Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaJXFfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:35:34 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:25252 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbaJXFfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:35:33 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Alexander Viro <viro@zeniv.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH resending] splice: sendfile() at once fails for big files
Message-Id: <20141024053503.0F8E91A655B@localhost.localdomain>
Date: Fri, 24 Oct 2014 07:35:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When big files (over 64kbytes) are sent with sendfile(), they are sent by blocks
of 64kbytes. In that case, the target must be informed that the current block is
not the last one, otherwise it might take wrong actions.
The issue was observed while sending a file to an AF_ALG socket for hashing. The
hash was reset at each 64k block.
This patch adds SPLICE_F_MORE to the flags when more data is pending.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Index: b/fs/splice.c
===================================================================
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1171,7 +1171,7 @@
 	long ret, bytes;
 	umode_t i_mode;
 	size_t len;
-	int i, flags;
+	int i, flags, more;
 
 	/*
 	 * We require the input being a regular file, as we don't want to
@@ -1214,6 +1214,7 @@
 	 * Don't block on output, we have to drain the direct pipe.
 	 */
 	sd->flags &= ~SPLICE_F_NONBLOCK;
+	more = sd->flags & SPLICE_F_MORE;
 
 	while (len) {
 		size_t read_len;
@@ -1226,6 +1227,10 @@
 		read_len = ret;
 		sd->total_len = read_len;
 
+		if (read_len < len)
+			sd->flags |= SPLICE_F_MORE;
+		else if (!more)
+			sd->flags &= ~SPLICE_F_MORE;
 		/*
 		 * NOTE: nonblocking mode only applies to the input. We
 		 * must not do the output in nonblocking mode as then we
