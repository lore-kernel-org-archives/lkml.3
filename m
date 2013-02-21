Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3BUJZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:25:36 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48212 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3BUJZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:25:33 -0500
X-IronPort-AV: E=Sophos;i="4.84,706,1355126400"; 
   d="scan'208";a="26282408"
Message-ID: <5125E809.4060407@codeaurora.org>
Date: Thu, 21 Feb 2013 01:25:29 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: mm-commits@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: mmotm 2013-02-19-17-20 uploaded
References: <20130220012122.870BB31C11E@corp2gmr1-1.hot.corp.google.com>
In-Reply-To: <20130220012122.870BB31C11E@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/2013 5:21 PM, akpm@linux-foundation.org wrote:
> * timer_list-split-timer_list_show_tickdevices.patch
> * timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
> * timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
> * timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch
> * timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
> * timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch

These commits seem to break the timer list on devices with maxcpus !=
nr_cpu_ids, which is possible if you specify maxcpus on the kernel
command line. I no longer see the percpu devices that I normally have
after the broadcast device.

I also notice what looks like an extra newline inserted in the output
between the percpu devices and the broadcast device, which may not be
intentional. There are also some more spelling mistakes in the comments.
Can we fold in this fix on top of the others (hopefully not white-space
damaged)?

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 9904e48..e3cb935 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -244,7 +244,6 @@ static void timer_list_show_tickdevices_header(struct seq_file *m)
 #endif
 	SEQ_printf(m, "\n");
 #endif
-	SEQ_printf(m, "\n");
 }
 #endif
 
@@ -275,7 +274,7 @@ static int timer_list_show(struct seq_file *m, void *v)
 }
 
 /*
- * This itererator really needs some explnation since it is offset and has
+ * This iterator really needs some explanation since it is offset and has
  * two passes, one of which is controlled by a config option.
  * In a hotplugged system some cpus, including cpu 0, may be missing so we have
  * to use cpumask_* to iterate over the cpus.
@@ -283,7 +282,7 @@ static int timer_list_show(struct seq_file *m, void *v)
  * It returns 1 for the header position.
  * For cpu 0 it returns 2 and the final possible cpu would be nr_cpu_ids + 1.
  * On the second pass:
- * It returnes nr_cpu_ids + 1 for the second header position.
+ * It returns nr_cpu_ids + 1 for the second header position.
  * For cpu 0 it returns nr_cpu_ids + 2
  * The final possible cpu would be nr_cpu_ids + nr_cpu_ids + 2.
  */
@@ -300,8 +299,12 @@ static void *timer_list_start(struct seq_file *file, loff_t *offset)
 			n = cpumask_next(n - 1, cpu_online_mask);
 		else
 			n = cpumask_first(cpu_online_mask);
-		*offset = n + 1;
-		return (void *)(unsigned long)(n + 2);
+		if (n < nr_cpu_ids) {
+			*offset = n + 1;
+			return (void *)(unsigned long)(n + 2);
+		} else {
+			*offset = n = nr_cpu_ids + 1;
+		}
 	}
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
@@ -314,8 +317,10 @@ static void *timer_list_start(struct seq_file *file, loff_t *offset)
 			n = cpumask_next(n - 1, cpu_online_mask);
 		else
 			n = cpumask_first(cpu_online_mask);
-		*offset = n + 2 + nr_cpu_ids;
-		return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
+		if (n < nr_cpu_ids) {
+			*offset = n + 2 + nr_cpu_ids;
+			return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
+		}
 	}
 #endif
 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

