Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaICWxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:53:34 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41147 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbaICWxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:53:32 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] eeepc-laptop: remove possible use of uninitialized value
Date: Thu,  4 Sep 2014 00:53:25 +0200
Message-Id: <1409784805-14190-1-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In store_sys_acpi, if count equals zero, or parse_arg()s sscanf call
fails, 'value' remains possibly uninitialized. In that case 'value'
shouldn't be used to produce the store_sys_acpi()s return value.

Only test the return value of set_acpi() if we can actually call it.
Return rv otherwise.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index bd533c2..41f12ba 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -279,10 +279,10 @@ static ssize_t store_sys_acpi(struct device *dev, int cm,
 	int rv, value;
 
 	rv = parse_arg(buf, count, &value);
-	if (rv > 0)
-		value = set_acpi(eeepc, cm, value);
-	if (value < 0)
-		return -EIO;
+	if (rv > 0) {
+		if (set_acpi(eeepc, cm, value) < 0)
+			return -EIO;
+	}
 	return rv;
 }
 
-- 
2.1.0

