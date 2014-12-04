Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbaLDVbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:31:09 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:58610 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLDVbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:31:07 -0500
Subject: [PATCH 4/5] pcmcia: handle anonymous cards by generating a fake CIS
From: Alan Cox <alan@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pcmica@lists.infradead.org
Date: Thu, 04 Dec 2014 21:30:56 +0000
Message-ID: <20141204213015.1351.23846.stgit@localhost.localdomain>
In-Reply-To: <20141204212746.1351.89165.stgit@localhost.localdomain>
References: <20141204212746.1351.89165.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core pcmcia code blows up all over the place if it allowed a card without
a valid CIS. We need to allow such cards as the CIS stuff is not on the older
flash, ROM and SRAM cards. We give it a suitably blank fake CIS instead.

In order to minimise the risk of misidentifying junk and feeding it to the
wrong thing we only fix up apparently anonymous cards if the driver for them
has been enabled.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/pcmcia/cistpl.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 8b3b492..64d0515 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -1451,10 +1451,26 @@ int pccard_validate_cis(struct pcmcia_socket *s, unsigned int *info)
 done:
 	/* invalidate CIS cache on failure */
 	if (!dev_ok || !ident_ok || !count) {
-		mutex_lock(&s->ops_mutex);
-		destroy_cis_cache(s);
-		mutex_unlock(&s->ops_mutex);
-		ret = -EIO;
+#if defined(CONFIG_MTD_PCMCIA_ANONYMOUS)
+		/* Set up as an anonymous card. If we don't have anonymous
+		   memory support then just error the card as there is no
+		   point trying to second guess.
+
+		   Note: some cards have just a device entry, it may be
+		   worth extending support to cover these in future */
+		if (!dev_ok || !ident_ok) {
+			dev_info(&s->dev, "no CIS, assuming an anonymous memory card.\n");
+			pcmcia_replace_cis(s, "\xFF", 1);
+			count = 1;
+			ret = 0;
+		} else
+#endif
+		{
+			mutex_lock(&s->ops_mutex);
+			destroy_cis_cache(s);
+			mutex_unlock(&s->ops_mutex);
+			ret = -EIO;
+		}
 	}
 
 	if (info)

