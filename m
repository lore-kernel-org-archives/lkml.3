Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaH2OWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:22:08 -0400
Received: from mga14.intel.com ([192.55.52.115]:49621 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbaH2OWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:22:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,424,1406617200"; 
   d="scan'208";a="583458632"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: akpm@linux-foundation.org
Cc: Mark Rustad <mark.d.rustad@intel.com>, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] init: Resolve shadow warnings
Date: Fri, 29 Aug 2014 07:21:52 -0700
Message-Id: <1409322112-31346-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Resolve shadow warnings that are produced in W=2 builds by
renaming a global with a too-generic name and renaming a
formal parameter.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 init/initramfs.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index bece48c..c9fc2e2 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -197,14 +197,14 @@ static __initdata enum state {
 } state, next_state;
 
 static __initdata char *victim;
-static unsigned long count __initdata;
+static unsigned long byte_count __initdata;
 static __initdata loff_t this_header, next_header;
 
 static inline void __init eat(unsigned n)
 {
 	victim += n;
 	this_header += n;
-	count -= n;
+	byte_count -= n;
 }
 
 static __initdata char *vcollected;
@@ -214,7 +214,7 @@ static __initdata char *collect;
 
 static void __init read_into(char *buf, unsigned size, enum state next)
 {
-	if (count >= size) {
+	if (byte_count >= size) {
 		collected = victim;
 		eat(size);
 		state = next;
@@ -237,8 +237,8 @@ static int __init do_start(void)
 static int __init do_collect(void)
 {
 	unsigned long n = remains;
-	if (count < n)
-		n = count;
+	if (byte_count < n)
+		n = byte_count;
 	memcpy(collect, victim, n);
 	eat(n);
 	collect += n;
@@ -280,8 +280,8 @@ static int __init do_header(void)
 
 static int __init do_skip(void)
 {
-	if (this_header + count < next_header) {
-		eat(count);
+	if (this_header + byte_count < next_header) {
+		eat(byte_count);
 		return 1;
 	} else {
 		eat(next_header - this_header);
@@ -292,9 +292,9 @@ static int __init do_skip(void)
 
 static int __init do_reset(void)
 {
-	while(count && *victim == '\0')
+	while(byte_count && *victim == '\0')
 		eat(1);
-	if (count && (this_header & 3))
+	if (byte_count && (this_header & 3))
 		error("broken padding");
 	return 1;
 }
@@ -309,11 +309,11 @@ static int __init maybe_link(void)
 	return 0;
 }
 
-static void __init clean_path(char *path, umode_t mode)
+static void __init clean_path(char *path, umode_t fmode)
 {
 	struct stat st;
 
-	if (!sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
+	if (!sys_newlstat(path, &st) && (st.st_mode ^ fmode) & S_IFMT) {
 		if (S_ISDIR(st.st_mode))
 			sys_rmdir(path);
 		else
@@ -368,7 +368,7 @@ static int __init do_name(void)
 
 static int __init do_copy(void)
 {
-	if (count >= body_len) {
+	if (byte_count >= body_len) {
 		if (xwrite(wfd, victim, body_len) != body_len)
 			error("write error");
 		sys_close(wfd);
@@ -378,10 +378,10 @@ static int __init do_copy(void)
 		state = SkipIt;
 		return 0;
 	} else {
-		if (xwrite(wfd, victim, count) != count)
+		if (xwrite(wfd, victim, byte_count) != byte_count)
 			error("write error");
-		body_len -= count;
-		eat(count);
+		body_len -= byte_count;
+		eat(byte_count);
 		return 1;
 	}
 }
@@ -411,12 +411,12 @@ static __initdata int (*actions[])(void) = {
 
 static long __init write_buffer(char *buf, unsigned long len)
 {
-	count = len;
+	byte_count = len;
 	victim = buf;
 
 	while (!actions[state]())
 		;
-	return len - count;
+	return len - byte_count;
 }
 
 static long __init flush_buffer(void *bufv, unsigned long len)
-- 
1.9.3

