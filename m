Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab3E1DzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52631 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758914Ab3E1DyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Oleg Nesterov" <oleg@redhat.com>,
        "Lucas De Marchi" <lucas.demarchi@intel.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.323636849@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [40/94] usermodehelper: check subprocess_info->path != NULL
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/kmod.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -467,6 +467,11 @@ int call_usermodehelper_exec(struct subp
 	int retval = 0;
 
 	helper_lock();
+	if (!sub_info->path) {
+		retval = -EINVAL;
+		goto out;
+	}
+
 	if (sub_info->path[0] == '\0')
 		goto out;
 

