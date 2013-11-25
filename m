Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab3KYIsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:48:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3KYIsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:48:46 -0500
Message-Id: <20131125084811.956664794@dhcp-16-126.nay.redhat.com>
User-Agent: quilt/0.60-1
Date: Mon, 25 Nov 2013 16:47:11 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com,
        Dave Young <dyoung@redhat.com>
Subject-Prefi: [patch @num@/@total@ v4]
Subject: do not use __va for getting setup_data virt addr
References: <20131125084659.182036023@dhcp-16-126.nay.redhat.com>
Content-Disposition: inline; filename=12-x86-kdebugfs-use-ioremap.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__va does not work in case memmap=exactmap, so let's always use ioremap_cache.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/kernel/kdebugfs.c |   35 +++++++++++------------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

--- efi.orig/arch/x86/kernel/kdebugfs.c
+++ efi/arch/x86/kernel/kdebugfs.c
@@ -33,7 +33,6 @@ static ssize_t setup_data_read(struct fi
 	struct setup_data_node *node = file->private_data;
 	unsigned long remain;
 	loff_t pos = *ppos;
-	struct page *pg;
 	void *p;
 	u64 pa;
 
@@ -47,18 +46,12 @@ static ssize_t setup_data_read(struct fi
 		count = node->len - pos;
 
 	pa = node->paddr + sizeof(struct setup_data) + pos;
-	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
-	if (PageHighMem(pg)) {
-		p = ioremap_cache(pa, count);
-		if (!p)
-			return -ENXIO;
-	} else
-		p = __va(pa);
+	p = ioremap_cache(pa, count);
+	if (!p)
+		return -ENXIO;
 
 	remain = copy_to_user(user_buf, p, count);
-
-	if (PageHighMem(pg))
-		iounmap(p);
+	iounmap(p);
 
 	if (remain)
 		return -EFAULT;
@@ -109,7 +102,6 @@ static int __init create_setup_data_node
 	struct setup_data *data;
 	int error;
 	struct dentry *d;
-	struct page *pg;
 	u64 pa_data;
 	int no = 0;
 
@@ -126,16 +118,12 @@ static int __init create_setup_data_node
 			goto err_dir;
 		}
 
-		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
-		if (PageHighMem(pg)) {
-			data = ioremap_cache(pa_data, sizeof(*data));
-			if (!data) {
-				kfree(node);
-				error = -ENXIO;
-				goto err_dir;
-			}
-		} else
-			data = __va(pa_data);
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data) {
+			kfree(node);
+			error = -ENXIO;
+			goto err_dir;
+		}
 
 		node->paddr = pa_data;
 		node->type = data->type;
@@ -143,8 +131,7 @@ static int __init create_setup_data_node
 		error = create_setup_data_node(d, no, node);
 		pa_data = data->next;
 
-		if (PageHighMem(pg))
-			iounmap(data);
+		iounmap(data);
 		if (error)
 			goto err_dir;
 		no++;

