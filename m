Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbaKSSu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:50:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbaKSSuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:50:25 -0500
Date: Wed, 19 Nov 2014 19:49:38 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: zhanghailiang <zhang.zhanghailiang@huawei.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Christopher Covington <cov@codeaurora.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH 00/17] RFC: userfault v2
Message-ID: <20141119184938.GE803@redhat.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com>
 <20141029174607.GK19606@redhat.com>
 <545221A4.9030606@huawei.com>
 <20141030124950.GJ2376@work-vm>
 <5452E531.4070205@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5452E531.4070205@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhang,

On Fri, Oct 31, 2014 at 09:26:09AM +0800, zhanghailiang wrote:
> On 2014/10/30 20:49, Dr. David Alan Gilbert wrote:
> > * zhanghailiang (zhang.zhanghailiang@huawei.com) wrote:
> >> On 2014/10/30 1:46, Andrea Arcangeli wrote:
> >>> Hi Zhanghailiang,
> >>>
> >>> On Mon, Oct 27, 2014 at 05:32:51PM +0800, zhanghailiang wrote:
> >>>> Hi Andrea,
> >>>>
> >>>> Thanks for your hard work on userfault;)
> >>>>
> >>>> This is really a useful API.
> >>>>
> >>>> I want to confirm a question:
> >>>> Can we support distinguishing between writing and reading memory for userfault?
> >>>> That is, we can decide whether writing a page, reading a page or both trigger userfault.
> >>>>
> >>>> I think this will help supporting vhost-scsi,ivshmem for migration,
> >>>> we can trace dirty page in userspace.
> >>>>
> >>>> Actually, i'm trying to relize live memory snapshot based on pre-copy and userfault,
> >>>> but reading memory from migration thread will also trigger userfault.
> >>>> It will be easy to implement live memory snapshot, if we support configuring
> >>>> userfault for writing memory only.
> >>>
> >>> Mail is going to be long enough already so I'll just assume tracking
> >>> dirty memory in userland (instead of doing it in kernel) is worthy
> >>> feature to have here.
> >>>
> >>> After some chat during the KVMForum I've been already thinking it
> >>> could be beneficial for some usage to give userland the information
> >>> about the fault being read or write, combined with the ability of
> >>> mapping pages wrprotected to mcopy_atomic (that would work without
> >>> false positives only with MADV_DONTFORK also set, but it's already set
> >>> in qemu). That will require "vma->vm_flags & VM_USERFAULT" to be
> >>> checked also in the wrprotect faults, not just in the not present
> >>> faults, but it's not a massive change. Returning the read/write
> >>> information is also a not massive change. This will then payoff mostly
> >>> if there's also a way to remove the memory atomically (kind of
> >>> remap_anon_pages).
> >>>
> >>> Would that be enough? I mean are you still ok if non present read
> >>> fault traps too (you'd be notified it's a read) and you get
> >>> notification for both wrprotect and non present faults?
> >>>
> >> Hi Andrea,
> >>
> >> Thanks for your reply, and your patience;)
> >>
> >> Er, maybe i didn't describe clearly. What i really need for live memory snapshot
> >> is only wrprotect fault, like kvm's dirty tracing mechanism, *only tracing write action*.
> >>
> >> My initial solution scheme for live memory snapshot is:
> >> (1) pause VM
> >> (2) using userfaultfd to mark all memory of VM is wrprotect (readonly)
> >> (3) save deivce state to snapshot file
> >> (4) resume VM
> >> (5) snapshot thread begin to save page of memory to snapshot file
> >> (6) VM is going to run, and it is OK for VM or other thread to read ram (no fault trap),
> >>      but if VM try to write page (dirty the page), there will be
> >>      a userfault trap notification.
> >> (7) a fault-handle-thread reads the page request from userfaultfd,
> >>      it will copy content of the page to some buffers, and then remove the page's
> >>      wrprotect limit(still using the userfaultfd to tell kernel).
> >> (8) after step (7), VM can continue to write the page which is now can be write.
> >> (9) snapshot thread save the page cached in step (7)
> >> (10) repeat step (5)~(9) until all VM's memory is saved to snapshot file.
> >
> > Hmm, I can see the same process being useful for the fault-tolerance schemes
> > like COLO, it needs a memory state snapshot.
> >
> >> So, what i need for userfault is supporting only wrprotect fault. i don't
> >> want to get notification for non present reading faults, it will influence
> >> VM's performance and the efficiency of doing snapshot.
> >
> > What pages would be non-present at this point - just balloon?
> >
> 
> Er, sorry, it should be 'no-present page faults';)

Could you elaborate? The balloon pages or not yet allocated pages in
the guest, if they fault too (in addition to the wrprotect faults) it
doesn't sound a big deal, as it's not so common (balloon especially
shouldn't happen except during balloon deflating during the live
snapshotting). We could bypass non-present faults though, and only
track strict wrprotect faults.
