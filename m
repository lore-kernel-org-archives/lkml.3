Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbaJ1Gcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:32:42 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39098 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493AbaJ1DvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:51:25 -0400
MIME-Version: 1.0
In-Reply-To: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org>
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org>
Date: Tue, 28 Oct 2014 09:21:25 +0530
Message-ID: <CAM4v1pOg1GFW82WD8b6Vas5xhYQrQtdP1STGxyzYtrBNSa+-Pw@mail.gmail.com>
Subject: Re: [PATCH V2 1/5] sched: idle: cpuidle: Check the latency req before idle
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org, Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thu, Oct 23, 2014 at 2:31 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> When the pmqos latency requirement is set to zero that means "poll in all the
> cases".
>
> That is correctly implemented on x86 but not on the other archs.
>
> As how is written the code, if the latency request is zero, the governor will
> return zero, so corresponding, for x86, to the poll function, but for the
> others arch the default idle function. For example, on ARM this is wait-for-
> interrupt with a latency of '1', so violating the constraint.

This is not true actually. On PowerPC the idle state 0 has an exit_latency of 0.

>
> In order to fix that, do the latency requirement check *before* calling the
> cpuidle framework in order to jump to the poll function without entering
> cpuidle. That has several benefits:

Doing so actually hurts on PowerPC. Because the idle loop defined for
idle state 0 is different from what cpu_relax() does in cpu_idle_loop().
The spinning is more power efficient in the former case. Moreover we also set
certain register values which indicate an idle cpu. The ppc_runlatch bits
do precisely this. These register values are being read by some user space
tools.  So we will end up breaking them with this patch

My suggestion is very well keep the latency requirement check in
kernel/sched/idle.c
like your doing in this patch. But before jumping to cpu_idle_loop verify if the
idle state 0 has an exit_latency > 0 in addition to your check on the
latency_req == 0.
If not, you can fall through to the regular path of calling into the
cpuidle driver.
The scheduler can query the cpuidle_driver structure anyway.

What do you think?

Regards
Preeti U Murthy
