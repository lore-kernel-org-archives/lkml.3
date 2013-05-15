Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab3EOUQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:16:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab3EOUQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:16:09 -0400
Date: Wed, 15 May 2013 22:12:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] coredump: introduce cn_vprintf()
Message-ID: <20130515201222.GA14631@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515201158.GA14606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn cn_printf(...) into cn_vprintf(va_list args), reintroduce
cn_printf() as a trivial wrapper.

This simplifies the next change and cn_vprintf() will have more
callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 11bc368..c10a43a 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -69,17 +69,13 @@ static int expand_corename(struct core_name *cn)
 	return 0;
 }
 
-static int cn_printf(struct core_name *cn, const char *fmt, ...)
+static int cn_vprintf(struct core_name *cn, const char *fmt, va_list arg)
 {
 	char *cur;
 	int need;
 	int ret;
-	va_list arg;
 
-	va_start(arg, fmt);
 	need = vsnprintf(NULL, 0, fmt, arg);
-	va_end(arg);
-
 	if (likely(need < cn->size - cn->used - 1))
 		goto out_printf;
 
@@ -89,9 +85,7 @@ static int cn_printf(struct core_name *cn, const char *fmt, ...)
 
 out_printf:
 	cur = cn->corename + cn->used;
-	va_start(arg, fmt);
 	vsnprintf(cur, need + 1, fmt, arg);
-	va_end(arg);
 	cn->used += need;
 	return 0;
 
@@ -99,6 +93,18 @@ expand_fail:
 	return ret;
 }
 
+static int cn_printf(struct core_name *cn, const char *fmt, ...)
+{
+	va_list arg;
+	int ret;
+
+	va_start(arg, fmt);
+	ret = cn_vprintf(cn, fmt, arg);
+	va_end(arg);
+
+	return ret;
+}
+
 static void cn_escape(char *str)
 {
 	for (; *str; str++)
-- 
1.5.5.1

