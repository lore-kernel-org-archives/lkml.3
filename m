Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaD1TZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:25:24 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53994 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaD1TZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:25:14 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 1/5] cpufreq,
 longhaul: Fix double invocation of cpufreq_freq_transition_begin/end
To: rjw@rjwysocki.net, mroos@linux.ee, viresh.kumar@linaro.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Date: Tue, 29 Apr 2014 00:24:09 +0530
Message-ID: <20140428185403.28755.99738.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
References: <20140428185331.28755.899.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042818-0260-0000-0000-000004D86B30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During frequency transitions, the cpufreq core takes the responsibility of
invoking cpufreq_freq_transition_begin() and cpufreq_freq_transition_end()
for those cpufreq drivers that define the ->target_index callback but don't
set the ASYNC_NOTIFICATION flag.

The longhaul cpufreq driver falls under this category, but this driver was
invoking the _begin() and _end() APIs itself around frequency transitions,
which led to double invocation of the _begin() API. The _begin API makes
contending callers wait until the previous invocation is complete. Hence,
the longhaul driver ended up waiting on itself, leading to system hangs
during boot.

Fix this by removing the calls to the _begin() and _end() APIs from the
longhaul driver, since they rightly belong to the cpufreq core.

(Note that during module_exit(), the longhaul driver sets the frequency
 without any help from the cpufreq core. So add explicit calls to the
 _begin() and _end() APIs around that frequency transition alone, to take
 care of that special case.)

Reported-and-Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/longhaul.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index d00e5d1..5c4369b 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -242,7 +242,7 @@ static void do_powersaver(int cx_address, unsigned int mults_index,
  * Sets a new clock ratio.
  */
 
-static void longhaul_setstate(struct cpufreq_policy *policy,
+static int longhaul_setstate(struct cpufreq_policy *policy,
 		unsigned int table_index)
 {
 	unsigned int mults_index;
@@ -258,10 +258,12 @@ static void longhaul_setstate(struct cpufreq_policy *policy,
 	/* Safety precautions */
 	mult = mults[mults_index & 0x1f];
 	if (mult == -1)
-		return;
+		return -EINVAL;
+
 	speed = calc_speed(mult);
 	if ((speed > highest_speed) || (speed < lowest_speed))
-		return;
+		return -EINVAL;
+
 	/* Voltage transition before frequency transition? */
 	if (can_scale_voltage && longhaul_index < table_index)
 		dir = 1;
@@ -269,8 +271,6 @@ static void longhaul_setstate(struct cpufreq_policy *policy,
 	freqs.old = calc_speed(longhaul_get_cpu_mult());
 	freqs.new = speed;
 
-	cpufreq_freq_transition_begin(policy, &freqs);
-
 	pr_debug("Setting to FSB:%dMHz Mult:%d.%dx (%s)\n",
 			fsb, mult/10, mult%10, print_speed(speed/1000));
 retry_loop:
@@ -385,12 +385,14 @@ retry_loop:
 			goto retry_loop;
 		}
 	}
-	/* Report true CPU frequency */
-	cpufreq_freq_transition_end(policy, &freqs, 0);
 
-	if (!bm_timeout)
+	if (!bm_timeout) {
 		printk(KERN_INFO PFX "Warning: Timeout while waiting for "
 				"idle PCI bus.\n");
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
 /*
@@ -631,9 +633,10 @@ static int longhaul_target(struct cpufreq_policy *policy,
 	unsigned int i;
 	unsigned int dir = 0;
 	u8 vid, current_vid;
+	int retval = 0;
 
 	if (!can_scale_voltage)
-		longhaul_setstate(policy, table_index);
+		retval = longhaul_setstate(policy, table_index);
 	else {
 		/* On test system voltage transitions exceeding single
 		 * step up or down were turning motherboard off. Both
@@ -648,7 +651,7 @@ static int longhaul_target(struct cpufreq_policy *policy,
 		while (i != table_index) {
 			vid = (longhaul_table[i].driver_data >> 8) & 0x1f;
 			if (vid != current_vid) {
-				longhaul_setstate(policy, i);
+				retval = longhaul_setstate(policy, i);
 				current_vid = vid;
 				msleep(200);
 			}
@@ -657,10 +660,11 @@ static int longhaul_target(struct cpufreq_policy *policy,
 			else
 				i--;
 		}
-		longhaul_setstate(policy, table_index);
+		retval = longhaul_setstate(policy, table_index);
 	}
+
 	longhaul_index = table_index;
-	return 0;
+	return retval;
 }
 
 
@@ -968,7 +972,15 @@ static void __exit longhaul_exit(void)
 
 	for (i = 0; i < numscales; i++) {
 		if (mults[i] == maxmult) {
+			struct cpufreq_freqs freqs;
+
+			freqs.old = policy->cur;
+			freqs.new = longhaul_table[i].frequency;
+			freqs.flags = 0;
+
+			cpufreq_freq_transition_begin(policy, &freqs);
 			longhaul_setstate(policy, i);
+			cpufreq_freq_transition_end(policy, &freqs, 0);
 			break;
 		}
 	}

