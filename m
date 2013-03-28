Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab3C1To5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 15:44:57 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59559 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3C1Toz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 15:44:55 -0400
Date: Thu, 28 Mar 2013 12:44:43 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
        Andi Kleen <andi@firstfloor.org>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: dm-crypt performance
Message-ID: <20130328194443.GG14088@htj.dyndns.org>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com>
 <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com>
 <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130328193343.GA15969@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Mar 28, 2013 at 03:33:43PM -0400, Vivek Goyal wrote:
> I am curious why out of order bio is a problem. Doesn't the elevator
> already merge bio's with existing requests and if merging does not
> happen then requests are sorted in order. So why ordering is not
> happening properly with dm-crypt. What additional info dm-crypt has
> that it can do better ordering than IO scheduler.

Hmmm... well, for one, it doesn't only change ordering.  It also
changes the timings.  Before iosched would get contiguous stream of
IOs when the queue gets unplugged (BTW, how does dm crypt handling
plugging?  If not handled properly, it could definitely affect a lot
of things.)  With multiple threads doing encryption in the middle, the
iosched could get scattered IOs which could easily span multiple
millisecs.  Even if context tagging was done properly, it could easily
lead to much less efficient IO patterns to hardware.

Keeping IO order combined with proper plug handling would not only
keep the ordering constant but also the relative timing of events,
which is an important factor when scheduling IOs.

> CFQ might seeing more performance hit because we maintain per
> process queues and kernel threads might not be sharing the IO context
> (i am not sure). So if all the crypto threads can share the IO
> context, atleast it will make sure all IO from them goes into a
> single queue.

Right, this is important too although I fail to see how workqueue
vs. custom dispatch would make any difference here.  dm-crypt should
definitely be using bio_associate_current().

Thanks.

-- 
tejun
