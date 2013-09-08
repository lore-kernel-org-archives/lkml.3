Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3IHDUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56058 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756275Ab3IHDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.630915814@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [118/121] ALSA: opti9xx: Fix conflicting driver object name
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/isa/opti9xx/opti92x-ad1848.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -173,11 +173,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_opti9x
 
 #endif	/* CONFIG_PNP */
 
-#ifdef OPTi93X
-#define DEV_NAME "opti93x"
-#else
-#define DEV_NAME "opti92x"
-#endif
+#define DEV_NAME KBUILD_MODNAME
 
 static char * snd_opti9xx_names[] = {
 	"unknown",
@@ -1126,7 +1122,7 @@ static void __devexit snd_opti9xx_pnp_re
 
 static struct pnp_card_driver opti9xx_pnpc_driver = {
 	.flags		= PNP_DRIVER_RES_DISABLE,
-	.name		= "opti9xx",
+	.name		= DEV_NAME,
 	.id_table	= snd_opti9xx_pnpids,
 	.probe		= snd_opti9xx_pnp_probe,
 	.remove		= __devexit_p(snd_opti9xx_pnp_remove),

