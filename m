Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbaF1SyF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:54:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53267 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbaF1RtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3.14 007/110] extcon: max14577: Fix probe failure on successful work queue
Date: Sat, 28 Jun 2014 10:46:04 -0700
Message-Id: <20140628174545.756385876@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit 12adef5b49e98eb181b4163c36e2998169e1379b upstream.

In probe the driver queued delayed work for cable detection and
returned the result of queue_delayed_work() call. However the return
value of queue_delayed_work() does not indicate an error and in normal
condition it returns true which means successful work queue.
This effectively resulted in probe failure:
[    2.088204] max14577-muic: probe of max77836-muic failed with error 1

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 962e56bfcf0b ("extcon: max14577: Add extcon-max14577 driver...")
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/extcon/extcon-max14577.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -710,13 +710,8 @@ static int max14577_muic_probe(struct pl
 	 * driver should notify cable state to upper layer.
 	 */
 	INIT_DELAYED_WORK(&info->wq_detcable, max14577_muic_detect_cable_wq);
-	ret = queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
+	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
 			delay_jiffies);
-	if (ret < 0) {
-		dev_err(&pdev->dev,
-			"failed to schedule delayed work for cable detect\n");
-		goto err_extcon;
-	}
 
 	return ret;
 


