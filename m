Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688AbaJaTji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:39:38 -0400
Received: from mail-qg0-f73.google.com ([209.85.192.73]:52323 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451AbaJaTjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:39:36 -0400
Date: Fri, 31 Oct 2014 12:39:32 -0700
From: Peter Feiner <pfeiner@google.com>
To: zhanghailiang <zhang.zhanghailiang@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
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
Message-ID: <20141031193932.GE38315@google.com>
References: <1412356087-16115-1-git-send-email-aarcange@redhat.com>
 <544E1143.1080905@huawei.com>
 <20141029174607.GK19606@redhat.com>
 <545221A4.9030606@huawei.com>
 <20141031022327.GA13275@google.com>
 <5453022D.4040801@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5453022D.4040801@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:29:49AM +0800, zhanghailiang wrote:
> Agreed, but for doing live memory snapshot (VM is running when do snapsphot),
> we have to do this (block the write action), because we have to save the page before it
> is dirtied by writing action. This is the difference, compared to pre-copy migration.

Ah ha, I understand the difference now. I suppose that you have considered
doing a traditional pre-copy migration (that is, passes over memory saving
dirty pages, followed by a pause and a final dump of remaining dirty pages) to
a file. Your approach has the advantage of having the VM pause time bounded by
the time it takes to handle the userfault and do the write, as opposed to
pre-copy migration which has a pause time bounded by the time it takes to do
the final dump of dirty pages, which, in the worst case, is the time it takes
to dump all of the guest memory!

You could use the old fork & dump trick. Given that the guest's memory is
backed by private VMA (as of a year ago when I last looked, is always the case
for QEMU), you can have the kernel do the write protection for you.
Essentially, you fork Qemu and, in the child process, dump the guest memory
then exit. If the parent (including the guest) writes to guest memory, then it
will fault and the kernel will copy the page. 

The fork & dump approach will give you the best performance w.r.t. guest pause
times (i.e., just pausing for the COW fault handler), but it does have the
distinct disadvantage of potentially using 2x the guest memory (i.e., if the
parent process races ahead and writes to all of the pages before you finish the
dump). To mitigate memory copying, you could madvise MADV_DONTNEED the child
memory as you copy it.

> Great! Do you plan to issue your patches to community? I mean is your work based on
> qemu? or an independent tool (CRIU migration?) for live-migration?
> Maybe i could fix the migration problem for ivshmem in qemu now,
> based on softdirty mechanism.

I absolutely plan on releasing these patches :-) CRIU was the first open-source
userland I had planned on integrating with. At Google, I'm working with our
home-grown Qemu replacement. However, I'd be happy to help with an effort to
get softdirty integrated in Qemu in the future.

> >Documentation/vm/soft-dirty.txt and pagemap.txt in case you aren't familiar. To
> 
> I have read them cursorily, it is useful for pre-copy indeed. But it seems that
> it can not meet my need for snapshot.

> >make softdirty usable for live migration, I've added an API to atomically
> >test-and-clear the bit and write protect the page.
> 
> How can i find the API? Is it been merged in kernel's master branch already?

Negative. I'll be sure to CC you when I start sending this stuff upstream.

Peter
