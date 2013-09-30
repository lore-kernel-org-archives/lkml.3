Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3I3KLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:11:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43334 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3I3KLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 003/104] ALSA: opti9xx: Fix conflicting driver object name
Date: Mon, 30 Sep 2013 11:09:40 +0100
Message-Id: <1380535881-9239-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit fb615499f0ad28ed74201c1cdfddf9e64e205424 upstream.

The recent commit to delay the release of kobject triggered NULL
dereferences of opti9xx drivers.  The cause is that all
snd-opti92x-ad1848, snd-opti92x-cs4231 and snd-opti93x drivers
register the PnP card driver with the very same name, and also
snd-opti92x-ad1848 and -cs4231 drivers register the ISA driver with
the same name, too.  When these drivers are built in, quick
"register-release-and-re-register" actions occur, and this results in
Oops because of the same name is assigned to the kobject.

The fix is simply to assign individual names.  As a bonus, by using
KBUILD_MODNAME, the patch reduces more lines than it adds.

The fix is based on the suggestion by Russell King.

Reported-and-tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/isa/opti9xx/opti92x-ad1848.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index d7ccf28..4589acd 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -173,11 +173,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_opti9xx_pnpids);
 
 #endif	/* CONFIG_PNP */
 
-#ifdef OPTi93X
-#define DEV_NAME "opti93x"
-#else
-#define DEV_NAME "opti92x"
-#endif
+#define DEV_NAME KBUILD_MODNAME
 
 static char * snd_opti9xx_names[] = {
 	"unknown",
@@ -1126,7 +1122,7 @@ static void __devexit snd_opti9xx_pnp_remove(struct pnp_card_link * pcard)
 
 static struct pnp_card_driver opti9xx_pnpc_driver = {
 	.flags		= PNP_DRIVER_RES_DISABLE,
-	.name		= "opti9xx",
+	.name		= DEV_NAME,
 	.id_table	= snd_opti9xx_pnpids,
 	.probe		= snd_opti9xx_pnp_probe,
 	.remove		= __devexit_p(snd_opti9xx_pnp_remove),
-- 
1.8.3.2

