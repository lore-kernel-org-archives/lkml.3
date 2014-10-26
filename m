Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbaJZCLD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 22:11:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43673 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaJZCLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 22:11:00 -0400
Date: Sun, 26 Oct 2014 11:08:54 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH RESEND] staging: dgap: re-arrange functions for removing
 forward declarations
Message-ID: <20141026020853.GA28838@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-arrange the functions for removing forward declarations.

Tested-by: Mark Hounschell <markh@compro.net>
Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
RESEND: This patch is tested all by Mark.
It is good to merge. Greg, check please.

 drivers/staging/dgap/dgap.c | 7462 +++++++++++++++++++++----------------------
 1 files changed, 3669 insertions(+), 3793 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index ad8c8ec..4b78051 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -65,145 +65,6 @@
 
 #include "dgap.h"
 
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Digi International, http://www.digi.com");
-MODULE_DESCRIPTION("Driver for the Digi International EPCA PCI based product line");
-MODULE_SUPPORTED_DEVICE("dgap");
-
-static int dgap_start(void);
-static void dgap_stop(void);
-static void dgap_init_globals(void);
-static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
-					int boardnum);
-static void dgap_cleanup_board(struct board_t *brd);
-static void dgap_poll_handler(ulong dummy);
-static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
-static void dgap_remove_one(struct pci_dev *dev);
-static int dgap_remap(struct board_t *brd);
-static void dgap_unmap(struct board_t *brd);
-static irqreturn_t dgap_intr(int irq, void *voidbrd);
-
-static int dgap_tty_open(struct tty_struct *tty, struct file *file);
-static void dgap_tty_close(struct tty_struct *tty, struct file *file);
-static int dgap_block_til_ready(struct tty_struct *tty, struct file *file,
-				struct channel_t *ch);
-static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
-				unsigned long arg);
-static int dgap_tty_digigeta(struct channel_t *ch,
-			     struct digi_t __user *retinfo);
-static int dgap_tty_digiseta(struct channel_t *ch, struct board_t *bd,
-			     struct un_t *un, struct digi_t __user *new_info);
-static int dgap_tty_digigetedelay(struct tty_struct *tty, int __user *retinfo);
-static int dgap_tty_digisetedelay(struct channel_t *ch, struct board_t *bd,
-				  struct un_t *un, int __user *new_info);
-static int dgap_tty_write_room(struct tty_struct *tty);
-static int dgap_tty_chars_in_buffer(struct tty_struct *tty);
-static void dgap_tty_start(struct tty_struct *tty);
-static void dgap_tty_stop(struct tty_struct *tty);
-static void dgap_tty_throttle(struct tty_struct *tty);
-static void dgap_tty_unthrottle(struct tty_struct *tty);
-static void dgap_tty_flush_chars(struct tty_struct *tty);
-static void dgap_tty_flush_buffer(struct tty_struct *tty);
-static void dgap_tty_hangup(struct tty_struct *tty);
-static int dgap_wait_for_drain(struct tty_struct *tty);
-static int dgap_set_modem_info(struct channel_t *ch, struct board_t *bd,
-			       struct un_t *un, unsigned int command,
-			       unsigned int __user *value);
-static int dgap_get_modem_info(struct channel_t *ch,
-				unsigned int __user *value);
-static int dgap_tty_digisetcustombaud(struct channel_t *ch, struct board_t *bd,
-				      struct un_t *un, int __user *new_info);
-static int dgap_tty_digigetcustombaud(struct channel_t *ch, struct un_t *un,
-				      int __user *retinfo);
-static int dgap_tty_tiocmget(struct tty_struct *tty);
-static int dgap_tty_tiocmset(struct tty_struct *tty, unsigned int set,
-				unsigned int clear);
-static int dgap_tty_send_break(struct tty_struct *tty, int msec);
-static void dgap_tty_wait_until_sent(struct tty_struct *tty, int timeout);
-static int dgap_tty_write(struct tty_struct *tty, const unsigned char *buf,
-				int count);
-static void dgap_tty_set_termios(struct tty_struct *tty,
-				struct ktermios *old_termios);
-static int dgap_tty_put_char(struct tty_struct *tty, unsigned char c);
-static void dgap_tty_send_xchar(struct tty_struct *tty, char ch);
-
-static int dgap_tty_register(struct board_t *brd);
-static void dgap_tty_unregister(struct board_t *brd);
-static int dgap_tty_init(struct board_t *);
-static void dgap_tty_free(struct board_t *);
-static void dgap_cleanup_tty(struct board_t *);
-static void dgap_carrier(struct channel_t *ch);
-static void dgap_input(struct channel_t *ch);
-
-/*
- * Our function prototypes from dgap_fep5
- */
-static void dgap_cmdw_ext(struct channel_t *ch, u16 cmd, u16 word, uint ncmds);
-static int dgap_event(struct board_t *bd);
-
-static void dgap_poll_tasklet(unsigned long data);
-static void dgap_cmdb(struct channel_t *ch, u8 cmd, u8 byte1,
-			u8 byte2, uint ncmds);
-static void dgap_cmdw(struct channel_t *ch, u8 cmd, u16 word, uint ncmds);
-static void dgap_wmove(struct channel_t *ch, char *buf, uint cnt);
-static int dgap_param(struct channel_t *ch, struct board_t *bd, u32 un_type);
-static void dgap_parity_scan(struct channel_t *ch, unsigned char *cbuf,
-				unsigned char *fbuf, int *len);
-static uint dgap_get_custom_baud(struct channel_t *ch);
-static void dgap_firmware_reset_port(struct channel_t *ch);
-
-/*
- * Function prototypes from dgap_parse.c.
- */
-static int dgap_gettok(char **in);
-static char *dgap_getword(char **in);
-static int dgap_checknode(struct cnode *p);
-
-/*
- * Function prototypes from dgap_sysfs.h
- */
-static void dgap_create_ports_sysfiles(struct board_t *bd);
-static void dgap_remove_ports_sysfiles(struct board_t *bd);
-
-static int dgap_create_driver_sysfiles(struct pci_driver *);
-static void dgap_remove_driver_sysfiles(struct pci_driver *);
-
-static void dgap_create_tty_sysfs(struct un_t *un, struct device *c);
-static void dgap_remove_tty_sysfs(struct device *c);
-
-/*
- * Function prototypes from dgap_parse.h
- */
-static int dgap_parsefile(char **in);
-static struct cnode *dgap_find_config(int type, int bus, int slot);
-static uint dgap_config_get_num_prts(struct board_t *bd);
-static char *dgap_create_config_string(struct board_t *bd, char *string);
-static uint dgap_config_get_useintr(struct board_t *bd);
-static uint dgap_config_get_altpin(struct board_t *bd);
-
-static void dgap_do_bios_load(struct board_t *brd, const u8 *ubios, int len);
-static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len);
-#ifdef DIGI_CONCENTRATORS_SUPPORTED
-static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len);
-#endif
-static int dgap_alloc_flipbuf(struct board_t *brd);
-static void dgap_free_flipbuf(struct board_t *brd);
-static int dgap_request_irq(struct board_t *brd);
-static void dgap_free_irq(struct board_t *brd);
-
-static void dgap_get_vpd(struct board_t *brd);
-static void dgap_do_reset_board(struct board_t *brd);
-static int dgap_test_bios(struct board_t *brd);
-static int dgap_test_fep(struct board_t *brd);
-static int dgap_tty_register_ports(struct board_t *brd);
-static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
-			      struct board_t *brd);
-static void dgap_cleanup_nodes(void);
-
-static void dgap_cleanup_module(void);
-
-module_exit(dgap_cleanup_module);
-
 /*
  * File operations permitted on Control/Management major.
  */
@@ -298,13 +159,6 @@ static struct board_id dgap_ids[] = {
 	{0,}						/* 0 terminated list. */
 };
 
-static struct pci_driver dgap_driver = {
-	.name		= "dgap",
-	.probe		= dgap_init_one,
-	.id_table	= dgap_pci_tbl,
-	.remove		= dgap_remove_one,
-};
-
 struct firmware_info {
 	u8 *conf_name;  /* dgap.conf */
 	u8 *bios_name;	/* BIOS filename */
@@ -367,29 +221,6 @@ static struct ktermios dgap_default_termios = {
 	.c_line =	0,
 };
 
-static const struct tty_operations dgap_tty_ops = {
-	.open = dgap_tty_open,
-	.close = dgap_tty_close,
-	.write = dgap_tty_write,
-	.write_room = dgap_tty_write_room,
-	.flush_buffer = dgap_tty_flush_buffer,
-	.chars_in_buffer = dgap_tty_chars_in_buffer,
-	.flush_chars = dgap_tty_flush_chars,
-	.ioctl = dgap_tty_ioctl,
-	.set_termios = dgap_tty_set_termios,
-	.stop = dgap_tty_stop,
-	.start = dgap_tty_start,
-	.throttle = dgap_tty_throttle,
-	.unthrottle = dgap_tty_unthrottle,
-	.hangup = dgap_tty_hangup,
-	.put_char = dgap_tty_put_char,
-	.tiocmget = dgap_tty_tiocmget,
-	.tiocmset = dgap_tty_tiocmset,
-	.break_ctl = dgap_tty_send_break,
-	.wait_until_sent = dgap_tty_wait_until_sent,
-	.send_xchar = dgap_tty_send_xchar
-};
-
 /*
  * Our needed internal static variables from dgap_parse.c
  */
@@ -457,1089 +288,1226 @@ static struct toklist dgap_tlist[] = {
 	{ 0,		NULL }
 };
 
-/************************************************************************
- *
- * Driver load/unload functions
- *
- ************************************************************************/
 
 /*
- * init_module()
- *
- * Module load.  This is where it all starts.
+ * dgap_sindex: much like index(), but it looks for a match of any character in
+ * the group, and returns that position.  If the first character is a ^, then
+ * this will match the first occurrence not in that group.
  */
-static int dgap_init_module(void)
+static char *dgap_sindex(char *string, char *group)
 {
-	int rc;
-
-	pr_info("%s, Digi International Part Number %s\n", DG_NAME, DG_PART);
-
-	rc = dgap_start();
-	if (rc)
-		return rc;
-
-	rc = pci_register_driver(&dgap_driver);
-	if (rc)
-		goto err_stop;
-
-	rc = dgap_create_driver_sysfiles(&dgap_driver);
-	if (rc)
-		goto err_unregister;
-
-	dgap_driver_state = DRIVER_READY;
+	char *ptr;
 
-	return 0;
+	if (!string || !group)
+		return (char *) NULL;
 
-err_unregister:
-	pci_unregister_driver(&dgap_driver);
-err_stop:
-	dgap_stop();
+	if (*group == '^') {
+		group++;
+		for (; *string; string++) {
+			for (ptr = group; *ptr; ptr++) {
+				if (*ptr == *string)
+					break;
+			}
+			if (*ptr == '\0')
+				return string;
+		}
+	} else {
+		for (; *string; string++) {
+			for (ptr = group; *ptr; ptr++) {
+				if (*ptr == *string)
+					return string;
+			}
+		}
+	}
 
-	return rc;
+	return (char *) NULL;
 }
-module_init(dgap_init_module);
 
 /*
- * Start of driver.
+ * get a word from the input stream, also keep track of current line number.
+ * words are separated by whitespace.
  */
-static int dgap_start(void)
+static char *dgap_getword(char **in)
 {
-	int rc;
-	unsigned long flags;
-	struct device *device;
-
-	/*
-	 * make sure that the globals are
-	 * init'd before we do anything else
-	 */
-	dgap_init_globals();
-
-	dgap_numboards = 0;
+	char *ret_ptr = *in;
 
-	pr_info("For the tools package please visit http://www.digi.com\n");
+	char *ptr = dgap_sindex(*in, " \t\n");
 
-	/*
-	 * Register our base character device into the kernel.
-	 */
+	/* If no word found, return null */
+	if (!ptr)
+		return NULL;
 
-	/*
-	 * Register management/dpa devices
-	 */
-	rc = register_chrdev(DIGI_DGAP_MAJOR, "dgap", &dgap_board_fops);
-	if (rc < 0)
-		return rc;
+	/* Mark new location for our buffer */
+	*ptr = '\0';
+	*in = ptr + 1;
 
-	dgap_class = class_create(THIS_MODULE, "dgap_mgmt");
-	if (IS_ERR(dgap_class)) {
-		rc = PTR_ERR(dgap_class);
-		goto failed_class;
+	/* Eat any extra spaces/tabs/newlines that might be present */
+	while (*in && **in && ((**in == ' ') ||
+			       (**in == '\t') ||
+			       (**in == '\n'))) {
+		**in = '\0';
+		*in = *in + 1;
 	}
 
-	device = device_create(dgap_class, NULL,
-		MKDEV(DIGI_DGAP_MAJOR, 0),
-		NULL, "dgap_mgmt");
-	if (IS_ERR(device)) {
-		rc = PTR_ERR(device);
-		goto failed_device;
-	}
+	return ret_ptr;
+}
 
-	/* Start the poller */
-	spin_lock_irqsave(&dgap_poll_lock, flags);
-	init_timer(&dgap_poll_timer);
-	dgap_poll_timer.function = dgap_poll_handler;
-	dgap_poll_timer.data = 0;
-	dgap_poll_time = jiffies + dgap_jiffies_from_ms(dgap_poll_tick);
-	dgap_poll_timer.expires = dgap_poll_time;
-	spin_unlock_irqrestore(&dgap_poll_lock, flags);
 
-	add_timer(&dgap_poll_timer);
+/*
+ * Get a token from the input file; return 0 if end of file is reached
+ */
+static int dgap_gettok(char **in)
+{
+	char *w;
+	struct toklist *t;
 
-	return rc;
+	if (strstr(dgap_cword, "board")) {
+		w = dgap_getword(in);
+		snprintf(dgap_cword, MAXCWORD, "%s", w);
+		for (t = dgap_brdtype; t->token != 0; t++) {
+			if (!strcmp(w, t->string))
+				return t->token;
+		}
+	} else {
+		while ((w = dgap_getword(in))) {
+			snprintf(dgap_cword, MAXCWORD, "%s", w);
+			for (t = dgap_tlist; t->token != 0; t++) {
+				if (!strcmp(w, t->string))
+					return t->token;
+			}
+		}
+	}
 
-failed_device:
-	class_destroy(dgap_class);
-failed_class:
-	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
-	return rc;
+	return 0;
 }
 
-static void dgap_stop(void)
+/*
+ * dgap_checknode: see if all the necessary info has been supplied for a node
+ * before creating the next node.
+ */
+static int dgap_checknode(struct cnode *p)
 {
-	unsigned long lock_flags;
-
-	spin_lock_irqsave(&dgap_poll_lock, lock_flags);
-	dgap_poll_stop = 1;
-	spin_unlock_irqrestore(&dgap_poll_lock, lock_flags);
+	switch (p->type) {
+	case LNODE:
+		if (p->u.line.v_speed == 0) {
+			pr_err("line speed not specified");
+			return 1;
+		}
+		return 0;
 
-	del_timer_sync(&dgap_poll_timer);
+	case CNODE:
+		if (p->u.conc.v_speed == 0) {
+			pr_err("concentrator line speed not specified");
+			return 1;
+		}
+		if (p->u.conc.v_nport == 0) {
+			pr_err("number of ports on concentrator not specified");
+			return 1;
+		}
+		if (p->u.conc.v_id == 0) {
+			pr_err("concentrator id letter not specified");
+			return 1;
+		}
+		return 0;
 
-	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
-	class_destroy(dgap_class);
-	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
+	case MNODE:
+		if (p->u.module.v_nport == 0) {
+			pr_err("number of ports on EBI module not specified");
+			return 1;
+		}
+		if (p->u.module.v_id == 0) {
+			pr_err("EBI module id letter not specified");
+			return 1;
+		}
+		return 0;
+	}
+	return 0;
 }
 
-static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+/*
+ * Given a board pointer, returns whether we should use interrupts or not.
+ */
+static uint dgap_config_get_useintr(struct board_t *bd)
 {
-	int rc;
-	struct board_t *brd;
-
-	if (dgap_numboards >= MAXBOARDS)
-		return -EPERM;
-
-	rc = pci_enable_device(pdev);
-	if (rc)
-		return -EIO;
-
-	brd = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
-	if (IS_ERR(brd))
-		return PTR_ERR(brd);
-
-	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
-	if (rc)
-		goto cleanup_brd;
-
-	rc = dgap_alloc_flipbuf(brd);
-	if (rc)
-		goto cleanup_brd;
-
-	rc = dgap_tty_register(brd);
-	if (rc)
-		goto free_flipbuf;
-
-	rc = dgap_request_irq(brd);
-	if (rc)
-		goto unregister_tty;
-
-	/*
-	 * Do tty device initialization.
-	 */
-	rc = dgap_tty_init(brd);
-	if (rc < 0)
-		goto free_irq;
-
-	rc = dgap_tty_register_ports(brd);
-	if (rc)
-		goto tty_free;
+	struct cnode *p;
 
-	brd->state = BOARD_READY;
-	brd->dpastatus = BD_RUNNING;
+	if (!bd)
+		return 0;
 
-	dgap_board[dgap_numboards++] = brd;
+	for (p = bd->bd_config; p; p = p->next) {
+		if (p->type == INTRNODE) {
+			/*
+			 * check for pcxr types.
+			 */
+			return p->u.useintr;
+		}
+	}
 
+	/* If not found, then don't turn on interrupts. */
 	return 0;
-
-tty_free:
-	dgap_tty_free(brd);
-free_irq:
-	dgap_free_irq(brd);
-unregister_tty:
-	dgap_tty_unregister(brd);
-free_flipbuf:
-	dgap_free_flipbuf(brd);
-cleanup_brd:
-	dgap_cleanup_nodes();
-	dgap_unmap(brd);
-	kfree(brd);
-
-	return rc;
-}
-
-static void dgap_remove_one(struct pci_dev *dev)
-{
-	/* Do Nothing */
 }
 
 /*
- * dgap_cleanup_module()
- *
- * Module unload.  This is where it all ends.
+ * Given a board pointer, returns whether we turn on altpin or not.
  */
-static void dgap_cleanup_module(void)
+static uint dgap_config_get_altpin(struct board_t *bd)
 {
-	int i;
-	ulong lock_flags;
-
-	spin_lock_irqsave(&dgap_poll_lock, lock_flags);
-	dgap_poll_stop = 1;
-	spin_unlock_irqrestore(&dgap_poll_lock, lock_flags);
-
-	/* Turn off poller right away. */
-	del_timer_sync(&dgap_poll_timer);
-
-	dgap_remove_driver_sysfiles(&dgap_driver);
+	struct cnode *p;
 
-	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
-	class_destroy(dgap_class);
-	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
+	if (!bd)
+		return 0;
 
-	for (i = 0; i < dgap_numboards; ++i) {
-		dgap_remove_ports_sysfiles(dgap_board[i]);
-		dgap_cleanup_tty(dgap_board[i]);
-		dgap_cleanup_board(dgap_board[i]);
+	for (p = bd->bd_config; p; p = p->next) {
+		if (p->type == ANODE) {
+			/*
+			 * check for pcxr types.
+			 */
+			return p->u.altpin;
+		}
 	}
 
-	dgap_cleanup_nodes();
-
-	if (dgap_numboards)
-		pci_unregister_driver(&dgap_driver);
+	/* If not found, then don't turn on interrupts. */
+	return 0;
 }
 
 /*
- * dgap_cleanup_board()
- *
- * Free all the memory associated with a board
+ * Given a specific type of board, if found, detached link and
+ * returns the first occurrence in the list.
  */
-static void dgap_cleanup_board(struct board_t *brd)
+static struct cnode *dgap_find_config(int type, int bus, int slot)
 {
-	int i;
+	struct cnode *p, *prev, *prev2, *found;
 
-	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
-		return;
+	p = &dgap_head;
 
-	dgap_free_irq(brd);
+	while (p->next) {
+		prev = p;
+		p = p->next;
 
-	tasklet_kill(&brd->helper_tasklet);
+		if (p->type != BNODE)
+			continue;
 
-	dgap_unmap(brd);
+		if (p->u.board.type != type)
+			continue;
 
-	/* Free all allocated channels structs */
-	for (i = 0; i < MAXPORTS ; i++)
-		kfree(brd->channels[i]);
+		if (p->u.board.v_pcibus &&
+		    p->u.board.pcibus != bus)
+			continue;
 
-	kfree(brd->flipbuf);
-	kfree(brd->flipflagbuf);
+		if (p->u.board.v_pcislot &&
+		    p->u.board.pcislot != slot)
+			continue;
 
-	dgap_board[brd->boardnum] = NULL;
+		found = p;
+		/*
+		 * Keep walking thru the list till we
+		 * find the next board.
+		 */
+		while (p->next) {
+			prev2 = p;
+			p = p->next;
 
-	kfree(brd);
+			if (p->type != BNODE)
+				continue;
+
+			/*
+			 * Mark the end of our 1 board
+			 * chain of configs.
+			 */
+			prev2->next = NULL;
+
+			/*
+			 * Link the "next" board to the
+			 * previous board, effectively
+			 * "unlinking" our board from
+			 * the main config.
+			 */
+			prev->next = p;
+
+			return found;
+		}
+		/*
+		 * It must be the last board in the list.
+		 */
+		prev->next = NULL;
+		return found;
+	}
+	return NULL;
 }
 
 /*
- * dgap_found_board()
- *
- * A board has been found, init it.
+ * Given a board pointer, walks the config link, counting up
+ * all ports user specified should be on the board.
+ * (This does NOT mean they are all actually present right now tho)
  */
-static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
-					int boardnum)
+static uint dgap_config_get_num_prts(struct board_t *bd)
 {
-	struct board_t *brd;
-	unsigned int pci_irq;
-	int i;
-	int ret;
-
-	/* get the board structure and prep it */
-	brd = kzalloc(sizeof(struct board_t), GFP_KERNEL);
-	if (!brd)
-		return ERR_PTR(-ENOMEM);
-
-	/* store the info for the board we've found */
-	brd->magic = DGAP_BOARD_MAGIC;
-	brd->boardnum = boardnum;
-	brd->vendor = dgap_pci_tbl[id].vendor;
-	brd->device = dgap_pci_tbl[id].device;
-	brd->pdev = pdev;
-	brd->pci_bus = pdev->bus->number;
-	brd->pci_slot = PCI_SLOT(pdev->devfn);
-	brd->name = dgap_ids[id].name;
-	brd->maxports = dgap_ids[id].maxports;
-	brd->type = dgap_ids[id].config_type;
-	brd->dpatype = dgap_ids[id].dpatype;
-	brd->dpastatus = BD_NOFEP;
-	init_waitqueue_head(&brd->state_wait);
+	int count = 0;
+	struct cnode *p;
 
-	spin_lock_init(&brd->bd_lock);
+	if (!bd)
+		return 0;
 
-	brd->inhibit_poller	= FALSE;
-	brd->wait_for_bios	= 0;
-	brd->wait_for_fep	= 0;
+	for (p = bd->bd_config; p; p = p->next) {
 
-	for (i = 0; i < MAXPORTS; i++)
-		brd->channels[i] = NULL;
+		switch (p->type) {
+		case BNODE:
+			/*
+			 * check for pcxr types.
+			 */
+			if (p->u.board.type > EPCFE)
+				count += p->u.board.nport;
+			break;
+		case CNODE:
+			count += p->u.conc.nport;
+			break;
+		case MNODE:
+			count += p->u.module.nport;
+			break;
+		}
+	}
+	return count;
+}
 
-	/* store which card & revision we have */
-	pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &brd->subvendor);
-	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &brd->subdevice);
-	pci_read_config_byte(pdev, PCI_REVISION_ID, &brd->rev);
+static char *dgap_create_config_string(struct board_t *bd, char *string)
+{
+	char *ptr = string;
+	struct cnode *p;
+	struct cnode *q;
+	int speed;
 
-	pci_irq = pdev->irq;
-	brd->irq = pci_irq;
+	if (!bd) {
+		*ptr = 0xff;
+		return string;
+	}
 
-	/* get the PCI Base Address Registers */
+	for (p = bd->bd_config; p; p = p->next) {
 
-	/* Xr Jupiter and EPC use BAR 2 */
-	if (brd->device == PCI_DEV_XRJ_DID || brd->device == PCI_DEV_EPCJ_DID) {
-		brd->membase     = pci_resource_start(pdev, 2);
-		brd->membase_end = pci_resource_end(pdev, 2);
-	}
-	/* Everyone else uses BAR 0 */
-	else {
-		brd->membase     = pci_resource_start(pdev, 0);
-		brd->membase_end = pci_resource_end(pdev, 0);
-	}
+		switch (p->type) {
+		case LNODE:
+			*ptr = '\0';
+			ptr++;
+			*ptr = p->u.line.speed;
+			ptr++;
+			break;
+		case CNODE:
+			/*
+			 * Because the EPC/con concentrators can have EM modules
+			 * hanging off of them, we have to walk ahead in the
+			 * list and keep adding the number of ports on each EM
+			 * to the config. UGH!
+			 */
+			speed = p->u.conc.speed;
+			q = p->next;
+			if (q && (q->type == MNODE)) {
+				*ptr = (p->u.conc.nport + 0x80);
+				ptr++;
+				p = q;
+				while (q->next && (q->next->type) == MNODE) {
+					*ptr = (q->u.module.nport + 0x80);
+					ptr++;
+					p = q;
+					q = q->next;
+				}
+				*ptr = q->u.module.nport;
+				ptr++;
+			} else {
+				*ptr = p->u.conc.nport;
+				ptr++;
+			}
 
-	if (!brd->membase) {
-		ret = -ENODEV;
-		goto free_brd;
+			*ptr = speed;
+			ptr++;
+			break;
+		}
 	}
 
-	if (brd->membase & 1)
-		brd->membase &= ~3;
-	else
-		brd->membase &= ~15;
-
-	/*
-	 * On the PCI boards, there is no IO space allocated
-	 * The I/O registers will be in the first 3 bytes of the
-	 * upper 2MB of the 4MB memory space.  The board memory
-	 * will be mapped into the low 2MB of the 4MB memory space
-	 */
-	brd->port = brd->membase + PCI_IO_OFFSET;
-	brd->port_end = brd->port + PCI_IO_SIZE;
+	*ptr = 0xff;
+	return string;
+}
 
-	/*
-	 * Special initialization for non-PLX boards
-	 */
-	if (brd->device != PCI_DEV_XRJ_DID && brd->device != PCI_DEV_EPCJ_DID) {
-		unsigned short cmd;
+/*
+ * Parse a configuration file read into memory as a string.
+ */
+static int dgap_parsefile(char **in)
+{
+	struct cnode *p, *brd, *line, *conc;
+	int rc;
+	char *s;
+	int linecnt = 0;
 
-		pci_write_config_byte(pdev, 0x40, 0);
-		pci_write_config_byte(pdev, 0x46, 0);
+	p = &dgap_head;
+	brd = line = conc = NULL;
 
-		/* Limit burst length to 2 doubleword transactions */
-		pci_write_config_byte(pdev, 0x42, 1);
+	/* perhaps we are adding to an existing list? */
+	while (p->next)
+		p = p->next;
 
-		/*
-		 * Enable IO and mem if not already done.
-		 * This was needed for support on Itanium.
-		 */
-		pci_read_config_word(pdev, PCI_COMMAND, &cmd);
-		cmd |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
-		pci_write_config_word(pdev, PCI_COMMAND, cmd);
+	/* file must start with a BEGIN */
+	while ((rc = dgap_gettok(in)) != BEGIN) {
+		if (rc == 0) {
+			pr_err("unexpected EOF");
+			return -1;
+		}
 	}
 
-	/* init our poll helper tasklet */
-	tasklet_init(&brd->helper_tasklet, dgap_poll_tasklet,
-			(unsigned long) brd);
+	for (; ;) {
+		int board_type = 0;
+		int conc_type = 0;
+		int module_type = 0;
 
-	ret = dgap_remap(brd);
-	if (ret)
-		goto free_brd;
+		rc = dgap_gettok(in);
+		if (rc == 0) {
+			pr_err("unexpected EOF");
+			return -1;
+		}
 
-	pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
-		boardnum, brd->name, brd->rev, brd->irq);
+		switch (rc) {
+		case BEGIN:	/* should only be 1 begin */
+			pr_err("unexpected config_begin\n");
+			return -1;
 
-	return brd;
+		case END:
+			return 0;
 
-free_brd:
-	kfree(brd);
+		case BOARD:	/* board info */
+			if (dgap_checknode(p))
+				return -1;
 
-	return ERR_PTR(ret);
-}
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
+			p = p->next;
 
-static int dgap_request_irq(struct board_t *brd)
-{
-	int rc;
+			p->type = BNODE;
+			p->u.board.status = kstrdup("No", GFP_KERNEL);
+			line = conc = NULL;
+			brd = p;
+			linecnt = -1;
 
-	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
-		return -ENODEV;
+			board_type = dgap_gettok(in);
+			if (board_type == 0) {
+				pr_err("board !!type not specified");
+				return -1;
+			}
 
-	/*
-	 * Set up our interrupt handler if we are set to do interrupts.
-	 */
-	if (dgap_config_get_useintr(brd) && brd->irq) {
+			p->u.board.type = board_type;
 
-		rc = request_irq(brd->irq, dgap_intr, IRQF_SHARED, "DGAP", brd);
+			break;
 
-		if (!rc)
-			brd->intr_used = 1;
-	}
-	return 0;
-}
+		case IO:	/* i/o port */
+			if (p->type != BNODE) {
+				pr_err("IO port only vaild for boards");
+				return -1;
+			}
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			p->u.board.portstr = kstrdup(s, GFP_KERNEL);
+			if (kstrtol(s, 0, &p->u.board.port)) {
+				pr_err("bad number for IO port");
+				return -1;
+			}
+			p->u.board.v_port = 1;
+			break;
 
-static void dgap_free_irq(struct board_t *brd)
-{
-	if (brd->intr_used && brd->irq)
-		free_irq(brd->irq, brd);
-}
+		case MEM:	/* memory address */
+			if (p->type != BNODE) {
+				pr_err("memory address only vaild for boards");
+				return -1;
+			}
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			p->u.board.addrstr = kstrdup(s, GFP_KERNEL);
+			if (kstrtoul(s, 0, &p->u.board.addr)) {
+				pr_err("bad number for memory address");
+				return -1;
+			}
+			p->u.board.v_addr = 1;
+			break;
 
-static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
-			      struct board_t *brd)
-{
-	const struct firmware *fw;
-	char *tmp_ptr;
-	int ret;
-	char *dgap_config_buf;
+		case PCIINFO:	/* pci information */
+			if (p->type != BNODE) {
+				pr_err("memory address only vaild for boards");
+				return -1;
+			}
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			p->u.board.pcibusstr = kstrdup(s, GFP_KERNEL);
+			if (kstrtoul(s, 0, &p->u.board.pcibus)) {
+				pr_err("bad number for pci bus");
+				return -1;
+			}
+			p->u.board.v_pcibus = 1;
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			p->u.board.pcislotstr = kstrdup(s, GFP_KERNEL);
+			if (kstrtoul(s, 0, &p->u.board.pcislot)) {
+				pr_err("bad number for pci slot");
+				return -1;
+			}
+			p->u.board.v_pcislot = 1;
+			break;
 
-	dgap_get_vpd(brd);
-	dgap_do_reset_board(brd);
+		case METHOD:
+			if (p->type != BNODE) {
+				pr_err("install method only vaild for boards");
+				return -1;
+			}
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			p->u.board.method = kstrdup(s, GFP_KERNEL);
+			p->u.board.v_method = 1;
+			break;
 
-	if (fw_info[card_type].conf_name) {
-		ret = request_firmware(&fw, fw_info[card_type].conf_name,
-					 &pdev->dev);
-		if (ret) {
-			dev_err(&pdev->dev, "config file %s not found\n",
-				fw_info[card_type].conf_name);
-			return ret;
-		}
+		case STATUS:
+			if (p->type != BNODE) {
+				pr_err("config status only vaild for boards");
+				return -1;
+			}
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			p->u.board.status = kstrdup(s, GFP_KERNEL);
+			break;
 
-		dgap_config_buf = kzalloc(fw->size + 1, GFP_KERNEL);
-		if (!dgap_config_buf) {
-			release_firmware(fw);
-			return -ENOMEM;
-		}
+		case NPORTS:	/* number of ports */
+			if (p->type == BNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				if (kstrtol(s, 0, &p->u.board.nport)) {
+					pr_err("bad number for number of ports");
+					return -1;
+				}
+				p->u.board.v_nport = 1;
+			} else if (p->type == CNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				if (kstrtol(s, 0, &p->u.conc.nport)) {
+					pr_err("bad number for number of ports");
+					return -1;
+				}
+				p->u.conc.v_nport = 1;
+			} else if (p->type == MNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				if (kstrtol(s, 0, &p->u.module.nport)) {
+					pr_err("bad number for number of ports");
+					return -1;
+				}
+				p->u.module.v_nport = 1;
+			} else {
+				pr_err("nports only valid for concentrators or modules");
+				return -1;
+			}
+			break;
 
-		memcpy(dgap_config_buf, fw->data, fw->size);
-		release_firmware(fw);
+		case ID:	/* letter ID used in tty name */
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
 
-		/*
-		 * preserve dgap_config_buf
-		 * as dgap_parsefile would
-		 * otherwise alter it.
-		 */
-		tmp_ptr = dgap_config_buf;
+			p->u.board.status = kstrdup(s, GFP_KERNEL);
 
-		if (dgap_parsefile(&tmp_ptr) != 0) {
-			kfree(dgap_config_buf);
-			return -EINVAL;
-		}
-		kfree(dgap_config_buf);
-	}
+			if (p->type == CNODE) {
+				p->u.conc.id = kstrdup(s, GFP_KERNEL);
+				p->u.conc.v_id = 1;
+			} else if (p->type == MNODE) {
+				p->u.module.id = kstrdup(s, GFP_KERNEL);
+				p->u.module.v_id = 1;
+			} else {
+				pr_err("id only valid for concentrators or modules");
+				return -1;
+			}
+			break;
 
-	/*
-	 * Match this board to a config the user created for us.
-	 */
-	brd->bd_config =
-		dgap_find_config(brd->type, brd->pci_bus, brd->pci_slot);
+		case STARTO:	/* start offset of ID */
+			if (p->type == BNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				if (kstrtol(s, 0, &p->u.board.start)) {
+					pr_err("bad number for start of tty count");
+					return -1;
+				}
+				p->u.board.v_start = 1;
+			} else if (p->type == CNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				if (kstrtol(s, 0, &p->u.conc.start)) {
+					pr_err("bad number for start of tty count");
+					return -1;
+				}
+				p->u.conc.v_start = 1;
+			} else if (p->type == MNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				if (kstrtol(s, 0, &p->u.module.start)) {
+					pr_err("bad number for start of tty count");
+					return -1;
+				}
+				p->u.module.v_start = 1;
+			} else {
+				pr_err("start only valid for concentrators or modules");
+				return -1;
+			}
+			break;
 
-	/*
-	 * Because the 4 port Xr products share the same PCI ID
-	 * as the 8 port Xr products, if we receive a NULL config
-	 * back, and this is a PAPORT8 board, retry with a
-	 * PAPORT4 attempt as well.
-	 */
-	if (brd->type == PAPORT8 && !brd->bd_config)
-		brd->bd_config =
-			dgap_find_config(PAPORT4, brd->pci_bus, brd->pci_slot);
+		case TTYN:	/* tty name prefix */
+			if (dgap_checknode(p))
+				return -1;
 
-	if (!brd->bd_config) {
-		dev_err(&pdev->dev, "No valid configuration found\n");
-		return -EINVAL;
-	}
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	if (fw_info[card_type].bios_name) {
-		ret = request_firmware(&fw, fw_info[card_type].bios_name,
-					&pdev->dev);
-		if (ret) {
-			dev_err(&pdev->dev, "bios file %s not found\n",
-				fw_info[card_type].bios_name);
-			return ret;
-		}
-		dgap_do_bios_load(brd, fw->data, fw->size);
-		release_firmware(fw);
+			p = p->next;
+			p->type = TNODE;
 
-		/* Wait for BIOS to test board... */
-		ret = dgap_test_bios(brd);
-		if (ret)
-			return ret;
-	}
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpeced end of file");
+				return -1;
+			}
+			p->u.ttyname = kstrdup(s, GFP_KERNEL);
+			if (!p->u.ttyname)
+				return -1;
 
-	if (fw_info[card_type].fep_name) {
-		ret = request_firmware(&fw, fw_info[card_type].fep_name,
-					&pdev->dev);
-		if (ret) {
-			dev_err(&pdev->dev, "dgap: fep file %s not found\n",
-				fw_info[card_type].fep_name);
-			return ret;
-		}
-		dgap_do_fep_load(brd, fw->data, fw->size);
-		release_firmware(fw);
+			break;
 
-		/* Wait for FEP to load on board... */
-		ret = dgap_test_fep(brd);
-		if (ret)
-			return ret;
-	}
+		case CU:	/* cu name prefix */
+			if (dgap_checknode(p))
+				return -1;
 
-#ifdef DIGI_CONCENTRATORS_SUPPORTED
-	/*
-	 * If this is a CX or EPCX, we need to see if the firmware
-	 * is requesting a concentrator image from us.
-	 */
-	if ((bd->type == PCX) || (bd->type == PEPC)) {
-		chk_addr = (u16 *) (vaddr + DOWNREQ);
-		/* Nonzero if FEP is requesting concentrator image. */
-		check = readw(chk_addr);
-		vaddr = brd->re_map_membase;
-	}
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	if (fw_info[card_type].con_name && check && vaddr) {
-		ret = request_firmware(&fw, fw_info[card_type].con_name,
-					&pdev->dev);
-		if (ret) {
-			dev_err(&pdev->dev, "conc file %s not found\n",
-				fw_info[card_type].con_name);
-			return ret;
-		}
-		/* Put concentrator firmware loading code here */
-		offset = readw((u16 *) (vaddr + DOWNREQ));
-		memcpy_toio(offset, fw->data, fw->size);
+			p = p->next;
+			p->type = CUNODE;
 
-		dgap_do_conc_load(brd, (char *)fw->data, fw->size)
-		release_firmware(fw);
-	}
-#endif
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpeced end of file");
+				return -1;
+			}
+			p->u.cuname = kstrdup(s, GFP_KERNEL);
+			if (!p->u.cuname)
+				return -1;
 
-	return 0;
-}
+			break;
 
-/*
- * Remap PCI memory.
- */
-static int dgap_remap(struct board_t *brd)
-{
-	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
-		return -EIO;
+		case LINE:	/* line information */
+			if (dgap_checknode(p))
+				return -1;
+			if (!brd) {
+				pr_err("must specify board before line info");
+				return -1;
+			}
+			switch (brd->u.board.type) {
+			case PPCM:
+				pr_err("line not vaild for PC/em");
+				return -1;
+			}
 
-	if (!request_mem_region(brd->membase, 0x200000, "dgap"))
-		return -ENOMEM;
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	if (!request_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000,
-					"dgap")) {
-		release_mem_region(brd->membase, 0x200000);
-		return -ENOMEM;
-	}
+			p = p->next;
+			p->type = LNODE;
+			conc = NULL;
+			line = p;
+			linecnt++;
+			break;
 
-	brd->re_map_membase = ioremap(brd->membase, 0x200000);
-	if (!brd->re_map_membase) {
-		release_mem_region(brd->membase, 0x200000);
-		release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
-		return -ENOMEM;
-	}
+		case CONC:	/* concentrator information */
+			if (dgap_checknode(p))
+				return -1;
+			if (!line) {
+				pr_err("must specify line info before concentrator");
+				return -1;
+			}
 
-	brd->re_map_port = ioremap((brd->membase + PCI_IO_OFFSET), 0x200000);
-	if (!brd->re_map_port) {
-		release_mem_region(brd->membase, 0x200000);
-		release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
-		iounmap(brd->re_map_membase);
-		return -ENOMEM;
-	}
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	return 0;
-}
+			p = p->next;
+			p->type = CNODE;
+			conc = p;
 
-static void dgap_unmap(struct board_t *brd)
-{
-	iounmap(brd->re_map_port);
-	iounmap(brd->re_map_membase);
-	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
-	release_mem_region(brd->membase, 0x200000);
-}
-/*****************************************************************************
-*
-* Function:
-*
-*    dgap_poll_handler
-*
-* Author:
-*
-*    Scott H Kilau
-*
-* Parameters:
-*
-*    dummy -- ignored
-*
-* Return Values:
-*
-*    none
-*
-* Description:
-*
-*    As each timer expires, it determines (a) whether the "transmit"
-*    waiter needs to be woken up, and (b) whether the poller needs to
-*    be rescheduled.
-*
-******************************************************************************/
+			if (linecnt)
+				brd->u.board.conc2++;
+			else
+				brd->u.board.conc1++;
 
-static void dgap_poll_handler(ulong dummy)
-{
-	int i;
-	struct board_t *brd;
-	unsigned long lock_flags;
-	ulong new_time;
+			conc_type = dgap_gettok(in);
+			if (conc_type == 0 || conc_type != CX ||
+			    conc_type != EPC) {
+				pr_err("failed to set a type of concentratros");
+				return -1;
+			}
 
-	dgap_poll_counter++;
+			p->u.conc.type = conc_type;
 
-	/*
-	 * Do not start the board state machine until
-	 * driver tells us its up and running, and has
-	 * everything it needs.
-	 */
-	if (dgap_driver_state != DRIVER_READY)
-		goto schedule_poller;
+			break;
 
-	/*
-	 * If we have just 1 board, or the system is not SMP,
-	 * then use the typical old style poller.
-	 * Otherwise, use our new tasklet based poller, which should
-	 * speed things up for multiple boards.
-	 */
-	if ((dgap_numboards == 1) || (num_online_cpus() <= 1)) {
-		for (i = 0; i < dgap_numboards; i++) {
+		case MOD:	/* EBI module */
+			if (dgap_checknode(p))
+				return -1;
+			if (!brd) {
+				pr_err("must specify board info before EBI modules");
+				return -1;
+			}
+			switch (brd->u.board.type) {
+			case PPCM:
+				linecnt = 0;
+				break;
+			default:
+				if (!conc) {
+					pr_err("must specify concentrator info before EBI module");
+					return -1;
+				}
+			}
 
-			brd = dgap_board[i];
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-			if (brd->state == BOARD_FAILED)
-				continue;
-			if (!brd->intr_running)
-				/* Call the real board poller directly */
-				dgap_poll_tasklet((unsigned long) brd);
-		}
-	} else {
-		/*
-		 * Go thru each board, kicking off a
-		 * tasklet for each if needed
-		 */
-		for (i = 0; i < dgap_numboards; i++) {
-			brd = dgap_board[i];
+			p = p->next;
+			p->type = MNODE;
 
-			/*
-			 * Attempt to grab the board lock.
-			 *
-			 * If we can't get it, no big deal, the next poll
-			 * will get it. Basically, I just really don't want
-			 * to spin in here, because I want to kick off my
-			 * tasklets as fast as I can, and then get out the
-			 * poller.
-			 */
-			if (!spin_trylock(&brd->bd_lock))
-				continue;
+			if (linecnt)
+				brd->u.board.module2++;
+			else
+				brd->u.board.module1++;
 
-			/*
-			 * If board is in a failed state, don't bother
-			 *  scheduling a tasklet
-			 */
-			if (brd->state == BOARD_FAILED) {
-				spin_unlock(&brd->bd_lock);
-				continue;
+			module_type = dgap_gettok(in);
+			if (module_type == 0 || module_type != PORTS ||
+			    module_type != MODEM) {
+				pr_err("failed to set a type of module");
+				return -1;
 			}
 
-			/* Schedule a poll helper task */
-			if (!brd->intr_running)
-				tasklet_schedule(&brd->helper_tasklet);
-
-			/*
-			 * Can't do DGAP_UNLOCK here, as we don't have
-			 * lock_flags because we did a trylock above.
-			 */
-			spin_unlock(&brd->bd_lock);
-		}
-	}
+			p->u.module.type = module_type;
 
-schedule_poller:
+			break;
 
-	/*
-	 * Schedule ourself back at the nominal wakeup interval.
-	 */
-	spin_lock_irqsave(&dgap_poll_lock, lock_flags);
-	dgap_poll_time +=  dgap_jiffies_from_ms(dgap_poll_tick);
+		case CABLE:
+			if (p->type == LNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				p->u.line.cable = kstrdup(s, GFP_KERNEL);
+				p->u.line.v_cable = 1;
+			}
+			break;
 
-	new_time = dgap_poll_time - jiffies;
+		case SPEED:	/* sync line speed indication */
+			if (p->type == LNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				if (kstrtol(s, 0, &p->u.line.speed)) {
+					pr_err("bad number for line speed");
+					return -1;
+				}
+				p->u.line.v_speed = 1;
+			} else if (p->type == CNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				if (kstrtol(s, 0, &p->u.conc.speed)) {
+					pr_err("bad number for line speed");
+					return -1;
+				}
+				p->u.conc.v_speed = 1;
+			} else {
+				pr_err("speed valid only for lines or concentrators.");
+				return -1;
+			}
+			break;
 
-	if ((ulong) new_time >= 2 * dgap_poll_tick) {
-		dgap_poll_time =
-			jiffies +  dgap_jiffies_from_ms(dgap_poll_tick);
-	}
+		case CONNECT:
+			if (p->type == CNODE) {
+				s = dgap_getword(in);
+				if (!s) {
+					pr_err("unexpected end of file");
+					return -1;
+				}
+				p->u.conc.connect = kstrdup(s, GFP_KERNEL);
+				p->u.conc.v_connect = 1;
+			}
+			break;
+		case PRINT:	/* transparent print name prefix */
+			if (dgap_checknode(p))
+				return -1;
 
-	dgap_poll_timer.function = dgap_poll_handler;
-	dgap_poll_timer.data = 0;
-	dgap_poll_timer.expires = dgap_poll_time;
-	spin_unlock_irqrestore(&dgap_poll_lock, lock_flags);
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	if (!dgap_poll_stop)
-		add_timer(&dgap_poll_timer);
-}
+			p = p->next;
+			p->type = PNODE;
 
-/*
- * dgap_intr()
- *
- * Driver interrupt handler.
- */
-static irqreturn_t dgap_intr(int irq, void *voidbrd)
-{
-	struct board_t *brd = (struct board_t *) voidbrd;
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpeced end of file");
+				return -1;
+			}
+			p->u.printname = kstrdup(s, GFP_KERNEL);
+			if (!p->u.printname)
+				return -1;
 
-	if (!brd)
-		return IRQ_NONE;
+			break;
 
-	/*
-	 * Check to make sure its for us.
-	 */
-	if (brd->magic != DGAP_BOARD_MAGIC)
-		return IRQ_NONE;
+		case CMAJOR:	/* major number */
+			if (dgap_checknode(p))
+				return -1;
 
-	brd->intr_count++;
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	/*
-	 * Schedule tasklet to run at a better time.
-	 */
-	tasklet_schedule(&brd->helper_tasklet);
-	return IRQ_HANDLED;
-}
+			p = p->next;
+			p->type = JNODE;
 
-/*
- * dgap_init_globals()
- *
- * This is where we initialize the globals from the static insmod
- * configuration variables.  These are declared near the head of
- * this file.
- */
-static void dgap_init_globals(void)
-{
-	int i;
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.majornumber)) {
+				pr_err("bad number for major number");
+				return -1;
+			}
+			break;
 
-	for (i = 0; i < MAXBOARDS; i++)
-		dgap_board[i] = NULL;
+		case ALTPIN:	/* altpin setting */
+			if (dgap_checknode(p))
+				return -1;
 
-	init_timer(&dgap_poll_timer);
-}
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-/************************************************************************
- *
- * TTY Initialization/Cleanup Functions
- *
- ************************************************************************/
+			p = p->next;
+			p->type = ANODE;
 
-/*
- * dgap_tty_register()
- *
- * Init the tty subsystem for this board.
- */
-static int dgap_tty_register(struct board_t *brd)
-{
-	int rc;
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.altpin)) {
+				pr_err("bad number for altpin");
+				return -1;
+			}
+			break;
 
-	brd->serial_driver = tty_alloc_driver(MAXPORTS, 0);
-	if (IS_ERR(brd->serial_driver))
-		return PTR_ERR(brd->serial_driver);
+		case USEINTR:		/* enable interrupt setting */
+			if (dgap_checknode(p))
+				return -1;
 
-	snprintf(brd->serial_name, MAXTTYNAMELEN, "tty_dgap_%d_",
-		 brd->boardnum);
-	brd->serial_driver->name = brd->serial_name;
-	brd->serial_driver->name_base = 0;
-	brd->serial_driver->major = 0;
-	brd->serial_driver->minor_start = 0;
-	brd->serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
-	brd->serial_driver->subtype = SERIAL_TYPE_NORMAL;
-	brd->serial_driver->init_termios = dgap_default_termios;
-	brd->serial_driver->driver_name = DRVSTR;
-	brd->serial_driver->flags = (TTY_DRIVER_REAL_RAW |
-				    TTY_DRIVER_DYNAMIC_DEV |
-				    TTY_DRIVER_HARDWARE_BREAK);
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	/* The kernel wants space to store pointers to tty_structs */
-	brd->serial_driver->ttys =
-		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
-	if (!brd->serial_driver->ttys) {
-		rc = -ENOMEM;
-		goto free_serial_drv;
-	}
+			p = p->next;
+			p->type = INTRNODE;
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.useintr)) {
+				pr_err("bad number for useintr");
+				return -1;
+			}
+			break;
 
-	/*
-	 * Entry points for driver.  Called by the kernel from
-	 * tty_io.c and n_tty.c.
-	 */
-	tty_set_operations(brd->serial_driver, &dgap_tty_ops);
+		case TTSIZ:	/* size of tty structure */
+			if (dgap_checknode(p))
+				return -1;
 
-	/*
-	 * If we're doing transparent print, we have to do all of the above
-	 * again, separately so we don't get the LD confused about what major
-	 * we are when we get into the dgap_tty_open() routine.
-	 */
-	brd->print_driver = tty_alloc_driver(MAXPORTS, 0);
-	if (IS_ERR(brd->print_driver)) {
-		rc = PTR_ERR(brd->print_driver);
-		goto free_serial_drv;
-	}
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	snprintf(brd->print_name, MAXTTYNAMELEN, "pr_dgap_%d_",
-		 brd->boardnum);
-	brd->print_driver->name = brd->print_name;
-	brd->print_driver->name_base = 0;
-	brd->print_driver->major = 0;
-	brd->print_driver->minor_start = 0;
-	brd->print_driver->type = TTY_DRIVER_TYPE_SERIAL;
-	brd->print_driver->subtype = SERIAL_TYPE_NORMAL;
-	brd->print_driver->init_termios = dgap_default_termios;
-	brd->print_driver->driver_name = DRVSTR;
-	brd->print_driver->flags = (TTY_DRIVER_REAL_RAW |
-				   TTY_DRIVER_DYNAMIC_DEV |
-				   TTY_DRIVER_HARDWARE_BREAK);
+			p = p->next;
+			p->type = TSNODE;
 
-	/* The kernel wants space to store pointers to tty_structs */
-	brd->print_driver->ttys =
-		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
-	if (!brd->print_driver->ttys) {
-		rc = -ENOMEM;
-		goto free_print_drv;
-	}
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.ttysize)) {
+				pr_err("bad number for ttysize");
+				return -1;
+			}
+			break;
 
-	/*
-	 * Entry points for driver.  Called by the kernel from
-	 * tty_io.c and n_tty.c.
-	 */
-	tty_set_operations(brd->print_driver, &dgap_tty_ops);
+		case CHSIZ:	/* channel structure size */
+			if (dgap_checknode(p))
+				return -1;
 
-	/* Register tty devices */
-	rc = tty_register_driver(brd->serial_driver);
-	if (rc < 0)
-		goto free_print_drv;
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	/* Register Transparent Print devices */
-	rc = tty_register_driver(brd->print_driver);
-	if (rc < 0)
-		goto unregister_serial_drv;
+			p = p->next;
+			p->type = CSNODE;
 
-	dgap_boards_by_major[brd->serial_driver->major] = brd;
-	brd->dgap_serial_major = brd->serial_driver->major;
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.chsize)) {
+				pr_err("bad number for chsize");
+				return -1;
+			}
+			break;
 
-	dgap_boards_by_major[brd->print_driver->major] = brd;
-	brd->dgap_transparent_print_major = brd->print_driver->major;
+		case BSSIZ:	/* board structure size */
+			if (dgap_checknode(p))
+				return -1;
 
-	return 0;
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-unregister_serial_drv:
-	tty_unregister_driver(brd->serial_driver);
-free_print_drv:
-	put_tty_driver(brd->print_driver);
-free_serial_drv:
-	put_tty_driver(brd->serial_driver);
+			p = p->next;
+			p->type = BSNODE;
 
-	return rc;
-}
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.bssize)) {
+				pr_err("bad number for bssize");
+				return -1;
+			}
+			break;
 
-static void dgap_tty_unregister(struct board_t *brd)
-{
-	tty_unregister_driver(brd->print_driver);
-	tty_unregister_driver(brd->serial_driver);
-	put_tty_driver(brd->print_driver);
-	put_tty_driver(brd->serial_driver);
-}
+		case UNTSIZ:	/* sched structure size */
+			if (dgap_checknode(p))
+				return -1;
 
-/*
- * dgap_tty_init()
- *
- * Init the tty subsystem.  Called once per board after board has been
- * downloaded and init'ed.
- */
-static int dgap_tty_init(struct board_t *brd)
-{
-	int i;
-	int tlw;
-	uint true_count;
-	u8 __iomem *vaddr;
-	u8 modem;
-	struct channel_t *ch;
-	struct bs_t __iomem *bs;
-	struct cm_t __iomem *cm;
-	int ret;
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	/*
-	 * Initialize board structure elements.
-	 */
+			p = p->next;
+			p->type = USNODE;
 
-	vaddr = brd->re_map_membase;
-	true_count = readw((vaddr + NCHAN));
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.unsize)) {
+				pr_err("bad number for schedsize");
+				return -1;
+			}
+			break;
 
-	brd->nasync = dgap_config_get_num_prts(brd);
+		case F2SIZ:	/* f2200 structure size */
+			if (dgap_checknode(p))
+				return -1;
 
-	if (!brd->nasync)
-		brd->nasync = brd->maxports;
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-	if (brd->nasync > brd->maxports)
-		brd->nasync = brd->maxports;
+			p = p->next;
+			p->type = FSNODE;
 
-	if (true_count != brd->nasync) {
-		dev_warn(&brd->pdev->dev,
-			 "%s configured for %d ports, has %d ports.\n",
-			 brd->name, brd->nasync, true_count);
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.f2size)) {
+				pr_err("bad number for f2200size");
+				return -1;
+			}
+			break;
 
-		if ((brd->type == PPCM) &&
-		    (true_count == 64 || true_count == 0)) {
-			dev_warn(&brd->pdev->dev,
-				 "Please make SURE the EBI cable running from the card\n");
-			dev_warn(&brd->pdev->dev,
-				 "to each EM module is plugged into EBI IN!\n");
-		}
+		case VPSIZ:	/* vpix structure size */
+			if (dgap_checknode(p))
+				return -1;
 
-		brd->nasync = true_count;
+			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
+			if (!p->next)
+				return -1;
 
-		/* If no ports, don't bother going any further */
-		if (!brd->nasync) {
-			brd->state = BOARD_FAILED;
-			brd->dpastatus = BD_NOFEP;
-			return -EIO;
-		}
-	}
+			p = p->next;
+			p->type = VSNODE;
 
-	/*
-	 * Allocate channel memory that might not have been allocated
-	 * when the driver was first loaded.
-	 */
-	for (i = 0; i < brd->nasync; i++) {
-		brd->channels[i] =
-			kzalloc(sizeof(struct channel_t), GFP_KERNEL);
-		if (!brd->channels[i]) {
-			ret = -ENOMEM;
-			goto free_chan;
+			s = dgap_getword(in);
+			if (!s) {
+				pr_err("unexpected end of file");
+				return -1;
+			}
+			if (kstrtol(s, 0, &p->u.vpixsize)) {
+				pr_err("bad number for vpixsize");
+				return -1;
+			}
+			break;
 		}
 	}
+}
 
-	ch = brd->channels[0];
-	vaddr = brd->re_map_membase;
+static void dgap_cleanup_nodes(void)
+{
+	struct cnode *p;
 
-	bs = (struct bs_t __iomem *) ((ulong) vaddr + CHANBUF);
-	cm = (struct cm_t __iomem *) ((ulong) vaddr + CMDBUF);
+	p = &dgap_head;
 
-	brd->bd_bs = bs;
+	while (p) {
+		struct cnode *tmp = p->next;
 
-	/* Set up channel variables */
-	for (i = 0; i < brd->nasync; i++, ch = brd->channels[i], bs++) {
+		if (p->type == NULLNODE) {
+			p = tmp;
+			continue;
+		}
 
-		spin_lock_init(&ch->ch_lock);
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
 
-		/* Store all our magic numbers */
-		ch->magic = DGAP_CHANNEL_MAGIC;
-		ch->ch_tun.magic = DGAP_UNIT_MAGIC;
-		ch->ch_tun.un_type = DGAP_SERIAL;
-		ch->ch_tun.un_ch = ch;
-		ch->ch_tun.un_dev = i;
+		kfree(p->u.board.status);
+		kfree(p);
+		p = tmp;
+	}
+}
 
-		ch->ch_pun.magic = DGAP_UNIT_MAGIC;
-		ch->ch_pun.un_type = DGAP_PRINT;
-		ch->ch_pun.un_ch = ch;
-		ch->ch_pun.un_dev = i;
+/*
+ * Retrives the current custom baud rate from FEP memory,
+ * and returns it back to the user.
+ * Returns 0 on error.
+ */
+static uint dgap_get_custom_baud(struct channel_t *ch)
+{
+	u8 __iomem *vaddr;
+	ulong offset;
+	uint value;
 
-		ch->ch_vaddr = vaddr;
-		ch->ch_bs = bs;
-		ch->ch_cm = cm;
-		ch->ch_bd = brd;
-		ch->ch_portnum = i;
-		ch->ch_digi = dgap_digi_init;
+	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
+		return 0;
 
-		/*
-		 * Set up digi dsr and dcd bits based on altpin flag.
-		 */
-		if (dgap_config_get_altpin(brd)) {
-			ch->ch_dsr	= DM_CD;
-			ch->ch_cd	= DM_DSR;
-			ch->ch_digi.digi_flags |= DIGI_ALTPIN;
-		} else {
-			ch->ch_cd	= DM_CD;
-			ch->ch_dsr	= DM_DSR;
-		}
+	if (!ch->ch_bd || ch->ch_bd->magic != DGAP_BOARD_MAGIC)
+		return 0;
 
-		ch->ch_taddr = vaddr + (ioread16(&(ch->ch_bs->tx_seg)) << 4);
-		ch->ch_raddr = vaddr + (ioread16(&(ch->ch_bs->rx_seg)) << 4);
-		ch->ch_tx_win = 0;
-		ch->ch_rx_win = 0;
-		ch->ch_tsize = readw(&(ch->ch_bs->tx_max)) + 1;
-		ch->ch_rsize = readw(&(ch->ch_bs->rx_max)) + 1;
-		ch->ch_tstart = 0;
-		ch->ch_rstart = 0;
+	if (!(ch->ch_bd->bd_flags & BD_FEP5PLUS))
+		return 0;
 
-		/*
-		 * Set queue water marks, interrupt mask,
-		 * and general tty parameters.
-		 */
-		tlw = ch->ch_tsize >= 2000 ? ((ch->ch_tsize * 5) / 8) :
-						ch->ch_tsize / 2;
-		ch->ch_tlw = tlw;
+	vaddr = ch->ch_bd->re_map_membase;
 
-		dgap_cmdw(ch, STLOW, tlw, 0);
+	if (!vaddr)
+		return 0;
 
-		dgap_cmdw(ch, SRLOW, ch->ch_rsize / 2, 0);
+	/*
+	 * Go get from fep mem, what the fep
+	 * believes the custom baud rate is.
+	 */
+	offset = (ioread16(vaddr + ECS_SEG) << 4) + (ch->ch_portnum * 0x28)
+	       + LINE_SPEED;
 
-		dgap_cmdw(ch, SRHIGH, 7 * ch->ch_rsize / 8, 0);
+	value = readw(vaddr + offset);
+	return value;
+}
 
-		ch->ch_mistat = readb(&(ch->ch_bs->m_stat));
+/*
+ * Remap PCI memory.
+ */
+static int dgap_remap(struct board_t *brd)
+{
+	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
+		return -EIO;
 
-		init_waitqueue_head(&ch->ch_flags_wait);
-		init_waitqueue_head(&ch->ch_tun.un_flags_wait);
-		init_waitqueue_head(&ch->ch_pun.un_flags_wait);
+	if (!request_mem_region(brd->membase, 0x200000, "dgap"))
+		return -ENOMEM;
 
-		/* Turn on all modem interrupts for now */
-		modem = (DM_CD | DM_DSR | DM_CTS | DM_RI);
-		writeb(modem, &(ch->ch_bs->m_int));
+	if (!request_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000,
+					"dgap")) {
+		release_mem_region(brd->membase, 0x200000);
+		return -ENOMEM;
+	}
 
-		/*
-		 * Set edelay to 0 if interrupts are turned on,
-		 * otherwise set edelay to the usual 100.
-		 */
-		if (brd->intr_used)
-			writew(0, &(ch->ch_bs->edelay));
-		else
-			writew(100, &(ch->ch_bs->edelay));
+	brd->re_map_membase = ioremap(brd->membase, 0x200000);
+	if (!brd->re_map_membase) {
+		release_mem_region(brd->membase, 0x200000);
+		release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
+		return -ENOMEM;
+	}
 
-		writeb(1, &(ch->ch_bs->idata));
+	brd->re_map_port = ioremap((brd->membase + PCI_IO_OFFSET), 0x200000);
+	if (!brd->re_map_port) {
+		release_mem_region(brd->membase, 0x200000);
+		release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
+		iounmap(brd->re_map_membase);
+		return -ENOMEM;
 	}
 
 	return 0;
-
-free_chan:
-	while (--i >= 0) {
-		kfree(brd->channels[i]);
-		brd->channels[i] = NULL;
-	}
-	return ret;
 }
 
-/*
- * dgap_tty_free()
- *
- * Free the channles which are allocated in dgap_tty_init().
- */
-static void dgap_tty_free(struct board_t *brd)
+static void dgap_unmap(struct board_t *brd)
 {
-	int i;
-
-	for (i = 0; i < brd->nasync; i++)
-		kfree(brd->channels[i]);
+	iounmap(brd->re_map_port);
+	iounmap(brd->re_map_membase);
+	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
+	release_mem_region(brd->membase, 0x200000);
 }
+
 /*
- * dgap_cleanup_tty()
+ * dgap_parity_scan()
  *
- * Uninitialize the TTY portion of this driver.  Free all memory and
- * resources.
+ * Convert the FEP5 way of reporting parity errors and breaks into
+ * the Linux line discipline way.
  */
-static void dgap_cleanup_tty(struct board_t *brd)
+static void dgap_parity_scan(struct channel_t *ch, unsigned char *cbuf,
+				unsigned char *fbuf, int *len)
 {
-	struct device *dev;
-	int i;
+	int l = *len;
+	int count = 0;
+	unsigned char *in, *cout, *fout;
+	unsigned char c;
 
-	dgap_boards_by_major[brd->serial_driver->major] = NULL;
-	brd->dgap_serial_major = 0;
-	for (i = 0; i < brd->nasync; i++) {
-		tty_port_destroy(&brd->serial_ports[i]);
-		dev = brd->channels[i]->ch_tun.un_sysfs;
-		dgap_remove_tty_sysfs(dev);
-		tty_unregister_device(brd->serial_driver, i);
-	}
-	tty_unregister_driver(brd->serial_driver);
-	put_tty_driver(brd->serial_driver);
-	kfree(brd->serial_ports);
+	in = cbuf;
+	cout = cbuf;
+	fout = fbuf;
 
-	dgap_boards_by_major[brd->print_driver->major] = NULL;
-	brd->dgap_transparent_print_major = 0;
-	for (i = 0; i < brd->nasync; i++) {
-		tty_port_destroy(&brd->printer_ports[i]);
-		dev = brd->channels[i]->ch_pun.un_sysfs;
-		dgap_remove_tty_sysfs(dev);
-		tty_unregister_device(brd->print_driver, i);
+	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
+		return;
+
+	while (l--) {
+		c = *in++;
+		switch (ch->pscan_state) {
+		default:
+			/* reset to sanity and fall through */
+			ch->pscan_state = 0;
+
+		case 0:
+			/* No FF seen yet */
+			if (c == (unsigned char) '\377')
+				/* delete this character from stream */
+				ch->pscan_state = 1;
+			else {
+				*cout++ = c;
+				*fout++ = TTY_NORMAL;
+				count += 1;
+			}
+			break;
+
+		case 1:
+			/* first FF seen */
+			if (c == (unsigned char) '\377') {
+				/* doubled ff, transform to single ff */
+				*cout++ = c;
+				*fout++ = TTY_NORMAL;
+				count += 1;
+				ch->pscan_state = 0;
+			} else {
+				/* save value examination in next state */
+				ch->pscan_savechar = c;
+				ch->pscan_state = 2;
+			}
+			break;
+
+		case 2:
+			/* third character of ff sequence */
+
+			*cout++ = c;
+
+			if (ch->pscan_savechar == 0x0) {
+
+				if (c == 0x0) {
+					ch->ch_err_break++;
+					*fout++ = TTY_BREAK;
+				} else {
+					ch->ch_err_parity++;
+					*fout++ = TTY_PARITY;
+				}
+			}
+
+			count += 1;
+			ch->pscan_state = 0;
+		}
 	}
-	tty_unregister_driver(brd->print_driver);
-	put_tty_driver(brd->print_driver);
-	kfree(brd->printer_ports);
+	*len = count;
 }
 
 /*=======================================================================
@@ -1750,6 +1718,33 @@ static void dgap_input(struct channel_t *ch)
 
 }
 
+static void dgap_write_wakeup(struct board_t *bd, struct channel_t *ch,
+			      struct un_t *un, u32 mask,
+			      unsigned long *irq_flags1,
+			      unsigned long *irq_flags2)
+{
+	if (!(un->un_flags & mask))
+		return;
+
+	un->un_flags &= ~mask;
+
+	if (!(un->un_flags & UN_ISOPEN))
+		return;
+
+	if ((un->un_tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
+	    un->un_tty->ldisc->ops->write_wakeup) {
+		spin_unlock_irqrestore(&ch->ch_lock, *irq_flags2);
+		spin_unlock_irqrestore(&bd->bd_lock, *irq_flags1);
+
+		(un->un_tty->ldisc->ops->write_wakeup)(un->un_tty);
+
+		spin_lock_irqsave(&bd->bd_lock, *irq_flags1);
+		spin_lock_irqsave(&ch->ch_lock, *irq_flags2);
+	}
+	wake_up_interruptible(&un->un_tty->write_wait);
+	wake_up_interruptible(&un->un_flags_wait);
+}
+
 /************************************************************************
  * Determines when CARRIER changes state and takes appropriate
  * action.
@@ -1864,163 +1859,1207 @@ static void dgap_carrier(struct channel_t *ch)
 		ch->ch_flags &= ~CH_CD;
 }
 
-/************************************************************************
+/*=======================================================================
  *
- * TTY Entry points and helper functions
+ *      dgap_event - FEP to host event processing routine.
  *
- ************************************************************************/
-
-/*
- * dgap_tty_open()
+ *              bd     - Board of current event.
  *
- */
-static int dgap_tty_open(struct tty_struct *tty, struct file *file)
+ *=======================================================================*/
+static int dgap_event(struct board_t *bd)
 {
-	struct board_t *brd;
 	struct channel_t *ch;
-	struct un_t *un;
-	struct bs_t __iomem *bs;
-	uint major;
-	uint minor;
-	int rc;
 	ulong lock_flags;
 	ulong lock_flags2;
-	u16 head;
+	struct bs_t __iomem *bs;
+	u8 __iomem *event;
+	u8 __iomem *vaddr;
+	struct ev_t __iomem *eaddr;
+	uint head;
+	uint tail;
+	int port;
+	int reason;
+	int modem;
+	int b1;
 
-	major = MAJOR(tty_devnum(tty));
-	minor = MINOR(tty_devnum(tty));
+	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
+		return -EIO;
 
-	if (major > 255)
+	spin_lock_irqsave(&bd->bd_lock, lock_flags);
+
+	vaddr = bd->re_map_membase;
+
+	if (!vaddr) {
+		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
 		return -EIO;
+	}
 
-	/* Get board pointer from our array of majors we have allocated */
-	brd = dgap_boards_by_major[major];
-	if (!brd)
+	eaddr = (struct ev_t __iomem *) (vaddr + EVBUF);
+
+	/* Get our head and tail */
+	head = readw(&(eaddr->ev_head));
+	tail = readw(&(eaddr->ev_tail));
+
+	/*
+	 * Forget it if pointers out of range.
+	 */
+
+	if (head >= EVMAX - EVSTART || tail >= EVMAX - EVSTART ||
+	    (head | tail) & 03) {
+		/* Let go of board lock */
+		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
 		return -EIO;
+	}
 
 	/*
-	 * If board is not yet up to a state of READY, go to
-	 * sleep waiting for it to happen or they cancel the open.
+	 * Loop to process all the events in the buffer.
 	 */
-	rc = wait_event_interruptible(brd->state_wait,
-		(brd->state & BOARD_READY));
+	while (tail != head) {
 
-	if (rc)
-		return rc;
+		/*
+		 * Get interrupt information.
+		 */
 
-	spin_lock_irqsave(&brd->bd_lock, lock_flags);
+		event = bd->re_map_membase + tail + EVSTART;
 
-	/* The wait above should guarantee this cannot happen */
-	if (brd->state != BOARD_READY) {
-		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
-		return -EIO;
+		port   = ioread8(event);
+		reason = ioread8(event + 1);
+		modem  = ioread8(event + 2);
+		b1     = ioread8(event + 3);
+
+		/*
+		 * Make sure the interrupt is valid.
+		 */
+		if (port >= bd->nasync)
+			goto next;
+
+		if (!(reason & (IFMODEM | IFBREAK | IFTLW | IFTEM | IFDATA)))
+			goto next;
+
+		ch = bd->channels[port];
+
+		if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
+			goto next;
+
+		/*
+		 * If we have made it here, the event was valid.
+		 * Lock down the channel.
+		 */
+		spin_lock_irqsave(&ch->ch_lock, lock_flags2);
+
+		bs = ch->ch_bs;
+
+		if (!bs) {
+			spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
+			goto next;
+		}
+
+		/*
+		 * Process received data.
+		 */
+		if (reason & IFDATA) {
+
+			/*
+			 * ALL LOCKS *MUST* BE DROPPED BEFORE CALLING INPUT!
+			 * input could send some data to ld, which in turn
+			 * could do a callback to one of our other functions.
+			 */
+			spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
+			spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+
+			dgap_input(ch);
+
+			spin_lock_irqsave(&bd->bd_lock, lock_flags);
+			spin_lock_irqsave(&ch->ch_lock, lock_flags2);
+
+			if (ch->ch_flags & CH_RACTIVE)
+				ch->ch_flags |= CH_RENABLE;
+			else
+				writeb(1, &(bs->idata));
+
+			if (ch->ch_flags & CH_RWAIT) {
+				ch->ch_flags &= ~CH_RWAIT;
+
+				wake_up_interruptible
+					(&ch->ch_tun.un_flags_wait);
+			}
+		}
+
+		/*
+		 * Process Modem change signals.
+		 */
+		if (reason & IFMODEM) {
+			ch->ch_mistat = modem;
+			dgap_carrier(ch);
+		}
+
+		/*
+		 * Process break.
+		 */
+		if (reason & IFBREAK) {
+
+			if (ch->ch_tun.un_tty) {
+				/* A break has been indicated */
+				ch->ch_err_break++;
+				tty_buffer_request_room
+					(ch->ch_tun.un_tty->port, 1);
+				tty_insert_flip_char(ch->ch_tun.un_tty->port,
+						     0, TTY_BREAK);
+				tty_flip_buffer_push(ch->ch_tun.un_tty->port);
+			}
+		}
+
+		/*
+		 * Process Transmit low.
+		 */
+		if (reason & IFTLW) {
+			dgap_write_wakeup(bd, ch, &ch->ch_tun, UN_LOW,
+					  &lock_flags, &lock_flags2);
+			dgap_write_wakeup(bd, ch, &ch->ch_pun, UN_LOW,
+					  &lock_flags, &lock_flags2);
+			if (ch->ch_flags & CH_WLOW) {
+				ch->ch_flags &= ~CH_WLOW;
+				wake_up_interruptible(&ch->ch_flags_wait);
+			}
+		}
+
+		/*
+		 * Process Transmit empty.
+		 */
+		if (reason & IFTEM) {
+			dgap_write_wakeup(bd, ch, &ch->ch_tun, UN_EMPTY,
+					  &lock_flags, &lock_flags2);
+			dgap_write_wakeup(bd, ch, &ch->ch_pun, UN_EMPTY,
+					  &lock_flags, &lock_flags2);
+			if (ch->ch_flags & CH_WEMPTY) {
+				ch->ch_flags &= ~CH_WEMPTY;
+				wake_up_interruptible(&ch->ch_flags_wait);
+			}
+		}
+
+		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
+
+next:
+		tail = (tail + 4) & (EVMAX - EVSTART - 4);
 	}
 
-	/* If opened device is greater than our number of ports, bail. */
-	if (MINOR(tty_devnum(tty)) > brd->nasync) {
-		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
-		return -EIO;
+	writew(tail, &(eaddr->ev_tail));
+	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+
+	return 0;
+}
+
+/*
+ * Our board poller function.
+ */
+static void dgap_poll_tasklet(unsigned long data)
+{
+	struct board_t *bd = (struct board_t *) data;
+	ulong lock_flags;
+	char __iomem *vaddr;
+	u16 head, tail;
+
+	if (!bd || (bd->magic != DGAP_BOARD_MAGIC))
+		return;
+
+	if (bd->inhibit_poller)
+		return;
+
+	spin_lock_irqsave(&bd->bd_lock, lock_flags);
+
+	vaddr = bd->re_map_membase;
+
+	/*
+	 * If board is ready, parse deeper to see if there is anything to do.
+	 */
+	if (bd->state == BOARD_READY) {
+
+		struct ev_t __iomem *eaddr;
+
+		if (!bd->re_map_membase) {
+			spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+			return;
+		}
+		if (!bd->re_map_port) {
+			spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+			return;
+		}
+
+		if (!bd->nasync)
+			goto out;
+
+		eaddr = (struct ev_t __iomem *) (vaddr + EVBUF);
+
+		/* Get our head and tail */
+		head = readw(&(eaddr->ev_head));
+		tail = readw(&(eaddr->ev_tail));
+
+		/*
+		 * If there is an event pending. Go service it.
+		 */
+		if (head != tail) {
+			spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+			dgap_event(bd);
+			spin_lock_irqsave(&bd->bd_lock, lock_flags);
+		}
+
+out:
+		/*
+		 * If board is doing interrupts, ACK the interrupt.
+		 */
+		if (bd && bd->intr_running)
+			readb(bd->re_map_port + 2);
+
+		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+		return;
 	}
 
-	ch = brd->channels[minor];
-	if (!ch) {
-		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
-		return -EIO;
+	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+}
+
+/*
+ * dgap_found_board()
+ *
+ * A board has been found, init it.
+ */
+static struct board_t *dgap_found_board(struct pci_dev *pdev, int id,
+					int boardnum)
+{
+	struct board_t *brd;
+	unsigned int pci_irq;
+	int i;
+	int ret;
+
+	/* get the board structure and prep it */
+	brd = kzalloc(sizeof(struct board_t), GFP_KERNEL);
+	if (!brd)
+		return ERR_PTR(-ENOMEM);
+
+	/* store the info for the board we've found */
+	brd->magic = DGAP_BOARD_MAGIC;
+	brd->boardnum = boardnum;
+	brd->vendor = dgap_pci_tbl[id].vendor;
+	brd->device = dgap_pci_tbl[id].device;
+	brd->pdev = pdev;
+	brd->pci_bus = pdev->bus->number;
+	brd->pci_slot = PCI_SLOT(pdev->devfn);
+	brd->name = dgap_ids[id].name;
+	brd->maxports = dgap_ids[id].maxports;
+	brd->type = dgap_ids[id].config_type;
+	brd->dpatype = dgap_ids[id].dpatype;
+	brd->dpastatus = BD_NOFEP;
+	init_waitqueue_head(&brd->state_wait);
+
+	spin_lock_init(&brd->bd_lock);
+
+	brd->inhibit_poller	= FALSE;
+	brd->wait_for_bios	= 0;
+	brd->wait_for_fep	= 0;
+
+	for (i = 0; i < MAXPORTS; i++)
+		brd->channels[i] = NULL;
+
+	/* store which card & revision we have */
+	pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &brd->subvendor);
+	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &brd->subdevice);
+	pci_read_config_byte(pdev, PCI_REVISION_ID, &brd->rev);
+
+	pci_irq = pdev->irq;
+	brd->irq = pci_irq;
+
+	/* get the PCI Base Address Registers */
+
+	/* Xr Jupiter and EPC use BAR 2 */
+	if (brd->device == PCI_DEV_XRJ_DID || brd->device == PCI_DEV_EPCJ_DID) {
+		brd->membase     = pci_resource_start(pdev, 2);
+		brd->membase_end = pci_resource_end(pdev, 2);
+	}
+	/* Everyone else uses BAR 0 */
+	else {
+		brd->membase     = pci_resource_start(pdev, 0);
+		brd->membase_end = pci_resource_end(pdev, 0);
 	}
 
-	/* Grab channel lock */
-	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
+	if (!brd->membase) {
+		ret = -ENODEV;
+		goto free_brd;
+	}
 
-	/* Figure out our type */
-	if (major == brd->dgap_serial_major) {
-		un = &brd->channels[minor]->ch_tun;
-		un->un_type = DGAP_SERIAL;
-	} else if (major == brd->dgap_transparent_print_major) {
-		un = &brd->channels[minor]->ch_pun;
-		un->un_type = DGAP_PRINT;
+	if (brd->membase & 1)
+		brd->membase &= ~3;
+	else
+		brd->membase &= ~15;
+
+	/*
+	 * On the PCI boards, there is no IO space allocated
+	 * The I/O registers will be in the first 3 bytes of the
+	 * upper 2MB of the 4MB memory space.  The board memory
+	 * will be mapped into the low 2MB of the 4MB memory space
+	 */
+	brd->port = brd->membase + PCI_IO_OFFSET;
+	brd->port_end = brd->port + PCI_IO_SIZE;
+
+	/*
+	 * Special initialization for non-PLX boards
+	 */
+	if (brd->device != PCI_DEV_XRJ_DID && brd->device != PCI_DEV_EPCJ_DID) {
+		unsigned short cmd;
+
+		pci_write_config_byte(pdev, 0x40, 0);
+		pci_write_config_byte(pdev, 0x46, 0);
+
+		/* Limit burst length to 2 doubleword transactions */
+		pci_write_config_byte(pdev, 0x42, 1);
+
+		/*
+		 * Enable IO and mem if not already done.
+		 * This was needed for support on Itanium.
+		 */
+		pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+		cmd |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
+		pci_write_config_word(pdev, PCI_COMMAND, cmd);
+	}
+
+	/* init our poll helper tasklet */
+	tasklet_init(&brd->helper_tasklet, dgap_poll_tasklet,
+			(unsigned long) brd);
+
+	ret = dgap_remap(brd);
+	if (ret)
+		goto free_brd;
+
+	pr_info("dgap: board %d: %s (rev %d), irq %ld\n",
+		boardnum, brd->name, brd->rev, brd->irq);
+
+	return brd;
+
+free_brd:
+	kfree(brd);
+
+	return ERR_PTR(ret);
+}
+
+/*
+ * dgap_intr()
+ *
+ * Driver interrupt handler.
+ */
+static irqreturn_t dgap_intr(int irq, void *voidbrd)
+{
+	struct board_t *brd = (struct board_t *) voidbrd;
+
+	if (!brd)
+		return IRQ_NONE;
+
+	/*
+	 * Check to make sure its for us.
+	 */
+	if (brd->magic != DGAP_BOARD_MAGIC)
+		return IRQ_NONE;
+
+	brd->intr_count++;
+
+	/*
+	 * Schedule tasklet to run at a better time.
+	 */
+	tasklet_schedule(&brd->helper_tasklet);
+	return IRQ_HANDLED;
+}
+
+/*****************************************************************************
+*
+* Function:
+*
+*    dgap_poll_handler
+*
+* Author:
+*
+*    Scott H Kilau
+*
+* Parameters:
+*
+*    dummy -- ignored
+*
+* Return Values:
+*
+*    none
+*
+* Description:
+*
+*    As each timer expires, it determines (a) whether the "transmit"
+*    waiter needs to be woken up, and (b) whether the poller needs to
+*    be rescheduled.
+*
+******************************************************************************/
+
+static void dgap_poll_handler(ulong dummy)
+{
+	int i;
+	struct board_t *brd;
+	unsigned long lock_flags;
+	ulong new_time;
+
+	dgap_poll_counter++;
+
+	/*
+	 * Do not start the board state machine until
+	 * driver tells us its up and running, and has
+	 * everything it needs.
+	 */
+	if (dgap_driver_state != DRIVER_READY)
+		goto schedule_poller;
+
+	/*
+	 * If we have just 1 board, or the system is not SMP,
+	 * then use the typical old style poller.
+	 * Otherwise, use our new tasklet based poller, which should
+	 * speed things up for multiple boards.
+	 */
+	if ((dgap_numboards == 1) || (num_online_cpus() <= 1)) {
+		for (i = 0; i < dgap_numboards; i++) {
+
+			brd = dgap_board[i];
+
+			if (brd->state == BOARD_FAILED)
+				continue;
+			if (!brd->intr_running)
+				/* Call the real board poller directly */
+				dgap_poll_tasklet((unsigned long) brd);
+		}
 	} else {
-		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
-		return -EIO;
+		/*
+		 * Go thru each board, kicking off a
+		 * tasklet for each if needed
+		 */
+		for (i = 0; i < dgap_numboards; i++) {
+			brd = dgap_board[i];
+
+			/*
+			 * Attempt to grab the board lock.
+			 *
+			 * If we can't get it, no big deal, the next poll
+			 * will get it. Basically, I just really don't want
+			 * to spin in here, because I want to kick off my
+			 * tasklets as fast as I can, and then get out the
+			 * poller.
+			 */
+			if (!spin_trylock(&brd->bd_lock))
+				continue;
+
+			/*
+			 * If board is in a failed state, don't bother
+			 *  scheduling a tasklet
+			 */
+			if (brd->state == BOARD_FAILED) {
+				spin_unlock(&brd->bd_lock);
+				continue;
+			}
+
+			/* Schedule a poll helper task */
+			if (!brd->intr_running)
+				tasklet_schedule(&brd->helper_tasklet);
+
+			/*
+			 * Can't do DGAP_UNLOCK here, as we don't have
+			 * lock_flags because we did a trylock above.
+			 */
+			spin_unlock(&brd->bd_lock);
+		}
 	}
 
-	/* Store our unit into driver_data, so we always have it available. */
-	tty->driver_data = un;
+schedule_poller:
 
 	/*
-	 * Error if channel info pointer is NULL.
+	 * Schedule ourself back at the nominal wakeup interval.
 	 */
-	bs = ch->ch_bs;
-	if (!bs) {
-		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
-		return -EIO;
+	spin_lock_irqsave(&dgap_poll_lock, lock_flags);
+	dgap_poll_time +=  dgap_jiffies_from_ms(dgap_poll_tick);
+
+	new_time = dgap_poll_time - jiffies;
+
+	if ((ulong) new_time >= 2 * dgap_poll_tick) {
+		dgap_poll_time =
+			jiffies +  dgap_jiffies_from_ms(dgap_poll_tick);
 	}
 
+	dgap_poll_timer.function = dgap_poll_handler;
+	dgap_poll_timer.data = 0;
+	dgap_poll_timer.expires = dgap_poll_time;
+	spin_unlock_irqrestore(&dgap_poll_lock, lock_flags);
+
+	if (!dgap_poll_stop)
+		add_timer(&dgap_poll_timer);
+}
+
+/*=======================================================================
+ *
+ *      dgap_cmdb - Sends a 2 byte command to the FEP.
+ *
+ *              ch      - Pointer to channel structure.
+ *              cmd     - Command to be sent.
+ *              byte1   - Integer containing first byte to be sent.
+ *              byte2   - Integer containing second byte to be sent.
+ *              ncmds   - Wait until ncmds or fewer cmds are left
+ *                        in the cmd buffer before returning.
+ *
+ *=======================================================================*/
+static void dgap_cmdb(struct channel_t *ch, u8 cmd, u8 byte1,
+			u8 byte2, uint ncmds)
+{
+	char __iomem *vaddr;
+	struct __iomem cm_t *cm_addr;
+	uint count;
+	uint n;
+	u16 head;
+	u16 tail;
+
+	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
+		return;
+
 	/*
-	 * Initialize tty's
+	 * Check if board is still alive.
 	 */
-	if (!(un->un_flags & UN_ISOPEN)) {
-		/* Store important variables. */
-		un->un_tty     = tty;
+	if (ch->ch_bd->state == BOARD_FAILED)
+		return;
 
-		/* Maybe do something here to the TTY struct as well? */
+	/*
+	 * Make sure the pointers are in range before
+	 * writing to the FEP memory.
+	 */
+	vaddr = ch->ch_bd->re_map_membase;
+
+	if (!vaddr)
+		return;
+
+	cm_addr = (struct cm_t __iomem *) (vaddr + CMDBUF);
+	head = readw(&(cm_addr->cm_head));
+
+	/*
+	 * Forget it if pointers out of range.
+	 */
+	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
+		ch->ch_bd->state = BOARD_FAILED;
+		return;
 	}
 
 	/*
-	 * Initialize if neither terminal or printer is open.
+	 * Put the data in the circular command buffer.
 	 */
-	if (!((ch->ch_tun.un_flags | ch->ch_pun.un_flags) & UN_ISOPEN)) {
+	writeb(cmd, (vaddr + head + CMDSTART + 0));
+	writeb((u8) ch->ch_portnum, (vaddr + head + CMDSTART + 1));
+	writeb(byte1, (vaddr + head + CMDSTART + 2));
+	writeb(byte2, (vaddr + head + CMDSTART + 3));
 
-		ch->ch_mforce = 0;
-		ch->ch_mval = 0;
+	head = (head + 4) & (CMDMAX - CMDSTART - 4);
+
+	writew(head, &(cm_addr->cm_head));
+
+	/*
+	 * Wait if necessary before updating the head
+	 * pointer to limit the number of outstanding
+	 * commands to the FEP.   If the time spent waiting
+	 * is outlandish, declare the FEP dead.
+	 */
+	for (count = dgap_count ;;) {
+
+		head = readw(&(cm_addr->cm_head));
+		tail = readw(&(cm_addr->cm_tail));
+
+		n = (head - tail) & (CMDMAX - CMDSTART - 4);
+
+		if (n <= ncmds * sizeof(struct cm_t))
+			break;
+
+		if (--count == 0) {
+			ch->ch_bd->state = BOARD_FAILED;
+			return;
+		}
+		udelay(10);
+	}
+}
+
+/*=======================================================================
+ *
+ *      dgap_cmdw - Sends a 1 word command to the FEP.
+ *
+ *              ch      - Pointer to channel structure.
+ *              cmd     - Command to be sent.
+ *              word    - Integer containing word to be sent.
+ *              ncmds   - Wait until ncmds or fewer cmds are left
+ *                        in the cmd buffer before returning.
+ *
+ *=======================================================================*/
+static void dgap_cmdw(struct channel_t *ch, u8 cmd, u16 word, uint ncmds)
+{
+	char __iomem *vaddr;
+	struct __iomem cm_t *cm_addr;
+	uint count;
+	uint n;
+	u16 head;
+	u16 tail;
+
+	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
+		return;
+
+	/*
+	 * Check if board is still alive.
+	 */
+	if (ch->ch_bd->state == BOARD_FAILED)
+		return;
+
+	/*
+	 * Make sure the pointers are in range before
+	 * writing to the FEP memory.
+	 */
+	vaddr = ch->ch_bd->re_map_membase;
+	if (!vaddr)
+		return;
+
+	cm_addr = (struct cm_t __iomem *) (vaddr + CMDBUF);
+	head = readw(&(cm_addr->cm_head));
+
+	/*
+	 * Forget it if pointers out of range.
+	 */
+	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
+		ch->ch_bd->state = BOARD_FAILED;
+		return;
+	}
 
+	/*
+	 * Put the data in the circular command buffer.
+	 */
+	writeb(cmd, (vaddr + head + CMDSTART + 0));
+	writeb((u8) ch->ch_portnum, (vaddr + head + CMDSTART + 1));
+	writew((u16) word, (vaddr + head + CMDSTART + 2));
+
+	head = (head + 4) & (CMDMAX - CMDSTART - 4);
+
+	writew(head, &(cm_addr->cm_head));
+
+	/*
+	 * Wait if necessary before updating the head
+	 * pointer to limit the number of outstanding
+	 * commands to the FEP.   If the time spent waiting
+	 * is outlandish, declare the FEP dead.
+	 */
+	for (count = dgap_count ;;) {
+
+		head = readw(&(cm_addr->cm_head));
+		tail = readw(&(cm_addr->cm_tail));
+
+		n = (head - tail) & (CMDMAX - CMDSTART - 4);
+
+		if (n <= ncmds * sizeof(struct cm_t))
+			break;
+
+		if (--count == 0) {
+			ch->ch_bd->state = BOARD_FAILED;
+			return;
+		}
+		udelay(10);
+	}
+}
+
+/*=======================================================================
+ *
+ *      dgap_cmdw_ext - Sends a extended word command to the FEP.
+ *
+ *              ch      - Pointer to channel structure.
+ *              cmd     - Command to be sent.
+ *              word    - Integer containing word to be sent.
+ *              ncmds   - Wait until ncmds or fewer cmds are left
+ *                        in the cmd buffer before returning.
+ *
+ *=======================================================================*/
+static void dgap_cmdw_ext(struct channel_t *ch, u16 cmd, u16 word, uint ncmds)
+{
+	char __iomem *vaddr;
+	struct __iomem cm_t *cm_addr;
+	uint count;
+	uint n;
+	u16 head;
+	u16 tail;
+
+	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
+		return;
+
+	/*
+	 * Check if board is still alive.
+	 */
+	if (ch->ch_bd->state == BOARD_FAILED)
+		return;
+
+	/*
+	 * Make sure the pointers are in range before
+	 * writing to the FEP memory.
+	 */
+	vaddr = ch->ch_bd->re_map_membase;
+	if (!vaddr)
+		return;
+
+	cm_addr = (struct cm_t __iomem *) (vaddr + CMDBUF);
+	head = readw(&(cm_addr->cm_head));
+
+	/*
+	 * Forget it if pointers out of range.
+	 */
+	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
+		ch->ch_bd->state = BOARD_FAILED;
+		return;
+	}
+
+	/*
+	 * Put the data in the circular command buffer.
+	 */
+
+	/* Write an FF to tell the FEP that we want an extended command */
+	writeb((u8) 0xff, (vaddr + head + CMDSTART + 0));
+
+	writeb((u8) ch->ch_portnum, (vaddr + head + CMDSTART + 1));
+	writew((u16) cmd, (vaddr + head + CMDSTART + 2));
+
+	/*
+	 * If the second part of the command won't fit,
+	 * put it at the beginning of the circular buffer.
+	 */
+	if (((head + 4) >= ((CMDMAX - CMDSTART)) || (head & 03)))
+		writew((u16) word, (vaddr + CMDSTART));
+	else
+		writew((u16) word, (vaddr + head + CMDSTART + 4));
+
+	head = (head + 8) & (CMDMAX - CMDSTART - 4);
+
+	writew(head, &(cm_addr->cm_head));
+
+	/*
+	 * Wait if necessary before updating the head
+	 * pointer to limit the number of outstanding
+	 * commands to the FEP.   If the time spent waiting
+	 * is outlandish, declare the FEP dead.
+	 */
+	for (count = dgap_count ;;) {
+
+		head = readw(&(cm_addr->cm_head));
+		tail = readw(&(cm_addr->cm_tail));
+
+		n = (head - tail) & (CMDMAX - CMDSTART - 4);
+
+		if (n <= ncmds * sizeof(struct cm_t))
+			break;
+
+		if (--count == 0) {
+			ch->ch_bd->state = BOARD_FAILED;
+			return;
+		}
+		udelay(10);
+	}
+}
+
+/*=======================================================================
+ *
+ *      dgap_wmove - Write data to FEP buffer.
+ *
+ *              ch      - Pointer to channel structure.
+ *              buf     - Poiter to characters to be moved.
+ *              cnt     - Number of characters to move.
+ *
+ *=======================================================================*/
+static void dgap_wmove(struct channel_t *ch, char *buf, uint cnt)
+{
+	int n;
+	char __iomem *taddr;
+	struct bs_t __iomem *bs;
+	u16 head;
+
+	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
+		return;
+
+	/*
+	 * Check parameters.
+	 */
+	bs   = ch->ch_bs;
+	head = readw(&(bs->tx_head));
+
+	/*
+	 * If pointers are out of range, just return.
+	 */
+	if ((cnt > ch->ch_tsize) ||
+	    (unsigned)(head - ch->ch_tstart) >= ch->ch_tsize)
+		return;
+
+	/*
+	 * If the write wraps over the top of the circular buffer,
+	 * move the portion up to the wrap point, and reset the
+	 * pointers to the bottom.
+	 */
+	n = ch->ch_tstart + ch->ch_tsize - head;
+
+	if (cnt >= n) {
+		cnt -= n;
+		taddr = ch->ch_taddr + head;
+		memcpy_toio(taddr, buf, n);
+		head = ch->ch_tstart;
+		buf += n;
+	}
+
+	/*
+	 * Move rest of data.
+	 */
+	taddr = ch->ch_taddr + head;
+	n = cnt;
+	memcpy_toio(taddr, buf, n);
+	head += cnt;
+
+	writew(head, &(bs->tx_head));
+}
+
+/*
+ * Calls the firmware to reset this channel.
+ */
+static void dgap_firmware_reset_port(struct channel_t *ch)
+{
+	dgap_cmdb(ch, CHRESET, 0, 0, 0);
+
+	/*
+	 * Now that the channel is reset, we need to make sure
+	 * all the current settings get reapplied to the port
+	 * in the firmware.
+	 *
+	 * So we will set the driver's cache of firmware
+	 * settings all to 0, and then call param.
+	 */
+	ch->ch_fepiflag = 0;
+	ch->ch_fepcflag = 0;
+	ch->ch_fepoflag = 0;
+	ch->ch_fepstartc = 0;
+	ch->ch_fepstopc = 0;
+	ch->ch_fepastartc = 0;
+	ch->ch_fepastopc = 0;
+	ch->ch_mostat = 0;
+	ch->ch_hflow = 0;
+}
+
+/*=======================================================================
+ *
+ *      dgap_param - Set Digi parameters.
+ *
+ *              struct tty_struct *     - TTY for port.
+ *
+ *=======================================================================*/
+static int dgap_param(struct channel_t *ch, struct board_t *bd, u32 un_type)
+{
+	u16 head;
+	u16 cflag;
+	u16 iflag;
+	u8 mval;
+	u8 hflow;
+
+	/*
+	 * If baud rate is zero, flush queues, and set mval to drop DTR.
+	 */
+	if ((ch->ch_c_cflag & (CBAUD)) == 0) {
+
+		/* flush rx */
+		head = readw(&(ch->ch_bs->rx_head));
+		writew(head, &(ch->ch_bs->rx_tail));
+
+		/* flush tx */
+		head = readw(&(ch->ch_bs->tx_head));
+		writew(head, &(ch->ch_bs->tx_tail));
+
+		ch->ch_flags |= (CH_BAUD0);
+
+		/* Drop RTS and DTR */
+		ch->ch_mval &= ~(D_RTS(ch)|D_DTR(ch));
+		mval = D_DTR(ch) | D_RTS(ch);
+		ch->ch_baud_info = 0;
+
+	} else if (ch->ch_custom_speed && (bd->bd_flags & BD_FEP5PLUS)) {
 		/*
-		 * Flush input queue.
+		 * Tell the fep to do the command
 		 */
-		head = readw(&(bs->rx_head));
-		writew(head, &(bs->rx_tail));
 
-		ch->ch_flags = 0;
-		ch->pscan_state = 0;
-		ch->pscan_savechar = 0;
+		dgap_cmdw_ext(ch, 0xff01, ch->ch_custom_speed, 0);
 
-		ch->ch_c_cflag   = tty->termios.c_cflag;
-		ch->ch_c_iflag   = tty->termios.c_iflag;
-		ch->ch_c_oflag   = tty->termios.c_oflag;
-		ch->ch_c_lflag   = tty->termios.c_lflag;
-		ch->ch_startc = tty->termios.c_cc[VSTART];
-		ch->ch_stopc  = tty->termios.c_cc[VSTOP];
+		/*
+		 * Now go get from fep mem, what the fep
+		 * believes the custom baud rate is.
+		 */
+		ch->ch_custom_speed = dgap_get_custom_baud(ch);
+		ch->ch_baud_info = ch->ch_custom_speed;
 
-		/* TODO: flush our TTY struct here? */
+		/* Handle transition from B0 */
+		if (ch->ch_flags & CH_BAUD0) {
+			ch->ch_flags &= ~(CH_BAUD0);
+			ch->ch_mval |= (D_RTS(ch)|D_DTR(ch));
+		}
+		mval = D_DTR(ch) | D_RTS(ch);
+
+	} else {
+		/*
+		 * Set baud rate, character size, and parity.
+		 */
+
+
+		int iindex = 0;
+		int jindex = 0;
+		int baud = 0;
+
+		ulong bauds[4][16] = {
+			{ /* slowbaud */
+				0,	50,	75,	110,
+				134,	150,	200,	300,
+				600,	1200,	1800,	2400,
+				4800,	9600,	19200,	38400 },
+			{ /* slowbaud & CBAUDEX */
+				0,	57600,	115200,	230400,
+				460800,	150,	200,	921600,
+				600,	1200,	1800,	2400,
+				4800,	9600,	19200,	38400 },
+			{ /* fastbaud */
+				0,	57600,	76800,	115200,
+				14400,	57600,	230400,	76800,
+				115200,	230400,	28800,	460800,
+				921600,	9600,	19200,	38400 },
+			{ /* fastbaud & CBAUDEX */
+				0,	57600,	115200,	230400,
+				460800,	150,	200,	921600,
+				600,	1200,	1800,	2400,
+				4800,	9600,	19200,	38400 }
+		};
+
+		/*
+		 * Only use the TXPrint baud rate if the
+		 * terminal unit is NOT open
+		 */
+		if (!(ch->ch_tun.un_flags & UN_ISOPEN) &&
+		    un_type == DGAP_PRINT)
+			baud = C_BAUD(ch->ch_pun.un_tty) & 0xff;
+		else
+			baud = C_BAUD(ch->ch_tun.un_tty) & 0xff;
+
+		if (ch->ch_c_cflag & CBAUDEX)
+			iindex = 1;
+
+		if (ch->ch_digi.digi_flags & DIGI_FAST)
+			iindex += 2;
+
+		jindex = baud;
+
+		if ((iindex >= 0) && (iindex < 4) &&
+		    (jindex >= 0) && (jindex < 16))
+			baud = bauds[iindex][jindex];
+		else
+			baud = 0;
+
+		if (baud == 0)
+			baud = 9600;
+
+		ch->ch_baud_info = baud;
+
+		/*
+		 * CBAUD has bit position 0x1000 set these days to
+		 * indicate Linux baud rate remap.
+		 * We use a different bit assignment for high speed.
+		 * Clear this bit out while grabbing the parts of
+		 * "cflag" we want.
+		 */
+		cflag = ch->ch_c_cflag & ((CBAUD ^ CBAUDEX) | PARODD | PARENB |
+						   CSTOPB | CSIZE);
+
+		/*
+		 * HUPCL bit is used by FEP to indicate fast baud
+		 * table is to be used.
+		 */
+		if ((ch->ch_digi.digi_flags & DIGI_FAST) ||
+		    (ch->ch_c_cflag & CBAUDEX))
+			cflag |= HUPCL;
+
+		if ((ch->ch_c_cflag & CBAUDEX) &&
+		    !(ch->ch_digi.digi_flags & DIGI_FAST)) {
+			/*
+			 * The below code is trying to guarantee that only
+			 * baud rates 115200, 230400, 460800, 921600 are
+			 * remapped. We use exclusive or  because the various
+			 * baud rates share common bit positions and therefore
+			 * can't be tested for easily.
+			 */
+			tcflag_t tcflag = (ch->ch_c_cflag & CBAUD) | CBAUDEX;
+			int baudpart = 0;
+
+			/*
+			 * Map high speed requests to index
+			 * into FEP's baud table
+			 */
+			switch (tcflag) {
+			case B57600:
+				baudpart = 1;
+				break;
+#ifdef B76800
+			case B76800:
+				baudpart = 2;
+				break;
+#endif
+			case B115200:
+				baudpart = 3;
+				break;
+			case B230400:
+				baudpart = 9;
+				break;
+			case B460800:
+				baudpart = 11;
+				break;
+#ifdef B921600
+			case B921600:
+				baudpart = 12;
+				break;
+#endif
+			default:
+				baudpart = 0;
+			}
+
+			if (baudpart)
+				cflag = (cflag & ~(CBAUD | CBAUDEX)) | baudpart;
+		}
+
+		cflag &= 0xffff;
+
+		if (cflag != ch->ch_fepcflag) {
+			ch->ch_fepcflag = (u16) (cflag & 0xffff);
+
+			/*
+			 * Okay to have channel and board
+			 * locks held calling this
+			 */
+			dgap_cmdw(ch, SCFLAG, (u16) cflag, 0);
+		}
+
+		/* Handle transition from B0 */
+		if (ch->ch_flags & CH_BAUD0) {
+			ch->ch_flags &= ~(CH_BAUD0);
+			ch->ch_mval |= (D_RTS(ch)|D_DTR(ch));
+		}
+		mval = D_DTR(ch) | D_RTS(ch);
 	}
 
-	dgap_carrier(ch);
 	/*
-	 * Run param in case we changed anything
+	 * Get input flags.
 	 */
-	dgap_param(ch, brd, un->un_type);
+	iflag = ch->ch_c_iflag & (IGNBRK | BRKINT | IGNPAR | PARMRK |
+				  INPCK | ISTRIP | IXON | IXANY | IXOFF);
+
+	if ((ch->ch_startc == _POSIX_VDISABLE) ||
+	    (ch->ch_stopc == _POSIX_VDISABLE)) {
+		iflag &= ~(IXON | IXOFF);
+		ch->ch_c_iflag &= ~(IXON | IXOFF);
+	}
 
 	/*
-	 * follow protocol for opening port
+	 * Only the IBM Xr card can switch between
+	 * 232 and 422 modes on the fly
 	 */
+	if (bd->device == PCI_DEV_XR_IBM_DID) {
+		if (ch->ch_digi.digi_flags & DIGI_422)
+			dgap_cmdb(ch, SCOMMODE, MODE_422, 0, 0);
+		else
+			dgap_cmdb(ch, SCOMMODE, MODE_232, 0, 0);
+	}
 
-	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-	spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
+	if (ch->ch_digi.digi_flags & DIGI_ALTPIN)
+		iflag |= IALTPIN;
 
-	rc = dgap_block_til_ready(tty, file, ch);
+	if (iflag != ch->ch_fepiflag) {
+		ch->ch_fepiflag = iflag;
 
-	if (!un->un_tty)
-		return -ENODEV;
+		/* Okay to have channel and board locks held calling this */
+		dgap_cmdw(ch, SIFLAG, (u16) ch->ch_fepiflag, 0);
+	}
 
-	/* No going back now, increment our unit and channel counters */
-	spin_lock_irqsave(&ch->ch_lock, lock_flags);
-	ch->ch_open_count++;
-	un->un_open_count++;
-	un->un_flags |= (UN_ISOPEN);
-	spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
+	/*
+	 * Select hardware handshaking.
+	 */
+	hflow = 0;
 
-	return rc;
+	if (ch->ch_c_cflag & CRTSCTS)
+		hflow |= (D_RTS(ch) | D_CTS(ch));
+	if (ch->ch_digi.digi_flags & RTSPACE)
+		hflow |= D_RTS(ch);
+	if (ch->ch_digi.digi_flags & DTRPACE)
+		hflow |= D_DTR(ch);
+	if (ch->ch_digi.digi_flags & CTSPACE)
+		hflow |= D_CTS(ch);
+	if (ch->ch_digi.digi_flags & DSRPACE)
+		hflow |= D_DSR(ch);
+	if (ch->ch_digi.digi_flags & DCDPACE)
+		hflow |= D_CD(ch);
+
+	if (hflow != ch->ch_hflow) {
+		ch->ch_hflow = hflow;
+
+		/* Okay to have channel and board locks held calling this */
+		dgap_cmdb(ch, SHFLOW, (u8) hflow, 0xff, 0);
+	}
+
+	/*
+	 * Set RTS and/or DTR Toggle if needed,
+	 * but only if product is FEP5+ based.
+	 */
+	if (bd->bd_flags & BD_FEP5PLUS) {
+		u16 hflow2 = 0;
+
+		if (ch->ch_digi.digi_flags & DIGI_RTS_TOGGLE)
+			hflow2 |= (D_RTS(ch));
+		if (ch->ch_digi.digi_flags & DIGI_DTR_TOGGLE)
+			hflow2 |= (D_DTR(ch));
+
+		dgap_cmdw_ext(ch, 0xff03, hflow2, 0);
+	}
+
+	/*
+	 * Set modem control lines.
+	 */
+
+	mval ^= ch->ch_mforce & (mval ^ ch->ch_mval);
+
+	if (ch->ch_mostat ^ mval) {
+		ch->ch_mostat = mval;
+
+		/* Okay to have channel and board locks held calling this */
+		dgap_cmdb(ch, SMODEM, (u8) mval, D_RTS(ch)|D_DTR(ch), 0);
+	}
+
+	/*
+	 * Read modem signals, and then call carrier function.
+	 */
+	ch->ch_mistat = readb(&(ch->ch_bs->m_stat));
+	dgap_carrier(ch);
+
+	/*
+	 * Set the start and stop characters.
+	 */
+	if (ch->ch_startc != ch->ch_fepstartc ||
+	    ch->ch_stopc != ch->ch_fepstopc) {
+		ch->ch_fepstartc = ch->ch_startc;
+		ch->ch_fepstopc =  ch->ch_stopc;
+
+		/* Okay to have channel and board locks held calling this */
+		dgap_cmdb(ch, SFLOWC, ch->ch_fepstartc, ch->ch_fepstopc, 0);
+	}
+
+	/*
+	 * Set the Auxiliary start and stop characters.
+	 */
+	if (ch->ch_astartc != ch->ch_fepastartc ||
+	    ch->ch_astopc != ch->ch_fepastopc) {
+		ch->ch_fepastartc = ch->ch_astartc;
+		ch->ch_fepastopc = ch->ch_astopc;
+
+		/* Okay to have channel and board locks held calling this */
+		dgap_cmdb(ch, SAFLOWC, ch->ch_fepastartc, ch->ch_fepastopc, 0);
+	}
+
+	return 0;
 }
 
 /*
@@ -2155,15 +3194,18 @@ static int dgap_block_til_ready(struct tty_struct *tty, struct file *file,
 }
 
 /*
- * dgap_tty_hangup()
+ * dgap_tty_flush_buffer()
  *
- * Hangup the port.  Like a close, but don't wait for output to drain.
+ * Flush Tx buffer (make in == out)
  */
-static void dgap_tty_hangup(struct tty_struct *tty)
+static void dgap_tty_flush_buffer(struct tty_struct *tty)
 {
 	struct board_t *bd;
 	struct channel_t *ch;
 	struct un_t *un;
+	ulong lock_flags;
+	ulong lock_flags2;
+	u16 head;
 
 	if (!tty || tty->magic != TTY_MAGIC)
 		return;
@@ -2180,21 +3222,39 @@ static void dgap_tty_hangup(struct tty_struct *tty)
 	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
 		return;
 
-	/* flush the transmit queues */
-	dgap_tty_flush_buffer(tty);
+	spin_lock_irqsave(&bd->bd_lock, lock_flags);
+	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
+
+	ch->ch_flags &= ~CH_STOP;
+	head = readw(&(ch->ch_bs->tx_head));
+	dgap_cmdw(ch, FLUSHTX, (u16) head, 0);
+	dgap_cmdw(ch, RESUMETX, 0, 0);
+	if (ch->ch_tun.un_flags & (UN_LOW|UN_EMPTY)) {
+		ch->ch_tun.un_flags &= ~(UN_LOW|UN_EMPTY);
+		wake_up_interruptible(&ch->ch_tun.un_flags_wait);
+	}
+	if (ch->ch_pun.un_flags & (UN_LOW|UN_EMPTY)) {
+		ch->ch_pun.un_flags &= ~(UN_LOW|UN_EMPTY);
+		wake_up_interruptible(&ch->ch_pun.un_flags_wait);
+	}
+
+	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
+	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+	if (waitqueue_active(&tty->write_wait))
+		wake_up_interruptible(&tty->write_wait);
+	tty_wakeup(tty);
 }
 
 /*
- * dgap_tty_close()
+ * dgap_tty_hangup()
  *
+ * Hangup the port.  Like a close, but don't wait for output to drain.
  */
-static void dgap_tty_close(struct tty_struct *tty, struct file *file)
+static void dgap_tty_hangup(struct tty_struct *tty)
 {
-	struct ktermios *ts;
 	struct board_t *bd;
 	struct channel_t *ch;
 	struct un_t *un;
-	ulong lock_flags;
 
 	if (!tty || tty->magic != TTY_MAGIC)
 		return;
@@ -2211,107 +3271,8 @@ static void dgap_tty_close(struct tty_struct *tty, struct file *file)
 	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
 		return;
 
-	ts = &tty->termios;
-
-	spin_lock_irqsave(&ch->ch_lock, lock_flags);
-
-	/*
-	 * Determine if this is the last close or not - and if we agree about
-	 * which type of close it is with the Line Discipline
-	 */
-	if ((tty->count == 1) && (un->un_open_count != 1)) {
-		/*
-		 * Uh, oh.  tty->count is 1, which means that the tty
-		 * structure will be freed.  un_open_count should always
-		 * be one in these conditions.  If it's greater than
-		 * one, we've got real problems, since it means the
-		 * serial port won't be shutdown.
-		 */
-		un->un_open_count = 1;
-	}
-
-	if (--un->un_open_count < 0)
-		un->un_open_count = 0;
-
-	ch->ch_open_count--;
-
-	if (ch->ch_open_count && un->un_open_count) {
-		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
-		return;
-	}
-
-	/* OK, its the last close on the unit */
-
-	un->un_flags |= UN_CLOSING;
-
-	tty->closing = 1;
-
-	/*
-	 * Only officially close channel if count is 0 and
-	 * DIGI_PRINTER bit is not set.
-	 */
-	if ((ch->ch_open_count == 0) &&
-	    !(ch->ch_digi.digi_flags & DIGI_PRINTER)) {
-
-		ch->ch_flags &= ~(CH_RXBLOCK);
-
-		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
-
-		/* wait for output to drain */
-		/* This will also return if we take an interrupt */
-
-		dgap_wait_for_drain(tty);
-
-		dgap_tty_flush_buffer(tty);
-		tty_ldisc_flush(tty);
-
-		spin_lock_irqsave(&ch->ch_lock, lock_flags);
-
-		tty->closing = 0;
-
-		/*
-		 * If we have HUPCL set, lower DTR and RTS
-		 */
-		if (ch->ch_c_cflag & HUPCL) {
-			ch->ch_mostat &= ~(D_RTS(ch)|D_DTR(ch));
-			dgap_cmdb(ch, SMODEM, 0, D_DTR(ch)|D_RTS(ch), 0);
-
-			/*
-			 * Go to sleep to ensure RTS/DTR
-			 * have been dropped for modems to see it.
-			 */
-			spin_unlock_irqrestore(&ch->ch_lock,
-					lock_flags);
-
-			/* .25 second delay for dropping RTS/DTR */
-			schedule_timeout_interruptible(msecs_to_jiffies(250));
-
-			spin_lock_irqsave(&ch->ch_lock, lock_flags);
-		}
-
-		ch->pscan_state = 0;
-		ch->pscan_savechar = 0;
-		ch->ch_baud_info = 0;
-
-	}
-
-	/*
-	 * turn off print device when closing print device.
-	 */
-	if ((un->un_type == DGAP_PRINT)  && (ch->ch_flags & CH_PRON)) {
-		dgap_wmove(ch, ch->ch_digi.digi_offstr,
-			(int) ch->ch_digi.digi_offlen);
-		ch->ch_flags &= ~CH_PRON;
-	}
-
-	un->un_tty = NULL;
-	un->un_flags &= ~(UN_ISOPEN | UN_CLOSING);
-	tty->driver_data = NULL;
-
-	wake_up_interruptible(&ch->ch_flags_wait);
-	wake_up_interruptible(&un->un_flags_wait);
-
-	spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
+	/* flush the transmit queues */
+	dgap_tty_flush_buffer(tty);
 }
 
 /*
@@ -2611,22 +3572,6 @@ static int dgap_tty_write_room(struct tty_struct *tty)
 }
 
 /*
- * dgap_tty_put_char()
- *
- * Put a character into ch->ch_buf
- *
- *      - used by the line discipline for OPOST processing
- */
-static int dgap_tty_put_char(struct tty_struct *tty, unsigned char c)
-{
-	/*
-	 * Simply call tty_write.
-	 */
-	dgap_tty_write(tty, &c, 1);
-	return 1;
-}
-
-/*
  * dgap_tty_write()
  *
  * Take data from the user or kernel and send it out to the FEP.
@@ -2788,6 +3733,22 @@ static int dgap_tty_write(struct tty_struct *tty, const unsigned char *buf,
 }
 
 /*
+ * dgap_tty_put_char()
+ *
+ * Put a character into ch->ch_buf
+ *
+ *      - used by the line discipline for OPOST processing
+ */
+static int dgap_tty_put_char(struct tty_struct *tty, unsigned char c)
+{
+	/*
+	 * Simply call tty_write.
+	 */
+	dgap_tty_write(tty, &c, 1);
+	return 1;
+}
+
+/*
  * Return modem signals to ld.
  */
 static int dgap_tty_tiocmget(struct tty_struct *tty)
@@ -3448,13 +4409,176 @@ static void dgap_tty_unthrottle(struct tty_struct *tty)
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
 }
 
-static void dgap_tty_start(struct tty_struct *tty)
+/************************************************************************
+ *
+ * TTY Entry points and helper functions
+ *
+ ************************************************************************/
+
+/*
+ * dgap_tty_open()
+ *
+ */
+static int dgap_tty_open(struct tty_struct *tty, struct file *file)
 {
-	struct board_t *bd;
+	struct board_t *brd;
 	struct channel_t *ch;
 	struct un_t *un;
+	struct bs_t __iomem *bs;
+	uint major;
+	uint minor;
+	int rc;
 	ulong lock_flags;
 	ulong lock_flags2;
+	u16 head;
+
+	major = MAJOR(tty_devnum(tty));
+	minor = MINOR(tty_devnum(tty));
+
+	if (major > 255)
+		return -EIO;
+
+	/* Get board pointer from our array of majors we have allocated */
+	brd = dgap_boards_by_major[major];
+	if (!brd)
+		return -EIO;
+
+	/*
+	 * If board is not yet up to a state of READY, go to
+	 * sleep waiting for it to happen or they cancel the open.
+	 */
+	rc = wait_event_interruptible(brd->state_wait,
+		(brd->state & BOARD_READY));
+
+	if (rc)
+		return rc;
+
+	spin_lock_irqsave(&brd->bd_lock, lock_flags);
+
+	/* The wait above should guarantee this cannot happen */
+	if (brd->state != BOARD_READY) {
+		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
+		return -EIO;
+	}
+
+	/* If opened device is greater than our number of ports, bail. */
+	if (MINOR(tty_devnum(tty)) > brd->nasync) {
+		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
+		return -EIO;
+	}
+
+	ch = brd->channels[minor];
+	if (!ch) {
+		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
+		return -EIO;
+	}
+
+	/* Grab channel lock */
+	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
+
+	/* Figure out our type */
+	if (major == brd->dgap_serial_major) {
+		un = &brd->channels[minor]->ch_tun;
+		un->un_type = DGAP_SERIAL;
+	} else if (major == brd->dgap_transparent_print_major) {
+		un = &brd->channels[minor]->ch_pun;
+		un->un_type = DGAP_PRINT;
+	} else {
+		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
+		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
+		return -EIO;
+	}
+
+	/* Store our unit into driver_data, so we always have it available. */
+	tty->driver_data = un;
+
+	/*
+	 * Error if channel info pointer is NULL.
+	 */
+	bs = ch->ch_bs;
+	if (!bs) {
+		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
+		spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
+		return -EIO;
+	}
+
+	/*
+	 * Initialize tty's
+	 */
+	if (!(un->un_flags & UN_ISOPEN)) {
+		/* Store important variables. */
+		un->un_tty     = tty;
+
+		/* Maybe do something here to the TTY struct as well? */
+	}
+
+	/*
+	 * Initialize if neither terminal or printer is open.
+	 */
+	if (!((ch->ch_tun.un_flags | ch->ch_pun.un_flags) & UN_ISOPEN)) {
+
+		ch->ch_mforce = 0;
+		ch->ch_mval = 0;
+
+		/*
+		 * Flush input queue.
+		 */
+		head = readw(&(bs->rx_head));
+		writew(head, &(bs->rx_tail));
+
+		ch->ch_flags = 0;
+		ch->pscan_state = 0;
+		ch->pscan_savechar = 0;
+
+		ch->ch_c_cflag   = tty->termios.c_cflag;
+		ch->ch_c_iflag   = tty->termios.c_iflag;
+		ch->ch_c_oflag   = tty->termios.c_oflag;
+		ch->ch_c_lflag   = tty->termios.c_lflag;
+		ch->ch_startc = tty->termios.c_cc[VSTART];
+		ch->ch_stopc  = tty->termios.c_cc[VSTOP];
+
+		/* TODO: flush our TTY struct here? */
+	}
+
+	dgap_carrier(ch);
+	/*
+	 * Run param in case we changed anything
+	 */
+	dgap_param(ch, brd, un->un_type);
+
+	/*
+	 * follow protocol for opening port
+	 */
+
+	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
+	spin_unlock_irqrestore(&brd->bd_lock, lock_flags);
+
+	rc = dgap_block_til_ready(tty, file, ch);
+
+	if (!un->un_tty)
+		return -ENODEV;
+
+	/* No going back now, increment our unit and channel counters */
+	spin_lock_irqsave(&ch->ch_lock, lock_flags);
+	ch->ch_open_count++;
+	un->un_open_count++;
+	un->un_flags |= (UN_ISOPEN);
+	spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
+
+	return rc;
+}
+
+/*
+ * dgap_tty_close()
+ *
+ */
+static void dgap_tty_close(struct tty_struct *tty, struct file *file)
+{
+	struct ktermios *ts;
+	struct board_t *bd;
+	struct channel_t *ch;
+	struct un_t *un;
+	ulong lock_flags;
 
 	if (!tty || tty->magic != TTY_MAGIC)
 		return;
@@ -3471,16 +4595,110 @@ static void dgap_tty_start(struct tty_struct *tty)
 	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
 		return;
 
-	spin_lock_irqsave(&bd->bd_lock, lock_flags);
-	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
+	ts = &tty->termios;
 
-	dgap_cmdw(ch, RESUMETX, 0, 0);
+	spin_lock_irqsave(&ch->ch_lock, lock_flags);
 
-	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
+	/*
+	 * Determine if this is the last close or not - and if we agree about
+	 * which type of close it is with the Line Discipline
+	 */
+	if ((tty->count == 1) && (un->un_open_count != 1)) {
+		/*
+		 * Uh, oh.  tty->count is 1, which means that the tty
+		 * structure will be freed.  un_open_count should always
+		 * be one in these conditions.  If it's greater than
+		 * one, we've got real problems, since it means the
+		 * serial port won't be shutdown.
+		 */
+		un->un_open_count = 1;
+	}
+
+	if (--un->un_open_count < 0)
+		un->un_open_count = 0;
+
+	ch->ch_open_count--;
+
+	if (ch->ch_open_count && un->un_open_count) {
+		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
+		return;
+	}
+
+	/* OK, its the last close on the unit */
+
+	un->un_flags |= UN_CLOSING;
+
+	tty->closing = 1;
+
+	/*
+	 * Only officially close channel if count is 0 and
+	 * DIGI_PRINTER bit is not set.
+	 */
+	if ((ch->ch_open_count == 0) &&
+	    !(ch->ch_digi.digi_flags & DIGI_PRINTER)) {
+
+		ch->ch_flags &= ~(CH_RXBLOCK);
+
+		spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
+
+		/* wait for output to drain */
+		/* This will also return if we take an interrupt */
+
+		dgap_wait_for_drain(tty);
+
+		dgap_tty_flush_buffer(tty);
+		tty_ldisc_flush(tty);
+
+		spin_lock_irqsave(&ch->ch_lock, lock_flags);
+
+		tty->closing = 0;
+
+		/*
+		 * If we have HUPCL set, lower DTR and RTS
+		 */
+		if (ch->ch_c_cflag & HUPCL) {
+			ch->ch_mostat &= ~(D_RTS(ch)|D_DTR(ch));
+			dgap_cmdb(ch, SMODEM, 0, D_DTR(ch)|D_RTS(ch), 0);
+
+			/*
+			 * Go to sleep to ensure RTS/DTR
+			 * have been dropped for modems to see it.
+			 */
+			spin_unlock_irqrestore(&ch->ch_lock,
+					lock_flags);
+
+			/* .25 second delay for dropping RTS/DTR */
+			schedule_timeout_interruptible(msecs_to_jiffies(250));
+
+			spin_lock_irqsave(&ch->ch_lock, lock_flags);
+		}
+
+		ch->pscan_state = 0;
+		ch->pscan_savechar = 0;
+		ch->ch_baud_info = 0;
+
+	}
+
+	/*
+	 * turn off print device when closing print device.
+	 */
+	if ((un->un_type == DGAP_PRINT)  && (ch->ch_flags & CH_PRON)) {
+		dgap_wmove(ch, ch->ch_digi.digi_offstr,
+			(int) ch->ch_digi.digi_offlen);
+		ch->ch_flags &= ~CH_PRON;
+	}
+
+	un->un_tty = NULL;
+	un->un_flags &= ~(UN_ISOPEN | UN_CLOSING);
+	tty->driver_data = NULL;
+
+	wake_up_interruptible(&ch->ch_flags_wait);
+	wake_up_interruptible(&un->un_flags_wait);
+
+	spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
 }
 
-static void dgap_tty_stop(struct tty_struct *tty)
+static void dgap_tty_start(struct tty_struct *tty)
 {
 	struct board_t *bd;
 	struct channel_t *ch;
@@ -3506,26 +4724,13 @@ static void dgap_tty_stop(struct tty_struct *tty)
 	spin_lock_irqsave(&bd->bd_lock, lock_flags);
 	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
 
-	dgap_cmdw(ch, PAUSETX, 0, 0);
+	dgap_cmdw(ch, RESUMETX, 0, 0);
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
 }
 
-/*
- * dgap_tty_flush_chars()
- *
- * Flush the cook buffer
- *
- * Note to self, and any other poor souls who venture here:
- *
- * flush in this case DOES NOT mean dispose of the data.
- * instead, it means "stop buffering and send it if you
- * haven't already."  Just guess how I figured that out...   SRW 2-Jun-98
- *
- * It is also always called in interrupt context - JAR 8-Sept-99
- */
-static void dgap_tty_flush_chars(struct tty_struct *tty)
+static void dgap_tty_stop(struct tty_struct *tty)
 {
 	struct board_t *bd;
 	struct channel_t *ch;
@@ -3551,25 +4756,32 @@ static void dgap_tty_flush_chars(struct tty_struct *tty)
 	spin_lock_irqsave(&bd->bd_lock, lock_flags);
 	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
 
-	/* TODO: Do something here */
+	dgap_cmdw(ch, PAUSETX, 0, 0);
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
 }
 
 /*
- * dgap_tty_flush_buffer()
+ * dgap_tty_flush_chars()
  *
- * Flush Tx buffer (make in == out)
+ * Flush the cook buffer
+ *
+ * Note to self, and any other poor souls who venture here:
+ *
+ * flush in this case DOES NOT mean dispose of the data.
+ * instead, it means "stop buffering and send it if you
+ * haven't already."  Just guess how I figured that out...   SRW 2-Jun-98
+ *
+ * It is also always called in interrupt context - JAR 8-Sept-99
  */
-static void dgap_tty_flush_buffer(struct tty_struct *tty)
+static void dgap_tty_flush_chars(struct tty_struct *tty)
 {
 	struct board_t *bd;
 	struct channel_t *ch;
 	struct un_t *un;
 	ulong lock_flags;
 	ulong lock_flags2;
-	u16 head;
 
 	if (!tty || tty->magic != TTY_MAGIC)
 		return;
@@ -3589,24 +4801,10 @@ static void dgap_tty_flush_buffer(struct tty_struct *tty)
 	spin_lock_irqsave(&bd->bd_lock, lock_flags);
 	spin_lock_irqsave(&ch->ch_lock, lock_flags2);
 
-	ch->ch_flags &= ~CH_STOP;
-	head = readw(&(ch->ch_bs->tx_head));
-	dgap_cmdw(ch, FLUSHTX, (u16) head, 0);
-	dgap_cmdw(ch, RESUMETX, 0, 0);
-	if (ch->ch_tun.un_flags & (UN_LOW|UN_EMPTY)) {
-		ch->ch_tun.un_flags &= ~(UN_LOW|UN_EMPTY);
-		wake_up_interruptible(&ch->ch_tun.un_flags_wait);
-	}
-	if (ch->ch_pun.un_flags & (UN_LOW|UN_EMPTY)) {
-		ch->ch_pun.un_flags &= ~(UN_LOW|UN_EMPTY);
-		wake_up_interruptible(&ch->ch_pun.un_flags_wait);
-	}
+	/* TODO: Do something here */
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
 	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-	if (waitqueue_active(&tty->write_wait))
-		wake_up_interruptible(&tty->write_wait);
-	tty_wakeup(tty);
 }
 
 /*****************************************************************************
@@ -4000,1614 +5198,173 @@ static int dgap_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	}
 }
 
-static int dgap_alloc_flipbuf(struct board_t *brd)
-{
-	/*
-	 * allocate flip buffer for board.
-	 */
-	brd->flipbuf = kmalloc(MYFLIPLEN, GFP_KERNEL);
-	if (!brd->flipbuf)
-		return -ENOMEM;
-
-	brd->flipflagbuf = kmalloc(MYFLIPLEN, GFP_KERNEL);
-	if (!brd->flipflagbuf) {
-		kfree(brd->flipbuf);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void dgap_free_flipbuf(struct board_t *brd)
-{
-	kfree(brd->flipbuf);
-	kfree(brd->flipflagbuf);
-}
-
-/*
- * Create pr and tty device entries
- */
-static int dgap_tty_register_ports(struct board_t *brd)
-{
-	struct channel_t *ch;
-	int i;
-	int ret;
-
-	brd->serial_ports = kcalloc(brd->nasync, sizeof(*brd->serial_ports),
-					GFP_KERNEL);
-	if (!brd->serial_ports)
-		return -ENOMEM;
-
-	brd->printer_ports = kcalloc(brd->nasync, sizeof(*brd->printer_ports),
-					GFP_KERNEL);
-	if (!brd->printer_ports) {
-		ret = -ENOMEM;
-		goto free_serial_ports;
-	}
-
-	for (i = 0; i < brd->nasync; i++) {
-		tty_port_init(&brd->serial_ports[i]);
-		tty_port_init(&brd->printer_ports[i]);
-	}
-
-	ch = brd->channels[0];
-	for (i = 0; i < brd->nasync; i++, ch = brd->channels[i]) {
-
-		struct device *classp;
-
-		classp = tty_port_register_device(&brd->serial_ports[i],
-						  brd->serial_driver,
-						  i, NULL);
-
-		if (IS_ERR(classp)) {
-			ret = PTR_ERR(classp);
-			goto unregister_ttys;
-		}
-
-		dgap_create_tty_sysfs(&ch->ch_tun, classp);
-		ch->ch_tun.un_sysfs = classp;
-
-		classp = tty_port_register_device(&brd->printer_ports[i],
-						  brd->print_driver,
-						  i, NULL);
-
-		if (IS_ERR(classp)) {
-			ret = PTR_ERR(classp);
-			goto unregister_ttys;
-		}
-
-		dgap_create_tty_sysfs(&ch->ch_pun, classp);
-		ch->ch_pun.un_sysfs = classp;
-	}
-	dgap_create_ports_sysfiles(brd);
-
-	return 0;
-
-unregister_ttys:
-	while (i >= 0) {
-		ch = brd->channels[i];
-		if (ch->ch_tun.un_sysfs) {
-			dgap_remove_tty_sysfs(ch->ch_tun.un_sysfs);
-			tty_unregister_device(brd->serial_driver, i);
-		}
-
-		if (ch->ch_pun.un_sysfs) {
-			dgap_remove_tty_sysfs(ch->ch_pun.un_sysfs);
-			tty_unregister_device(brd->print_driver, i);
-		}
-		i--;
-	}
-
-	for (i = 0; i < brd->nasync; i++) {
-		tty_port_destroy(&brd->serial_ports[i]);
-		tty_port_destroy(&brd->printer_ports[i]);
-	}
-
-	kfree(brd->printer_ports);
-	brd->printer_ports = NULL;
-
-free_serial_ports:
-	kfree(brd->serial_ports);
-	brd->serial_ports = NULL;
-
-	return ret;
-}
-
-/*
- * Copies the BIOS code from the user to the board,
- * and starts the BIOS running.
- */
-static void dgap_do_bios_load(struct board_t *brd, const u8 *ubios, int len)
-{
-	u8 __iomem *addr;
-	uint offset;
-	int i;
-
-	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
-		return;
-
-	addr = brd->re_map_membase;
-
-	/*
-	 * clear POST area
-	 */
-	for (i = 0; i < 16; i++)
-		writeb(0, addr + POSTAREA + i);
-
-	/*
-	 * Download bios
-	 */
-	offset = 0x1000;
-	memcpy_toio(addr + offset, ubios, len);
-
-	writel(0x0bf00401, addr);
-	writel(0, (addr + 4));
-
-	/* Clear the reset, and change states. */
-	writeb(FEPCLR, brd->re_map_port);
-}
-
-/*
- * Checks to see if the BIOS completed running on the card.
- */
-static int dgap_test_bios(struct board_t *brd)
-{
-	u8 __iomem *addr;
-	u16 word;
-	u16 err1;
-	u16 err2;
-
-	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
-		return -EINVAL;
-
-	addr = brd->re_map_membase;
-	word = readw(addr + POSTAREA);
-
-	/*
-	 * It can take 5-6 seconds for a board to
-	 * pass the bios self test and post results.
-	 * Give it 10 seconds.
-	 */
-	brd->wait_for_bios = 0;
-	while (brd->wait_for_bios < 1000) {
-		/* Check to see if BIOS thinks board is good. (GD). */
-		if (word == *(u16 *) "GD")
-			return 0;
-		msleep_interruptible(10);
-		brd->wait_for_bios++;
-		word = readw(addr + POSTAREA);
-	}
-
-	/* Gave up on board after too long of time taken */
-	err1 = readw(addr + SEQUENCE);
-	err2 = readw(addr + ERROR);
-	dev_warn(&brd->pdev->dev, "%s failed diagnostics.  Error #(%x,%x).\n",
-		brd->name, err1, err2);
-	brd->state = BOARD_FAILED;
-	brd->dpastatus = BD_NOBIOS;
-
-	return -EIO;
-}
-
-/*
- * Copies the FEP code from the user to the board,
- * and starts the FEP running.
- */
-static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len)
-{
-	u8 __iomem *addr;
-	uint offset;
-
-	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
-		return;
-
-	addr = brd->re_map_membase;
-
-	/*
-	 * Download FEP
-	 */
-	offset = 0x1000;
-	memcpy_toio(addr + offset, ufep, len);
-
-	/*
-	 * If board is a concentrator product, we need to give
-	 * it its config string describing how the concentrators look.
-	 */
-	if ((brd->type == PCX) || (brd->type == PEPC)) {
-		u8 string[100];
-		u8 __iomem *config;
-		u8 *xconfig;
-		int i = 0;
-
-		xconfig = dgap_create_config_string(brd, string);
-
-		/* Write string to board memory */
-		config = addr + CONFIG;
-		for (; i < CONFIGSIZE; i++, config++, xconfig++) {
-			writeb(*xconfig, config);
-			if ((*xconfig & 0xff) == 0xff)
-				break;
-		}
-	}
-
-	writel(0xbfc01004, (addr + 0xc34));
-	writel(0x3, (addr + 0xc30));
-
-}
-
-/*
- * Waits for the FEP to report thats its ready for us to use.
- */
-static int dgap_test_fep(struct board_t *brd)
-{
-	u8 __iomem *addr;
-	u16 word;
-	u16 err1;
-	u16 err2;
-
-	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
-		return -EINVAL;
-
-	addr = brd->re_map_membase;
-	word = readw(addr + FEPSTAT);
-
-	/*
-	 * It can take 2-3 seconds for the FEP to
-	 * be up and running. Give it 5 secs.
-	 */
-	brd->wait_for_fep = 0;
-	while (brd->wait_for_fep < 500) {
-		/* Check to see if FEP is up and running now. */
-		if (word == *(u16 *) "OS") {
-			/*
-			 * Check to see if the board can support FEP5+ commands.
-			*/
-			word = readw(addr + FEP5_PLUS);
-			if (word == *(u16 *) "5A")
-				brd->bd_flags |= BD_FEP5PLUS;
-
-			return 0;
-		}
-		msleep_interruptible(10);
-		brd->wait_for_fep++;
-		word = readw(addr + FEPSTAT);
-	}
-
-	/* Gave up on board after too long of time taken */
-	err1 = readw(addr + SEQUENCE);
-	err2 = readw(addr + ERROR);
-	dev_warn(&brd->pdev->dev,
-		 "FEPOS for %s not functioning.  Error #(%x,%x).\n",
-		 brd->name, err1, err2);
-	brd->state = BOARD_FAILED;
-	brd->dpastatus = BD_NOFEP;
-
-	return -EIO;
-}
-
-/*
- * Physically forces the FEP5 card to reset itself.
- */
-static void dgap_do_reset_board(struct board_t *brd)
-{
-	u8 check;
-	u32 check1;
-	u32 check2;
-	int i;
-
-	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) ||
-	    !brd->re_map_membase || !brd->re_map_port)
-		return;
-
-	/* FEPRST does not vary among supported boards */
-	writeb(FEPRST, brd->re_map_port);
-
-	for (i = 0; i <= 1000; i++) {
-		check = readb(brd->re_map_port) & 0xe;
-		if (check == FEPRST)
-			break;
-		udelay(10);
-
-	}
-	if (i > 1000) {
-		dev_warn(&brd->pdev->dev,
-			 "dgap: Board not resetting...  Failing board.\n");
-		brd->state = BOARD_FAILED;
-		brd->dpastatus = BD_NOFEP;
-		return;
-	}
-
-	/*
-	 * Make sure there really is memory out there.
-	 */
-	writel(0xa55a3cc3, (brd->re_map_membase + LOWMEM));
-	writel(0x5aa5c33c, (brd->re_map_membase + HIGHMEM));
-	check1 = readl(brd->re_map_membase + LOWMEM);
-	check2 = readl(brd->re_map_membase + HIGHMEM);
-
-	if ((check1 != 0xa55a3cc3) || (check2 != 0x5aa5c33c)) {
-		dev_warn(&brd->pdev->dev,
-			 "No memory at %p for board.\n",
-			 brd->re_map_membase);
-		brd->state = BOARD_FAILED;
-		brd->dpastatus = BD_NOFEP;
-		return;
-	}
-}
-
-#ifdef DIGI_CONCENTRATORS_SUPPORTED
-/*
- * Sends a concentrator image into the FEP5 board.
- */
-static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len)
-{
-	char __iomem *vaddr;
-	u16 offset;
-	struct downld_t *to_dp;
-
-	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
-		return;
-
-	vaddr = brd->re_map_membase;
-
-	offset = readw((u16 *) (vaddr + DOWNREQ));
-	to_dp = (struct downld_t *) (vaddr + (int) offset);
-	memcpy_toio(to_dp, uaddr, len);
-
-	/* Tell card we have data for it */
-	writew(0, vaddr + (DOWNREQ));
-
-	brd->conc_dl_status = NO_PENDING_CONCENTRATOR_REQUESTS;
-}
-#endif
-
-#define EXPANSION_ROM_SIZE	(64 * 1024)
-#define FEP5_ROM_MAGIC		(0xFEFFFFFF)
-
-static void dgap_get_vpd(struct board_t *brd)
-{
-	u32 magic;
-	u32 base_offset;
-	u16 rom_offset;
-	u16 vpd_offset;
-	u16 image_length;
-	u16 i;
-	u8 byte1;
-	u8 byte2;
-
-	/*
-	 * Poke the magic number at the PCI Rom Address location.
-	 * If VPD is supported, the value read from that address
-	 * will be non-zero.
-	 */
-	magic = FEP5_ROM_MAGIC;
-	pci_write_config_dword(brd->pdev, PCI_ROM_ADDRESS, magic);
-	pci_read_config_dword(brd->pdev, PCI_ROM_ADDRESS, &magic);
-
-	/* VPD not supported, bail */
-	if (!magic)
-		return;
-
-	/*
-	 * To get to the OTPROM memory, we have to send the boards base
-	 * address or'ed with 1 into the PCI Rom Address location.
-	 */
-	magic = brd->membase | 0x01;
-	pci_write_config_dword(brd->pdev, PCI_ROM_ADDRESS, magic);
-	pci_read_config_dword(brd->pdev, PCI_ROM_ADDRESS, &magic);
-
-	byte1 = readb(brd->re_map_membase);
-	byte2 = readb(brd->re_map_membase + 1);
-
-	/*
-	 * If the board correctly swapped to the OTPROM memory,
-	 * the first 2 bytes (header) should be 0x55, 0xAA
-	 */
-	if (byte1 == 0x55 && byte2 == 0xAA) {
-
-		base_offset = 0;
-
-		/*
-		 * We have to run through all the OTPROM memory looking
-		 * for the VPD offset.
-		 */
-		while (base_offset <= EXPANSION_ROM_SIZE) {
-
-			/*
-			 * Lots of magic numbers here.
-			 *
-			 * The VPD offset is located inside the ROM Data
-			 * Structure.
-			 *
-			 * We also have to remember the length of each
-			 * ROM Data Structure, so we can "hop" to the next
-			 * entry if the VPD isn't in the current
-			 * ROM Data Structure.
-			 */
-			rom_offset = readw(brd->re_map_membase +
-						base_offset + 0x18);
-			image_length = readw(brd->re_map_membase +
-						rom_offset + 0x10) * 512;
-			vpd_offset = readw(brd->re_map_membase +
-						rom_offset + 0x08);
-
-			/* Found the VPD entry */
-			if (vpd_offset)
-				break;
-
-			/* We didn't find a VPD entry, go to next ROM entry. */
-			base_offset += image_length;
-
-			byte1 = readb(brd->re_map_membase + base_offset);
-			byte2 = readb(brd->re_map_membase + base_offset + 1);
-
-			/*
-			 * If the new ROM offset doesn't have 0x55, 0xAA
-			 * as its header, we have run out of ROM.
-			 */
-			if (byte1 != 0x55 || byte2 != 0xAA)
-				break;
-		}
-
-		/*
-		 * If we have a VPD offset, then mark the board
-		 * as having a valid VPD, and copy VPDSIZE (512) bytes of
-		 * that VPD to the buffer we have in our board structure.
-		 */
-		if (vpd_offset) {
-			brd->bd_flags |= BD_HAS_VPD;
-			for (i = 0; i < VPDSIZE; i++) {
-				brd->vpd[i] = readb(brd->re_map_membase +
-							vpd_offset + i);
-			}
-		}
-	}
-
-	/*
-	 * We MUST poke the magic number at the PCI Rom Address location again.
-	 * This makes the card report the regular board memory back to us,
-	 * rather than the OTPROM memory.
-	 */
-	magic = FEP5_ROM_MAGIC;
-	pci_write_config_dword(brd->pdev, PCI_ROM_ADDRESS, magic);
-}
-
-/*
- * Our board poller function.
- */
-static void dgap_poll_tasklet(unsigned long data)
-{
-	struct board_t *bd = (struct board_t *) data;
-	ulong lock_flags;
-	char __iomem *vaddr;
-	u16 head, tail;
-
-	if (!bd || (bd->magic != DGAP_BOARD_MAGIC))
-		return;
-
-	if (bd->inhibit_poller)
-		return;
-
-	spin_lock_irqsave(&bd->bd_lock, lock_flags);
-
-	vaddr = bd->re_map_membase;
-
-	/*
-	 * If board is ready, parse deeper to see if there is anything to do.
-	 */
-	if (bd->state == BOARD_READY) {
-
-		struct ev_t __iomem *eaddr;
-
-		if (!bd->re_map_membase) {
-			spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-			return;
-		}
-		if (!bd->re_map_port) {
-			spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-			return;
-		}
-
-		if (!bd->nasync)
-			goto out;
-
-		eaddr = (struct ev_t __iomem *) (vaddr + EVBUF);
-
-		/* Get our head and tail */
-		head = readw(&(eaddr->ev_head));
-		tail = readw(&(eaddr->ev_tail));
-
-		/*
-		 * If there is an event pending. Go service it.
-		 */
-		if (head != tail) {
-			spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-			dgap_event(bd);
-			spin_lock_irqsave(&bd->bd_lock, lock_flags);
-		}
-
-out:
-		/*
-		 * If board is doing interrupts, ACK the interrupt.
-		 */
-		if (bd && bd->intr_running)
-			readb(bd->re_map_port + 2);
-
-		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return;
-	}
-
-	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-}
-
-/*=======================================================================
- *
- *      dgap_cmdb - Sends a 2 byte command to the FEP.
- *
- *              ch      - Pointer to channel structure.
- *              cmd     - Command to be sent.
- *              byte1   - Integer containing first byte to be sent.
- *              byte2   - Integer containing second byte to be sent.
- *              ncmds   - Wait until ncmds or fewer cmds are left
- *                        in the cmd buffer before returning.
- *
- *=======================================================================*/
-static void dgap_cmdb(struct channel_t *ch, u8 cmd, u8 byte1,
-			u8 byte2, uint ncmds)
-{
-	char __iomem *vaddr;
-	struct __iomem cm_t *cm_addr;
-	uint count;
-	uint n;
-	u16 head;
-	u16 tail;
-
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return;
-
-	/*
-	 * Check if board is still alive.
-	 */
-	if (ch->ch_bd->state == BOARD_FAILED)
-		return;
-
-	/*
-	 * Make sure the pointers are in range before
-	 * writing to the FEP memory.
-	 */
-	vaddr = ch->ch_bd->re_map_membase;
-
-	if (!vaddr)
-		return;
-
-	cm_addr = (struct cm_t __iomem *) (vaddr + CMDBUF);
-	head = readw(&(cm_addr->cm_head));
-
-	/*
-	 * Forget it if pointers out of range.
-	 */
-	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
-		ch->ch_bd->state = BOARD_FAILED;
-		return;
-	}
-
-	/*
-	 * Put the data in the circular command buffer.
-	 */
-	writeb(cmd, (vaddr + head + CMDSTART + 0));
-	writeb((u8) ch->ch_portnum, (vaddr + head + CMDSTART + 1));
-	writeb(byte1, (vaddr + head + CMDSTART + 2));
-	writeb(byte2, (vaddr + head + CMDSTART + 3));
-
-	head = (head + 4) & (CMDMAX - CMDSTART - 4);
-
-	writew(head, &(cm_addr->cm_head));
-
-	/*
-	 * Wait if necessary before updating the head
-	 * pointer to limit the number of outstanding
-	 * commands to the FEP.   If the time spent waiting
-	 * is outlandish, declare the FEP dead.
-	 */
-	for (count = dgap_count ;;) {
-
-		head = readw(&(cm_addr->cm_head));
-		tail = readw(&(cm_addr->cm_tail));
-
-		n = (head - tail) & (CMDMAX - CMDSTART - 4);
-
-		if (n <= ncmds * sizeof(struct cm_t))
-			break;
-
-		if (--count == 0) {
-			ch->ch_bd->state = BOARD_FAILED;
-			return;
-		}
-		udelay(10);
-	}
-}
-
-/*=======================================================================
- *
- *      dgap_cmdw - Sends a 1 word command to the FEP.
- *
- *              ch      - Pointer to channel structure.
- *              cmd     - Command to be sent.
- *              word    - Integer containing word to be sent.
- *              ncmds   - Wait until ncmds or fewer cmds are left
- *                        in the cmd buffer before returning.
- *
- *=======================================================================*/
-static void dgap_cmdw(struct channel_t *ch, u8 cmd, u16 word, uint ncmds)
-{
-	char __iomem *vaddr;
-	struct __iomem cm_t *cm_addr;
-	uint count;
-	uint n;
-	u16 head;
-	u16 tail;
-
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return;
-
-	/*
-	 * Check if board is still alive.
-	 */
-	if (ch->ch_bd->state == BOARD_FAILED)
-		return;
-
-	/*
-	 * Make sure the pointers are in range before
-	 * writing to the FEP memory.
-	 */
-	vaddr = ch->ch_bd->re_map_membase;
-	if (!vaddr)
-		return;
-
-	cm_addr = (struct cm_t __iomem *) (vaddr + CMDBUF);
-	head = readw(&(cm_addr->cm_head));
-
-	/*
-	 * Forget it if pointers out of range.
-	 */
-	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
-		ch->ch_bd->state = BOARD_FAILED;
-		return;
-	}
-
-	/*
-	 * Put the data in the circular command buffer.
-	 */
-	writeb(cmd, (vaddr + head + CMDSTART + 0));
-	writeb((u8) ch->ch_portnum, (vaddr + head + CMDSTART + 1));
-	writew((u16) word, (vaddr + head + CMDSTART + 2));
-
-	head = (head + 4) & (CMDMAX - CMDSTART - 4);
-
-	writew(head, &(cm_addr->cm_head));
-
-	/*
-	 * Wait if necessary before updating the head
-	 * pointer to limit the number of outstanding
-	 * commands to the FEP.   If the time spent waiting
-	 * is outlandish, declare the FEP dead.
-	 */
-	for (count = dgap_count ;;) {
-
-		head = readw(&(cm_addr->cm_head));
-		tail = readw(&(cm_addr->cm_tail));
-
-		n = (head - tail) & (CMDMAX - CMDSTART - 4);
-
-		if (n <= ncmds * sizeof(struct cm_t))
-			break;
-
-		if (--count == 0) {
-			ch->ch_bd->state = BOARD_FAILED;
-			return;
-		}
-		udelay(10);
-	}
-}
-
-/*=======================================================================
- *
- *      dgap_cmdw_ext - Sends a extended word command to the FEP.
- *
- *              ch      - Pointer to channel structure.
- *              cmd     - Command to be sent.
- *              word    - Integer containing word to be sent.
- *              ncmds   - Wait until ncmds or fewer cmds are left
- *                        in the cmd buffer before returning.
- *
- *=======================================================================*/
-static void dgap_cmdw_ext(struct channel_t *ch, u16 cmd, u16 word, uint ncmds)
-{
-	char __iomem *vaddr;
-	struct __iomem cm_t *cm_addr;
-	uint count;
-	uint n;
-	u16 head;
-	u16 tail;
-
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return;
-
-	/*
-	 * Check if board is still alive.
-	 */
-	if (ch->ch_bd->state == BOARD_FAILED)
-		return;
-
-	/*
-	 * Make sure the pointers are in range before
-	 * writing to the FEP memory.
-	 */
-	vaddr = ch->ch_bd->re_map_membase;
-	if (!vaddr)
-		return;
-
-	cm_addr = (struct cm_t __iomem *) (vaddr + CMDBUF);
-	head = readw(&(cm_addr->cm_head));
-
-	/*
-	 * Forget it if pointers out of range.
-	 */
-	if (head >= (CMDMAX - CMDSTART) || (head & 03)) {
-		ch->ch_bd->state = BOARD_FAILED;
-		return;
-	}
-
-	/*
-	 * Put the data in the circular command buffer.
-	 */
-
-	/* Write an FF to tell the FEP that we want an extended command */
-	writeb((u8) 0xff, (vaddr + head + CMDSTART + 0));
-
-	writeb((u8) ch->ch_portnum, (vaddr + head + CMDSTART + 1));
-	writew((u16) cmd, (vaddr + head + CMDSTART + 2));
-
-	/*
-	 * If the second part of the command won't fit,
-	 * put it at the beginning of the circular buffer.
-	 */
-	if (((head + 4) >= ((CMDMAX - CMDSTART)) || (head & 03)))
-		writew((u16) word, (vaddr + CMDSTART));
-	else
-		writew((u16) word, (vaddr + head + CMDSTART + 4));
-
-	head = (head + 8) & (CMDMAX - CMDSTART - 4);
-
-	writew(head, &(cm_addr->cm_head));
-
-	/*
-	 * Wait if necessary before updating the head
-	 * pointer to limit the number of outstanding
-	 * commands to the FEP.   If the time spent waiting
-	 * is outlandish, declare the FEP dead.
-	 */
-	for (count = dgap_count ;;) {
-
-		head = readw(&(cm_addr->cm_head));
-		tail = readw(&(cm_addr->cm_tail));
-
-		n = (head - tail) & (CMDMAX - CMDSTART - 4);
-
-		if (n <= ncmds * sizeof(struct cm_t))
-			break;
-
-		if (--count == 0) {
-			ch->ch_bd->state = BOARD_FAILED;
-			return;
-		}
-		udelay(10);
-	}
-}
+static const struct tty_operations dgap_tty_ops = {
+	.open = dgap_tty_open,
+	.close = dgap_tty_close,
+	.write = dgap_tty_write,
+	.write_room = dgap_tty_write_room,
+	.flush_buffer = dgap_tty_flush_buffer,
+	.chars_in_buffer = dgap_tty_chars_in_buffer,
+	.flush_chars = dgap_tty_flush_chars,
+	.ioctl = dgap_tty_ioctl,
+	.set_termios = dgap_tty_set_termios,
+	.stop = dgap_tty_stop,
+	.start = dgap_tty_start,
+	.throttle = dgap_tty_throttle,
+	.unthrottle = dgap_tty_unthrottle,
+	.hangup = dgap_tty_hangup,
+	.put_char = dgap_tty_put_char,
+	.tiocmget = dgap_tty_tiocmget,
+	.tiocmset = dgap_tty_tiocmset,
+	.break_ctl = dgap_tty_send_break,
+	.wait_until_sent = dgap_tty_wait_until_sent,
+	.send_xchar = dgap_tty_send_xchar
+};
 
-/*=======================================================================
- *
- *      dgap_wmove - Write data to FEP buffer.
+/************************************************************************
  *
- *              ch      - Pointer to channel structure.
- *              buf     - Poiter to characters to be moved.
- *              cnt     - Number of characters to move.
+ * TTY Initialization/Cleanup Functions
  *
- *=======================================================================*/
-static void dgap_wmove(struct channel_t *ch, char *buf, uint cnt)
-{
-	int n;
-	char __iomem *taddr;
-	struct bs_t __iomem *bs;
-	u16 head;
-
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return;
-
-	/*
-	 * Check parameters.
-	 */
-	bs   = ch->ch_bs;
-	head = readw(&(bs->tx_head));
-
-	/*
-	 * If pointers are out of range, just return.
-	 */
-	if ((cnt > ch->ch_tsize) ||
-	    (unsigned)(head - ch->ch_tstart) >= ch->ch_tsize)
-		return;
-
-	/*
-	 * If the write wraps over the top of the circular buffer,
-	 * move the portion up to the wrap point, and reset the
-	 * pointers to the bottom.
-	 */
-	n = ch->ch_tstart + ch->ch_tsize - head;
-
-	if (cnt >= n) {
-		cnt -= n;
-		taddr = ch->ch_taddr + head;
-		memcpy_toio(taddr, buf, n);
-		head = ch->ch_tstart;
-		buf += n;
-	}
-
-	/*
-	 * Move rest of data.
-	 */
-	taddr = ch->ch_taddr + head;
-	n = cnt;
-	memcpy_toio(taddr, buf, n);
-	head += cnt;
-
-	writew(head, &(bs->tx_head));
-}
-
-/*
- * Retrives the current custom baud rate from FEP memory,
- * and returns it back to the user.
- * Returns 0 on error.
- */
-static uint dgap_get_custom_baud(struct channel_t *ch)
-{
-	u8 __iomem *vaddr;
-	ulong offset;
-	uint value;
-
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return 0;
-
-	if (!ch->ch_bd || ch->ch_bd->magic != DGAP_BOARD_MAGIC)
-		return 0;
-
-	if (!(ch->ch_bd->bd_flags & BD_FEP5PLUS))
-		return 0;
-
-	vaddr = ch->ch_bd->re_map_membase;
-
-	if (!vaddr)
-		return 0;
-
-	/*
-	 * Go get from fep mem, what the fep
-	 * believes the custom baud rate is.
-	 */
-	offset = (ioread16(vaddr + ECS_SEG) << 4) + (ch->ch_portnum * 0x28)
-	       + LINE_SPEED;
-
-	value = readw(vaddr + offset);
-	return value;
-}
+ ************************************************************************/
 
 /*
- * Calls the firmware to reset this channel.
- */
-static void dgap_firmware_reset_port(struct channel_t *ch)
-{
-	dgap_cmdb(ch, CHRESET, 0, 0, 0);
-
-	/*
-	 * Now that the channel is reset, we need to make sure
-	 * all the current settings get reapplied to the port
-	 * in the firmware.
-	 *
-	 * So we will set the driver's cache of firmware
-	 * settings all to 0, and then call param.
-	 */
-	ch->ch_fepiflag = 0;
-	ch->ch_fepcflag = 0;
-	ch->ch_fepoflag = 0;
-	ch->ch_fepstartc = 0;
-	ch->ch_fepstopc = 0;
-	ch->ch_fepastartc = 0;
-	ch->ch_fepastopc = 0;
-	ch->ch_mostat = 0;
-	ch->ch_hflow = 0;
-}
-
-/*=======================================================================
- *
- *      dgap_param - Set Digi parameters.
- *
- *              struct tty_struct *     - TTY for port.
+ * dgap_tty_register()
  *
- *=======================================================================*/
-static int dgap_param(struct channel_t *ch, struct board_t *bd, u32 un_type)
+ * Init the tty subsystem for this board.
+ */
+static int dgap_tty_register(struct board_t *brd)
 {
-	u16 head;
-	u16 cflag;
-	u16 iflag;
-	u8 mval;
-	u8 hflow;
-
-	/*
-	 * If baud rate is zero, flush queues, and set mval to drop DTR.
-	 */
-	if ((ch->ch_c_cflag & (CBAUD)) == 0) {
-
-		/* flush rx */
-		head = readw(&(ch->ch_bs->rx_head));
-		writew(head, &(ch->ch_bs->rx_tail));
-
-		/* flush tx */
-		head = readw(&(ch->ch_bs->tx_head));
-		writew(head, &(ch->ch_bs->tx_tail));
-
-		ch->ch_flags |= (CH_BAUD0);
-
-		/* Drop RTS and DTR */
-		ch->ch_mval &= ~(D_RTS(ch)|D_DTR(ch));
-		mval = D_DTR(ch) | D_RTS(ch);
-		ch->ch_baud_info = 0;
-
-	} else if (ch->ch_custom_speed && (bd->bd_flags & BD_FEP5PLUS)) {
-		/*
-		 * Tell the fep to do the command
-		 */
-
-		dgap_cmdw_ext(ch, 0xff01, ch->ch_custom_speed, 0);
-
-		/*
-		 * Now go get from fep mem, what the fep
-		 * believes the custom baud rate is.
-		 */
-		ch->ch_custom_speed = dgap_get_custom_baud(ch);
-		ch->ch_baud_info = ch->ch_custom_speed;
-
-		/* Handle transition from B0 */
-		if (ch->ch_flags & CH_BAUD0) {
-			ch->ch_flags &= ~(CH_BAUD0);
-			ch->ch_mval |= (D_RTS(ch)|D_DTR(ch));
-		}
-		mval = D_DTR(ch) | D_RTS(ch);
-
-	} else {
-		/*
-		 * Set baud rate, character size, and parity.
-		 */
-
-
-		int iindex = 0;
-		int jindex = 0;
-		int baud = 0;
-
-		ulong bauds[4][16] = {
-			{ /* slowbaud */
-				0,	50,	75,	110,
-				134,	150,	200,	300,
-				600,	1200,	1800,	2400,
-				4800,	9600,	19200,	38400 },
-			{ /* slowbaud & CBAUDEX */
-				0,	57600,	115200,	230400,
-				460800,	150,	200,	921600,
-				600,	1200,	1800,	2400,
-				4800,	9600,	19200,	38400 },
-			{ /* fastbaud */
-				0,	57600,	76800,	115200,
-				14400,	57600,	230400,	76800,
-				115200,	230400,	28800,	460800,
-				921600,	9600,	19200,	38400 },
-			{ /* fastbaud & CBAUDEX */
-				0,	57600,	115200,	230400,
-				460800,	150,	200,	921600,
-				600,	1200,	1800,	2400,
-				4800,	9600,	19200,	38400 }
-		};
-
-		/*
-		 * Only use the TXPrint baud rate if the
-		 * terminal unit is NOT open
-		 */
-		if (!(ch->ch_tun.un_flags & UN_ISOPEN) &&
-		    un_type == DGAP_PRINT)
-			baud = C_BAUD(ch->ch_pun.un_tty) & 0xff;
-		else
-			baud = C_BAUD(ch->ch_tun.un_tty) & 0xff;
-
-		if (ch->ch_c_cflag & CBAUDEX)
-			iindex = 1;
-
-		if (ch->ch_digi.digi_flags & DIGI_FAST)
-			iindex += 2;
-
-		jindex = baud;
-
-		if ((iindex >= 0) && (iindex < 4) &&
-		    (jindex >= 0) && (jindex < 16))
-			baud = bauds[iindex][jindex];
-		else
-			baud = 0;
-
-		if (baud == 0)
-			baud = 9600;
-
-		ch->ch_baud_info = baud;
-
-		/*
-		 * CBAUD has bit position 0x1000 set these days to
-		 * indicate Linux baud rate remap.
-		 * We use a different bit assignment for high speed.
-		 * Clear this bit out while grabbing the parts of
-		 * "cflag" we want.
-		 */
-		cflag = ch->ch_c_cflag & ((CBAUD ^ CBAUDEX) | PARODD | PARENB |
-						   CSTOPB | CSIZE);
-
-		/*
-		 * HUPCL bit is used by FEP to indicate fast baud
-		 * table is to be used.
-		 */
-		if ((ch->ch_digi.digi_flags & DIGI_FAST) ||
-		    (ch->ch_c_cflag & CBAUDEX))
-			cflag |= HUPCL;
-
-		if ((ch->ch_c_cflag & CBAUDEX) &&
-		    !(ch->ch_digi.digi_flags & DIGI_FAST)) {
-			/*
-			 * The below code is trying to guarantee that only
-			 * baud rates 115200, 230400, 460800, 921600 are
-			 * remapped. We use exclusive or  because the various
-			 * baud rates share common bit positions and therefore
-			 * can't be tested for easily.
-			 */
-			tcflag_t tcflag = (ch->ch_c_cflag & CBAUD) | CBAUDEX;
-			int baudpart = 0;
-
-			/*
-			 * Map high speed requests to index
-			 * into FEP's baud table
-			 */
-			switch (tcflag) {
-			case B57600:
-				baudpart = 1;
-				break;
-#ifdef B76800
-			case B76800:
-				baudpart = 2;
-				break;
-#endif
-			case B115200:
-				baudpart = 3;
-				break;
-			case B230400:
-				baudpart = 9;
-				break;
-			case B460800:
-				baudpart = 11;
-				break;
-#ifdef B921600
-			case B921600:
-				baudpart = 12;
-				break;
-#endif
-			default:
-				baudpart = 0;
-			}
-
-			if (baudpart)
-				cflag = (cflag & ~(CBAUD | CBAUDEX)) | baudpart;
-		}
-
-		cflag &= 0xffff;
-
-		if (cflag != ch->ch_fepcflag) {
-			ch->ch_fepcflag = (u16) (cflag & 0xffff);
-
-			/*
-			 * Okay to have channel and board
-			 * locks held calling this
-			 */
-			dgap_cmdw(ch, SCFLAG, (u16) cflag, 0);
-		}
-
-		/* Handle transition from B0 */
-		if (ch->ch_flags & CH_BAUD0) {
-			ch->ch_flags &= ~(CH_BAUD0);
-			ch->ch_mval |= (D_RTS(ch)|D_DTR(ch));
-		}
-		mval = D_DTR(ch) | D_RTS(ch);
-	}
-
-	/*
-	 * Get input flags.
-	 */
-	iflag = ch->ch_c_iflag & (IGNBRK | BRKINT | IGNPAR | PARMRK |
-				  INPCK | ISTRIP | IXON | IXANY | IXOFF);
-
-	if ((ch->ch_startc == _POSIX_VDISABLE) ||
-	    (ch->ch_stopc == _POSIX_VDISABLE)) {
-		iflag &= ~(IXON | IXOFF);
-		ch->ch_c_iflag &= ~(IXON | IXOFF);
-	}
-
-	/*
-	 * Only the IBM Xr card can switch between
-	 * 232 and 422 modes on the fly
-	 */
-	if (bd->device == PCI_DEV_XR_IBM_DID) {
-		if (ch->ch_digi.digi_flags & DIGI_422)
-			dgap_cmdb(ch, SCOMMODE, MODE_422, 0, 0);
-		else
-			dgap_cmdb(ch, SCOMMODE, MODE_232, 0, 0);
-	}
+	int rc;
 
-	if (ch->ch_digi.digi_flags & DIGI_ALTPIN)
-		iflag |= IALTPIN;
+	brd->serial_driver = tty_alloc_driver(MAXPORTS, 0);
+	if (IS_ERR(brd->serial_driver))
+		return PTR_ERR(brd->serial_driver);
 
-	if (iflag != ch->ch_fepiflag) {
-		ch->ch_fepiflag = iflag;
+	snprintf(brd->serial_name, MAXTTYNAMELEN, "tty_dgap_%d_",
+		 brd->boardnum);
+	brd->serial_driver->name = brd->serial_name;
+	brd->serial_driver->name_base = 0;
+	brd->serial_driver->major = 0;
+	brd->serial_driver->minor_start = 0;
+	brd->serial_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	brd->serial_driver->subtype = SERIAL_TYPE_NORMAL;
+	brd->serial_driver->init_termios = dgap_default_termios;
+	brd->serial_driver->driver_name = DRVSTR;
+	brd->serial_driver->flags = (TTY_DRIVER_REAL_RAW |
+				    TTY_DRIVER_DYNAMIC_DEV |
+				    TTY_DRIVER_HARDWARE_BREAK);
 
-		/* Okay to have channel and board locks held calling this */
-		dgap_cmdw(ch, SIFLAG, (u16) ch->ch_fepiflag, 0);
+	/* The kernel wants space to store pointers to tty_structs */
+	brd->serial_driver->ttys =
+		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
+	if (!brd->serial_driver->ttys) {
+		rc = -ENOMEM;
+		goto free_serial_drv;
 	}
 
 	/*
-	 * Select hardware handshaking.
+	 * Entry points for driver.  Called by the kernel from
+	 * tty_io.c and n_tty.c.
 	 */
-	hflow = 0;
-
-	if (ch->ch_c_cflag & CRTSCTS)
-		hflow |= (D_RTS(ch) | D_CTS(ch));
-	if (ch->ch_digi.digi_flags & RTSPACE)
-		hflow |= D_RTS(ch);
-	if (ch->ch_digi.digi_flags & DTRPACE)
-		hflow |= D_DTR(ch);
-	if (ch->ch_digi.digi_flags & CTSPACE)
-		hflow |= D_CTS(ch);
-	if (ch->ch_digi.digi_flags & DSRPACE)
-		hflow |= D_DSR(ch);
-	if (ch->ch_digi.digi_flags & DCDPACE)
-		hflow |= D_CD(ch);
-
-	if (hflow != ch->ch_hflow) {
-		ch->ch_hflow = hflow;
-
-		/* Okay to have channel and board locks held calling this */
-		dgap_cmdb(ch, SHFLOW, (u8) hflow, 0xff, 0);
-	}
+	tty_set_operations(brd->serial_driver, &dgap_tty_ops);
 
 	/*
-	 * Set RTS and/or DTR Toggle if needed,
-	 * but only if product is FEP5+ based.
+	 * If we're doing transparent print, we have to do all of the above
+	 * again, separately so we don't get the LD confused about what major
+	 * we are when we get into the dgap_tty_open() routine.
 	 */
-	if (bd->bd_flags & BD_FEP5PLUS) {
-		u16 hflow2 = 0;
-
-		if (ch->ch_digi.digi_flags & DIGI_RTS_TOGGLE)
-			hflow2 |= (D_RTS(ch));
-		if (ch->ch_digi.digi_flags & DIGI_DTR_TOGGLE)
-			hflow2 |= (D_DTR(ch));
-
-		dgap_cmdw_ext(ch, 0xff03, hflow2, 0);
+	brd->print_driver = tty_alloc_driver(MAXPORTS, 0);
+	if (IS_ERR(brd->print_driver)) {
+		rc = PTR_ERR(brd->print_driver);
+		goto free_serial_drv;
 	}
 
-	/*
-	 * Set modem control lines.
-	 */
-
-	mval ^= ch->ch_mforce & (mval ^ ch->ch_mval);
-
-	if (ch->ch_mostat ^ mval) {
-		ch->ch_mostat = mval;
+	snprintf(brd->print_name, MAXTTYNAMELEN, "pr_dgap_%d_",
+		 brd->boardnum);
+	brd->print_driver->name = brd->print_name;
+	brd->print_driver->name_base = 0;
+	brd->print_driver->major = 0;
+	brd->print_driver->minor_start = 0;
+	brd->print_driver->type = TTY_DRIVER_TYPE_SERIAL;
+	brd->print_driver->subtype = SERIAL_TYPE_NORMAL;
+	brd->print_driver->init_termios = dgap_default_termios;
+	brd->print_driver->driver_name = DRVSTR;
+	brd->print_driver->flags = (TTY_DRIVER_REAL_RAW |
+				   TTY_DRIVER_DYNAMIC_DEV |
+				   TTY_DRIVER_HARDWARE_BREAK);
 
-		/* Okay to have channel and board locks held calling this */
-		dgap_cmdb(ch, SMODEM, (u8) mval, D_RTS(ch)|D_DTR(ch), 0);
+	/* The kernel wants space to store pointers to tty_structs */
+	brd->print_driver->ttys =
+		kzalloc(MAXPORTS * sizeof(struct tty_struct *), GFP_KERNEL);
+	if (!brd->print_driver->ttys) {
+		rc = -ENOMEM;
+		goto free_print_drv;
 	}
 
 	/*
-	 * Read modem signals, and then call carrier function.
+	 * Entry points for driver.  Called by the kernel from
+	 * tty_io.c and n_tty.c.
 	 */
-	ch->ch_mistat = readb(&(ch->ch_bs->m_stat));
-	dgap_carrier(ch);
+	tty_set_operations(brd->print_driver, &dgap_tty_ops);
 
-	/*
-	 * Set the start and stop characters.
-	 */
-	if (ch->ch_startc != ch->ch_fepstartc ||
-	    ch->ch_stopc != ch->ch_fepstopc) {
-		ch->ch_fepstartc = ch->ch_startc;
-		ch->ch_fepstopc =  ch->ch_stopc;
+	/* Register tty devices */
+	rc = tty_register_driver(brd->serial_driver);
+	if (rc < 0)
+		goto free_print_drv;
 
-		/* Okay to have channel and board locks held calling this */
-		dgap_cmdb(ch, SFLOWC, ch->ch_fepstartc, ch->ch_fepstopc, 0);
-	}
+	/* Register Transparent Print devices */
+	rc = tty_register_driver(brd->print_driver);
+	if (rc < 0)
+		goto unregister_serial_drv;
 
-	/*
-	 * Set the Auxiliary start and stop characters.
-	 */
-	if (ch->ch_astartc != ch->ch_fepastartc ||
-	    ch->ch_astopc != ch->ch_fepastopc) {
-		ch->ch_fepastartc = ch->ch_astartc;
-		ch->ch_fepastopc = ch->ch_astopc;
+	dgap_boards_by_major[brd->serial_driver->major] = brd;
+	brd->dgap_serial_major = brd->serial_driver->major;
 
-		/* Okay to have channel and board locks held calling this */
-		dgap_cmdb(ch, SAFLOWC, ch->ch_fepastartc, ch->ch_fepastopc, 0);
-	}
+	dgap_boards_by_major[brd->print_driver->major] = brd;
+	brd->dgap_transparent_print_major = brd->print_driver->major;
 
 	return 0;
-}
-
-/*
- * dgap_parity_scan()
- *
- * Convert the FEP5 way of reporting parity errors and breaks into
- * the Linux line discipline way.
- */
-static void dgap_parity_scan(struct channel_t *ch, unsigned char *cbuf,
-				unsigned char *fbuf, int *len)
-{
-	int l = *len;
-	int count = 0;
-	unsigned char *in, *cout, *fout;
-	unsigned char c;
-
-	in = cbuf;
-	cout = cbuf;
-	fout = fbuf;
-
-	if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-		return;
-
-	while (l--) {
-		c = *in++;
-		switch (ch->pscan_state) {
-		default:
-			/* reset to sanity and fall through */
-			ch->pscan_state = 0;
-
-		case 0:
-			/* No FF seen yet */
-			if (c == (unsigned char) '\377')
-				/* delete this character from stream */
-				ch->pscan_state = 1;
-			else {
-				*cout++ = c;
-				*fout++ = TTY_NORMAL;
-				count += 1;
-			}
-			break;
-
-		case 1:
-			/* first FF seen */
-			if (c == (unsigned char) '\377') {
-				/* doubled ff, transform to single ff */
-				*cout++ = c;
-				*fout++ = TTY_NORMAL;
-				count += 1;
-				ch->pscan_state = 0;
-			} else {
-				/* save value examination in next state */
-				ch->pscan_savechar = c;
-				ch->pscan_state = 2;
-			}
-			break;
-
-		case 2:
-			/* third character of ff sequence */
 
-			*cout++ = c;
-
-			if (ch->pscan_savechar == 0x0) {
-
-				if (c == 0x0) {
-					ch->ch_err_break++;
-					*fout++ = TTY_BREAK;
-				} else {
-					ch->ch_err_parity++;
-					*fout++ = TTY_PARITY;
-				}
-			}
+unregister_serial_drv:
+	tty_unregister_driver(brd->serial_driver);
+free_print_drv:
+	put_tty_driver(brd->print_driver);
+free_serial_drv:
+	put_tty_driver(brd->serial_driver);
 
-			count += 1;
-			ch->pscan_state = 0;
-		}
-	}
-	*len = count;
+	return rc;
 }
 
-static void dgap_write_wakeup(struct board_t *bd, struct channel_t *ch,
-			      struct un_t *un, u32 mask,
-			      unsigned long *irq_flags1,
-			      unsigned long *irq_flags2)
+static void dgap_tty_unregister(struct board_t *brd)
 {
-	if (!(un->un_flags & mask))
-		return;
-
-	un->un_flags &= ~mask;
-
-	if (!(un->un_flags & UN_ISOPEN))
-		return;
-
-	if ((un->un_tty->flags & (1 << TTY_DO_WRITE_WAKEUP)) &&
-	    un->un_tty->ldisc->ops->write_wakeup) {
-		spin_unlock_irqrestore(&ch->ch_lock, *irq_flags2);
-		spin_unlock_irqrestore(&bd->bd_lock, *irq_flags1);
-
-		(un->un_tty->ldisc->ops->write_wakeup)(un->un_tty);
-
-		spin_lock_irqsave(&bd->bd_lock, *irq_flags1);
-		spin_lock_irqsave(&ch->ch_lock, *irq_flags2);
-	}
-	wake_up_interruptible(&un->un_tty->write_wait);
-	wake_up_interruptible(&un->un_flags_wait);
+	tty_unregister_driver(brd->print_driver);
+	tty_unregister_driver(brd->serial_driver);
+	put_tty_driver(brd->print_driver);
+	put_tty_driver(brd->serial_driver);
 }
 
-/*=======================================================================
- *
- *      dgap_event - FEP to host event processing routine.
- *
- *              bd     - Board of current event.
- *
- *=======================================================================*/
-static int dgap_event(struct board_t *bd)
+static int dgap_alloc_flipbuf(struct board_t *brd)
 {
-	struct channel_t *ch;
-	ulong lock_flags;
-	ulong lock_flags2;
-	struct bs_t __iomem *bs;
-	u8 __iomem *event;
-	u8 __iomem *vaddr;
-	struct ev_t __iomem *eaddr;
-	uint head;
-	uint tail;
-	int port;
-	int reason;
-	int modem;
-	int b1;
-
-	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
-		return -EIO;
-
-	spin_lock_irqsave(&bd->bd_lock, lock_flags);
-
-	vaddr = bd->re_map_membase;
-
-	if (!vaddr) {
-		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return -EIO;
-	}
-
-	eaddr = (struct ev_t __iomem *) (vaddr + EVBUF);
-
-	/* Get our head and tail */
-	head = readw(&(eaddr->ev_head));
-	tail = readw(&(eaddr->ev_tail));
-
-	/*
-	 * Forget it if pointers out of range.
-	 */
-
-	if (head >= EVMAX - EVSTART || tail >= EVMAX - EVSTART ||
-	    (head | tail) & 03) {
-		/* Let go of board lock */
-		spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-		return -EIO;
-	}
-
 	/*
-	 * Loop to process all the events in the buffer.
+	 * allocate flip buffer for board.
 	 */
-	while (tail != head) {
-
-		/*
-		 * Get interrupt information.
-		 */
-
-		event = bd->re_map_membase + tail + EVSTART;
-
-		port   = ioread8(event);
-		reason = ioread8(event + 1);
-		modem  = ioread8(event + 2);
-		b1     = ioread8(event + 3);
-
-		/*
-		 * Make sure the interrupt is valid.
-		 */
-		if (port >= bd->nasync)
-			goto next;
-
-		if (!(reason & (IFMODEM | IFBREAK | IFTLW | IFTEM | IFDATA)))
-			goto next;
-
-		ch = bd->channels[port];
-
-		if (!ch || ch->magic != DGAP_CHANNEL_MAGIC)
-			goto next;
-
-		/*
-		 * If we have made it here, the event was valid.
-		 * Lock down the channel.
-		 */
-		spin_lock_irqsave(&ch->ch_lock, lock_flags2);
-
-		bs = ch->ch_bs;
-
-		if (!bs) {
-			spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-			goto next;
-		}
-
-		/*
-		 * Process received data.
-		 */
-		if (reason & IFDATA) {
-
-			/*
-			 * ALL LOCKS *MUST* BE DROPPED BEFORE CALLING INPUT!
-			 * input could send some data to ld, which in turn
-			 * could do a callback to one of our other functions.
-			 */
-			spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
-			spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-
-			dgap_input(ch);
-
-			spin_lock_irqsave(&bd->bd_lock, lock_flags);
-			spin_lock_irqsave(&ch->ch_lock, lock_flags2);
-
-			if (ch->ch_flags & CH_RACTIVE)
-				ch->ch_flags |= CH_RENABLE;
-			else
-				writeb(1, &(bs->idata));
-
-			if (ch->ch_flags & CH_RWAIT) {
-				ch->ch_flags &= ~CH_RWAIT;
-
-				wake_up_interruptible
-					(&ch->ch_tun.un_flags_wait);
-			}
-		}
-
-		/*
-		 * Process Modem change signals.
-		 */
-		if (reason & IFMODEM) {
-			ch->ch_mistat = modem;
-			dgap_carrier(ch);
-		}
-
-		/*
-		 * Process break.
-		 */
-		if (reason & IFBREAK) {
-
-			if (ch->ch_tun.un_tty) {
-				/* A break has been indicated */
-				ch->ch_err_break++;
-				tty_buffer_request_room
-					(ch->ch_tun.un_tty->port, 1);
-				tty_insert_flip_char(ch->ch_tun.un_tty->port,
-						     0, TTY_BREAK);
-				tty_flip_buffer_push(ch->ch_tun.un_tty->port);
-			}
-		}
-
-		/*
-		 * Process Transmit low.
-		 */
-		if (reason & IFTLW) {
-			dgap_write_wakeup(bd, ch, &ch->ch_tun, UN_LOW,
-					  &lock_flags, &lock_flags2);
-			dgap_write_wakeup(bd, ch, &ch->ch_pun, UN_LOW,
-					  &lock_flags, &lock_flags2);
-			if (ch->ch_flags & CH_WLOW) {
-				ch->ch_flags &= ~CH_WLOW;
-				wake_up_interruptible(&ch->ch_flags_wait);
-			}
-		}
-
-		/*
-		 * Process Transmit empty.
-		 */
-		if (reason & IFTEM) {
-			dgap_write_wakeup(bd, ch, &ch->ch_tun, UN_EMPTY,
-					  &lock_flags, &lock_flags2);
-			dgap_write_wakeup(bd, ch, &ch->ch_pun, UN_EMPTY,
-					  &lock_flags, &lock_flags2);
-			if (ch->ch_flags & CH_WEMPTY) {
-				ch->ch_flags &= ~CH_WEMPTY;
-				wake_up_interruptible(&ch->ch_flags_wait);
-			}
-		}
-
-		spin_unlock_irqrestore(&ch->ch_lock, lock_flags2);
+	brd->flipbuf = kmalloc(MYFLIPLEN, GFP_KERNEL);
+	if (!brd->flipbuf)
+		return -ENOMEM;
 
-next:
-		tail = (tail + 4) & (EVMAX - EVSTART - 4);
+	brd->flipflagbuf = kmalloc(MYFLIPLEN, GFP_KERNEL);
+	if (!brd->flipflagbuf) {
+		kfree(brd->flipbuf);
+		return -ENOMEM;
 	}
 
-	writew(tail, &(eaddr->ev_tail));
-	spin_unlock_irqrestore(&bd->bd_lock, lock_flags);
-
 	return 0;
 }
 
-static ssize_t dgap_driver_version_show(struct device_driver *ddp, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%s\n", DG_PART);
-}
-static DRIVER_ATTR(version, S_IRUSR, dgap_driver_version_show, NULL);
-
-
-static ssize_t dgap_driver_boards_show(struct device_driver *ddp, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", dgap_numboards);
-}
-static DRIVER_ATTR(boards, S_IRUSR, dgap_driver_boards_show, NULL);
-
-
-static ssize_t dgap_driver_maxboards_show(struct device_driver *ddp, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", MAXBOARDS);
-}
-static DRIVER_ATTR(maxboards, S_IRUSR, dgap_driver_maxboards_show, NULL);
-
-
-static ssize_t dgap_driver_pollcounter_show(struct device_driver *ddp,
-					    char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%ld\n", dgap_poll_counter);
-}
-static DRIVER_ATTR(pollcounter, S_IRUSR, dgap_driver_pollcounter_show, NULL);
-
-static ssize_t dgap_driver_pollrate_show(struct device_driver *ddp, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%dms\n", dgap_poll_tick);
-}
-
-static ssize_t dgap_driver_pollrate_store(struct device_driver *ddp,
-					  const char *buf, size_t count)
-{
-	if (sscanf(buf, "%d\n", &dgap_poll_tick) != 1)
-		return -EINVAL;
-	return count;
-}
-static DRIVER_ATTR(pollrate, (S_IRUSR | S_IWUSR), dgap_driver_pollrate_show,
-		   dgap_driver_pollrate_store);
-
-static int dgap_create_driver_sysfiles(struct pci_driver *dgap_driver)
-{
-	int rc = 0;
-	struct device_driver *driverfs = &dgap_driver->driver;
-
-	rc |= driver_create_file(driverfs, &driver_attr_version);
-	rc |= driver_create_file(driverfs, &driver_attr_boards);
-	rc |= driver_create_file(driverfs, &driver_attr_maxboards);
-	rc |= driver_create_file(driverfs, &driver_attr_pollrate);
-	rc |= driver_create_file(driverfs, &driver_attr_pollcounter);
-
-	return rc;
-}
-
-static void dgap_remove_driver_sysfiles(struct pci_driver *dgap_driver)
+static void dgap_free_flipbuf(struct board_t *brd)
 {
-	struct device_driver *driverfs = &dgap_driver->driver;
-
-	driver_remove_file(driverfs, &driver_attr_version);
-	driver_remove_file(driverfs, &driver_attr_boards);
-	driver_remove_file(driverfs, &driver_attr_maxboards);
-	driver_remove_file(driverfs, &driver_attr_pollrate);
-	driver_remove_file(driverfs, &driver_attr_pollcounter);
+	kfree(brd->flipbuf);
+	kfree(brd->flipflagbuf);
 }
 
 static struct board_t *dgap_verify_board(struct device *p)
@@ -5843,39 +5600,6 @@ static ssize_t dgap_ports_txcount_show(struct device *p,
 }
 static DEVICE_ATTR(ports_txcount, S_IRUSR, dgap_ports_txcount_show, NULL);
 
-/* this function creates the sys files that will export each signal status
- * to sysfs each value will be put in a separate filename
- */
-static void dgap_create_ports_sysfiles(struct board_t *bd)
-{
-	dev_set_drvdata(&bd->pdev->dev, bd);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_state);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_baud);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_msignals);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_iflag);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_cflag);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_oflag);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_lflag);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_digi_flag);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_rxcount);
-	device_create_file(&(bd->pdev->dev), &dev_attr_ports_txcount);
-}
-
-/* removes all the sys files created for that port */
-static void dgap_remove_ports_sysfiles(struct board_t *bd)
-{
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_state);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_baud);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_msignals);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_iflag);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_cflag);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_oflag);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_lflag);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_digi_flag);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_rxcount);
-	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_txcount);
-}
-
 static ssize_t dgap_tty_state_show(struct device *d,
 				   struct device_attribute *attr,
 				   char *buf)
@@ -6270,1086 +5994,1238 @@ static struct attribute *dgap_sysfs_tty_entries[] = {
 	NULL
 };
 
-static struct attribute_group dgap_tty_attribute_group = {
-	.name = NULL,
-	.attrs = dgap_sysfs_tty_entries,
-};
 
-static void dgap_create_tty_sysfs(struct un_t *un, struct device *c)
+/* this function creates the sys files that will export each signal status
+ * to sysfs each value will be put in a separate filename
+ */
+static void dgap_create_ports_sysfiles(struct board_t *bd)
 {
-	int ret;
+	dev_set_drvdata(&bd->pdev->dev, bd);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_state);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_baud);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_msignals);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_iflag);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_cflag);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_oflag);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_lflag);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_digi_flag);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_rxcount);
+	device_create_file(&(bd->pdev->dev), &dev_attr_ports_txcount);
+}
 
-	ret = sysfs_create_group(&c->kobj, &dgap_tty_attribute_group);
-	if (ret)
+/* removes all the sys files created for that port */
+static void dgap_remove_ports_sysfiles(struct board_t *bd)
+{
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_state);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_baud);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_msignals);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_iflag);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_cflag);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_oflag);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_lflag);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_digi_flag);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_rxcount);
+	device_remove_file(&(bd->pdev->dev), &dev_attr_ports_txcount);
+}
+
+/*
+ * Copies the BIOS code from the user to the board,
+ * and starts the BIOS running.
+ */
+static void dgap_do_bios_load(struct board_t *brd, const u8 *ubios, int len)
+{
+	u8 __iomem *addr;
+	uint offset;
+	int i;
+
+	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
 		return;
 
-	dev_set_drvdata(c, un);
+	addr = brd->re_map_membase;
+
+	/*
+	 * clear POST area
+	 */
+	for (i = 0; i < 16; i++)
+		writeb(0, addr + POSTAREA + i);
+
+	/*
+	 * Download bios
+	 */
+	offset = 0x1000;
+	memcpy_toio(addr + offset, ubios, len);
 
+	writel(0x0bf00401, addr);
+	writel(0, (addr + 4));
+
+	/* Clear the reset, and change states. */
+	writeb(FEPCLR, brd->re_map_port);
 }
 
-static void dgap_remove_tty_sysfs(struct device *c)
+/*
+ * Checks to see if the BIOS completed running on the card.
+ */
+static int dgap_test_bios(struct board_t *brd)
 {
-	sysfs_remove_group(&c->kobj, &dgap_tty_attribute_group);
+	u8 __iomem *addr;
+	u16 word;
+	u16 err1;
+	u16 err2;
+
+	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
+		return -EINVAL;
+
+	addr = brd->re_map_membase;
+	word = readw(addr + POSTAREA);
+
+	/*
+	 * It can take 5-6 seconds for a board to
+	 * pass the bios self test and post results.
+	 * Give it 10 seconds.
+	 */
+	brd->wait_for_bios = 0;
+	while (brd->wait_for_bios < 1000) {
+		/* Check to see if BIOS thinks board is good. (GD). */
+		if (word == *(u16 *) "GD")
+			return 0;
+		msleep_interruptible(10);
+		brd->wait_for_bios++;
+		word = readw(addr + POSTAREA);
+	}
+
+	/* Gave up on board after too long of time taken */
+	err1 = readw(addr + SEQUENCE);
+	err2 = readw(addr + ERROR);
+	dev_warn(&brd->pdev->dev, "%s failed diagnostics.  Error #(%x,%x).\n",
+		brd->name, err1, err2);
+	brd->state = BOARD_FAILED;
+	brd->dpastatus = BD_NOBIOS;
+
+	return -EIO;
 }
 
-static void dgap_cleanup_nodes(void)
+/*
+ * Copies the FEP code from the user to the board,
+ * and starts the FEP running.
+ */
+static void dgap_do_fep_load(struct board_t *brd, const u8 *ufep, int len)
 {
-	struct cnode *p;
+	u8 __iomem *addr;
+	uint offset;
 
-	p = &dgap_head;
+	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
+		return;
 
-	while (p) {
-		struct cnode *tmp = p->next;
+	addr = brd->re_map_membase;
 
-		if (p->type == NULLNODE) {
-			p = tmp;
-			continue;
-		}
+	/*
+	 * Download FEP
+	 */
+	offset = 0x1000;
+	memcpy_toio(addr + offset, ufep, len);
 
-		switch (p->type) {
-		case BNODE:
-			kfree(p->u.board.portstr);
-			kfree(p->u.board.addrstr);
-			kfree(p->u.board.pcibusstr);
-			kfree(p->u.board.pcislotstr);
-			kfree(p->u.board.method);
-			break;
-		case CNODE:
-			kfree(p->u.conc.id);
-			kfree(p->u.conc.connect);
-			break;
-		case MNODE:
-			kfree(p->u.module.id);
-			break;
-		case TNODE:
-			kfree(p->u.ttyname);
-			break;
-		case CUNODE:
-			kfree(p->u.cuname);
-			break;
-		case LNODE:
-			kfree(p->u.line.cable);
-			break;
-		case PNODE:
-			kfree(p->u.printname);
-			break;
-		}
+	/*
+	 * If board is a concentrator product, we need to give
+	 * it its config string describing how the concentrators look.
+	 */
+	if ((brd->type == PCX) || (brd->type == PEPC)) {
+		u8 string[100];
+		u8 __iomem *config;
+		u8 *xconfig;
+		int i = 0;
 
-		kfree(p->u.board.status);
-		kfree(p);
-		p = tmp;
+		xconfig = dgap_create_config_string(brd, string);
+
+		/* Write string to board memory */
+		config = addr + CONFIG;
+		for (; i < CONFIGSIZE; i++, config++, xconfig++) {
+			writeb(*xconfig, config);
+			if ((*xconfig & 0xff) == 0xff)
+				break;
+		}
 	}
+
+	writel(0xbfc01004, (addr + 0xc34));
+	writel(0x3, (addr + 0xc30));
+
 }
+
 /*
- * Parse a configuration file read into memory as a string.
+ * Waits for the FEP to report thats its ready for us to use.
  */
-static int dgap_parsefile(char **in)
+static int dgap_test_fep(struct board_t *brd)
 {
-	struct cnode *p, *brd, *line, *conc;
-	int rc;
-	char *s;
-	int linecnt = 0;
+	u8 __iomem *addr;
+	u16 word;
+	u16 err1;
+	u16 err2;
 
-	p = &dgap_head;
-	brd = line = conc = NULL;
+	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
+		return -EINVAL;
 
-	/* perhaps we are adding to an existing list? */
-	while (p->next)
-		p = p->next;
+	addr = brd->re_map_membase;
+	word = readw(addr + FEPSTAT);
 
-	/* file must start with a BEGIN */
-	while ((rc = dgap_gettok(in)) != BEGIN) {
-		if (rc == 0) {
-			pr_err("unexpected EOF");
-			return -1;
+	/*
+	 * It can take 2-3 seconds for the FEP to
+	 * be up and running. Give it 5 secs.
+	 */
+	brd->wait_for_fep = 0;
+	while (brd->wait_for_fep < 500) {
+		/* Check to see if FEP is up and running now. */
+		if (word == *(u16 *) "OS") {
+			/*
+			 * Check to see if the board can support FEP5+ commands.
+			*/
+			word = readw(addr + FEP5_PLUS);
+			if (word == *(u16 *) "5A")
+				brd->bd_flags |= BD_FEP5PLUS;
+
+			return 0;
 		}
+		msleep_interruptible(10);
+		brd->wait_for_fep++;
+		word = readw(addr + FEPSTAT);
 	}
 
-	for (; ;) {
-		int board_type = 0;
-		int conc_type = 0;
-		int module_type = 0;
+	/* Gave up on board after too long of time taken */
+	err1 = readw(addr + SEQUENCE);
+	err2 = readw(addr + ERROR);
+	dev_warn(&brd->pdev->dev,
+		 "FEPOS for %s not functioning.  Error #(%x,%x).\n",
+		 brd->name, err1, err2);
+	brd->state = BOARD_FAILED;
+	brd->dpastatus = BD_NOFEP;
 
-		rc = dgap_gettok(in);
-		if (rc == 0) {
-			pr_err("unexpected EOF");
-			return -1;
-		}
+	return -EIO;
+}
 
-		switch (rc) {
-		case BEGIN:	/* should only be 1 begin */
-			pr_err("unexpected config_begin\n");
-			return -1;
+/*
+ * Physically forces the FEP5 card to reset itself.
+ */
+static void dgap_do_reset_board(struct board_t *brd)
+{
+	u8 check;
+	u32 check1;
+	u32 check2;
+	int i;
 
-		case END:
-			return 0;
+	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) ||
+	    !brd->re_map_membase || !brd->re_map_port)
+		return;
 
-		case BOARD:	/* board info */
-			if (dgap_checknode(p))
-				return -1;
+	/* FEPRST does not vary among supported boards */
+	writeb(FEPRST, brd->re_map_port);
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+	for (i = 0; i <= 1000; i++) {
+		check = readb(brd->re_map_port) & 0xe;
+		if (check == FEPRST)
+			break;
+		udelay(10);
 
-			p = p->next;
+	}
+	if (i > 1000) {
+		dev_warn(&brd->pdev->dev,
+			 "dgap: Board not resetting...  Failing board.\n");
+		brd->state = BOARD_FAILED;
+		brd->dpastatus = BD_NOFEP;
+		return;
+	}
 
-			p->type = BNODE;
-			p->u.board.status = kstrdup("No", GFP_KERNEL);
-			line = conc = NULL;
-			brd = p;
-			linecnt = -1;
+	/*
+	 * Make sure there really is memory out there.
+	 */
+	writel(0xa55a3cc3, (brd->re_map_membase + LOWMEM));
+	writel(0x5aa5c33c, (brd->re_map_membase + HIGHMEM));
+	check1 = readl(brd->re_map_membase + LOWMEM);
+	check2 = readl(brd->re_map_membase + HIGHMEM);
 
-			board_type = dgap_gettok(in);
-			if (board_type == 0) {
-				pr_err("board !!type not specified");
-				return -1;
-			}
+	if ((check1 != 0xa55a3cc3) || (check2 != 0x5aa5c33c)) {
+		dev_warn(&brd->pdev->dev,
+			 "No memory at %p for board.\n",
+			 brd->re_map_membase);
+		brd->state = BOARD_FAILED;
+		brd->dpastatus = BD_NOFEP;
+		return;
+	}
+}
 
-			p->u.board.type = board_type;
+#ifdef DIGI_CONCENTRATORS_SUPPORTED
+/*
+ * Sends a concentrator image into the FEP5 board.
+ */
+static void dgap_do_conc_load(struct board_t *brd, u8 *uaddr, int len)
+{
+	char __iomem *vaddr;
+	u16 offset;
+	struct downld_t *to_dp;
 
-			break;
+	if (!brd || (brd->magic != DGAP_BOARD_MAGIC) || !brd->re_map_membase)
+		return;
 
-		case IO:	/* i/o port */
-			if (p->type != BNODE) {
-				pr_err("IO port only vaild for boards");
-				return -1;
-			}
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			p->u.board.portstr = kstrdup(s, GFP_KERNEL);
-			if (kstrtol(s, 0, &p->u.board.port)) {
-				pr_err("bad number for IO port");
-				return -1;
-			}
-			p->u.board.v_port = 1;
-			break;
+	vaddr = brd->re_map_membase;
 
-		case MEM:	/* memory address */
-			if (p->type != BNODE) {
-				pr_err("memory address only vaild for boards");
-				return -1;
-			}
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			p->u.board.addrstr = kstrdup(s, GFP_KERNEL);
-			if (kstrtoul(s, 0, &p->u.board.addr)) {
-				pr_err("bad number for memory address");
-				return -1;
-			}
-			p->u.board.v_addr = 1;
-			break;
+	offset = readw((u16 *) (vaddr + DOWNREQ));
+	to_dp = (struct downld_t *) (vaddr + (int) offset);
+	memcpy_toio(to_dp, uaddr, len);
 
-		case PCIINFO:	/* pci information */
-			if (p->type != BNODE) {
-				pr_err("memory address only vaild for boards");
-				return -1;
-			}
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			p->u.board.pcibusstr = kstrdup(s, GFP_KERNEL);
-			if (kstrtoul(s, 0, &p->u.board.pcibus)) {
-				pr_err("bad number for pci bus");
-				return -1;
-			}
-			p->u.board.v_pcibus = 1;
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			p->u.board.pcislotstr = kstrdup(s, GFP_KERNEL);
-			if (kstrtoul(s, 0, &p->u.board.pcislot)) {
-				pr_err("bad number for pci slot");
-				return -1;
-			}
-			p->u.board.v_pcislot = 1;
-			break;
+	/* Tell card we have data for it */
+	writew(0, vaddr + (DOWNREQ));
 
-		case METHOD:
-			if (p->type != BNODE) {
-				pr_err("install method only vaild for boards");
-				return -1;
-			}
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			p->u.board.method = kstrdup(s, GFP_KERNEL);
-			p->u.board.v_method = 1;
-			break;
+	brd->conc_dl_status = NO_PENDING_CONCENTRATOR_REQUESTS;
+}
+#endif
 
-		case STATUS:
-			if (p->type != BNODE) {
-				pr_err("config status only vaild for boards");
-				return -1;
-			}
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			p->u.board.status = kstrdup(s, GFP_KERNEL);
-			break;
+#define EXPANSION_ROM_SIZE	(64 * 1024)
+#define FEP5_ROM_MAGIC		(0xFEFFFFFF)
 
-		case NPORTS:	/* number of ports */
-			if (p->type == BNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				if (kstrtol(s, 0, &p->u.board.nport)) {
-					pr_err("bad number for number of ports");
-					return -1;
-				}
-				p->u.board.v_nport = 1;
-			} else if (p->type == CNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				if (kstrtol(s, 0, &p->u.conc.nport)) {
-					pr_err("bad number for number of ports");
-					return -1;
-				}
-				p->u.conc.v_nport = 1;
-			} else if (p->type == MNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				if (kstrtol(s, 0, &p->u.module.nport)) {
-					pr_err("bad number for number of ports");
-					return -1;
-				}
-				p->u.module.v_nport = 1;
-			} else {
-				pr_err("nports only valid for concentrators or modules");
-				return -1;
-			}
-			break;
+static void dgap_get_vpd(struct board_t *brd)
+{
+	u32 magic;
+	u32 base_offset;
+	u16 rom_offset;
+	u16 vpd_offset;
+	u16 image_length;
+	u16 i;
+	u8 byte1;
+	u8 byte2;
 
-		case ID:	/* letter ID used in tty name */
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
+	/*
+	 * Poke the magic number at the PCI Rom Address location.
+	 * If VPD is supported, the value read from that address
+	 * will be non-zero.
+	 */
+	magic = FEP5_ROM_MAGIC;
+	pci_write_config_dword(brd->pdev, PCI_ROM_ADDRESS, magic);
+	pci_read_config_dword(brd->pdev, PCI_ROM_ADDRESS, &magic);
 
-			p->u.board.status = kstrdup(s, GFP_KERNEL);
+	/* VPD not supported, bail */
+	if (!magic)
+		return;
 
-			if (p->type == CNODE) {
-				p->u.conc.id = kstrdup(s, GFP_KERNEL);
-				p->u.conc.v_id = 1;
-			} else if (p->type == MNODE) {
-				p->u.module.id = kstrdup(s, GFP_KERNEL);
-				p->u.module.v_id = 1;
-			} else {
-				pr_err("id only valid for concentrators or modules");
-				return -1;
-			}
-			break;
+	/*
+	 * To get to the OTPROM memory, we have to send the boards base
+	 * address or'ed with 1 into the PCI Rom Address location.
+	 */
+	magic = brd->membase | 0x01;
+	pci_write_config_dword(brd->pdev, PCI_ROM_ADDRESS, magic);
+	pci_read_config_dword(brd->pdev, PCI_ROM_ADDRESS, &magic);
 
-		case STARTO:	/* start offset of ID */
-			if (p->type == BNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				if (kstrtol(s, 0, &p->u.board.start)) {
-					pr_err("bad number for start of tty count");
-					return -1;
-				}
-				p->u.board.v_start = 1;
-			} else if (p->type == CNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				if (kstrtol(s, 0, &p->u.conc.start)) {
-					pr_err("bad number for start of tty count");
-					return -1;
-				}
-				p->u.conc.v_start = 1;
-			} else if (p->type == MNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				if (kstrtol(s, 0, &p->u.module.start)) {
-					pr_err("bad number for start of tty count");
-					return -1;
-				}
-				p->u.module.v_start = 1;
-			} else {
-				pr_err("start only valid for concentrators or modules");
-				return -1;
-			}
-			break;
+	byte1 = readb(brd->re_map_membase);
+	byte2 = readb(brd->re_map_membase + 1);
 
-		case TTYN:	/* tty name prefix */
-			if (dgap_checknode(p))
-				return -1;
+	/*
+	 * If the board correctly swapped to the OTPROM memory,
+	 * the first 2 bytes (header) should be 0x55, 0xAA
+	 */
+	if (byte1 == 0x55 && byte2 == 0xAA) {
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+		base_offset = 0;
 
-			p = p->next;
-			p->type = TNODE;
+		/*
+		 * We have to run through all the OTPROM memory looking
+		 * for the VPD offset.
+		 */
+		while (base_offset <= EXPANSION_ROM_SIZE) {
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpeced end of file");
-				return -1;
-			}
-			p->u.ttyname = kstrdup(s, GFP_KERNEL);
-			if (!p->u.ttyname)
-				return -1;
+			/*
+			 * Lots of magic numbers here.
+			 *
+			 * The VPD offset is located inside the ROM Data
+			 * Structure.
+			 *
+			 * We also have to remember the length of each
+			 * ROM Data Structure, so we can "hop" to the next
+			 * entry if the VPD isn't in the current
+			 * ROM Data Structure.
+			 */
+			rom_offset = readw(brd->re_map_membase +
+						base_offset + 0x18);
+			image_length = readw(brd->re_map_membase +
+						rom_offset + 0x10) * 512;
+			vpd_offset = readw(brd->re_map_membase +
+						rom_offset + 0x08);
 
-			break;
+			/* Found the VPD entry */
+			if (vpd_offset)
+				break;
 
-		case CU:	/* cu name prefix */
-			if (dgap_checknode(p))
-				return -1;
+			/* We didn't find a VPD entry, go to next ROM entry. */
+			base_offset += image_length;
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+			byte1 = readb(brd->re_map_membase + base_offset);
+			byte2 = readb(brd->re_map_membase + base_offset + 1);
 
-			p = p->next;
-			p->type = CUNODE;
+			/*
+			 * If the new ROM offset doesn't have 0x55, 0xAA
+			 * as its header, we have run out of ROM.
+			 */
+			if (byte1 != 0x55 || byte2 != 0xAA)
+				break;
+		}
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpeced end of file");
-				return -1;
+		/*
+		 * If we have a VPD offset, then mark the board
+		 * as having a valid VPD, and copy VPDSIZE (512) bytes of
+		 * that VPD to the buffer we have in our board structure.
+		 */
+		if (vpd_offset) {
+			brd->bd_flags |= BD_HAS_VPD;
+			for (i = 0; i < VPDSIZE; i++) {
+				brd->vpd[i] = readb(brd->re_map_membase +
+							vpd_offset + i);
 			}
-			p->u.cuname = kstrdup(s, GFP_KERNEL);
-			if (!p->u.cuname)
-				return -1;
+		}
+	}
 
-			break;
+	/*
+	 * We MUST poke the magic number at the PCI Rom Address location again.
+	 * This makes the card report the regular board memory back to us,
+	 * rather than the OTPROM memory.
+	 */
+	magic = FEP5_ROM_MAGIC;
+	pci_write_config_dword(brd->pdev, PCI_ROM_ADDRESS, magic);
+}
 
-		case LINE:	/* line information */
-			if (dgap_checknode(p))
-				return -1;
-			if (!brd) {
-				pr_err("must specify board before line info");
-				return -1;
-			}
-			switch (brd->u.board.type) {
-			case PPCM:
-				pr_err("line not vaild for PC/em");
-				return -1;
-			}
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+static ssize_t dgap_driver_version_show(struct device_driver *ddp, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", DG_PART);
+}
+static DRIVER_ATTR(version, S_IRUSR, dgap_driver_version_show, NULL);
 
-			p = p->next;
-			p->type = LNODE;
-			conc = NULL;
-			line = p;
-			linecnt++;
-			break;
 
-		case CONC:	/* concentrator information */
-			if (dgap_checknode(p))
-				return -1;
-			if (!line) {
-				pr_err("must specify line info before concentrator");
-				return -1;
-			}
+static ssize_t dgap_driver_boards_show(struct device_driver *ddp, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", dgap_numboards);
+}
+static DRIVER_ATTR(boards, S_IRUSR, dgap_driver_boards_show, NULL);
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
 
-			p = p->next;
-			p->type = CNODE;
-			conc = p;
+static ssize_t dgap_driver_maxboards_show(struct device_driver *ddp, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", MAXBOARDS);
+}
+static DRIVER_ATTR(maxboards, S_IRUSR, dgap_driver_maxboards_show, NULL);
 
-			if (linecnt)
-				brd->u.board.conc2++;
-			else
-				brd->u.board.conc1++;
 
-			conc_type = dgap_gettok(in);
-			if (conc_type == 0 || conc_type != CX ||
-			    conc_type != EPC) {
-				pr_err("failed to set a type of concentratros");
-				return -1;
-			}
+static ssize_t dgap_driver_pollcounter_show(struct device_driver *ddp,
+					    char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%ld\n", dgap_poll_counter);
+}
+static DRIVER_ATTR(pollcounter, S_IRUSR, dgap_driver_pollcounter_show, NULL);
 
-			p->u.conc.type = conc_type;
+static ssize_t dgap_driver_pollrate_show(struct device_driver *ddp, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%dms\n", dgap_poll_tick);
+}
 
-			break;
+static ssize_t dgap_driver_pollrate_store(struct device_driver *ddp,
+					  const char *buf, size_t count)
+{
+	if (sscanf(buf, "%d\n", &dgap_poll_tick) != 1)
+		return -EINVAL;
+	return count;
+}
+static DRIVER_ATTR(pollrate, (S_IRUSR | S_IWUSR), dgap_driver_pollrate_show,
+		   dgap_driver_pollrate_store);
 
-		case MOD:	/* EBI module */
-			if (dgap_checknode(p))
-				return -1;
-			if (!brd) {
-				pr_err("must specify board info before EBI modules");
-				return -1;
-			}
-			switch (brd->u.board.type) {
-			case PPCM:
-				linecnt = 0;
-				break;
-			default:
-				if (!conc) {
-					pr_err("must specify concentrator info before EBI module");
-					return -1;
-				}
-			}
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+static int dgap_create_driver_sysfiles(struct pci_driver *dgap_driver)
+{
+	int rc = 0;
+	struct device_driver *driverfs = &dgap_driver->driver;
 
-			p = p->next;
-			p->type = MNODE;
+	rc |= driver_create_file(driverfs, &driver_attr_version);
+	rc |= driver_create_file(driverfs, &driver_attr_boards);
+	rc |= driver_create_file(driverfs, &driver_attr_maxboards);
+	rc |= driver_create_file(driverfs, &driver_attr_pollrate);
+	rc |= driver_create_file(driverfs, &driver_attr_pollcounter);
 
-			if (linecnt)
-				brd->u.board.module2++;
-			else
-				brd->u.board.module1++;
+	return rc;
+}
 
-			module_type = dgap_gettok(in);
-			if (module_type == 0 || module_type != PORTS ||
-			    module_type != MODEM) {
-				pr_err("failed to set a type of module");
-				return -1;
-			}
+static void dgap_remove_driver_sysfiles(struct pci_driver *dgap_driver)
+{
+	struct device_driver *driverfs = &dgap_driver->driver;
 
-			p->u.module.type = module_type;
+	driver_remove_file(driverfs, &driver_attr_version);
+	driver_remove_file(driverfs, &driver_attr_boards);
+	driver_remove_file(driverfs, &driver_attr_maxboards);
+	driver_remove_file(driverfs, &driver_attr_pollrate);
+	driver_remove_file(driverfs, &driver_attr_pollcounter);
+}
 
-			break;
+static struct attribute_group dgap_tty_attribute_group = {
+	.name = NULL,
+	.attrs = dgap_sysfs_tty_entries,
+};
 
-		case CABLE:
-			if (p->type == LNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				p->u.line.cable = kstrdup(s, GFP_KERNEL);
-				p->u.line.v_cable = 1;
-			}
-			break;
+static void dgap_create_tty_sysfs(struct un_t *un, struct device *c)
+{
+	int ret;
 
-		case SPEED:	/* sync line speed indication */
-			if (p->type == LNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				if (kstrtol(s, 0, &p->u.line.speed)) {
-					pr_err("bad number for line speed");
-					return -1;
-				}
-				p->u.line.v_speed = 1;
-			} else if (p->type == CNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				if (kstrtol(s, 0, &p->u.conc.speed)) {
-					pr_err("bad number for line speed");
-					return -1;
-				}
-				p->u.conc.v_speed = 1;
-			} else {
-				pr_err("speed valid only for lines or concentrators.");
-				return -1;
-			}
-			break;
+	ret = sysfs_create_group(&c->kobj, &dgap_tty_attribute_group);
+	if (ret)
+		return;
 
-		case CONNECT:
-			if (p->type == CNODE) {
-				s = dgap_getword(in);
-				if (!s) {
-					pr_err("unexpected end of file");
-					return -1;
-				}
-				p->u.conc.connect = kstrdup(s, GFP_KERNEL);
-				p->u.conc.v_connect = 1;
-			}
-			break;
-		case PRINT:	/* transparent print name prefix */
-			if (dgap_checknode(p))
-				return -1;
+	dev_set_drvdata(c, un);
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+}
 
-			p = p->next;
-			p->type = PNODE;
+static void dgap_remove_tty_sysfs(struct device *c)
+{
+	sysfs_remove_group(&c->kobj, &dgap_tty_attribute_group);
+}
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpeced end of file");
-				return -1;
-			}
-			p->u.printname = kstrdup(s, GFP_KERNEL);
-			if (!p->u.printname)
-				return -1;
+/*
+ * Create pr and tty device entries
+ */
+static int dgap_tty_register_ports(struct board_t *brd)
+{
+	struct channel_t *ch;
+	int i;
+	int ret;
 
-			break;
+	brd->serial_ports = kcalloc(brd->nasync, sizeof(*brd->serial_ports),
+					GFP_KERNEL);
+	if (!brd->serial_ports)
+		return -ENOMEM;
 
-		case CMAJOR:	/* major number */
-			if (dgap_checknode(p))
-				return -1;
+	brd->printer_ports = kcalloc(brd->nasync, sizeof(*brd->printer_ports),
+					GFP_KERNEL);
+	if (!brd->printer_ports) {
+		ret = -ENOMEM;
+		goto free_serial_ports;
+	}
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+	for (i = 0; i < brd->nasync; i++) {
+		tty_port_init(&brd->serial_ports[i]);
+		tty_port_init(&brd->printer_ports[i]);
+	}
 
-			p = p->next;
-			p->type = JNODE;
+	ch = brd->channels[0];
+	for (i = 0; i < brd->nasync; i++, ch = brd->channels[i]) {
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.majornumber)) {
-				pr_err("bad number for major number");
-				return -1;
-			}
-			break;
+		struct device *classp;
 
-		case ALTPIN:	/* altpin setting */
-			if (dgap_checknode(p))
-				return -1;
+		classp = tty_port_register_device(&brd->serial_ports[i],
+						  brd->serial_driver,
+						  i, NULL);
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+		if (IS_ERR(classp)) {
+			ret = PTR_ERR(classp);
+			goto unregister_ttys;
+		}
 
-			p = p->next;
-			p->type = ANODE;
+		dgap_create_tty_sysfs(&ch->ch_tun, classp);
+		ch->ch_tun.un_sysfs = classp;
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.altpin)) {
-				pr_err("bad number for altpin");
-				return -1;
-			}
-			break;
+		classp = tty_port_register_device(&brd->printer_ports[i],
+						  brd->print_driver,
+						  i, NULL);
 
-		case USEINTR:		/* enable interrupt setting */
-			if (dgap_checknode(p))
-				return -1;
+		if (IS_ERR(classp)) {
+			ret = PTR_ERR(classp);
+			goto unregister_ttys;
+		}
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+		dgap_create_tty_sysfs(&ch->ch_pun, classp);
+		ch->ch_pun.un_sysfs = classp;
+	}
+	dgap_create_ports_sysfiles(brd);
 
-			p = p->next;
-			p->type = INTRNODE;
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.useintr)) {
-				pr_err("bad number for useintr");
-				return -1;
-			}
-			break;
+	return 0;
 
-		case TTSIZ:	/* size of tty structure */
-			if (dgap_checknode(p))
-				return -1;
+unregister_ttys:
+	while (i >= 0) {
+		ch = brd->channels[i];
+		if (ch->ch_tun.un_sysfs) {
+			dgap_remove_tty_sysfs(ch->ch_tun.un_sysfs);
+			tty_unregister_device(brd->serial_driver, i);
+		}
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+		if (ch->ch_pun.un_sysfs) {
+			dgap_remove_tty_sysfs(ch->ch_pun.un_sysfs);
+			tty_unregister_device(brd->print_driver, i);
+		}
+		i--;
+	}
 
-			p = p->next;
-			p->type = TSNODE;
+	for (i = 0; i < brd->nasync; i++) {
+		tty_port_destroy(&brd->serial_ports[i]);
+		tty_port_destroy(&brd->printer_ports[i]);
+	}
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.ttysize)) {
-				pr_err("bad number for ttysize");
-				return -1;
-			}
-			break;
+	kfree(brd->printer_ports);
+	brd->printer_ports = NULL;
 
-		case CHSIZ:	/* channel structure size */
-			if (dgap_checknode(p))
-				return -1;
+free_serial_ports:
+	kfree(brd->serial_ports);
+	brd->serial_ports = NULL;
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+	return ret;
+}
 
-			p = p->next;
-			p->type = CSNODE;
+/*
+ * dgap_cleanup_tty()
+ *
+ * Uninitialize the TTY portion of this driver.  Free all memory and
+ * resources.
+ */
+static void dgap_cleanup_tty(struct board_t *brd)
+{
+	struct device *dev;
+	int i;
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.chsize)) {
-				pr_err("bad number for chsize");
-				return -1;
-			}
-			break;
+	dgap_boards_by_major[brd->serial_driver->major] = NULL;
+	brd->dgap_serial_major = 0;
+	for (i = 0; i < brd->nasync; i++) {
+		tty_port_destroy(&brd->serial_ports[i]);
+		dev = brd->channels[i]->ch_tun.un_sysfs;
+		dgap_remove_tty_sysfs(dev);
+		tty_unregister_device(brd->serial_driver, i);
+	}
+	tty_unregister_driver(brd->serial_driver);
+	put_tty_driver(brd->serial_driver);
+	kfree(brd->serial_ports);
 
-		case BSSIZ:	/* board structure size */
-			if (dgap_checknode(p))
-				return -1;
+	dgap_boards_by_major[brd->print_driver->major] = NULL;
+	brd->dgap_transparent_print_major = 0;
+	for (i = 0; i < brd->nasync; i++) {
+		tty_port_destroy(&brd->printer_ports[i]);
+		dev = brd->channels[i]->ch_pun.un_sysfs;
+		dgap_remove_tty_sysfs(dev);
+		tty_unregister_device(brd->print_driver, i);
+	}
+	tty_unregister_driver(brd->print_driver);
+	put_tty_driver(brd->print_driver);
+	kfree(brd->printer_ports);
+}
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+static int dgap_request_irq(struct board_t *brd)
+{
+	int rc;
 
-			p = p->next;
-			p->type = BSNODE;
+	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
+		return -ENODEV;
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.bssize)) {
-				pr_err("bad number for bssize");
-				return -1;
-			}
-			break;
+	/*
+	 * Set up our interrupt handler if we are set to do interrupts.
+	 */
+	if (dgap_config_get_useintr(brd) && brd->irq) {
 
-		case UNTSIZ:	/* sched structure size */
-			if (dgap_checknode(p))
-				return -1;
+		rc = request_irq(brd->irq, dgap_intr, IRQF_SHARED, "DGAP", brd);
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+		if (!rc)
+			brd->intr_used = 1;
+	}
+	return 0;
+}
 
-			p = p->next;
-			p->type = USNODE;
+static void dgap_free_irq(struct board_t *brd)
+{
+	if (brd->intr_used && brd->irq)
+		free_irq(brd->irq, brd);
+}
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.unsize)) {
-				pr_err("bad number for schedsize");
-				return -1;
-			}
-			break;
+static int dgap_firmware_load(struct pci_dev *pdev, int card_type,
+			      struct board_t *brd)
+{
+	const struct firmware *fw;
+	char *tmp_ptr;
+	int ret;
+	char *dgap_config_buf;
 
-		case F2SIZ:	/* f2200 structure size */
-			if (dgap_checknode(p))
-				return -1;
+	dgap_get_vpd(brd);
+	dgap_do_reset_board(brd);
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+	if (fw_info[card_type].conf_name) {
+		ret = request_firmware(&fw, fw_info[card_type].conf_name,
+					 &pdev->dev);
+		if (ret) {
+			dev_err(&pdev->dev, "config file %s not found\n",
+				fw_info[card_type].conf_name);
+			return ret;
+		}
 
-			p = p->next;
-			p->type = FSNODE;
+		dgap_config_buf = kzalloc(fw->size + 1, GFP_KERNEL);
+		if (!dgap_config_buf) {
+			release_firmware(fw);
+			return -ENOMEM;
+		}
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.f2size)) {
-				pr_err("bad number for f2200size");
-				return -1;
-			}
-			break;
+		memcpy(dgap_config_buf, fw->data, fw->size);
+		release_firmware(fw);
 
-		case VPSIZ:	/* vpix structure size */
-			if (dgap_checknode(p))
-				return -1;
+		/*
+		 * preserve dgap_config_buf
+		 * as dgap_parsefile would
+		 * otherwise alter it.
+		 */
+		tmp_ptr = dgap_config_buf;
 
-			p->next = kzalloc(sizeof(struct cnode), GFP_KERNEL);
-			if (!p->next)
-				return -1;
+		if (dgap_parsefile(&tmp_ptr) != 0) {
+			kfree(dgap_config_buf);
+			return -EINVAL;
+		}
+		kfree(dgap_config_buf);
+	}
 
-			p = p->next;
-			p->type = VSNODE;
+	/*
+	 * Match this board to a config the user created for us.
+	 */
+	brd->bd_config =
+		dgap_find_config(brd->type, brd->pci_bus, brd->pci_slot);
 
-			s = dgap_getword(in);
-			if (!s) {
-				pr_err("unexpected end of file");
-				return -1;
-			}
-			if (kstrtol(s, 0, &p->u.vpixsize)) {
-				pr_err("bad number for vpixsize");
-				return -1;
-			}
-			break;
-		}
+	/*
+	 * Because the 4 port Xr products share the same PCI ID
+	 * as the 8 port Xr products, if we receive a NULL config
+	 * back, and this is a PAPORT8 board, retry with a
+	 * PAPORT4 attempt as well.
+	 */
+	if (brd->type == PAPORT8 && !brd->bd_config)
+		brd->bd_config =
+			dgap_find_config(PAPORT4, brd->pci_bus, brd->pci_slot);
+
+	if (!brd->bd_config) {
+		dev_err(&pdev->dev, "No valid configuration found\n");
+		return -EINVAL;
 	}
-}
 
-/*
- * dgap_sindex: much like index(), but it looks for a match of any character in
- * the group, and returns that position.  If the first character is a ^, then
- * this will match the first occurrence not in that group.
- */
-static char *dgap_sindex(char *string, char *group)
-{
-	char *ptr;
+	if (fw_info[card_type].bios_name) {
+		ret = request_firmware(&fw, fw_info[card_type].bios_name,
+					&pdev->dev);
+		if (ret) {
+			dev_err(&pdev->dev, "bios file %s not found\n",
+				fw_info[card_type].bios_name);
+			return ret;
+		}
+		dgap_do_bios_load(brd, fw->data, fw->size);
+		release_firmware(fw);
 
-	if (!string || !group)
-		return (char *) NULL;
+		/* Wait for BIOS to test board... */
+		ret = dgap_test_bios(brd);
+		if (ret)
+			return ret;
+	}
 
-	if (*group == '^') {
-		group++;
-		for (; *string; string++) {
-			for (ptr = group; *ptr; ptr++) {
-				if (*ptr == *string)
-					break;
-			}
-			if (*ptr == '\0')
-				return string;
+	if (fw_info[card_type].fep_name) {
+		ret = request_firmware(&fw, fw_info[card_type].fep_name,
+					&pdev->dev);
+		if (ret) {
+			dev_err(&pdev->dev, "dgap: fep file %s not found\n",
+				fw_info[card_type].fep_name);
+			return ret;
 		}
-	} else {
-		for (; *string; string++) {
-			for (ptr = group; *ptr; ptr++) {
-				if (*ptr == *string)
-					return string;
-			}
+		dgap_do_fep_load(brd, fw->data, fw->size);
+		release_firmware(fw);
+
+		/* Wait for FEP to load on board... */
+		ret = dgap_test_fep(brd);
+		if (ret)
+			return ret;
+	}
+
+#ifdef DIGI_CONCENTRATORS_SUPPORTED
+	/*
+	 * If this is a CX or EPCX, we need to see if the firmware
+	 * is requesting a concentrator image from us.
+	 */
+	if ((bd->type == PCX) || (bd->type == PEPC)) {
+		chk_addr = (u16 *) (vaddr + DOWNREQ);
+		/* Nonzero if FEP is requesting concentrator image. */
+		check = readw(chk_addr);
+		vaddr = brd->re_map_membase;
+	}
+
+	if (fw_info[card_type].con_name && check && vaddr) {
+		ret = request_firmware(&fw, fw_info[card_type].con_name,
+					&pdev->dev);
+		if (ret) {
+			dev_err(&pdev->dev, "conc file %s not found\n",
+				fw_info[card_type].con_name);
+			return ret;
 		}
+		/* Put concentrator firmware loading code here */
+		offset = readw((u16 *) (vaddr + DOWNREQ));
+		memcpy_toio(offset, fw->data, fw->size);
+
+		dgap_do_conc_load(brd, (char *)fw->data, fw->size)
+		release_firmware(fw);
 	}
+#endif
 
-	return (char *) NULL;
+	return 0;
 }
 
 /*
- * Get a token from the input file; return 0 if end of file is reached
+ * dgap_tty_init()
+ *
+ * Init the tty subsystem.  Called once per board after board has been
+ * downloaded and init'ed.
  */
-static int dgap_gettok(char **in)
+static int dgap_tty_init(struct board_t *brd)
 {
-	char *w;
-	struct toklist *t;
+	int i;
+	int tlw;
+	uint true_count;
+	u8 __iomem *vaddr;
+	u8 modem;
+	struct channel_t *ch;
+	struct bs_t __iomem *bs;
+	struct cm_t __iomem *cm;
+	int ret;
 
-	if (strstr(dgap_cword, "board")) {
-		w = dgap_getword(in);
-		snprintf(dgap_cword, MAXCWORD, "%s", w);
-		for (t = dgap_brdtype; t->token != 0; t++) {
-			if (!strcmp(w, t->string))
-				return t->token;
+	/*
+	 * Initialize board structure elements.
+	 */
+
+	vaddr = brd->re_map_membase;
+	true_count = readw((vaddr + NCHAN));
+
+	brd->nasync = dgap_config_get_num_prts(brd);
+
+	if (!brd->nasync)
+		brd->nasync = brd->maxports;
+
+	if (brd->nasync > brd->maxports)
+		brd->nasync = brd->maxports;
+
+	if (true_count != brd->nasync) {
+		dev_warn(&brd->pdev->dev,
+			 "%s configured for %d ports, has %d ports.\n",
+			 brd->name, brd->nasync, true_count);
+
+		if ((brd->type == PPCM) &&
+		    (true_count == 64 || true_count == 0)) {
+			dev_warn(&brd->pdev->dev,
+				 "Please make SURE the EBI cable running from the card\n");
+			dev_warn(&brd->pdev->dev,
+				 "to each EM module is plugged into EBI IN!\n");
 		}
-	} else {
-		while ((w = dgap_getword(in))) {
-			snprintf(dgap_cword, MAXCWORD, "%s", w);
-			for (t = dgap_tlist; t->token != 0; t++) {
-				if (!strcmp(w, t->string))
-					return t->token;
-			}
+
+		brd->nasync = true_count;
+
+		/* If no ports, don't bother going any further */
+		if (!brd->nasync) {
+			brd->state = BOARD_FAILED;
+			brd->dpastatus = BD_NOFEP;
+			return -EIO;
+		}
+	}
+
+	/*
+	 * Allocate channel memory that might not have been allocated
+	 * when the driver was first loaded.
+	 */
+	for (i = 0; i < brd->nasync; i++) {
+		brd->channels[i] =
+			kzalloc(sizeof(struct channel_t), GFP_KERNEL);
+		if (!brd->channels[i]) {
+			ret = -ENOMEM;
+			goto free_chan;
 		}
 	}
 
+	ch = brd->channels[0];
+	vaddr = brd->re_map_membase;
+
+	bs = (struct bs_t __iomem *) ((ulong) vaddr + CHANBUF);
+	cm = (struct cm_t __iomem *) ((ulong) vaddr + CMDBUF);
+
+	brd->bd_bs = bs;
+
+	/* Set up channel variables */
+	for (i = 0; i < brd->nasync; i++, ch = brd->channels[i], bs++) {
+
+		spin_lock_init(&ch->ch_lock);
+
+		/* Store all our magic numbers */
+		ch->magic = DGAP_CHANNEL_MAGIC;
+		ch->ch_tun.magic = DGAP_UNIT_MAGIC;
+		ch->ch_tun.un_type = DGAP_SERIAL;
+		ch->ch_tun.un_ch = ch;
+		ch->ch_tun.un_dev = i;
+
+		ch->ch_pun.magic = DGAP_UNIT_MAGIC;
+		ch->ch_pun.un_type = DGAP_PRINT;
+		ch->ch_pun.un_ch = ch;
+		ch->ch_pun.un_dev = i;
+
+		ch->ch_vaddr = vaddr;
+		ch->ch_bs = bs;
+		ch->ch_cm = cm;
+		ch->ch_bd = brd;
+		ch->ch_portnum = i;
+		ch->ch_digi = dgap_digi_init;
+
+		/*
+		 * Set up digi dsr and dcd bits based on altpin flag.
+		 */
+		if (dgap_config_get_altpin(brd)) {
+			ch->ch_dsr	= DM_CD;
+			ch->ch_cd	= DM_DSR;
+			ch->ch_digi.digi_flags |= DIGI_ALTPIN;
+		} else {
+			ch->ch_cd	= DM_CD;
+			ch->ch_dsr	= DM_DSR;
+		}
+
+		ch->ch_taddr = vaddr + (ioread16(&(ch->ch_bs->tx_seg)) << 4);
+		ch->ch_raddr = vaddr + (ioread16(&(ch->ch_bs->rx_seg)) << 4);
+		ch->ch_tx_win = 0;
+		ch->ch_rx_win = 0;
+		ch->ch_tsize = readw(&(ch->ch_bs->tx_max)) + 1;
+		ch->ch_rsize = readw(&(ch->ch_bs->rx_max)) + 1;
+		ch->ch_tstart = 0;
+		ch->ch_rstart = 0;
+
+		/*
+		 * Set queue water marks, interrupt mask,
+		 * and general tty parameters.
+		 */
+		tlw = ch->ch_tsize >= 2000 ? ((ch->ch_tsize * 5) / 8) :
+						ch->ch_tsize / 2;
+		ch->ch_tlw = tlw;
+
+		dgap_cmdw(ch, STLOW, tlw, 0);
+
+		dgap_cmdw(ch, SRLOW, ch->ch_rsize / 2, 0);
+
+		dgap_cmdw(ch, SRHIGH, 7 * ch->ch_rsize / 8, 0);
+
+		ch->ch_mistat = readb(&(ch->ch_bs->m_stat));
+
+		init_waitqueue_head(&ch->ch_flags_wait);
+		init_waitqueue_head(&ch->ch_tun.un_flags_wait);
+		init_waitqueue_head(&ch->ch_pun.un_flags_wait);
+
+		/* Turn on all modem interrupts for now */
+		modem = (DM_CD | DM_DSR | DM_CTS | DM_RI);
+		writeb(modem, &(ch->ch_bs->m_int));
+
+		/*
+		 * Set edelay to 0 if interrupts are turned on,
+		 * otherwise set edelay to the usual 100.
+		 */
+		if (brd->intr_used)
+			writew(0, &(ch->ch_bs->edelay));
+		else
+			writew(100, &(ch->ch_bs->edelay));
+
+		writeb(1, &(ch->ch_bs->idata));
+	}
+
 	return 0;
+
+free_chan:
+	while (--i >= 0) {
+		kfree(brd->channels[i]);
+		brd->channels[i] = NULL;
+	}
+	return ret;
 }
 
 /*
- * get a word from the input stream, also keep track of current line number.
- * words are separated by whitespace.
+ * dgap_tty_free()
+ *
+ * Free the channles which are allocated in dgap_tty_init().
  */
-static char *dgap_getword(char **in)
+static void dgap_tty_free(struct board_t *brd)
 {
-	char *ret_ptr = *in;
+	int i;
 
-	char *ptr = dgap_sindex(*in, " \t\n");
+	for (i = 0; i < brd->nasync; i++)
+		kfree(brd->channels[i]);
+}
 
-	/* If no word found, return null */
-	if (!ptr)
-		return NULL;
+static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int rc;
+	struct board_t *brd;
 
-	/* Mark new location for our buffer */
-	*ptr = '\0';
-	*in = ptr + 1;
+	if (dgap_numboards >= MAXBOARDS)
+		return -EPERM;
 
-	/* Eat any extra spaces/tabs/newlines that might be present */
-	while (*in && **in && ((**in == ' ') ||
-			       (**in == '\t') ||
-			       (**in == '\n'))) {
-		**in = '\0';
-		*in = *in + 1;
-	}
+	rc = pci_enable_device(pdev);
+	if (rc)
+		return -EIO;
 
-	return ret_ptr;
+	brd = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
+	if (IS_ERR(brd))
+		return PTR_ERR(brd);
+
+	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
+	if (rc)
+		goto cleanup_brd;
+
+	rc = dgap_alloc_flipbuf(brd);
+	if (rc)
+		goto cleanup_brd;
+
+	rc = dgap_tty_register(brd);
+	if (rc)
+		goto free_flipbuf;
+
+	rc = dgap_request_irq(brd);
+	if (rc)
+		goto unregister_tty;
+
+	/*
+	 * Do tty device initialization.
+	 */
+	rc = dgap_tty_init(brd);
+	if (rc < 0)
+		goto free_irq;
+
+	rc = dgap_tty_register_ports(brd);
+	if (rc)
+		goto tty_free;
+
+	brd->state = BOARD_READY;
+	brd->dpastatus = BD_RUNNING;
+
+	dgap_board[dgap_numboards++] = brd;
+
+	return 0;
+
+tty_free:
+	dgap_tty_free(brd);
+free_irq:
+	dgap_free_irq(brd);
+unregister_tty:
+	dgap_tty_unregister(brd);
+free_flipbuf:
+	dgap_free_flipbuf(brd);
+cleanup_brd:
+	dgap_cleanup_nodes();
+	dgap_unmap(brd);
+	kfree(brd);
+
+	return rc;
+}
+
+static void dgap_remove_one(struct pci_dev *dev)
+{
+	/* Do Nothing */
 }
 
+static struct pci_driver dgap_driver = {
+	.name		= "dgap",
+	.probe		= dgap_init_one,
+	.id_table	= dgap_pci_tbl,
+	.remove		= dgap_remove_one,
+};
+
 /*
- * dgap_checknode: see if all the necessary info has been supplied for a node
- * before creating the next node.
+ * dgap_init_globals()
+ *
+ * This is where we initialize the globals from the static insmod
+ * configuration variables.  These are declared near the head of
+ * this file.
  */
-static int dgap_checknode(struct cnode *p)
+static void dgap_init_globals(void)
 {
-	switch (p->type) {
-	case LNODE:
-		if (p->u.line.v_speed == 0) {
-			pr_err("line speed not specified");
-			return 1;
-		}
-		return 0;
+	int i;
 
-	case CNODE:
-		if (p->u.conc.v_speed == 0) {
-			pr_err("concentrator line speed not specified");
-			return 1;
-		}
-		if (p->u.conc.v_nport == 0) {
-			pr_err("number of ports on concentrator not specified");
-			return 1;
-		}
-		if (p->u.conc.v_id == 0) {
-			pr_err("concentrator id letter not specified");
-			return 1;
-		}
-		return 0;
+	for (i = 0; i < MAXBOARDS; i++)
+		dgap_board[i] = NULL;
 
-	case MNODE:
-		if (p->u.module.v_nport == 0) {
-			pr_err("number of ports on EBI module not specified");
-			return 1;
-		}
-		if (p->u.module.v_id == 0) {
-			pr_err("EBI module id letter not specified");
-			return 1;
-		}
-		return 0;
-	}
-	return 0;
+	init_timer(&dgap_poll_timer);
 }
 
 /*
- * Given a board pointer, returns whether we should use interrupts or not.
+ * Start of driver.
  */
-static uint dgap_config_get_useintr(struct board_t *bd)
+static int dgap_start(void)
 {
-	struct cnode *p;
+	int rc;
+	unsigned long flags;
+	struct device *device;
 
-	if (!bd)
-		return 0;
+	/*
+	 * make sure that the globals are
+	 * init'd before we do anything else
+	 */
+	dgap_init_globals();
 
-	for (p = bd->bd_config; p; p = p->next) {
-		if (p->type == INTRNODE) {
-			/*
-			 * check for pcxr types.
-			 */
-			return p->u.useintr;
-		}
+	dgap_numboards = 0;
+
+	pr_info("For the tools package please visit http://www.digi.com\n");
+
+	/*
+	 * Register our base character device into the kernel.
+	 */
+
+	/*
+	 * Register management/dpa devices
+	 */
+	rc = register_chrdev(DIGI_DGAP_MAJOR, "dgap", &dgap_board_fops);
+	if (rc < 0)
+		return rc;
+
+	dgap_class = class_create(THIS_MODULE, "dgap_mgmt");
+	if (IS_ERR(dgap_class)) {
+		rc = PTR_ERR(dgap_class);
+		goto failed_class;
 	}
 
-	/* If not found, then don't turn on interrupts. */
-	return 0;
+	device = device_create(dgap_class, NULL,
+		MKDEV(DIGI_DGAP_MAJOR, 0),
+		NULL, "dgap_mgmt");
+	if (IS_ERR(device)) {
+		rc = PTR_ERR(device);
+		goto failed_device;
+	}
+
+	/* Start the poller */
+	spin_lock_irqsave(&dgap_poll_lock, flags);
+	init_timer(&dgap_poll_timer);
+	dgap_poll_timer.function = dgap_poll_handler;
+	dgap_poll_timer.data = 0;
+	dgap_poll_time = jiffies + dgap_jiffies_from_ms(dgap_poll_tick);
+	dgap_poll_timer.expires = dgap_poll_time;
+	spin_unlock_irqrestore(&dgap_poll_lock, flags);
+
+	add_timer(&dgap_poll_timer);
+
+	return rc;
+
+failed_device:
+	class_destroy(dgap_class);
+failed_class:
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
+	return rc;
 }
 
-/*
- * Given a board pointer, returns whether we turn on altpin or not.
- */
-static uint dgap_config_get_altpin(struct board_t *bd)
+static void dgap_stop(void)
 {
-	struct cnode *p;
+	unsigned long lock_flags;
 
-	if (!bd)
-		return 0;
+	spin_lock_irqsave(&dgap_poll_lock, lock_flags);
+	dgap_poll_stop = 1;
+	spin_unlock_irqrestore(&dgap_poll_lock, lock_flags);
 
-	for (p = bd->bd_config; p; p = p->next) {
-		if (p->type == ANODE) {
-			/*
-			 * check for pcxr types.
-			 */
-			return p->u.altpin;
-		}
-	}
+	del_timer_sync(&dgap_poll_timer);
 
-	/* If not found, then don't turn on interrupts. */
-	return 0;
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
+	class_destroy(dgap_class);
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
 }
 
 /*
- * Given a specific type of board, if found, detached link and
- * returns the first occurrence in the list.
+ * dgap_cleanup_board()
+ *
+ * Free all the memory associated with a board
  */
-static struct cnode *dgap_find_config(int type, int bus, int slot)
+static void dgap_cleanup_board(struct board_t *brd)
 {
-	struct cnode *p, *prev, *prev2, *found;
-
-	p = &dgap_head;
+	int i;
 
-	while (p->next) {
-		prev = p;
-		p = p->next;
+	if (!brd || brd->magic != DGAP_BOARD_MAGIC)
+		return;
 
-		if (p->type != BNODE)
-			continue;
+	dgap_free_irq(brd);
 
-		if (p->u.board.type != type)
-			continue;
+	tasklet_kill(&brd->helper_tasklet);
 
-		if (p->u.board.v_pcibus &&
-		    p->u.board.pcibus != bus)
-			continue;
+	dgap_unmap(brd);
 
-		if (p->u.board.v_pcislot &&
-		    p->u.board.pcislot != slot)
-			continue;
+	/* Free all allocated channels structs */
+	for (i = 0; i < MAXPORTS ; i++)
+		kfree(brd->channels[i]);
 
-		found = p;
-		/*
-		 * Keep walking thru the list till we
-		 * find the next board.
-		 */
-		while (p->next) {
-			prev2 = p;
-			p = p->next;
+	kfree(brd->flipbuf);
+	kfree(brd->flipflagbuf);
 
-			if (p->type != BNODE)
-				continue;
+	dgap_board[brd->boardnum] = NULL;
 
-			/*
-			 * Mark the end of our 1 board
-			 * chain of configs.
-			 */
-			prev2->next = NULL;
+	kfree(brd);
+}
 
-			/*
-			 * Link the "next" board to the
-			 * previous board, effectively
-			 * "unlinking" our board from
-			 * the main config.
-			 */
-			prev->next = p;
 
-			return found;
-		}
-		/*
-		 * It must be the last board in the list.
-		 */
-		prev->next = NULL;
-		return found;
-	}
-	return NULL;
-}
+/************************************************************************
+ *
+ * Driver load/unload functions
+ *
+ ************************************************************************/
 
 /*
- * Given a board pointer, walks the config link, counting up
- * all ports user specified should be on the board.
- * (This does NOT mean they are all actually present right now tho)
+ * init_module()
+ *
+ * Module load.  This is where it all starts.
  */
-static uint dgap_config_get_num_prts(struct board_t *bd)
+static int dgap_init_module(void)
 {
-	int count = 0;
-	struct cnode *p;
+	int rc;
 
-	if (!bd)
-		return 0;
+	pr_info("%s, Digi International Part Number %s\n", DG_NAME, DG_PART);
 
-	for (p = bd->bd_config; p; p = p->next) {
+	rc = dgap_start();
+	if (rc)
+		return rc;
 
-		switch (p->type) {
-		case BNODE:
-			/*
-			 * check for pcxr types.
-			 */
-			if (p->u.board.type > EPCFE)
-				count += p->u.board.nport;
-			break;
-		case CNODE:
-			count += p->u.conc.nport;
-			break;
-		case MNODE:
-			count += p->u.module.nport;
-			break;
-		}
-	}
-	return count;
+	rc = pci_register_driver(&dgap_driver);
+	if (rc)
+		goto err_stop;
+
+	rc = dgap_create_driver_sysfiles(&dgap_driver);
+	if (rc)
+		goto err_unregister;
+
+	dgap_driver_state = DRIVER_READY;
+
+	return 0;
+
+err_unregister:
+	pci_unregister_driver(&dgap_driver);
+err_stop:
+	dgap_stop();
+
+	return rc;
 }
 
-static char *dgap_create_config_string(struct board_t *bd, char *string)
+/*
+ * dgap_cleanup_module()
+ *
+ * Module unload.  This is where it all ends.
+ */
+static void dgap_cleanup_module(void)
 {
-	char *ptr = string;
-	struct cnode *p;
-	struct cnode *q;
-	int speed;
+	int i;
+	ulong lock_flags;
 
-	if (!bd) {
-		*ptr = 0xff;
-		return string;
-	}
+	spin_lock_irqsave(&dgap_poll_lock, lock_flags);
+	dgap_poll_stop = 1;
+	spin_unlock_irqrestore(&dgap_poll_lock, lock_flags);
 
-	for (p = bd->bd_config; p; p = p->next) {
+	/* Turn off poller right away. */
+	del_timer_sync(&dgap_poll_timer);
 
-		switch (p->type) {
-		case LNODE:
-			*ptr = '\0';
-			ptr++;
-			*ptr = p->u.line.speed;
-			ptr++;
-			break;
-		case CNODE:
-			/*
-			 * Because the EPC/con concentrators can have EM modules
-			 * hanging off of them, we have to walk ahead in the
-			 * list and keep adding the number of ports on each EM
-			 * to the config. UGH!
-			 */
-			speed = p->u.conc.speed;
-			q = p->next;
-			if (q && (q->type == MNODE)) {
-				*ptr = (p->u.conc.nport + 0x80);
-				ptr++;
-				p = q;
-				while (q->next && (q->next->type) == MNODE) {
-					*ptr = (q->u.module.nport + 0x80);
-					ptr++;
-					p = q;
-					q = q->next;
-				}
-				*ptr = q->u.module.nport;
-				ptr++;
-			} else {
-				*ptr = p->u.conc.nport;
-				ptr++;
-			}
+	dgap_remove_driver_sysfiles(&dgap_driver);
 
-			*ptr = speed;
-			ptr++;
-			break;
-		}
+	device_destroy(dgap_class, MKDEV(DIGI_DGAP_MAJOR, 0));
+	class_destroy(dgap_class);
+	unregister_chrdev(DIGI_DGAP_MAJOR, "dgap");
+
+	for (i = 0; i < dgap_numboards; ++i) {
+		dgap_remove_ports_sysfiles(dgap_board[i]);
+		dgap_cleanup_tty(dgap_board[i]);
+		dgap_cleanup_board(dgap_board[i]);
 	}
 
-	*ptr = 0xff;
-	return string;
+	dgap_cleanup_nodes();
+
+	if (dgap_numboards)
+		pci_unregister_driver(&dgap_driver);
 }
+
+module_init(dgap_init_module);
+module_exit(dgap_cleanup_module);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Digi International, http://www.digi.com");
+MODULE_DESCRIPTION("Driver for the Digi International EPCA PCI based product line");
+MODULE_SUPPORTED_DEVICE("dgap");
-- 
1.7.1

