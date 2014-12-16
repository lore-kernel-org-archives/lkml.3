Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103AbaLPJBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:01:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaLPJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:01:44 -0500
Date: Tue, 16 Dec 2014 10:01:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, Waiman.Long@hp.com
Subject: Re: [PATCH] locking/rwlocks: clean up of qrwlock
Message-ID: <20141216090128.GU3337@twins.programming.kicks-ass.net>
References: <1418709640-5625-1-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418709640-5625-1-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 02:00:40PM +0800, Baoquan He wrote:
> In queue_read_lock_slowpath, when writer count becomes 0, we need
> increment the read count and get the lock. Then need call
> rspin_until_writer_unlock to check again if an incoming writer
> steals the lock in the gap. But in rspin_until_writer_unlock
> it only checks the writer count, namely low 8 bit of lock->cnts,
> no need to subtract the reader count unit specifically. So remove
> that subtraction to make it clearer, rspin_until_writer_unlock
> just takes the actual lock->cnts as the 2nd argument.
> 
> And also change the code comment in queue_write_lock_slowpath to
> make it more exact and explicit.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  kernel/locking/qrwlock.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> index f956ede..ae66c10 100644
> --- a/kernel/locking/qrwlock.c
> +++ b/kernel/locking/qrwlock.c
> @@ -76,7 +76,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
>  	while (atomic_read(&lock->cnts) & _QW_WMASK)
>  		cpu_relax_lowlatency();
>  
> -	cnts = atomic_add_return(_QR_BIAS, &lock->cnts) - _QR_BIAS;
> +	cnts = atomic_add_return(_QR_BIAS, &lock->cnts);
>  	rspin_until_writer_unlock(lock, cnts);

Did you actually look at the ASM generated? I suspect your change makes
it bigger.
