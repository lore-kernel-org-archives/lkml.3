Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaDXTfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:35:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45238 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbaDXTe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:34:58 -0400
X-Sasl-enc: 0s8a0DGEj6fXZOEeKaM26RF7iCfWO4RnZNZh528Vwc/T 1398368097
Date: Thu, 24 Apr 2014 12:37:50 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
Message-ID: <20140424193750.GB26081@kroah.com>
References: <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403252220110.4094@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403261731390.26530@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403262248170.31401@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403270940250.27563@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403311201520.14882@ionos.tec.linutronix.de>
 <20140406034750.GA7674@kroah.com>
 <alpine.DEB.2.02.1404170056140.22697@ionos.tec.linutronix.de>
 <20140417023818.GB6448@kroah.com>
 <alpine.DEB.2.02.1404170951080.22697@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404170951080.22697@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 09:59:01AM +0200, Thomas Gleixner wrote:
> On Wed, 16 Apr 2014, Greg KH wrote:
> > On Thu, Apr 17, 2014 at 01:00:53AM +0200, Thomas Gleixner wrote:
> > > And cdevs is an array of  struct cdev:
> > > 
> > > struct cdev {
> > > 	struct kobject kobj;
> > 
> > Those are not "real" kobjects, and are never registered with the kobject
> > core.
> > 
> > I really need to go rename those one of these days, and just make them a
> > separate object, as they have nothing to do with a "normal" kobject
> > other than the reference count and the use of the kobject map stuff.
> > 
> > So if this is showing up as a problem, something else is going on here,
> > as this should not be an issue at all.
> 
> As far as I decoded it from Vince traces the issue is only with
> DEBUG_KOBJECT_RELEASE=y. That deferres the release to a workqueue.
> 
> Now the cdevs in tty are allocated ahead and not freed on
> release. They stay in the cdevs[] array of the tty drivers.
> 
> Now if a cdev is released the kobject debug stuff schedules the
> delayed work, but the tty core can reuse the cdev.before the delayed
> work has been executed and first thing it does is calling cdev_init()
> which does a
> 
>      memset(cdev, 0, sizeof *cdev);
> 
> which of course includes the enqueued timer and the scheduled work. Go
> figure how well that goes.

Ugh, the kobject isn't "real", but it seems like it has changed over
time to be more real than I imagined.

I'll work to rip the kobject code out of the cdev soon, which should
resolve this issue, thanks.

greg k-h
