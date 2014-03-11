Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaCKENV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 00:13:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:59131 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaCKENT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 00:13:19 -0400
Message-ID: <1394511196.4896.29.camel@marge.simpson.net>
Subject: Re: [PATCH RT] fs: jbd2: pull your plug when waiting for space
From: Mike Galbraith <bitbucket@online.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, tglx@linutronix.de
Date: Tue, 11 Mar 2014 05:13:16 +0100
In-Reply-To: <20140310174718.GB6763@thunk.org>
References: <20140221123253.GA12822@linutronix.de>
	 <1392990852.5451.178.camel@marge.simpson.net>
	 <20140310174718.GB6763@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:cOVPIRrNWxAJYHJwMOyKuWQTIXyf8z4F5FxuSo+F1gE
 kPI5CeOZHFW0nHbFZTwNdBdfIauf7Xhmc53vCm/kXHXNmANxhA
 NhOnwLZDBxb9zAm2AaEkgO1CH4uEZ4BeL6HQ2vWNOm6JtkxH46
 vXUmfmMQCYnjaU/SUR33pj8UGiS9uEJ5E+dMCQZnO03LHeXFMN
 BfzijRP/JTEQi2nDKIY7PAM9gwU4D9AbUp464L1c8WyesfIFXl
 yi6ktEh2s1Uj/q/upvsvu9myKeZjWOJZTyzkNDsBFXv/62D5zT
 PdPGKK96zkedCptlU3Z+6sOctDwyHn4xND8ZIzEyeb1YsO5LY6
 Jobkftpp8ClqrjYF2PmS59paV0eg4QGjtOoaPmyjc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 13:47 -0400, Theodore Ts'o wrote: 
> On Fri, Feb 21, 2014 at 02:54:12PM +0100, Mike Galbraith wrote:
> > 
> > ext3: dbench1 queues a buffer, blocks on journal mutex, it's plug is not
> > pulled.  dbench2 mutex owner is waiting for kjournald, who is waiting for
> > the buffer queued by dbench1.  Game over.
> 
> Where is in ext3/4 are we calling some function which could end up
> blocking on kjournald while we have the I/O queue plugged?  That
> sounds suspicious and potentially wrong.

I don't have the crash dumps and analysis handy, this was quite some
time ago.  Problem is that..

static inline void sched_submit_work(struct task_struct *tsk)
{
        if (!tsk->state || tsk_is_pi_blocked(tsk))
                return;
        /*
         * If we are going to sleep and we have plugged IO queued,
         * make sure to submit it to avoid deadlocks.
         */
        if (blk_needs_flush_plug(tsk))
                blk_schedule_flush_plug(tsk);
}

..tsk_is_pi_blocked(tsk) leaves us with IO queued, dependency on which
can (_did_ for ext[34] and xfs that I recall) end up with our waker
waiting on our IO.  There were other deadlock scenarios, not only the
one in the quoted text.

-Mike

