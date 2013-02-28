Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3B1Osf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:48:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42191 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3B1Osa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:48:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 066/139] NLM: Ensure that we resend all pending blocking locks after a reclaim
Date: Thu, 28 Feb 2013 14:43:36 +0000
Message-Id: <1362062689-2567-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 666b3d803a511fbc9bc5e5ea8ce66010cf03ea13 upstream.

Currently, nlmclnt_lock will break out of the for(;;) loop when
the reclaimer wakes up the blocking lock thread by setting
nlm_lck_denied_grace_period. This causes the lock request to fail
with an ENOLCK error.
The intention was always to ensure that we resend the lock request
after the grace period has expired.

Reported-by: Wangyuan Zhang <Wangyuan.Zhang@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/lockd/clntproc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/lockd/clntproc.c b/fs/lockd/clntproc.c
index 8392cb8..a3a0987 100644
--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -551,6 +551,9 @@ again:
 		status = nlmclnt_block(block, req, NLMCLNT_POLL_TIMEOUT);
 		if (status < 0)
 			break;
+		/* Resend the blocking lock request after a server reboot */
+		if (resp->status ==  nlm_lck_denied_grace_period)
+			continue;
 		if (resp->status != nlm_lck_blocked)
 			break;
 	}
-- 
1.8.1.2

