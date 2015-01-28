Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbbA2KUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:20:03 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756846AbbA2JA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:59 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Bruce Fields <bfields@fieldses.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 129/176] LOCKD: Fix a race when initialising nlmsvc_timeout
Date: Wed, 28 Jan 2015 15:29:19 +0100
Message-Id: <47427496998a44df34bdc1b47fca647e8398716b.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <trond.myklebust@primarydata.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 06bed7d18c2c07b3e3eeadf4bd357f6e806618cc upstream.

This commit fixes a race whereby nlmclnt_init() first starts the lockd
daemon, and then calls nlm_bind_host() with the expectation that
nlmsvc_timeout has already been initialised. Unfortunately, there is no
no synchronisation between lockd() and lockd_up() to guarantee that this
is the case.

Fix is to move the initialisation of nlmsvc_timeout into lockd_create_svc

Fixes: 9a1b6bf818e74 ("LOCKD: Don't call utsname()->nodename...")
Cc: Bruce Fields <bfields@fieldses.org>
Cc: stable@vger.kernel.org # 3.10.x
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/lockd/svc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 223e1cb14345..59a53f664005 100644
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
2.2.2

