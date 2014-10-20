Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaJTOqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:46:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:7823 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaJTOqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:46:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="402973230"
Message-ID: <1413816389.7906.336.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 20 Oct 2014 17:46:29 +0300
In-Reply-To: <543F9895.7010502@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
					 <1412029248-22454-4-git-send-email-richard@nod.at>
				 <1412346676.3795.62.camel@sauron.fi.intel.com> <542EF3BF.1070401@nod.at>
			 <1413206263.7906.18.camel@sauron.fi.intel.com> <543BE21F.5020504@nod.at>
		 <1413213803.7906.45.camel@sauron.fi.intel.com> <543C3E60.4080507@nod.at>
	 <1413282203.7906.72.camel@sauron.fi.intel.com> <543F9895.7010502@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 12:06 +0200, Richard Weinberger wrote:
> Am 14.10.2014 um 12:23 schrieb Artem Bityutskiy:
> > On Mon, 2014-10-13 at 23:04 +0200, Richard Weinberger wrote:
> >> Am 13.10.2014 um 17:23 schrieb Artem Bityutskiy:
> >>> Well, used and free are RB-trees, looking them up is slow.
> >>
> >> This is true but we'd have to look it up in multiple trees and the protection queue...
> > 
> > Right. 2 RB-trees, and one list. The list is empty most of the time, or
> > contains one element. 
> 
> Actually it is the free, used and scrub tree plus the protection queue.

OK, still does not change my point: 3 trees and a list which is mostly
empty or short. Not that bad.

Besides, the used tree is the large one, contains most of the stuff. The
scrub tree is usually small, and mostly empty. The erroneous tree also
mostly empty.

So this in most of the cases, this will be about looking up a single
tree.

And again, all you need is:

1. all used
2. all scrub
3. all erroneous

> Then there is another place where PEBs can hide, the erase work queue.

That's just fastmap code not doing the right thing. We should not touch
the work queue directly at all. What we _should_ do instead is to make
it empty by asking the subsystem which manages it to flush it.

1. Lock the work queue to prevent anyone from submitting new jobs while
we are in process of writing the fastmap.
2. Flush all works
3. do all the fastmap write stuff
4. Unlock

> This brings me to an issue I've recently identified and fixed in my local queue.
> 
> ubi_wl_put_peb() does the following:
>                 if (in_wl_tree(e, &ubi->used)) {
>                         self_check_in_wl_tree(ubi, e, &ubi->used);
>                         rb_erase(&e->u.rb, &ubi->used);
>                 } else if (in_wl_tree(e, &ubi->scrub)) {
>                         self_check_in_wl_tree(ubi, e, &ubi->scrub);
>                         rb_erase(&e->u.rb, &ubi->scrub);
>                 } else if (in_wl_tree(e, &ubi->erroneous)) {
>                         self_check_in_wl_tree(ubi, e, &ubi->erroneous);
>                         rb_erase(&e->u.rb, &ubi->erroneous);
>                         ubi->erroneous_peb_count -= 1;
>                         ubi_assert(ubi->erroneous_peb_count >= 0);
>                         /* Erroneous PEBs should be tortured */
>                         torture = 1;
>                 } else {
>                         err = prot_queue_del(ubi, e->pnum);
>                         if (err) {
>                                 ubi_err("PEB %d not found", pnum);
>                                 ubi_ro_mode(ubi);
>                                 spin_unlock(&ubi->wl_lock);
>                                 return err;
>                         }
>                 }
>         }
>         spin_unlock(&ubi->wl_lock);
> 
>         err = schedule_erase(ubi, e, vol_id, lnum, torture);
> 
> If it happens that a fastmap write is needed between spin_unlock() and schedule_erase(), fastmap
> will miss this PEB.

You say is that LEBs change while you are writing fastmap. Of course
they do. We should have a locking mechanism in place which would prevent
this.

Mat be wl_lock needs to become a mutex, or may be there should be
separate mutex.

Or may be 'ubi_wl_put_peb()' should go through the fatmap subsystem
which should be able to block it if it is writing fastmap.

Ideally, you should be able to "freeze" the state (of course for a short
time), prepare fastmap data structures in memory, unfreeze, let users to
further IO, and wirte fastmap.

This is roughly what UBIFS does when committing. It freezes all writers,
builds the commit list, unfreezes the writers, and continues the commit
process.

Now, to be that advanced, you need a journal. Without journal, you do
freeze, prepare and write, unfreeze. The end results is that writers are
blocked for longer time, but this may be good enough.

> What do you think?

I think that UBI is memory consumption grows linearly with the flash
growth. Mount time was linear too, fastmap is supposed to improve this.

I know that there are people, who also reported their issues in this
mailing list, who are very concerned about UBI memory consumption.

And I think that fastmap should try really hard to not only improve the
mount time, but also not to make the memory consumption problem worse.

So yes, I understand code niceness argument. I really do. But this
should not make UBI problem to be an even worse problem.

Please, let's try much harder to go without increasing the memory
footprint.

Thanks!


