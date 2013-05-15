Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab3EOUQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:16:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749Ab3EOUQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:16:10 -0400
Date: Wed, 15 May 2013 22:12:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] coredump: kill cn_escape(), introduce cn_esc_printf()
Message-ID: <20130515201229.GA14641@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515201158.GA14606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of cn_escape() looks really annoying, imho this
sequence needs a wrapper. And it is buggy. If cn_printf()
does expand_corename() cn_escape() writes to the freed
memory.

Introduce cn_esc_printf() which hopefully does this all right.
It records the index before cn_vprintf(), not "char *" which
is no longer valid (in general) after krealloc().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   44 +++++++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 2b1d1f5..8b42688 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -99,11 +99,21 @@ static int cn_printf(struct core_name *cn, const char *fmt, ...)
 	return ret;
 }
 
-static void cn_escape(char *str)
+static int cn_esc_printf(struct core_name *cn, const char *fmt, ...)
 {
-	for (; *str; str++)
-		if (*str == '/')
-			*str = '!';
+	int cur = cn->used;
+	va_list arg;
+	int ret;
+
+	va_start(arg, fmt);
+	ret = cn_vprintf(cn, fmt, arg);
+	va_end(arg);
+
+	for (; cur < cn->used; ++cur) {
+		if (cn->corename[cur] == '/')
+			cn->corename[cur] = '!';
+	}
+	return ret;
 }
 
 static int cn_print_exe_file(struct core_name *cn)
@@ -113,12 +123,8 @@ static int cn_print_exe_file(struct core_name *cn)
 	int ret;
 
 	exe_file = get_mm_exe_file(current->mm);
-	if (!exe_file) {
-		char *commstart = cn->corename + cn->used;
-		ret = cn_printf(cn, "%s (path unknown)", current->comm);
-		cn_escape(commstart);
-		return ret;
-	}
+	if (!exe_file)
+		ret = cn_esc_printf(cn, "%s (path unknown)", current->comm);
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
@@ -132,9 +138,7 @@ static int cn_print_exe_file(struct core_name *cn)
 		goto free_buf;
 	}
 
-	cn_escape(path);
-
-	ret = cn_printf(cn, "%s", path);
+	ret = cn_esc_printf(cn, "%s", path);
 
 free_buf:
 	kfree(pathbuf);
@@ -207,22 +211,16 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 				break;
 			}
 			/* hostname */
-			case 'h': {
-				char *namestart = cn->corename + cn->used;
+			case 'h':
 				down_read(&uts_sem);
-				err = cn_printf(cn, "%s",
+				err = cn_esc_printf(cn, "%s",
 					      utsname()->nodename);
 				up_read(&uts_sem);
-				cn_escape(namestart);
 				break;
-			}
 			/* executable */
-			case 'e': {
-				char *commstart = cn->corename + cn->used;
-				err = cn_printf(cn, "%s", current->comm);
-				cn_escape(commstart);
+			case 'e':
+				err = cn_esc_printf(cn, "%s", current->comm);
 				break;
-			}
 			case 'E':
 				err = cn_print_exe_file(cn);
 				break;
-- 
1.5.5.1

