Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017Ab3FSRPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:15:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11500 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934961Ab3FSRNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:13:06 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-57-51c1e6a133f7
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH v4 1/7] cpufreq: Store cpufreq policies in a list
Date: Wed, 19 Jun 2013 19:12:42 +0200
Message-id: <1371661969-7660-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd2Fzw4GGvxq0bD483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbS43biCzaJ/YS+TxZOH
	fWwWHUe+MVts/OrhwO+xeM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSX
	TUpqTmZZapG+XQJXxtbNB9kLvvJV/Pxs3MB4haeLkZNDQsBEYtbtUywQtpjEhXvr2boYuTiE
	BKYzSlw70AjldDFJLNpynxGkik1AT+Lz3adMILaIgK9Ez7JDTCBFzAL7WCSmfutg7WLk4BAW
	cJRY8zIEpIZFQFXi0fUtYPW8Aq4SC3/OZ4XYJi/x9H4fG4jNKeAmcfxbF9SyRkaJtRseME9g
	5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhon0ntYFzZYHGIUYCDUYmHV+PywUAh
	1sSy4srcQ4wSHMxKIrxLjwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0t
	SC2CyTJxcEo1MB5l273YW2bl8WwHBesUx2UuvcKLXl6fviJdzaxyloQPa8GEH+aHJjcvkZfW
	XJR8sfuKdW+6u9NNzYeRO1ZOy4m8dNi45ukKid/RE4JPrnf7fmgu4/zwWecfrNl+ZONBw4Un
	F24MeX7JvD+Jv8Lj+jGO9j/bnh6Wb4mceb9o88xjDzNNQvl6pr5RYinOSDTUYi4qTgQAUOeD
	/VYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Policies available in a cpufreq framework are now linked together. They are
accessible via cpufreq_policy_list defined at cpufreq core.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Changes for v4:
- New patch
---
 drivers/cpufreq/cpufreq.c |    3 +++
 include/linux/cpufreq.h   |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2ce86ed..665e641 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -46,6 +46,7 @@ static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_RWLOCK(cpufreq_driver_lock);
+static LIST_HEAD(cpufreq_policy_list);
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -989,6 +990,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	}
 #endif
 
+	list_add(&policy->policy_list, &cpufreq_policy_list);
 	ret = cpufreq_add_dev_interface(cpu, policy, dev);
 	if (ret)
 		goto err_out_unregister;
@@ -1992,6 +1994,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
+	list_del(&cpufreq_policy_list);
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ab1932c..5348981 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -117,6 +117,7 @@ struct cpufreq_policy {
 
 	struct cpufreq_real_policy	user_policy;
 
+	struct list_head        policy_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 };
-- 
1.7.10.4

