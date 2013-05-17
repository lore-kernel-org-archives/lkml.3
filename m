Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3EQVk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:40:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab3EQViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 095/102] usermodehelper: check subprocess_info->path != NULL
Date: Fri, 17 May 2013 14:36:50 -0700
Message-Id: <20130517213254.214204806@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 264b83c07a84223f0efd0d1db9ccc66d6f88288f upstream.

argv_split(empty_or_all_spaces) happily succeeds, it simply returns
argc == 0 and argv[0] == NULL. Change call_usermodehelper_exec() to
check sub_info->path != NULL to avoid the crash.

This is the minimal fix, todo:

 - perhaps we should change argv_split() to return NULL or change the
   callers.

 - kill or justify ->path[0] check

 - narrow the scope of helper_lock()

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-By: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kmod.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -570,6 +570,11 @@ int call_usermodehelper_exec(struct subp
 	int retval = 0;
 
 	helper_lock();
+	if (!sub_info->path) {
+		retval = -EINVAL;
+		goto out;
+	}
+
 	if (sub_info->path[0] == '\0')
 		goto out;
 


