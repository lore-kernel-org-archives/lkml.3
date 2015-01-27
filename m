Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbbA0Ma2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:30:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbbA0MTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 088/126] LOCKD: Fix a race when initialising nlmsvc_timeout
Date: Tue, 27 Jan 2015 12:16:33 +0000
Message-Id: <1422361031-19364-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 06bed7d18c2c07b3e3eeadf4bd357f6e806618cc upstream.

This commit fixes a race whereby nlmclnt_init() first starts the lockd
daemon, and then calls nlm_bind_host() with the expectation that
nlmsvc_timeout has already been initialised. Unfortunately, there is no
no synchronisation between lockd() and lockd_up() to guarantee that this
is the case.

Fix is to move the initialisation of nlmsvc_timeout into lockd_create_svc

Fixes: 9a1b6bf818e74 ("LOCKD: Don't call utsname()->nodename...")
Cc: Bruce Fields <bfields@fieldses.org>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/lockd/svc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index ec9e082f9ecd..3f5a7248e771 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -137,10 +137,6 @@ lockd(void *vrqstp)
 
 	dprintk("NFS locking service started (ver " LOCKD_VERSION ").\n");
 
-	if (!nlm_timeout)
-		nlm_timeout = LOCKD_DFLT_TIMEO;
-	nlmsvc_timeout = nlm_timeout * HZ;
-
 	/*
 	 * The main request loop. We don't terminate until the last
 	 * NFS mount or NFS daemon has gone away.
@@ -346,6 +342,10 @@ static struct svc_serv *lockd_create_svc(void)
 		printk(KERN_WARNING
 			"lockd_up: no pid, %d users??\n", nlmsvc_users);
 
+	if (!nlm_timeout)
+		nlm_timeout = LOCKD_DFLT_TIMEO;
+	nlmsvc_timeout = nlm_timeout * HZ;
+
 	serv = svc_create(&nlmsvc_program, LOCKD_BUFSIZE, NULL);
 	if (!serv) {
 		printk(KERN_WARNING "lockd_up: create service failed\n");
-- 
2.1.4

