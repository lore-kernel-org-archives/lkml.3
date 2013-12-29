Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab3L2Vwu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:52:50 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:31760 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341Ab3L2VwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:52:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,570,1384297200"; 
   d="scan'208";a="50832553"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jonathan Woithe <jwoithe@just42.net>
Cc: kernel-janitors@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/25] fujitsu-laptop: fix error return code
Date: Sun, 29 Dec 2013 23:47:36 +0100
Message-Id: <1388357260-4843-22-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

These functions mix the use of result and error.  In acpi_fujitsu_add,
result does not seem useful; it would seem reasonable to propagate the
return value of acpi_bus_update_power in an error case.  On the other hand,
in the case of acpi_fujitsu_hotkey_add, there is an initialization of
result that can lead to what looks like a failure case, but that does not
abort the function.  The variable result is kept for this case.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.  Not sure to be doing the right thing with result in the second
case.

 drivers/platform/x86/fujitsu-laptop.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index 9d30d69..be02bcc 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -633,7 +633,6 @@ static struct dmi_system_id fujitsu_dmi_table[] = {
 
 static int acpi_fujitsu_add(struct acpi_device *device)
 {
-	int result = 0;
 	int state = 0;
 	struct input_dev *input;
 	int error;
@@ -669,8 +668,8 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 	if (error)
 		goto err_free_input_dev;
 
-	result = acpi_bus_update_power(fujitsu->acpi_handle, &state);
-	if (result) {
+	error = acpi_bus_update_power(fujitsu->acpi_handle, &state);
+	if (error) {
 		pr_err("Error reading power state\n");
 		goto err_unregister_input_dev;
 	}
@@ -700,7 +699,7 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 		fujitsu->max_brightness = FUJITSU_LCD_N_LEVELS;
 	get_lcd_level();
 
-	return result;
+	return 0;
 
 err_unregister_input_dev:
 	input_unregister_device(input);
@@ -708,7 +707,7 @@ err_unregister_input_dev:
 err_free_input_dev:
 	input_free_device(input);
 err_stop:
-	return result;
+	return error;
 }
 
 static int acpi_fujitsu_remove(struct acpi_device *device)
@@ -831,8 +830,8 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 	if (error)
 		goto err_free_input_dev;
 
-	result = acpi_bus_update_power(fujitsu_hotkey->acpi_handle, &state);
-	if (result) {
+	error = acpi_bus_update_power(fujitsu_hotkey->acpi_handle, &state);
+	if (error) {
 		pr_err("Error reading power state\n");
 		goto err_unregister_input_dev;
 	}
@@ -907,7 +906,7 @@ err_free_input_dev:
 err_free_fifo:
 	kfifo_free(&fujitsu_hotkey->fifo);
 err_stop:
-	return result;
+	return error;
 }
 
 static int acpi_fujitsu_hotkey_remove(struct acpi_device *device)

