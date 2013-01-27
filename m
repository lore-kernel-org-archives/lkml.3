Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3A0Wxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:53:49 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:38156 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab3A0Wxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:53:43 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: bzhao@marvell.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] mwifiex: avoid out of bounds access in mwifiex_get_common_rates.
Date: Sun, 27 Jan 2013 23:42:48 +0100
Message-Id: <1359326568-17022-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check that the array indexes are in-bounds before accessing the rate2 and tmp
arrays.

Found with the following semantic patch:

<smpl>
@@
identifier t;
identifier idx;
expression E;
statement S;
@@
* for (... ; <+... t[idx] ...+> && idx < E ; ...)
S
</smpl>

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/net/wireless/mwifiex/join.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 893d809..f0a634d 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -157,8 +157,8 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 
 	memset(rate1, 0, rate1_size);
 
-	for (i = 0; rate2[i] && i < rate2_size; i++) {
-		for (j = 0; tmp[j] && j < rate1_size; j++) {
+	for (i = 0; i < rate2_size && rate2[i]; i++) {
+		for (j = 0; j < rate1_size && tmp[j]; j++) {
 			/* Check common rate, excluding the bit for
 			   basic rate */
 			if ((rate2[i] & 0x7F) == (tmp[j] & 0x7F)) {
-- 
1.7.10.4

