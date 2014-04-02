Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474AbaDBU3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:29:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42807 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758825AbaDBUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 36/40] make prepend_name() work correctly when called with negative *buflen
Date: Wed,  2 Apr 2014 22:13:22 +0200
Message-Id: <d01497237d210820a2153ae5ba5d3549ab1847cb.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e825196d48d2b89a6ec3a8eff280098d2a78207e upstream.

In all callchains leading to prepend_name(), the value left in *buflen
is eventually discarded unused if prepend_name() has returned a negative.
So we are free to do what prepend() does, and subtract from *buflen
*before* checking for underflow (which turns into checking the sign
of subtraction result, of course).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/dcache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4021e0172602..30b38e23caa7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2846,9 +2846,9 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
 	u32 dlen = ACCESS_ONCE(name->len);
 	char *p;
 
-	if (*buflen < dlen + 1)
-		return -ENAMETOOLONG;
 	*buflen -= dlen + 1;
+	if (*buflen < 0)
+		return -ENAMETOOLONG;
 	p = *buffer -= dlen + 1;
 	*p++ = '/';
 	while (dlen--) {
-- 
1.9.1

