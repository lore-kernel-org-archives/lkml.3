Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaIJUF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:05:27 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:49563 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753109AbaIJUFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:05:23 -0400
Message-ID: <1410379520.11097.18.camel@x220>
Subject: [PATCH v2] eeepc-laptop: simplify parse_arg()
From: Paul Bolle <pebolle@tiscali.nl>
To: Darren Hart <dvhart@infradead.org>,
        Corentin Chary <corentin.chary@gmail.com>
Cc: Frans Klaver <fransklaver@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2014 22:05:20 +0200
In-Reply-To: <20140910164916.GA48285@vmdeb7>
References: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
	 <1409814488.5546.63.camel@x220> <20140906021757.GA9197@vmdeb7>
	 <7288841.ayNsq2yeGO@vostro.rjw.lan> <1410252608.22255.5.camel@x220>
	 <20140910033304.GB39541@vmdeb7>
	 <CAH6sp9NtLDG4AvpTF7KzxwxVhrj8ZzNLugwoU5=YrLp65AptQQ@mail.gmail.com>
	 <20140910164916.GA48285@vmdeb7>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Sep 2014 20:05:20.0912 (UTC) FILETIME=[8CAB2900:01CFCD32]
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

While we're at it, let store_sys_acpi() return whatever error set_acpi()
returns instead of remapping it to EIO.

A nice side effect is that this GCC warning is silenced too:
    drivers/platform/x86/eeepc-laptop.c: In function ‘store_sys_acpi’:
    drivers/platform/x86/eeepc-laptop.c:279:10: warning: ‘value’ may be used uninitialized in this function [-Wmaybe-uninitialized]
      int rv, value;

Which is, of course, the reason to have a look at parse_arg().

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v2: let store_sys_acpi() return whatever error set_acpi()
returns instead of remapping it to EIO. The new line about that in the
commit explanation is silly, but I couldn't come up with a better
explanation.

Still build tested only on top of v3.17-rc4 (I think Frans actually
tested v1, which is almost identical). 

There was a lot of discussion on the errors returned by this driver. I
think using new error codes is actually out of scope for this patch and
should be done in follow up patches.

 drivers/platform/x86/eeepc-laptop.c | 38 ++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index bd533c22be57..90be993b140e 100644
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
-	if (value < 0)
-		return -EIO;
-	return rv;
+	rv = parse_arg(buf, &value);
+	if (rv < 0)
+		return rv;
+	rv = set_acpi(eeepc, cm, value);
+	if (rv < 0)
+		return rv;
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

