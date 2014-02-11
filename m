Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaBKTjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:39:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbaBKTHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.10 31/79] NFSv4.1: Handle errors correctly in nfs41_walk_client_list
Date: Tue, 11 Feb 2014 11:05:35 -0800
Message-Id: <20140211184721.827588757@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 64590daa9e0dfb3aad89e3ab9230683b76211d5b upstream.

Both nfs41_walk_client_list and nfs40_walk_client_list expect the
'status' variable to be set to the value -NFS4ERR_STALE_CLIENTID
if the loop fails to find a match.
The problem is that the 'pos->cl_cons_state > NFS_CS_READY' changes
the value of 'status', and sets it either to the value '0' (which
indicates success), or to the value EINTR.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4client.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -324,9 +324,10 @@ int nfs40_walk_client_list(struct nfs_cl
 			prev = pos;
 
 			status = nfs_wait_client_init_complete(pos);
-			spin_lock(&nn->nfs_client_lock);
 			if (status < 0)
-				continue;
+				goto out;
+			status = -NFS4ERR_STALE_CLIENTID;
+			spin_lock(&nn->nfs_client_lock);
 		}
 		if (pos->cl_cons_state != NFS_CS_READY)
 			continue;
@@ -464,7 +465,8 @@ int nfs41_walk_client_list(struct nfs_cl
 			}
 			spin_lock(&nn->nfs_client_lock);
 			if (status < 0)
-				continue;
+				break;
+			status = -NFS4ERR_STALE_CLIENTID;
 		}
 		if (pos->cl_cons_state != NFS_CS_READY)
 			continue;


