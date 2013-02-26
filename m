Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3BZX63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab3BZX6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Balaji T K <balajitk@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [ 120/150] mmc: core: expose RPMB partition only for CMD23 capable hosts
Date: Tue, 26 Feb 2013 15:56:17 -0800
Message-Id: <20130226235536.574936583@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balaji T K <balajitk@ti.com>

commit d0123ccac55088811bde4f76c4a3fdbd39c3cfba upstream.

SET_BLOCK_COUNT CMD23 is needed for all access to RPMB partition.  If
block count is not set by CMD23, all subsequent read/write commands fail
as per eMMC specification. So, If the host does not support CMD23, do not
expose RPMB partition.

Accessing RPMB partition can cause hang / huge delay for hosts which do
not support CMD23.

Signed-off-by: Balaji T K <balajitk@ti.com>
Reported-and-Tested-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -496,7 +496,7 @@ static int mmc_read_ext_csd(struct mmc_c
 		 * RPMB regions are defined in multiples of 128K.
 		 */
 		card->ext_csd.raw_rpmb_size_mult = ext_csd[EXT_CSD_RPMB_MULT];
-		if (ext_csd[EXT_CSD_RPMB_MULT]) {
+		if (ext_csd[EXT_CSD_RPMB_MULT] && mmc_host_cmd23(card->host)) {
 			mmc_part_add(card, ext_csd[EXT_CSD_RPMB_MULT] << 17,
 				EXT_CSD_PART_CONFIG_ACC_RPMB,
 				"rpmb", 0, false,


