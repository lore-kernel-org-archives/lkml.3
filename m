Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3KYRCC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:02:02 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:51073 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3KYRB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:01:57 -0500
MIME-Version: 1.0
In-Reply-To: <52937D0C.1020501@gmail.com>
References: <046513da96dfec919a1a41d270c167147d4a9c8d.1385353358.git.viresh.kumar@linaro.org>
	<52937D0C.1020501@gmail.com>
Date: Mon, 25 Nov 2013 22:31:56 +0530
Message-ID: <CAKohpok0QJ2xP5uoSaAsX76KwD5yi9Z54pgNyQ7CW3c4Fkbq2A@mail.gmail.com>
Subject: Re: [PATCH V2] cpufreq: Make sure CPU is running on a freq from freq-table
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Carlos Hernandez <ceh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2013 22:08, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
> IMHO this issue should be fixed in the scaling driver for the platform.
>
> The scaling driver sets policy->cur and fills in the frequency table and has

Not anymore, policy->cur is set in the core for most of the drivers now.
Drivers just provide ->get() callbacks.

> the ability to adjust the frequency of the CPU.

I believe this kind of decisions should stay with the core, drivers should
just provide the backend instead of intelligence..

> Letting this leak up into the core
> is wrong IMHO and just widens the window where the CPU will be running at
> the wrong frequency set by the bootloader.

It doesn't stay there for long enough.. we get to this point in
cpufreq core just
after calling ->init(), and if the CPU is working without issues until
now, it will
stay stable for few more milliseconds.

> Shouldn't there be a check to see if the problem exists at all?  Otherwise
> the core is setting a policy for ALL platform even those where the issue
> does
> not exist.

That is taken care of by __cpufreq_driver_target(). It checks if we are
already running at requested frequency or not (after getting the next
higher frequency)... If current freq is present in table,
cpufreq_frequency_table_target() will return current frequency only for
policy->cur -1. And so we will not end up configuring hardware
unnecessarily.
