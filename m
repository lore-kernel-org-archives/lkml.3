Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaAWRDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:03:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbaAWRDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:03:43 -0500
Date: Thu, 23 Jan 2014 17:03:37 +0000
From: Mel Gorman <mgorman@suse.de>
To: Steven Noonan <steven@uplinklabs.net>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
Message-ID: <20140123170337.GM4963@suse.de>
References: <20140121232708.GA29787@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140121232708.GA29787@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:27:08PM -0800, Steven Noonan wrote:
> A user reported a problem starting vsftpd on a Xen paravirtualized
> guest, with this in dmesg:
> 
> [   60.654862] BUG: Bad page map in process vsftpd  pte:8000000493b88165 pmd:e9cc01067
> [   60.654876] page:ffffea00124ee200 count:0 mapcount:-1 mapping:     (null) index:0x0
> [   60.654879] page flags: 0x2ffc0000000014(referenced|dirty)
> [   60.654885] addr:00007f97eea74000 vm_flags:00100071 anon_vma:ffff880e98f80380 mapping:          (null) index:7f97eea74
> [   60.654890] CPU: 4 PID: 587 Comm: vsftpd Not tainted 3.12.7-1-ec2 #1
> [   60.654893]  ffff880e9cc6ec38 ffff880e9cc61ca0 ffffffff814c763b 00007f97eea74000
> [   60.654900]  ffff880e9cc61ce8 ffffffff8116784e 0000000000000000 0000000000000000
> [   60.654906]  ffff880e9cc013a0 ffffea00124ee200 00007f97eea75000 ffff880e9cc61e10
> [   60.654912] Call Trace:
> [   60.654921]  [<ffffffff814c763b>] dump_stack+0x45/0x56
> [   60.654928]  [<ffffffff8116784e>] print_bad_pte+0x22e/0x250
> [   60.654933]  [<ffffffff81169073>] unmap_single_vma+0x583/0x890
> [   60.654938]  [<ffffffff8116a405>] unmap_vmas+0x65/0x90
> [   60.654942]  [<ffffffff81173795>] exit_mmap+0xc5/0x170
> [   60.654948]  [<ffffffff8105d295>] mmput+0x65/0x100
> [   60.654952]  [<ffffffff81062983>] do_exit+0x393/0x9e0
> [   60.654955]  [<ffffffff810630dc>] do_group_exit+0xcc/0x140
> [   60.654959]  [<ffffffff81063164>] SyS_exit_group+0x14/0x20
> [   60.654965]  [<ffffffff814d602d>] system_call_fastpath+0x1a/0x1f
> [   60.654968] Disabling lock debugging due to kernel taint
> [   60.655191] BUG: Bad rss-counter state mm:ffff880e9ca60580 idx:0 val:-1
> [   60.655196] BUG: Bad rss-counter state mm:ffff880e9ca60580 idx:1 val:1
> 
> 
> The issue could not be reproduced under an HVM instance with the same
> kernel, so it appears to be exclusive to paravirtual Xen guests.
> 
> I noted that it wasn't present in 3.10.27, but was present in 3.12.7 and
> 3.12.8. I ran through a bisection to find the root cause:
> 
>  # start: 'v3.12.7' 'v3.10.27'
>  # bad:  [4301b7a8] Linux 3.12.7
>  # good: [1071ea6e] Linux 3.10.27
>  # good: [8bb495e3] Linux 3.10
>  # good: [8fe73691] staging: comedi: comedi_bond: change return value
>  # good: [22e04f6b] Merge branch 'for-linus' of git://git.kernel.org/p
>  # good: [b7c09ad4] Merge branch 'for-linus' of git://git.kernel.org/p
>  # good: [13caa8ed] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
>  # good: [13caa8ed] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
>  # good: [f5fa9283] ipv6: reset dst.expires value when clearing expire
>  # good: [4af9d888] bridge: flush br's address entry in fdb when remov
>  # good: [8c13daf6] dm delay: fix a possible deadlock due to shared wo
>  # good: [93c02d70] firewire: sbp2: bring back WRITE SAME support
>  # good: [18065245] ACPI / PCI / hotplug: Avoid warning when _ADR not
>  # bad:  [8807a436] mm/memory-failure.c: transfer page count from head
>  # bad:  [fd5df800] mm: numa: avoid unnecessary disruption of NUMA hin
>  # good: [c18e3316] mm: numa: do not clear PMD during PTE update scan
>  # good: [f3b578d9] mm: numa: avoid unnecessary work on the failure pa
>  # bad:  [3d792d61] mm: numa: clear numa hinting information on mprote
>  # good: [cefeb279] sched: numa: skip inaccessible VMAs
>  # first bad:  [3d792d61] mm: numa: clear numa hinting information on mprote
> 
> If only I'd tested v3.12.0, that bisection would have been a lot shorter!
> 
> 
> It looks like this is the change implicated (introduced in v3.12.7):
> 
>     commit 3d792d616ba408ab55a54c1bb75a9367d997acfa
>     Author: Mel Gorman <mgorman@suse.de>
>     Date:   Tue Jan 7 14:00:44 2014 +0000
>     
>         mm: numa: clear numa hinting information on mprotect
>     
>         commit 1667918b6483b12a6496bf54151b827b8235d7b1 upstream.
>     
>         On a protection change it is no longer clear if the page should be still
>         accessible.  This patch clears the NUMA hinting fault bits on a
>         protection change.
>     
>         Signed-off-by: Mel Gorman <mgorman@suse.de>
>         Reviewed-by: Rik van Riel <riel@redhat.com>
>         Cc: Alex Thorlton <athorlton@sgi.com>
>         Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>         Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>         Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

Sorry for the long delay in responding. I've only managed to get as far as
this mail now and it's already my evening and I won't be able to work on
it now either. Based on the patch a possible explanation is that I called
the page table mknonnuma helpers on a non-numa PTE and there is now a
mixup between the _PAGE_PRESENT and _PAGE_PROTNONE bits. It feels like a
bad fit though and would not explain why it only affects Xen. A slightly
better fit would be if the page table helpers for numa hinting flags are
colliding badly with the paravirt interface somehow. A git grep for
_PAGE_PROTNONE on xen showed up nothing but _PAGE_PRESENT has special
meaning and that might be what I trashed.

-- 
Mel Gorman
SUSE Labs
