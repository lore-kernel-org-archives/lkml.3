Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934153Ab3FSHzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 03:55:39 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36461 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933811Ab3FSHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 03:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <1371625207-26702-1-git-send-email-chenxg@marvell.com>
References: <1371625207-26702-1-git-send-email-chenxg@marvell.com>
Date: Wed, 19 Jun 2013 13:25:36 +0530
Message-ID: <CAKohponDRcfHyRA-JCW01SC8R-dDiOx1dzBcOU6ag2DUa5_DyA@mail.gmail.com>
Subject: Re: [PATCH v9] Cpufreq: Fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, njiang1@marvell.com, zjwu@marvell.com,
        ylmao@marvell.com, chenxg.marvell@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 12:30, Xiaoguang Chen <chenxg@marvell.com> wrote:
> Cpufreq governor's stop and start operation should be kept in sequence.
> If not, there will be unexpected behavior, for example:
>
> There are 4 CPUs and policy->cpu=CPU0, CPU1/2/3 are linked to CPU0.
> The normal sequence is as below:
>
> 1) Current governor is userspace, One application tries to set
> governor to ondemand. It will call __cpufreq_set_policy in which it
> will stop userspace governor and then start ondemand governor.
>
> 2) Current governor is userspace, Now CPU0 hotplugs in CPU3 (put CPU3 online),
> It will call cpufreq_add_policy_cpu in which it first stops userspace
> governor, and then starts userspace governor.
>
> Now if the sequence of above two cases interleaves, It becomes like below:
>
> 1) Application stops userspace governor
> 2)                                      Hotplug stops userspace governor
> 3) Application starts ondemand governor
> 4)                                      Hotplug starts a governor
>
> In step 4, Hotplug is supposed to start userspace governor, But now
> the governor has been changed by application to ondemand, So hotplug
> starts ondemand governor again !!!!
>
> The solution is: Do not allow stop policy's governor multi-times.
> Governor should only be stopped once for one policy, After it is stopped,
> No other governor stop operation should be executed. also add one mutex to
> protect __cpufreq_governor so governor operation can be kept in sequence.
>
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 24 ++++++++++++++++++++++++
>  include/linux/cpufreq.h   |  1 +
>  2 files changed, 25 insertions(+)

All good now. Sorry for the noise :)
