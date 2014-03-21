Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966426AbaCUAfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:35:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965906AbaCUAI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Adamson <andros@netapp.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 51/85] NFSv4: nfs4_stateid_is_current should return true for an invalid stateid
Date: Thu, 20 Mar 2014 17:09:54 -0700
Message-Id: <20140321000605.993433327@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3607,8 +3607,9 @@ static bool nfs4_stateid_is_current(nfs4
 {
 	nfs4_stateid current_stateid;
 
-	if (nfs4_set_rw_stateid(&current_stateid, ctx, l_ctx, fmode))
-		return false;
+	/* If the current stateid represents a lost lock, then exit */
+	if (nfs4_set_rw_stateid(&current_stateid, ctx, l_ctx, fmode) == -EIO)
+		return true;
 	return nfs4_stateid_match(stateid, &current_stateid);
 }
 


