Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbbA0PZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:25:56 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64754 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbbA0PZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:25:50 -0500
From: Karl Beldan <karl.beldan@gmail.com>
X-Google-Original-From: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Karl Beldan <karl.beldan@gmail.com>,
        Karl Beldan <karl.beldan@rivierawaves.com>,
        Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH] lib/checksum.c: fix carry in csum_tcpudp_nofold
Date: Tue, 27 Jan 2015 16:25:16 +0100
Message-Id: <1422372316-25287-1-git-send-email-karl.beldan@rivierawaves.com>
X-Mailer: git-send-email 2.0.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The carry from the 64->32bits folding was dropped, e.g with:
saddr=0xFFFFFFFF daddr=0xFF0000FF len=0xFFFF proto=0 sum=1

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Cc: Stable <stable@vger.kernel.org>
---
 lib/checksum.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/checksum.c b/lib/checksum.c
index 129775e..4b5adf2 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -195,8 +195,8 @@ __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
 #else
 	s += (proto + len) << 8;
 #endif
-	s += (s >> 32);
-	return (__force __wsum)s;
+	s += (s << 32) + (s >> 32);
+	return (__force __wsum)(s >> 32);
 }
 EXPORT_SYMBOL(csum_tcpudp_nofold);
 #endif
-- 
2.0.1

