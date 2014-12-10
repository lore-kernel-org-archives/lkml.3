Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbaLJDHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:07:52 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:26052 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaLJDHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:07:51 -0500
Message-ID: <5487B7E5.2080104@huawei.com>
Date: Wed, 10 Dec 2014 11:03:01 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Jiang Liu" <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Yingjoe Chen" <yingjoe.chen@mediatek.com>,
        Will Deacon <will.deacon@arm.com>,
        "Catalin marinas" <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>
Subject: Re: [PATCH v3 04/13] irqchip: GICv3: ITS command queue
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com> <1416839720-18400-5-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1416839720-18400-5-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/24 22:35, Marc Zyngier wrote:

[...]

> +static struct its_collection *its_build_mapd_cmd(struct its_cmd_block *cmd,
> +						 struct its_cmd_desc *desc)
> +{
> +	unsigned long itt_addr;
> +	u8 size = order_base_2(desc->its_mapd_cmd.dev->nr_ites);

If @nr_ites is 1, then @size becomes 0, and... (see below)

> +
> +	itt_addr = virt_to_phys(desc->its_mapd_cmd.dev->itt);
> +	itt_addr = ALIGN(itt_addr, ITS_ITT_ALIGN);
> +
> +	its_encode_cmd(cmd, GITS_CMD_MAPD);
> +	its_encode_devid(cmd, desc->its_mapd_cmd.dev->device_id);
> +	its_encode_size(cmd, size - 1);

here (size - 1) becomes the value of ~0, which will exceed the maximum
supported bits of identifier.

Regards,
	Abel

> +	its_encode_itt(cmd, itt_addr);
> +	its_encode_valid(cmd, desc->its_mapd_cmd.valid);
> +
> +	its_fixup_cmd(cmd);
> +
> +	return desc->its_mapd_cmd.dev->collection;
> +}
> +
> +static struct its_collection *its_build_mapc_cmd(struct its_cmd_block *cmd,
> +						 struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_MAPC);
> +	its_encode_collection(cmd, desc->its_mapc_cmd.col->col_id);
> +	its_encode_target(cmd, desc->its_mapc_cmd.col->target_address);
> +	its_encode_valid(cmd, desc->its_mapc_cmd.valid);
> +
> +	its_fixup_cmd(cmd);
> +
> +	return desc->its_mapc_cmd.col;
> +}
> +
> +static struct its_collection *its_build_mapvi_cmd(struct its_cmd_block *cmd,
> +						  struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_MAPVI);
> +	its_encode_devid(cmd, desc->its_mapvi_cmd.dev->device_id);
> +	its_encode_event_id(cmd, desc->its_mapvi_cmd.event_id);
> +	its_encode_phys_id(cmd, desc->its_mapvi_cmd.phys_id);
> +	its_encode_collection(cmd, desc->its_mapvi_cmd.dev->collection->col_id);
> +
> +	its_fixup_cmd(cmd);
> +
> +	return desc->its_mapvi_cmd.dev->collection;
> +}
> +
> +static struct its_collection *its_build_movi_cmd(struct its_cmd_block *cmd,
> +						 struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_MOVI);
> +	its_encode_devid(cmd, desc->its_movi_cmd.dev->device_id);
> +	its_encode_event_id(cmd, desc->its_movi_cmd.id);
> +	its_encode_collection(cmd, desc->its_movi_cmd.col->col_id);
> +
> +	its_fixup_cmd(cmd);
> +
> +	return desc->its_movi_cmd.dev->collection;
> +}
> +
> +static struct its_collection *its_build_discard_cmd(struct its_cmd_block *cmd,
> +						    struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_DISCARD);
> +	its_encode_devid(cmd, desc->its_discard_cmd.dev->device_id);
> +	its_encode_event_id(cmd, desc->its_discard_cmd.event_id);
> +
> +	its_fixup_cmd(cmd);
> +
> +	return desc->its_discard_cmd.dev->collection;
> +}
> +
> +static struct its_collection *its_build_inv_cmd(struct its_cmd_block *cmd,
> +						struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_INV);
> +	its_encode_devid(cmd, desc->its_inv_cmd.dev->device_id);
> +	its_encode_event_id(cmd, desc->its_inv_cmd.event_id);
> +
> +	its_fixup_cmd(cmd);
> +
> +	return desc->its_inv_cmd.dev->collection;
> +}
> +
> +static struct its_collection *its_build_invall_cmd(struct its_cmd_block *cmd,
> +						   struct its_cmd_desc *desc)
> +{
> +	its_encode_cmd(cmd, GITS_CMD_INVALL);
> +	its_encode_collection(cmd, desc->its_mapc_cmd.col->col_id);
> +
> +	its_fixup_cmd(cmd);
> +
> +	return NULL;
> +}
> +
> +static u64 its_cmd_ptr_to_offset(struct its_node *its,
> +				 struct its_cmd_block *ptr)
> +{
> +	return (ptr - its->cmd_base) * sizeof(*ptr);
> +}
> +
> +static int its_queue_full(struct its_node *its)
> +{
> +	int widx;
> +	int ridx;
> +
> +	widx = its->cmd_write - its->cmd_base;
> +	ridx = readl_relaxed(its->base + GITS_CREADR) / sizeof(struct its_cmd_block);
> +
> +	/* This is incredibly unlikely to happen, unless the ITS locks up. */
> +	if (((widx + 1) % ITS_CMD_QUEUE_NR_ENTRIES) == ridx)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static struct its_cmd_block *its_allocate_entry(struct its_node *its)
> +{
> +	struct its_cmd_block *cmd;
> +	u32 count = 1000000;	/* 1s! */
> +
> +	while (its_queue_full(its)) {
> +		count--;
> +		if (!count) {
> +			pr_err_ratelimited("ITS queue not draining\n");
> +			return NULL;
> +		}
> +		cpu_relax();
> +		udelay(1);
> +	}
> +
> +	cmd = its->cmd_write++;
> +
> +	/* Handle queue wrapping */
> +	if (its->cmd_write == (its->cmd_base + ITS_CMD_QUEUE_NR_ENTRIES))
> +		its->cmd_write = its->cmd_base;
> +
> +	return cmd;
> +}
> +
> +static struct its_cmd_block *its_post_commands(struct its_node *its)
> +{
> +	u64 wr = its_cmd_ptr_to_offset(its, its->cmd_write);
> +
> +	writel_relaxed(wr, its->base + GITS_CWRITER);
> +
> +	return its->cmd_write;
> +}
> +
> +static void its_flush_cmd(struct its_node *its, struct its_cmd_block *cmd)
> +{
> +	/*
> +	 * Make sure the commands written to memory are observable by
> +	 * the ITS.
> +	 */
> +	if (its->flags & ITS_FLAGS_CMDQ_NEEDS_FLUSHING)
> +		__flush_dcache_area(cmd, sizeof(*cmd));
> +	else
> +		dsb(ishst);
> +}
> +
> +static void its_wait_for_range_completion(struct its_node *its,
> +					  struct its_cmd_block *from,
> +					  struct its_cmd_block *to)
> +{
> +	u64 rd_idx, from_idx, to_idx;
> +	u32 count = 1000000;	/* 1s! */
> +
> +	from_idx = its_cmd_ptr_to_offset(its, from);
> +	to_idx = its_cmd_ptr_to_offset(its, to);
> +
> +	while (1) {
> +		rd_idx = readl_relaxed(its->base + GITS_CREADR);
> +		if (rd_idx >= to_idx || rd_idx < from_idx)
> +			break;
> +
> +		count--;
> +		if (!count) {
> +			pr_err_ratelimited("ITS queue timeout\n");
> +			return;
> +		}
> +		cpu_relax();
> +		udelay(1);
> +	}
> +}
> +
> +static void its_send_single_command(struct its_node *its,
> +				    its_cmd_builder_t builder,
> +				    struct its_cmd_desc *desc)
> +{
> +	struct its_cmd_block *cmd, *sync_cmd, *next_cmd;
> +	struct its_collection *sync_col;
> +
> +	raw_spin_lock(&its->lock);
> +
> +	cmd = its_allocate_entry(its);
> +	if (!cmd) {		/* We're soooooo screewed... */
> +		pr_err_ratelimited("ITS can't allocate, dropping command\n");
> +		raw_spin_unlock(&its->lock);
> +		return;
> +	}
> +	sync_col = builder(cmd, desc);
> +	its_flush_cmd(its, cmd);
> +
> +	if (sync_col) {
> +		sync_cmd = its_allocate_entry(its);
> +		if (!sync_cmd) {
> +			pr_err_ratelimited("ITS can't SYNC, skipping\n");
> +			goto post;
> +		}
> +		its_encode_cmd(sync_cmd, GITS_CMD_SYNC);
> +		its_encode_target(sync_cmd, sync_col->target_address);
> +		its_fixup_cmd(sync_cmd);
> +		its_flush_cmd(its, sync_cmd);
> +	}
> +
> +post:
> +	next_cmd = its_post_commands(its);
> +	raw_spin_unlock(&its->lock);
> +
> +	its_wait_for_range_completion(its, cmd, next_cmd);
> +}
> +
> +static void its_send_inv(struct its_device *dev, u32 event_id)
> +{
> +	struct its_cmd_desc desc;
> +
> +	desc.its_inv_cmd.dev = dev;
> +	desc.its_inv_cmd.event_id = event_id;
> +
> +	its_send_single_command(dev->its, its_build_inv_cmd, &desc);
> +}
> +
> +static void its_send_mapd(struct its_device *dev, int valid)
> +{
> +	struct its_cmd_desc desc;
> +
> +	desc.its_mapd_cmd.dev = dev;
> +	desc.its_mapd_cmd.valid = !!valid;
> +
> +	its_send_single_command(dev->its, its_build_mapd_cmd, &desc);
> +}
> +
> +static void its_send_mapc(struct its_node *its, struct its_collection *col,
> +			  int valid)
> +{
> +	struct its_cmd_desc desc;
> +
> +	desc.its_mapc_cmd.col = col;
> +	desc.its_mapc_cmd.valid = !!valid;
> +
> +	its_send_single_command(its, its_build_mapc_cmd, &desc);
> +}
> +
> +static void its_send_mapvi(struct its_device *dev, u32 irq_id, u32 id)
> +{
> +	struct its_cmd_desc desc;
> +
> +	desc.its_mapvi_cmd.dev = dev;
> +	desc.its_mapvi_cmd.phys_id = irq_id;
> +	desc.its_mapvi_cmd.event_id = id;
> +
> +	its_send_single_command(dev->its, its_build_mapvi_cmd, &desc);
> +}
> +
> +static void its_send_movi(struct its_device *dev,
> +			  struct its_collection *col, u32 id)
> +{
> +	struct its_cmd_desc desc;
> +
> +	desc.its_movi_cmd.dev = dev;
> +	desc.its_movi_cmd.col = col;
> +	desc.its_movi_cmd.id = id;
> +
> +	its_send_single_command(dev->its, its_build_movi_cmd, &desc);
> +}
> +
> +static void its_send_discard(struct its_device *dev, u32 id)
> +{
> +	struct its_cmd_desc desc;
> +
> +	desc.its_discard_cmd.dev = dev;
> +	desc.its_discard_cmd.event_id = id;
> +
> +	its_send_single_command(dev->its, its_build_discard_cmd, &desc);
> +}
> +
> +static void its_send_invall(struct its_node *its, struct its_collection *col)
> +{
> +	struct its_cmd_desc desc;
> +
> +	desc.its_invall_cmd.col = col;
> +
> +	its_send_single_command(its, its_build_invall_cmd, &desc);
> +}
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 040615a..21c9d70 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -80,9 +80,27 @@
>  #define GICR_MOVALLR			0x0110
>  #define GICR_PIDR2			GICD_PIDR2
>  
> +#define GICR_CTLR_ENABLE_LPIS		(1UL << 0)
> +
> +#define GICR_TYPER_CPU_NUMBER(r)	(((r) >> 8) & 0xffff)
> +
>  #define GICR_WAKER_ProcessorSleep	(1U << 1)
>  #define GICR_WAKER_ChildrenAsleep	(1U << 2)
>  
> +#define GICR_PROPBASER_NonShareable	(0U << 10)
> +#define GICR_PROPBASER_InnerShareable	(1U << 10)
> +#define GICR_PROPBASER_OuterShareable	(2U << 10)
> +#define GICR_PROPBASER_SHAREABILITY_MASK (3UL << 10)
> +#define GICR_PROPBASER_nCnB		(0U << 7)
> +#define GICR_PROPBASER_nC		(1U << 7)
> +#define GICR_PROPBASER_RaWt		(2U << 7)
> +#define GICR_PROPBASER_RaWb		(3U << 7)
> +#define GICR_PROPBASER_WaWt		(4U << 7)
> +#define GICR_PROPBASER_WaWb		(5U << 7)
> +#define GICR_PROPBASER_RaWaWt		(6U << 7)
> +#define GICR_PROPBASER_RaWaWb		(7U << 7)
> +#define GICR_PROPBASER_IDBITS_MASK	(0x1f)
> +
>  /*
>   * Re-Distributor registers, offsets from SGI_base
>   */
> @@ -95,9 +113,93 @@
>  #define GICR_IPRIORITYR0		GICD_IPRIORITYR
>  #define GICR_ICFGR0			GICD_ICFGR
>  
> +#define GICR_TYPER_PLPIS		(1U << 0)
>  #define GICR_TYPER_VLPIS		(1U << 1)
>  #define GICR_TYPER_LAST			(1U << 4)
>  
> +#define LPI_PROP_GROUP1			(1 << 1)
> +#define LPI_PROP_ENABLED		(1 << 0)
> +
> +/*
> + * ITS registers, offsets from ITS_base
> + */
> +#define GITS_CTLR			0x0000
> +#define GITS_IIDR			0x0004
> +#define GITS_TYPER			0x0008
> +#define GITS_CBASER			0x0080
> +#define GITS_CWRITER			0x0088
> +#define GITS_CREADR			0x0090
> +#define GITS_BASER			0x0100
> +#define GITS_PIDR2			GICR_PIDR2
> +
> +#define GITS_TRANSLATER			0x10040
> +
> +#define GITS_TYPER_PTA			(1UL << 19)
> +
> +#define GITS_CBASER_VALID		(1UL << 63)
> +#define GITS_CBASER_nCnB		(0UL << 59)
> +#define GITS_CBASER_nC			(1UL << 59)
> +#define GITS_CBASER_RaWt		(2UL << 59)
> +#define GITS_CBASER_RaWb		(3UL << 59)
> +#define GITS_CBASER_WaWt		(4UL << 59)
> +#define GITS_CBASER_WaWb		(5UL << 59)
> +#define GITS_CBASER_RaWaWt		(6UL << 59)
> +#define GITS_CBASER_RaWaWb		(7UL << 59)
> +#define GITS_CBASER_NonShareable	(0UL << 10)
> +#define GITS_CBASER_InnerShareable	(1UL << 10)
> +#define GITS_CBASER_OuterShareable	(2UL << 10)
> +#define GITS_CBASER_SHAREABILITY_MASK	(3UL << 10)
> +
> +#define GITS_BASER_NR_REGS		8
> +
> +#define GITS_BASER_VALID		(1UL << 63)
> +#define GITS_BASER_nCnB			(0UL << 59)
> +#define GITS_BASER_nC			(1UL << 59)
> +#define GITS_BASER_RaWt			(2UL << 59)
> +#define GITS_BASER_RaWb			(3UL << 59)
> +#define GITS_BASER_WaWt			(4UL << 59)
> +#define GITS_BASER_WaWb			(5UL << 59)
> +#define GITS_BASER_RaWaWt		(6UL << 59)
> +#define GITS_BASER_RaWaWb		(7UL << 59)
> +#define GITS_BASER_TYPE_SHIFT		(56)
> +#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
> +#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
> +#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0xff) + 1)
> +#define GITS_BASER_NonShareable		(0UL << 10)
> +#define GITS_BASER_InnerShareable	(1UL << 10)
> +#define GITS_BASER_OuterShareable	(2UL << 10)
> +#define GITS_BASER_SHAREABILITY_SHIFT	(10)
> +#define GITS_BASER_SHAREABILITY_MASK	(3UL << GITS_BASER_SHAREABILITY_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
> +#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +
> +#define GITS_BASER_TYPE_NONE		0
> +#define GITS_BASER_TYPE_DEVICE		1
> +#define GITS_BASER_TYPE_VCPU		2
> +#define GITS_BASER_TYPE_CPU		3
> +#define GITS_BASER_TYPE_COLLECTION	4
> +#define GITS_BASER_TYPE_RESERVED5	5
> +#define GITS_BASER_TYPE_RESERVED6	6
> +#define GITS_BASER_TYPE_RESERVED7	7
> +
> +/*
> + * ITS commands
> + */
> +#define GITS_CMD_MAPD			0x08
> +#define GITS_CMD_MAPC			0x09
> +#define GITS_CMD_MAPVI			0x0a
> +#define GITS_CMD_MOVI			0x01
> +#define GITS_CMD_DISCARD		0x0f
> +#define GITS_CMD_INV			0x0c
> +#define GITS_CMD_MOVALL			0x0e
> +#define GITS_CMD_INVALL			0x0d
> +#define GITS_CMD_INT			0x03
> +#define GITS_CMD_CLEAR			0x04
> +#define GITS_CMD_SYNC			0x05
> +
>  /*
>   * CPU interface registers
>   */



