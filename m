Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaILXHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:07:54 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38108 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaILXHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:07:20 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] eeepc-laptop: return -ENXIO if acpi getter or setter fails
Date: Sat, 13 Sep 2014 01:06:52 +0200
Message-Id: <1410563212-31565-14-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_acpi() and set_acpi() return -ENODEV on error.  However, of the
available options, ENXIO seems more appropriate, since we're dealing
with both devices and addresses here:

	#define EIO              5      /* I/O error */
	#define ENXIO            6      /* No such device or address */
	#define ENODEV          19      /* No such device */

One could expect the same applies to acpi_setter_handle(), as this
follows a similar setup. Changing the return values here triggers the
error "Error removing rfkill notify handler" during boot, so we'll leave
that as is.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
Changing ENODEV to ENXIO in acpi_setter_handle() probably requires some extra
work to get it working properly. I'd propose to dive into that after we finish
this series, or we drop this patch from the series and move the whole return
value issue into a separate patch set. Either way, with the sysfs fixes in
place, I don't think this one is going to make a huge difference in the end.

 drivers/platform/x86/eeepc-laptop.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index ad221e0..064ab0d 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -215,9 +215,9 @@ static int set_acpi(struct eeepc_laptop *eeepc, int cm, int value)
 	const char *method = cm_setv[cm];
 
 	if (method == NULL)
-		return -ENODEV;
+		return -ENXIO;
 	if ((eeepc->cm_supported & (0x1 << cm)) == 0)
-		return -ENODEV;
+		return -ENXIO;
 
 	if (write_acpi_int(eeepc->handle, method, value))
 		pr_warn("Error writing %s\n", method);
@@ -230,9 +230,9 @@ static int get_acpi(struct eeepc_laptop *eeepc, int cm)
 	int value;
 
 	if (method == NULL)
-		return -ENODEV;
+		return -ENXIO;
 	if ((eeepc->cm_supported & (0x1 << cm)) == 0)
-		return -ENODEV;
+		return -ENXIO;
 
 	if (read_acpi_int(eeepc->handle, method, &value))
 		pr_warn("Error reading %s\n", method);
@@ -527,7 +527,7 @@ static int eeepc_led_init(struct eeepc_laptop *eeepc)
 {
 	int rv;
 
-	if (get_acpi(eeepc, CM_ASL_TPD) == -ENODEV)
+	if (get_acpi(eeepc, CM_ASL_TPD) == -ENXIO)
 		return 0;
 
 	eeepc->led_workqueue = create_singlethread_workqueue("led_workqueue");
-- 
2.1.0

