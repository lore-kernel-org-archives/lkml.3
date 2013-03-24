Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3CXPpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:45:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab3CXPp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:45:29 -0400
Date: Sun, 24 Mar 2013 17:45:52 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Roland Dreier <roland@kernel.org>,
        "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: [PATCHv2] ibverbs: add a new IBV_ACCESS_GIFT option
Message-ID: <20130324154552.GA16346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment registering an MR breaks COW.  If the application does not
care that adapter sees stale data (for example, it tracks writes
reregisters and resends), it can use a new IBV_ACCESS_GIFT flag to
prevent registration from breaking COW.

The semantics are similar to that of SPLICE_F_GIFT thus the name.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This is compiled but untested. Michael, could you please try
this patch (together with the kernel patch I'm sending separately)
and report whether setting this flag unbreaks overcommit for you?

 include/infiniband/verbs.h | 3 ++-
 man/ibv_reg_mr.3           | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 6acfc81..3290ec9 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -290,7 +290,8 @@ enum ibv_access_flags {
 	IBV_ACCESS_REMOTE_WRITE		= (1<<1),
 	IBV_ACCESS_REMOTE_READ		= (1<<2),
 	IBV_ACCESS_REMOTE_ATOMIC	= (1<<3),
-	IBV_ACCESS_MW_BIND		= (1<<4)
+	IBV_ACCESS_MW_BIND		= (1<<4),
+	IBV_ACCESS_GIFT			= (1<<6)
 };
 
 struct ibv_pd {
diff --git a/man/ibv_reg_mr.3 b/man/ibv_reg_mr.3
index 7723771..3c302f0 100644
--- a/man/ibv_reg_mr.3
+++ b/man/ibv_reg_mr.3
@@ -34,6 +34,8 @@ describes the desired memory protection attributes; it is either 0 or the bitwis
 .B IBV_ACCESS_REMOTE_ATOMIC\fR Enable Remote Atomic Operation Access (if supported)
 .TP
 .B IBV_ACCESS_MW_BIND\fR       Enable Memory Window Binding
+.TP
+.B IBV_ACCESS_GIFT\fR          This memory is a gift to the adapter: if memory is modified after registration, the local version and data seen by the adapter through this region rkey may differ
 .PP
 If
 .B IBV_ACCESS_REMOTE_WRITE
@@ -43,6 +45,9 @@ is set, then
 .B IBV_ACCESS_LOCAL_WRITE
 must be set too.
 .PP
+.B IBV_ACCESS_GIFT
+is only legal with remote or local read access.
+.PP
 Local read access is always enabled for the MR.
 .PP
 .B ibv_dereg_mr()
-- 
MST
