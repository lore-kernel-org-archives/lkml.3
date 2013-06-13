Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab3FMJQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:16:33 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:40890 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3FMJQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:16:31 -0400
MIME-Version: 1.0
In-Reply-To: <1371114118-19488-1-git-send-email-chenxg@marvell.com>
References: <1371114118-19488-1-git-send-email-chenxg@marvell.com>
Date: Thu, 13 Jun 2013 14:46:31 +0530
Message-ID: <CAKohpomDXmQ_DWpHgm1mD5WWUvBTjWXBPDp1KOWb1mff4UdX=g@mail.gmail.com>
Subject: Re: [PATCH v5] cpufreq: fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, njiang1@marvell.com, zjwu@marvell.com,
        ylmao@marvell.com, chenxg.marvell@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 June 2013 14:31, Xiaoguang Chen <chenxg@marvell.com> wrote:
> cpufreq governor stop and start should be kept in sequence.
> If not, there will be unexpected behavior, for example:
>
> we have 4 cpus and policy->cpu=cpu0, cpu1/2/3 are linked to cpu0.
> the normal sequence is as below:
>
> 1) Current governor is userspace, one application tries to set
> governor to ondemand. it will call __cpufreq_set_policy in which it
> will stop userspace governor and then start ondemand governor.
>
> 2) Current governor is userspace, now cpu0 hotplugs in cpu3, it will
> call cpufreq_add_policy_cpu. on which it first stops userspace
> governor, and then starts userspace governor.
>
> Now if the sequence of above two cases interleaves, it becames
> below sequence:
>
> 1) application stops userspace governor
> 2)                                      hotplug stops userspace governor
> 3) application starts ondemand governor
> 4)                                      hotplug starts a governor
>
> in step 4, hotplug is supposed to start userspace governor, but now
> the governor has been changed by application to ondemand, so hotplug
> starts ondemand governor again !!!!
>
> The solution is: do not allow stop one policy's governor multi-times
> Governor stop should only do once for one policy, after it is stopped,
> no other governor stop should be executed. also add one mutext to
> protect __cpufreq_governor so governor operation can be kept in sequence.
>
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> ---
>  drivers/cpufreq/cpufreq.c | 24 ++++++++++++++++++++++++
>  include/linux/cpufreq.h   |  1 +
>  2 files changed, 25 insertions(+)

I forgot to tell you earlier but please update changelog everytime you
send a new version.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
