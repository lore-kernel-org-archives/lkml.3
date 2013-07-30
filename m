Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3G3PFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:05:53 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:45163 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3G3PFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:05:51 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, gnatapov@redhat.com, kvm@vger.kernel.org
Subject: [PATCH] KVM: introduce __kvm_io_bus_sort_cmp
Date: Tue, 30 Jul 2013 17:05:37 +0200
Message-Id: <1375196737-2264-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm_io_bus_sort_cmp is used also directly, not just as a callback for
sort and bsearch.  In these cases, it is handy to have a type-safe
variant.  This patch introduces such a variant, __kvm_io_bus_sort_cmp,
and uses it throughout kvm_main.c.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b2a2bb9..e0d127d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2812,11 +2812,9 @@ static void kvm_io_bus_destroy(struct kvm_io_bus *bus)
 	kfree(bus);
 }
 
-static int kvm_io_bus_sort_cmp(const void *p1, const void *p2)
+static inline int __kvm_io_bus_sort_cmp(const struct kvm_io_range *r1,
+                                        const struct kvm_io_range *r2)
 {
-	const struct kvm_io_range *r1 = p1;
-	const struct kvm_io_range *r2 = p2;
-
 	if (r1->addr < r2->addr)
 		return -1;
 	if (r1->addr + r1->len > r2->addr + r2->len)
@@ -2824,6 +2822,11 @@ static int kvm_io_bus_sort_cmp(const void *p1, const void *p2)
 	return 0;
 }
 
+static int kvm_io_bus_sort_cmp(const void *p1, const void *p2)
+{
+	return __kvm_io_bus_sort_cmp(p1, p2);
+}
+
 static int kvm_io_bus_insert_dev(struct kvm_io_bus *bus, struct kvm_io_device *dev,
 			  gpa_t addr, int len)
 {
@@ -2857,7 +2860,7 @@ static int kvm_io_bus_get_first_dev(struct kvm_io_bus *bus,
 
 	off = range - bus->range;
 
-	while (off > 0 && kvm_io_bus_sort_cmp(&key, &bus->range[off-1]) == 0)
+	while (off > 0 && __kvm_io_bus_sort_cmp(&key, &bus->range[off-1]) == 0)
 		off--;
 
 	return off;
@@ -2873,7 +2876,7 @@ static int __kvm_io_bus_write(struct kvm_io_bus *bus,
 		return -EOPNOTSUPP;
 
 	while (idx < bus->dev_count &&
-		kvm_io_bus_sort_cmp(range, &bus->range[idx]) == 0) {
+		__kvm_io_bus_sort_cmp(range, &bus->range[idx]) == 0) {
 		if (!kvm_iodevice_write(bus->range[idx].dev, range->addr,
 					range->len, val))
 			return idx;
@@ -2917,7 +2920,7 @@ int kvm_io_bus_write_cookie(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 
 	/* First try the device referenced by cookie. */
 	if ((cookie >= 0) && (cookie < bus->dev_count) &&
-	    (kvm_io_bus_sort_cmp(&range, &bus->range[cookie]) == 0))
+	    (__kvm_io_bus_sort_cmp(&range, &bus->range[cookie]) == 0))
 		if (!kvm_iodevice_write(bus->range[cookie].dev, addr, len,
 					val))
 			return cookie;
@@ -2939,7 +2942,7 @@ static int __kvm_io_bus_read(struct kvm_io_bus *bus, struct kvm_io_range *range,
 		return -EOPNOTSUPP;
 
 	while (idx < bus->dev_count &&
-		kvm_io_bus_sort_cmp(range, &bus->range[idx]) == 0) {
+		__kvm_io_bus_sort_cmp(range, &bus->range[idx]) == 0) {
 		if (!kvm_iodevice_read(bus->range[idx].dev, range->addr,
 				       range->len, val))
 			return idx;
@@ -2983,7 +2986,7 @@ int kvm_io_bus_read_cookie(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 
 	/* First try the device referenced by cookie. */
 	if ((cookie >= 0) && (cookie < bus->dev_count) &&
-	    (kvm_io_bus_sort_cmp(&range, &bus->range[cookie]) == 0))
+	    (__kvm_io_bus_sort_cmp(&range, &bus->range[cookie]) == 0))
 		if (!kvm_iodevice_read(bus->range[cookie].dev, addr, len,
 				       val))
 			return cookie;
-- 
1.8.1.4

