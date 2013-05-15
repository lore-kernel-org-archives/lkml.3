Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab3EOUQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:16:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699Ab3EOUQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:16:08 -0400
Date: Wed, 15 May 2013 22:12:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] coredump: '% at the end' shouldn't bypass
	core_uses_pid logic
Message-ID: <20130515201235.GA14651@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515201158.GA14606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"goto end" should not bypass the "Backward compatibility with
core_uses_pid" code, move this label up.

While at it,

	- It is ugly to copy '|' into cn->corename and then inc
	  the pointer for argv_split().

	  Change format_corename() to increment pat_ptr instead.

	- Remove the dead "if (*pat_ptr == 0)" in format_corename(),
	  we already checked it is not zero.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 10ba96a..a2ace9f 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -166,12 +166,13 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 	if (expand_corename(cn, core_name_size))
 		return -ENOMEM;
 
+	if (ispipe)
+		++pat_ptr;
+
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
 		if (*pat_ptr != '%') {
-			if (*pat_ptr == 0)
-				goto out;
 			err = cn_printf(cn, "%c", *pat_ptr++);
 		} else {
 			switch (*++pat_ptr) {
@@ -240,6 +241,7 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 			return err;
 	}
 
+out:
 	/* Backward compatibility with core_uses_pid:
 	 *
 	 * If core_pattern does not include a %p (as is the default)
@@ -250,7 +252,6 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 		if (err)
 			return err;
 	}
-out:
 	return ispipe;
 }
 
@@ -580,7 +581,7 @@ void do_coredump(siginfo_t *siginfo)
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, cn.corename+1, NULL);
+		helper_argv = argv_split(GFP_KERNEL, cn.corename, NULL);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
@@ -597,7 +598,7 @@ void do_coredump(siginfo_t *siginfo)
 
 		argv_free(helper_argv);
 		if (retval) {
-			printk(KERN_INFO "Core dump to %s pipe failed\n",
+			printk(KERN_INFO "Core dump to |%s pipe failed\n",
 			       cn.corename);
 			goto close_fail;
 		}
-- 
1.5.5.1

