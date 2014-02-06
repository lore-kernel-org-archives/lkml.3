Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaBFQNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:13:51 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:35860 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751316AbaBFQNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:13:50 -0500
Date: Thu, 6 Feb 2014 11:13:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] lib: Fix some sparse warnings in devres.c
Message-ID: <20140206111346.712edc04@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having a discussion about sparse warnings in the kernel, and that we
should clean them up, I decided to pick a random file to do so. This
happened to be devres.c which gives the following warnings:

  CHECK   lib/devres.c
lib/devres.c:83:9: warning: cast removes address space of expression
lib/devres.c:117:31: warning: incorrect type in return expression (different address spaces)
lib/devres.c:117:31:    expected void [noderef] <asn:2>*
lib/devres.c:117:31:    got void *
lib/devres.c:125:31: warning: incorrect type in return expression (different address spaces)
lib/devres.c:125:31:    expected void [noderef] <asn:2>*
lib/devres.c:125:31:    got void *
lib/devres.c:136:26: warning: incorrect type in assignment (different address spaces)
lib/devres.c:136:26:    expected void [noderef] <asn:2>*[assigned] dest_ptr
lib/devres.c:136:26:    got void *
lib/devres.c:226:9: warning: cast removes address space of expression

Mostly it's just the use of typecasting to void * without adding
__force, or returning ERR_PTR(-ESOMEERR) without typecasting to a
__iomem type.

I added a helper macro IOMEM_ERR_PTR() that does the typecast to make
the code a little nicer than adding ugly typecasts to the code.

This is applied against linux-next.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/lib/devres.c b/lib/devres.c
index 8235331..48cb3c7 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -81,11 +81,13 @@ EXPORT_SYMBOL(devm_ioremap_nocache);
 void devm_iounmap(struct device *dev, void __iomem *addr)
 {
 	WARN_ON(devres_destroy(dev, devm_ioremap_release, devm_ioremap_match,
-			       (void *)addr));
+			       (__force void *)addr));
 	iounmap(addr);
 }
 EXPORT_SYMBOL(devm_iounmap);
 
+#define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
+
 /**
  * devm_ioremap_resource() - check, request region, and ioremap resource
  * @dev: generic device to handle the resource for
@@ -114,7 +116,7 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 
 	if (!res || resource_type(res) != IORESOURCE_MEM) {
 		dev_err(dev, "invalid resource\n");
-		return ERR_PTR(-EINVAL);
+		return IOMEM_ERR_PTR(-EINVAL);
 	}
 
 	size = resource_size(res);
@@ -122,7 +124,7 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 
 	if (!devm_request_mem_region(dev, res->start, size, name)) {
 		dev_err(dev, "can't request region for resource %pR\n", res);
-		return ERR_PTR(-EBUSY);
+		return IOMEM_ERR_PTR(-EBUSY);
 	}
 
 	if (res->flags & IORESOURCE_CACHEABLE)
@@ -133,7 +135,7 @@ void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 	if (!dest_ptr) {
 		dev_err(dev, "ioremap failed for resource %pR\n", res);
 		devm_release_mem_region(dev, res->start, size);
-		dest_ptr = ERR_PTR(-ENOMEM);
+		dest_ptr = IOMEM_ERR_PTR(-ENOMEM);
 	}
 
 	return dest_ptr;
@@ -224,7 +226,7 @@ void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 {
 	ioport_unmap(addr);
 	WARN_ON(devres_destroy(dev, devm_ioport_map_release,
-			       devm_ioport_map_match, (void *)addr));
+			       devm_ioport_map_match, (__force void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
 #endif /* CONFIG_HAS_IOPORT */
