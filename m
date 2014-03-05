Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbaCEBXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:23:41 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55762 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaCEBXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:23:40 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: davem@davemloft.net, sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ying.xue@windriver.com
Subject: [PATCH 6/7] staging: cxtie1: remove unneeded mkret() calls
Date: Wed, 05 Mar 2014 10:23:34 +0900
Message-ID: <2580565.BRTEYLnRvA@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The mkret() change a value of error from positive to
negative. This patch is modified to return negative value
when it failed. It doesn't need to call with function
for changing from positive to negative.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/linux.c     |   72 +++++++++++++----------------------
 drivers/staging/cxt1e1/musycc.c    |    2 +-
 drivers/staging/cxt1e1/pmcc4_drv.c |   40 ++++++++++----------
 3 files changed, 48 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 478516f..5bb42ae 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -146,16 +146,6 @@ get_hdlc_name(hdlc_device *hdlc)
 	return dev->name;
 }
 
-
-static status_t
-mkret(int bsd)
-{
-	if (bsd > 0)
-		return -bsd;
-	else
-		return bsd;
-}
-
 /***************************************************************************/
 #include <linux/workqueue.h>
 
@@ -293,8 +283,8 @@ chan_open(struct net_device *ndev)
 	}
 
 	ret = c4_chan_up(priv->ci, priv->channum);
-	if (ret)
-		return -ret;
+	if (ret < 0)
+		return ret;
 	try_module_get(THIS_MODULE);
 	netif_start_queue(ndev);
 	return 0;                       /* no error = success */
@@ -524,8 +514,8 @@ do_get_port(struct net_device *ndev, void *data)
 	if (!ci)
 		return -EINVAL;             /* get card info */
 
-	ret = mkret(c4_get_port(ci, pp.portnum));
-	if (ret)
+	ret = c4_get_port(ci, pp.portnum);
+	if (ret < 0)
 		return ret;
 	if (copy_to_user(data, &ci->port[pp.portnum].p,
 			 sizeof(struct sbecom_port_param)))
@@ -552,7 +542,7 @@ do_set_port(struct net_device *ndev, void *data)
 		return -ENXIO;
 
 	memcpy(&ci->port[pp.portnum].p, &pp, sizeof(struct sbecom_port_param));
-	return mkret(c4_set_port(ci, pp.portnum));
+	return c4_set_port(ci, pp.portnum);
 }
 
 /* work the port loopback mode as per directed */
@@ -567,7 +557,7 @@ do_port_loop(struct net_device *ndev, void *data)
 	ci = get_ci_by_dev(ndev);
 	if (!ci)
 		return -EINVAL;
-	return mkret(c4_loop_port(ci, pp.portnum, pp.port_mode));
+	return c4_loop_port(ci, pp.portnum, pp.port_mode);
 }
 
 /* set the specified register with the given value / or just read it */
@@ -583,8 +573,8 @@ do_framer_rw(struct net_device *ndev, void *data)
 	ci = get_ci_by_dev(ndev);
 	if (!ci)
 		return -EINVAL;
-	ret = mkret(c4_frame_rw(ci, &pp));
-	if (ret)
+	ret = c4_frame_rw(ci, &pp);
+	if (ret < 0)
 		return ret;
 	if (copy_to_user(data, &pp, sizeof(struct sbecom_port_param)))
 		return -EFAULT;
@@ -604,7 +594,8 @@ do_pld_rw(struct net_device *ndev, void *data)
 	ci = get_ci_by_dev(ndev);
 	if (!ci)
 		return -EINVAL;
-	ret = mkret(c4_pld_rw(ci, &pp));
+
+	ret = c4_pld_rw(ci, &pp);
 	if (ret)
 		return ret;
 	if (copy_to_user(data, &pp, sizeof(struct sbecom_port_param)))
@@ -625,8 +616,8 @@ do_musycc_rw(struct net_device *ndev, void *data)
 	ci = get_ci_by_dev(ndev);
 	if (!ci)
 		return -EINVAL;
-	ret = mkret(c4_musycc_rw(ci, &mp));
-	if (ret)
+	ret = c4_musycc_rw(ci, &mp);
+	if (ret < 0)
 		return ret;
 	if (copy_to_user(data, &mp, sizeof(struct c4_musycc_param)))
 		return -EFAULT;
@@ -643,8 +634,8 @@ do_get_chan(struct net_device *ndev, void *data)
 				sizeof(struct sbecom_chan_param)))
 		return -EFAULT;
 
-	ret = mkret(c4_get_chan(cp.channum, &cp));
-	if (ret)
+	ret = c4_get_chan(cp.channum, &cp);
+	if (ret < 0)
 		return ret;
 
 	if (copy_to_user(data, &cp, sizeof(struct sbecom_chan_param)))
@@ -656,7 +647,6 @@ static status_t
 do_set_chan(struct net_device *ndev, void *data)
 {
 	struct sbecom_chan_param cp;
-	int         ret;
 	ci_t       *ci;
 
 	if (copy_from_user(&cp, data, sizeof(struct sbecom_chan_param)))
@@ -664,13 +654,7 @@ do_set_chan(struct net_device *ndev, void *data)
 	ci = get_ci_by_dev(ndev);
 	if (!ci)
 		return -EINVAL;
-	switch (ret = mkret(c4_set_chan(cp.channum, &cp)))
-	{
-	case 0:
-		return 0;
-	default:
-		return ret;
-	}
+	return c4_set_chan(cp.channum, &cp);
 }
 
 static status_t
@@ -689,8 +673,8 @@ do_create_chan(struct net_device *ndev, void *data)
 	dev = create_chan(ndev, ci, &cp);
 	if (!dev)
 		return -EBUSY;
-	ret = mkret(c4_new_chan(ci, cp.port, cp.channum, dev));
-	if (ret) {
+	ret = c4_new_chan(ci, cp.port, cp.channum, dev);
+	if (ret < 0) {
 		/* needed due to Ioctl calling sequence */
 		rtnl_unlock();
 		unregister_hdlc_device(dev);
@@ -710,13 +694,11 @@ do_get_chan_stats(struct net_device *ndev, void *data)
 	if (copy_from_user(&ccs, data,
 			   sizeof(struct c4_chan_stats_wrap)))
 		return -EFAULT;
-	switch (ret = mkret(c4_get_chan_stats(ccs.channum, &ccs.stats)))
-	{
-	case 0:
-		break;
-	default:
+
+	ret = c4_get_chan_stats(ccs.channum, &ccs.stats);
+	if (ret < 0)
 		return ret;
-	}
+
 	if (copy_to_user(data, &ccs,
 			 sizeof(struct c4_chan_stats_wrap)))
 		return -EFAULT;
@@ -824,7 +806,7 @@ do_reset_chan_stats(struct net_device *musycc_dev, void *data)
 	if (copy_from_user(&cp, data,
 			   sizeof(struct sbecom_chan_param)))
 		return -EFAULT;
-	return mkret(c4_del_chan_stats(cp.channum));
+	return c4_del_chan_stats(cp.channum);
 }
 
 static status_t
@@ -938,7 +920,7 @@ c4_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
 		ret = -EINVAL;
 		break;
 	}
-	return mkret(ret);
+	return ret;
 }
 
 static const struct net_device_ops c4_ops = {
@@ -964,7 +946,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 	if (!ndev) {
 		pr_warning("%s: no memory for struct net_device !\n",
 			   hi->devname);
-		error_flag = ENOMEM;
+		error_flag = -ENOMEM;
 		return NULL;
 	}
 	ci = (ci_t *)(netdev_priv(ndev));
@@ -1000,7 +982,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		(c4_init(ci, (u_char *) f0, (u_char *) f1) != SBE_DRVR_SUCCESS)) {
 		OS_kfree(netdev_priv(ndev));
 		OS_kfree(ndev);
-		error_flag = ENODEV;
+		error_flag = -ENODEV;
 		return NULL;
 	}
 	/*************************************************************
@@ -1026,7 +1008,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		unregister_netdev(ndev);
 		OS_kfree(netdev_priv(ndev));
 		OS_kfree(ndev);
-		error_flag = EIO;
+		error_flag = -EIO;
 		return NULL;
 	}
 #ifdef CONFIG_SBE_PMCC4_NCOMM
@@ -1036,7 +1018,7 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 		free_irq(irq0, ndev);
 		OS_kfree(netdev_priv(ndev));
 		OS_kfree(ndev);
-		error_flag = EIO;
+		error_flag = -EIO;
 		return NULL;
 	}
 #endif
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 7a3a30c..28765be 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -1546,7 +1546,7 @@ musycc_chan_down(ci_t *dummy, int channum)
     int         i, gchan;
 
     if (!(ch = sd_find_chan(dummy, channum)))
-	return EINVAL;
+	return -EINVAL;
     pi = ch->up;
     gchan = ch->gchan;
 
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index a9d9575..bcd61df 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -756,7 +756,7 @@ c4_frame_rw (ci_t *ci, struct sbecom_port_param *pp)
     volatile u_int32_t data;
 
     if (pp->portnum >= ci->max_port)/* sanity check */
-        return ENXIO;
+        return -ENXIO;
 
     comet = ci->port[pp->portnum].cometbase;
     data = pci_read_32 ((u_int32_t *) comet + pp->port_mode) & 0xff;
@@ -845,7 +845,7 @@ c4_musycc_rw (ci_t *ci, struct c4_musycc_param *mcp)
      */
     portnum = (mcp->offset % 0x6000) / 0x800;
     if (portnum >= ci->max_port)
-        return ENXIO;
+        return -ENXIO;
     pi = &ci->port[portnum];
     if (mcp->offset >= 0x6000)
         offset += 0x6000;           /* put back in MsgCfgDesc address offset */
@@ -894,7 +894,7 @@ status_t
 c4_get_port (ci_t *ci, int portnum)
 {
     if (portnum >= ci->max_port)    /* sanity check */
-        return ENXIO;
+        return -ENXIO;
 
     SD_SEM_TAKE (&ci->sem_wdbusy, "_wd_");      /* only 1 thru here, per
                                                  * board */
@@ -915,7 +915,7 @@ c4_set_port (ci_t *ci, int portnum)
     int         i;
 
     if (portnum >= ci->max_port)    /* sanity check */
-        return ENXIO;
+        return -ENXIO;
 
     pi = &ci->port[portnum];
     pp = &ci->port[portnum].p;
@@ -927,7 +927,7 @@ c4_set_port (ci_t *ci, int portnum)
                 portnum, e1mode, pi->openchans);
     }
     if (pi->openchans)
-        return EBUSY;               /* group needs initialization only for
+        return -EBUSY;               /* group needs initialization only for
                                      * first channel of a group */
 
     {
@@ -1018,10 +1018,10 @@ c4_new_chan (ci_t *ci, int portnum, int channum, void *user)
     int         gchan;
 
     if (c4_find_chan (channum))     /* a new channel shouldn't already exist */
-        return EEXIST;
+        return -EEXIST;
 
     if (portnum >= ci->max_port)    /* sanity check */
-        return ENXIO;
+        return -ENXIO;
 
     pi = &(ci->port[portnum]);
     /* find any available channel within this port */
@@ -1032,7 +1032,7 @@ c4_new_chan (ci_t *ci, int portnum, int channum, void *user)
             break;
     }
     if (gchan == MUSYCC_NCHANS)     /* exhausted table, all were assigned */
-        return ENFILE;
+        return -ENFILE;
 
     ch->up = pi;
 
@@ -1080,7 +1080,7 @@ c4_del_chan (int channum)
     mch_t      *ch;
 
     if (!(ch = c4_find_chan (channum)))
-        return ENOENT;
+        return -ENOENT;
     if (ch->state == UP)
         musycc_chan_down ((ci_t *) 0, channum);
     ch->state = UNASSIGNED;
@@ -1096,7 +1096,7 @@ c4_del_chan_stats (int channum)
     mch_t      *ch;
 
     if (!(ch = c4_find_chan (channum)))
-        return ENOENT;
+        return -ENOENT;
 
     memset (&ch->s, 0, sizeof (struct sbecom_chan_stats));
     return 0;
@@ -1110,18 +1110,18 @@ c4_set_chan (int channum, struct sbecom_chan_param *p)
     int         i, x = 0;
 
     if (!(ch = c4_find_chan (channum)))
-        return ENOENT;
+        return -ENOENT;
 
 #if 1
     if (ch->p.card != p->card ||
         ch->p.port != p->port ||
         ch->p.channum != p->channum)
-        return EINVAL;
+        return -EINVAL;
 #endif
 
     if (!(ch->up->group_is_set))
     {
-        return EIO;                 /* out of order, SET_PORT command
+        return -EIO;                 /* out of order, SET_PORT command
                                      * required prior to first group's
                                      * SET_CHAN command */
     }
@@ -1160,7 +1160,7 @@ c4_get_chan (int channum, struct sbecom_chan_param *p)
     mch_t      *ch;
 
     if (!(ch = c4_find_chan (channum)))
-        return ENOENT;
+        return -ENOENT;
     *p = ch->p;
     return 0;
 }
@@ -1171,7 +1171,7 @@ c4_get_chan_stats (int channum, struct sbecom_chan_stats *p)
     mch_t      *ch;
 
     if (!(ch = c4_find_chan (channum)))
-        return ENOENT;
+        return -ENOENT;
     *p = ch->s;
     p->tx_pending = atomic_read (&ch->tx_pending);
     return 0;
@@ -1241,7 +1241,7 @@ c4_chan_up (ci_t *ci, int channum)
                                  * platform */
 
     if (!(ch = c4_find_chan (channum)))
-        return ENOENT;
+        return -ENOENT;
     if (ch->state == UP)
     {
         if (cxt1e1_log_level >= LOG_MONITOR)
@@ -1264,7 +1264,7 @@ c4_chan_up (ci_t *ci, int channum)
                 pr_info("+ ask4 %x, currently %x\n",
                         ch->p.bitmask[i], pi->tsm[i]);
             }
-            return EINVAL;
+            return -EINVAL;
         }
         for (j = 0; j < 8; j++)
             if (ch->p.bitmask[i] & (1 << j))
@@ -1277,7 +1277,7 @@ c4_chan_up (ci_t *ci, int channum)
         /* if( cxt1e1_log_level >= LOG_WARN)  */
         pr_info("%s: c4_chan_up[%d] ENOBUFS (no TimeSlots assigned)\n",
                 ci->devname, channum);
-        return ENOBUFS;             /* this should not happen */
+        return -ENOBUFS;             /* this should not happen */
     }
     addr = c4_fifo_alloc (pi, gchan, &nbuf);
     ch->state = UP;
@@ -1454,7 +1454,7 @@ errfree:
     ch->mdr = NULL;
     ch->rxd_num = 0;
     ch->state = DOWN;
-    return ENOBUFS;
+    return -ENOBUFS;
 }
 
 /* stop the hardware from servicing & interrupting */
@@ -1534,7 +1534,7 @@ c4_get_iidinfo (ci_t *ci, struct sbe_iid_info *iip)
     char       *np;
 
     if (!(dev = getuserbychan (iip->channum)))
-        return ENOENT;
+        return -ENOENT;
 
     np = dev->name;
     strncpy (iip->iname, np, CHNM_STRLEN - 1);
-- 
1.7.4.4


