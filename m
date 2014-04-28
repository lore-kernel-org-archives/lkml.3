Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaD1Bbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42887 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752524AbaD1B3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland Dreier" <roland@purestorage.com>,
        "Yann Droneaud" <ydroneaud@opteya.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.320597291@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 71/94] IB/ehca: Returns an error on ib_copy_to_udata()
 failure
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yann Droneaud <ydroneaud@opteya.com>

commit 5bdb0f02add5994b0bc17494f4726925ca5d6ba1 upstream.

In case of error when writing to userspace, function ehca_create_cq()
does not set an error code before following its error path.

This patch sets the error code to -EFAULT when ib_copy_to_udata()
fails.

This was caught when using spatch (aka. coccinelle)
to rewrite call to ib_copy_{from,to}_udata().

Link: https://www.gitorious.org/opteya/coccib/source/75ebf2c1033c64c1d81df13e4ae44ee99c989eba:ib_copy_udata.cocci
Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/hw/ehca/ehca_cq.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -296,6 +296,7 @@ struct ib_cq *ehca_create_cq(struct ib_d
 			(my_cq->galpas.user.fw_handle & (PAGE_SIZE - 1));
 		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
 			ehca_err(device, "Copy to udata failed.");
+			cq = ERR_PTR(-EFAULT);
 			goto create_cq_exit4;
 		}
 	}

