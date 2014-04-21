Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaDULPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 07:15:07 -0400
Received: from [207.46.163.144] ([207.46.163.144]:32482 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbaDULPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 07:15:02 -0400
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <lgirdwood@gmail.com>, <tiwai@suse.de>, <perex@perex.cz>
Subject: [PATCH] ASoC: core: Don't break component searching if both id and num_dai are 0
Date: Mon, 21 Apr 2014 19:14:46 +0800
Message-ID: <1398078886-31505-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(81342001)(50226001)(93916002)(36756003)(46102001)(62966002)(4396001)(81542001)(50986999)(47776003)(20776003)(80022001)(76482001)(48376002)(86362001)(92566001)(77096999)(92726001)(50466002)(83072002)(89996001)(99396002)(87936001)(79102001)(88136002)(77982001)(6806004)(31966008)(74502001)(85852003)(87286001)(74662001)(77156001)(19580395003)(83322001)(19580405001)(80976001)(44976005);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB028;H:az84smr01.freescale.net;FPR:3A5DDE31.2C96C588.41E73F7F.86EEEA72.201F5;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0188D66E61
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit e41975ed (ASoC: core: Fix the DAI name getting) added a break
within the "if (id < 0 || id >= pos->num_dai)" while the original design
of the search didn't break the loop if that condition contented but only
mark the ret error and let it go on to search the next component.

In a case like dmaengine which's not a dai but as a component sharing an
identical name with a dai, both the id and pos->num_dai here could be 0.
If we break the search, we may never find the dai we want as it might be
placed behind its dmaengine in the component list.

So this patch fixes the issue above by following the original design to
let the search carry on.

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 sound/soc/soc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a17c047..82e9fdf 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -4591,7 +4591,7 @@ int snd_soc_of_get_dai_name(struct device_node *of_node,
 
 			if (id < 0 || id >= pos->num_dai) {
 				ret = -EINVAL;
-				break;
+				continue;
 			}
 
 			ret = 0;
-- 
1.8.4

