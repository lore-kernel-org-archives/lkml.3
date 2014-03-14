Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaCNMpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:45:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42455 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaCNMpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:45:02 -0400
Date: Fri, 14 Mar 2014 05:44:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140314124457.GA4859@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <20140313161347.GA6598@redhat.com>
 <20140314092519.GA10139@infradead.org>
 <5322CC4D.8040509@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5322CC4D.8040509@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 10:30:53AM +0100, Hannes Reinecke wrote:
> That was actually one of my plans, move dm-multipath over to use
> blk-mq. But then I'd need to discuss with Jens et al how to best
> achieve this; the current static hctx allocation doesn't play well
> with multipaths dynamic path management.

I'd say it the other way around: the clone + insert hacks in
dm-multipath don't work well with blk-mq.  Not allowing non-owned
requests is fundamentally part of the blk-mq model to allow things
like the integrated tag allocator and queue depth limiting or the
preallocated driver specific data.

Instead dm-multipath should alway resubmit the request like it already
does for the slow path for the first step.  Longer term we might be able
to operate using a cheaper temporary structure, but I'm not sure that's
going to be worth it.
