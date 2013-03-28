Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3C1NIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:08:40 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:64187 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3C1NIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130328073849.GA24433@gmail.com>
References: <1364398359-21990-1-git-send-email-fweisbec@gmail.com>
	<1364398359-21990-2-git-send-email-fweisbec@gmail.com>
	<20130328073849.GA24433@gmail.com>
Date: Thu, 28 Mar 2013 14:08:35 +0100
Message-ID: <CAFTL4hzfNdSb3+uOmTfGiH3mOsZcs0jtphUxLpSNs5VhsEb_ig@mail.gmail.com>
Subject: Re: [PATCH 1/4] nohz: Force boot CPU outside full dynticks range
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/28 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> The timekeeping job must be able to run early on boot
>> because there may be some pre-SMP (and thus pre-initcalls )
>> components that rely on it. The IO-APIC is one such users
>> as it tests the timer health by watching jiffies progression.
>
> Btw., while I agree that a conservative mode is probably wise for bootup,
> that IO-APIC assumption could be fixed or even removed.
>
> If the IO-APIC code wants to know whether an interrupt fired, it can take
> a look at the kstat_irqs numbers?

Good point. Still I need to let timekeeping working early to avoid
more surprises.

>
> Also, could we restrict the boot CPU's mode only during the early bootup
> stage - i.e. until we are ready to execute user-space init?

That's a tricky issue. Let's consider the boot CPU is the timekeeper
in the beginning. Later reassigning the timekeeping duty to another
CPU require some careful treatment because we may do that remotely and
we want to keep tick_do_timer_cpu lockless. This may involve an IPI
coupled with proper memory ordering if we don't want to race with
dynticks idle (or even full dynticks).

It's on the long term plan but I thought about dealing with that later
once we get the basic feature working. But if you prefer I can work on
that now.
