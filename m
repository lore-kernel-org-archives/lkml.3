Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3KOK1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:27:48 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50561 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3KOK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:27:37 -0500
MIME-Version: 1.0
In-Reply-To: <528502AC.4010604@ti.com>
References: <1382638087-32054-1-git-send-email-nm@ti.com>
	<CAKohponJOOfGX4BHn76LTBDTm58+2QxPf_rv1i4avVfrWhfkRg@mail.gmail.com>
	<52824522.7020401@ti.com>
	<CAKohpomB=wnct88wrTvW-qixLQPQGjVrCVF3V-BSbY7mhsSYQg@mail.gmail.com>
	<20131113151645.GA17828@kahuna>
	<52842671.40703@linaro.org>
	<5284DDB9.7040502@ti.com>
	<5284FE48.8040802@linaro.org>
	<528502AC.4010604@ti.com>
Date: Fri, 15 Nov 2013 15:57:36 +0530
Message-ID: <CAKohpokz6YEqz8ZNmQ77y8K3qvKYu3ffgVmiEcDyh2M9FsDGPg@mail.gmail.com>
Subject: Re: [RFC PATCH] cpufreq: cpufreq-cpu0: do not allow transitions with
 regulators suspended
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 November 2013 22:34, Nishanth Menon <nm@ti.com> wrote:
> I think it is still too early to do so :(

:)

> equivalent patch: http://pastebin.mozilla.org/3603467 (with minor
> changes for build)
>
> Basic tests: http://pastebin.mozilla.org/3603456 (governor is
> functional, but governor kicks in early before i2c is resumed)
>
> With call stack: http://pastebin.mozilla.org/3603455 to highlight call
> sequences
>
> Seems like we might want to pause governor as early in the suspend
> sequence as possible to allow SoC and regulator stuff to suspend
> themselves without cpufreq interfering.. just my 2 cents..

You made me spend a day on this :)
It wasn't a day's job really but I got into a really hard to crack bug with my
patch, I was calling __cpufreq_governor() from under write_lock_irqsave
for cpufreq_driver_lock. And __cpufreq_governor() had:

 read_lock_irqsave(&cpufreq_driver_lock, flags);

I wasn't able to suspend my system: ARM, X86.. It simply stopped
printing anything and I didn't had a clue of what's going on.. Hacked
everything possible, even kernel/power/suspend.c to return early
(yeah I used freezer > pm_test as well, but I wanted to return before
freezing userspace)...

Then somehow I got to know that this is the wrong piece of code :)

But probably I have a solution now to which you can't say:

"I think it is still too early to do so :("

:)

Give it a try and give a Tested-by please :)
