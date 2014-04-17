Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaDQH64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:58:56 -0400
Received: from www.linutronix.de ([62.245.132.108]:46349 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaDQH6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:58:55 -0400
Date: Thu, 17 Apr 2014 09:59:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <20140417023818.GB6448@kroah.com>
Message-ID: <alpine.DEB.2.02.1404170951080.22697@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1403231613230.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403240017430.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403252220110.4094@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403261731390.26530@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403262248170.31401@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403270940250.27563@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403311201520.14882@ionos.tec.linutronix.de>
 <20140406034750.GA7674@kroah.com> <alpine.DEB.2.02.1404170056140.22697@ionos.tec.linutronix.de> <20140417023818.GB6448@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014, Greg KH wrote:
> On Thu, Apr 17, 2014 at 01:00:53AM +0200, Thomas Gleixner wrote:
> > And cdevs is an array of  struct cdev:
> > 
> > struct cdev {
> > 	struct kobject kobj;
> 
> Those are not "real" kobjects, and are never registered with the kobject
> core.
> 
> I really need to go rename those one of these days, and just make them a
> separate object, as they have nothing to do with a "normal" kobject
> other than the reference count and the use of the kobject map stuff.
> 
> So if this is showing up as a problem, something else is going on here,
> as this should not be an issue at all.

As far as I decoded it from Vince traces the issue is only with
DEBUG_KOBJECT_RELEASE=y. That deferres the release to a workqueue.

Now the cdevs in tty are allocated ahead and not freed on
release. They stay in the cdevs[] array of the tty drivers.

Now if a cdev is released the kobject debug stuff schedules the
delayed work, but the tty core can reuse the cdev.before the delayed
work has been executed and first thing it does is calling cdev_init()
which does a

     memset(cdev, 0, sizeof *cdev);

which of course includes the enqueued timer and the scheduled work. Go
figure how well that goes.

Thanks,

	tglx

