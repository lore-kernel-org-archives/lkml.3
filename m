Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaCEBVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:21:09 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:57547 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaCEBVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:21:07 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, sachin.kamat@linaro.org, shaun@xresource.ca,
        dulshani.gunawardhana89@gmail.com, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7 v3] staging: cxt1e1: fix checkpatch error 'assignment in if condition'
Date: Wed, 05 Mar 2014 10:21:01 +0900
Message-ID: <2109601.U7a2ESYcJ8@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


checkpatch.pl error in linux.c:
 ERROR: do not use assignment in if condition

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/cxt1e1/linux.c |   31 +++++++++++++++++++------------
 1 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 579e68e..e4541af 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -229,7 +229,8 @@ c4_wq_port_init(mpi_t *pi)
 	pr_info(">> %s: creating workqueue <%s> for Port %d.\n",
 		__func__, name, pi->portnum); /* RLD DEBUG */
 #endif
-	if (!(pi->wq_port = create_singlethread_workqueue(name)))
+	pi->wq_port = create_singlethread_workqueue(name);
+	if (!pi->wq_port)
 		return -ENOMEM;
 	return 0;                       /* success */
 }
@@ -286,12 +287,14 @@ chan_open(struct net_device *ndev)
 	const struct c4_priv *priv = hdlc->priv;
 	int         ret;
 
-	if ((ret = hdlc_open(ndev)))
-	{
+	ret = hdlc_open(ndev);
+	if (ret) {
 		pr_info("hdlc_open failure, err %d.\n", ret);
 		return ret;
 	}
-	if ((ret = c4_chan_up(priv->ci, priv->channum)))
+
+	ret = c4_chan_up(priv->ci, priv->channum);
+	if (ret)
 		return -ret;
 	try_module_get(THIS_MODULE);
 	netif_start_queue(ndev);
@@ -648,7 +651,8 @@ do_get_chan(struct net_device *ndev, void *data)
 				sizeof(struct sbecom_chan_param)))
 		return -EFAULT;
 
-	if ((ret = mkret(c4_get_chan(cp.channum, &cp))))
+	ret = mkret(c4_get_chan(cp.channum, &cp));
+	if (ret)
 		return ret;
 
 	if (copy_to_user(data, &cp, sizeof(struct sbecom_chan_param)))
@@ -864,7 +868,8 @@ c4_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
 		return -EPERM;
 	if (cmd != SIOCDEVPRIVATE + 15)
 		return -EINVAL;
-	if (!(ci = get_ci_by_dev(ndev)))
+	ci =  get_ci_by_dev(ndev);
+	if (!ci)
 		return -EINVAL;
 	if (ci->state != C_RUNNING)
 		return -ENODEV;
@@ -1100,9 +1105,8 @@ c4_add_dev(hdw_info_t *hi, int brdno, unsigned long f0, unsigned long f1,
 	tasklet_enable(&ci->ci_musycc_isr_tasklet);
 #endif
 
-
-	if ((error_flag = c4_init2(ci)) != SBE_DRVR_SUCCESS)
-	{
+	error_flag = c4_init2(ci);
+	if (error_flag != SBE_DRVR_SUCCESS) {
 #ifdef CONFIG_PROC_FS
 		sbecom_proc_brd_cleanup(ci);
 #endif
@@ -1123,7 +1127,8 @@ c4_mod_init(void)
 	int         rtn;
 
 	pr_warning("%s\n", pmcc4_OSSI_release);
-	if ((rtn = c4hw_attach_all()))
+	rtn = c4hw_attach_all();
+	if (rtn)
 		return -rtn; /* installation failure - see system log */
 
 	/* housekeeping notifications */
@@ -1173,11 +1178,13 @@ cleanup_hdlc(void)
 		{
 			ci = (ci_t *)(netdev_priv(hi->ndev));
 			for (j = 0; j < ci->max_port; j++)
-				for (k = 0; k < MUSYCC_NCHANS; k++)
-					if ((ndev = ci->port[j].chan[k]->user))
+				for (k = 0; k < MUSYCC_NCHANS; k++) {
+					ndev = ci->port[j].chan[k]->user;
+					if (ndev)
 					{
 						do_deluser(ndev, 0);
 					}
+				}
 		}
 	}
 }
-- 
1.7.4.4


