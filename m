Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab3ETQ7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3ETQ7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:59:32 -0400
Date: Mon, 20 May 2013 18:55:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH] usermodehelper: kill the sub_info->path[0] check
Message-ID: <20130520165559.GA19645@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call_usermodehelper_exec() does nothing but returns success if
path[0] == 0. The only user which needs this strange feature is
request_module(), it can check modprobe_path[0] itself like other
users do if they want to detect the "disabled by admin" case.

Kill it. Not only it looks strange, it can confuse other callers.
And this allows us to revert 264b83c0 "usermodehelper: check
subprocess_info->path != NULL", do_execve(NULL) is safe.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 8241906..fb32636 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -147,6 +147,9 @@ int __request_module(bool wait, const char *fmt, ...)
 	 */
 	WARN_ON_ONCE(wait && current_is_async());
 
+	if (!modprobe_path[0])
+		return 0;
+
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
@@ -569,14 +572,6 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	int retval = 0;
 
 	helper_lock();
-	if (!sub_info->path) {
-		retval = -EINVAL;
-		goto out;
-	}
-
-	if (sub_info->path[0] == '\0')
-		goto out;
-
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
 		goto out;
-- 
1.5.5.1


