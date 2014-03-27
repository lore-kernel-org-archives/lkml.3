Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaC0EVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:21:07 -0400
Received: from smtp4out.l-3com.com ([128.170.207.112]:32387 "EHLO
	smtp4out.l-3com.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaC0EVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:21:05 -0400
X-filenames: 
X-filesizes: None
X-filetypes: 
X-IronPort-AV: E=Sophos;i="4.97,739,1389744000"; 
   d="scan'208";a="218929737"
X-IronPort-AV: E=Sophos;i="4.97,739,1389765600"; 
   d="scan'208";a="5282483"
From: <jimmie.davis@l-3com.com>
To: <luto@amacapital.net>, <umgwanakikbuti@gmail.com>
CC: <oneukum@suse.de>, <artem_fetishev@epam.com>, <peterz@infradead.org>,
        <kosaki.motohiro@jp.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: RE: Bug 71331 - mlock yields processor to lower priority process
Thread-Topic: Bug 71331 - mlock yields processor to lower priority process
Thread-Index: AQHPRNwZPC5PRgt+P0GtAN8yDFKRX5rrmJkA///XPHuAAG8YgP//rVNFgABlNQD//6xjLQEayuUAAAOtPtA=
Date: Thu, 27 Mar 2014 04:20:11 +0000
Message-ID: <FFF95760268D324AB6DD9426E83C8DF70B2E725C@ARLEXCHMBX01.lst.link.l-3com.com>
References: <20140321200248.GB6264@owamsq.epam.com>
	 ,<1395393822.6030.59.camel@marge.simpson.net>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>
	 ,<1395408925.9455.3.camel@linux-fkkt.site>
	 <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>,<1395412904.6030.126.camel@marge.simpson.net>
 <FFF95760268D324AB6DD9426E83C8DF70B2E595F@ARLEXCHMBX01.lst.link.l-3com.com>
 <5333734E.2020600@mit.edu>
In-Reply-To: <5333734E.2020600@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [130.210.49.246]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Andy Lutomirski [mailto:luto@amacapital.net] 
Sent: Wednesday, March 26, 2014 7:40 PM
To: Davis, Bud @ SSG - Link; umgwanakikbuti@gmail.com
Cc: oneukum@suse.de; artem_fetishev@epam.com; peterz@infradead.org; kosaki.motohiro@jp.fujitsu.com; linux-kernel@vger.kernel.org
Subject: Re: Bug 71331 - mlock yields processor to lower priority process

On 03/21/2014 07:50 AM, jimmie.davis@l-3com.com wrote:
> 
> ________________________________________
> From: Mike Galbraith [umgwanakikbuti@gmail.com]
> Sent: Friday, March 21, 2014 9:41 AM
> To: Davis, Bud @ SSG - Link
> Cc: oneukum@suse.de; artem_fetishev@epam.com; peterz@infradead.org; kosaki.motohiro@jp.fujitsu.com; linux-kernel@vger.kernel.org
> Subject: RE: Bug 71331 - mlock yields processor to lower priority process
> 
> On Fri, 2014-03-21 at 14:01 +0000, jimmie.davis@l-3com.com wrote:
> 
>> If you call mlock () from a SCHED_FIFO task, you expect it to return
>> when done.  You don't expect it to block, and your task to be
>> pre-empted.
> 
> Say some of your pages are sitting in an nfs swapfile orbiting Neptune,
> how do they get home, and what should we do meanwhile?
> 
> -Mike
> 
> Two options.
> 
> #1. Return with a status value of EAGAIN.
> 
> or 
> 
> #2.  Don't return until you can do it.
> 
> If SCHED_FIFO is used, and mlock() is called, the intention of the user is very clear.  Run this task until
> it is completed or it blocks (and until a bit ago, mlock() did not block).
> 
> SCHED_FIFO users don't care about fairness.  They want the system to do what it is told.

I use mlock in real-time processes, but I do it in a separate thread.

Seriously, though, what do you expect the kernel to do?  When you call
mlock on a page that isn't present, the kernel will *read* that page.
mlock will, therefore, block until the IO finishes.

Some time around 3.9, the behavior changed a little bit: IIRC mlock used
to hold mmap_sem while sleeping.  Or maybe just mmap with MCL_FUTURE did
that.  In any case, the mlock code is less lock-happy than it was.  Is
it possible that you have two threads, and the non-mlock-calling thread
got blocked behind mlock, so it looked better?

--Andy

===================================================================================================================


Andy,

The example code submitted into bugzilla (chase back on the thread a bit, there is a reference) shows the problem.

Two threads, TaskA (high priority) and TaskB (low priority).  Assigned to the same processor, explicitly for the guarantee that only one of them can execute at a time.  TaskA becomes eligible to run.  As part of its processing ( which the normal end is a call to sem_wait() ), it calls mlock().  TaskA then blocks, and TaskB begins running.  But wait, the system is designed that TaskA will run until it is done (thus SCHED_FIFO and a priority less than TaskB).  TaskA, a higher priority task is suspended and TaskB starts running.  And in the code that lead me on this endeavor :) {consisting of a lot of Ada threads}, the result was a segfault due to half-processed data by TaskA.

This is what I call 'blocking'; the thread is no longer running and the scheduler puts someone else in the processor.  I don't mean 'takes a long time until it returns'.  Takes a long time is fine, the system design relies on priority based scheduling and cpu affinity to ensure ordered access to application data.

mlock() now blocks.  I don't care how long mlock() takes, what I care about is the lower priority process pre-empting me.  Only a limited number of syscalls block; those that do are documented and usually have a way to obtain blocking or non-blocking behavior.

Can I change the system to deal with mlock() being a blocking syscall ?  Yes, but this is a situation where working code, that meets the API has stopped working.

Thanks for looking at it.

Regards,
Bud Davis






