Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230AbaGKNuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:50:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:56230 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaGKNo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:44:58 -0400
Message-Id: <20140711133708.592694569@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:44:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Jean Delvare <jdelvare@suse.de>
Subject: [patch 39/55] hwmon: ibmaem: Use ktime_get_ns()
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=hwmon-ibmaem-use-ktime.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the wall clock time for delta time calculations is wrong to
begin with because wall clock time can be set from userspace and NTP.
Such data wants to be based on clock monotonic.

The calcuations also are done on a nanosecond basis. Use the
nanoseconds based interface right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean Delvare <jdelvare@suse.de>
---
 drivers/hwmon/ibmaem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: tip/drivers/hwmon/ibmaem.c
===================================================================
--- tip.orig/drivers/hwmon/ibmaem.c
+++ tip/drivers/hwmon/ibmaem.c
@@ -842,11 +842,10 @@ static ssize_t aem_show_power(struct dev
 	struct aem_data *data = dev_get_drvdata(dev);
 	u64 before, after, delta, time;
 	signed long leftover;
-	struct timespec b, a;
 
 	mutex_lock(&data->lock);
 	update_aem_energy_one(data, attr->index);
-	getnstimeofday(&b);
+	time = ktime_get_ns();
 	before = data->energy[attr->index];
 
 	leftover = schedule_timeout_interruptible(
@@ -858,11 +857,10 @@ static ssize_t aem_show_power(struct dev
 	}
 
 	update_aem_energy_one(data, attr->index);
-	getnstimeofday(&a);
+	time = ktime_get_ns() - time;
 	after = data->energy[attr->index];
 	mutex_unlock(&data->lock);
 
-	time = timespec_to_ns(&a) - timespec_to_ns(&b);
 	delta = (after - before) * UJ_PER_MJ;
 
 	return sprintf(buf, "%llu\n",


