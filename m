Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbaIOWW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:22:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51392 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbaIOWUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:20:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 037/187] nfs: check if gssd is running before attempting to use krb5i auth in SETCLIENTID call
Date: Mon, 15 Sep 2014 15:07:27 -0700
Message-Id: <1410818997-9432-38-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 6aa23d76a7b549521a03b63b6d5b7880ea87eab7 upstream.

Currently, the client will attempt to use krb5i in the SETCLIENTID call
even if rpc.gssd isn't running. When that fails, it'll then fall back to
RPC_AUTH_UNIX. This introduced a delay when mounting if rpc.gssd isn't
running, and causes warning messages to pop up in the ring buffer.

Check to see if rpc.gssd is running before even attempting to use krb5i
auth, and just silently skip trying to do so if it isn't. In the event
that the admin is actually trying to mount with krb5*, it will still
fail at a later stage of the mount attempt.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/nfs4client.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4client.c b/fs/nfs/nfs4client.c
index cb70bdd..4c7bd2c 100644
--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -10,6 +10,7 @@
 #include <linux/sunrpc/auth.h>
 #include <linux/sunrpc/xprt.h>
 #include <linux/sunrpc/bc_xprt.h>
+#include <linux/sunrpc/rpc_pipe_fs.h>
 #include "internal.h"
 #include "callback.h"
 #include "delegation.h"
@@ -370,7 +371,11 @@ struct nfs_client *nfs4_init_client(struct nfs_client *clp,
 		__set_bit(NFS_CS_INFINITE_SLOTS, &clp->cl_flags);
 	__set_bit(NFS_CS_DISCRTRY, &clp->cl_flags);
 	__set_bit(NFS_CS_NO_RETRANS_TIMEOUT, &clp->cl_flags);
-	error = nfs_create_rpc_client(clp, timeparms, RPC_AUTH_GSS_KRB5I);
+
+	error = -EINVAL;
+	if (gssd_running(clp->cl_net))
+		error = nfs_create_rpc_client(clp, timeparms,
+					      RPC_AUTH_GSS_KRB5I);
 	if (error == -EINVAL)
 		error = nfs_create_rpc_client(clp, timeparms, RPC_AUTH_UNIX);
 	if (error < 0)
-- 
1.9.1

