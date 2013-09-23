Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3IWNCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:02:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab3IWNCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:02:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: Send BLK_TN_PROCESS events to all running traces
References: <1379449831-6710-1-git-send-email-jack@suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Sep 2013 09:02:08 -0400
In-Reply-To: <1379449831-6710-1-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Tue, 17 Sep 2013 22:30:31 +0200")
Message-ID: <x4938ovzo6n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> Currently each task sends BLK_TN_PROCESS event to the first traced
> device it interacts with after a new trace is started. When there are
> several traced devices and the task accesses more devices, this logic
> can result in BLK_TN_PROCESS being sent several times to some devices
> while it is never sent to other devices. Thus blkparse doesn't display
> command name when parsing some blktrace files.
>
> Fix the problem by sending BLK_TN_PROCESS event to all traced devices
> when a task interacts with any of them.
>
> Signed-off-by: Jan Kara <jack@suse.cz>

[snip]

> @@ -229,16 +241,15 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  		goto record_it;
>  	}
>  
> +	if (unlikely(tsk->btrace_seq != blktrace_seq))
> +		trace_note_tsk(tsk);
> +
>  	/*
>  	 * A word about the locking here - we disable interrupts to reserve
>  	 * some space in the relay per-cpu buffer, to prevent an irq
>  	 * from coming in and stepping on our toes.
>  	 */
>  	local_irq_save(flags);
> -
> -	if (unlikely(tsk->btrace_seq != blktrace_seq))
> -		trace_note_tsk(bt, tsk);
> -
>  	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
>  	if (t) {
>  		sequence = per_cpu_ptr(bt->sequence, cpu);

I don't think moving the call site was strictly necessary.  That
wouldn't really change anything, though.  I also think that this
simplistic approach is good enough.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
