Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaGCCTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 22:19:32 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:55684 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaGCCTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 22:19:30 -0400
MIME-Version: 1.0
In-Reply-To: <53B4A607.7030001@codeaurora.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
	<eb6df0f1f2c82db0d516b9b63820cfe0c0c97d5c.1404231535.git.viresh.kumar@linaro.org>
	<20140702055330.GA3454@dragon>
	<CAKohpomzPHRghqHD7-tDbj0gXzc=ANEb3qLv2kRKOZUyqatBew@mail.gmail.com>
	<CAKohpomk-pyv6Risyq_b8h3DJNGxBoUWu1Y9cApvoz3CwOtL=w@mail.gmail.com>
	<53B4A607.7030001@codeaurora.org>
Date: Thu, 3 Jul 2014 07:49:29 +0530
Message-ID: <CAKohpok0wt46-odR1+KiLLi9=iv+jvAozny9906UND6AgwBgJA@mail.gmail.com>
Subject: Re: [PATCH 06/14] cpufreq: cpu0: defer probe if clock isn't
 registered yet
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>, linux-arm-msm@vger.kernel.org,
        Sachin Kamat <spk.linux@gmail.com>,
        Thomas P Abraham <thomas.ab@samsung.com>, Nishanth Menon <nm@ti.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 July 2014 06:08, Stephen Boyd <sboyd@codeaurora.org> wrote:
> Please make this a dev_dbg() or just remove it entirely. Sending a
> message to the log on probe defer just duplicates what the driver core
> is already doing.

Updated as:

Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Thu Jun 26 10:40:21 2014 +0530

    cpufreq: cpu0: print relevant error when we defer probe

    Currently, we defer probe if regulator_get() returned -EPROBE_DEFER, i.e.
    regulator isn't registered yet. We do a dev_err() in this case. Sending a
    message to the log on probe defer just duplicates what the driver core is
    already doing. Convert it to dev_dbg() instead.

    We should defer in case of clk_get() as well.

    Current code already does it, but it wasn't intentional probably.
Its just that
    we are returning the right error with wrong print message.

    Fix print message to convey right error.

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 4273a5f..8a1166c 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -140,7 +140,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
                 * not yet registered, we should try defering probe.
                 */
                if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
-                       dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
+                       dev_dbg(cpu_dev, "cpu0 regulator not ready, retry\n");
                        ret = -EPROBE_DEFER;
                        goto out_put_node;
                }
@@ -151,7 +151,16 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
        cpu_clk = clk_get(cpu_dev, NULL);
        if (IS_ERR(cpu_clk)) {
                ret = PTR_ERR(cpu_clk);
-               pr_err("failed to get cpu0 clock: %d\n", ret);
+
+               /*
+                * If cpu's clk node is present, but clock is not yet
+                * registered, we should try defering probe.
+                */
+               if (ret == -EPROBE_DEFER)
+                       dev_dbg(cpu_dev, "cpu0 clock not ready, retry\n");
+               else
+                       dev_err(cpu_dev, "failed to get cpu0 clock: %d\n", ret);
+
                goto out_put_reg;
        }
