Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab3JGFLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 01:11:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:20306 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460Ab3JGFLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 01:11:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1047,1371106800"; 
   d="scan'208";a="406368173"
Date: Mon, 7 Oct 2013 13:10:38 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131007051038.GA9764@localhost>
References: <20131006082340.GA24568@localhost>
 <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
 <20131007021118.GA27927@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007021118.GA27927@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:11:18AM +0800, Fengguang Wu wrote:
> On Sun, Oct 06, 2013 at 10:26:24AM -0700, Linus Torvalds wrote:
> > On Sun, Oct 6, 2013 at 1:23 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > >
> > > I got the below dmesg and the first bad commit is commit cf39c8e5352b:
> > >     Merge tag 'stable/for-linus-3.12-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
> > 
> > Ugh. How reliable is the double fault? Because bisecting it to the
> > merge that didn't even have any conflicts in it as far as I can
> > remember means that there's something really subtle going on wrt some
> > semantic conflict or other. Or, alternatively, it means that the
> > bisect failed because the double fault isn't 100% reliable..
> 
> Oops, it's not a reliable bisect...
> 
> The "first" bad commit cf39c8e5352b4fb9efedfe7e9acb566a85ed847c runs
> and produces 25 good dmesgs and 3530 bad dmesgs, however only 1 of the
> bad boots has "double fault:" in its dmesg.
> 
> Looking into all the 3530 bad dmesgs, I find all kinds of bug messages:
> 
> $ grep_crash_head -h dmesg-* | sed 's/^[^a-zA-Z]*//' | sort | uniq -c | sort -nr
> 
>    3086 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>    3047 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>    3046 Kernel panic - not syncing: Fatal exception in interrupt

I retried bisect with "Oops:" and the first bad commit is

commit c817a67ecba7c3c2aaa104796d78f160af60920d
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Jun 27 15:06:14 2013 +0100

    kobject: delayed kobject release: help find buggy drivers

    Implement debugging for kobject release functions.  kobjects are
    reference counted, so the drop of the last reference to them is not
    predictable. However, the common case is for the last reference to be
    the kobject's removal from a subsystem, which results in the release
    function being immediately called.

    This can hide subtle bugs, which can occur when another thread holds a
    reference to the kobject at the same time that a kobject is removed.
    This results in the release method being delayed.

    In order to make these kinds of problems more visible, the following
    patch implements a delayed release; this has the effect that the
    release function will be out of order with respect to the removal of
    the kobject in the same manner that it would be if a reference was
    being held.

    This provides us with an easy way to allow driver writers to debug
    their drivers and fix otherwise hidden problems.

    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

That commit has already helped expose some bugs, however I suspect there are
still many hidden ones. In this particular bisect, the commit produces 85 good
dmesgs and 2055 bad dmesgs, exposing all sorts of error messages

   1929 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
   1921 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
   1897 Kernel panic - not syncing: Fatal exception in interrupt
     56 WARNING: CPU: 0 PID: 1 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
     28 kernel BUG at /c/wfg/mm/mm/slab.c:3011!
     27 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     19 Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
     16 INFO: lockdep is turned off.
     13 general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     13 BUG: unable to handle kernel 
      8 BUG: sleeping function called from invalid context at /c/wfg/mm/kernel/rwsem.c:20
      6 WARNING: CPU: 0 PID: 0 at /c/wfg/mm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      6 WARNING: CPU: 0 PID: 0 at /c/wfg/mm/kernel/workqueue.c:457 work_fixup_activate+0x6a/0x6f()
      6 WARNING: CPU: 0 PID: 0 at /c/wfg/mm/kernel/workqueue.c:1378 __queue_work+0x1a1/0x1ee()
      5 WARNING: CPU: 1 PID: 0 at /c/wfg/mm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      5 WARNING: CPU: 1 PID: 0 at /c/wfg/mm/kernel/workqueue.c:457 work_fixup_activate+0x6a/0x6f()
      5 WARNING: CPU: 1 PID: 0 at /c/wfg/mm/kernel/workqueue.c:1378 __queue_work+0x1a1/0x1ee()
      5 Oops: 0002 [#1] 
      4 WARNING: CPU: 1 PID: 0 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      4 Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      4 BUG: unable to handle kernel NULL pointer dereference
      3 Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      3 BUG: kernel boot crashed
      2 WARNING: CPU: 1 PID: 1 at /c/wfg/mm/kernel/workqueue.c:590 set_work_data+0x33/0x50()
      2 BUG: unable to handle kernel paging request at ffffffffffffffa8
      2 BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
      2 BUG: unable to handle kernel NULL pointer dereference at 0000000000000017
      2 BUG: scheduling while atomic: rc.local/135/0x10000002

In comparison, its parent commit 7c42721fe0 ("char: tile-srom: fix
build error") boots fine 10001 times w/o a single error. It also goes
quiet if reverting the commit on top of upstream kernel.

Thanks,
Fengguang
