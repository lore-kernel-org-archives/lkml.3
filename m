Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab3ISJu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:50:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35555 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab3ISJux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:50:53 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-a6-523ac8fc30dd
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 4/7] USB: gadget: s3c-hsotg: add DAINT masking
Date: Thu, 19 Sep 2013 11:50:20 +0200
Message-id: <1379584223-15232-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
References: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQd0/J6yCDLp7hSw2zljPanHwfr1F
	8+L1bBZnm96wW1zeNYfNYtGyVmaLtUfusls8OLyT3YHDY//cNewefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujMcztrEW/OOouHb+NEsD40b2LkZODgkBE4krR04wQthiEhfurWfr
	YuTiEBKYziix/fwzZpCEkEA7k0TvGTMQm01AR2LL9wlgDSICAhLrX1xiB2lgFnjCKDH1yCuw
	qcICjhLX515kA7FZBFQlXp7fzARi8wq4Snx+/AUozgG0TUFiziQbkDCngJvExPOvWSB2uUo8
	3vSFbQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwSH1TGoH48oGi0OMAhyMSjy8
	ERcsg4RYE8uKK3MPMUpwMCuJ8M45ZBUkxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdAq3WgkEB6
	YklqdmpqQWoRTJaJg1OqgXH1/LhnFf932xdHtEQtC0v0fPg++2hh19Tyn5O1fzmyH66dnBpo
	8bhH+pBD0f8HXXV6khe/iOSZq3pf/15nOzVRcM73bfr1V9u5/hW3XPx/KqrSg7HYhoONdeH7
	16+mKl49V//5/6d25RfN2m+yM444M5Ru17t39ret3qTsM581VV9u5J3cyKrEUpyRaKjFXFSc
	CADLGKLgJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In OEPInt/IEPInt interrupts handling added bitwise and of DAINT and
DAINTMSK, because we should handle masked interrupts only.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 3024685d..e32f868 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2398,10 +2398,14 @@ irq_retry:
 
 	if (gintsts & (GINTSTS_OEPInt | GINTSTS_IEPInt)) {
 		u32 daint = readl(hsotg->regs + DAINT);
-		u32 daint_out = daint >> DAINT_OutEP_SHIFT;
-		u32 daint_in = daint & ~(daint_out << DAINT_OutEP_SHIFT);
+		u32 daintmsk = readl(hsotg->regs + DAINTMSK);
+		u32 daint_out, daint_in;
 		int ep;
 
+		daint &= daintmsk;
+		daint_out = daint >> DAINT_OutEP_SHIFT;
+		daint_in = daint & ~(daint_out << DAINT_OutEP_SHIFT);
+
 		dev_dbg(hsotg->dev, "%s: daint=%08x\n", __func__, daint);
 
 		for (ep = 0; ep < 15 && daint_out; ep++, daint_out >>= 1) {
-- 
1.7.9.5

