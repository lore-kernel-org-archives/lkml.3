Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaFQMm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:42:29 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56969 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbaFQMm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:42:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140617121535.GY6758@twins.programming.kicks-ass.net>
References: <20131212140835.729222186@infradead.org>
	<20131212141655.238445339@infradead.org>
	<CAOh2x=mgeozUMGYQubQ4GKPEB6k_TkcV3CSTzNLqjKok-gROQg@mail.gmail.com>
	<20140617121535.GY6758@twins.programming.kicks-ass.net>
Date: Tue, 17 Jun 2014 18:12:27 +0530
Message-ID: <CAKohpo=6t-VHgJfrq7wz35y_zKfL+wb8amgj0ZV9cezb39r=uA@mail.gmail.com>
Subject: Re: [PATCH 11/15] x86: Rewrite cyc2ns to avoid the need to disable IRQs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        registosites@hotmail.com, "Srivatsa S. Bhat" <srivatsa@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 June 2014 17:45, Peter Zijlstra <peterz@infradead.org> wrote:
> Ah, just a freeze?

As per what he reported and his screen dumps, looks like yes a
freeze. IOW, no prints at all on terminal, even the ones issued
before reaching set_cyc2ns_scale()..

>> CPUs: Only two CPUs, sharing clock line
>
> What's specific to this particular CPU?

You meant why I mentioned this information? Nothing specific
actually, just mentioned it to make all information available that
might be useful .. Probably its not :)

> So what you can try is force a cyc2ns read before the write in
> set_cyc2ns_scale(). I think its possible that if we do not do the read,
> the write will wait for a 'free' slot indefinitely.

Hmm, I see. Thanks for your quick response.

Are you suggesting something like this ? :

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57e5ce1..290ac03 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -249,6 +249,9 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
        if (!cpu_khz)
                goto done;

+       data = cyc2ns_read_begin();
+       cyc2ns_read_end(data);
+
        data = cyc2ns_write_begin(cpu);

        rdtscll(tsc_now);


@Mauro: Please try this once Peter confirms.

--
viresh
