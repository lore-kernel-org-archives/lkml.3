Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaJ1LeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:34:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9459 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753921AbaJ1LeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:34:04 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] usb: gadget: don't create new string_container if already exist
Date: Tue, 28 Oct 2014 19:33:58 +0800
Message-ID: <1414496039-5655-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-28_05:2014-10-28,2014-10-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1410280112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't create new usb_gadget_string_container if the current strings are
already exist in the usb_composite_dev.
Otherwise the ids_tab will overflow soon if we bind / unbind usb
functions frequently like android does.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/gadget/composite.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index a8c18df..6fe3c6b 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1183,6 +1183,12 @@ struct usb_string *usb_gstrings_attach(struct usb_composite_dev *cdev,
 	if (!n_gstrings)
 		return ERR_PTR(-EINVAL);
 
+	list_for_each_entry(uc, &cdev->gstrings, list) {
+		n_gs = get_containers_gs(uc);
+		if (!strcmp(n_gs[0]->strings[0].s, sp[0]->strings[0].s))
+			return n_gs[0]->strings;
+	}
+
 	uc = copy_gadget_strings(sp, n_gstrings, n_strings);
 	if (IS_ERR(uc))
 		return ERR_CAST(uc);
-- 
1.7.9.5

