Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaCIWxm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 18:53:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36833 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaCIWxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 18:53:40 -0400
Date: Sun, 09 Mar 2014 18:53:38 -0400 (EDT)
Message-Id: <20140309.185338.2057082497431220324.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: mkl@pengutronix.de, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] net: sched: dev_deactivate_many(): use msleep(1)
 instead of yield() to wait for outstanding qdisc_run calls
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394392160.15968.13.camel@deadeye.wl.decadent.org.uk>
References: <1393976987-23555-1-git-send-email-mkl@pengutronix.de>
	<20140306.160622.59358366688518505.davem@davemloft.net>
	<1394392160.15968.13.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Mar 2014 15:53:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 09 Mar 2014 19:09:20 +0000

> On Thu, 2014-03-06 at 16:06 -0500, David Miller wrote:
>> From: Marc Kleine-Budde <mkl@pengutronix.de>
>> Date: Wed,  5 Mar 2014 00:49:47 +0100
>> 
>> > @@ -839,7 +839,7 @@ void dev_deactivate_many(struct list_head *head)
>> >       /* Wait for outstanding qdisc_run calls. */
>> >       list_for_each_entry(dev, head, unreg_list)
>> >               while (some_qdisc_is_busy(dev))
>> > -                     yield();
>> > +                     msleep(1)
>> >  }
>> 
>> I don't understand this.
>> 
>> yield() should really _mean_ yield.
>> 
>> The intent of a yield() call, like this one here, is unambiguously
>> that the current thread cannot do anything until some other thread
>> gets onto the cpu and makes forward progress.
>>
>> Therefore it should allow lower priority threads to run, not just
>> equal or higher priority ones.
> 
> Until when?
> 
> yield() is not a sensible operation in a preemptive multitasking system,
> regardless of RT.

To me it means "I've got nothing to do if other tasks want to run right
now"  Yes, I even see it having this meaning when an RT task executes
it.

How else can you interpret the intent above?

If you change it to msleep(1), you're assigning an extra completely
arbitrary time limit to the yield.  The code doesn't want to sleep
for 1ms, that's not what it's asking for.

On the other hand, I do completely agree with other replies stating
that it would be better if we found a way for this code to wait on
something explicitly via a wait queue.

Unfortunately, that's undesirable from another perspective, in that it
would probably require making the fast paths of the qdiscs more
expensive.
