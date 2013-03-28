Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3C1TeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:34:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab3C1TeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:34:10 -0400
Date: Thu, 28 Mar 2013 15:33:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: dm-crypt performance
Message-ID: <20130328193343.GA15969@redhat.com>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com>
 <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com>
 <20130328185327.GF14088@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328185327.GF14088@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 11:53:27AM -0700, Tejun Heo wrote:
> Hello,
> 
> (cc'ing Vivek and Jens for the iosched related bits)
> 
> On Tue, Mar 26, 2013 at 04:28:38PM -0400, Mike Snitzer wrote:
> > On Tue, Mar 26 2013 at  4:05pm -0400,
> > Milan Broz <gmazyland@gmail.com> wrote:
> > 
> > > >On Mon, Mar 25, 2013 at 11:47:22PM -0400, Mikulas Patocka wrote:
> > > >
> > > >>For best performance we could use the unbound workqueue implementation
> > > >>with request sorting, if people don't object to the request sorting being
> > > >>done in dm-crypt.
> > > 
> > > So again:
> > > 
> > > - why IO scheduler is not working properly here? Do it need some extensions?
> > > If fixed, it can help even is some other non-dmcrypt IO patterns.
> > > (I mean dmcrypt can set some special parameter for underlying device queue
> > > automagically to fine-tune sorting parameters.)
> > 
> > Not sure, but IO scheduler changes are fairly slow to materialize given
> > the potential for adverse side-effects.  Are you so surprised that a
> > shotgun blast of IOs might make the IO schduler less optimal than if
> > some basic sorting were done at the layer above?
> 
> My memory is already pretty hazy but Vivek should be able to correct
> me if I say something nonsense.  The thing is, the order and timings
> of IOs coming down from upper layers has certain meanings to ioscheds
> and they exploit those patterns to do better scheduling.
> 
> Reordering IOs randomly actually makes certain information about the
> IO stream lost and makes ioscheds mis-classify the IO stream -
> e.g. what could have been classfied as "mostly consecutive streaming
> IO" could after such reordering fail to be detected as such.  Sure,
> ioscheds can probably be improved to compensate for such temporary
> localized reorderings but nothing is free and given that most of the
> upper stacks already do pretty good job of issuing IOs orderly when
> possible, it would be a bit silly to do more than usually necessary in
> ioscheds.
> 
> So, no, I don't think maintaining IO order in stacking drivers is a
> bad idea.  I actually think all stacking drivers should do that;
> otherwise, they really are destroying actual useful side-band
> information.

I am curious why out of order bio is a problem. Doesn't the elevator
already merge bio's with existing requests and if merging does not
happen then requests are sorted in order. So why ordering is not
happening properly with dm-crypt. What additional info dm-crypt has
that it can do better ordering than IO scheduler.

CFQ might seeing more performance hit because we maintain per
process queues and kernel threads might not be sharing the IO context
(i am not sure). So if all the crypto threads can share the IO
context, atleast it will make sure all IO from them goes into a
single queue.

So it would help if somebody can explain that why existing merging
and sorting logic is not working well with dm-crypt and what additional
info dm-crypt has which can help it do better job.

Thanks
Vivek
