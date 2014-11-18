Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaKRTmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:42:46 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:47617 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaKRTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:42:40 -0500
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: hch@infradead.org, axboe@fb.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: thornber@redhat.com, bvanassche@acm.org, jmad@itu.dk,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [RFC PATCH 4/5] nvme: LightNVM integration
Date: Tue, 18 Nov 2014 20:41:58 +0100
Message-Id: <1416339719-8488-5-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416339719-8488-1-git-send-email-m@bjorling.me>
References: <1416339719-8488-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVMe devices are identified by the vendor specific bits:

Bit 3 in OACS (device-wide). Currently made per device, as the nvme
namespace is missing in the completion path. This is _not_ to be kept
and only added temponarily. Only added to hint blk-mq that it should
reserve space in the per-request private data field for LightNVM.

Bit 1 in DSM (per-namespace).

>From there, the NVMe specification is extended with the following
commands:

  LightNVM Identify
  LightNVM Get Features
  LightNVM Set Responsibility
  LightNVM Synchronious/Asynchronious erase
  LightNVM Get Logical to Physical map

The NVMe integration can be tested using Keith Busch NVMe qemu simulator
with LightNVM patches on top. This can be found at:

  https://github.com/OpenChannelSSD/qemu-nvme

Contributions in this patch from:

  Jesper Madsen <jmad@itu.dk>

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 drivers/block/nvme-core.c | 187 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/nvme.h      |   1 +
 include/uapi/linux/nvme.h |  74 ++++++++++++++++++
 3 files changed, 261 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index 337878b..e012c02 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -38,6 +38,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/lightnvm.h>
 #include <scsi/sg.h>
 #include <asm-generic/io-64-nonatomic-lo-hi.h>
 
@@ -129,6 +130,7 @@ static inline void _nvme_check_size(void)
 	BUILD_BUG_ON(sizeof(struct nvme_id_ns) != 4096);
 	BUILD_BUG_ON(sizeof(struct nvme_lba_range_type) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_smart_log) != 512);
+	BUILD_BUG_ON(sizeof(struct nvme_lnvm_rw_command) != 64);
 }
 
 typedef void (*nvme_completion_fn)(struct nvme_queue *, void *,
@@ -560,6 +562,9 @@ static int nvme_submit_iod(struct nvme_queue *nvmeq, struct nvme_iod *iod,
 	cmnd->rw.control = cpu_to_le16(control);
 	cmnd->rw.dsmgmt = cpu_to_le32(dsmgmt);
 
+	if (req->cmd_flags & REQ_NVM_MAPPED)
+		cmnd->lnvm_rw.phys_addr = cpu_to_le64(req->phys_sector + 1);
+
 	if (++nvmeq->sq_tail == nvmeq->q_depth)
 		nvmeq->sq_tail = 0;
 	writel(nvmeq->sq_tail, nvmeq->q_db);
@@ -576,6 +581,7 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx, struct request *req)
 	enum dma_data_direction dma_dir;
 	int psegs = req->nr_phys_segments;
 	int result = BLK_MQ_RQ_QUEUE_BUSY;
+
 	/*
 	 * Requeued IO has already been prepped
 	 */
@@ -895,6 +901,43 @@ static int adapter_delete_sq(struct nvme_dev *dev, u16 sqid)
 	return adapter_delete_queue(dev, nvme_admin_delete_sq, sqid);
 }
 
+int lnvm_identify(struct nvme_dev *dev, u32 chnl_off, dma_addr_t dma_addr)
+{
+	struct nvme_command c;
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode = lnvm_admin_identify;
+	c.common.nsid = cpu_to_le32(chnl_off);
+	c.common.prp1 = cpu_to_le64(dma_addr);
+
+	return nvme_submit_admin_cmd(dev, &c, NULL);
+}
+
+int lnvm_get_features(struct nvme_dev *dev, unsigned nsid, dma_addr_t dma_addr)
+{
+	struct nvme_command c;
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode = lnvm_admin_get_features;
+	c.common.nsid = cpu_to_le32(nsid);
+	c.common.prp1 = cpu_to_le64(dma_addr);
+
+	return nvme_submit_admin_cmd(dev, &c, NULL);
+}
+
+int lnvm_set_responsibility(struct nvme_dev *dev, unsigned nsid,
+							dma_addr_t dma_addr)
+{
+	struct nvme_command c;
+
+	memset(&c, 0, sizeof(c));
+	c.common.opcode = lnvm_admin_set_responsibility;
+	c.common.nsid = cpu_to_le32(nsid);
+	c.common.prp1 = cpu_to_le64(dma_addr);
+
+	return nvme_submit_admin_cmd(dev, &c, NULL);
+}
+
 int nvme_identify(struct nvme_dev *dev, unsigned nsid, unsigned cns,
 							dma_addr_t dma_addr)
 {
@@ -1282,6 +1325,99 @@ static int nvme_shutdown_ctrl(struct nvme_dev *dev)
 	return 0;
 }
 
+static int init_chnls(struct nvme_dev *dev, struct nvm_id *nvm_id,
+			struct nvme_lnvm_id *dma_buf, dma_addr_t dma_addr)
+{
+	struct nvme_lnvm_id_chnl *src = dma_buf->chnls;
+	struct nvm_id_chnl *dst = nvm_id->chnls;
+	unsigned int len = nvm_id->nchannels;
+	int i, end, off = 0;
+
+	while (len) {
+		end = min_t(u32, NVME_LNVM_CHNLS_PR_REQ, len);
+
+		for (i = 0; i < end; i++, dst++, src++) {
+			dst->queue_size = le64_to_cpu(src->queue_size);
+			dst->gran_read = le64_to_cpu(src->gran_read);
+			dst->gran_write = le64_to_cpu(src->gran_write);
+			dst->gran_erase = le64_to_cpu(src->gran_erase);
+			dst->oob_size = le64_to_cpu(src->oob_size);
+			dst->t_r = le32_to_cpu(src->t_r);
+			dst->t_sqr = le32_to_cpu(src->t_sqr);
+			dst->t_w = le32_to_cpu(src->t_w);
+			dst->t_sqw = le32_to_cpu(src->t_sqw);
+			dst->t_e = le32_to_cpu(src->t_e);
+			dst->io_sched = src->io_sched;
+			dst->laddr_begin = le64_to_cpu(src->laddr_begin);
+			dst->laddr_end = le64_to_cpu(src->laddr_end);
+		}
+
+		len -= end;
+		if (!len)
+			break;
+
+		off += end;
+
+		if (lnvm_identify(dev, off, dma_addr))
+			return -EIO;
+
+		src = dma_buf->chnls;
+	}
+	return 0;
+}
+
+static int nvme_nvm_id(struct request_queue *q, struct nvm_id *nvm_id)
+{
+	struct nvme_ns *ns = q->queuedata;
+	struct nvme_dev *dev = ns->dev;
+	struct pci_dev *pdev = dev->pci_dev;
+	struct nvme_lnvm_id *ctrl;
+	dma_addr_t dma_addr;
+	unsigned int ret;
+
+	ctrl = dma_alloc_coherent(&pdev->dev, 4096, &dma_addr, GFP_KERNEL);
+	if (!ctrl)
+		return -ENOMEM;
+
+	ret = lnvm_identify(dev, 0, dma_addr);
+	if (ret) {
+		ret = -EIO;
+		goto out;
+	}
+
+	nvm_id->ver_id = le16_to_cpu(ctrl->ver_id);
+	nvm_id->nvm_type = ctrl->nvm_type;
+	nvm_id->nchannels = le16_to_cpu(ctrl->nchannels);
+
+	if (!nvm_id->chnls)
+		nvm_id->chnls = kmalloc(sizeof(struct nvm_id_chnl)
+					* nvm_id->nchannels, GFP_KERNEL);
+
+	if (!nvm_id->chnls) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = init_chnls(dev, nvm_id, ctrl, dma_addr);
+out:
+	dma_free_coherent(&pdev->dev, 4096, ctrl, dma_addr);
+	return ret;
+}
+
+static int nvme_nvm_get_features(struct request_queue *q,
+						struct nvm_get_features *gf)
+{
+	gf->rsp[0] = (1 << NVM_RSP_L2P);
+	gf->rsp[0] |= (1 << NVM_RSP_P2L);
+	gf->rsp[0] |= (1 << NVM_RSP_GC);
+	return 0;
+}
+
+static int nvme_nvm_set_rsp(struct request_queue *q, u8 rsp, u8 val)
+{
+	return NVM_RID_NOT_CHANGEABLE | NVM_DNR;
+}
+
 static struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_admin_queue_rq,
 	.map_queue	= blk_mq_map_queue,
@@ -1290,6 +1426,12 @@ static struct blk_mq_ops nvme_mq_admin_ops = {
 	.timeout	= nvme_timeout,
 };
 
+static struct lightnvm_dev_ops nvme_nvm_dev_ops = {
+	.identify		= nvme_nvm_id,
+	.get_features		= nvme_nvm_get_features,
+	.set_responsibility	= nvme_nvm_set_rsp,
+};
+
 static struct blk_mq_ops nvme_mq_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.map_queue	= blk_mq_map_queue,
@@ -1455,6 +1597,26 @@ void nvme_unmap_user_pages(struct nvme_dev *dev, int write,
 		put_page(sg_page(&iod->sg[i]));
 }
 
+static int nvme_nvm_submit_io(struct nvme_ns *ns, struct nvme_user_io *io)
+{
+	struct nvme_command c;
+	struct nvme_dev *dev = ns->dev;
+
+	memset(&c, 0, sizeof(c));
+	c.rw.opcode = io->opcode;
+	c.rw.flags = io->flags;
+	c.rw.nsid = cpu_to_le32(ns->ns_id);
+	c.rw.slba = cpu_to_le64(io->slba);
+	c.rw.length = cpu_to_le16(io->nblocks);
+	c.rw.control = cpu_to_le16(io->control);
+	c.rw.dsmgmt = cpu_to_le32(io->dsmgmt);
+	c.rw.reftag = cpu_to_le32(io->reftag);
+	c.rw.apptag = cpu_to_le16(io->apptag);
+	c.rw.appmask = cpu_to_le16(io->appmask);
+
+	return nvme_submit_io_cmd(dev, ns, &c, NULL);
+}
+
 static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 {
 	struct nvme_dev *dev = ns->dev;
@@ -1480,6 +1642,10 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio)
 	case nvme_cmd_compare:
 		iod = nvme_map_user_pages(dev, io.opcode & 1, io.addr, length);
 		break;
+	case lnvm_admin_identify:
+	case lnvm_admin_get_features:
+	case lnvm_admin_set_responsibility:
+		return nvme_nvm_submit_io(ns, &io);
 	default:
 		return -EINVAL;
 	}
@@ -1769,7 +1935,6 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 	ns->queue = blk_mq_init_queue(&dev->tagset);
 	if (!ns->queue)
 		goto out_free_ns;
-	queue_flag_set_unlocked(QUEUE_FLAG_DEFAULT, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, ns->queue);
 	queue_flag_set_unlocked(QUEUE_FLAG_SG_GAPS, ns->queue);
@@ -1807,8 +1972,18 @@ static struct nvme_ns *nvme_alloc_ns(struct nvme_dev *dev, unsigned nsid,
 	if (dev->oncs & NVME_CTRL_ONCS_DSM)
 		nvme_config_discard(ns);
 
+	if (id->nsfeat & NVME_NS_FEAT_LIGHTNVM) {
+		if (blk_lightnvm_register(ns->queue, &nvme_nvm_dev_ops))
+			goto out_put_disk;
+
+		/* FIXME: This will be handled later by ns */
+		ns->queue->nvm->drv_cmd_size = sizeof(struct nvme_cmd_info);
+	}
+
 	return ns;
 
+ out_put_disk:
+	put_disk(disk);
  out_free_queue:
 	blk_cleanup_queue(ns->queue);
  out_free_ns:
@@ -1954,6 +2129,7 @@ static int nvme_dev_add(struct nvme_dev *dev)
 	ctrl = mem;
 	nn = le32_to_cpup(&ctrl->nn);
 	dev->oncs = le16_to_cpup(&ctrl->oncs);
+	dev->oacs = le16_to_cpup(&ctrl->oacs);
 	dev->abort_limit = ctrl->acl + 1;
 	dev->vwc = ctrl->vwc;
 	memcpy(dev->serial, ctrl->sn, sizeof(ctrl->sn));
@@ -1983,6 +2159,15 @@ static int nvme_dev_add(struct nvme_dev *dev)
 	dev->tagset.flags = BLK_MQ_F_SHOULD_MERGE;
 	dev->tagset.driver_data = dev;
 
+	/* LightNVM is actually per ns, but as the tagset is defined with a set
+	 * of operations for the whole device. It currently is either all or
+	 * no lightnvm compatible name-spaces for a given device.
+	 */
+	if (dev->oacs & NVME_CTRL_OACS_LIGHTNVM) {
+		dev->tagset.flags &= ~BLK_MQ_F_SHOULD_MERGE;
+		dev->tagset.flags |= BLK_MQ_F_LIGHTNVM;
+	}
+
 	if (blk_mq_alloc_tag_set(&dev->tagset))
 		goto out;
 
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 299e6f5..89aed50 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -100,6 +100,7 @@ struct nvme_dev {
 	u32 max_hw_sectors;
 	u32 stripe_size;
 	u16 oncs;
+	u16 oacs;
 	u16 abort_limit;
 	u8 vwc;
 	u8 initialized;
diff --git a/include/uapi/linux/nvme.h b/include/uapi/linux/nvme.h
index 29a7d86..c3d1e9a 100644
--- a/include/uapi/linux/nvme.h
+++ b/include/uapi/linux/nvme.h
@@ -85,6 +85,35 @@ struct nvme_id_ctrl {
 	__u8			vs[1024];
 };
 
+struct nvme_lnvm_id_chnl {
+	__le64			laddr_begin;
+	__le64			laddr_end;
+	__le32			oob_size;
+	__le32			queue_size;
+	__le32			gran_read;
+	__le32			gran_write;
+	__le32			gran_erase;
+	__le32			t_r;
+	__le32			t_sqr;
+	__le32			t_w;
+	__le32			t_sqw;
+	__le32			t_e;
+	__le16			chnl_parallelism;
+	__u8			io_sched;
+	__u8			reserved[133];
+} __attribute__((packed));
+
+struct nvme_lnvm_id {
+	__u8				ver_id;
+	__u8				nvm_type;
+	__le16				nchannels;
+	__u8				reserved[252];
+	struct nvme_lnvm_id_chnl	chnls[];
+} __attribute__((packed));
+
+#define NVME_LNVM_CHNLS_PR_REQ ((4096U - sizeof(struct nvme_lnvm_id)) \
+					/ sizeof(struct nvme_lnvm_id_chnl))
+
 enum {
 	NVME_CTRL_ONCS_COMPARE			= 1 << 0,
 	NVME_CTRL_ONCS_WRITE_UNCORRECTABLE	= 1 << 1,
@@ -123,7 +152,12 @@ struct nvme_id_ns {
 };
 
 enum {
+	NVME_CTRL_OACS_LIGHTNVM	= 1 << 3,
+};
+
+enum {
 	NVME_NS_FEAT_THIN	= 1 << 0,
+	NVME_NS_FEAT_LIGHTNVM	= 1 << 1,
 	NVME_LBAF_RP_BEST	= 0,
 	NVME_LBAF_RP_BETTER	= 1,
 	NVME_LBAF_RP_GOOD	= 2,
@@ -192,6 +226,11 @@ enum nvme_opcode {
 	nvme_cmd_dsm		= 0x09,
 };
 
+enum lnvme_opcode {
+	lnvme_cmd_erase_sync	= 0x80,
+	lnvme_cmd_erase_async	= 0x81,
+};
+
 struct nvme_common_command {
 	__u8			opcode;
 	__u8			flags;
@@ -222,6 +261,22 @@ struct nvme_rw_command {
 	__le16			appmask;
 };
 
+struct nvme_lnvm_rw_command {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__u64			rsvd2;
+	__le64			metadata;
+	__le64			prp1;
+	__le64			prp2;
+	__le64			slba;
+	__le16			length;
+	__le16			control;
+	__le32			dsmgmt;
+	__le64			phys_addr;
+};
+
 enum {
 	NVME_RW_LR			= 1 << 15,
 	NVME_RW_FUA			= 1 << 14,
@@ -285,6 +340,11 @@ enum nvme_admin_opcode {
 	nvme_admin_format_nvm		= 0x80,
 	nvme_admin_security_send	= 0x81,
 	nvme_admin_security_recv	= 0x82,
+
+	lnvm_admin_identify		= 0xc0,
+	lnvm_admin_get_features		= 0xc1,
+	lnvm_admin_set_responsibility	= 0xc2,
+	lnvm_admin_get_l2p_tbl		= 0xc3,
 };
 
 enum {
@@ -410,6 +470,18 @@ struct nvme_format_cmd {
 	__u32			rsvd11[5];
 };
 
+struct nvme_lnvm_identify {
+	__u8			opcode;
+	__u8			flags;
+	__u16			command_id;
+	__le32			nsid;
+	__u64			rsvd[2];
+	__le64			prp1;
+	__le64			prp2;
+	__le32			cns;
+	__u32			rsvd11[5];
+};
+
 struct nvme_command {
 	union {
 		struct nvme_common_command common;
@@ -423,6 +495,8 @@ struct nvme_command {
 		struct nvme_format_cmd format;
 		struct nvme_dsm_cmd dsm;
 		struct nvme_abort_cmd abort;
+		struct nvme_lnvm_identify lnvm_identify;
+		struct nvme_lnvm_rw_command lnvm_rw;
 	};
 };
 
-- 
1.9.1

