Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaEDQE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:04:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36611 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbaEDPme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.10 50/86] IB/ehca: Returns an error on ib_copy_to_udata() failure
Date: Sun,  4 May 2014 11:41:25 -0400
Message-Id: <20140504154147.214802809@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/ehca/ehca_cq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -283,6 +283,7 @@ struct ib_cq *ehca_create_cq(struct ib_d
 			(my_cq->galpas.user.fw_handle & (PAGE_SIZE - 1));
 		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
 			ehca_err(device, "Copy to udata failed.");
+			cq = ERR_PTR(-EFAULT);
 			goto create_cq_exit4;
 		}
 	}


