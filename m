Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3FCK2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:28:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57395 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab3FCK2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:28:00 -0400
Date: Mon, 3 Jun 2013 11:27:23 +0100
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: A bug about system call on ARM
Message-ID: <20130603102723.GD32242@mudshark.cambridge.arm.com>
References: <CAFLxGvy39xWdZmtiVHP+y=zH1coCVmMuREcmD25wSb=w-VK7Xg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D1610991B85D@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
 <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
 <20130529094826.GD13095@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B866@CNBJMBX05.corpusers.net>
 <20130530090949.GC7483@mudshark.cambridge.arm.com>
 <20130530114112.GH7483@mudshark.cambridge.arm.com>
 <20130603101809.GK18614@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603101809.GK18614@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Mon, Jun 03, 2013 at 11:18:09AM +0100, Russell King - ARM Linux wrote:
> On Thu, May 30, 2013 at 12:41:12PM +0100, Will Deacon wrote:
> > +#if defined(CONFIG_OABI_COMPAT) || !defined(CONFIG_AEABI)
> > +	/*
> > +	 * We may have faulted trying to load the SWI instruction due to
> > +	 * concurrent page aging on another CPU. In this case, return
> > +	 * back to the swi instruction and fault the page back.
> > +	 */
> > +9001:
> > +	sub	lr, lr, #4
> > +	str	lr, [sp, #S_PC]
> > +	b	ret_fast_syscall
> > +#endif
> 
> The comment is wrong.  If we get here, it means that the fault from
> trying to loading the instruction can't be fixed up.  Arguably, that
> should result in a SIGSEGV being sent immediately, but we'll get to
> that when we then try to re-load the instruction.

Why would we kill the application in this case? The reported problem is
where one CPU ages the page containing the swi instruction (mkold =>
clears L_PTE_YOUNG => write 0 to the pte) in between the other CPU executing
the swi and the kernel trying to read the immediate. The VMA is fine.

> What it means is that the page we were trying to execute has been
> unmapped beneath us.

Yes, as a result of the kernel aging it.

> BTW, I notice that the kernel oops was never posted to the list, so it's
> impossible for other people following this thread to see what the real
> problem is...

It was sent as an attachment I think, so I've pasted the log below (you can
see CPU0 unmapping the page from which CPU1 is assumedly executing).

Will

--->8

<1>[44330.850628] Unable to handle kernel paging request at virtual address 4020841c
<1>[44330.850750] pgd = c490c000
<1>[44330.850841] [4020841c] *pgd=84451831, *pte=bf05859d, *ppte=00000000
<0>[44330.851055] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
<4>[44330.851146] Modules linked in: hid_sony(O)
<4>[44330.851330] CPU: 1    Tainted: G        W  O  (3.4.0-perf-gf496dca-01162-gcbcc62b #1)
<4>[44330.851421] PC is at vector_swi+0x28/0x88
<4>[44330.851482] LR is at 0x40208420
<4>[44330.851604] pc : [<c000dfe8>]    lr : [<40208420>]    psr: 60000093
<4>[44330.851604] sp : e0601fb0  ip : 40092f78  fp : befcd6fc
<4>[44330.851757] r10: 4005a040  r9 : 4012fa70  r8 : 60000010
<4>[44330.851818] r7 : 00000107  r6 : 00000003  r5 : 4005a030  r4 : 5746d378
<4>[44330.851909] r3 : 5883fbf8  r2 : 00000000  r1 : befcd6d0  r0 : 00000001
<4>[44330.851971] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
<4>[44330.852093] Control: 10c5787d  Table: 84b0c06a  DAC: 00000015
<4>[44330.852154] 
<4>[44330.852154] PC: 0xc000df68:
<4>[44330.852306] df68  e31100ff 1afffff0 e59d1040 e5bde03c e16ff001 f57ff01f e95d7fff e1a00000
<4>[44330.852825] df88  e28dd00c e1b0f00e eb025aba e1a096ad e1a09689 e5991000 e3a08001 e3110c03
<4>[44330.853405] dfa8  0affffec e1a0100d e3a00001 eb000911 eaffffe8 e320f000 e24dd048 e88d1fff
<4>[44330.853954] dfc8  e28d803c e9486000 e14f8000 e58de03c e58d8040 e58d0044 e3180020 13a0a000
<4>[44330.854534] dfe8  051ea004 e59fc0ac e59cc000 ee01cf10 f1080080 e1a096ad e1a09689 e28f809c
<4>[44330.855053] e008  e3daa4ff 122a7609 159f808c e599a000 e92d0030 e31a0c03 1a000008 e3570f5f
<4>[44330.855602] e028  e24fee13 3798f107 e28d1008 e3a08000 e357080f e2270000 2a000fac ea022fd4
<4>[44330.856152] e048  e1a02007 e28d1008 e3a00000 eb0008e9 e28fe014 e1a07000 e28d1008 e3570f5f
<4>[44330.856732] 
<4>[44330.856732] SP: 0xe0601f30:
<4>[44330.856823] 1f30  00000000 00000000 c0d44f98 00000001 e18fce48 00000002 e565fa80 00000000
<4>[44330.857373] 1f50  c000dfe8 60000093 ffffffff e0601f9c 60000010 c0731518 00000001 befcd6d0
<4>[44330.857891] 1f70  00000000 5883fbf8 5746d378 4005a030 00000003 00000107 60000010 4012fa70
<4>[44330.858471] 1f90  4005a040 befcd6fc 40092f78 e0601fb0 40208420 c000dfe8 60000093 ffffffff
<4>[44330.859021] 1fb0  00000001 befcd6d0 00000000 5883fbf8 5746d378 4005a030 00000003 00000107
<4>[44330.859570] 1fd0  befcd6e8 4012fa70 4005a040 befcd6fc 40092f78 befcd6c8 4008aef9 40208420
<4>[44330.860089] 1ff0  60000010 00000001 ffe6e6e6 ffe6e6e6 00000000 00000000 00000000 00000000
<4>[44330.860669] 2010  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
<0>[44330.861218] Process ndroid.settings (pid: 25518, stack limit = 0xe06002f0)
<0>[44330.861279] Stack: (0xe0601fb0 to 0xe0602000)
<0>[44330.861401] 1fa0:                                     00000001 befcd6d0 00000000 5883fbf8
<0>[44330.861462] 1fc0: 5746d378 4005a030 00000003 00000107 befcd6e8 4012fa70 4005a040 befcd6fc
<0>[44330.861584] 1fe0: 40092f78 befcd6c8 4008aef9 40208420 60000010 00000001 ffe6e6e6 ffe6e6e6
<0>[44330.861707] Code: e58d8040 e58d0044 e3180020 13a0a000 (051ea004) 
<4>[44330.861890] ---[ end trace da227214a82491c0 ]---
<0>[44330.862012] Kernel panic - not syncing: Fatal exception
<2>[44330.862073] CPU0: stopping
<4>[44330.862195] [<c0014df8>] (unwind_backtrace+0x0/0x11c) from [<c001339c>] (handle_IPI+0x110/0x224)
<4>[44330.862256] [<c001339c>] (handle_IPI+0x110/0x224) from [<c000868c>] (gic_handle_irq+0x104/0x110)
<4>[44330.862378] [<c000868c>] (gic_handle_irq+0x104/0x110) from [<c0731580>] (__irq_svc+0x40/0x70)
<4>[44330.862470] Exception stack(0xc7439b10 to 0xc7439b58)
<4>[44330.862531] 9b00:                                     00000001 bf05f000 00000004 1a55b000
<4>[44330.862653] 9b20: bf05f59d d2b4ac08 000bf05f ca5ca03c 00000000 c7439c24 4020f000 00000001
<4>[44330.862744] 9b40: c0f2ab50 c7439b58 c0123038 c0123040 00000113 ffffffff
<4>[44330.862836] [<c0731580>] (__irq_svc+0x40/0x70) from [<c0123040>] (memblock_is_memory+0x18/0x20)
<4>[44330.862958] [<c0123040>] (memblock_is_memory+0x18/0x20) from [<c00198b4>] (__sync_icache_dcache+0x40/0x9c)
<4>[44330.863049] [<c00198b4>] (__sync_icache_dcache+0x40/0x9c) from [<c0121a44>] (ptep_clear_flush_young+0x3c/0x60)
<4>[44330.863171] [<c0121a44>] (ptep_clear_flush_young+0x3c/0x60) from [<c011d3b0>] (page_referenced_one+0x6c/0xfc)
<4>[44330.863294] [<c011d3b0>] (page_referenced_one+0x6c/0xfc) from [<c011e9e4>] (page_referenced+0x1a8/0x200)
<4>[44330.863416] [<c011e9e4>] (page_referenced+0x1a8/0x200) from [<c010522c>] (shrink_active_list.isra.49+0x1ec/0x2e8)
<4>[44330.863477] [<c010522c>] (shrink_active_list.isra.49+0x1ec/0x2e8) from [<c0106554>] (shrink_mem_cgroup_zone+0x338/0x4c4)
<4>[44330.863599] [<c0106554>] (shrink_mem_cgroup_zone+0x338/0x4c4) from [<c010740c>] (try_to_free_pages+0x2a0/0x570)
<4>[44330.863690] [<c010740c>] (try_to_free_pages+0x2a0/0x570) from [<c00fbff0>] (__alloc_pages_nodemask+0x424/0x758)
<4>[44330.863812] [<c00fbff0>] (__alloc_pages_nodemask+0x424/0x758) from [<c0116dcc>] (handle_pte_fault+0x184/0x7c8)
<4>[44330.863934] [<c0116dcc>] (handle_pte_fault+0x184/0x7c8) from [<c011751c>] (handle_mm_fault+0x10c/0x128)
<4>[44330.864057] [<c011751c>] (handle_mm_fault+0x10c/0x128) from [<c0732cc0>] (do_page_fault+0x180/0x3c0)
<4>[44330.864148] [<c0732cc0>] (do_page_fault+0x180/0x3c0) from [<c000847c>] (do_DataAbort+0x134/0x1a8)
<4>[44330.864270] [<c000847c>] (do_DataAbort+0x134/0x1a8) from [<c07316f4>] (__dabt_usr+0x34/0x40)
<4>[44330.864331] Exception stack(0xc7439fb0 to 0xc7439ff8)
<4>[44330.864453] 9fa0:                                     40baa000 40fab040 0002d440 00000000
<4>[44330.864545] 9fc0: 41ed0f10 00000001 408d72c0 41ed0f2c 0000001c 00000000 40fab400 00000001
<4>[44330.864606] 9fe0: 00000380 59c70e10 00000400 40209364 20000010 ffffffff


