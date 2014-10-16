Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaJPOFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:05:09 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43160 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaJPOFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:05:06 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-1d-543fd0903721
Message-id: <1413468302.5605.9.camel@AMDC1943>
Subject: PM/runtime issue: Device cannot runtime resume because power domain is
 off during system resume
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Oct 2014 16:05:02 +0200
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Zd0JF+xDDC4v47KYNWUvk8XlXXPY
	LD73HmG0uHvqKJvFmdOXWB1YPRbvecnkseVqO4vHitXf2T0+b5ILYInisklJzcksSy3St0vg
	yljzeQ57wSbuigd3GlkaGL9xdDFyckgImEh8efWVDcIWk7hwbz2QzcUhJLCUUWLDmnOMEM5n
	Rokpc64wg1TxCuhJtK56zg5iCwtkSdza9IAFxGYTMJbYvHwJWLcISPecMx8YQRIsAqoSl/bs
	B1vBLKAuMWneIqBBHEDrlCUa+90gZgpK/Jh8jwWiRF5i85q3zBMYeWch6ZiFpGwWkrIFjMyr
	GEVTS5MLipPScw31ihNzi0vz0vWS83M3MUIC8MsOxsXHrA4xCnAwKvHwagTbhwixJpYVV+Ye
	YpTgYFYS4T12CijEm5JYWZValB9fVJqTWnyIkYmDU6qBkcXl9X2V6+0JHGmP57FWPNY67yTt
	3T2d70v3/oUs7vGntd7/lf0iunadpaz53yPOiwN3d+5YYToxWO2fRPXRfqUZ3vdDPrtld6tI
	GJX/ODzpnqD0niIngXdX9f7mTRef7fjuneGUi62rJA5ovT72Madh40PPVzNtnxybs9jw5hsX
	v/m1qrG895RYijMSDbWYi4oTASmaFLceAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I encounter issues with DRM/panel driver for Exynos after resuming from
suspend to RAM. This is reproduced on 3.16 but I think it is applicable
also to mainline.

The scenario:
0. DRM DSI is in LCD power domain. Power domain is OFF before
suspending.
1. System suspends.
2. System resumes.
3. DRM driver:resume().
4. pm_runtime_get() for DRM DSI driver.
5. This should enable LCD power domain.
6. but __pm_genpd_poweron() exits early because:
   genpd->prepared_count = 3
   genpd->suspend_power_off = 1
  in domain.c:183

7. The domain is not powered on but it is marked as active.
8. The DRM driver thinks everything is OK and proceeds with resume...
but it fails because whole power domain is OFF.

The question: Shouldn't the power domain be powered up EARLY?

Something like this:

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 40bc2f4072cc..4fdfe404a04c 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -179,8 +179,7 @@ static int __pm_genpd_poweron(struct
        }
        finish_wait(&genpd->status_wait_queue, &wait);
 
-       if (genpd->status == GPD_STATE_ACTIVE
-           || (genpd->prepared_count > 0 && genpd->suspend_power_off))
+       if (genpd->status == GPD_STATE_ACTIVE)
                return 0;
 
        if (genpd->status != GPD_STATE_POWER_OFF) {


If not... how to solve the scenario above?

Best regards,
Krzyszto

