Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3CNKhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3CNKg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 12/88] ALSA: bt87x: Make load_all parameter working again
Date: Thu, 14 Mar 2013 10:35:05 +0000
Message-Id: <1363257381-15900-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit aacfddfdadb3540651d263245069631f341e953a upstream.

Along with a clean up commit [e9f66d9b9: ALSA: pci: clean up using
module_pci_driver()], bt87x driver lost the functionality of load_all
parameter.  This patch does a partial revert of the commit only for
bt87x.c to recover it.

Reported-by: Clemens Ladisch <cladisch@googlemail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/bt87x.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index b6a95ee..62d6163 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -836,6 +836,8 @@ static struct {
 	{0x7063, 0x2000}, /* pcHDTV HD-2000 TV */
 };
 
+static struct pci_driver driver;
+
 /* return the id of the card, or a negative value if it's blacklisted */
 static int __devinit snd_bt87x_detect_card(struct pci_dev *pci)
 {
@@ -962,11 +964,24 @@ static DEFINE_PCI_DEVICE_TABLE(snd_bt87x_default_ids) = {
 	{ }
 };
 
-static struct pci_driver bt87x_driver = {
+static struct pci_driver driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_bt87x_ids,
 	.probe = snd_bt87x_probe,
 	.remove = __devexit_p(snd_bt87x_remove),
 };
 
-module_pci_driver(bt87x_driver);
+static int __init alsa_card_bt87x_init(void)
+{
+	if (load_all)
+		driver.id_table = snd_bt87x_default_ids;
+	return pci_register_driver(&driver);
+}
+
+static void __exit alsa_card_bt87x_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
+module_init(alsa_card_bt87x_init)
+module_exit(alsa_card_bt87x_exit)
-- 
1.8.1.2

