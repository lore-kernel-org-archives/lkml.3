Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaILXHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:07:52 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:62709 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaILXHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:07:16 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/13] eeepc-laptop: make fan1_input really read-only
Date: Sat, 13 Sep 2014 01:06:48 +0200
Message-Id: <1410563212-31565-10-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the instantiation of the fan1_input device attribute, NULL is passed
as set function to store_sys_hwmon. The function pointer is never
checked before dereferencing it. This is fine if we can guarantee that
it will never be called with an invalid pointer, but we can't. If
someone from user space decides to change the permissions on this
attribute and write to it, kernel will crash.

Introduce EEEPC_CREATE_SENSOR_ATTR_RO() to instantiate a read-only
attribute, and declare fan1_input with it. This ensures store_sys_hwmon
is never called with NULL parameters. If someone tries to write the
attribute, the system will at least keep its sanity.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index fbaa4d5..47488d3 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1060,7 +1060,11 @@ static ssize_t show_sys_hwmon(int (*get)(void), char *buf)
 	EEEPC_SENSOR_STORE_FUNC(_name, _set)				\
 	static DEVICE_ATTR(_name, _mode, show_##_name, store_##_name)
 
-EEEPC_CREATE_SENSOR_ATTR(fan1_input, S_IRUGO, eeepc_get_fan_rpm, NULL);
+#define EEEPC_CREATE_SENSOR_ATTR_RO(_name, _mode, _get)			\
+	EEEPC_SENSOR_SHOW_FUNC(_name, _get)				\
+	static DEVICE_ATTR(_name, _mode, show_##_name, NULL)
+
+EEEPC_CREATE_SENSOR_ATTR_RO(fan1_input, S_IRUGO, eeepc_get_fan_rpm);
 EEEPC_CREATE_SENSOR_ATTR(pwm1, S_IRUGO | S_IWUSR,
 			 eeepc_get_fan_pwm, eeepc_set_fan_pwm);
 EEEPC_CREATE_SENSOR_ATTR(pwm1_enable, S_IRUGO | S_IWUSR,
-- 
2.1.0

