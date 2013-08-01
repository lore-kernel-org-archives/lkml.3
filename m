Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3HACBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 22:01:11 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:57520 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3HACBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 22:01:09 -0400
Date: Thu, 1 Aug 2013 10:01:01 +0800
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        djbw@fb.com
Subject: Re: [patch 1/3] raid5: offload stripe handle to workqueue
Message-ID: <20130801020101.GB12580@kernel.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055257.527231772@kernel.org>
 <20130730125306.GC2599@htj.dyndns.org>
 <20130730130708.GA30352@kernel.org>
 <20130730135751.GD12016@htj.dyndns.org>
 <20130731012434.GA1504@kernel.org>
 <20130731103332.GE2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731103332.GE2810@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 06:33:32AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jul 31, 2013 at 09:24:34AM +0800, Shaohua Li wrote:
> > stripe is the work unit actually. As I said, if I queue a work for each stripe,
> > just queue_work() will make the system blast because of the pwq->pool->lock
> > contention. dispatching one work has another side effect that I can't add block
> 
> Hmmm.... I see.  I'm not familiar with the code base and could be
> missing something but how does the custom stripe dispatch queue
> synchronize?  Doesn't that make use of a lock anyway?  If so, how
> would scheduling separate work items be worse?  

It does have lock, but when a stripe is queued to handle, no lock is required.
So the workqueue lock will be high contended.

> Also, can you please
> elaborate the block plug part?

Basically I do:

blk_start_plug()
handle_stripe() //may dispatch request
blk_end_plug()

If only handle one stripe between block plug, the plug is useless, so I need
handle several stripes.

Thanks,
Shaohua
