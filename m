Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab3FGXwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:52:11 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58624 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757120Ab3FGXvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:51:44 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 5/6] kthread: avoid parsing names as format strings
Date: Fri,  7 Jun 2013 16:50:54 -0700
Message-Id: <1370649055-12830-6-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370649055-12830-1-git-send-email-keescook@chromium.org>
References: <1370649055-12830-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling kthread_run with a single name parameter causes it to be handled
as a format string. Many callers are passing potentially dynamic string
content, so use "%s" in those cases to avoid any potential accidents.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/block/aoe/aoecmd.c           |    2 +-
 drivers/block/mtip32xx/mtip32xx.c    |    3 ++-
 drivers/block/xen-blkback/xenbus.c   |    2 +-
 drivers/hwmon/adt7470.c              |    2 +-
 drivers/media/i2c/tvaudio.c          |    3 ++-
 drivers/media/pci/ivtv/ivtv-driver.c |    2 +-
 drivers/media/platform/vivi.c        |    3 ++-
 drivers/mtd/ubi/build.c              |    2 +-
 drivers/net/wireless/airo.c          |    3 ++-
 drivers/scsi/aacraid/commctrl.c      |    3 ++-
 drivers/scsi/aacraid/commsup.c       |    3 ++-
 drivers/spi/spi.c                    |    2 +-
 drivers/staging/rtl8712/os_intfs.c   |    2 +-
 drivers/usb/atm/usbatm.c             |    5 +++--
 fs/lockd/svc.c                       |    2 +-
 fs/nfs/callback.c                    |    5 ++---
 fs/nfs/nfs4state.c                   |    2 +-
 kernel/rcutree.c                     |    2 +-
 net/sunrpc/svc.c                     |    2 +-
 19 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index fc803ec..b75c7db 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1340,7 +1340,7 @@ aoe_ktstart(struct ktstate *k)
 	struct task_struct *task;
 
 	init_completion(&k->rendez);
-	task = kthread_run(kthread, k, k->name);
+	task = kthread_run(kthread, k, "%s", k->name);
 	if (task == NULL || IS_ERR(task))
 		return -ENOMEM;
 	k->task = task;
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 847107e..81ce4c0 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4085,7 +4085,8 @@ skip_create_disk:
 start_service_thread:
 	sprintf(thd_name, "mtip_svc_thd_%02d", index);
 	dd->mtip_svc_handler = kthread_create_on_node(mtip_service_thread,
-						dd, dd->numa_node, thd_name);
+						dd, dd->numa_node, "%s",
+						thd_name);
 
 	if (IS_ERR(dd->mtip_svc_handler)) {
 		dev_err(&dd->pdev->dev, "service thread failed to start\n");
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 8bfd1bc..04608a6 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -93,7 +93,7 @@ static void xen_update_blkif_status(struct xen_blkif *blkif)
 	}
 	invalidate_inode_pages2(blkif->vbd.bdev->bd_inode->i_mapping);
 
-	blkif->xenblkd = kthread_run(xen_blkif_schedule, blkif, name);
+	blkif->xenblkd = kthread_run(xen_blkif_schedule, blkif, "%s", name);
 	if (IS_ERR(blkif->xenblkd)) {
 		err = PTR_ERR(blkif->xenblkd);
 		blkif->xenblkd = NULL;
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index b83bf4b..0f34bca 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1285,7 +1285,7 @@ static int adt7470_probe(struct i2c_client *client,
 	}
 
 	init_completion(&data->auto_update_stop);
-	data->auto_update = kthread_run(adt7470_update_thread, client,
+	data->auto_update = kthread_run(adt7470_update_thread, client, "%s",
 					dev_name(data->hwmon_dev));
 	if (IS_ERR(data->auto_update)) {
 		err = PTR_ERR(data->auto_update);
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index b72a59d..e0634c8 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -2020,7 +2020,8 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 		/* start async thread */
 		chip->wt.function = chip_thread_wake;
 		chip->wt.data     = (unsigned long)chip;
-		chip->thread = kthread_run(chip_thread, chip, client->name);
+		chip->thread = kthread_run(chip_thread, chip, "%s",
+					   client->name);
 		if (IS_ERR(chip->thread)) {
 			v4l2_warn(sd, "failed to create kthread\n");
 			chip->thread = NULL;
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 07b8460..b809bc8 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -753,7 +753,7 @@ static int ivtv_init_struct1(struct ivtv *itv)
 
 	init_kthread_worker(&itv->irq_worker);
 	itv->irq_worker_task = kthread_run(kthread_worker_fn, &itv->irq_worker,
-					   itv->v4l2_dev.name);
+					   "%s", itv->v4l2_dev.name);
 	if (IS_ERR(itv->irq_worker_task)) {
 		IVTV_ERR("Could not create ivtv task\n");
 		return -1;
diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 85bc314..1d3f119 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -768,7 +768,8 @@ static int vivi_start_generating(struct vivi_dev *dev)
 
 	dma_q->frame = 0;
 	dma_q->ini_jiffies = jiffies;
-	dma_q->kthread = kthread_run(vivi_thread, dev, dev->v4l2_dev.name);
+	dma_q->kthread = kthread_run(vivi_thread, dev, "%s",
+				     dev->v4l2_dev.name);
 
 	if (IS_ERR(dma_q->kthread)) {
 		v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index a561335..0aaece9 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1005,7 +1005,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	if (err)
 		goto out_uif;
 
-	ubi->bgt_thread = kthread_create(ubi_thread, ubi, ubi->bgt_name);
+	ubi->bgt_thread = kthread_create(ubi_thread, ubi, "%s", ubi->bgt_name);
 	if (IS_ERR(ubi->bgt_thread)) {
 		err = PTR_ERR(ubi->bgt_thread);
 		ubi_err("cannot spawn \"%s\", error %d", ubi->bgt_name,
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 6125adb..d0adbaf 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1893,7 +1893,8 @@ static int airo_open(struct net_device *dev) {
 
 	if (ai->wifidev != dev) {
 		clear_bit(JOB_DIE, &ai->jobs);
-		ai->airo_thread_task = kthread_run(airo_thread, dev, dev->name);
+		ai->airo_thread_task = kthread_run(airo_thread, dev, "%s",
+						   dev->name);
 		if (IS_ERR(ai->airo_thread_task))
 			return (int)PTR_ERR(ai->airo_thread_task);
 
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 1ef041b..d85ac1a 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -318,7 +318,8 @@ return_fib:
 			kthread_stop(dev->thread);
 			ssleep(1);
 			dev->aif_thread = 0;
-			dev->thread = kthread_run(aac_command_thread, dev, dev->name);
+			dev->thread = kthread_run(aac_command_thread, dev,
+						  "%s", dev->name);
 			ssleep(1);
 		}
 		if (f.wait) {
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 1be0776..cab190a 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1336,7 +1336,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 		if ((retval = pci_set_dma_mask(aac->pdev, DMA_BIT_MASK(32))))
 			goto out;
 	if (jafo) {
-		aac->thread = kthread_run(aac_command_thread, aac, aac->name);
+		aac->thread = kthread_run(aac_command_thread, aac, "%s",
+					  aac->name);
 		if (IS_ERR(aac->thread)) {
 			retval = PTR_ERR(aac->thread);
 			goto out;
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 32b7bb1..085db8b 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -601,7 +601,7 @@ static int spi_init_queue(struct spi_master *master)
 
 	init_kthread_worker(&master->kworker);
 	master->kworker_task = kthread_run(kthread_worker_fn,
-					   &master->kworker,
+					   &master->kworker, "%s",
 					   dev_name(&master->dev));
 	if (IS_ERR(master->kworker_task)) {
 		dev_err(&master->dev, "failed to create message pump task\n");
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index b65bf5e..6e81ba0 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -238,7 +238,7 @@ struct net_device *r8712_init_netdev(void)
 
 static u32 start_drv_threads(struct _adapter *padapter)
 {
-	padapter->cmdThread = kthread_run(r8712_cmd_thread, padapter,
+	padapter->cmdThread = kthread_run(r8712_cmd_thread, padapter, "%s",
 			      padapter->pnetdev->name);
 	if (IS_ERR(padapter->cmdThread) < 0)
 		return _FAIL;
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index d3527dd..5e0d33a 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -1020,7 +1020,7 @@ static int usbatm_heavy_init(struct usbatm_data *instance)
 {
 	struct task_struct *t;
 
-	t = kthread_create(usbatm_do_heavy_init, instance,
+	t = kthread_create(usbatm_do_heavy_init, instance, "%s",
 			instance->driver->driver_name);
 	if (IS_ERR(t)) {
 		usb_err(instance, "%s: failed to create kernel_thread (%ld)!\n",
@@ -1076,7 +1076,8 @@ int usbatm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id,
 	/* public fields */
 
 	instance->driver = driver;
-	snprintf(instance->driver_name, sizeof(instance->driver_name), driver->driver_name);
+	strlcpy(instance->driver_name, driver->driver_name,
+		sizeof(instance->driver_name));
 
 	instance->usb_dev = usb_dev;
 	instance->usb_intf = intf;
diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index a2aa97d..10d6c41 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -305,7 +305,7 @@ static int lockd_start_svc(struct svc_serv *serv)
 	svc_sock_update_bufs(serv);
 	serv->sv_maxconn = nlm_max_connections;
 
-	nlmsvc_task = kthread_run(lockd, nlmsvc_rqst, serv->sv_name);
+	nlmsvc_task = kthread_run(lockd, nlmsvc_rqst, "%s", serv->sv_name);
 	if (IS_ERR(nlmsvc_task)) {
 		error = PTR_ERR(nlmsvc_task);
 		printk(KERN_WARNING
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index cff089a..da6a43d 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -211,7 +211,6 @@ static int nfs_callback_start_svc(int minorversion, struct rpc_xprt *xprt,
 	struct svc_rqst *rqstp;
 	int (*callback_svc)(void *vrqstp);
 	struct nfs_callback_data *cb_info = &nfs_callback_info[minorversion];
-	char svc_name[12];
 	int ret;
 
 	nfs_callback_bc_serv(minorversion, xprt, serv);
@@ -235,10 +234,10 @@ static int nfs_callback_start_svc(int minorversion, struct rpc_xprt *xprt,
 
 	svc_sock_update_bufs(serv);
 
-	sprintf(svc_name, "nfsv4.%u-svc", minorversion);
 	cb_info->serv = serv;
 	cb_info->rqst = rqstp;
-	cb_info->task = kthread_run(callback_svc, cb_info->rqst, svc_name);
+	cb_info->task = kthread_run(callback_svc, cb_info->rqst,
+				    "nfsv4.%u-svc", minorversion);
 	if (IS_ERR(cb_info->task)) {
 		ret = PTR_ERR(cb_info->task);
 		svc_exit_thread(cb_info->rqst);
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 1fab140..73d0f75 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1194,7 +1194,7 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 	snprintf(buf, sizeof(buf), "%s-manager",
 			rpc_peeraddr2str(clp->cl_rpcclient, RPC_DISPLAY_ADDR));
 	rcu_read_unlock();
-	task = kthread_run(nfs4_run_state_manager, clp, buf);
+	task = kthread_run(nfs4_run_state_manager, clp, "%s", buf);
 	if (IS_ERR(task)) {
 		printk(KERN_ERR "%s: kthread_run: %ld\n",
 			__func__, PTR_ERR(task));
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 16ea679..ea7fe31 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -3108,7 +3108,7 @@ static int __init rcu_spawn_gp_kthread(void)
 	struct task_struct *t;
 
 	for_each_rcu_flavor(rsp) {
-		t = kthread_run(rcu_gp_kthread, rsp, rsp->name);
+		t = kthread_run(rcu_gp_kthread, rsp, "%s", rsp->name);
 		BUG_ON(IS_ERR(t));
 		rnp = rcu_get_root(rsp);
 		raw_spin_lock_irqsave(&rnp->lock, flags);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 89a588b..b974571 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -740,7 +740,7 @@ svc_set_num_threads(struct svc_serv *serv, struct svc_pool *pool, int nrservs)
 
 		__module_get(serv->sv_module);
 		task = kthread_create_on_node(serv->sv_function, rqstp,
-					      node, serv->sv_name);
+					      node, "%s", serv->sv_name);
 		if (IS_ERR(task)) {
 			error = PTR_ERR(task);
 			module_put(serv->sv_module);
-- 
1.7.9.5

