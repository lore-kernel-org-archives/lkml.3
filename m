Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947491Ab3BIAI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:08:56 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39603 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947339Ab3BIAIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:08:54 -0500
Message-ID: <51159391.2020002@gmail.com>
Date: Fri, 08 Feb 2013 16:08:49 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, valdis.kletnieks@vt.edu,
        artem.savkov@gmail.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Nathan Zimmer <nzimmer@sgi.com>, dirk.brandewie@gmail.com
Subject: Re: [PATCH 0/4] CPUFreq Fixes for 3.9
References: <cover.1360232293.git.viresh.kumar@linaro.org> <CAKohpokp4YrxKHibewdt+3-WF7P2Fa_bvRidHpjd9SpsT6bPpw@mail.gmail.com> <1653071.l2kN4Hy2U6@vostro.rjw.lan> <2792362.JXCag4GJsR@vostro.rjw.lan>
In-Reply-To: <2792362.JXCag4GJsR@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 03:56 PM, Rafael J. Wysocki wrote:
> On Friday, February 08, 2013 09:02:37 PM Rafael J. Wysocki wrote:
>> On Friday, February 08, 2013 08:06:52 PM Viresh Kumar wrote:
>>> On 8 February 2013 18:02, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>> So as I said, please rework the fixes on top of linux-pm.git/pm-cpufreq.
>>>
>>> I already did. Please check for-rafael branch
>>
>> Cool.  This is the one I'm supposed to apply, then?
>
> OK, applied to bleeding-edge.  Hopefully it will be build-tested over the
> weekend and I can move it to linux-next.
>
> I dropped the rwlock/RCU patches from Nathan, though, because I had some
> doubts about the correctness of the RCU one and the rwlock one alone would
> conflict with your further changes.

One piece of fallout from dropping Nathan patches I had rebased mine on top of 
them.

This fixes the breakage do you want me to spin my patches or send this separately?:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0ebdf8c..a008b8e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1024,7 +1024,7 @@ static int __cpufreq_remove_dev(struct device *dev, struct
                 __cpufreq_governor(data, CPUFREQ_GOV_STOP);

  #ifdef CONFIG_HOTPLUG_CPU
-       if (!driver->setpolicy)
+       if (!cpufreq_driver->setpolicy)
                 strncpy(per_cpu(cpufreq_cpu_governor, cpu),
                         data->governor->name, CPUFREQ_NAME_LEN);
  #endif
@@ -1771,7 +1771,7 @@ int cpufreq_update_policy(unsigned int cpu)
                         pr_debug("Driver did not initialize current freq");
                         data->cur = policy.cur;
                 } else {
-                       if (data->cur != policy.cur && driver->target)
+                       if (data->cur != policy.cur && cpufreq_driver->target)
                                 cpufreq_out_of_sync(cpu, data->cur,
                                                                 policy.cur);
                 }

