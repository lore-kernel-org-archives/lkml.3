Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbaGOJNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:13:07 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58981 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaGOJND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:13:03 -0400
Date: Tue, 15 Jul 2014 18:11:44 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/8 V2] staging: dgap: remove unneeded dgap_err()
Message-ID: <20140715091144.GA19080@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dgap_err() is printing a message with pr_err(),
so all those are replaced.

Use definition "pr_fmt" and then all of "dgap:" in
the beginning of print messages are removed.

And also removed "out of memory" message because
the kernel has own message for that.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V2: use pr_fmt "dgap:" prefix on print message on dgap.
    remove "out of memory" message.

    Adds Mark to TO list and CC list for checking send
    this email properly to him.

 drivers/staging/dgap/dgap.c |  306 +++++++++++++++++++------------------------
 1 files changed, 133 insertions(+), 173 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 06c55cb..9e750fb 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -41,6 +41,8 @@
  */
 #undef DIGI_CONCENTRATORS_SUPPORTED
 
+#define pr_fmt(fmt) "dgap: " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -153,7 +155,6 @@ static void dgap_firmware_reset_port(struct channel_t *ch);
 static int dgap_gettok(char **in);
 static char *dgap_getword(char **in);
 static int dgap_checknode(struct cnode *p);
-static void dgap_err(char *s);
 
 /*
  * Function prototypes from dgap_sysfs.h
@@ -815,7 +816,7 @@ static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
 	if (ret)
 		goto free_brd;
 
-	pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
+	pr_info("board %d: %s (rev %d), irq %ld\n",
 		boardnum, brd->name, brd->rev, brd->irq);
 
 	return brd;
@@ -875,7 +876,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 		ret = request_firmware(&fw, fw_info[card_type].conf_name,
 					 &pdev->dev);
 		if (ret) {
-			pr_err("dgap: config file %s not found\n",
+			pr_err("config file %s not found\n",
 				fw_info[card_type].conf_name);
 			return ret;
 		}
@@ -920,7 +921,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 			dgap_find_config(PAPORT4, brd->pci_bus, brd->pci_slot);
 
 	if (!brd->bd_config) {
-		pr_err("dgap: No valid configuration found\n");
+		pr_err("No valid configuration found\n");
 		return -EINVAL;
 	}
 
@@ -928,7 +929,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 		ret = request_firmware(&fw, fw_info[card_type].bios_name,
 					&pdev->dev);
 		if (ret) {
-			pr_err("dgap: bios file %s not found\n",
+			pr_err("bios file %s not found\n",
 				fw_info[card_type].bios_name);
 			return ret;
 		}
@@ -945,7 +946,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 		ret = request_firmware(&fw, fw_info[card_type].fep_name,
 					&pdev->dev);
 		if (ret) {
-			pr_err("dgap: fep file %s not found\n",
+			pr_err("fep file %s not found\n",
 				fw_info[card_type].fep_name);
 			return ret;
 		}
@@ -974,7 +975,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 		ret = request_firmware(&fw, fw_info[card_type].con_name,
 					&pdev->dev);
 		if (ret) {
-			pr_err("dgap: conc file %s not found\n",
+			pr_err("conc file %s not found\n",
 				fw_info[card_type].con_name);
 			return ret;
 		}
@@ -1379,17 +1380,17 @@ static int dgap_tty_init(struct board_t *brd)
 
 	if (true_count != brd->nasync) {
 		if ((brd->type == PPCM) && (true_count == 64)) {
-			pr_warn("dgap: %s configured for %d ports, has %d ports.\n",
+			pr_warn("%s configured for %d ports, has %d ports.\n",
 				brd->name, brd->nasync, true_count);
-			pr_warn("dgap: Please make SURE the EBI cable running from the card\n");
-			pr_warn("dgap: to each EM module is plugged into EBI IN!\n");
+			pr_warn("Please make SURE the EBI cable running from the card\n");
+			pr_warn("to each EM module is plugged into EBI IN!\n");
 		} else if ((brd->type == PPCM) && (true_count == 0)) {
-			pr_warn("dgap: %s configured for %d ports, has %d ports.\n",
+			pr_warn("%s configured for %d ports, has %d ports.\n",
 				brd->name, brd->nasync, true_count);
-			pr_warn("dgap: Please make SURE the EBI cable running from the card\n");
-			pr_warn("dgap: to each EM module is plugged into EBI IN!\n");
+			pr_warn("Please make SURE the EBI cable running from the card\n");
+			pr_warn("to each EM module is plugged into EBI IN!\n");
 		} else
-			pr_warn("dgap: %s configured for %d ports, has %d ports.\n",
+			pr_warn("%s configured for %d ports, has %d ports.\n",
 				brd->name, brd->nasync, true_count);
 
 		brd->nasync = true_count;
@@ -4215,7 +4216,7 @@ static int dgap_test_bios(struct board_t *brd)
 	/* Gave up on board after too long of time taken */
 	err1 = readw(addr + SEQUENCE);
 	err2 = readw(addr + ERROR);
-	pr_warn("dgap: %s failed diagnostics.  Error #(%x,%x).\n",
+	pr_warn("%s failed diagnostics.  Error #(%x,%x).\n",
 		brd->name, err1, err2);
 	brd->state = BOARD_FAILED;
 	brd->dpastatus = BD_NOBIOS;
@@ -4310,7 +4311,7 @@ static int dgap_test_fep(struct board_t *brd)
 	/* Gave up on board after too long of time taken */
 	err1 = readw(addr + SEQUENCE);
 	err2 = readw(addr + ERROR);
-	pr_warn("dgap: FEPOS for %s not functioning.  Error #(%x,%x).\n",
+	pr_warn("FEPOS for %s not functioning.  Error #(%x,%x).\n",
 		brd->name, err1, err2);
 	brd->state = BOARD_FAILED;
 	brd->dpastatus = BD_NOFEP;
@@ -4343,7 +4344,7 @@ static void dgap_do_reset_board(struct board_t *brd)
 
 	}
 	if (i > 1000) {
-		pr_warn("dgap: Board not resetting...  Failing board.\n");
+		pr_warn("Board not resetting...  Failing board.\n");
 		brd->state = BOARD_FAILED;
 		brd->dpastatus = BD_NOFEP;
 		return;
@@ -4358,7 +4359,7 @@ static void dgap_do_reset_board(struct board_t *brd)
 	check2 = readl(brd->re_map_membase + HIGHMEM);
 
 	if ((check1 != 0xa55a3cc3) || (check2 != 0x5aa5c33c)) {
-		pr_warn("dgap: No memory at %p for board.\n",
+		pr_warn("No memory at %p for board.\n",
 			brd->re_map_membase);
 		brd->state = BOARD_FAILED;
 		brd->dpastatus = BD_NOFEP;
@@ -6343,7 +6344,7 @@ static int dgap_parsefile(char **in)
 	/* file must start with a BEGIN */
 	while ((rc = dgap_gettok(in)) != BEGIN) {
 		if (rc == 0) {
-			dgap_err("unexpected EOF");
+			pr_err("parse: unexpected EOF\n");
 			return -1;
 		}
 	}
@@ -6351,13 +6352,13 @@ static int dgap_parsefile(char **in)
 	for (; ;) {
 		rc = dgap_gettok(in);
 		if (rc == 0) {
-			dgap_err("unexpected EOF");
+			pr_err("parse: unexpected EOF\n");
 			return -1;
 		}
 
 		switch (rc) {
 		case BEGIN:	/* should only be 1 begin */
-			dgap_err("unexpected config_begin\n");
+			pr_err("parse: unexpected config_begin\n");
 			return -1;
 
 		case END:
@@ -6368,10 +6369,9 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
+
 			p = p->next;
 
 			p->type = BNODE;
@@ -6383,7 +6383,7 @@ static int dgap_parsefile(char **in)
 
 		case APORT2_920P:	/* AccelePort_4 */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_2r_920 string");
+				pr_err("parse: unexpected Digi_2r_920 string\n");
 				return -1;
 			}
 			p->u.board.type = APORT2_920P;
@@ -6392,7 +6392,7 @@ static int dgap_parsefile(char **in)
 
 		case APORT4_920P:	/* AccelePort_4 */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_4r_920 string");
+				pr_err("parse: unexpected Digi_4r_920 string\n");
 				return -1;
 			}
 			p->u.board.type = APORT4_920P;
@@ -6401,7 +6401,7 @@ static int dgap_parsefile(char **in)
 
 		case APORT8_920P:	/* AccelePort_8 */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_8r_920 string");
+				pr_err("parse: unexpected Digi_8r_920 string\n");
 				return -1;
 			}
 			p->u.board.type = APORT8_920P;
@@ -6410,7 +6410,7 @@ static int dgap_parsefile(char **in)
 
 		case PAPORT4:	/* AccelePort_4 PCI */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_4r(PCI) string");
+				pr_err("parse: unexpected Digi_4r(PCI) string\n");
 				return -1;
 			}
 			p->u.board.type = PAPORT4;
@@ -6419,7 +6419,7 @@ static int dgap_parsefile(char **in)
 
 		case PAPORT8:	/* AccelePort_8 PCI */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_8r string");
+				pr_err("parse: unexpected Digi_8r string\n");
 				return -1;
 			}
 			p->u.board.type = PAPORT8;
@@ -6428,7 +6428,7 @@ static int dgap_parsefile(char **in)
 
 		case PCX:	/* PCI C/X */
 			if (p->type != BNODE) {
-				dgap_err("unexpected Digi_C/X_(PCI) string");
+				pr_err("parse: unexpected Digi_C/X_(PCI) string\n");
 				return -1;
 			}
 			p->u.board.type = PCX;
@@ -6441,7 +6441,7 @@ static int dgap_parsefile(char **in)
 
 		case PEPC:	/* PCI EPC/X */
 			if (p->type != BNODE) {
-				dgap_err("unexpected \"Digi_EPC/X_(PCI)\" string");
+				pr_err("parse: unexpected \"Digi_EPC/X_(PCI)\" string\n");
 				return -1;
 			}
 			p->u.board.type = PEPC;
@@ -6454,7 +6454,7 @@ static int dgap_parsefile(char **in)
 
 		case PPCM:	/* PCI/Xem */
 			if (p->type != BNODE) {
-				dgap_err("unexpected PCI/Xem string");
+				pr_err("parse: unexpected PCI/Xem string\n");
 				return -1;
 			}
 			p->u.board.type = PPCM;
@@ -6465,17 +6465,17 @@ static int dgap_parsefile(char **in)
 
 		case IO:	/* i/o port */
 			if (p->type != BNODE) {
-				dgap_err("IO port only vaild for boards");
+				pr_err("parse: IO port only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.portstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtol(s, 0, &p->u.board.port)) {
-				dgap_err("bad number for IO port");
+				pr_err("parse: bad number for IO port\n");
 				return -1;
 			}
 			p->u.board.v_port = 1;
@@ -6483,17 +6483,17 @@ static int dgap_parsefile(char **in)
 
 		case MEM:	/* memory address */
 			if (p->type != BNODE) {
-				dgap_err("memory address only vaild for boards");
+				pr_err("parse: memory address only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.addrstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.addr)) {
-				dgap_err("bad number for memory address");
+				pr_err("parse: bad number for memory address\n");
 				return -1;
 			}
 			p->u.board.v_addr = 1;
@@ -6501,28 +6501,28 @@ static int dgap_parsefile(char **in)
 
 		case PCIINFO:	/* pci information */
 			if (p->type != BNODE) {
-				dgap_err("memory address only vaild for boards");
+				pr_err("parse: memory address only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.pcibusstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.pcibus)) {
-				dgap_err("bad number for pci bus");
+				pr_err("parse: bad number for pci bus\n");
 				return -1;
 			}
 			p->u.board.v_pcibus = 1;
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.pcislotstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.pcislot)) {
-				dgap_err("bad number for pci slot");
+				pr_err("parse: bad number for pci slot\n");
 				return -1;
 			}
 			p->u.board.v_pcislot = 1;
@@ -6530,12 +6530,12 @@ static int dgap_parsefile(char **in)
 
 		case METHOD:
 			if (p->type != BNODE) {
-				dgap_err("install method only vaild for boards");
+				pr_err("parse: install method only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.method = kstrdup(s, GFP_KERNEL);
@@ -6544,12 +6544,12 @@ static int dgap_parsefile(char **in)
 
 		case STATUS:
 			if (p->type != BNODE) {
-				dgap_err("config status only vaild for boards");
+				pr_err("parse: config status only vaild for boards\n");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			p->u.board.status = kstrdup(s, GFP_KERNEL);
@@ -6559,38 +6559,38 @@ static int dgap_parsefile(char **in)
 			if (p->type == BNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.board.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("parse: bad number for number of ports\n");
 					return -1;
 				}
 				p->u.board.v_nport = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("parse: bad number for number of ports\n");
 					return -1;
 				}
 				p->u.conc.v_nport = 1;
 			} else if (p->type == MNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.module.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("parse: bad number for number of ports\n");
 					return -1;
 				}
 				p->u.module.v_nport = 1;
 			} else {
-				dgap_err("nports only valid for concentrators or modules");
+				pr_err("parse: nports only valid for concentrators or modules\n");
 				return -1;
 			}
 			break;
@@ -6598,7 +6598,7 @@ static int dgap_parsefile(char **in)
 		case ID:	/* letter ID used in tty name */
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 
@@ -6611,7 +6611,7 @@ static int dgap_parsefile(char **in)
 				p->u.module.id = kstrdup(s, GFP_KERNEL);
 				p->u.module.v_id = 1;
 			} else {
-				dgap_err("id only valid for concentrators or modules");
+				pr_err("parse: id only valid for concentrators or modules\n");
 				return -1;
 			}
 			break;
@@ -6620,38 +6620,38 @@ static int dgap_parsefile(char **in)
 			if (p->type == BNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.board.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("parse: bad number for start of tty count\n");
 					return -1;
 				}
 				p->u.board.v_start = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("parse: bad number for start of tty count\n");
 					return -1;
 				}
 				p->u.conc.v_start = 1;
 			} else if (p->type == MNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.module.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("parse: bad number for start of tty count\n");
 					return -1;
 				}
 				p->u.module.v_start = 1;
 			} else {
-				dgap_err("start only valid for concentrators or modules");
+				pr_err("parse: start only valid for concentrators or modules\n");
 				return -1;
 			}
 			break;
@@ -6661,24 +6661,21 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = TNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpeced end of file");
+				pr_err("parse: unexpeced end of file\n");
 				return -1;
 			}
 			p->u.ttyname = kstrdup(s, GFP_KERNEL);
-			if (!p->u.ttyname) {
-				dgap_err("out of memory");
+			if (!p->u.ttyname)
 				return -1;
-			}
+
 			break;
 
 		case CU:	/* cu name prefix */
@@ -6686,44 +6683,39 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = CUNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpeced end of file");
+				pr_err("parse: unexpeced end of file\n");
 				return -1;
 			}
 			p->u.cuname = kstrdup(s, GFP_KERNEL);
-			if (!p->u.cuname) {
-				dgap_err("out of memory");
+			if (!p->u.cuname)
 				return -1;
-			}
+
 			break;
 
 		case LINE:	/* line information */
 			if (dgap_checknode(p))
 				return -1;
 			if (!brd) {
-				dgap_err("must specify board before line info");
+				pr_err("parse: must specify board before line info\n");
 				return -1;
 			}
 			switch (brd->u.board.type) {
 			case PPCM:
-				dgap_err("line not vaild for PC/em");
+				pr_err("parse: line not vaild for PC/em\n");
 				return -1;
 			}
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = LNODE;
@@ -6736,15 +6728,13 @@ static int dgap_parsefile(char **in)
 			if (dgap_checknode(p))
 				return -1;
 			if (!line) {
-				dgap_err("must specify line info before concentrator");
+				pr_err("parse: must specify line info before concentrator\n");
 				return -1;
 			}
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = CNODE;
@@ -6759,7 +6749,7 @@ static int dgap_parsefile(char **in)
 
 		case CX:	/* c/x type concentrator */
 			if (p->type != CNODE) {
-				dgap_err("cx only valid for concentrators");
+				pr_err("parse: cx only valid for concentrators\n");
 				return -1;
 			}
 			p->u.conc.type = CX;
@@ -6768,7 +6758,7 @@ static int dgap_parsefile(char **in)
 
 		case EPC:	/* epc type concentrator */
 			if (p->type != CNODE) {
-				dgap_err("cx only valid for concentrators");
+				pr_err("parse: cx only valid for concentrators\n");
 				return -1;
 			}
 			p->u.conc.type = EPC;
@@ -6779,7 +6769,7 @@ static int dgap_parsefile(char **in)
 			if (dgap_checknode(p))
 				return -1;
 			if (!brd) {
-				dgap_err("must specify board info before EBI modules");
+				pr_err("parse: must specify board info before EBI modules\n");
 				return -1;
 			}
 			switch (brd->u.board.type) {
@@ -6788,16 +6778,15 @@ static int dgap_parsefile(char **in)
 				break;
 			default:
 				if (!conc) {
-					dgap_err("must specify concentrator info before EBI module");
+					pr_err("parse: must specify concentrator info before EBI module\n");
 					return -1;
 				}
 			}
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
+
 			p = p->next;
 			p->type = MNODE;
 
@@ -6810,7 +6799,7 @@ static int dgap_parsefile(char **in)
 
 		case PORTS:	/* ports type EBI module */
 			if (p->type != MNODE) {
-				dgap_err("ports only valid for EBI modules");
+				pr_err("parse: ports only valid for EBI modules\n");
 				return -1;
 			}
 			p->u.module.type = PORTS;
@@ -6819,7 +6808,7 @@ static int dgap_parsefile(char **in)
 
 		case MODEM:	/* ports type EBI module */
 			if (p->type != MNODE) {
-				dgap_err("modem only valid for modem modules");
+				pr_err("parse: modem only valid for modem modules\n");
 				return -1;
 			}
 			p->u.module.type = MODEM;
@@ -6830,7 +6819,7 @@ static int dgap_parsefile(char **in)
 			if (p->type == LNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				p->u.line.cable = kstrdup(s, GFP_KERNEL);
@@ -6842,27 +6831,27 @@ static int dgap_parsefile(char **in)
 			if (p->type == LNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.line.speed)) {
-					dgap_err("bad number for line speed");
+					pr_err("parse: bad number for line speed\n");
 					return -1;
 				}
 				p->u.line.v_speed = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.speed)) {
-					dgap_err("bad number for line speed");
+					pr_err("parse: bad number for line speed\n");
 					return -1;
 				}
 				p->u.conc.v_speed = 1;
 			} else {
-				dgap_err("speed valid only for lines or concentrators.");
+				pr_err("parse: speed valid only for lines or concentrators.\n");
 				return -1;
 			}
 			break;
@@ -6871,7 +6860,7 @@ static int dgap_parsefile(char **in)
 			if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("parse: unexpected end of file\n");
 					return -1;
 				}
 				p->u.conc.connect = kstrdup(s, GFP_KERNEL);
@@ -6883,24 +6872,21 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = PNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpeced end of file");
+				pr_err("parse: unexpeced end of file\n");
 				return -1;
 			}
 			p->u.printname = kstrdup(s, GFP_KERNEL);
-			if (!p->u.printname) {
-				dgap_err("out of memory");
+			if (!p->u.printname)
 				return -1;
-			}
+
 			break;
 
 		case CMAJOR:	/* major number */
@@ -6908,21 +6894,19 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = JNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.majornumber)) {
-				dgap_err("bad number for major number");
+				pr_err("parse: bad number for major number\n");
 				return -1;
 			}
 			break;
@@ -6932,21 +6916,19 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = ANODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.altpin)) {
-				dgap_err("bad number for altpin");
+				pr_err("parse: bad number for altpin\n");
 				return -1;
 			}
 			break;
@@ -6956,19 +6938,18 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
+
 			p = p->next;
 			p->type = INTRNODE;
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.useintr)) {
-				dgap_err("bad number for useintr");
+				pr_err("parse: bad number for useintr\n");
 				return -1;
 			}
 			break;
@@ -6978,21 +6959,19 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = TSNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.ttysize)) {
-				dgap_err("bad number for ttysize");
+				pr_err("parse: bad number for ttysize\n");
 				return -1;
 			}
 			break;
@@ -7002,21 +6981,19 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = CSNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.chsize)) {
-				dgap_err("bad number for chsize");
+				pr_err("parse: bad number for chsize\n");
 				return -1;
 			}
 			break;
@@ -7026,21 +7003,19 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = BSNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.bssize)) {
-				dgap_err("bad number for bssize");
+				pr_err("parse: bad number for bssize\n");
 				return -1;
 			}
 			break;
@@ -7050,21 +7025,19 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = USNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.unsize)) {
-				dgap_err("bad number for schedsize");
+				pr_err("parse: bad number for schedsize\n");
 				return -1;
 			}
 			break;
@@ -7074,21 +7047,19 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = FSNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.f2size)) {
-				dgap_err("bad number for f2200size");
+				pr_err("parse: bad number for f2200size\n");
 				return -1;
 			}
 			break;
@@ -7098,21 +7069,19 @@ static int dgap_parsefile(char **in)
 				return -1;
 
 			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next) {
-				dgap_err("out of memory");
+			if (!p->next)
 				return -1;
-			}
 
 			p = p->next;
 			p->type = VSNODE;
 
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("parse: unexpected end of file\n");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.vpixsize)) {
-				dgap_err("bad number for vpixsize");
+				pr_err("parse: bad number for vpixsize\n");
 				return -1;
 			}
 			break;
@@ -7169,7 +7138,7 @@ static int dgap_gettok(char **in)
 			if (!strcmp(w, t->string))
 				return t->token;
 		}
-		dgap_err("board !!type not specified");
+		pr_err("parse: board !!type not specified\n");
 		return 1;
 	} else {
 		while ((w = dgap_getword(in))) {
@@ -7213,15 +7182,6 @@ static char *dgap_getword(char **in)
 }
 
 /*
- * print an error message, giving the line number in the file where
- * the error occurred.
- */
-static void dgap_err(char *s)
-{
-	pr_err("dgap: parse: %s\n", s);
-}
-
-/*
  * dgap_checknode: see if all the necessary info has been supplied for a node
  * before creating the next node.
  */
@@ -7230,7 +7190,7 @@ static int dgap_checknode(struct cnode *p)
 	switch (p->type) {
 	case BNODE:
 		if (p->u.board.v_type == 0) {
-			dgap_err("board type !not specified");
+			pr_err("parse: board type !not specified\n");
 			return 1;
 		}
 
@@ -7238,41 +7198,41 @@ static int dgap_checknode(struct cnode *p)
 
 	case LNODE:
 		if (p->u.line.v_speed == 0) {
-			dgap_err("line speed not specified");
+			pr_err("parse: line speed not specified\n");
 			return 1;
 		}
 		return 0;
 
 	case CNODE:
 		if (p->u.conc.v_type == 0) {
-			dgap_err("concentrator type not specified");
+			pr_err("parse: concentrator type not specified\n");
 			return 1;
 		}
 		if (p->u.conc.v_speed == 0) {
-			dgap_err("concentrator line speed not specified");
+			pr_err("parse: concentrator line speed not specified\n");
 			return 1;
 		}
 		if (p->u.conc.v_nport == 0) {
-			dgap_err("number of ports on concentrator not specified");
+			pr_err("parse: number of ports on concentrator not specified\n");
 			return 1;
 		}
 		if (p->u.conc.v_id == 0) {
-			dgap_err("concentrator id letter not specified");
+			pr_err("parse: concentrator id letter not specified\n");
 			return 1;
 		}
 		return 0;
 
 	case MNODE:
 		if (p->u.module.v_type == 0) {
-			dgap_err("EBI module type not specified");
+			pr_err("parse: EBI module type not specified\n");
 			return 1;
 		}
 		if (p->u.module.v_nport == 0) {
-			dgap_err("number of ports on EBI module not specified");
+			pr_err("parse: number of ports on EBI module not specified\n");
 			return 1;
 		}
 		if (p->u.module.v_id == 0) {
-			dgap_err("EBI module id letter not specified");
+			pr_err("parse: EBI module id letter not specified\n");
 			return 1;
 		}
 		return 0;
-- 
1.7.1

