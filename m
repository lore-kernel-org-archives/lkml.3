Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3CATpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:45:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab3CATpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Clemens Ladisch <cladisch@googlemail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 02/77] ALSA: bt87x: Make load_all parameter working again
Date: Fri,  1 Mar 2013 11:43:47 -0800
Message-Id: <20130301194352.223911700@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit aacfddfdadb3540651d263245069631f341e953a upstream.

Along with a clean up commit [e9f66d9b9: ALSA: pci: clean up using
module_pci_driver()], bt87x driver lost the functionality of load_all
parameter.  This patch does a partial revert of the commit only for
bt87x.c to recover it.

Reported-by: Clemens Ladisch <cladisch@googlemail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/bt87x.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -836,6 +836,8 @@ static struct {
 	{0x7063, 0x2000}, /* pcHDTV HD-2000 TV */
 };
 
+static struct pci_driver driver;
+
 /* return the id of the card, or a negative value if it's blacklisted */
 static int snd_bt87x_detect_card(struct pci_dev *pci)
 {
@@ -962,11 +964,24 @@ static DEFINE_PCI_DEVICE_TABLE(snd_bt87x
 	{ }
 };
 
-static struct pci_driver bt87x_driver = {
+static struct pci_driver driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_bt87x_ids,
 	.probe = snd_bt87x_probe,
 	.remove = snd_bt87x_remove,
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


