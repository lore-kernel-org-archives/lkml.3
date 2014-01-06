Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbaAFWmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:42:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbaAFWmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:42:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 098/129] libceph: fix truncate size calculation
Date: Mon,  6 Jan 2014 14:38:47 -0800
Message-Id: <20140106223902.405012485@linuxfoundation.org>
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

From: "Yan, Zheng" <zheng.z.yan@intel.com>

commit ccca4e37b1a912da3db68aee826557ea66145273 upstream.

check the "not truncated yet" case

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -733,12 +733,14 @@ struct ceph_osd_request *ceph_osdc_new_r
 
 	object_size = le32_to_cpu(layout->fl_object_size);
 	object_base = off - objoff;
-	if (truncate_size <= object_base) {
-		truncate_size = 0;
-	} else {
-		truncate_size -= object_base;
-		if (truncate_size > object_size)
-			truncate_size = object_size;
+	if (!(truncate_seq == 1 && truncate_size == -1ULL)) {
+		if (truncate_size <= object_base) {
+			truncate_size = 0;
+		} else {
+			truncate_size -= object_base;
+			if (truncate_size > object_size)
+				truncate_size = object_size;
+		}
 	}
 
 	osd_req_op_extent_init(req, 0, opcode, objoff, objlen,


