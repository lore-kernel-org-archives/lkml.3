Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaJPQKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:10:36 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43052 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJPQKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:10:35 -0400
Message-ID: <543FEDFF.2000105@kernel.dk>
Date: Thu, 16 Oct 2014 10:10:39 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: IO request merging
References: <20141016122740.GI6085@quack.suse.cz>
In-Reply-To: <20141016122740.GI6085@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 06:27 AM, Jan Kara wrote:
>   Hello,
> 
>   one of our customers was complaining that elv_attempt_insert_merge()
> merges two requests (via blk_attempt_req_merge()) without asking IO
> scheduler for permission (->elevator_allow_merge_fn() callback). Now for
> them this is a problem because of their custom IO scheduler but looking
> into the code this can result in somewhat suboptimal behavior for CFQ as
> well (merging two requests from different IO contexts, possibly merging
> sync & async request). What do others think about this?
> 
> Regarding possible fix, we cannot really call ->elevator_allow_merge_fn()
> because that assumes it is called from a context of a process submitting the
> passed bio. So we would need to create a separate allow merge callback for
> this.

It would need a new (rq to rq) merge hook, if they have a custom IO
scheduler, they should submit a change to allow that kind of behaviour.
Outside of potentially mixing sync and async IO (which seems like
something that should rarely/never happen), not sure I see a lot of
downsides. And that case could be explicitly checked in attempt_merge()
or blk_attempt_req_merge() without having to define a new hook to catch
that specific case. For the hook, cfq would lookup the io contexts and
compare, and basically disallow any merge that crosses a cfq io context
boundary. But given that I would only expect these types of merges to
happen very rarely, the sync vs async check would be good enough for me.

-- 
Jens Axboe

