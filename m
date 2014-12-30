Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaL3Wnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:43:47 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6740 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaL3Wno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:43:44 -0500
X-IronPort-AV: E=Sophos;i="5.07,668,1413270000"; 
   d="scan'208";a="53814394"
From: Jonathan Richardson <jonathar@broadcom.com>
To: Tim Kryger <tim.kryger@gmail.com>
CC: Scott Branden <sbranden@broadcom.com>,
        Arun Ramamurthy <arun.ramamurthy@broadcom.com>,
        Thierry Reding <thierry.reding@gmail.com>, Ray Jui <rjui@broadcom.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        <linux-kernel@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
        "Jonathan Richardson" <jonathar@broadcom.com>
Subject: [PATCH v4 3/3] pwm: core: Set enable state properly on failed call to enable
Date: Tue, 30 Dec 2014 14:43:30 -0800
Message-ID: <1419979410-7589-4-git-send-email-jonathar@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419979410-7589-1-git-send-email-jonathar@broadcom.com>
References: <Jonathan Richardson <jonathar@broadcom.com>
 <1419979410-7589-1-git-send-email-jonathar@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pwm_enable function didn't clear the enabled bit if a call to a
clients enable function returned an error. The result was that the state
of the pwm core was wrong. Clearing the bit when enable returns an error
ensures the state is properly set.

Signed-off-by: Jonathan Richardson <jonathar@broadcom.com>
---
 drivers/pwm/core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 966497d..641f6ec 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -457,8 +457,14 @@ EXPORT_SYMBOL_GPL(pwm_set_polarity);
  */
 int pwm_enable(struct pwm_device *pwm)
 {
-	if (pwm && !test_and_set_bit(PWMF_ENABLED, &pwm->flags))
-		return pwm->chip->ops->enable(pwm->chip, pwm);
+	int err;
+
+	if (pwm && !test_and_set_bit(PWMF_ENABLED, &pwm->flags)) {
+		err = pwm->chip->ops->enable(pwm->chip, pwm);
+		if (err)
+			clear_bit(PWMF_ENABLED, &pwm->flags);
+		return err;
+	}
 
 	return pwm ? 0 : -EINVAL;
 }
-- 
1.7.9.5

