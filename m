Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaILXHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:07:48 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:58825 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaILXHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:07:17 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] eeepc-laptop: compare proper return values in get_cpufv
Date: Sat, 13 Sep 2014 01:06:49 +0200
Message-Id: <1410563212-31565-11-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
References: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In get_cpufv the return value of get_acpi is stored in the cpufv struct.
Right before this value is checked for errors, it is and'ed with 0xff.
This means c->cur can never be less than zero. Besides that, the actual
error value is ignored.

c->num is also and'ed with 0xff, which means we can ignore values below
zero.

Check the result of get_acpi() right away. While at it, propagate the
error if we got one.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 47488d3..828db56 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -332,9 +332,12 @@ struct eeepc_cpufv {
 static int get_cpufv(struct eeepc_laptop *eeepc, struct eeepc_cpufv *c)
 {
 	c->cur = get_acpi(eeepc, CM_ASL_CPUFV);
+	if (c->cur < 0)
+		return c->cur;
+
 	c->num = (c->cur >> 8) & 0xff;
 	c->cur &= 0xff;
-	if (c->cur < 0 || c->num <= 0 || c->num > 12)
+	if (c->num == 0 || c->num > 12)
 		return -ENODEV;
 	return 0;
 }
-- 
2.1.0

