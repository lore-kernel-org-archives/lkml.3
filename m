Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaLCMjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:39:43 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59147 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaLCMjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:39:41 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-9d-547f048a0527
Message-id: <547F0486.7020400@samsung.com>
Date: Wed, 03 Dec 2014 15:39:34 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nadia.Derbey@bull.net,
        aquini@redhat.com, davidlohr@hp.com, Joe Perches <joe@perches.com>,
        manfred@colorfullife.com, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: Out-of-bounds access in __do_proc_doulongvec_minmax
References: <CACT4Y+aUYGCsqGWWJEG2KHXc_Heq6k1=yPuA+7qrRbB+jsRC6A@mail.gmail.com>
In-reply-to: <CACT4Y+aUYGCsqGWWJEG2KHXc_Heq6k1=yPuA+7qrRbB+jsRC6A@mail.gmail.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t/xq7pdLPUhBluOG1rMWb+GzaJn904m
	ixkPf7FYrFh6jcViyX1hi+cPH7JbTHjYxm4x+/5joPiz+0wW25+9ZbK4+XwOi8XKzgesFv2P
	v7NbXN41h81i3/0prBYf1p5isTjRt5bJom3JRiYHIY8XC7cwe0x8OpPV4+X2DWweO2fdZfdY
	sKnUY8/Ek2weu7btZPI4MeM3i8e8k4Eekw5/ZvL4suoas8f7fVfZPD5vkgvgjeKySUnNySxL
	LdK3S+DK2LvBv2ChZsWKQ7eYGhifKHYxcnBICJhINK/i6GLkBDLFJC7cW8/WxcjFISSwlFFi
	9dolzBBOM5PEyv9XmUCqeAW0JF62zGUBsVkEVCW2HHwFFmcT0JP4N2s7G4gtKhAhcWXNHEaI
	ekGJH5PvgdWLCKhJNL7uAdvALPCaReLgil1gzcICDhLbprWCNQsJBEi827YazOYUCJbY+O4h
	E8ilzALqElOm5IKEmQXkJTavecs8gVFgFpIVsxCqZiGpWsDIvIpRNLU0uaA4KT3XSK84Mbe4
	NC9dLzk/dxMjJDK/7mBceszqEKMAB6MSD6/Du5oQIdbEsuLK3EOMEhzMSiK8z77VhQjxpiRW
	VqUW5ccXleakFh9iZOLglGpgnOWsvfYRO49Nx/WqDTEcrBZH0hdxnt7adnDePQb7JrYLXiqP
	issLlQ8c2iy7UG3OntmXVxgY/7zUtY7toKFV7b85j+U+dnYcc7r46dlevwuHH8YkNnWtqZuf
	7m/B0azhuvh6Yezk81fCj9w/FOvfoPVr89STX8/o/7Wcb2IsO7H6m+Q5dx0hTiWW4oxEQy3m
	ouJEAFIgpJCqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 12:04 PM, Dmitry Vyukov wrote:
> Hi,
> 
> I am working on AddressSanitizer, a fast memory error detector for kernel:
> https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel
> 
> Here is a bug report that I've got while running trinity:
> 
> ==================================================================
> BUG: AddressSanitizer: out of bounds access in
> __do_proc_doulongvec_minmax+0x8a0/0x9a0 at addr ffffffff83980960
> Read of size 8 by task trinity-c14/6919
> Out-of-bounds access to the global variable 'zero'
> [ffffffff83980960-ffffffff83980964) defined at ipc/ipc_sysctl.c:158

This line seems incorrect. Judging from the backtrace below variable 'zero' is
defined in kernel/sysctl.c:123


> 
> CPU: 1 PID: 6919 Comm: trinity-c14 Not tainted 3.18.0-rc1+ #50
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>  0000000000000001 ffff8800b68cf418 ffffffff82c2d3ae 0000000000000000
>  ffff8800b68cf4c0 ffff8800b68cf4a8 ffffffff813eaa81 ffffffff0000000c
>  ffff88010b003600 ffff8800b68cf479 0000000000000296 0000000000000000
> Call Trace:
>  [<ffffffff813ead71>] __asan_report_load8_noabort+0x51/0x70
> mm/kasan/report.c:248
>  [<ffffffff810cc3e0>] __do_proc_doulongvec_minmax+0x8a0/0x9a0
> kernel/sysctl.c:2284
>  [<     inlined    >] proc_doulongvec_minmax+0x50/0x80
> do_proc_doulongvec_minmax kernel/sysctl.c:2322
>  [<ffffffff810cc530>] proc_doulongvec_minmax+0x50/0x80 kernel/sysctl.c:2345
>  [<ffffffff813c9e5a>] hugetlb_sysctl_handler_common+0x12a/0x3c0
> mm/hugetlb.c:2270
>  [<ffffffff813cb45c>] hugetlb_mempolicy_sysctl_handler+0x1c/0x20
> mm/hugetlb.c:2293
>  [<ffffffff8153e6e9>] proc_sys_call_handler+0x179/0x1f0
> fs/proc/proc_sysctl.c:506
>  [<ffffffff8153e76f>] proc_sys_write+0xf/0x20 fs/proc/proc_sysctl.c:524
>  [<ffffffff813f1563>] __kernel_write+0x123/0x440 fs/read_write.c:502
>  [<ffffffff8147ebaa>] write_pipe_buf+0x14a/0x1d0 fs/splice.c:1074
>  [<     inlined    >] __splice_from_pipe+0x22e/0x6f0
> splice_from_pipe_feed fs/splice.c:769
>  [<ffffffff8147dbde>] __splice_from_pipe+0x22e/0x6f0 fs/splice.c:886
>  [<ffffffff81483211>] splice_from_pipe+0xc1/0x110 fs/splice.c:921
>  [<ffffffff81483298>] default_file_splice_write+0x18/0x50 fs/splice.c:1086
>  [<     inlined    >] direct_splice_actor+0x104/0x1c0 do_splice_from
> fs/splice.c:1128
>  [<ffffffff8147cfc4>] direct_splice_actor+0x104/0x1c0 fs/splice.c:1284
>  [<ffffffff8147e5ba>] splice_direct_to_actor+0x24a/0x6f0 fs/splice.c:1237
>  [<ffffffff81483424>] do_splice_direct+0x154/0x270 fs/splice.c:1327
>  [<ffffffff813f3bfb>] do_sendfile+0x5fb/0x1260 fs/read_write.c:1266
>  [<     inlined    >] SyS_sendfile64+0xfa/0x100 SYSC_sendfile64
> fs/read_write.c:1327
>  [<ffffffff813f6bea>] SyS_sendfile64+0xfa/0x100 fs/read_write.c:1313
>  [<ffffffff82c464f9>] ia32_do_call+0x13/0x13 arch/x86/ia32/ia32entry.S:444
> Memory state around the buggy address:
>  ffffffff83980680: 04 f8 f8 f8 f8 f8 f8 f8 02 f8 f8 f8 f8 f8 f8 f8
>  ffffffff83980700: 00 f8 f8 f8 f8 f8 f8 f8 00 f8 f8 f8 f8 f8 f8 f8
>  ffffffff83980780: 00 00 00 00 00 00 00 00 f8 f8 f8 f8 00 00 00 00
>  ffffffff83980800: 00 00 00 00 00 00 00 00 f8 f8 f8 f8 04 f8 f8 f8
>  ffffffff83980880: f8 f8 f8 f8 04 f8 f8 f8 f8 f8 f8 f8 04 f8 f8 f8
>> ffffffff83980900: f8 f8 f8 f8 04 f8 f8 f8 f8 f8 f8 f8 04 f8 f8 f8
>                                                        ^
>  ffffffff83980980: f8 f8 f8 f8 00 00 00 00 f8 f8 f8 f8 00 00 00 00
>  ffffffff83980a00: 02 f8 f8 f8 f8 f8 f8 f8 00 00 00 00 00 00 00 00
>  ffffffff83980a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffffff83980b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffffffff83980b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ==================================================================
> 
> The core creates ctl_table as:
> 
> static int zero;
> static int one = 1;
> static int int_max = INT_MAX;
> static struct ctl_table ipc_kern_table[] = {
> {
> ...
>   {
>     .procname = "shm_rmid_forced",
>     .data = &init_ipc_ns.shm_rmid_forced,
>     .maxlen = sizeof(init_ipc_ns.shm_rmid_forced),
>     .mode = 0644,
>     .proc_handler = proc_ipc_dointvec_minmax_orphans,
>     .extra1 = &zero,
>     .extra2 = &one,
>   },
> 
> But later extra1/2 are casted to *unsigned long**:
> 
> static int __do_proc_doulongvec_minmax(void *data, struct ctl_table
> *table, int write, ...
> {
>   ...
>   min = (unsigned long *) table->extra1;
>   max = (unsigned long *) table->extra2;
> 
> This leads to bogus bounds check for the sysctl value.
> 
> The bug is added in commit:
> 
> commit 9eefe520c814f6f62c5d36a2ddcd3fb99dfdb30e
> Author: Nadia Derbey <Nadia.Derbey@bull.net>
> Date:   Fri Jul 25 01:48:08 2008 -0700
> 
> Later zero and one were used in a bunch of other ctl_table's.
> 

I think you are blaming wrong commit. This bug was introduced by
ed4d4902ebdd7ca8b5a51daaf6bebf4b172895cc ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")

We have two options to fix this. Reintroduce back hugetlb_zero or make 'zero' unsigned long instead.
I would prefer the latter, changing type to 'unsigned long' shouldn't harm any other users of this variable.

