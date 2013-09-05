Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab3IEUcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:32:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab3IEU2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 02/14] ALSA: opti9xx: Fix conflicting driver object name
Date: Thu,  5 Sep 2013 13:28:13 -0700
Message-Id: <20130905202614.699124005@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202614.354156084@linuxfoundation.org>
References: <20130905202614.354156084@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/isa/opti9xx/opti92x-ad1848.c |    8 ++------
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


