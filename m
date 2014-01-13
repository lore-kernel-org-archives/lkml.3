Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaAMDuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:50:10 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35226 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAMDuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:50:06 -0500
Date: Sun, 12 Jan 2014 19:49:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Daniel J Blueman <daniel@numascale.com>
Cc: Waiman Long <Waiman.Long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140113034957.GJ10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <52D353C8.4000000@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D353C8.4000000@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011303-9332-0000-0000-000002BC94F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 10:47:36AM +0800, Daniel J Blueman wrote:
> On Thursday, 9 January 2014 01:10:03 UTC+8, Waiman Long  wrote:
> > This patch modifies the queue_write_unlock() function to use the
> > new smp_store_release() function in another pending patch. It also
> > removes the temporary implementation of smp_load_acquire() and
> > smp_store_release() function in qrwlock.c.
> >
> > This patch should only be merged if PeterZ's linux-arch patch patch
> > was merged.
> >
> > Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  include/asm-generic/qrwlock.h |    4 +---
> >  kernel/locking/qrwlock.c      |   34 ----------------------------------
> >  2 files changed, 1 insertions(+), 37 deletions(-)
> >
> > diff --git a/include/asm-generic/qrwlock.h
> b/include/asm-generic/qrwlock.h
> > index 2b9a7b4..4d4bd04 100644
> > --- a/include/asm-generic/qrwlock.h
> > +++ b/include/asm-generic/qrwlock.h
> > @@ -179,9 +179,7 @@ static inline void queue_write_unlock(struct
> qrwlock *lock)
> >  	/*
> >  	 * Make sure that none of the critical section will be leaked out.
> >  	 */
> > -	smp_mb__before_clear_bit();
> > -	ACCESS_ONCE(lock->cnts.writer) = 0;
> > -	smp_mb__after_clear_bit();
> > +	smp_store_release(&lock->cnts.writer, 0)
> 
> This will fail compilation, so probably needs further testing with
> Peter's load_acquire/store_release barrier patches.

Peter's patch just hit -tip, so this should be esay to do.  In Waiman's
defense, he does call attention to this in the commit log.

							Thanx, Paul

