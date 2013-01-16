Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab3APQiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:38:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36270 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3APQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ondrej Zary <linux@rainbow-software.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 124/222] x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops
Date: Wed, 16 Jan 2013 13:55:24 -0200
Message-Id: <1358351822-7675-125-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Zary <linux@rainbow-software.org>

commit ad68652412276f68ad4fe3e1ecf5ee6880876783 upstream.

Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable A20
line but resume code assumes that KBC was used.
The laptop will not resume from S3 otherwise but powers off after a while
and then powers on again stuck with a blank screen.

Fix it by enabling A20 using KBC in i8042_platform_init for x86.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/201212112218.06551.linux@rainbow-software.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/input/serio/i8042-x86ia64io.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index d6cc77a..5f306f7 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -921,6 +921,7 @@ static int __init i8042_platform_init(void)
 	int retval;
 
 #ifdef CONFIG_X86
+	u8 a20_on = 0xdf;
 	/* Just return if pre-detection shows no i8042 controller exist */
 	if (!x86_platform.i8042_detect())
 		return -ENODEV;
@@ -960,6 +961,14 @@ static int __init i8042_platform_init(void)
 
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = true;
+
+	/*
+	 * A20 was already enabled during early kernel init. But some buggy
+	 * BIOSes (in MSI Laptops) require A20 to be enabled using 8042 to
+	 * resume from S3. So we do it here and hope that nothing breaks.
+	 */
+	i8042_command(&a20_on, 0x10d1);
+	i8042_command(NULL, 0x00ff);	/* Null command for SMM firmware */
 #endif /* CONFIG_X86 */
 
 	return retval;
-- 
1.7.9.5

