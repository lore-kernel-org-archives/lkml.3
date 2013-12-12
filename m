Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab3LLOTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:19:38 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48738 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3LLOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:19:34 -0500
Message-ID: <52A9C5D9.9000207@windriver.com>
Date: Thu, 12 Dec 2013 09:19:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] wait-simple: Introduce the simple waitqueue implementation
References: <1386810399-8973-1-git-send-email-paul.gortmaker@windriver.com> <1386810399-8973-2-git-send-email-paul.gortmaker@windriver.com> <20131212111809.GF21999@twins.programming.kicks-ass.net> <20131212112020.GO3694@twins.programming.kicks-ass.net>
In-Reply-To: <20131212112020.GO3694@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-12-12 06:20 AM, Peter Zijlstra wrote:
> On Thu, Dec 12, 2013 at 12:18:09PM +0100, Peter Zijlstra wrote:
>> On Wed, Dec 11, 2013 at 08:06:37PM -0500, Paul Gortmaker wrote:

[...]

>>> +
>>> +unsigned int
>>> +__swake_up(struct swait_queue_head *head, unsigned int state, unsigned int num)
>>> +{
>>> +	unsigned long flags;
>>> +	int woken;
>>> +
>>> +	if (!swaitqueue_active(head))
>>> +		return 0;
>>> +
>>> +	raw_spin_lock_irqsave(&head->lock, flags);
>>> +	woken = __swake_up_locked(head, state, num);
>>> +	raw_spin_unlock_irqrestore(&head->lock, flags);
>>> +	return woken;
>>> +}
>>> +EXPORT_SYMBOL(__swake_up);
>>
>> Urgh, fail. Do not put unbounded loops in raw_spin_lock.
>>
>> I think I posted a patch a while back to cure this.
> 
> tada!
> 
> lkml.kernel.org/r/20131004145625.GN3081@twins.programming.kicks-ass.net

Yep, I linked to that at the bottom of the 0/3 -- I was still
hoping we could find a way to somehow do that w/o passing
the flags around between functions...  perhaps it isn't possible...
