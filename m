Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3A3TdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:33:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3A3TdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:33:01 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-sparse@vger.kernel.org
Cc: Christopher Li <sparse@chrisli.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Ignore address space for IS_ERR() and friends
Date: Wed, 30 Jan 2013 20:32:57 +0100
Message-Id: <1359574377-3402-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359574377-3402-1-git-send-email-thierry.reding@avionic-design.de>
References: <1359574377-3402-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:QYUPWslRk+j1faeoVWvzDvWZVCrVE4rWPB9EOfDuKBF
 K/bKHps9Ey7xkG/dhvl7sbI6lD36++GFHn26dh7jhaAcqEdyUi
 pYN8IGJDBimU8bpHAzuV5wYyaA4THH77DPEspJ1DGbzebbECuB
 dyPYuxnDcVeyaYYBQoc7EV+RoW8nfhgJY1ETpV/2YQjqpJXzdM
 OuUNlgF9ygsK6Fm5xkZBkOoc46NxDo7gDDOcNSQLc59SYsWNlD
 yk+XowtWJvXCMm3mgSFI5exlpDjtxgCaeqcetS4arq3vQJh9t7
 u1JWUrB/nTuCrcPK6g225e9bB8kNfUB5BW9+3Zqrs7V8QMy09Y
 reLxl0Sowc8FrzQausWeHbGy9aB0OuuzhmgSAd3r+hMlFwP25m
 2ad3m9mLHd+ibZb2h1gFaH/BtIujQfv/cK2F11DJYJ/QS/B7Af
 tTxJi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ignores sparse' address_space and noderef attributes for
pointers passed to the IS_ERR() and related functions. Since they only
extract an error code or compare the pointer to an integer value, they
can safely be used on any type of pointer.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Note that in order for this to work a patched version of sparse is
required.

 include/linux/err.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index f2edce2..92103bf 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -24,17 +24,17 @@ static inline void * __must_check ERR_PTR(long error)
 	return (void *) error;
 }
 
-static inline long __must_check PTR_ERR(const void *ptr)
+static inline long __must_check PTR_ERR(const void __force *ptr)
 {
 	return (long) ptr;
 }
 
-static inline long __must_check IS_ERR(const void *ptr)
+static inline long __must_check IS_ERR(const void __force *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
+static inline long __must_check IS_ERR_OR_NULL(const void __force *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -46,13 +46,13 @@ static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void * __must_check ERR_CAST(const void *ptr)
+static inline void * __must_check ERR_CAST(const void __force *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
 }
 
-static inline int __must_check PTR_RET(const void *ptr)
+static inline int __must_check PTR_RET(const void __force *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
-- 
1.8.1.2

