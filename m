Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932873Ab3EOURQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab3EOUQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:16:05 -0400
Date: Wed, 15 May 2013 22:12:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] coredump: cn_vprintf() has no reason to call
	vsnprintf() twice
Message-ID: <20130515201226.GA14638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515201158.GA14606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cn_vprintf() looks really overcomplicated and sub-optimal.
We do not need vsnprintf(NULL) to calculate the size we
need, we can simply try to print into the current buffer
and expand/retry only if necessary.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index c10a43a..2b1d1f5 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -71,26 +71,20 @@ static int expand_corename(struct core_name *cn)
 
 static int cn_vprintf(struct core_name *cn, const char *fmt, va_list arg)
 {
-	char *cur;
-	int need;
-	int ret;
-
-	need = vsnprintf(NULL, 0, fmt, arg);
-	if (likely(need < cn->size - cn->used - 1))
-		goto out_printf;
-
-	ret = expand_corename(cn);
-	if (ret)
-		goto expand_fail;
+	int free, need;
+
+again:
+	free = cn->size - cn->used;
+	need = vsnprintf(cn->corename + cn->used, free, fmt, arg);
+	if (need < free) {
+		cn->used += need;
+		return 0;
+	}
 
-out_printf:
-	cur = cn->corename + cn->used;
-	vsnprintf(cur, need + 1, fmt, arg);
-	cn->used += need;
-	return 0;
+	if (!expand_corename(cn))
+		goto again;
 
-expand_fail:
-	return ret;
+	return -ENOMEM;
 }
 
 static int cn_printf(struct core_name *cn, const char *fmt, ...)
-- 
1.5.5.1

