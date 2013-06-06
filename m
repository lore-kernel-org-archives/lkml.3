Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab3FFHJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:09:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47403 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3FFHI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:08:57 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-28-51b035883f45
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
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 1/5] cpufreq: Define cpufreq_set_drv_attr_files() to add per
 CPU sysfs attributes
Date: Thu, 06 Jun 2013 09:07:48 +0200
Message-id: <1370502472-7249-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd0O0w2BBk1zhS3+vF3OavG06Qe7
	xbzPshadZ58wW7x5xG3x5uFmRovLu+awWXzuPcJocbtxBZtF/8JeJouOI9+YLTZ+9XDg8bhz
	bQ+bx7ppb5k9+rasYvR4tLiF0ePzJrkA1igum5TUnMyy1CJ9uwSujK7f85gLfvFW7J2/gqmB
	cR13FyMHh4SAicTiVocuRk4gU0ziwr31bF2MXBxCAtMZJfadeQXldDFJfL35kA2kik1AT+Lz
	3adMILaIgK9Ez7JDYDazwElmibvHAkFsYYFkiWkfN4PVswioSnQ9eQRm8wq4SvTsOcIMsU1e
	4un9PrA4p4CbxNxPL8BsIaCamx9Wskxg5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	IzgAn0ntYFzZYHGIUYCDUYmHVyJgfaAQa2JZcWXuIUYJDmYlEd5YkQ2BQrwpiZVVqUX58UWl
	OanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhgnvZfX2jr5r+2rDS2h0vk8csvi
	tkgmr1c7Vfk58mFo2KHTH9b3sO9J79tu2mR9cKbEEYvSJUwJf6V/Zfzecu/1R16Viw45stdO
	3lO06zj6xfcH5y2HZe6v/5dyCV3Y3C9hJtg2OeqkW7rBbLfFGbe0bnH6bWhJ2dx6ta460Nv1
	rdPu253xs3SUWIozEg21mIuKEwEO/ot8PAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq_set_drv_attr_files() function creates sysfs file entry for
each available CPU. With it in place it is possible to add different
set of attributes without code duplication.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/cpufreq.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1b8a48e..ca74e27 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -730,12 +730,23 @@ static int cpufreq_add_dev_symlink(unsigned int cpu,
 	return ret;
 }
 
+static int cpufreq_set_drv_attr_files(struct cpufreq_policy *policy,
+				      struct freq_attr **drv_attr)
+{
+	while ((drv_attr) && (*drv_attr)) {
+		if (sysfs_create_file(&policy->kobj, &((*drv_attr)->attr)))
+			return 1;
+		drv_attr++;
+	}
+
+	return 0;
+}
+
 static int cpufreq_add_dev_interface(unsigned int cpu,
 				     struct cpufreq_policy *policy,
 				     struct device *dev)
 {
 	struct cpufreq_policy new_policy;
-	struct freq_attr **drv_attr;
 	unsigned long flags;
 	int ret = 0;
 	unsigned int j;
@@ -747,13 +758,9 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 		return ret;
 
 	/* set up files for this cpu device */
-	drv_attr = cpufreq_driver->attr;
-	while ((drv_attr) && (*drv_attr)) {
-		ret = sysfs_create_file(&policy->kobj, &((*drv_attr)->attr));
-		if (ret)
-			goto err_out_kobj_put;
-		drv_attr++;
-	}
+	if (cpufreq_set_drv_attr_files(policy, cpufreq_driver->attr))
+		goto err_out_kobj_put;
+
 	if (cpufreq_driver->get) {
 		ret = sysfs_create_file(&policy->kobj, &cpuinfo_cur_freq.attr);
 		if (ret)
-- 
1.7.10.4

