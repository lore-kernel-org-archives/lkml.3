Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbaCTXy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:54:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943AbaCTXyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:54:25 -0400
Date: Thu, 20 Mar 2014 19:53:46 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Message-ID: <20140320195346.0876e175@tlielax.poochiereds.net>
In-Reply-To: <20140319151252.16ed3ac6@gandalf.local.home>
References: <20140319151252.16ed3ac6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014 15:12:52 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> We just had a customer report a deadlock in their 3.8-rt kernel.
> Looking into this, it is very possible to have the same deadlock in
> mainline in Linus's tree as it stands today.
> 
> It is much easier to deadlock in the -rt kernel because reader locks
> are serialized, where a down_read() can block another down_read(). But
> because rwsems are fair locks, if a writer is waiting, a new reader
> will then block. This means that if it is possible for a reader to
> deadlock another reader, this can happen if a write comes along and
> blocks on a current reader. That will prevent another reader from
> running, and if that new reader requires to wake up a reader that owns
> the lock, you have your deadlock.
> 
> Here's the situation with CIFS and workqueues:
> 
> The cifs system has several workqueues used in file.c and other places.
> One of them is used for completion of a read and to release the
> page_lock which wakes up the reader. There are several other workqueues
> that do various other tasks.
> 
> A holder of the reader lock can sleep on a page_lock() and expect the
> reader workqueue to wake it up (page_unlock()). The reader workqueue
> takes no locks so this does not seem to be a problem (but it is).
> 
> The other workqueues can take the rwsem for read or for write. But our
> issue that we tripped over was that it grabs it for read (remember in
> -rt readers are serialized). But this can also happen if a separate
> writer is waiting on the lock as that would cause a reader to block on
> another reader too.
> 
> All the workqueue callbacks are executed on the same workqueue:
> 
> 	queue_work(cifsiod_wq, &rdata->work);
> 	[...]
> 	queue_work(cifsiod_wq, &cfile->oplock_break);
> 
> Now if the reader workqueue callback is queued after one of these
> workqueues that can take the rwsem, we can hit a deadlock. The
> workqueue code looks to be able to prevent deadlocks of these kinds,
> but I do not totally understand the workqueue scheduled work structure
> and perhaps if the kworker thread structure blocks hard it wont move
> works around.
> 
> Here's what we see:
> 
> 	rdata->work is scheduled after cfile->oplock_break
> 
> 	CPU0						CPU1
> 	----						----
> 
>   do_sync_read()
>     cifs_strict_readv()
>       down_read(cinode->lock_sem);
>       generic_file_aio_read()
>         __lock_page_killable()
>           __wait_on_bit_lock()
> 
>        * BLOCKED *
> 
> 						process_one_work()
> 						  cifs_oplock_break()
> 						    cifs_has_mand_locks()
> 						      down_read(cinode->lock_sem);
> 
> 						   * BLOCKED *
> 
> 					      [ note, cifs_oplock_break() can
> 					        also call cifs_push_locks which takes
> 					        the lock with down_write() ]
> 
> 

Wait...why does the work running on CPU1 end up blocked on down_read()?
Is it really getting stuck on the down_write you mention?

-- 
Jeff Layton <jlayton@redhat.com>
