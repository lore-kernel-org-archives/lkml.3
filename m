Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaIUPv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 11:51:59 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:45904 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaIUPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 11:51:57 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] resource: Add NULL check in next_resource
Date: Sun, 21 Sep 2014 08:51:44 -0700
Message-Id: <1411314704-27072-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
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
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
The NULL check could be added elsewhere instead. I am open to suggestions.

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

