Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaC0Ajq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:39:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57999 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaC0Ajp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:39:45 -0400
Message-ID: <5333734E.2020600@mit.edu>
Date: Wed, 26 Mar 2014 17:39:42 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: jimmie.davis@l-3com.com, umgwanakikbuti@gmail.com
CC: oneukum@suse.de, artem_fetishev@epam.com, peterz@infradead.org,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: Bug 71331 - mlock yields processor to lower priority process
References: <20140321200248.GB6264@owamsq.epam.com>	 ,<1395393822.6030.59.camel@marge.simpson.net>	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>	 ,<1395408925.9455.3.camel@linux-fkkt.site>	 <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>,<1395412904.6030.126.camel@marge.simpson.net> <FFF95760268D324AB6DD9426E83C8DF70B2E595F@ARLEXCHMBX01.lst.link.l-3com.com>
In-Reply-To: <FFF95760268D324AB6DD9426E83C8DF70B2E595F@ARLEXCHMBX01.lst.link.l-3com.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
