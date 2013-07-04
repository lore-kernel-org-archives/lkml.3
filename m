Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab3GDIvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:51:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16694 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab3GDIu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:50:57 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-51-51d5376e4ec5
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v5 1/7] cpufreq: Store cpufreq policies in a list
Date: Thu, 04 Jul 2013 10:50:24 +0200
Message-id: <1372927830-2949-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jAd0886uBBls/yVv8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW7x5uJnR4vKuOWwWn3uPMFrcblzBZtG/sJfJ4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgyji/4zZTwTWBivnPP7M0MM7g62Lk5JAQMJF4ufAtG4QtJnHh3nogm4tDSGARo8Tb
	6+3sEE4Xk8T137dZQKrYBPQkPt99ygRiiwjMYZS4c9QdxGYWWMkscaLREcQWFnCU6F3+EayG
	RUBVYlbbCzCbV8BVYt+VeUwQ2+Qlnt7vA9vMKeAmcflCDxPEskZGiQ0dH1gmMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcrM+kdzCuarA4xCjAwajEwythdSVQiDWxrLgy9xCj
	BAezkgivE8fVQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2CyTByc
	Ug2MDRrf+ayuNKd67X/9MC1K2TWjkZdDOcyuyK3YeJZxr1H3MxkbwfcJN6tDdNkf3DPOq/lQ
	vPjgS/clsz6XZW9Qafj8cuWNlM7dZn+DBaPWu345px+81nXupqPqv5yLftZ8mKfyfgvbE1+V
	9/evW3BosnoKbXNnW62TeqrjHmuk9+eJfX4JGYlKLMUZiYZazEXFiQCTNXVNUgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Policies available in a cpufreq framework are now linked together. They are
accessible via cpufreq_policy_list defined at cpufreq core.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
Changes for v5:
- Call list_add() only when device successfully added
Changes for v4:
- New patch

 drivers/cpufreq/cpufreq.c |    3 +++
 include/linux/cpufreq.h   |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0937b8d..420ccb5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -46,6 +46,7 @@ static struct cpufreq_driver *cpufreq_driver;
 static DEFINE_PER_CPU(struct cpufreq_policy *, cpufreq_cpu_data);
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 static DEFINE_MUTEX(cpufreq_governor_lock);
+static LIST_HEAD(cpufreq_policy_list);
 
 #ifdef CONFIG_HOTPLUG_CPU
 /* This one keeps track of the previously set governor of a removed CPU */
@@ -1054,6 +1055,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	if (ret)
 		goto err_out_unregister;
 
+	list_add(&policy->policy_list, &cpufreq_policy_list);
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
 	module_put(cpufreq_driver->owner);
 	pr_debug("initialization complete\n");
@@ -2056,6 +2058,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 	subsys_interface_unregister(&cpufreq_interface);
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
+	list_del(&cpufreq_policy_list);
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 90d5a15..d8e30fc 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -117,6 +117,7 @@ struct cpufreq_policy {
 
 	struct cpufreq_real_policy	user_policy;
 
+	struct list_head        policy_list;
 	struct kobject		kobj;
 	struct completion	kobj_unregister;
 	int			transition_ongoing; /* Tracks transition status */
-- 
1.7.10.4

