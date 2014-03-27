Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaC0GDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 02:03:12 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33401 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaC0GC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 02:02:56 -0400
Message-ID: <5333BF0C.2030102@gmail.com>
Date: Thu, 27 Mar 2014 00:02:52 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: jimmie.davis@l-3com.com, umgwanakikbuti@gmail.com
CC: oneukum@suse.de, artem_fetishev@epam.com, peterz@infradead.org,
        kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: Bug 71331 - mlock yields processor to lower priority process
References: <20140321200248.GB6264@owamsq.epam.com>	 ,<1395393822.6030.59.camel@marge.simpson.net>	 <FFF95760268D324AB6DD9426E83C8DF70B2E5870@ARLEXCHMBX01.lst.link.l-3com.com>	 ,<1395408925.9455.3.camel@linux-fkkt.site>	 <FFF95760268D324AB6DD9426E83C8DF70B2E58FB@ARLEXCHMBX01.lst.link.l-3com.com>,<1395412904.6030.126.camel@marge.simpson.net> <FFF95760268D324AB6DD9426E83C8DF70B2E595F@ARLEXCHMBX01.lst.link.l-3com.com>
In-Reply-To: <FFF95760268D324AB6DD9426E83C8DF70B2E595F@ARLEXCHMBX01.lst.link.l-3com.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/14 08:50 AM, jimmie.davis@l-3com.com wrote:>
 > ________________________________________
 > From: Mike Galbraith [umgwanakikbuti@gmail.com]
 > Sent: Friday, March 21, 2014 9:41 AM
 > To: Davis, Bud @ SSG - Link
 > Cc: oneukum@suse.de; artem_fetishev@epam.com; peterz@infradead.org; 
kosaki.motohiro@jp.fujitsu.com; linux-kernel@vger.kernel.org
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
 > If SCHED_FIFO is used, and mlock() is called, the intention of the 
user is very clear.  Run this task until
 > it is completed or it blocks (and until a bit ago, mlock() did not 
block).

Returning EAGAIN is not something that the API definition from POSIX 
allows for, that is only for indicating a failure. If the memory that is 
being locked is not currently residing in RAM, then the memory will need 
to be swapped in before the call returns, which clearly cannot be done 
without blocking. Thus mlock can potentially block, which has not 
changed. Whether or not any kernel behavior has changed to cause this to 
happen in some cases where it didn't previously, the fact remains that 
this is allowed behavior.

Generally real-time applications should not be doing mlock calls during 
their real-time execution for that reason. The required memory regions 
should be locked during startup so that this kind of execution delay can 
be avoided at runtime.

 >
 > SCHED_FIFO users don't care about fairness.  They want the system to 
do what it is told.
 >
 > regards,
 > Bud Davis
 >
 >
 >
 >
 >
 >
 >
 >
 >

