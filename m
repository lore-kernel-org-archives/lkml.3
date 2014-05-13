Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761446AbaEMKqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:46:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60732 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759793AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        David Teigland <teigland@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 001/182] dlm: Avoid that dlm_release_lockspace() incorrectly returns -EBUSY
Date: Tue, 13 May 2014 11:25:53 +0200
Message-Id: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a97f4a66d8ee4faf0f31cc4ad3f4aa0baef23fc7 upstream.

When dlm_release_lockspace(ls, 1) is invoked on a busy system
immediately after the last dlm_unlock() AST has finished it can occur
that lkb_idr_is_local() is invoked for the unlocked LKB since removal
from ls_lkbidr only occurs after the AST has returned. If that happens
dlm_release_lockspace(ls, 1) will return -EBUSY instead of releasing
the lockspace. Fix this race condition by changing lkb_idr_is_local()
such that it only returns true for LKB's that have not yet been
unlocked.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/dlm/lockspace.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 88556dc0458e..d5abafd56a6d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -706,9 +706,7 @@ static int lkb_idr_is_local(int id, void *p, void *data)
 {
 	struct dlm_lkb *lkb = p;
 
-	if (!lkb->lkb_nodeid)
-		return 1;
-	return 0;
+	return lkb->lkb_nodeid == 0 && lkb->lkb_grmode != DLM_LOCK_IV;
 }
 
 static int lkb_idr_is_any(int id, void *p, void *data)
-- 
1.9.3

