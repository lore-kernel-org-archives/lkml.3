Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3CTLca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:32:30 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:65519 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757776Ab3CTLc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:32:27 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] BUG: pinmux: forbid mux_usecount to be set at UINT_MAX
Date: Wed, 20 Mar 2013 12:31:52 +0100
Message-Id: <1363779113-8776-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com>
References: <1363779113-8776-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pin_free is called on a pin already freed, mux_usecount is set to
UINT_MAX which is really a bad idea.
This will silently ignore a double call to pin_free

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/pinctrl/pinmux.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 917e830..9fd55f9 100644
--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -194,8 +194,9 @@ static const char *pin_free(struct pinctrl_dev *pctldev, int pin,
 	}
 
 	if (!gpio_range) {
-		desc->mux_usecount--;
-		if (desc->mux_usecount)
+		if (1 == desc->mux_usecount)
+			desc->mux_usecount = 0;
+		else
 			return NULL;
 	}
 
-- 
1.7.2.5

