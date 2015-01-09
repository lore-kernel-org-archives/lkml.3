Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbbAIKkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:21 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44573 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757481AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 61/78] userns: Check euid no fsuid when establishing an unprivileged uid mapping
Date: Fri,  9 Jan 2015 11:32:10 +0100
Message-Id: <6cffb2520aba06a0df8ddbe0917175e07475431a.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 80dd00a23784b384ccea049bfb3f259d3f973b9d upstream.

setresuid allows the euid to be set to any of uid, euid, suid, and
fsuid.  Therefor it is safe to allow an unprivileged user to map
their euid and use CAP_SETUID privileged with exactly that uid,
as no new credentials can be obtained.

I can not find a combination of existing system calls that allows setting
uid, euid, suid, and fsuid from the fsuid making the previous use
of fsuid for allowing unprivileged mappings a bug.

This is part of a fix for CVE-2014-8989.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/user_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index a5809c42a1b3..6e495bd672a7 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -805,7 +805,7 @@ static bool new_idmap_permitted(const struct file *file,
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, file->f_cred->fsuid))
+			if (uid_eq(uid, file->f_cred->euid))
 				return true;
 		}
 	}
-- 
2.2.1

