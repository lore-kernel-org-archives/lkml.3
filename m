Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461Ab3IBNuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 09:50:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756087Ab3IBNuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 09:50:39 -0400
Date: Mon, 2 Sep 2013 15:50:34 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130902135033.GA1686@redhat.com>
References: <20130820111426.GA27828@swordfish.datadirectnet.com>
 <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
 <20130821153957.GA2969@swordfish.minsk.epam.com>
 <20130830230402.GA14760@somewhere>
 <20130902122845.GA2457@swordfish.minsk.epam.com>
 <20130902130744.GB2378@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130902130744.GB2378@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 03:07:45PM +0200, Frederic Weisbecker wrote:
> > Hope this may help.
> > I've added a silly check to make sure that `stime < rtime'
> > 
> > @@ -579,6 +582,10 @@ static void cputime_adjust(struct task_cputime *curr,
> >         if (total) {
> >                 stime = scale_stime((__force u64)stime,
> >                                     (__force u64)rtime, (__force u64)total);
> > +               if (stime > rtime) {
> > +                       printk(KERN_ERR "Ooops: stime:%llu rtime:%llu\n", stime, rtime);
> > +                       WARN_ON(1);
> > +               }
> >                 utime = rtime - stime;
> >         } else {
> >                 stime = rtime;
[snip]

> Thanks a lot Sergey for testing this further!
> 
> Interesting results, so rtime is always one or two units off stime after scaling.
> Stanislaw made the scaling code with Linus and he has a better idea on the math guts
> here.

I don't think this is scale issue, but rather at scale_stime() input
stime is already bigger then rtime. Sergey, could you verify that
by adding check before scale_stime() ?

Stanislaw
