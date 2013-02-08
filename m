Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab3BHAgE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:36:04 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:39350 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3BHAgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:36:00 -0500
MIME-Version: 1.0
In-Reply-To: <20130207223434.GG2545@linux.vnet.ibm.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	<1358896415-28569-2-git-send-email-walken@google.com>
	<20130207223434.GG2545@linux.vnet.ibm.com>
Date: Thu, 7 Feb 2013 16:35:59 -0800
Message-ID: <CANN689H30q1R=sjeBvUSoO+h+qydWTRd3e1U8YZ2GMYvr37dLQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
From: Michel Lespinasse <walken@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 2:34 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Jan 22, 2013 at 03:13:30PM -0800, Michel Lespinasse wrote:
>> Introduce queue spinlocks, to be used in situations where it is desired
>> to have good throughput even under the occasional high-contention situation.
>>
>> This initial implementation is based on the classic MCS spinlock,
>> because I think this represents the nicest API we can hope for in a
>> fast queue spinlock algorithm. The MCS spinlock has known limitations
>> in that it performs very well under high contention, but is not as
>> good as the ticket spinlock under low contention. I will address these
>> limitations in a later patch, which will propose an alternative,
>> higher performance implementation using (mostly) the same API.

While we're talking about MCS spinlocks, I should point out a
potential issue I found about my 'faster queue spinlock' proposed MCS
alternative. It is nice in that it avoids an atomic operation in the
unlock path; however each unlocked lock must have a 'token' allocated
and this token is accessed by the lock function. The issue with this
is that if two threads don't actually block on each other, but they
both access a lock that bounces between them, now the token will have
to bounce between these threads as well, which is going to be more
expansive than the atomic operation that was saved.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
