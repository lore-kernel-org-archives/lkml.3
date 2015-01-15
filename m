Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbbAOWKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:10:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50448 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbbAOWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 06/19] userns: Check euid no fsuid when establishing an unprivileged uid mapping
Date: Thu, 15 Jan 2015 14:09:42 -0800
Message-Id: <1421359795-11155-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/user_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 4612096..8bdb421 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -809,7 +809,7 @@ static bool new_idmap_permitted(const struct file *file,
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, file->f_cred->fsuid))
+			if (uid_eq(uid, file->f_cred->euid))
 				return true;
 		}
 		else if (cap_setid == CAP_SETGID) {
-- 
1.9.1

