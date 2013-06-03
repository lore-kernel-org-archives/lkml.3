Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab3FCCck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:32:40 -0400
Received: from ozlabs.org ([203.10.76.45]:56414 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387Ab3FCCcc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:32:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Meyer <thomas@m3y3r.de>, mst@redhat.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [RFC] PTR_ERR: return 0 if ptr isn't an error value.
References: <1370080565.29224.29.camel@localhost.localdomain>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 03 Jun 2013 11:59:15 +0930
Message-ID: <87mwr8sz9g.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Back in 2011, Uwe Kleine-König added the nonsensically-named
PTR_RET(), providing a means to avoid if() statements in code (commit 
fa9ee9c4b9).

Instead, just make PTR_ERR() return 0 if the pointer isn't an error
value.  This is harmless, since PTR_ERR() should have never been
passed a non-error value.  And GCC is usually smart enough to remove
the extra test if IS_ERR() has already been called.

My vmlinux text increased by 300 bytes:

	   text	   data	    bss	    dec	    hex	filename
	6029452	 491628	2576384	9097464	 8ad0f8	vmlinux
	6029721	 491628	2576384	9097733	 8ad205	vmlinux.PTR_ERR

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/err.h b/include/linux/err.h
index f2edce2..621d859 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -24,14 +24,16 @@ static inline void * __must_check ERR_PTR(long error)
 	return (void *) error;
 }
 
-static inline long __must_check PTR_ERR(const void *ptr)
+static inline long __must_check IS_ERR(const void *ptr)
 {
-	return (long) ptr;
+	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long __must_check IS_ERR(const void *ptr)
+static inline long __must_check PTR_ERR(const void *ptr)
 {
-	return IS_ERR_VALUE((unsigned long)ptr);
+	if (IS_ERR(ptr))
+		return (long) ptr;
+	return 0;
 }
 
 static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
@@ -52,14 +54,7 @@ static inline void * __must_check ERR_CAST(const void *ptr)
 	return (void *) ptr;
 }
 
-static inline int __must_check PTR_RET(const void *ptr)
-{
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-	else
-		return 0;
-}
-
+#define PTR_RET	PTR_ERR
 #endif
 
 #endif /* _LINUX_ERR_H */
