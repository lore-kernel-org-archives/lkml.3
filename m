Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbaGHBQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:16:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaGGXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>, Pekon Gupta <pekon@ti.com>
Subject: [PATCH 3.15 023/122] mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in erased-page
Date: Mon,  7 Jul 2014 16:56:25 -0700
Message-Id: <20140707235734.942717975@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: pekon gupta <pekon@ti.com>

commit f306e8c3b667632952f1a4a74ffb910bbc06255f upstream.

fixes: commit 62116e5171e00f85a8d53f76e45b84423c89ff34
       mtd: nand: omap2: Support for hardware BCH error correction.

In omap_elm_correct_data(), if bitflip_count in an erased-page is within the
correctable limit (< ecc.strength), then it is not indicated back to the caller
ecc->read_page().

This mis-guides upper layers like MTD and UBIFS layer to assume erased-page as
perfectly clean and use it for writing even if actual bitflip_count was
dangerously high (bitflip_count > mtd->bitflip_threshold).

This patch fixes this above issue, by returning 'stats' to caller
ecc->read_page() under all scenarios.

Reported-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/omap2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1382,7 +1382,7 @@ static int omap_elm_correct_data(struct
 
 	/* Check if any error reported */
 	if (!is_error_reported)
-		return 0;
+		return stat;
 
 	/* Decode BCH error using ELM module */
 	elm_decode_bch_error_page(info->elm_dev, ecc_vec, err_vec);


