Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaLCNFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:05:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaLCNFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:05:54 -0500
Date: Wed, 3 Dec 2014 11:04:54 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: akpm@linux-foundation.org, Dmitry Vyukov <dvyukov@google.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadia.Derbey@bull.net, davidlohr@hp.com, Joe Perches <joe@perches.com>,
        manfred@colorfullife.com, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH] kernel: sysctl: use 'unsigned long' type for 'zero'
 variable
Message-ID: <20141203130352.GA1742@x61.redhat.com>
References: <547F0486.7020400@samsung.com>
 <1417610481-11590-1-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417610481-11590-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 03:41:21PM +0300, Andrey Ryabinin wrote:
> 
> Commit ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity") replaced
> 'unsigned long hugetlb_zero' with 'int zero' leading to out-of-bounds access
> in proc_doulongvec_minmax():
> 
> 	==================================================================
> 	BUG: AddressSanitizer: out of bounds access in
> 	__do_proc_doulongvec_minmax+0x8a0/0x9a0 at addr ffffffff83980960
> 	Read of size 8 by task trinity-c14/6919
> 	Out-of-bounds access to the global variable 'zero'
> 	[ffffffff83980960-ffffffff83980964) defined at ipc/ipc_sysctl.c:158
> 
> 	CPU: 1 PID: 6919 Comm: trinity-c14 Not tainted 3.18.0-rc1+ #50
> 	Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
> 	 0000000000000001 ffff8800b68cf418 ffffffff82c2d3ae 0000000000000000
> 	 ffff8800b68cf4c0 ffff8800b68cf4a8 ffffffff813eaa81 ffffffff0000000c
> 	 ffff88010b003600 ffff8800b68cf479 0000000000000296 0000000000000000
> 	Call Trace:
> 	 [<ffffffff813ead71>] __asan_report_load8_noabort+0x51/0x70
> 	mm/kasan/report.c:248
> 	 [<ffffffff810cc3e0>] __do_proc_doulongvec_minmax+0x8a0/0x9a0
> 	kernel/sysctl.c:2284
> 	 [<     inlined    >] proc_doulongvec_minmax+0x50/0x80
> 	do_proc_doulongvec_minmax kernel/sysctl.c:2322
> 	 [<ffffffff810cc530>] proc_doulongvec_minmax+0x50/0x80 kernel/sysctl.c:2345
> 	 [<ffffffff813c9e5a>] hugetlb_sysctl_handler_common+0x12a/0x3c0
> 	mm/hugetlb.c:2270
> 	 [<ffffffff813cb45c>] hugetlb_mempolicy_sysctl_handler+0x1c/0x20
> 	mm/hugetlb.c:2293
> 	 [<ffffffff8153e6e9>] proc_sys_call_handler+0x179/0x1f0
> 	fs/proc/proc_sysctl.c:506
> 	 [<ffffffff8153e76f>] proc_sys_write+0xf/0x20 fs/proc/proc_sysctl.c:524
> 	 [<ffffffff813f1563>] __kernel_write+0x123/0x440 fs/read_write.c:502
> 	 [<ffffffff8147ebaa>] write_pipe_buf+0x14a/0x1d0 fs/splice.c:1074
> 	 [<     inlined    >] __splice_from_pipe+0x22e/0x6f0
> 	splice_from_pipe_feed fs/splice.c:769
> 	 [<ffffffff8147dbde>] __splice_from_pipe+0x22e/0x6f0 fs/splice.c:886
> 	 [<ffffffff81483211>] splice_from_pipe+0xc1/0x110 fs/splice.c:921
> 	 [<ffffffff81483298>] default_file_splice_write+0x18/0x50 fs/splice.c:1086
> 	 [<     inlined    >] direct_splice_actor+0x104/0x1c0 do_splice_from
> 	fs/splice.c:1128
> 	 [<ffffffff8147cfc4>] direct_splice_actor+0x104/0x1c0 fs/splice.c:1284
> 	 [<ffffffff8147e5ba>] splice_direct_to_actor+0x24a/0x6f0 fs/splice.c:1237
> 	 [<ffffffff81483424>] do_splice_direct+0x154/0x270 fs/splice.c:1327
> 	 [<ffffffff813f3bfb>] do_sendfile+0x5fb/0x1260 fs/read_write.c:1266
> 	 [<     inlined    >] SyS_sendfile64+0xfa/0x100 SYSC_sendfile64
> 	fs/read_write.c:1327
> 	 [<ffffffff813f6bea>] SyS_sendfile64+0xfa/0x100 fs/read_write.c:1313
> 	 [<ffffffff82c464f9>] ia32_do_call+0x13/0x13 arch/x86/ia32/ia32entry.S:444
> 	Memory state around the buggy address:
> 	 ffffffff83980680: 04 f8 f8 f8 f8 f8 f8 f8 02 f8 f8 f8 f8 f8 f8 f8
> 	 ffffffff83980700: 00 f8 f8 f8 f8 f8 f8 f8 00 f8 f8 f8 f8 f8 f8 f8
> 	 ffffffff83980780: 00 00 00 00 00 00 00 00 f8 f8 f8 f8 00 00 00 00
> 	 ffffffff83980800: 00 00 00 00 00 00 00 00 f8 f8 f8 f8 04 f8 f8 f8
> 	 ffffffff83980880: f8 f8 f8 f8 04 f8 f8 f8 f8 f8 f8 f8 04 f8 f8 f8
> 	>ffffffff83980900: f8 f8 f8 f8 04 f8 f8 f8 f8 f8 f8 f8 04 f8 f8 f8
> 	                                                       ^
> 	 ffffffff83980980: f8 f8 f8 f8 00 00 00 00 f8 f8 f8 f8 00 00 00 00
> 	 ffffffff83980a00: 02 f8 f8 f8 f8 f8 f8 f8 00 00 00 00 00 00 00 00
> 	 ffffffff83980a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 	 ffffffff83980b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 	 ffffffff83980b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 	==================================================================
> 
> Use the 'unsigned long' type for 'zero' variable to fix this.
> Changing type to 'unsigned long' shouldn't affect any other users
> of this variable.
> 
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  kernel/sysctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 15f2511..45c45c9 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -120,7 +120,7 @@ static int sixty = 60;
>  
>  static int __maybe_unused neg_one = -1;
>  
> -static int zero;
> +static unsigned long zero;
>  static int __maybe_unused one = 1;
>  static int __maybe_unused two = 2;
>  static int __maybe_unused four = 4;
> -- 
> 2.2.0
> 
Acked-by: Rafael Aquini <aquini@redhat.com>
