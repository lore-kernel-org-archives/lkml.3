Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaLAD5R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:57:17 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54940 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaLAD5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:57:16 -0500
Date: Sun, 30 Nov 2014 19:57:12 -0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: don't use rw_is_sync() to determine sync request
Message-ID: <20141201035712.GA8443@kernel.org>
References: <4f327fd4f830a3fceab3694cdd7621c37f780809.1417391999.git.shli@kernel.org>
 <547BC5CF.7080904@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547BC5CF.7080904@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 06:35:11PM -0700, Jens Axboe wrote:
> On 11/30/2014 05:01 PM, Shaohua Li wrote:
> >Buffer read is counted as sync in rw_is_sync(). If we use it,
> >blk_sq_make_request() will not do per-process plug any more.
> >
> >I haven't changed blk_mq_make_request() yet. It makes sense to dispatch
> >REQ_SYNC request immediately. But for buffer read, it's weird not to do
> >per-process plug, as buffer read doesn't need low latency.
> >blk_mq_merge_queue_io() isn't very helpful, as we don't have delay mechanism
> >there, the queue is immediately flushed, which makes the merge very
> >superficial.
> 
> A read is sync, buffered or not. A buffered read is every bit as
> latency sensitive as an O_DIRECT read. I think it'd be fine to
> modify rw_is_sync() to disregard REQ_AHEAD as sync (and ensure it's
> carried forward in the request flags, too). At least to the extent
> that we process plug and get the merging, since for streamed reads
> we'd soon be waiting on them anyway.

A quick search shows nobody uses REQ_AHEAD. For stream reads, only first several
reads are waited I suppose, later reads are read ahead. Maybe only counts
REQ_META read as sync?

Thanks,
Shaohua
