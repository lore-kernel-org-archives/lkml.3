Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab3LFNEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:04:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161855Ab3LFNEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 232/272] nfsd: return better errors to exportfs
Date: Fri,  6 Dec 2013 12:58:41 +0000
Message-Id: <1386334761-25517-233-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 427d6c6646d868fbd3094e7e2e1644d480cd9204 upstream.

Someone noticed exportfs happily accepted exports that would later be
rejected when mountd tried to give them to the kernel.  Fix this.

This is a regression from 4c1e1b34d5c800ad3ac9a7e2805b0bea70ad2278
"nfsd: Store ex_anon_uid and ex_anon_gid as kuids and kgids".

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Reported-by: Yin.JianHong <jiyin@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/export.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 5f38ea3..af51cf9 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -536,16 +536,12 @@ static int svc_export_parse(struct cache_detail *cd, char *mesg, int mlen)
 		if (err)
 			goto out3;
 		exp.ex_anon_uid= make_kuid(&init_user_ns, an_int);
-		if (!uid_valid(exp.ex_anon_uid))
-			goto out3;
 
 		/* anon gid */
 		err = get_int(&mesg, &an_int);
 		if (err)
 			goto out3;
 		exp.ex_anon_gid= make_kgid(&init_user_ns, an_int);
-		if (!gid_valid(exp.ex_anon_gid))
-			goto out3;
 
 		/* fsid */
 		err = get_int(&mesg, &an_int);
@@ -583,6 +579,17 @@ static int svc_export_parse(struct cache_detail *cd, char *mesg, int mlen)
 				   exp.ex_uuid);
 		if (err)
 			goto out4;
+		/*
+		 * For some reason exportfs has been passing down an
+		 * invalid (-1) uid & gid on the "dummy" export which it
+		 * uses to test export support.  To make sure exportfs
+		 * sees errors from check_export we therefore need to
+		 * delay these checks till after check_export:
+		 */
+		if (!uid_valid(exp.ex_anon_uid))
+			goto out4;
+		if (!gid_valid(exp.ex_anon_gid))
+			goto out4;
 	}
 
 	expp = svc_export_lookup(&exp);
-- 
1.8.3.2

