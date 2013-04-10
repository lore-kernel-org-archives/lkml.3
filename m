Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238Ab3DJXIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:08:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937226Ab3DJWrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [ 47/64] NFSv4: Fix a memory leak in nfs4_discover_server_trunking
Date: Wed, 10 Apr 2013 15:46:44 -0700
Message-Id: <20130410224344.314992147@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b193d59a4863ea670872d76dc99231ddeb598625 upstream.

When we assign a new rpc_client to clp->cl_rpcclient, we need to destroy
the old one.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4state.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1877,7 +1877,13 @@ again:
 			status = PTR_ERR(clnt);
 			break;
 		}
-		clp->cl_rpcclient = clnt;
+		/* Note: this is safe because we haven't yet marked the
+		 * client as ready, so we are the only user of
+		 * clp->cl_rpcclient
+		 */
+		clnt = xchg(&clp->cl_rpcclient, clnt);
+		rpc_shutdown_client(clnt);
+		clnt = clp->cl_rpcclient;
 		goto again;
 
 	case -NFS4ERR_MINOR_VERS_MISMATCH:


