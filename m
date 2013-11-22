Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3KVHDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:03:43 -0500
Received: from mail-qe0-f42.google.com ([209.85.128.42]:40465 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3KVHDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:03:40 -0500
Message-ID: <528F01C4.1050608@linaro.org>
Date: Fri, 22 Nov 2013 12:33:32 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: nm@ti.com
CC: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org, ceh@ti.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] cpufreq: Make sure CPU is running on a freq from freq-table
References: <de5c3ff26e9d06a6e0b06f8ba3da6d8c3ff82304.1385017369.git.viresh.kumar@linaro.org>
In-Reply-To: <de5c3ff26e9d06a6e0b06f8ba3da6d8c3ff82304.1385017369.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 November 2013 12:39 PM, Viresh Kumar wrote:
> Sometimes boot loaders set CPU frequency to a value outside of frequency table
> present with cpufreq core. In such cases CPU might be unstable if it has to run
> on that frequency for long duration of time and so its better to set it to a
> frequency which is specified in freq-table. This also makes cpufreq stats
> inconsistent as cpufreq-stats would fail to register because current frequency
> of CPU isn't found in freq-table.
> 
> Because we don't want this change to effect boot process badly, we go for the
> next freq which is >= policy->cur ('cur' must be set by now, otherwise we will
> end up setting freq to lowest of the table as 'cur' is initialized to zero).
> 
> In case where CPU is already running on one of the frequencies present in
> freq-table, this would turn into a dummy call as __cpufreq_driver_target() would
> return early.
> 
> Reported-by: Carlos Hernandez <ceh@ti.com>
> Reported-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Copying another mail from Nishant here to get my cc'list back..

On Friday 22 November 2013 05:12 AM, Nishanth Menon wrote:
> I gave this a quick run on my 3.12 kernel:
> http://pastebin.mozilla.org/3649730 is what I applied and output
> http://pastebin.mozilla.org/3649729
>
> I need to see what I might have mucked up.. or see if I can test this
> on 3.13 master on a different board (since OMAP5 wont boot in master
> without clock dts nodes :()..

This happened because of common sense, which was missing in my patch :)

Try this over existing patch:

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6e8b226..e403388 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1126,13 +1126,19 @@ static int __cpufreq_add_dev(struct device *dev, struct
subsys_interface *sif,
         * In case where CPU is already running on one of the frequencies
         * present in freq-table, this would turn into a dummy call as
         * __cpufreq_driver_target() would return early.
+        *
+        * We are passing target-freq as "policy->cur - 1" otherwise
+        * __cpufreq_driver_target() would simply fail, as policy->cur will be
+        * equal to target-freq.
         */
        if (has_target()) {
-               ret = __cpufreq_driver_target(policy, policy->cur,
+               ret = __cpufreq_driver_target(policy, policy->cur - 1,
                                CPUFREQ_RELATION_L);
-               if (ret)
+               if (ret) {
                        pr_err("%s: Unable to set frequency from table: %d\n",
                                        __func__, ret);
+                       goto err_out_unregister;
+               }
        }

        /* related cpus should atleast have policy->cpus */

