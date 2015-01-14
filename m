Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbbANH3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:29:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbbANH3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@primarydata.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.18 105/150] nfsd: fix fi_delegees leak when fi_had_conflict returns true
Date: Tue, 13 Jan 2015 23:22:56 -0800
Message-Id: <20150114072100.614420922@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@primarydata.com>

commit 94ae1db226a5bcbb48372d81161f084c9e283fd8 upstream.

Currently, nfs4_set_delegation takes a reference to an existing
delegation and then checks to see if there is a conflict. If there is
one, then it doesn't release that reference.

Change the code to take the reference after the check and only if there
is no conflict.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3890,11 +3890,11 @@ nfs4_set_delegation(struct nfs4_client *
 		status = nfs4_setlease(dp);
 		goto out;
 	}
-	atomic_inc(&fp->fi_delegees);
 	if (fp->fi_had_conflict) {
 		status = -EAGAIN;
 		goto out_unlock;
 	}
+	atomic_inc(&fp->fi_delegees);
 	hash_delegation_locked(dp, fp);
 	status = 0;
 out_unlock:


