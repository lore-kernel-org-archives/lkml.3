Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852Ab3DKN2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933494Ab3DKN2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 07/26] cxt1e1: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bob Beers <bob.beers@gmail.com>, viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:28:38 +0100
Message-ID: <20130411132838.32763.58346.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Bob Beers <bob.beers@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org
---

 drivers/staging/cxt1e1/Makefile  |    3 
 drivers/staging/cxt1e1/sbeproc.c |  460 +++++++++++++-------------------------
 drivers/staging/cxt1e1/sbeproc.h |   14 +
 3 files changed, 175 insertions(+), 302 deletions(-)

diff --git a/drivers/staging/cxt1e1/Makefile b/drivers/staging/cxt1e1/Makefile
index e99b823..b9ccb76 100644
--- a/drivers/staging/cxt1e1/Makefile
+++ b/drivers/staging/cxt1e1/Makefile
@@ -12,8 +12,9 @@ cxt1e1-y := 	\
   linux.o 		\
   functions.o 		\
   hwprobe.o 		\
-  sbeproc.o 		\
   pmc93x6_eeprom.o 	\
   sbecrc.o 		\
   comet_tables.o 	\
   sbeid.o
+
+cxt1e1-$(CONFIG_PROC_FS) += sbeproc.o
diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index f42531c..eac8983 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/sched.h>
 #include <asm/uaccess.h>
 #include "pmcc4_sysdep.h"
@@ -26,332 +27,193 @@
 #include "pmcc4_private.h"
 #include "sbeproc.h"
 
-/* forwards */
-void        sbecom_get_brdinfo (ci_t *, struct sbe_brd_info *, u_int8_t *);
+extern void sbecom_get_brdinfo(ci_t *, struct sbe_brd_info *, u_int8_t *);
 extern struct s_hdw_info hdw_info[MAX_BOARDS];
 
-#ifdef CONFIG_PROC_FS
-
-/********************************************************************/
-/* procfs stuff                                                     */
-/********************************************************************/
-
-
-void
-sbecom_proc_brd_cleanup (ci_t * ci)
+void sbecom_proc_brd_cleanup(ci_t *ci)
 {
-    if (ci->dir_dev)
-    {
-	char dir[7 + SBE_IFACETMPL_SIZE + 1];
-	snprintf(dir, sizeof(dir), "driver/%s", ci->devname);
-        remove_proc_entry("info", ci->dir_dev);
-        remove_proc_entry(dir, NULL);
-        ci->dir_dev = NULL;
-    }
+	if (ci->dir_dev) {
+		char dir[7 + SBE_IFACETMPL_SIZE + 1];
+		snprintf(dir, sizeof(dir), "driver/%s", ci->devname);
+		remove_proc_entry("info", ci->dir_dev);
+		remove_proc_entry(dir, NULL);
+		ci->dir_dev = NULL;
+	}
 }
 
-
-static int
-sbecom_proc_get_sbe_info (char *buffer, char **start, off_t offset,
-                          int length, int *eof, void *priv)
+static void sbecom_proc_get_brdinfo(ci_t *ci, struct sbe_brd_info *bip)
 {
-    ci_t       *ci = (ci_t *) priv;
-    int         len = 0;
-    char       *spd;
-    struct sbe_brd_info *bip;
-
-    if (!(bip = OS_kmalloc (sizeof (struct sbe_brd_info))))
-    {
-        return -ENOMEM;
-    }
-#if 0
-    /** RLD DEBUG **/
-    pr_info(">> sbecom_proc_get_sbe_info: entered, offset %d. length %d.\n",
-            (int) offset, (int) length);
-#endif
-
-    {
-        hdw_info_t *hi = &hdw_info[ci->brdno];
-
-        u_int8_t *bsn = 0;
-
-        switch (hi->promfmt)
-        {
-        case PROM_FORMAT_TYPE1:
-            bsn = (u_int8_t *) hi->mfg_info.pft1.Serial;
-            break;
-        case PROM_FORMAT_TYPE2:
-            bsn = (u_int8_t *) hi->mfg_info.pft2.Serial;
-            break;
-        }
-
-        sbecom_get_brdinfo (ci, bip, bsn);
-    }
-
-#if 0
-    /** RLD DEBUG **/
-    pr_info(">> sbecom_get_brdinfo: returned, first_if %p <%s> last_if %p <%s>\n",
-            (char *) &bip->first_iname, (char *) &bip->first_iname,
-            (char *) &bip->last_iname, (char *) &bip->last_iname);
-#endif
-    len += sprintf (buffer + len, "Board Type:    ");
-    switch (bip->brd_id)
-    {
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T3):
-        len += sprintf (buffer + len, "wanPMC-C1T3");
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
-        len += sprintf (buffer + len, "wanPTMC-256T3 <E1>");
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
-        len += sprintf (buffer + len, "wanPTMC-256T3 <T1>");
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_C24TE1):
-        len += sprintf (buffer + len, "wanPTMC-C24TE1");
-        break;
-
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
-        len += sprintf (buffer + len, "wanPMC-C4T1E1");
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
-        len += sprintf (buffer + len, "wanPMC-C2T1E1");
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
-        len += sprintf (buffer + len, "wanPMC-C1T1E1");
-        break;
-
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
-        len += sprintf (buffer + len, "wanPCI-C4T1E1");
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
-        len += sprintf (buffer + len, "wanPCI-C2T1E1");
-        break;
-    case SBE_BOARD_ID (PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
-        len += sprintf (buffer + len, "wanPCI-C1T1E1");
-        break;
-
-    default:
-        len += sprintf (buffer + len, "unknown");
-        break;
-    }
-    len += sprintf (buffer + len, "  [%08X]\n", bip->brd_id);
+	hdw_info_t *hi = &hdw_info[ci->brdno];
+	u_int8_t *bsn = 0;
+
+	switch (hi->promfmt)
+	{
+	case PROM_FORMAT_TYPE1:
+		bsn = (u_int8_t *) hi->mfg_info.pft1.Serial;
+		break;
+	case PROM_FORMAT_TYPE2:
+		bsn = (u_int8_t *) hi->mfg_info.pft2.Serial;
+		break;
+	}
+
+	sbecom_get_brdinfo (ci, bip, bsn);
+
+	pr_devel(">> sbecom_get_brdinfo: returned, first_if %p <%s> last_if %p <%s>\n",
+		 bip->first_iname, bip->first_iname,
+		 bip->last_iname, bip->last_iname);
+}
 
-    len += sprintf (buffer + len, "Board Number:  %d\n", bip->brdno);
-    len += sprintf (buffer + len, "Hardware ID:   0x%02X\n", ci->hdw_bid);
-    len += sprintf (buffer + len, "Board SN:      %06X\n", bip->brd_sn);
-	len += sprintf(buffer + len, "Board MAC:     %pMF\n",
-		bip->brd_mac_addr);
-    len += sprintf (buffer + len, "Ports:         %d\n", ci->max_port);
-    len += sprintf (buffer + len, "Channels:      %d\n", bip->brd_chan_cnt);
+/*
+ * Describe the driver state through /proc
+ */
+static int sbecom_proc_get_sbe_info(struct seq_file *m, void *v)
+{
+	ci_t       *ci = m->private;
+	char       *spd;
+	struct sbe_brd_info *bip;
+
+	if (!(bip = OS_kmalloc(sizeof(struct sbe_brd_info))))
+		return -ENOMEM;
+
+	pr_devel(">> sbecom_proc_get_sbe_info: entered\n");
+
+	sbecom_proc_get_brdinfo(ci, bip);
+
+	seq_puts(m, "Board Type:    ");
+	switch (bip->brd_id) {
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T3):
+		seq_puts(m, "wanPMC-C1T3");
+		break;
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_E1):
+		seq_puts(m, "wanPTMC-256T3 <E1>");
+		break;
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_256T3_T1):
+		seq_puts(m, "wanPTMC-256T3 <T1>");
+		break;
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPTMC_C24TE1):
+		seq_puts(m, "wanPTMC-C24TE1");
+		break;
+
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C4T1E1_L):
+		seq_puts(m, "wanPMC-C4T1E1");
+		break;
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C2T1E1_L):
+		seq_puts(m, "wanPMC-C2T1E1");
+		break;
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1):
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPMC_C1T1E1_L):
+		seq_puts(m, "wanPMC-C1T1E1");
+		break;
+
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C4T1E1):
+		seq_puts(m, "wanPCI-C4T1E1");
+		break;
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C2T1E1):
+		seq_puts(m, "wanPCI-C2T1E1");
+		break;
+	case SBE_BOARD_ID(PCI_VENDOR_ID_SBE, PCI_DEVICE_ID_WANPCI_C1T1E1):
+		seq_puts(m, "wanPCI-C1T1E1");
+		break;
+
+	default:
+		seq_puts(m, "unknown");
+		break;
+	}
+
+	seq_printf(m, "  [%08X]\n", bip->brd_id);
+
+	seq_printf(m, "Board Number:  %d\n", bip->brdno);
+	seq_printf(m, "Hardware ID:   0x%02X\n", ci->hdw_bid);
+	seq_printf(m, "Board SN:      %06X\n", bip->brd_sn);
+	seq_printf(m, "Board MAC:     %pMF\n", bip->brd_mac_addr);
+	seq_printf(m, "Ports:         %d\n", ci->max_port);
+	seq_printf(m, "Channels:      %d\n", bip->brd_chan_cnt);
 #if 1
-    len += sprintf (buffer + len, "Interface:     %s -> %s\n",
-                    (char *) &bip->first_iname, (char *) &bip->last_iname);
+	seq_printf(m, "Interface:     %s -> %s\n",
+		   bip->first_iname, bip->last_iname);
 #else
-    len += sprintf (buffer + len, "Interface:     <not available> 1st %p lst %p\n",
-                    (char *) &bip->first_iname, (char *) &bip->last_iname);
+	seq_printf(m, "Interface:     <not available> 1st %p lst %p\n",
+		   bip->first_iname, bip->last_iname);
 #endif
 
-    switch (bip->brd_pci_speed)
-    {
-    case BINFO_PCI_SPEED_33:
-        spd = "33Mhz";
-        break;
-    case BINFO_PCI_SPEED_66:
-        spd = "66Mhz";
-        break;
-    default:
-        spd = "<not available>";
-        break;
-    }
-    len += sprintf (buffer + len, "PCI Bus Speed: %s\n", spd);
-    len += sprintf (buffer + len, "Release:       %s\n", ci->release);
+	switch (bip->brd_pci_speed) {
+	case BINFO_PCI_SPEED_33:
+		spd = "33Mhz";
+		break;
+	case BINFO_PCI_SPEED_66:
+		spd = "66Mhz";
+		break;
+	default:
+		spd = "<not available>";
+		break;
+	}
+	seq_printf(m, "PCI Bus Speed: %s\n", spd);
+	seq_printf(m, "Release:       %s\n", ci->release);
 
 #ifdef SBE_PMCC4_ENABLE
-    {
-               extern int cxt1e1_max_mru;
-#if 0
-        extern int max_chans_used;
-        extern int cxt1e1_max_mtu;
-#endif
-        extern int max_rxdesc_used, max_txdesc_used;
-
-        len += sprintf (buffer + len, "\ncxt1e1_max_mru:         %d\n", cxt1e1_max_mru);
+	{
+		extern int cxt1e1_max_mru;
 #if 0
-        len += sprintf (buffer + len, "\nmax_chans_used:  %d\n", max_chans_used);
-        len += sprintf (buffer + len, "cxt1e1_max_mtu:         %d\n", cxt1e1_max_mtu);
-#endif
-        len += sprintf (buffer + len, "max_rxdesc_used: %d\n", max_rxdesc_used);
-        len += sprintf (buffer + len, "max_txdesc_used: %d\n", max_txdesc_used);
-    }
-#endif
-
-    OS_kfree (bip);                 /* cleanup */
-
-    /***
-     * How to be a proc read function
-     * ------------------------------
-     * Prototype:
-     *    int f(char *buffer, char **start, off_t offset,
-     *          int count, int *peof, void *dat)
-     *
-     * Assume that the buffer is "count" bytes in size.
-     *
-     * If you know you have supplied all the data you
-     * have, set *peof.
-     *
-     * You have three ways to return data:
-     * 0) Leave *start = NULL.  (This is the default.)
-     *    Put the data of the requested offset at that
-     *    offset within the buffer.  Return the number (n)
-     *    of bytes there are from the beginning of the
-     *    buffer up to the last byte of data.  If the
-     *    number of supplied bytes (= n - offset) is
-     *    greater than zero and you didn't signal eof
-     *    and the reader is prepared to take more data
-     *    you will be called again with the requested
-     *    offset advanced by the number of bytes
-     *    absorbed.  This interface is useful for files
-     *    no larger than the buffer.
-     * 1) Set *start = an unsigned long value less than
-     *    the buffer address but greater than zero.
-     *    Put the data of the requested offset at the
-     *    beginning of the buffer.  Return the number of
-     *    bytes of data placed there.  If this number is
-     *    greater than zero and you didn't signal eof
-     *    and the reader is prepared to take more data
-     *    you will be called again with the requested
-     *    offset advanced by *start.  This interface is
-     *    useful when you have a large file consisting
-     *    of a series of blocks which you want to count
-     *    and return as wholes.
-     *    (Hack by Paul.Russell@rustcorp.com.au)
-     * 2) Set *start = an address within the buffer.
-     *    Put the data of the requested offset at *start.
-     *    Return the number of bytes of data placed there.
-     *    If this number is greater than zero and you
-     *    didn't signal eof and the reader is prepared to
-     *    take more data you will be called again with the
-     *    requested offset advanced by the number of bytes
-     *    absorbed.
-     */
-
-#if 1
-    /* #4 - interpretation of above = set EOF, return len */
-    *eof = 1;
+		extern int max_chans_used;
+		extern int cxt1e1_max_mtu;
 #endif
+		extern int max_rxdesc_used, max_txdesc_used;
 
+		seq_printf(m, "\ncxt1e1_max_mru:         %d\n", cxt1e1_max_mru);
 #if 0
-    /*
-     * #1 - from net/wireless/atmel.c RLD NOTE -there's something wrong with
-     * this plagarized code which results in this routine being called TWICE.
-     * The second call returns ZERO, resulting in hidden failure, but at
-     * least only a single message set is being displayed.
-     */
-    if (len <= offset + length)
-        *eof = 1;
-    *start = buffer + offset;
-    len -= offset;
-    if (len > length)
-        len = length;
-    if (len < 0)
-        len = 0;
-#endif
-
-#if 0                               /* #2 from net/tokenring/olympic.c +
-                                     * lanstreamer.c */
-    {
-        off_t       begin = 0;
-        int         size = 0;
-        off_t       pos = 0;
-
-        size = len;
-        pos = begin + size;
-        if (pos < offset)
-        {
-            len = 0;
-            begin = pos;
-        }
-        *start = buffer + (offset - begin);     /* Start of wanted data */
-        len -= (offset - begin);    /* Start slop */
-        if (len > length)
-            len = length;           /* Ending slop */
-    }
+		seq_printf(m, "\nmax_chans_used:  %d\n", max_chans_used);
+		seq_printf(m, "cxt1e1_max_mtu:         %d\n", cxt1e1_max_mtu);
 #endif
-
-#if 0                               /* #3 from
-                                     * char/ftape/lowlevel/ftape-proc.c */
-    len = strlen (buffer);
-    *start = NULL;
-    if (offset + length >= len)
-        *eof = 1;
-    else
-        *eof = 0;
-#endif
-
-#if 0
-    pr_info(">> proc_fs: returned len = %d., start %p\n", len, start);  /* RLD DEBUG */
+		seq_printf(m, "max_rxdesc_used: %d\n", max_rxdesc_used);
+		seq_printf(m, "max_txdesc_used: %d\n", max_txdesc_used);
+	}
 #endif
 
-/***
-   using NONE: returns = 314.314.314.
-   using #1  : returns = 314, 0.
-   using #2  : returns = 314, 0, 0.
-   using #3  : returns = 314, 314.
-   using #4  : returns = 314, 314.
-***/
+	kfree(bip);
 
-    return len;
+	pr_devel(">> proc_fs: finished\n");
+	return 0;
 }
 
-/* initialize the /proc subsystem for the specific SBE driver */
-
-int         __init
-sbecom_proc_brd_init (ci_t * ci)
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int sbecom_proc_open(struct inode *inode, struct file *file)
 {
-    struct proc_dir_entry *e;
-    char dir[7 + SBE_IFACETMPL_SIZE + 1];
-
-    /* create a directory in the root procfs */
-    snprintf(dir, sizeof(dir), "driver/%s", ci->devname);
-    ci->dir_dev = proc_mkdir(dir, NULL);
-    if (!ci->dir_dev)
-    {
-        pr_err("Unable to create directory /proc/driver/%s\n", ci->devname);
-        goto fail;
-    }
-    e = create_proc_read_entry ("info", S_IFREG | S_IRUGO,
-                                ci->dir_dev, sbecom_proc_get_sbe_info, ci);
-    if (!e)
-    {
-        pr_err("Unable to create entry /proc/driver/%s/info\n", ci->devname);
-        goto fail;
-    }
-    return 0;
-
-fail:
-    sbecom_proc_brd_cleanup (ci);
-    return 1;
+	return single_open(file, sbecom_proc_get_sbe_info, PDE(inode)->data);
 }
 
-#else                           /*** ! CONFIG_PROC_FS ***/
+static const struct file_operations sbecom_proc_fops = {
+	.open		= sbecom_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 
-/* stubbed off dummy routines */
-
-void
-sbecom_proc_brd_cleanup (ci_t * ci)
-{
-}
-
-int         __init
-sbecom_proc_brd_init (ci_t * ci)
+/*
+ * Initialize the /proc subsystem for the specific SBE driver
+ */
+int __init sbecom_proc_brd_init(ci_t *ci)
 {
-    return 0;
-}
-
-#endif                          /*** CONFIG_PROC_FS ***/
+	char dir[7 + SBE_IFACETMPL_SIZE + 1];
 
+	snprintf(dir, sizeof(dir), "driver/%s", ci->devname);
+	ci->dir_dev = proc_mkdir(dir, NULL);
+	if (!ci->dir_dev) {
+		pr_err("Unable to create directory /proc/driver/%s\n", ci->devname);
+		goto fail;
+	}
+
+	if (!proc_create_data("info", S_IFREG | S_IRUGO, ci->dir_dev,
+			      &sbecom_proc_fops, ci)) {
+		pr_err("Unable to create entry /proc/driver/%s/info\n", ci->devname);
+		goto fail;
+	}
+	return 0;
 
-/*** End-of-File ***/
+fail:
+	sbecom_proc_brd_cleanup(ci);
+	return 1;
+}
diff --git a/drivers/staging/cxt1e1/sbeproc.h b/drivers/staging/cxt1e1/sbeproc.h
index e82be6a..e5c072c 100644
--- a/drivers/staging/cxt1e1/sbeproc.h
+++ b/drivers/staging/cxt1e1/sbeproc.h
@@ -23,10 +23,20 @@
 
 
 #ifdef CONFIG_PROC_FS
-#ifdef __KERNEL__
 void        sbecom_proc_brd_cleanup (ci_t *);
 int __init  sbecom_proc_brd_init (ci_t *);
 
-#endif                          /*** __KERNEL__ ***/
+#else
+
+static inline void sbecom_proc_brd_cleanup(ci_t * ci)
+{
+}
+
+static inline int __init sbecom_proc_brd_init(ci_t * ci)
+{
+	return 0;
+}
+
 #endif                          /*** CONFIG_PROC_FS ***/
+
 #endif                          /*** _INC_SBEPROC_H_ ***/

