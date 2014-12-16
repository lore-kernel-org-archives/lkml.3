Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaLPPhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:37:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaLPPhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:37:19 -0500
Date: Tue, 16 Dec 2014 23:36:50 +0800
From: Baoquan He <bhe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, Waiman.Long@hp.com
Subject: Re: [PATCH] locking/rwlocks: clean up of qrwlock
Message-ID: <20141216153650.GA1758@dhcp-17-102.nay.redhat.com>
References: <1418709640-5625-1-git-send-email-bhe@redhat.com>
 <20141216090128.GU3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216090128.GU3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/14 at 10:01am, Peter Zijlstra wrote:
> On Tue, Dec 16, 2014 at 02:00:40PM +0800, Baoquan He wrote:
> > In queue_read_lock_slowpath, when writer count becomes 0, we need
> > increment the read count and get the lock. Then need call
> > rspin_until_writer_unlock to check again if an incoming writer
> > steals the lock in the gap. But in rspin_until_writer_unlock
> > it only checks the writer count, namely low 8 bit of lock->cnts,
> > no need to subtract the reader count unit specifically. So remove
> > that subtraction to make it clearer, rspin_until_writer_unlock
> > just takes the actual lock->cnts as the 2nd argument.
> > 
> > And also change the code comment in queue_write_lock_slowpath to
> > make it more exact and explicit.
> > 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  kernel/locking/qrwlock.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
> > index f956ede..ae66c10 100644
> > --- a/kernel/locking/qrwlock.c
> > +++ b/kernel/locking/qrwlock.c
> > @@ -76,7 +76,7 @@ void queue_read_lock_slowpath(struct qrwlock *lock)
> >  	while (atomic_read(&lock->cnts) & _QW_WMASK)
> >  		cpu_relax_lowlatency();
> >  
> > -	cnts = atomic_add_return(_QR_BIAS, &lock->cnts) - _QR_BIAS;
> > +	cnts = atomic_add_return(_QR_BIAS, &lock->cnts);
> >  	rspin_until_writer_unlock(lock, cnts);
> 
> Did you actually look at the ASM generated? I suspect your change makes
> it bigger.


It does make it bigger. But it doesn't matter. Because in
rspin_until_writer_unlock it only compqre (cnts & _QW_WMASK) 
with _QW_LOCKED. So using incremented reader count doesn't impact
the result. Anyway it will get the actual lock->cnts in
rspin_until_writer_unlock in next loop. I can't see why we need
subtract that reader count increment specifically.

When I read this code, thought there's some special usage. Finally I
realized it doesn't have special usage, and doesn't have to do that. 
