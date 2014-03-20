Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbaCTU5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:57:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:50549 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759458AbaCTU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:57:07 -0400
Date: Thu, 20 Mar 2014 16:57:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jeffrey Layton <jlayton@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        uobergfe@redhat.com, Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Message-ID: <20140320165703.522c7c5c@gandalf.local.home>
In-Reply-To: <20140320152833.216d81a0@tlielax.poochiereds.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 15:28:33 -0400
Jeffrey Layton <jlayton@redhat.com> wrote:

 
> Nice analysis! I think eventually we'll need to overhaul this code not

Note, Ulrich Obergfell helped a bit in the initial analysis. He found
from a customer core dump that the kworker thread was blocked on the
cinode->lock_sem, and the reader was blocked as well. That was enough
for me to find where the problem laid.

> to use rw semaphores, but that's going to take some redesign. (Wonder
> if we could change it to use seqlocks or something?)
> 
> Out of curiousity, does this eventually time out and unwedge itself?
> Usually when the server doesn't get a response to an oplock break in
> around a minute or so it gives up and allows the thing that caused the
> oplock break to proceed anyway. Not great for performance but it out to
> eventually make progress due to that.

No, I believe it's hard locked. Nothing is going to wake up the oplock
break  if it is blocked on a down_read(). Only the release of the rwsem
will do that. It's the subtle way the kworker threads are done.

> 
> In any case, this looks like a reasonable fix for now, but I suspect you
> can hit similar problems in the write codepath too. What may be best is
> turn this around and queue the oplock break to the new workqueue
> instead of the read completion job.

Or perhaps give both the read and write their own workqueues? We have
to look at all the work queue handlers, and be careful about any users
that take the lock_sem, and separate them out.

-- Steve


