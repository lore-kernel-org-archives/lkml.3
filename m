Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaJ0S5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:57:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52388 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbaJ0S5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:41 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 020/105] mmc: tmio: prevent endless loop in tmio_mmc_set_clock()
Date: Mon, 27 Oct 2014 11:55:55 -0700
Message-Id: <1414436240-13879-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit bb98d9d1d2e791f368295c9c09c9a03fe3ac0e62 upstream.

I spent a couple of days with the driver just hanging due to me forgetting to
specify the external crystal frequency,  so that clk_get_rate() returned 0 and
thus the loop in tmio_mmc_set_clock() never ended. I don't think that's an
acceptable behavior, so I suggest that the minimum frequency is checked for 0
in tmio_mmc_host_probe().

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Acked-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mmc/host/tmio_mmc_pio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
index f3b2d8c..51add7f 100644
--- a/drivers/mmc/host/tmio_mmc_pio.c
+++ b/drivers/mmc/host/tmio_mmc_pio.c
@@ -1042,6 +1042,15 @@ int tmio_mmc_host_probe(struct tmio_mmc_host **host,
 	}
 
 	/*
+	 * Check the sanity of mmc->f_min to prevent tmio_mmc_set_clock() from
+	 * looping forever...
+	 */
+	if (mmc->f_min == 0) {
+		ret = -EINVAL;
+		goto host_free;
+	}
+
+	/*
 	 * There are 4 different scenarios for the card detection:
 	 *  1) an external gpio irq handles the cd (best for power savings)
 	 *  2) internal sdhi irq handles the cd
-- 
1.9.1

