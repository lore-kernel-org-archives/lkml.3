Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaHFVA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:00:29 -0400
Received: from dub004-omc4s8.hotmail.com ([157.55.2.83]:50949 "EHLO
	DUB004-OMC4S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaHFVAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:00:25 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 17:00:25 EDT
X-TMN: [huzzlrG6rIxwy/dW2Bieyfsrk0qxjHDK]
X-Originating-Email: [dcb314@hotmail.com]
Message-ID: <DUB128-W44671ADCA62DEF226431E09CE00@phx.gbl>
From: David Binderman <dcb314@hotmail.com>
To: "trivial@kernel.org" <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib: Add 64 bit speedup to lib/sort.c
Date: Wed, 6 Aug 2014 20:55:16 +0000
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 Aug 2014 20:55:16.0620 (UTC) FILETIME=[B9CAACC0:01CFB1B8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

The following patch adds an obvious speedup for 64 bit data to lib/sort.c

In tests on a 64 bit machine, the code at the end of the lib/sort.c
file executed some 40% faster.

The patch is against kernel version 3.16-rc6

Regards

David Binderman

Signed-off-by: David Binderman <dcb314@hotmail.com>

--- linux-3.16-rc6/lib/sort.c.old    2014-07-23 16:47:59.120299115 +0100
+++ linux-3.16-rc6/lib/sort.c    2014-07-23 17:33:21.405251903 +0100
@@ -16,6 +16,13 @@ static void u32_swap(void *a, void *b, i
     *(u32 *)b = t;
 }
 
+static void u64_swap(void *a, void *b, int size)
+{
+    u64 t = *(u64 *)a;
+    *(u64 *)a = *(u64 *)b;
+    *(u64 *)b = t;
+}
+
 static void generic_swap(void *a, void *b, int size)
 {
     char t;
@@ -51,8 +58,14 @@ void sort(void *base, size_t num, size_t
     /* pre-scale counters for performance */
     int i = (num/2 - 1) * size, n = num * size, c, r;
 
-    if (!swap_func)
-        swap_func = (size == 4 ? u32_swap : generic_swap);
+    if (!swap_func) {
+        if (size == 4)
+            swap_func = u32_swap;
+        else if (size == 8)
+            swap_func = u64_swap;
+        else
+            swap_func = generic_swap;
+    }
 
     /* heapify */
     for ( ; i>= 0; i -= size) {

 		 	   		  