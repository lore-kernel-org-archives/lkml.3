Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3IKE5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3IKE4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:50 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=jaaXmWPtUZkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=VYAIF170pFYA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=0kPLrQdw3YYA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042932.114401809@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [239/251] ALSA: opti9xx: Fix conflicting driver object name
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0239-ALSA-opti9xx-Fix-conflicting-driver-object-name.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit fb615499f0ad28ed74201c1cdfddf9e64e205424 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/isa/opti9xx/opti92x-ad1848.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index f8fbe22..e7ec347 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -172,11 +172,7 @@ MODULE_DEVICE_TABLE(pnp_card, snd_opti9xx_pnpids);
 
 #endif	/* CONFIG_PNP */
 
-#ifdef OPTi93X
-#define DEV_NAME "opti93x"
-#else
-#define DEV_NAME "opti92x"
-#endif
+#define DEV_NAME KBUILD_MODNAME
 
 static char * snd_opti9xx_names[] = {
 	"unknown",
@@ -1180,7 +1176,7 @@ static int snd_opti9xx_pnp_resume(struct pnp_card_link *pcard)
 
 static struct pnp_card_driver opti9xx_pnpc_driver = {
 	.flags		= PNP_DRIVER_RES_DISABLE,
-	.name		= "opti9xx",
+	.name		= DEV_NAME,
 	.id_table	= snd_opti9xx_pnpids,
 	.probe		= snd_opti9xx_pnp_probe,
 	.remove		= __devexit_p(snd_opti9xx_pnp_remove),
-- 
1.7.10.4


