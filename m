Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbaAFXG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:06:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaAFWlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Durgin <josh.durgin@inktank.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <alex.elder@linaro.org>
Subject: [PATCH 3.10 112/129] rbd: fix null dereference in dout
Date: Mon,  6 Jan 2014 14:39:01 -0800
Message-Id: <20140106223902.799208515@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@inktank.com>

commit c35455791c1131e7ccbf56ea6fbdd562401c2ce2 upstream.

The order parameter is sometimes NULL in _rbd_dev_v2_snap_size(), but
the dout() always derefences it. Move this to another dout() protected
by a check that order is non-NULL.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <alex.elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3712,12 +3712,14 @@ static int _rbd_dev_v2_snap_size(struct
 	if (ret < sizeof (size_buf))
 		return -ERANGE;
 
-	if (order)
+	if (order) {
 		*order = size_buf.order;
+		dout("  order %u", (unsigned int)*order);
+	}
 	*snap_size = le64_to_cpu(size_buf.size);
 
-	dout("  snap_id 0x%016llx order = %u, snap_size = %llu\n",
-		(unsigned long long)snap_id, (unsigned int)*order,
+	dout("  snap_id 0x%016llx snap_size = %llu\n",
+		(unsigned long long)snap_id,
 		(unsigned long long)*snap_size);
 
 	return 0;


