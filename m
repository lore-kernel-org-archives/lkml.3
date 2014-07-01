Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaGAKcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:32:35 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:53516 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbaGAKce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:32:34 -0400
Message-ID: <1404210751.2010.4.camel@x220>
Subject: [PATCH] eeepc-laptop: simplify parse_arg()
From: Paul Bolle <pebolle@tiscali.nl>
To: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 01 Jul 2014 12:32:31 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Jul 2014 10:32:31.0394 (UTC) FILETIME=[C382A820:01CF9517]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parse_arg() has three possible return values:
    -EINVAL if sscanf(), in short, fails;
    zero if "count" is zero; and
    "count" in all other cases

But "count" will never be zero. See, parse_arg() is called by the
various store functions. And the callchain of these functions starts
with sysfs_kf_write(). And that function checks for a zero "count". So
we can stop checking for a zero "count", drop the "count" argument
entirely, and transform parse_arg() into a function that returns zero on
success or a negative error. That, in turn, allows to make those store
functions just return "count" on success. The net effect is that the
code becomes a bit easier to understand.

A nice side effect is that this GCC warning is silenced too:
    drivers/platform/x86/eeepc-laptop.c: In function ‘store_sys_acpi’:
    drivers/platform/x86/eeepc-laptop.c:279:10: warning: ‘value’ may be used uninitialized in this function [-Wmaybe-uninitialized]
      int rv, value;

Which is, of course, the reason to have a look at parse_arg().

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested. I don't own an eeepc.

I do hope my reading of the code make sense. Ie, is it correct that
sysfs_kf_write() is at the start of all the sysfs writes involved?

 drivers/platform/x86/eeepc-laptop.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 9b0c57cd1d4a..a7ef834ffa39 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -263,13 +263,11 @@ static int acpi_setter_handle(struct eeepc_laptop *eeepc, int cm,
 /*
  * Sys helpers
  */
-static int parse_arg(const char *buf, unsigned long count, int *val)
+static int parse_arg(const char *buf, int *val)
 {
-	if (!count)
-		return 0;
 	if (sscanf(buf, "%i", val) != 1)
 		return -EINVAL;
-	return count;
+	return 0;
 }
 
 static ssize_t store_sys_acpi(struct device *dev, int cm,
@@ -278,12 +276,13 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
 	struct eeepc_laptop *eeepc = dev_get_drvdata(dev);
 	int rv, value;
 
-	rv = parse_arg(buf, count, &value);
-	if (rv > 0)
-		value = set_acpi(eeepc, cm, value);
+	rv = parse_arg(buf, &value);
+	if (rv < 0)
+		return rv;
+	value = set_acpi(eeepc, cm, value);
 	if (value < 0)
 		return -EIO;
-	return rv;
+	return count;
 }
 
 static ssize_t show_sys_acpi(struct device *dev, int cm, char *buf)
@@ -377,13 +376,13 @@ static ssize_t store_cpufv(struct device *dev,
 		return -EPERM;
 	if (get_cpufv(eeepc, &c))
 		return -ENODEV;
-	rv = parse_arg(buf, count, &value);
+	rv = parse_arg(buf, &value);
 	if (rv < 0)
 		return rv;
-	if (!rv || value < 0 || value >= c.num)
+	if (value < 0 || value >= c.num)
 		return -EINVAL;
 	set_acpi(eeepc, CM_ASL_CPUFV, value);
-	return rv;
+	return count;
 }
 
 static ssize_t show_cpufv_disabled(struct device *dev,
@@ -402,7 +401,7 @@ static ssize_t store_cpufv_disabled(struct device *dev,
 	struct eeepc_laptop *eeepc = dev_get_drvdata(dev);
 	int rv, value;
 
-	rv = parse_arg(buf, count, &value);
+	rv = parse_arg(buf, &value);
 	if (rv < 0)
 		return rv;
 
@@ -412,7 +411,7 @@ static ssize_t store_cpufv_disabled(struct device *dev,
 			pr_warn("cpufv enabled (not officially supported "
 				"on this model)\n");
 		eeepc->cpufv_disabled = false;
-		return rv;
+		return count;
 	case 1:
 		return -EPERM;
 	default:
@@ -1042,10 +1041,11 @@ static ssize_t store_sys_hwmon(void (*set)(int), const char *buf, size_t count)
 {
 	int rv, value;
 
-	rv = parse_arg(buf, count, &value);
-	if (rv > 0)
-		set(value);
-	return rv;
+	rv = parse_arg(buf, &value);
+	if (rv < 0)
+		return rv;
+	set(value);
+	return count;
 }
 
 static ssize_t show_sys_hwmon(int (*get)(void), char *buf)
-- 
1.9.3

