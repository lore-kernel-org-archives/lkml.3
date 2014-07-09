Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaGIQuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:50:02 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43731 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbaGIQuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:50:00 -0400
Message-ID: <1404924596.2006.6.camel@jarvis.lan>
Subject: Re: [PATCH 08/14] scsi: convert device_busy to atomic_t
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>,
        Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 09 Jul 2014 09:49:56 -0700
In-Reply-To: <1403715121-1201-9-git-send-email-hch@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
	 <1403715121-1201-9-git-send-email-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 18:51 +0200, Christoph Hellwig wrote:
> Avoid taking the queue_lock to check the per-device queue limit.  Instead
> we do an atomic_inc_return early on to grab our slot in the queue,
> and if nessecary decrement it after finishing all checks.
> 
> Unlike the host and target busy counters this doesn't allow us to avoid the
> queue_lock in the request_fn due to the way the interface works, but it'll
> allow us to prepare for using the blk-mq code, which doesn't use the
> queue_lock at all, and it at least avoids a queue_lock rountrip in
> scsi_device_unbusy, which is still important given how busy the queue_lock
> is.

Most of these patches look fine to me, but this one worries me largely
because of the expense of atomics.

As far as I can tell from the block MQ, we get one CPU thread per LUN.
Doesn't this mean that we only need true atomics for variables that
cross threads?  That does mean target and host, but shouldn't mean
device, since device == LUN.  As long as we protect from local
interrupts, we should be able to exclusively update all LUN local
variables without having to change them to being atomic.

This view depends on correct CPU steering of returning interrupts, since
the LUN thread model only works if the same CPU handles issue and
completion, but it looks like that works in MQ, even if it doesn't work
in vanilla.

James


