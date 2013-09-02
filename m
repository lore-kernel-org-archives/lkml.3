Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab3IBON4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:13:56 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63843 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3IBONz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:13:55 -0400
Date: Mon, 2 Sep 2013 16:13:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130902141350.GC2378@somewhere>
References: <20130820111426.GA27828@swordfish.datadirectnet.com>
 <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
 <20130821153957.GA2969@swordfish.minsk.epam.com>
 <20130830230402.GA14760@somewhere>
 <20130902122845.GA2457@swordfish.minsk.epam.com>
 <20130902130744.GB2378@somewhere>
 <20130902135033.GA1686@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902135033.GA1686@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 03:50:34PM +0200, Stanislaw Gruszka wrote:
> On Mon, Sep 02, 2013 at 03:07:45PM +0200, Frederic Weisbecker wrote:
> > > Hope this may help.
> > > I've added a silly check to make sure that `stime < rtime'
> > > 
> > > @@ -579,6 +582,10 @@ static void cputime_adjust(struct task_cputime *curr,
> > >         if (total) {
> > >                 stime = scale_stime((__force u64)stime,
> > >                                     (__force u64)rtime, (__force u64)total);
> > > +               if (stime > rtime) {
> > > +                       printk(KERN_ERR "Ooops: stime:%llu rtime:%llu\n", stime, rtime);
> > > +                       WARN_ON(1);
> > > +               }
> > >                 utime = rtime - stime;
> > >         } else {
> > >                 stime = rtime;
> [snip]
> 
> > Thanks a lot Sergey for testing this further!
> > 
> > Interesting results, so rtime is always one or two units off stime after scaling.
> > Stanislaw made the scaling code with Linus and he has a better idea on the math guts
> > here.
> 
> I don't think this is scale issue, but rather at scale_stime() input
> stime is already bigger then rtime. Sergey, could you verify that
> by adding check before scale_stime() ?

Note that having stime > rtime should be fine to handle. This can happen for
example if the task runs on tiny timeslices but is unlucky enough that all these
timeslices are interrupted by the tick.

> 
> Stanislaw
