Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaE1RWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:22:41 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:36656 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaE1RWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:22:40 -0400
Message-ID: <53861B5D.2040406@linaro.org>
Date: Wed, 28 May 2014 10:22:37 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>,
        Stanislav Meduna <stano@meduna.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] tracing: Don't account for cpu idle time with irqsoff
 tracers
References: <1401221284-13678-1-git-send-email-sboyd@codeaurora.org> <17051981.niWmA6MIgX@wuerfel> <20140527174847.7b405b5c@gandalf.local.home> <53850FF3.8050107@codeaurora.org> <20140527193050.4606a014@gandalf.local.home> <53852999.7060907@codeaurora.org> <1401237734.23277.1.camel@pippen.local.home> <20140528072457.GM11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140528072457.GM11096@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 12:24 AM, Peter Zijlstra wrote:
> On Tue, May 27, 2014 at 08:42:14PM -0400, Steven Rostedt wrote:
>> On Tue, 2014-05-27 at 17:11 -0700, Stephen Boyd wrote:
>>
>>> cpuidle_enter_state() calls ktime_get() which on lockdep enabled builds
>>> calls seqcount_lockdep_reader_access() which calls local_irq_save() that
>>
>> seqcount_lockdep_reader_access()?? Ug, I wonder if that should call
>> raw_local_irq_save/restore() as it's a lockdep helper to begin with. If
>> it's wrong then it's the lockdep infrastructure that broke, not the core
>> kernel.
>>
>> Peter?
>
> Hurm,.. don't know actually.. so from a lockdep pov it doesn't need to
> do that and we can simply remove the local_irq_{save,restore}() from
> that function.
>
> It could be John did it to avoid some IRQ recursion warning, but if so,
> he failed to mention it.
>
> John, remember why you typed those characters?

So.. With seqlocks, we're trying to just make sure reads and writes
don't nest under a write. However we don't care if a write nests in a
read, because the read will be restarted. An example is someone hitting
gettimeofday over and over taking a read, and then an IRQ lands mid-read
and we take the write and update the data. This is expected normal
behavior.  So this was trying to make the read side lockdep
aquire/release combo atomic, so we don't create false warnings if an IRQ
landed right in-between.

Does that make sense?

thanks
-john

