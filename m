Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485Ab3DGNd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 09:33:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48018 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760846Ab3DGNdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 09:33:55 -0400
Date: Sun, 7 Apr 2013 15:33:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, hpa@linux.intel.com,
        penguin-kernel@i-love.sakura.ne.jp, x86@kernel.org,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        khlebnikov@openvz.org, bhelgaas@google.com
Subject: Re: [PATCH] do not try to sync identity map for non-mapped pages
Message-ID: <20130407133346.GD31299@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
	hpa@linux.intel.com, penguin-kernel@i-love.sakura.ne.jp,
	x86@kernel.org, akpm@linux-foundation.org,
	suresh.b.siddha@intel.com, khlebnikov@openvz.org,
	bhelgaas@google.com
References: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130307163151.D9B58C4E@kernel.stglabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Dave,

On Thu, Mar 07, 2013 at 08:31:51AM -0800, Dave Hansen wrote:
> 
> The original bug reporter says this fixes it for him, so I'm
> broadening the cc list a bit.  I assume this should just get
> sucked in to the x86 tree.

looks like we haven't whacked all the moles - I keep seeing this when
testing 32-bit builds in qemu on latest Linus + tip. I'd guess this is
still that /dev/mem accessing thing called wdm.

I'm still wondering though whether we should BUG_ON on a /dev/mem
access?

I've added debug output to show why we're triggering:

[  471.102902] slow_virt_to_phys((void *)x): 0x0, phys_addr: 0x37bfe000
[  471.119500] ------------[ cut here ]------------
[  471.119500] kernel BUG at arch/x86/mm/physaddr.c:85!
[  471.119500] invalid opcode: 0000 [#1] PREEMPT SMP 
[  471.119500] Modules linked in:
[  471.119500] Pid: 1571, comm: wdm Not tainted 3.9.0-rc5+ #42 Bochs Bochs
[  471.119500] EIP: 0060:[<c1032f56>] EFLAGS: 00000206 CPU: 0
[  471.119500] EIP is at __phys_addr+0x86/0xb0
[  471.119500] EAX: 37bfe000 EBX: 37bfe000 ECX: 00000001 EDX: 37bfe000
[  471.119500] ESI: f7bfe000 EDI: 00002000 EBP: f67f1f3c ESP: f67f1f28
[  471.119500]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  471.119500] CR0: 8005003b CR2: bfeb12d4 CR3: 35edd000 CR4: 000006f0
[  471.119500] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  471.119500] DR6: 00000000 DR7: 00000000
[  471.119500] Process wdm (pid: 1571, ti=f67f0000 task=f5c90000 task.ti=f67f0000)
[  471.119500] Stack:
[  471.119500]  c16b1f2c 00000000 37bfe000 00000000 00002000 f67f1f64 c131d074 00002000
[  471.119500]  00000246 bfeb12ec 00000000 00000000 f67a6c40 c131d040 00002000 f67f1f8c
[  471.119500]  c1129c85 f67f1f98 f67f0000 f5ebe864 c131d040 00000020 f67a6c40 00000000
[  471.119500] Call Trace:
[  471.119500]  [<c131d074>] read_mem+0x34/0x100
[  471.119500]  [<c131d040>] ? write_mem+0x110/0x110
[  471.119500]  [<c1129c85>] vfs_read+0x85/0x130
[  471.119500]  [<c131d040>] ? write_mem+0x110/0x110
[  471.119500]  [<c1129e87>] sys_read+0x47/0xa0
[  471.119500]  [<c1546e5e>] sysenter_do_call+0x12/0x36
[  471.119500] Code: 0b a1 88 ae 0c c2 05 00 00 80 00 39 c6 72 bb a1 ac 1a 76 c1 2d 00 a0 3e 00 25 00 00 e0 ff 2d 00 20 00 00 39 c6 73 a3 0f 0b 0f 0b <0f> 0b 89 f0 e8 41 ca ff ff 89 5c 24 08 89 44 24 04 c7 04 24 2c
[  471.119500] EIP: [<c1032f56>] __phys_addr+0x86/0xb0 SS:ESP 0068:f67f1f28
[  471.508967] ---[ end trace 5fc00ac35d61284a ]---

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
