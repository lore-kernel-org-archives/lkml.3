Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3LLOsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:48:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:41461 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3LLOsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:48:21 -0500
Message-ID: <52A9CCA6.6040806@windriver.com>
Date: Thu, 12 Dec 2013 09:48:06 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue implementation
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com> <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com> <20131212080314.GA25783@infradead.org> <alpine.DEB.2.02.1312121147130.28330@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1312121147130.28330@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-12 05:56 AM, Thomas Gleixner wrote:
> On Thu, 12 Dec 2013, Christoph Hellwig wrote:
> 
>> On Wed, Dec 11, 2013 at 08:06:37PM -0500, Paul Gortmaker wrote:
>>> From: Thomas Gleixner <tglx@linutronix.de>
>>>
>>> The wait_queue is a swiss army knife and in most of the cases the
>>> full complexity is not needed.  Here we provide a slim version, as
>>> it lowers memory consumption and runtime overhead.
>>
>> Might it make more sense to just make the simple one the default and use
>> the complex one in the few cases that need it?
> 
> Sure.

The one major downside of doing it that way, is that it becomes
a flag day event instead of a gradual roll out.  Any unexpected
fallout will bisect to the one commit, which kind of would suck,
if we happen to trigger something kooky like the 50w mwait issue,
or break the usb stack somehow.

If we do the flag day type change, where complex wait is what we
have currently, and simple wait is the default, then I guess the
logistics would be something like:

1) git mv wait.[ch] --- > cwait.[ch]
   make an empty wait.h include cwait.h temporarily

2) rename all existing functions in cwait.[ch] to have an added
  "c" prefix (or similar)
   
   in wait.h, temporarily add a bunch of things like
          #define wait_xyz  cwait_xyz
   so that things still compile and link.

3) track down the users who really need the extra complexity
   and have them use cwait calls and include cwait.h

4) bring in the simple wait queue support as wait.c and wait.h
   and delete the defines added in step two.  This will be the
   flag day commit.

Is that what we want to do here?

Paul.
--

>  
>> It would also be good to enumerate those cases.  The wake callbacks come
>> to mind, but I guess there are more?
> 
> You can convert everything which uses default_wake_function and does
> not use the exclusive wait trickery.
> 
> Thanks,
> 
> 	tglx
> 
