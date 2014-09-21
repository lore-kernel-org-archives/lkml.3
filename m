Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaIUQ2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:28:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40040 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaIUQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:27:46 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Waldemar Brodkorb <mail@waldemar-brodkorb.de>,
        Jesper Nilsson <jespern@axis.com>, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com, Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 7/8] resource: Add NULL check in next_resource
Date: Sun, 21 Sep 2014 09:27:17 -0700
Message-Id: <1411316838-15135-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
References: <1411316838-15135-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8c86e70acead ("resource: provide new functions to walk through
resources") adds a suble new requirement that iomem_resource.child must
not be NULL when walk_system_ram_range is called. This can cause a crash
if it turns out that there are no children. The crash ('Unable to handle
kernel NULL pointer dereference') is seen when trying to test a crisv32
image on kernels with this commit applied.

Fix by adding a NULL check into next_resource().

Fixes: 8c86e70acead ("resource: provide new functions to walk through resources")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 kernel/resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/resource.c b/kernel/resource.c
index 60c5a38..00c57ad 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -61,6 +61,9 @@ static DEFINE_SPINLOCK(bootmem_resource_lock);
 
 static struct resource *next_resource(struct resource *p, bool sibling_only)
 {
+	if (p == NULL)
+		return NULL;
+
 	/* Caller wants to traverse through siblings only */
 	if (sibling_only)
 		return p->sibling;
-- 
1.9.1

