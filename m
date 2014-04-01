Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaDALRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42317 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbaDALRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 049/144] NFSv4: nfs4_stateid_is_current should return 'true' for an invalid stateid
Date: Tue,  1 Apr 2014 12:14:13 +0100
Message-Id: <1396350948-29910-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit e1253be0ece1a95a02c7f5843194877471af8179 upstream.

When nfs4_set_rw_stateid() can fails by returning EIO to indicate that
the stateid is completely invalid, then it makes no sense to have it
trigger a retry of the READ or WRITE operation. Instead, we should just
have it fall through and attempt a recovery.

This fixes an infinite loop in which the client keeps replaying the same
bad stateid back to the server.

Reported-by: Andy Adamson <andros@netapp.com>
Link: http://lkml.kernel.org/r/1393954269-3974-1-git-send-email-andros@netapp.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfs/nfs4proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 64dd7c6..7690917 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3825,8 +3825,9 @@ static bool nfs4_stateid_is_current(nfs4_stateid *stateid,
 {
 	nfs4_stateid current_stateid;
 
-	if (nfs4_set_rw_stateid(&current_stateid, ctx, l_ctx, fmode))
-		return false;
+	/* If the current stateid represents a lost lock, then exit */
+	if (nfs4_set_rw_stateid(&current_stateid, ctx, l_ctx, fmode) == -EIO)
+		return true;
 	return nfs4_stateid_match(stateid, &current_stateid);
 }
 
-- 
1.9.1

