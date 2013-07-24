Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3GXSh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:37:57 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:34998 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3GXShy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:37:54 -0400
Message-ID: <51F01EFB.6070207@linux.vnet.ibm.com>
Date: Wed, 24 Jul 2013 13:37:47 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        isimatu.yasuaki@jp.fujitsu.com
Subject: [PATCH 3/8] Add all memory via sysfs probe interface at once
References: <51F01E06.6090800@linux.vnet.ibm.com>
In-Reply-To: <51F01E06.6090800@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072418-5490-0000-0000-000003E0F2B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing memory hot add via the 'probe' interface in sysfs we do not
need to loop through and add memory one section at a time. I think this
was originally done for powerpc, but is not needed. This patch removes
the loop and just calls add_memory for all of the memory to be added.

Signed-off-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 drivers/base/memory.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

Index: linux/drivers/base/memory.c
===================================================================
--- linux.orig/drivers/base/memory.c
+++ linux/drivers/base/memory.c
@@ -427,8 +427,8 @@ memory_probe_store(struct device *dev, s
 		   const char *buf, size_t count)
 {
 	u64 phys_addr;
-	int nid;
-	int i, ret;
+	int nid, ret;
+	unsigned long block_size;
 	unsigned long pages_per_block = PAGES_PER_SECTION * sections_per_block;
 
 	phys_addr = simple_strtoull(buf, NULL, 0);
@@ -436,19 +436,11 @@ memory_probe_store(struct device *dev, s
 	if (phys_addr & ((pages_per_block << PAGE_SHIFT) - 1))
 		return -EINVAL;
 
-	for (i = 0; i < sections_per_block; i++) {
-		nid = memory_add_physaddr_to_nid(phys_addr);
-		ret = add_memory(nid, phys_addr,
-				 PAGES_PER_SECTION << PAGE_SHIFT);
-		if (ret)
-			goto out;
+	block_size = get_memory_block_size();
+	nid = memory_add_physaddr_to_nid(phys_addr);
+	ret = add_memory(nid, phys_addr, block_size);
 
-		phys_addr += MIN_MEMORY_BLOCK_SIZE;
-	}
-
-	ret = count;
-out:
-	return ret;
+	return ret ? ret : count;
 }
 
 static DEVICE_ATTR(probe, S_IWUSR, NULL, memory_probe_store);


