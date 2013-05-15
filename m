Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab3EOUQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:16:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab3EOUQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:16:03 -0400
Date: Wed, 15 May 2013 22:12:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] coredump: format_corename() can leak cn->corename
Message-ID: <20130515201219.GA14624@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515201158.GA14606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_coredump() assumes that format_corename() can only fail if
expand_corename() fails and frees cn->corename. This is not true,
for example cn_print_exe_file() can fail and in this case nobody
frees cn->corename.

Change do_coredump() to always do kfree(cn->corename) after it
calls format_corename() (NULL is fine), change expand_corename()
to do nothing if kmalloc() fails.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index dafafba..11bc368 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -58,16 +58,14 @@ static atomic_t call_count = ATOMIC_INIT(1);
 
 static int expand_corename(struct core_name *cn)
 {
-	char *old_corename = cn->corename;
+	int size = CORENAME_MAX_SIZE * atomic_inc_return(&call_count);
+	char *corename = krealloc(cn->corename, size, GFP_KERNEL);
 
-	cn->size = CORENAME_MAX_SIZE * atomic_inc_return(&call_count);
-	cn->corename = krealloc(old_corename, cn->size, GFP_KERNEL);
-
-	if (!cn->corename) {
-		kfree(old_corename);
+	if (!corename)
 		return -ENOMEM;
-	}
 
+	cn->size = size;
+	cn->corename = corename;
 	return 0;
 }
 
@@ -157,10 +155,9 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 	int pid_in_pattern = 0;
 	int err = 0;
 
+	cn->used = 0;
 	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
 	cn->corename = kmalloc(cn->size, GFP_KERNEL);
-	cn->used = 0;
-
 	if (!cn->corename)
 		return -ENOMEM;
 
@@ -549,7 +546,7 @@ void do_coredump(siginfo_t *siginfo)
 		if (ispipe < 0) {
 			printk(KERN_WARNING "format_corename failed\n");
 			printk(KERN_WARNING "Aborting core\n");
-			goto fail_corename;
+			goto fail_unlock;
 		}
 
 		if (cprm.limit == 1) {
@@ -669,7 +666,6 @@ fail_dropcount:
 		atomic_dec(&core_dump_count);
 fail_unlock:
 	kfree(cn.corename);
-fail_corename:
 	coredump_finish(mm, core_dumped);
 	revert_creds(old_cred);
 fail_creds:
-- 
1.5.5.1

