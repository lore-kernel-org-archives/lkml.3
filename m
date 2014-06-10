Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322AbaFJAWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:22:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934016AbaFJAWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 47/88] mm: add kmap_to_page()
Date: Mon,  9 Jun 2014 17:24:57 -0700
Message-Id: <20140610002426.089246636@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit fcb8996728fb59eddf84678df7cb213b2c9a2e26 upstream.

This is extracted from Mel Gorman's commit 5a178119b0fb ('mm: add
support for direct_IO to highmem pages') upstream.

Required to backport commit b9cdc88df8e6 ('virtio: 9p: correctly pass
physical address to userspace for high pages').

Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/highmem.h |    7 +++++++
 mm/highmem.c            |   12 ++++++++++++
 2 files changed, 19 insertions(+)

--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -39,10 +39,17 @@ extern unsigned long totalhigh_pages;
 
 void kmap_flush_unused(void);
 
+struct page *kmap_to_page(void *addr);
+
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
 
+static inline struct page *kmap_to_page(void *addr)
+{
+	return virt_to_page(addr);
+}
+
 #define totalhigh_pages 0UL
 
 #ifndef ARCH_HAS_KMAP
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -94,6 +94,18 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map
 		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
 #endif
 
+struct page *kmap_to_page(void *vaddr)
+{
+	unsigned long addr = (unsigned long)vaddr;
+
+	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+		return pte_page(pkmap_page_table[i]);
+	}
+
+	return virt_to_page(addr);
+}
+
 static void flush_all_zero_pkmaps(void)
 {
 	int i;


