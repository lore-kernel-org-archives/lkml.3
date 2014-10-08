Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaJHHtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:49:32 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40106 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbaJHHt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:49:29 -0400
From: Mike Turquette <mturquette@linaro.org>
To: viresh.kumar@linaro.org
Cc: thomas.petazzoni@free-electrons.com, rjw@rjwysocki.net,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        shawn.guo@linaro.org, sboyd@codeaurora.org,
        linux-arm-msm@vger.kernel.org, spk.linux@gmail.com,
        pramod.gurav@smartplayin.com, rob.herring@linaro.org,
        ezequiel.garcia@free-electrons.com, tawfik@marvell.com,
        nadavh@marvell.com, alior@marvell.com, morten.rasmussen@arm.com,
        dietmar.eggemann@arm.com, vincent.guittot@linaro.org,
        nicolas.pitre@linaro.org, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 1/2] cpufreq: add driver flag for sleepable transitions
Date: Wed,  8 Oct 2014 00:48:53 -0700
Message-Id: <1412754534-14068-2-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412754534-14068-1-git-send-email-mturquette@linaro.org>
References: <CAKohpo=7q9bDcHRxLehNLX6A2idGxUy3jEWvQ+EGbKOQG-MH2g@mail.gmail.com>
 <1412754534-14068-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CPUfreq core does not differentiate between .target & .target_index
callbacks that may sleep or block and callbacks that are fast and return
immediately. To date this has not mattered much since the typical
CPUfreq governor calls the .target callback from process context via a
workqueue.

When calling the .target callback from a different context, such as a
scheduler load balance operation (see Morten's "energy aware scheduler"
RFC[0]), this detail matters.

This patch introduces a new CPUfreq driver flag for fast .target
callbacks that are guaranteed to neither sleep nor block. Setting this
flag allows for .target to be called from schedule() and other call
sites that have interrupts disabled or other constraints. Drivers may
set CPUFREQ_NO_SLEEP at driver registration-time.

The default is to not have this flag set, resulting in the need to defer
calls to .target and .target_index.

[0] http://lkml.kernel.org/r/<1381511957-29776-7-git-send-email-morten.rasmussen@arm.com>

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 include/linux/cpufreq.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 138336b..9034573 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -308,6 +308,19 @@ struct cpufreq_driver {
  */
 #define CPUFREQ_NEED_INITIAL_FREQ_CHECK	(1 << 5)
 
+/*
+ * Set by drivers whose .target or .target_index callback will never sleep or
+ * block. Setting this flag allows for more optimal code by calling .target
+ * from a context that otherwise would require deferring the work.
+ *
+ * An example use of this flag is when scaling cpu frequency from within a call
+ * to schedule() with interrupts disabled and runqueue locks held.
+ *
+ * This flag is not set by default, causing calls to .target to be done in
+ * process context.
+ */
+#define CPUFREQ_NO_SLEEP (1 << 6)
+
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
-- 
1.8.3.2

