Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259AbbAFVhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:37:19 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:29899 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbbAFVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:37:16 -0500
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giel van Schijndel <me@mortis.eu>, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org (open list:COMMON INTERNET F...),
        samba-technical@lists.samba.org (moderated list:COMMON INTERNET F...)
Subject: [PATCH RESEND] cifs: use memzero_explicit to clear stack buffer
Date: Tue,  6 Jan 2015 22:37:00 +0100
Message-Id: <1420580220-6276-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420394744-20268-1-git-send-email-me@mortis.eu>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When leaving a function use memzero_explicit instead of memset(0) to
clear stack allocated buffers. memset(0) may be optimized away.

This particular buffer is highly likely to contain sensitive data which
we shouldn't leak (it's named 'passwd' after all).

Signed-off-by: Giel van Schijndel <me@mortis.eu>
Reported-at: http://www.viva64.com/en/b/0299/
Reported-by: Andrey Karpov
Reported-by: Svyatoslav Razmyslov
---
 fs/cifs/smbencrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 6c15663..a4232ec 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -221,7 +221,7 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16,
 	}
 
 	rc = mdfour(p16, (unsigned char *) wpwd, len * sizeof(__le16));
-	memset(wpwd, 0, 129 * sizeof(__le16));
+	memzero_explicit(wpwd, sizeof(wpwd));
 
 	return rc;
 }
-- 
2.1.4

