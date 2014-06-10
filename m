Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaFJVjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 17:39:03 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:57077 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaFJVjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 17:39:01 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: linux-kernel@vger.kernel.org
Cc: dan.carpenter@oracle.com, linux-sparse@vger.kernel.org,
        Jeff Layton <jlayton@primarydata.com>
Subject: [PATCH][RFC] err.h: silence sparse warning: dereference of noderef expression
Date: Tue, 10 Jun 2014 17:38:49 -0400
Message-Id: <1402436329-24750-1-git-send-email-jlayton@poochiereds.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@primarydata.com>

Lately, when I do a make with C=1, I get *tons* of these warnings:

    include/linux/err.h:35:16: warning: dereference of noderef expression
    include/linux/err.h:30:23: warning: dereference of noderef expression

...so many that it's really driven down the signal to noise ratio. I've
taken a look at what's driving these warnings and I really just don't
get it. The pointers being passed in aren't being dereferenced as far
as I can tell, so what is sparse complaining about?

Even odder, just in playing around I've noticed that removing the
__force directives seems to silence these warnings. This is really
strange since all of the docs I see indicate that __force is supposed to
help silence sparse warnings, not cause them.

This patch just removes the __force directives on the err.h inlines and
that silences the warnings for me. Dan originally added those in commit
e7152b97f38f1 (err.h: IS_ERR() can accept __user pointers).

I don't really consider this a serious proposal for inclusion, but
rather just a starting point for discussion. What's the right way to fix
this problem? Is this a bug in sparse?

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 include/linux/err.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index a729120644d5..284897f403b3 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -25,17 +25,17 @@ static inline void * __must_check ERR_PTR(long error)
 	return (void *) error;
 }
 
-static inline long __must_check PTR_ERR(__force const void *ptr)
+static inline long __must_check PTR_ERR(const void *ptr)
 {
 	return (long) ptr;
 }
 
-static inline bool __must_check IS_ERR(__force const void *ptr)
+static inline bool __must_check IS_ERR(const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
+static inline bool __must_check IS_ERR_OR_NULL(const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -47,13 +47,13 @@ static inline bool __must_check IS_ERR_OR_NULL(__force const void *ptr)
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void * __must_check ERR_CAST(__force const void *ptr)
+static inline void * __must_check ERR_CAST(const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
 }
 
-static inline int __must_check PTR_ERR_OR_ZERO(__force const void *ptr)
+static inline int __must_check PTR_ERR_OR_ZERO(const void *ptr)
 {
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
-- 
1.9.3

