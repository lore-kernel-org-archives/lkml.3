Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab3EHHmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 03:42:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36261 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3EHHma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 03:42:30 -0400
Date: Wed, 8 May 2013 10:42:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christopher Li <sparse@chrisli.org>
Subject: [patch] err.h: IS_ERR() can accept __user pointers
Message-ID: <20130508074221.GA5024@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANeU7QnO8MzqT+9BDsXj3=nkKOBKumOwEKGnT=BL_cS0wiPPmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse generates a false positive when you pass a __user or __iomem
pointer to the IS_ERR() functions.

drivers/rtc/rtc-ds1286.c:344:36: sparse: incorrect type in argument 1 (different address spaces)
drivers/rtc/rtc-ds1286.c:344:36:    expected void const *ptr
drivers/rtc/rtc-ds1286.c:344:36:    got unsigned int [noderef] [usertype] <asn:2>*rtcregs

We can silence these by adding a __force here and upgrading to the
latest git release of Sparse.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This change has no effect when using current Sparse releases.

diff --git a/include/linux/err.h b/include/linux/err.h
index f2edce2..221fcfb 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -24,17 +24,17 @@ static inline void * __must_check ERR_PTR(long error)
 	return (void *) error;
 }
 
-static inline long __must_check PTR_ERR(const void *ptr)
+static inline long __must_check PTR_ERR(__force const void *ptr)
 {
 	return (long) ptr;
 }
 
-static inline long __must_check IS_ERR(const void *ptr)
+static inline long __must_check IS_ERR(__force const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
+static inline long __must_check IS_ERR_OR_NULL(__force const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -46,13 +46,13 @@ static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void * __must_check ERR_CAST(const void *ptr)
+static inline void * __must_check ERR_CAST(__force const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
 }
 
-static inline int __must_check PTR_RET(const void *ptr)
+static inline int __must_check PTR_RET(__force const void *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
