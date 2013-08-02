Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3HBTdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:33:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab3HBTdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:33:03 -0400
Date: Fri, 2 Aug 2013 21:27:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Zach Levis <zml@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] exec: kill ->load_binary != NULL check in
	search_binary_handler()
Message-ID: <20130802192736.GA9568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802192713.GA9543@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

search_binary_handler() checks ->load_binary != NULL for no reason,
this method should be always defined. Turn this check into WARN_ON()
and move it into __register_binfmt().

Also, kill the function pointer. The current code looks confusing,
as if ->load_binary can go away after read_unlock(&binfmt_lock).
But we rely on module_get(fmt->module), this fmt can't be changed
or unregistered, otherwise this code is buggy anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ef70320..9f41e7d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -74,6 +74,8 @@ static DEFINE_RWLOCK(binfmt_lock);
 void __register_binfmt(struct linux_binfmt * fmt, int insert)
 {
 	BUG_ON(!fmt);
+	if (WARN_ON(!fmt->load_binary))
+		return;
 	write_lock(&binfmt_lock);
 	insert ? list_add(&fmt->lh, &formats) :
 		 list_add_tail(&fmt->lh, &formats);
@@ -1389,14 +1391,11 @@ int search_binary_handler(struct linux_binprm *bprm)
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
 		list_for_each_entry(fmt, &formats, lh) {
-			int (*fn)(struct linux_binprm *) = fmt->load_binary;
-			if (!fn)
-				continue;
 			if (!try_module_get(fmt->module))
 				continue;
 			read_unlock(&binfmt_lock);
 			bprm->recursion_depth++;
-			retval = fn(bprm);
+			retval = fmt->load_binary(bprm);
 			bprm->recursion_depth--;
 			if (retval >= 0) {
 				put_binfmt(fmt);
-- 
1.5.5.1

