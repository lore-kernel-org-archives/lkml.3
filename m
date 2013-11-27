Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab3K0A7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:59:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab3K0A7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Yin.JianHong" <jiyin@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.12 068/116] nfsd: return better errors to exportfs
Date: Tue, 26 Nov 2013 16:57:21 -0800
Message-Id: <20131127005741.640897306@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/export.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -536,16 +536,12 @@ static int svc_export_parse(struct cache
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
@@ -583,6 +579,17 @@ static int svc_export_parse(struct cache
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


