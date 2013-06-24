Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3FXXZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:25:26 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:36288
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab3FXXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:25:24 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: pavel@ucw.cz, rjw@sisk.pl, len.brown@intel.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH v2] power: Add warning message about incorrect system date and time after resume when pm_trace is enabled
Date: Mon, 24 Jun 2013 17:25:18 -0600
Message-Id: <1372116318-10824-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pm_trace uses the system's Real Time Clock (RTC) to save the magic number.
Reason for this is that the RTC is the only reliably available piece of
hardware during resume operations where a value can be set that will
survive a reboot.

Consequence is that after a resume (even if it is successful) your system
clock will have a value corresponding to the magic number instead of the
correct date/time! It is therefore advisable to use a program like ntp-date
or rdate to reset the correct date/time from an external time source when
using this trace option.

There is no run-time message to warn users of the consequences of enabling
pm_trace. Adding a warning message to pm_trace_store() will serve as a
reminder to users to set the system date and time after resume.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 kernel/power/main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index d77663b..fd744d1 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -528,6 +528,8 @@ pm_trace_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 	if (sscanf(buf, "%d", &val) == 1) {
 		pm_trace_enabled = !!val;
+		pr_warn("PM: Enabling pm_trace changes system date and time after resume.\n");
+		pr_cont("PM: Remember to set correct time after resume\n");
 		return n;
 	}
 	return -EINVAL;
-- 
1.7.10.4

