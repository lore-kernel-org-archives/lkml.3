Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaEZTPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:15:51 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53743 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaEZTPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:15:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Warren <swarren@nvidia.com>, Dylan Reid <dgreid@chromium.org>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ALSA: hda: fix tegra build
Date: Mon, 26 May 2014 21:15:20 +0200
Message-ID: <4369871.VRtaiA22pI@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/jdRnocq1lJ2fjbhs2IPcaB+saoddhA9geyuXITfF++
 /NxBKlHiu+BOF4YB7q3bbvJ0VamHXxhcWV29zQEsTGR36qTwxO
 9PbGCIX1Q1bnEWfW9aeBPsRyUUE0rRmFV6Zvxz7c81i0UID8LF
 nCGR16UW5A6udlhFs4a661CkstezV34TJGXTXKSaIA/jftK2wN
 Y7HIVnvqbpDKZH7rv2Ftno/aAsJsUrK42xfzbyWFGfn7dnPg+H
 8IW3L1VoGxfnnYfdyeiY8FarkaKLuo4Q3ZUSdPr08P8dN6GjkR
 kPeaVrqrJow1vQ8+K9saxbiAQtDep8V7H89kBERyXd/ww8WzsE
 tu1x2XD21iGbbleFuWOc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_PM is disabled, the CONFIG_SND_HDA_POWER_SAVE_DEFAULT symbol
does not get defined, which causes a build error for the hda-tegra driver:

hda/hda_tegra.c:80:25: error: 'CONFIG_SND_HDA_POWER_SAVE_DEFAULT' undeclared here (not in a function)
 static int power_save = CONFIG_SND_HDA_POWER_SAVE_DEFAULT;
                         ^
/git/arm-soc/sound/pci/hda/hda_tegra.c:235:13: warning: 'hda_tegra_disable_clocks' defined but not used [-Wunused-function]
 static void hda_tegra_disable_clocks(struct hda_tegra *data)
             ^

This works around the problem by not referencing that macro
when CONFIG_PM is disabled. Instead, we assume that it's disabled
unconditionally and cannot be enabled at runtime.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dylan Reid <dgreid@chromium.org>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Takashi Iwai <tiwai@suse.de>
---
Same patch, but this time with correct Signed-off-by line.

diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index 086fd06..a366ba9 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -77,10 +77,14 @@ struct hda_tegra {
 	void __iomem *regs;
 };
 
+#ifdef CONFIG_PM
 static int power_save = CONFIG_SND_HDA_POWER_SAVE_DEFAULT;
 module_param(power_save, bint, 0644);
 MODULE_PARM_DESC(power_save,
 		 "Automatic power-saving timeout (in seconds, 0 = disable).");
+#else
+static int power_save = 0;
+#endif
 
 /*
  * DMA page allocation ops.

