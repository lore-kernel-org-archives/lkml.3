Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab3B0L3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:29:31 -0500
Received: from service87.mimecast.com ([91.220.42.44]:58087 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab3B0L33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:29:29 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] workqueue: define mod_scheduled_delayed_work[_on]() helpers
Date: Wed, 27 Feb 2013 16:59:10 +0530
Message-Id: <5249868a014d716eb38cc90e04ed0f6051e65fc3.1361964515.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 27 Feb 2013 11:29:23.0706 (UTC) FILETIME=[B16865A0:01CE14DD]
X-MC-Unique: 113022711292608901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1RBTw3S006740

The only difference between schedule_delayed_work[_on]() and
queue_delayed_work[_on]() is the workqueue, work is scheduled on. We may need to
modify the delay for works queued with schedule_delayed_work[_on]() calls and
thus adding these helpers.

First users of these new helpers is cpufreq governors which need to modify the
delay for its works.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/workqueue.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2b58905..864c2b3 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -412,6 +412,7 @@ extern bool schedule_delayed_work_on(int cpu, struct delayed_work *work,
 extern bool schedule_delayed_work(struct delayed_work *work,
 				  unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
+
 extern int keventd_up(void);
 
 int execute_in_process_context(work_func_t fn, struct execute_work *);
@@ -465,6 +466,11 @@ static inline long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg);
 #endif /* CONFIG_SMP */
 
+#define mod_scheduled_delayed_work_on(cpu, dwork, delay)	\
+	mod_delayed_work_on(cpu, system_wq, dwork, delay)
+#define mod_scheduled_delayed_work(dwork, delay)		\
+	mod_delayed_work(system_wq, dwork, delay)
+
 #ifdef CONFIG_FREEZER
 extern void freeze_workqueues_begin(void);
 extern bool freeze_workqueues_busy(void);
-- 
1.7.12.rc2.18.g61b472e


