Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3C1Ui6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 16:38:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab3C1Ui5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 16:38:57 -0400
Date: Thu, 28 Mar 2013 16:38:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: dm-crypt performance
Message-ID: <20130328203808.GC15969@redhat.com>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com>
 <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com>
 <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328194443.GG14088@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 12:44:43PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Mar 28, 2013 at 03:33:43PM -0400, Vivek Goyal wrote:
> > I am curious why out of order bio is a problem. Doesn't the elevator
> > already merge bio's with existing requests and if merging does not
> > happen then requests are sorted in order. So why ordering is not
> > happening properly with dm-crypt. What additional info dm-crypt has
> > that it can do better ordering than IO scheduler.
> 
> Hmmm... well, for one, it doesn't only change ordering.  It also
> changes the timings.  Before iosched would get contiguous stream of
> IOs when the queue gets unplugged (BTW, how does dm crypt handling
> plugging?  If not handled properly, it could definitely affect a lot
> of things.)  With multiple threads doing encryption in the middle, the
> iosched could get scattered IOs which could easily span multiple
> millisecs.  Even if context tagging was done properly, it could easily
> lead to much less efficient IO patterns to hardware.
> 
> Keeping IO order combined with proper plug handling would not only
> keep the ordering constant but also the relative timing of events,
> which is an important factor when scheduling IOs.

If timing of unordered IO is an issue, then dm-crypt can try
to batch IO submission using blk_start_plug()/blk_finish_plug(). That way
dm-crypt can batch bio and control submission and there should not
be a need to put specific ordering logic in dm-crypt. 

So if there are multiple threads doing crypto, they end up submitting
bio after crypto operation or queue it somewhere and ther is single
submitter thread.

If compltion of crypto is an issue, then I think it is very hard to
determine whether extra waiting helps with throughput or hurts. If
dm-crypt can decide that somehow, then I guess they can just try
to do batch submission of IO from various crypto threads and see
if it helps with performance. (At some point of time, submitter
thread will become a bottleneck).

> 
> > CFQ might seeing more performance hit because we maintain per
> > process queues and kernel threads might not be sharing the IO context
> > (i am not sure). So if all the crypto threads can share the IO
> > context, atleast it will make sure all IO from them goes into a
> > single queue.
> 
> Right, this is important too although I fail to see how workqueue
> vs. custom dispatch would make any difference here.  dm-crypt should
> definitely be using bio_associate_current().

Agreed. bio_associate_current() will atleast help keeping all bios
of single context in single queue and promote more merging (if submission
happens in right time frame).

Thanks
Vivek
