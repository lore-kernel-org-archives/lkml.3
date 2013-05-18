Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657Ab3ERDAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab3ERDAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:07 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=uB9Vxy_hztgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Q9XzrnMwiiEA:10 a=JDjsHSkAAAAA:8 a=VwQbUJbxAAAA:8 a=9ZeapjglKACuKqVwk_oA:9 a=Hf6muOzgCGQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021652.412604872@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 066/136 ] NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in
 nfs4_open_delegation_recall
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0066-NFSv4-Handle-NFS4ERR_DELAY-and-NFS4ERR_GRACE-in-nfs4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ Upstream commit 8b6cc4d6f841d31f72fe7478453759166d366274 ]

A server shouldn't normally return NFS4ERR_GRACE if the client holds a
delegation, since no conflicting lock reclaims can be granted, however
the spec does not require the server to grant the open in this
instance

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/nfs/nfs4proc.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 2c6c214..4d135ef 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1383,6 +1383,12 @@ int nfs4_open_delegation_recall(struct nfs_open_context *ctx, struct nfs4_state
 			case -ENOMEM:
 				err = 0;
 				goto out;
+			case -NFS4ERR_DELAY:
+			case -NFS4ERR_GRACE:
+				set_bit(NFS_DELEGATED_STATE, &state->flags);
+				ssleep(1);
+				err = -EAGAIN;
+				goto out;
 		}
 		err = nfs4_handle_exception(server, err, &exception);
 	} while (exception.retry);
-- 
1.7.10.4


