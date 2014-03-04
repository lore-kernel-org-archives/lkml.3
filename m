Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbaCDVgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:36:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbaCDUCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Adamson <andros@netapp.com>, NeilBrown <neilb@suse.de>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.13 035/172] NFS fix error return in nfs4_select_rw_stateid
Date: Tue,  4 Mar 2014 12:01:59 -0800
Message-Id: <20140304200300.846492013@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Adamson <andros@netapp.com>

commit 146d70caaa1b87f64597743429d7da4b8073d0c9 upstream.

Do not return an error when nfs4_copy_delegation_stateid succeeds.

Signed-off-by: Andy Adamson <andros@netapp.com>
Link: http://lkml.kernel.org/r/1392737765-41942-1-git-send-email-andros@netapp.com
Fixes: ef1820f9be27b (NFSv4: Don't try to recover NFSv4 locks when...)
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1015,8 +1015,11 @@ int nfs4_select_rw_stateid(nfs4_stateid
 	if (ret == -EIO)
 		/* A lost lock - don't even consider delegations */
 		goto out;
-	if (nfs4_copy_delegation_stateid(dst, state->inode, fmode))
+	/* returns true if delegation stateid found and copied */
+	if (nfs4_copy_delegation_stateid(dst, state->inode, fmode)) {
+		ret = 0;
 		goto out;
+	}
 	if (ret != -ENOENT)
 		/* nfs4_copy_delegation_stateid() didn't over-write
 		 * dst, so it still has the lock stateid which we now


