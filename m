Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3C1St1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:49:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44997 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3C1St0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:49:26 -0400
Date: Thu, 28 Mar 2013 12:49:22 -0600
From: Jens Axboe <axboe@kernel.dk>
To: tlinder@codeaurora.org
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        alex.lemberg@sandisk.com, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] block: Add support for reinsert a dispatched req
Message-ID: <20130328184922.GE19488@kernel.dk>
References: <1364202150-8776-1-git-send-email-tlinder@codeaurora.org>
 <20130325123410.GG22327@kernel.dk>
 <d6658b60b7e09376cfcf692dc54ac922.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6658b60b7e09376cfcf692dc54ac922.squirrel@www.codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27 2013, tlinder@codeaurora.org wrote:
> Hi Jens
> 
> >> Add support for reinserting a dispatched request back to the
> >> scheduler's internal data structures.
> >> This capability is used by the device driver when it chooses to
> >> interrupt the current request transmission and execute another (more
> >> urgent) pending request. For example: interrupting long write in order
> >> to handle pending read. The device driver re-inserts the
> >> remaining write request back to the scheduler, to be rescheduled
> >> for transmission later on.
> >>
> >> Add API for verifying whether the current scheduler
> >> supports reinserting requests mechanism. If reinsert mechanism isn't
> >> supported by the scheduler, this code path will never be activated.
> >
> > This is practically the exact same operation as a requeue.
> 
> Not exactly. When you requeue request X it will be the next one to be
> dispatched and handled by the device driver. When you reinsert a request,
> you reinset it back to the I/O scheduler and not to the dispatch queue.
> That means that this reinserted request will be rescheduled and its
> possible that it wont be the next one to be dispatched since there might
> be more urgent requests pending.
> For example: an urgent request notification was sent to the device driver
> that is currently transmitting a long packed WRITE command. The urgent
> request pending to be served is a READ request. The device driver decides
> to stop the packed WRITE request and handle the urgent READ. This is the
> difference between requeue and reinsert:
>  - if we requeue the stopped packed WRITE, it will be immediately fetched
> and transmitted again and the READ will be left pending till the packed
> WRITE completes. In this case there was no point in stopping the packed
> WRITE
> - if we reinsert the stopped packed WRITE the next request to be
> dispatched will be the urgent READ request (since READ is given priority
> over WRITE) and this will reduce the READ latency greatly.

I said practically the same, not exactly the same! In any case, the
point is that you could reuse the exact same infrastructure for this,
instead of literally duplicating everything. Have some helper that does
the grunt of the work, pass in whether or not you want the existing
requeue event, or a reinsert event.

-- 
Jens Axboe

