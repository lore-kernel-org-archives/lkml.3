Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaHIFlF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:41:05 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34490 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaHIFlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:41:01 -0400
Date: Sat, 9 Aug 2014 14:39:29 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging: dgap: cleanup print messages for dgap driver
Message-ID: <20140809053929.GA14688@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* use dev_{warn,err} instead of pr_{warn,err}
* removes dgap_err() and just use pr_err(). pr_err() used in
dgap_parsefile() not dev_err() because if dgap_parsefile() is
failed, just one message is printed.
* removes "out of memory" messages.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |  285 +++++++++++++++++++------------------------
 1 files changed, 126 insertions(+), 159 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index a54b8d4..45f20b4 100644
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
@@ -877,7 +878,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 		ret = request_firmware(&fw, fw_info[card_type].conf_name,
 					 &pdev->dev);
 		if (ret) {
-			pr_err("dgap: config file %s not found\n",
+			dev_err(&pdev->dev, "config file %s not found\n",
 				fw_info[card_type].conf_name);
 			return ret;
 		}
@@ -922,7 +923,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 			dgap_find_config(PAPORT4, brd->pci_bus, brd->pci_slot);
 
 	if (!brd->bd_config) {
-		pr_err("dgap: No valid configuration found\n");
+		dev_err(&pdev->dev, "No valid configuration found\n");
 		return -EINVAL;
 	}
 
@@ -930,7 +931,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 		ret = request_firmware(&fw, fw_info[card_type].bios_name,
 					&pdev->dev);
 		if (ret) {
-			pr_err("dgap: bios file %s not found\n",
+			dev_err(&pdev->dev, "bios file %s not found\n",
 				fw_info[card_type].bios_name);
 			return ret;
 		}
@@ -947,7 +948,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 		ret = request_firmware(&fw, fw_info[card_type].fep_name,
 					&pdev->dev);
 		if (ret) {
-			pr_err("dgap: fep file %s not found\n",
+			dev_err(&pdev->dev, "dgap: fep file %s not found\n",
 				fw_info[card_type].fep_name);
 			return ret;
 		}
@@ -976,7 +977,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
 		ret = request_firmware(&fw, fw_info[card_type].con_name,
 					&pdev->dev);
 		if (ret) {
-			pr_err("dgap: conc file %s not found\n",
+			dev_err(&pdev->dev, "conc file %s not found\n",
 				fw_info[card_type].con_name);
 			return ret;
 		}
@@ -1378,13 +1379,16 @@ static int dgap_tty_init(struct board_t *brd)
 		brd->nasync = brd->maxports;
 
 	if (true_count != brd->nasync) {
-		pr_warn("dgap: %s configured for %d ports, has %d ports.\n",
-			brd->name, brd->nasync, true_count);
+		dev_warn(&brd->pdev->dev,
+			 "%s configured for %d ports, has %d ports.\n",
+			 brd->name, brd->nasync, true_count);
 
 		if ((brd->type == PPCM) &&
 		    (true_count == 64 || true_count == 0)) {
-			pr_warn("dgap: Please make SURE the EBI cable running from the card\n");
-			pr_warn("dgap: to each EM module is plugged into EBI IN!\n");
+			dev_warn(&brd->pdev->dev,
+				 "Please make SURE the EBI cable running from the card\n");
+			dev_warn(&brd->pdev->dev,
+				 "to each EM module is plugged into EBI IN!\n");
 		}
 
 		brd->nasync = true_count;
@@ -4204,7 +4208,7 @@ static int dgap_test_bios(struct board_t *brd)
 	/* Gave up on board after too long of time taken */
 	err1 = readw(addr + SEQUENCE);
 	err2 = readw(addr + ERROR);
-	pr_warn("dgap: %s failed diagnostics.  Error #(%x,%x).\n",
+	dev_warn(&brd->pdev->dev, "%s failed diagnostics.  Error #(%x,%x).\n",
 		brd->name, err1, err2);
 	brd->state = BOARD_FAILED;
 	brd->dpastatus = BD_NOBIOS;
@@ -4299,8 +4303,9 @@ static int dgap_test_fep(struct board_t *brd)
 	/* Gave up on board after too long of time taken */
 	err1 = readw(addr + SEQUENCE);
 	err2 = readw(addr + ERROR);
-	pr_warn("dgap: FEPOS for %s not functioning.  Error #(%x,%x).\n",
-		brd->name, err1, err2);
+	dev_warn(&brd->pdev->dev,
+		 "FEPOS for %s not functioning.  Error #(%x,%x).\n",
+		 brd->name, err1, err2);
 	brd->state = BOARD_FAILED;
 	brd->dpastatus = BD_NOFEP;
 
@@ -4332,7 +4337,8 @@ static void dgap_do_reset_board(struct board_t *brd)
 
 	}
 	if (i > 1000) {
-		pr_warn("dgap: Board not resetting...  Failing board.\n");
+		dev_warn(&brd->pdev->dev,
+			 "dgap: Board not resetting...  Failing board.\n");
 		brd->state = BOARD_FAILED;
 		brd->dpastatus = BD_NOFEP;
 		return;
@@ -4347,8 +4353,9 @@ static void dgap_do_reset_board(struct board_t *brd)
 	check2 = readl(brd->re_map_membase + HIGHMEM);
 
 	if ((check1 != 0xa55a3cc3) || (check2 != 0x5aa5c33c)) {
-		pr_warn("dgap: No memory at %p for board.\n",
-			brd->re_map_membase);
+		dev_warn(&brd->pdev->dev,
+			 "No memory at %p for board.\n",
+			 brd->re_map_membase);
 		brd->state = BOARD_FAILED;
 		brd->dpastatus = BD_NOFEP;
 		return;
@@ -6380,7 +6387,7 @@ static int dgap_parsefile(char **in)
 	/* file must start with a BEGIN */
 	while ((rc = dgap_gettok(in)) != BEGIN) {
 		if (rc == 0) {
-			dgap_err("unexpected EOF");
+			pr_err("unexpected EOF");
 			return -1;
 		}
 	}
@@ -6392,13 +6399,13 @@ static int dgap_parsefile(char **in)
 
 		rc = dgap_gettok(in);
 		if (rc == 0) {
-			dgap_err("unexpected EOF");
+			pr_err("unexpected EOF");
 			return -1;
 		}
 
 		switch (rc) {
 		case BEGIN:	/* should only be 1 begin */
-			dgap_err("unexpected config_begin\n");
+			pr_err("unexpected config_begin\n");
 			return -1;
 
 		case END:
@@ -6409,10 +6416,9 @@ static int dgap_parsefile(char **in)
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
@@ -6422,8 +6428,10 @@ static int dgap_parsefile(char **in)
 			linecnt = -1;
 
 			board_type = dgap_gettok(in);
-			if (board_type == 0)
+			if (board_type == 0) {
+				pr_err("board !!type not specified");
 				return -1;
+			}
 
 			p->u.board.type = board_type;
 
@@ -6431,17 +6439,17 @@ static int dgap_parsefile(char **in)
 
 		case IO:	/* i/o port */
 			if (p->type != BNODE) {
-				dgap_err("IO port only vaild for boards");
+				pr_err("IO port only vaild for boards");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			p->u.board.portstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtol(s, 0, &p->u.board.port)) {
-				dgap_err("bad number for IO port");
+				pr_err("bad number for IO port");
 				return -1;
 			}
 			p->u.board.v_port = 1;
@@ -6449,17 +6457,17 @@ static int dgap_parsefile(char **in)
 
 		case MEM:	/* memory address */
 			if (p->type != BNODE) {
-				dgap_err("memory address only vaild for boards");
+				pr_err("memory address only vaild for boards");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			p->u.board.addrstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.addr)) {
-				dgap_err("bad number for memory address");
+				pr_err("bad number for memory address");
 				return -1;
 			}
 			p->u.board.v_addr = 1;
@@ -6467,28 +6475,28 @@ static int dgap_parsefile(char **in)
 
 		case PCIINFO:	/* pci information */
 			if (p->type != BNODE) {
-				dgap_err("memory address only vaild for boards");
+				pr_err("memory address only vaild for boards");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			p->u.board.pcibusstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.pcibus)) {
-				dgap_err("bad number for pci bus");
+				pr_err("bad number for pci bus");
 				return -1;
 			}
 			p->u.board.v_pcibus = 1;
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			p->u.board.pcislotstr = kstrdup(s, GFP_KERNEL);
 			if (kstrtoul(s, 0, &p->u.board.pcislot)) {
-				dgap_err("bad number for pci slot");
+				pr_err("bad number for pci slot");
 				return -1;
 			}
 			p->u.board.v_pcislot = 1;
@@ -6496,12 +6504,12 @@ static int dgap_parsefile(char **in)
 
 		case METHOD:
 			if (p->type != BNODE) {
-				dgap_err("install method only vaild for boards");
+				pr_err("install method only vaild for boards");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			p->u.board.method = kstrdup(s, GFP_KERNEL);
@@ -6510,12 +6518,12 @@ static int dgap_parsefile(char **in)
 
 		case STATUS:
 			if (p->type != BNODE) {
-				dgap_err("config status only vaild for boards");
+				pr_err("config status only vaild for boards");
 				return -1;
 			}
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			p->u.board.status = kstrdup(s, GFP_KERNEL);
@@ -6525,38 +6533,38 @@ static int dgap_parsefile(char **in)
 			if (p->type == BNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.board.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("bad number for number of ports");
 					return -1;
 				}
 				p->u.board.v_nport = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("bad number for number of ports");
 					return -1;
 				}
 				p->u.conc.v_nport = 1;
 			} else if (p->type == MNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.module.nport)) {
-					dgap_err("bad number for number of ports");
+					pr_err("bad number for number of ports");
 					return -1;
 				}
 				p->u.module.v_nport = 1;
 			} else {
-				dgap_err("nports only valid for concentrators or modules");
+				pr_err("nports only valid for concentrators or modules");
 				return -1;
 			}
 			break;
@@ -6564,7 +6572,7 @@ static int dgap_parsefile(char **in)
 		case ID:	/* letter ID used in tty name */
 			s = dgap_getword(in);
 			if (!s) {
-				dgap_err("unexpected end of file");
+				pr_err("unexpected end of file");
 				return -1;
 			}
 
@@ -6577,7 +6585,7 @@ static int dgap_parsefile(char **in)
 				p->u.module.id = kstrdup(s, GFP_KERNEL);
 				p->u.module.v_id = 1;
 			} else {
-				dgap_err("id only valid for concentrators or modules");
+				pr_err("id only valid for concentrators or modules");
 				return -1;
 			}
 			break;
@@ -6586,38 +6594,38 @@ static int dgap_parsefile(char **in)
 			if (p->type == BNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.board.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("bad number for start of tty count");
 					return -1;
 				}
 				p->u.board.v_start = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("bad number for start of tty count");
 					return -1;
 				}
 				p->u.conc.v_start = 1;
 			} else if (p->type == MNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.module.start)) {
-					dgap_err("bad number for start of tty count");
+					pr_err("bad number for start of tty count");
 					return -1;
 				}
 				p->u.module.v_start = 1;
 			} else {
-				dgap_err("start only valid for concentrators or modules");
+				pr_err("start only valid for concentrators or modules");
 				return -1;
 			}
 			break;
@@ -6627,24 +6635,21 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpeced end of file");
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
@@ -6652,44 +6657,39 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpeced end of file");
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
+				pr_err("must specify board before line info");
 				return -1;
 			}
 			switch (brd->u.board.type) {
 			case PPCM:
-				dgap_err("line not vaild for PC/em");
+				pr_err("line not vaild for PC/em");
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
@@ -6702,15 +6702,13 @@ static int dgap_parsefile(char **in)
 			if (dgap_checknode(p))
 				return -1;
 			if (!line) {
-				dgap_err("must specify line info before concentrator");
+				pr_err("must specify line info before concentrator");
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
@@ -6724,7 +6722,7 @@ static int dgap_parsefile(char **in)
 			conc_type = dgap_gettok(in);
 			if (conc_type == 0 || conc_type != CX ||
 			    conc_type != EPC) {
-				dgap_err("failed to set a type of concentratros");
+				pr_err("failed to set a type of concentratros");
 				return -1;
 			}
 
@@ -6736,7 +6734,7 @@ static int dgap_parsefile(char **in)
 			if (dgap_checknode(p))
 				return -1;
 			if (!brd) {
-				dgap_err("must specify board info before EBI modules");
+				pr_err("must specify board info before EBI modules");
 				return -1;
 			}
 			switch (brd->u.board.type) {
@@ -6745,16 +6743,15 @@ static int dgap_parsefile(char **in)
 				break;
 			default:
 				if (!conc) {
-					dgap_err("must specify concentrator info before EBI module");
+					pr_err("must specify concentrator info before EBI module");
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
 
@@ -6766,7 +6763,7 @@ static int dgap_parsefile(char **in)
 			module_type = dgap_gettok(in);
 			if (module_type == 0 || module_type != PORTS ||
 			    module_type != MODEM) {
-				dgap_err("failed to set a type of module");
+				pr_err("failed to set a type of module");
 				return -1;
 			}
 
@@ -6778,7 +6775,7 @@ static int dgap_parsefile(char **in)
 			if (p->type == LNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				p->u.line.cable = kstrdup(s, GFP_KERNEL);
@@ -6790,27 +6787,27 @@ static int dgap_parsefile(char **in)
 			if (p->type == LNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.line.speed)) {
-					dgap_err("bad number for line speed");
+					pr_err("bad number for line speed");
 					return -1;
 				}
 				p->u.line.v_speed = 1;
 			} else if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				if (kstrtol(s, 0, &p->u.conc.speed)) {
-					dgap_err("bad number for line speed");
+					pr_err("bad number for line speed");
 					return -1;
 				}
 				p->u.conc.v_speed = 1;
 			} else {
-				dgap_err("speed valid only for lines or concentrators.");
+				pr_err("speed valid only for lines or concentrators.");
 				return -1;
 			}
 			break;
@@ -6819,7 +6816,7 @@ static int dgap_parsefile(char **in)
 			if (p->type == CNODE) {
 				s = dgap_getword(in);
 				if (!s) {
-					dgap_err("unexpected end of file");
+					pr_err("unexpected end of file");
 					return -1;
 				}
 				p->u.conc.connect = kstrdup(s, GFP_KERNEL);
@@ -6831,24 +6828,21 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpeced end of file");
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
@@ -6856,21 +6850,19 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.majornumber)) {
-				dgap_err("bad number for major number");
+				pr_err("bad number for major number");
 				return -1;
 			}
 			break;
@@ -6880,21 +6872,19 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.altpin)) {
-				dgap_err("bad number for altpin");
+				pr_err("bad number for altpin");
 				return -1;
 			}
 			break;
@@ -6904,19 +6894,18 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.useintr)) {
-				dgap_err("bad number for useintr");
+				pr_err("bad number for useintr");
 				return -1;
 			}
 			break;
@@ -6926,21 +6915,19 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.ttysize)) {
-				dgap_err("bad number for ttysize");
+				pr_err("bad number for ttysize");
 				return -1;
 			}
 			break;
@@ -6950,21 +6937,19 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.chsize)) {
-				dgap_err("bad number for chsize");
+				pr_err("bad number for chsize");
 				return -1;
 			}
 			break;
@@ -6974,21 +6959,19 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.bssize)) {
-				dgap_err("bad number for bssize");
+				pr_err("bad number for bssize");
 				return -1;
 			}
 			break;
@@ -6998,21 +6981,19 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.unsize)) {
-				dgap_err("bad number for schedsize");
+				pr_err("bad number for schedsize");
 				return -1;
 			}
 			break;
@@ -7022,21 +7003,19 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.f2size)) {
-				dgap_err("bad number for f2200size");
+				pr_err("bad number for f2200size");
 				return -1;
 			}
 			break;
@@ -7046,21 +7025,19 @@ static int dgap_parsefile(char **in)
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
+				pr_err("unexpected end of file");
 				return -1;
 			}
 			if (kstrtol(s, 0, &p->u.vpixsize)) {
-				dgap_err("bad number for vpixsize");
+				pr_err("bad number for vpixsize");
 				return -1;
 			}
 			break;
@@ -7117,7 +7094,6 @@ static int dgap_gettok(char **in)
 			if (!strcmp(w, t->string))
 				return t->token;
 		}
-		dgap_err("board !!type not specified");
 	} else {
 		while ((w = dgap_getword(in))) {
 			snprintf(dgap_cword, MAXCWORD, "%s", w);
@@ -7161,15 +7137,6 @@ static char *dgap_getword(char **in)
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
@@ -7178,33 +7145,33 @@ static int dgap_checknode(struct cnode *p)
 	switch (p->type) {
 	case LNODE:
 		if (p->u.line.v_speed == 0) {
-			dgap_err("line speed not specified");
+			pr_err("line speed not specified");
 			return 1;
 		}
 		return 0;
 
 	case CNODE:
 		if (p->u.conc.v_speed == 0) {
-			dgap_err("concentrator line speed not specified");
+			pr_err("concentrator line speed not specified");
 			return 1;
 		}
 		if (p->u.conc.v_nport == 0) {
-			dgap_err("number of ports on concentrator not specified");
+			pr_err("number of ports on concentrator not specified");
 			return 1;
 		}
 		if (p->u.conc.v_id == 0) {
-			dgap_err("concentrator id letter not specified");
+			pr_err("concentrator id letter not specified");
 			return 1;
 		}
 		return 0;
 
 	case MNODE:
 		if (p->u.module.v_nport == 0) {
-			dgap_err("number of ports on EBI module not specified");
+			pr_err("number of ports on EBI module not specified");
 			return 1;
 		}
 		if (p->u.module.v_id == 0) {
-			dgap_err("EBI module id letter not specified");
+			pr_err("EBI module id letter not specified");
 			return 1;
 		}
 		return 0;
-- 
1.7.1

