Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaGQBgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:36:53 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36938 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaGQBgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:36:51 -0400
Date: Thu, 17 Jul 2014 10:35:32 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: introduce dgap_cleanup_nodes()
Message-ID: <20140717013532.GA1040@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a configration file is parsed with dgap_parsefile(),
makes nodes for saving configrations for board.

Making a node will allocate node memory and strings for saving
configrations with kstrdup().

So these are freed when dgap is unloaded or failed to initialize.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
Mark, please review this patch.
Thanks.

 drivers/staging/dgap/dgap.c |   47 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 06c55cb..e9df2ea 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -201,6 +201,7 @@ static int dgap_test_fep(struct board_t *brd);
 static int dgap_tty_register_ports(struct board_t *brd);
 static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 			      struct board_t *brd);
+static void dgap_cleanup_nodes(void);
 
 static void dgap_cleanup_module(void);
 
@@ -619,6 +620,7 @@ unregister_tty:
 free_flipbuf:
 	dgap_free_flipbuf(brd);
 cleanup_brd:
+	dgap_cleanup_nodes();
 	dgap_release_remap(brd);
 	kfree(brd);
 
@@ -659,6 +661,8 @@ static void dgap_cleanup_module(void)
 		dgap_cleanup_board(dgap_board[i]);
 	}
 
+	dgap_cleanup_nodes();
+
 	if (dgap_numboards)
 		pci_unregister_driver(&dgap_driver);
 }
@@ -6323,6 +6327,49 @@ static void dgap_remove_tty_sysfs(struct device *c)
 	sysfs_remove_group(&c->kobj, &dgap_tty_attribute_group);
 }
 
+static void dgap_cleanup_nodes(void)
+{
+	struct cnode *p;
+
+	p = &dgap_head;
+
+	while (p) {
+		struct cnode *tmp = p->next;
+
+		switch (p->type) {
+		case BNODE:
+			kfree(p->u.board.portstr);
+			kfree(p->u.board.addrstr);
+			kfree(p->u.board.pcibusstr);
+			kfree(p->u.board.pcislotstr);
+			kfree(p->u.board.method);
+			break;
+		case CNODE:
+			kfree(p->u.conc.id);
+			kfree(p->u.conc.connect);
+			break;
+		case MNODE:
+			kfree(p->u.module.id);
+			break;
+		case TNODE:
+			kfree(p->u.ttyname);
+			break;
+		case CUNODE:
+			kfree(p->u.cuname);
+			break;
+		case LNODE:
+			kfree(p->u.line.cable);
+			break;
+		case PNODE:
+			kfree(p->u.printname);
+			break;
+		}
+
+		kfree(p->u.board.status);
+		kfree(p);
+		p = tmp;
+	}
+}
 /*
  * Parse a configuration file read into memory as a string.
  */
-- 
1.7.1

