Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3CULWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:22:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39929 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab3CULWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:22:08 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Cc: Axel Lin <axel.lin@ingics.com>, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] BUG: pinmux: forbid mux_usecount to be set at UINT_MAX
Date: Thu, 21 Mar 2013 12:21:47 +0100
Message-Id: <1363864907-28351-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <5149ED25.4010309@wwwdotorg.org>
References: <5149ED25.4010309@wwwdotorg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pin_free is called on a pin already freed, mux_usecount is set to
UINT_MAX which is really a bad idea.
This will issue a warning, so that we can correct the code responsible
for the double free.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
Ok Stephen, your idea (and code) seems better.
I signed-off it, but it's really yours...
Feel free to transform my Signed-off-by in a Tested-by

 drivers/pinctrl/pinmux.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 1a00658..bd83c8b 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -194,6 +194,11 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 	}
 
 	if (!gpio_range) {
+		/*
+		 * A pin should not be freed more times than allocated.
+		 */
+		if (WARN_ON(!desc->mux_usecount))
+			return NULL;
 		desc->mux_usecount--;
 		if (desc->mux_usecount)
 			return NULL;
-- 
1.7.2.5

