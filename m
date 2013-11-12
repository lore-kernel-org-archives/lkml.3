Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3KLOcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:32:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60358 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab3KLOcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:32:01 -0500
Date: Tue, 12 Nov 2013 15:31:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: Remove unused variable ret from
 sync_thread_master()
Message-ID: <20131112143152.GS5056@laptop.programming.kicks-ass.net>
References: <1384264396-14550-1-git-send-email-geert@linux-m68k.org>
 <20131112141314.GQ5056@laptop.programming.kicks-ass.net>
 <AE90C24D6B3A694183C094C60CF0A2F6026B7405@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7405@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 02:21:39PM -0000, David Laight wrote:
> > > @@ -1637,7 +1637,7 @@ static int sync_thread_master(void *data)
> > >  			continue;
> > >  		}
> > >  		while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
> > > -			int ret = __wait_event_interruptible(*sk_sleep(sk),
> > 
> > So ideally there's be a comment here why we're using interruptible but
> > then ignore interruptions.
> > 
> > Julian said (
> > http://lkml.kernel.org/r/alpine.LFD.2.00.1310012245020.1782@ja.ssi.bg ):
> > 
> > " Yes, your patch looks ok to me. In the past
> > we used ssleep() but IPVS users were confused why
> > IPVS threads increase the load average. So, we
> > switched to _interruptible calls and later the socket
> > polling was added.  "
> 
> I've done this in the past so that the code sleeps interruptibly
> unless there is a signal pending - which would cause it to return
> early.
> 
>     /* Tell scheduler we are going to sleep... */
>     if (signal_pending(current))
>         /* We don't want waking immediately (again) */
>         sleep_state = TASK_UNINTERRUPTIBLE;
>     else
>         sleep_state = TASK_INTERRUPTIBLE;
>     set_current_state(sleep_state);

If this is for kernel threads, I think you can wipe the pending state;
not entirely sure how signals interact with kthreads; Oleg will know.
