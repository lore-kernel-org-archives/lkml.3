Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3JJXGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 19:06:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3JJXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 19:06:05 -0400
Date: Thu, 10 Oct 2013 16:06:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: "sangjung.woo" <sangjung.woo@samsung.com>,
        Alessandro Rubini <rubini@gnudd.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] rtc: pl030: Use devm_kzalloc() instead of kmalloc()
Message-Id: <20131010160603.1489fe054c2bdc0a0eb9460f@linux-foundation.org>
In-Reply-To: <1381294767.2040.5.camel@joe-AO722>
References: <1381291240-23727-1-git-send-email-sangjung.woo@samsung.com>
	<1381291649.2040.1.camel@joe-AO722>
	<5254DD64.4090205@samsung.com>
	<1381294767.2040.5.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Oct 2013 21:59:27 -0700 Joe Perches <joe@perches.com> wrote:

> I was a bit surprised to find there isn't a devm_kmalloc.

Yes, the unconditional memset is silly.  Especially when the
function has a handy gfp_t and could be passed __GFP_ZERO.

The comment says "managed kzalloc/kfree for device drivers, no kmalloc,
always use kzalloc".  There's no explanation for this - it looks like
some ideological thing.


--- a/drivers/base/devres.c~a
+++ a/drivers/base/devres.c
@@ -91,7 +91,8 @@ static __always_inline struct devres * a
 	if (unlikely(!dr))
 		return NULL;
 
-	memset(dr, 0, tot_size);
+	if (gfp & __GFP_ZERO)
+		memset(dr, 0, tot_size);
 	INIT_LIST_HEAD(&dr->node.entry);
 	dr->node.release = release;
 	return dr;
@@ -770,7 +771,7 @@ static int devm_kzalloc_match(struct dev
  * RETURNS:
  * Pointer to allocated memory on success, NULL on failure.
  */
-void * devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+static void *__devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
 {
 	struct devres *dr;
 
@@ -783,8 +784,19 @@ void * devm_kzalloc(struct device *dev,
 	devres_add(dev, dr->data);
 	return dr->data;
 }
+
+void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp)
+{
+	return __devm_kzalloc(dev, size, gfp | __GFP_ZERO);
+}
 EXPORT_SYMBOL_GPL(devm_kzalloc);
 
+void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp)
+{
+	return __devm_kzalloc(dev, size, gfp);
+}
+EXPORT_SYMBOL_GPL(devm_kmalloc);
+
 /**
  * devm_kfree - Resource-managed kfree
  * @dev: Device this memory belongs to
--- a/include/linux/device.h~a
+++ a/include/linux/device.h
@@ -602,8 +602,9 @@ extern void devres_close_group(struct de
 extern void devres_remove_group(struct device *dev, void *id);
 extern int devres_release_group(struct device *dev, void *id);
 
-/* managed kzalloc/kfree for device drivers, no kmalloc, always use kzalloc */
+/* managed kmalloc/kzalloc/kfree for device drivers */
 extern void *devm_kzalloc(struct device *dev, size_t size, gfp_t gfp);
+extern void *devm_kmalloc(struct device *dev, size_t size, gfp_t gfp);
 extern void devm_kfree(struct device *dev, void *p);
 
 void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res);
_

