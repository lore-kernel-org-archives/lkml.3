Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbaBFT2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:28:42 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:52436 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbaBFT2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:28:40 -0500
Message-ID: <52F3E255.5050906@gmail.com>
Date: Thu, 06 Feb 2014 13:28:21 -0600
From: Tom Musta <tommusta@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Torsten Duwe <duwe@lst.de>
CC: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Convert powerpc simple spinlocks into ticket locks
References: <20140206103736.GA18054@lst.de> <20140206163837.GT2936@laptop.programming.kicks-ass.net> <20140206173727.GA13048@lst.de> <20140206180826.GI5002@laptop.programming.kicks-ass.net>
In-Reply-To: <20140206180826.GI5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/2014 12:08 PM, Peter Zijlstra wrote:
>>> Can you pair lwarx with sthcx ? I couldn't immediately find the answer
>>> > > in the PowerISA doc. If so I think you can do better by being able to
>>> > > atomically load both tickets but only storing the head without affecting
>>> > > the tail.
>> > 
>> > V2.06b, Book II, Chapter 3, "sthcx" says:
>> > | If a reservation exists and the length associated [...] is not 2 bytes,
>> > | it is undefined whether (RS)_48:63 are stored [...]
>> > 
>> > That doesn't make me feel comfortable :(
> That's on page 692, right? The way I read that is of the lharx/sthcx
> don't have the exact same address, storage is undefined. But I can't
> find mention of non-matching load and store size, although I can imagine
> it being the same undefined.

My read is consistent with Torsten's ... this looks like a bad idea.

Look at the RTL for sthcx. on page 692 (Power ISA V2.06) and you will see this:

if RESERVE then
  if RESERVE_LENGTH = 2 then
     ...
  else
     undefined_case <- 1
else
  ...

A legal implementation might never perform the store.



