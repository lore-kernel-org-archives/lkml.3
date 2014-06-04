Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaFDXVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaFDXVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.14 045/228] Revert "hwmon: (coretemp) Refine TjMax detection"
Date: Wed,  4 Jun 2014 16:21:14 -0700
Message-Id: <20140604232349.526287489@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit c0940e95f7a78be0525c8d31df0b1f71e149e57e upstream.

This reverts commit 9fb6c9c73b11bef65ba80a362547fd116c1e1c9d.

Tjmax on some Intel CPUs is below 85 degrees C. One known example is
L5630 with Tjmax of 71 degrees C. There are other Xeon processors with
Tjmax of 70 or 80 degrees C. Also, the Intel IA32 System Programming
document states that the temperature target is in bits 23:16 of MSR 0x1a2
(MSR_TEMPERATURE_TARGET), which is 8 bits, not 7.

So even if turbostat uses similar checks to validate Tjmax, there is no
evidence that the checks are actually required. On the contrary, the
checks are known to cause problems and therefore need to be removed.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=75071.

Fixes: 9fb6c9c hwmon: (coretemp) Refine TjMax detection
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/coretemp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -369,12 +369,12 @@ static int get_tjmax(struct cpuinfo_x86
 		if (cpu_has_tjmax(c))
 			dev_warn(dev, "Unable to read TjMax from CPU %u\n", id);
 	} else {
-		val = (eax >> 16) & 0x7f;
+		val = (eax >> 16) & 0xff;
 		/*
 		 * If the TjMax is not plausible, an assumption
 		 * will be used
 		 */
-		if (val >= 85) {
+		if (val) {
 			dev_dbg(dev, "TjMax is %d degrees C\n", val);
 			return val * 1000;
 		}


