Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaAMWp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 17:45:59 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:53286 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaAMWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 17:45:54 -0500
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: keescook@chromium.org, james.l.morris@oracle.com,
        akpm@linux-foundation.com, oleg@redhat.com, viro@zeniv.linux.org.uk,
        nschichan@freebox.fr, Will Drewry <wad@chromium.org>, rob@landley.net,
        linux-doc@vger.kernel.org
Subject: [PATCH 3/3] Documentation/prctl/seccomp_filter.txt: document extensions
Date: Mon, 13 Jan 2014 16:42:18 -0600
Message-Id: <1389652941-19030-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389645028-17157-2-git-send-email-wad@chromium.org>
References: <1389645028-17157-2-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(missed this on the first run)

Add an entry for the PR_SECCOMP_EXT entry point and the
only existing consumer, SECCOMP_EXT_ACT_TSYNC.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 Documentation/prctl/seccomp_filter.txt |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 1e469ef..b296701 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -166,10 +166,36 @@ The samples/seccomp/ directory contains both an x86-specific example
 and a more generic example of a higher level macro interface for BPF
 program generation.
 
+Extensions
+----------
+
+SECCOMP_MODE_FILTER supports an additional entry point for accessing
+extended behavior through prctl(PR_SECCOMP_EXT).  Only one extension
+exists today:
+
+SECCOMP_EXT_ACT_TSYNC:
+	If the calling task is running under SECCOMP_MODE_FILTER, it
+	may call prctl() to synchronize the seccomp filter of its
+	threads.  As seccomp behavior is per-task, any thread under
+	SECCOMP_MODE_STRICT will be unaffected, as will any thread
+	under SECCOMP_MODE_FILTER that does not have a filter that is
+	in the filter tree ancestry for the caller.  Any threads that
+	are in SECCOMP_MODE_NONE will be transitioned to
+	SECCOMP_MODE_FILTER if possible.
+
+	Usage:
+		prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_TSYNC, 0, 0);
+
+	If any threads cannot be transitioned, the call will return one
+	of the process ids.  All other threads will have been transitioned.
+	A return value of 0 indicates success. On a negative return value,
+	the errno will be populated appropriately:
+		EINVAL indicates invalid arguments.
+		EACCES indicates invalid seccomp mode.
 
 
 Adding architecture support
------------------------
+---------------------------
 
 See arch/Kconfig for the authoritative requirements.  In general, if an
 architecture supports both ptrace_event and seccomp, it will be able to
-- 
1.7.9.5

