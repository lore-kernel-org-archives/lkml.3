Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaBZThc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:37:32 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49719 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaBZThT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:37:19 -0500
Subject: [PATCH 2/9] vsprintf: Add support for IORESOURCE_UNSET in %pR
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:37:16 -0700
Message-ID: <20140226193716.10125.11835.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we have a struct resource where we know the type (MEM/IO/etc.)
and the size, but we haven't assigned address space for it.  The
IORESOURCE_UNSET flag is a way to indicate this situation.  For these
"unset" resources, the start address is meaningless, so print only the
size, e.g.,

  - pci 0000:0c:00.0: reg 184: [mem 0x00000000-0x00001fff 64bit]
  + pci 0000:0c:00.0: reg 184: [mem size 0x2000 64bit]

For %pr (printing with raw flags), we still print the address range,
because %pr is mostly used for debugging anyway.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 include/linux/ioport.h |    2 +-
 lib/vsprintf.c         |   13 +++++++++----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 9fcaac8bc4f6..5e3a906cc089 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -51,7 +51,7 @@ struct resource {
 
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
-#define IORESOURCE_UNSET	0x20000000
+#define IORESOURCE_UNSET	0x20000000	/* No address assigned yet */
 #define IORESOURCE_AUTO		0x40000000
 #define IORESOURCE_BUSY		0x80000000	/* Driver has marked this resource busy */
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 185b6d300ebc..c14669f4ffc4 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -719,10 +719,15 @@ char *resource_string(char *buf, char *end, struct resource *res,
 		specp = &mem_spec;
 		decode = 0;
 	}
-	p = number(p, pend, res->start, *specp);
-	if (res->start != res->end) {
-		*p++ = '-';
-		p = number(p, pend, res->end, *specp);
+	if (decode && res->flags & IORESOURCE_UNSET) {
+		p = string(p, pend, "size ", str_spec);
+		p = number(p, pend, res->end - res->start + 1, *specp);
+	} else {
+		p = number(p, pend, res->start, *specp);
+		if (res->start != res->end) {
+			*p++ = '-';
+			p = number(p, pend, res->end, *specp);
+		}
 	}
 	if (decode) {
 		if (res->flags & IORESOURCE_MEM_64)

