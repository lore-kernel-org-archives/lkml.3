Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbaKLD2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:28:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbaKLBdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:33:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.17 257/319] nfsd4: fix crash on unknown operation number
Date: Wed, 12 Nov 2014 10:16:35 +0900
Message-Id: <20141112011035.297536390@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 51904b08072a8bf2b9ed74d1bd7a5300a614471d upstream.

Unknown operation numbers are caught in nfsd4_decode_compound() which
sets op->opnum to OP_ILLEGAL and op->status to nfserr_op_illegal.  The
error causes the main loop in nfsd4_proc_compound() to skip most
processing.  But nfsd4_proc_compound also peeks ahead at the next
operation in one case and doesn't take similar precautions there.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1229,7 +1229,8 @@ static bool need_wrongsec_check(struct s
 	 */
 	if (argp->opcnt == resp->opcnt)
 		return false;
-
+	if (next->opnum == OP_ILLEGAL)
+		return false;
 	nextd = OPDESC(next);
 	/*
 	 * Rest of 2.6.3.1.1: certain operations will return WRONGSEC


