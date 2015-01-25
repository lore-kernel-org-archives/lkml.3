Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705AbbAYTL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:11:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbbAYSJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.14 81/98] LOCKD: Fix a race when initialising nlmsvc_timeout
Date: Sun, 25 Jan 2015 10:07:39 -0800
Message-Id: <20150125180716.406363496@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Cc: stable@vger.kernel.org # 3.10.x
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/svc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
@@ -346,6 +342,10 @@ static struct svc_serv *lockd_create_svc
 		printk(KERN_WARNING
 			"lockd_up: no pid, %d users??\n", nlmsvc_users);
 
+	if (!nlm_timeout)
+		nlm_timeout = LOCKD_DFLT_TIMEO;
+	nlmsvc_timeout = nlm_timeout * HZ;
+
 	serv = svc_create(&nlmsvc_program, LOCKD_BUFSIZE, NULL);
 	if (!serv) {
 		printk(KERN_WARNING "lockd_up: create service failed\n");


