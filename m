Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbaEMJgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:36:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60922 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760118AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>,
        Roland Dreier <roland@purestorage.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 068/182] IB/mthca: Return an error on ib_copy_to_udata() failure
Date: Tue, 13 May 2014 11:27:00 +0200
Message-Id: <343ef31e82f332a4f4a4d104449e1645a5d79911.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 08e74c4b00c30c232d535ff368554959403d0432 upstream.

In case of error when writing to userspace, the function mthca_create_cq()
does not set an error code before following its error path.

This patch sets the error code to -EFAULT when ib_copy_to_udata() fails.

This was caught when using spatch (aka. coccinelle)
to rewrite call to ib_copy_{from,to}_udata().

Link: https://www.gitorious.org/opteya/coccib/source/75ebf2c1033c64c1d81df13e4ae44ee99c989eba:ib_copy_udata.cocci
Link: http://marc.info/?i=cover.1394485254.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 5b71d43bd89c..42dde06fdb91 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -695,6 +695,7 @@ static struct ib_cq *mthca_create_cq(struct ib_device *ibdev, int entries,
 
 	if (context && ib_copy_to_udata(udata, &cq->cqn, sizeof (__u32))) {
 		mthca_free_cq(to_mdev(ibdev), cq);
+		err = -EFAULT;
 		goto err_free;
 	}
 
-- 
1.9.3

