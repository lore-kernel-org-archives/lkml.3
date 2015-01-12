Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbbALSG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:06:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57810 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbbALSGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:06:51 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 109/216] userns: Check euid no fsuid when establishing an unprivileged uid mapping
Date: Mon, 12 Jan 2015 18:03:46 +0000
Message-Id: <1421085933-32536-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/user_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index b96763a25a68..16b716e8184c 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -819,7 +819,7 @@ static bool new_idmap_permitted(const struct file *file,
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, file->f_cred->fsuid))
+			if (uid_eq(uid, file->f_cred->euid))
 				return true;
 		}
 	}
-- 
2.1.4

