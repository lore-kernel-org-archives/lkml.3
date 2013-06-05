Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab3FEQbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:31:16 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:40909 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3FEQbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:31:15 -0400
From: Rasmus Villemoes <mail@rasmusvillemoes.dk>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] fs: Properly pair fget_light/fput_light in fdget/fdput
Date: Wed,  5 Jun 2013 16:30:57 +0000
Message-Id: <1370449857-25355-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fdget() is implemented using fget_light(). Its companion fdput()
currently open-codes the behaviour of fput_light(). This is slightly
confusing. To follow the documentation in fs/file.c:688ff to the
letter, use fput_light() in fdput().

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/file.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/file.h b/include/linux/file.h
index cbacf4f..30be9b0 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -33,8 +33,7 @@ struct fd {
 
 static inline void fdput(struct fd fd)
 {
-	if (fd.need_put)
-		fput(fd.file);
+	fput_light(fd.file, fd.need_put);
 }
 
 extern struct file *fget(unsigned int fd);
-- 
1.7.9.5

