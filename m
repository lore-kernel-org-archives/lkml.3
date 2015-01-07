Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbbAGCa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:30:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589AbbAGCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:16:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.17 50/73] userns: Check euid no fsuid when establishing an unprivileged uid mapping
Date: Tue,  6 Jan 2015 18:16:11 -0800
Message-Id: <20150107021559.053811569@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/user_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -819,7 +819,7 @@ static bool new_idmap_permitted(const st
 		u32 id = new_map->extent[0].lower_first;
 		if (cap_setid == CAP_SETUID) {
 			kuid_t uid = make_kuid(ns->parent, id);
-			if (uid_eq(uid, file->f_cred->fsuid))
+			if (uid_eq(uid, file->f_cred->euid))
 				return true;
 		}
 	}


