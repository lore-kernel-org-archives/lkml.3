Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaCWIE2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 04:04:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:56846 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaCWIEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 04:04:23 -0400
Date: Sun, 23 Mar 2014 09:04:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: oleg@redhat.com, joseph.salisbury@canonical.com, JBottomley@parallels.com,
        Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com,
        rientjes@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
        linux-scsi@vger.kernel.org, thenzl@redhat.com
Subject: Re: please fix FUSION
 (Was:[v3.13][v3.14][Regression]kthread:makekthread_create()killable)
In-Reply-To: <201403230857.IGH51500.FOHtQMFVOFOLJS@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1403230856500.18573@ionos.tec.linutronix.de>
References: <20140321183443.GA3891@redhat.com> <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp> <20140322192511.GA14811@redhat.com> <alpine.DEB.2.02.1403222201300.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403222242450.18573@ionos.tec.linutronix.de>
 <201403230857.IGH51500.FOHtQMFVOFOLJS@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Mar 2014, Tetsuo Handa wrote:

> Thomas Gleixner wrote:
> > But then systemd/udev mutters:
> > 
> >    "You migh be able to work around the timeout with udev rules and
> >     OPTIONS+="event_timeout=120", but that code was maybe never used
> >     or tested, so it might not work correctly." [1]
> > 
> > AFAICT from the ubuntu bug system [2] nobody bothered even to try that.
> > 
> > And if the udev/systemd event_timeout option is broken it's way better
> > to fix that one instead of hacking random heuristics into the kernel.
> 
> I haven't tried the event_timeout= option but I think it will not work.
> The timeout is hard coded as shown below and there will be no chance for taking
> the event_timeout= option into account.
> 
> ---------- systemd-204/src/udev/udevd.c start ----------
> (...snipped...)
>                         /* check for hanging events */
>                         udev_list_node_foreach(loop, &worker_list) {
>                                 struct worker *worker = node_to_worker(loop);
> 
>                                 if (worker->state != WORKER_RUNNING)
>                                         continue;
> 
>                                 if ((now(CLOCK_MONOTONIC) - worker->event_start_usec) > 30 * 1000 * 1000) {

And because systemd has an immutable hardcoded random timeout we add
another hardcoded random timeout into kthread_create() to work around
that.

How broken is that?

And it seems other people have solved it:

    http://www.redhat.com/archives/lvm-devel/2013-September/msg00036.html

Thanks,

	tglx
