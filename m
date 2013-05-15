Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab3EOUQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:16:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625Ab3EOUQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:16:06 -0400
Date: Wed, 15 May 2013 22:12:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] coredump: kill call_count, add core_name_size
Message-ID: <20130515201232.GA14648@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515201158.GA14606@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imho, "atomic_t call_count" is ugly and should die. It buys
nothing and in fact it can grow more than necessary, expand
doesn't check if it was already incremented by another task.

Kill it, and introduce "static int core_name_size" updated by
expand_corename(). This is obviously racy too but harmless,
and core_name_size never grows for no reason.

We do not bother to to calculate the "right" new size, we
simply do kmalloc(size_we_need) and use ksize() to rely on
kmalloc_index's decision.

Finally change format_corename() to use expand_corename(),
krealloc(NULL) is fine.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 8b42688..10ba96a 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -45,26 +45,28 @@
 #include <trace/events/sched.h>
 
 int core_uses_pid;
-char core_pattern[CORENAME_MAX_SIZE] = "core";
 unsigned int core_pipe_limit;
+char core_pattern[CORENAME_MAX_SIZE] = "core";
+static int core_name_size = CORENAME_MAX_SIZE;
 
 struct core_name {
 	char *corename;
 	int used, size;
 };
-static atomic_t call_count = ATOMIC_INIT(1);
 
 /* The maximal length of core_pattern is also specified in sysctl.c */
 
-static int expand_corename(struct core_name *cn)
+static int expand_corename(struct core_name *cn, int size)
 {
-	int size = CORENAME_MAX_SIZE * atomic_inc_return(&call_count);
 	char *corename = krealloc(cn->corename, size, GFP_KERNEL);
 
 	if (!corename)
 		return -ENOMEM;
 
-	cn->size = size;
+	if (size > core_name_size) /* racy but harmless */
+		core_name_size = size;
+
+	cn->size = ksize(corename);
 	cn->corename = corename;
 	return 0;
 }
@@ -81,7 +83,7 @@ again:
 		return 0;
 	}
 
-	if (!expand_corename(cn))
+	if (!expand_corename(cn, cn->size + need - free + 1))
 		goto again;
 
 	return -ENOMEM;
@@ -160,9 +162,8 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 	int err = 0;
 
 	cn->used = 0;
-	cn->size = CORENAME_MAX_SIZE * atomic_read(&call_count);
-	cn->corename = kmalloc(cn->size, GFP_KERNEL);
-	if (!cn->corename)
+	cn->corename = NULL;
+	if (expand_corename(cn, core_name_size))
 		return -ENOMEM;
 
 	/* Repeat as long as we have more pattern to process and more output
-- 
1.5.5.1

