Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370Ab3K0BuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:50:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3K0A5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.10 52/80] NFSv4: Fix state reference counting in _nfs4_opendata_reclaim_to_nfs4_state
Date: Tue, 26 Nov 2013 16:57:21 -0800
Message-Id: <20131127005644.562622789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit d49f042aeec99c5f87160bb52dd52088b1051311 upstream.

Currently, if the call to nfs_refresh_inode fails, then we end up leaking
a reference count, due to the call to nfs4_get_open_state.
While we're at it, replace nfs4_get_open_state with a simple call to
atomic_inc(); there is no need to do a full lookup of the struct nfs_state
since it is passed as an argument in the struct nfs4_opendata, and
is already assigned to the variable 'state'.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1168,11 +1168,6 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 		goto update;
 	}
 
-	ret = -ENOMEM;
-	state = nfs4_get_open_state(inode, data->owner);
-	if (state == NULL)
-		goto err;
-
 	ret = nfs_refresh_inode(inode, &data->f_attr);
 	if (ret)
 		goto err;
@@ -1182,6 +1177,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 update:
 	update_open_stateid(state, &data->o_res.stateid, NULL,
 			    data->o_arg.fmode);
+	atomic_inc(&state->count);
 
 	return state;
 err:


