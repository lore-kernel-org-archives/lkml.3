Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3K0A5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:57:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab3K0A5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 3.10 51/80] NFSv4: dont reprocess cached open CLAIM_PREVIOUS
Date: Tue, 26 Nov 2013 16:57:20 -0800
Message-Id: <20131127005644.495361416@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weston Andros Adamson <dros@netapp.com>

commit d2bfda2e7aa036f90ccea610a657064b1e267913 upstream.

Cached opens have already been handled by _nfs4_opendata_reclaim_to_nfs4_state
and can safely skip being reprocessed, but must still call update_open_stateid
to make sure that all active fmodes are recovered.

Signed-off-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1159,10 +1159,13 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 	struct nfs4_state *state = data->state;
 	int ret;
 
-	/* allow cached opens (!rpc_done && !rpc_status) */
-	if (!data->rpc_done && data->rpc_status) {
-		ret = data->rpc_status;
-		goto err;
+	if (!data->rpc_done) {
+		if (data->rpc_status) {
+			ret = data->rpc_status;
+			goto err;
+		}
+		/* cached opens have already been processed */
+		goto update;
 	}
 
 	ret = -ENOMEM;
@@ -1176,6 +1179,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(str
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
+update:
 	update_open_stateid(state, &data->o_res.stateid, NULL,
 			    data->o_arg.fmode);
 


