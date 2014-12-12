Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934382AbaLLG0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:26:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52095 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759391AbaLLGRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:00 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.99686228@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 078/164] nfsd4: fix crash on unknown operation number
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 51904b08072a8bf2b9ed74d1bd7a5300a614471d upstream.

Unknown operation numbers are caught in nfsd4_decode_compound() which
sets op->opnum to OP_ILLEGAL and op->status to nfserr_op_illegal.  The
error causes the main loop in nfsd4_proc_compound() to skip most
processing.  But nfsd4_proc_compound also peeks ahead at the next
operation in one case and doesn't take similar precautions there.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1111,7 +1111,8 @@ static bool need_wrongsec_check(struct s
 	 */
 	if (argp->opcnt == resp->opcnt)
 		return false;
-
+	if (next->opnum == OP_ILLEGAL)
+		return false;
 	nextd = OPDESC(next);
 	/*
 	 * Rest of 2.6.3.1.1: certain operations will return WRONGSEC

