Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbaGDMw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:52:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38513 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaGDMwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:52:41 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-cb-53b6a3979fd0
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: cw00.choi@samsung.com
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 3/3] extcon: max77693: Force using UART path for jig
Date: Fri, 04 Jul 2014 15:51:26 +0300
Message-id: <8f9245d605cd5c679d1ec06180bc49be38b10da8.1404478227.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1404478227.git.d.kasatkin@samsung.com>
References: <cover.1404478227.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1404478227.git.d.kasatkin@samsung.com>
References: <cover.1404478227.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xy7rTF28LNujczW5x/ctzVotbf/cy
	W3SefcJscXnXHDaL240r2BxYPfq2rGL0+LxJLoApissmJTUnsyy1SN8ugSvj9qFvjAX/OSu+
	LvvG3MA4i6OLkZNDQsBEYs302awQtpjEhXvr2boYuTiEBJYySnw9fYYJwulkkmj7uJURpIpN
	QE9iQ/MP9i5GDg4RAUmJln1mIDXMAnMZJe7MvcACUiMs4CLR37abDcRmEVCVmNvQxAxSzysQ
	J7HwqQ3EMjmJk8cmgy3mFLCS2PnxEzuILSRgKfH4czMjLvEJjPwLGBlWMYqmliYXFCel5xrq
	FSfmFpfmpesl5+duYoSE1JcdjIuPWR1iFOBgVOLhbVyxIViINbGsuDL3EKMEB7OSCK/WnG3B
	QrwpiZVVqUX58UWlOanFhxiZODilGhhbk5NiEg4IR/Gr/o/2DLs6P83CPsdxctidqeeXXt0q
	WTbx/MtDLNLtqrH3914ou7Kad/qJ2PJdRyqy73WGLZ6598ShTw+sv0fo7P0uEPn+4nk5HTXb
	Xp1/DHHpArbvZucsvvPVtJU7tpcvMZn15kS+mexF96b3nO9OTPGrvn0xZuVh3231Lg1KLMUZ
	iYZazEXFiQCL6engBwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When USB cable is connected to jig, device disables console.
This patch forces using UART when jig cable is connected.
It allows to charge the device, which also prevents it from sleeping.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 1b194b3..862d68f 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -296,10 +296,18 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 		return ret;
 	}
 
-	if (attached)
-		ctrl1 = val;
-	else
+	if (attached) {
+		if (info->prev_cable_type ==
+		    MAX77693_MUIC_ADC_FACTORY_MODE_UART_OFF) {
+			/* if cable_type is jig, then force UART */
+			dev_info(info->dev, "For jig force using UART path\n");
+			ctrl1 = CONTROL1_SW_UART;
+		} else {
+			ctrl1 = val;
+		}
+	} else {
 		ctrl1 = CONTROL1_SW_OPEN;
+	}
 
 	ret = max77693_update_reg(info->max77693->regmap_muic,
 			MAX77693_MUIC_REG_CTRL1, ctrl1, COMP_SW_MASK);
-- 
1.9.1

