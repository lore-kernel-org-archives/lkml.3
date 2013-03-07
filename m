Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3CGJph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:45:37 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:49374 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3CGJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:45:35 -0500
Message-ID: <1362649361.14735.5.camel@beeld>
Subject: [PATCH] nsproxy: Fix ->nsproxy counting problem in copy_namespace.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 07 Mar 2013 15:42:41 +0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From cd41495e25cf2641ffe9e01a40d3d221a46b08be Mon Sep 17 00:00:00 2001
From: Rakib Mullick <rakib.mullick@gmail.com>
Date: Thu, 7 Mar 2013 14:52:20 +0600
Subject: [PATCH] nsproxy: Fix ->nsproxy counting problem in copy_namespace.

In copy_namespace(), get_nsproxy() (which increments nsproxy->count) is called before checking namespace related flags.
Therefore, task's nsproxy->count could have improper value, which could lead to calling free_nsproxy unnecessarily. Also,
incrementing nsproxy->count is an atomic operation (which is expensive than normal increment operation), so before
doing it - it's better we make sure namespace related flags are set.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---
 kernel/nsproxy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index afc0456..de36209 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -130,12 +130,12 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
 	if (!old_ns)
 		return 0;
 
-	get_nsproxy(old_ns);
-
 	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
 				CLONE_NEWPID | CLONE_NEWNET)))
 		return 0;
 
+	get_nsproxy(old_ns);
+
 	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
 		err = -EPERM;
 		goto out;
-- 
1.7.11.7



