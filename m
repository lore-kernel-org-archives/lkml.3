Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab3EGNiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:38:55 -0400
Received: from beta.dmz-eu.st.com ([164.129.1.35]:47325 "EHLO
	beta.dmz-eu.st.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758587Ab3EGNiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:38:54 -0400
X-Greylist: delayed 1355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 09:38:54 EDT
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: broonie@kernel.org
Cc: srinivas.kandagatla@st.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] regmap: debugfs: Fix start_reg calculation
Date: Tue,  7 May 2013 14:11:37 +0100
Message-Id: <1367932297-27926-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

If we dump syscon regmap registers via debufs you will notice that the
dump contains lot of XXXXXXXX values at the end.

An example configuration is:
syscon@fdde0000{
	compatible      = "syscon";
	reg		= <0xfdde0000 0x15c>;
};

example dump:
cat  /sys/kernel/debug/regmap/fdde0000.syscon/registers
...
154: 001c1dff
158: 00000003
05a: XXXXXXXX
05e: XXXXXXXX
...

regmap_debugfs_get_dump_start returns register number, not the actual
offset into the map. So we use the return value as start to dump the 
registers we can endup with wrong start address, in the example case
for the second loop the code ends up with start_reg = 0x56. Which is
incorrect.
Also this keeps incremeting by stride, which can than result in
unaligned address.

This patch multiples the return value of regmap_debugfs_get_dump_start
with stride to get the correct offset into the map.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/base/regmap/regmap-debugfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 81d6f60..4a66e54 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -190,6 +190,7 @@ static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 
 	/* Work out which register we're starting at */
 	start_reg = regmap_debugfs_get_dump_start(map, from, *ppos, &p);
+	start_reg *= map->reg_stride;
 
 	for (i = start_reg; i <= to; i += map->reg_stride) {
 		if (!regmap_readable(map, i))
-- 
1.7.6.5

