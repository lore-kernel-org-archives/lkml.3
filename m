Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbaDRAcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:32:09 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56924 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDRAcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:05 -0400
Date: Fri, 18 Apr 2014 09:31:35 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, sachin.kamat@linaro.org, shaun@xresource.ca,
        ebru.akagunduz@gmail.com, dulshani.gunawardhana89@gmail.com,
        speiro@ai2.upv.es, gulsah.1004@gmail.com, himangi774@gmail.com,
        peter.p.waskiewicz.jr@intel.com, fempsci@gmail.com,
        nandu.hgowda@gmail.com, sima.baymani@gmail.com,
        viro@zeniv.linux.org.uk, dhowells@redhat.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        tklauser@distanz.ch
Subject: [PATCH V4] staging: cxt1e1: replace OS_kmalloc/OS_kfree with
 kzalloc/kfree
Message-ID: <20140418003135.GA8135@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace OS_kmalloc/OS_kfree with kzalloc/kfree.
And also some allocation doesn't need to use GFP_DMA
so just use GFP_KERNEL.

c4_new() function is never called, remove it.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
V4: update patch description, OS_kmalloc should be replaced with
kzalloc for zeroed out the allocated data.
V3: replace kmalloc with kzalloc.
V2: fix subject and comment correctly.

It has some coding style issue. If this patch is merged,
I fix this issue with another patch.

 drivers/staging/cxt1e1/hwprobe.c             |    2 +-
 drivers/staging/cxt1e1/linux.c               |   21 +++++------
 drivers/staging/cxt1e1/musycc.c              |   12 ++++---
 drivers/staging/cxt1e1/pmcc4_drv.c           |   47 +++++---------------------
 drivers/staging/cxt1e1/sbecom_inline_linux.h |   23 +------------
 drivers/staging/cxt1e1/sbecrc.c              |    5 ++-
 drivers/staging/cxt1e1/sbeproc.c             |    2 +-
 7 files changed, 32 insertions(+), 80 deletions(-)

diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 9b4198b..6e207f5 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -205,7 +205,7 @@ cleanup_devs(void)
 #ifdef CONFIG_SBE_PMCC4_NCOMM
 		free_irq(hi->pdev[1]->irq, hi->ndev);
 #endif
-		OS_kfree(hi->ndev);
+		kfree(hi->ndev);
 	}
 }
 
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index b02f5ade..4b4609d 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -60,7 +60,6 @@ status_t    c4_chan_work_init(mpi_t *, mch_t *);
 void        musycc_wq_chan_restart(void *);
 status_t __init c4_init(ci_t *, u_char *, u_char *);
 status_t __init c4_init2(ci_t *);
-ci_t       *__init c4_new(void *);
 int __init  c4hw_attach_all(void);
 void __init hdw_sn_get(hdw_info_t *, int);
 
@@ -418,7 +417,7 @@ create_chan(struct net_device *ndev, ci_t *ci,
 		struct c4_priv *priv;
 
 		/* allocate then fill in private data structure */
-		priv = OS_kmalloc(sizeof(struct c4_priv));
+		priv = kzalloc(sizeof(struct c4_priv), GFP_KERNEL);
 		if (!priv) {
 			pr_warning("%s: no memory for net_device !\n",
 				   ci->devname);
@@ -428,7 +427,7 @@ create_chan(struct net_device *ndev, ci_t *ci,
 		if (!dev) {
 			pr_warning("%s: no memory for hdlc_device !\n",
 				   ci->devname);
-			OS_kfree(priv);
+			kfree(priv);
 			return NULL;
 		}
 		priv->ci = ci;
@@ -972,8 +971,8 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 
 	if (register_netdev(ndev) ||
 		(c4_init(ci, (u_char *) f0, (u_char *) f1) != SBE_DRVR_SUCCESS)) {
-		OS_kfree(netdev_priv(ndev));
-		OS_kfree(ndev);
+		kfree(netdev_priv(ndev));
+		kfree(ndev);
 		error_flag = -ENODEV;
 		return NULL;
 	}
@@ -998,8 +997,8 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		pr_warning("%s: MUSYCC could not get irq: %d\n",
 			   ndev->name, irq0);
 		unregister_netdev(ndev);
-		OS_kfree(netdev_priv(ndev));
-		OS_kfree(ndev);
+		kfree(netdev_priv(ndev));
+		kfree(ndev);
 		error_flag = -EIO;
 		return NULL;
 	}
@@ -1008,8 +1007,8 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		pr_warning("%s: EBUS could not get irq: %d\n", hi->devname, irq1);
 		unregister_netdev(ndev);
 		free_irq(irq0, ndev);
-		OS_kfree(netdev_priv(ndev));
-		OS_kfree(ndev);
+		kfree(netdev_priv(ndev));
+		kfree(ndev);
 		error_flag = -EIO;
 		return NULL;
 	}
@@ -1068,8 +1067,8 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		unregister_netdev(ndev);
 		free_irq(irq1, ndev);
 		free_irq(irq0, ndev);
-		OS_kfree(netdev_priv(ndev));
-		OS_kfree(ndev);
+		kfree(netdev_priv(ndev));
+		kfree(ndev);
 		/* failure, error_flag is set */
 		return NULL;
 	}
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 7b4f6f2..872cdae 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -744,7 +744,8 @@ musycc_init(ci_t *ci)
 
 #define INT_QUEUE_BOUNDARY  4
 
-    regaddr = OS_kmalloc((INT_QUEUE_SIZE + 1) * sizeof(u_int32_t));
+	regaddr = kzalloc((INT_QUEUE_SIZE + 1) * sizeof(u_int32_t),
+			  GFP_KERNEL | GFP_DMA);
     if (!regaddr)
 	return -ENOMEM;
     ci->iqd_p_saved = regaddr;      /* save orig value for free's usage */
@@ -765,11 +766,12 @@ musycc_init(ci_t *ci)
 
 #define GROUP_BOUNDARY   0x800
 
-	regaddr = OS_kmalloc(sizeof(struct musycc_groupr) + GROUP_BOUNDARY);
+	regaddr = kzalloc(sizeof(struct musycc_groupr) + GROUP_BOUNDARY,
+			  GFP_KERNEL | GFP_DMA);
 	if (!regaddr) {
 	    for (gchan = 0; gchan < i; gchan++) {
 		pi = &ci->port[gchan];
-		OS_kfree(pi->reg);
+		kfree(pi->reg);
 		pi->reg = NULL;
 	    }
 	    return -ENOMEM;
@@ -1576,10 +1578,10 @@ musycc_chan_down(ci_t *dummy, int channum)
 	if (ch->mdr[i].mem_token)
 	    OS_mem_token_free(ch->mdr[i].mem_token);
 
-    OS_kfree(ch->mdr);
+    kfree(ch->mdr);
     ch->mdr = NULL;
     ch->rxd_num = 0;
-    OS_kfree(ch->mdt);
+    kfree(ch->mdt);
     ch->mdt = NULL;
     ch->txd_num = 0;
 
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 621a729..76bebdd 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -122,35 +122,6 @@ c4_find_chan (int channum)
     return NULL;
 }
 
-
-ci_t       *__init
-c4_new (void *hi)
-{
-    ci_t       *ci;
-
-#ifdef SBE_MAP_DEBUG
-    pr_warning("c4_new() entered, ci needs %u.\n",
-               (unsigned int) sizeof (ci_t));
-#endif
-
-    ci = (ci_t *) OS_kmalloc (sizeof (ci_t));
-    if (ci)
-    {
-        ci->hdw_info = hi;
-        ci->state = C_INIT;         /* mark as hardware not available */
-        ci->next = c4_list;
-        c4_list = ci;
-        ci->brdno = ci->next ? ci->next->brdno + 1 : 0;
-    } else
-        pr_warning("failed CI malloc, size %u.\n",
-                   (unsigned int) sizeof (ci_t));
-
-    if (!CI)
-        CI = ci;                    /* DEBUG, only board 0 usage */
-    return ci;
-}
-
-
 /***
  * Check port state and set LED states using watchdog or ioctl...
  * also check for in-band SF loopback commands (& cause results if they are there)
@@ -485,12 +456,12 @@ c4_cleanup (void)
             for (j = 0; j < MUSYCC_NCHANS; j++)
             {
                 if (pi->chan[j])
-                    OS_kfree (pi->chan[j]);     /* free mch_t struct */
+                    kfree(pi->chan[j]);     /* free mch_t struct */
             }
-            OS_kfree (pi->regram_saved);
+            kfree(pi->regram_saved);
         }
-        OS_kfree (ci->iqd_p_saved);
-        OS_kfree (ci);
+        kfree(ci->iqd_p_saved);
+        kfree(ci);
         ci = next;                  /* cleanup next board, if any */
     }
 }
@@ -619,7 +590,7 @@ c4_init (ci_t *ci, u_char *func0, u_char *func1)
         /* allocate channel structures for this port */
         for (j = 0; j < MUSYCC_NCHANS; j++)
         {
-            ch = OS_kmalloc (sizeof (mch_t));
+		ch = kzalloc(sizeof(mch_t), GFP_KERNEL | GFP_DMA);
             if (ch)
             {
                 pi->chan[j] = ch;
@@ -1368,8 +1339,8 @@ c4_chan_up (ci_t *ci, int channum)
     ch->txd_num = txnum;
     ch->rxix_irq_srv = 0;
 
-    ch->mdr = OS_kmalloc (sizeof (struct mdesc) * rxnum);
-    ch->mdt = OS_kmalloc (sizeof (struct mdesc) * txnum);
+	ch->mdr = kzalloc(sizeof(struct mdesc) * rxnum, GFP_KERNEL | GFP_DMA);
+	ch->mdt = kzalloc(sizeof(struct mdesc) * txnum, GFP_KERNEL | GFP_DMA);
     if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)
                tmp = __constant_cpu_to_le32 (cxt1e1_max_mru | EOBIRQ_ENABLE);
     else
@@ -1462,10 +1433,10 @@ errfree:
         i--;
         OS_mem_token_free (ch->mdr[i].mem_token);
     }
-    OS_kfree (ch->mdt);
+    kfree(ch->mdt);
     ch->mdt = NULL;
     ch->txd_num = 0;
-    OS_kfree (ch->mdr);
+    kfree(ch->mdr);
     ch->mdr = NULL;
     ch->rxd_num = 0;
     ch->state = DOWN;
diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index ba3ff3e..f5835c2 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -39,27 +39,6 @@ void        pci_write_32 (u_int32_t *p, u_int32_t v);
  * system dependent callbacks
  */
 
-/**********/
-/* malloc */
-/**********/
-
-static inline void *
-OS_kmalloc (size_t size)
-{
-    char       *ptr = kmalloc (size, GFP_KERNEL | GFP_DMA);
-
-    if (ptr)
-        memset (ptr, 0, size);
-    return ptr;
-}
-
-static inline void
-OS_kfree (void *x)
-{
-    kfree (x);
-}
-
-
 /****************/
 /* memory token */
 /****************/
@@ -197,7 +176,7 @@ static inline int
 OS_free_watchdog (struct watchdog *wd)
 {
     OS_stop_watchdog (wd);
-    OS_kfree (wd);
+    kfree(wd);
     return 0;
 }
 
diff --git a/drivers/staging/cxt1e1/sbecrc.c b/drivers/staging/cxt1e1/sbecrc.c
index 81fa8a3..a51780f 100644
--- a/drivers/staging/cxt1e1/sbecrc.c
+++ b/drivers/staging/cxt1e1/sbecrc.c
@@ -101,7 +101,8 @@ sbeCrc(u_int8_t *buffer,          /* data buffer to crc */
 		tbl = &CRCTable;
 		genCrcTable(tbl);
 #else
-		tbl = (u_int32_t *) OS_kmalloc(CRC_TABLE_ENTRIES * sizeof(u_int32_t));
+		tbl = kzalloc(CRC_TABLE_ENTRIES * sizeof(u_int32_t),
+			      GFP_KERNEL);
 		if (!tbl) {
 			*result = 0;   /* dummy up return value due to malloc
 					* failure */
@@ -125,7 +126,7 @@ sbeCrc(u_int8_t *buffer,          /* data buffer to crc */
 
 #ifndef STATIC_CRC_TABLE
 	crcTableInit = 0;
-	OS_kfree(tbl);
+	kfree(tbl);
 #endif
 }
 
diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index 840c647..1c2e52e 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -72,7 +72,7 @@ static int sbecom_proc_get_sbe_info(struct seq_file *m, void *v)
 	char       *spd;
 	struct sbe_brd_info *bip;
 
-	bip = OS_kmalloc(sizeof(struct sbe_brd_info));
+	bip = kzalloc(sizeof(struct sbe_brd_info), GFP_KERNEL | GFP_DMA);
 	if (!bip)
 		return -ENOMEM;
 
-- 
1.7.4.4

