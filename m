Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaIYCYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 22:24:11 -0400
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:31669
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbaIYCYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 22:24:10 -0400
Message-ID: <54237CBF.2010706@freescale.com>
Date: Wed, 24 Sep 2014 21:23:59 -0500
From: German Rivera <German.Rivera@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        Erez Nir-RM30794 <nir.erez@freescale.com>
Subject: Re: [PATCH 1/3 v2] drivers/bus: Added Freescale Management Complex
 APIs
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>	<1411166981-3610-2-git-send-email-German.Rivera@freescale.com> <20140923194901.894483bfaef97d13d12c75a5@freescale.com>
In-Reply-To: <20140923194901.894483bfaef97d13d12c75a5@freescale.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.88.168.50]
X-ClientProxiedBy: BY2PR06CA037.namprd06.prod.outlook.com (10.141.250.155) To
 BY2PR03MB331.namprd03.prod.outlook.com (10.141.139.20)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6049001)(6009001)(24454002)(189002)(377454003)(52314003)(199003)(479174003)(95666004)(106356001)(97736003)(50466002)(31966008)(21056001)(54356999)(33656002)(20776003)(107046002)(79102003)(46102003)(87266999)(92566001)(80022003)(10300001)(50986999)(74662003)(66066001)(64706001)(4396001)(102836001)(81342003)(83506001)(65806001)(87976001)(76176999)(110136001)(42186005)(83072002)(19580405001)(77982003)(59896002)(74502003)(64126003)(80316001)(105586002)(23676002)(19580395003)(36756003)(65816999)(101416001)(65956001)(85306004)(90102001)(47776003)(77096002)(76482002)(86362001)(92726001)(81542003)(99396003)(85852003)(120916001)(83322001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB331;H:[10.214.80.135];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/23/2014 07:49 PM, Kim Phillips wrote:
> On Fri, 19 Sep 2014 17:49:39 -0500
> "J. German Rivera" <German.Rivera@freescale.com> wrote:
>
>> +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
> ...
>> +	err = mc_send_command(mc_io, &cmd);
>> +	if (err)
>> +		return err;
>> +
>> +		DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);
>
> alignment
>
>> +int dpmng_load_aiop(struct fsl_mc_io *mc_io,
>> +		    int aiop_tile_id, uint8_t *img_addr, int img_size)
>> +{
>> +	struct mc_command cmd = { 0 };
>> +	uint64_t img_paddr = virt_to_phys(img_addr);
>
> Direct use of virt_to_phys by drivers is deprecated; this code needs
> to map the i/o space via the DMA API.  This is in order to handle
> situations where e.g., the device sitting behind an IOMMU.  See
> Documentation/DMA-API* for more info.
>
Ok, we will make this change in the v3 respin.

>> +/**
>> + * Delay in microseconds between polling iterations while
>> + * waiting for MC command completion
>> + */
>> +#define MC_CMD_COMPLETION_POLLING_INTERVAL_USECS    500	/* 0.5 ms */
>> +
>> +int __must_check fsl_create_mc_io(struct device *dev,
>> +				  phys_addr_t mc_portal_phys_addr,
>> +				  uint32_t mc_portal_size,
>> +				  uint32_t flags, struct fsl_mc_io **new_mc_io)
>> +{
>> +	struct fsl_mc_io *mc_io;
>> +	void __iomem *mc_portal_virt_addr;
>> +	struct resource *res;
>> +
>> +	mc_io = devm_kzalloc(dev, sizeof(*mc_io), GFP_KERNEL);
>> +	if (mc_io == NULL)
>> +		return -ENOMEM;
>> +
>> +	mc_io->dev = dev;
>> +	mc_io->flags = flags;
>> +	mc_io->portal_phys_addr = mc_portal_phys_addr;
>> +	mc_io->portal_size = mc_portal_size;
>> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS)
>> +		spin_lock_init(&mc_io->spinlock);
>
> I'm confused - this patseries doesn't register an interrupt handler,
> so this can't be true (or it's premature if it will, in which case
> it should be left out for now).
>
> However, if somehow users of this code register an IRQ handler for
> the portal (I don't see any users to tell how they get the IRQ line
> either?), then it's up to them to establish mutual exclusion rules
> for access, among themselves.  Unless you think they will be calling
> mc_send_command from h/w IRQ context, in which case I'd reconsider
> that assumption because send_command looks like it'd take too long
> to get an answer from the h/w - IRQ handlers should just ack the h/w
> IRQ, and notify the scheduler that the driver has work to do (in s/w
> IRQ context perhaps).
>
Although not included in this patch series, there are cases in
subsequent patch series, in which mc_send_command() will need to be
called from interrupt context.

For example, the dprc_get_irq_status() needs to be called from the DPRC
ISR to determine the actual cause of the interrupt. Also, to clear
the interrupt the dprc_clear_irq_status() needs to be called from the
ISR. Both od these functions call mc_send_command():

int dprc_get_irq_status(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
			uint8_t irq_index, uint32_t *status)
{
	struct mc_command cmd = { 0 };
	int err;

	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_IRQ_STATUS,
					  DPRC_CMDSZ_GET_IRQ_STATUS,
					  MC_CMD_PRI_LOW, dprc_handle);

	DPRC_CMD_GET_IRQ_STATUS(cmd, irq_index);
	err = mc_send_command(mc_io, &cmd);
	if (!err)
		DPRC_RSP_GET_IRQ_STATUS(cmd, *status);

	return err;
}

int dprc_clear_irq_status(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
			  uint8_t irq_index, uint32_t status)
{
	struct mc_command cmd = { 0 };

	cmd.header = mc_encode_cmd_header(DPRC_CMDID_CLEAR_IRQ_STATUS,
					  DPRC_CMDSZ_CLEAR_IRQ_STATUS,
					  MC_CMD_PRI_LOW, dprc_handle);

	DPRC_CMD_CLEAR_IRQ_STATUS(cmd, status, irq_index);
	return mc_send_command(mc_io, &cmd);
}

>> +	else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
>> +		mutex_init(&mc_io->mutex);
>
> I'd assume SHARED_BY_THREADS to always be true in linux.
>
Not, if mc_send_command() is called from interrupt context, as
explained above. However, since this patch series does not include
any interrupt handlers, we can remove the
FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS flag and the associated spinlock,
from this patch series.

>> +	res = devm_request_mem_region(dev,
>> +				      mc_portal_phys_addr,
>> +				      mc_portal_size,
>> +				      "mc_portal");
>> +	if (res == NULL) {
>> +		dev_err(dev,
>> +			"devm_request_mem_region failed for MC portal %#llx\n",
>> +			mc_portal_phys_addr);
>> +		return -EBUSY;
>> +	}
>> +
>> +	mc_portal_virt_addr = devm_ioremap_nocache(dev,
>> +						   mc_portal_phys_addr,
>> +						   mc_portal_size);
>> +	if (mc_portal_virt_addr == NULL) {
>> +		dev_err(dev,
>> +			"devm_ioremap_nocache failed for MC portal %#llx\n",
>> +			mc_portal_phys_addr);
>> +		return -ENXIO;
>> +	}
>> +
>> +	mc_io->portal_virt_addr = mc_portal_virt_addr;
>> +	*new_mc_io = mc_io;
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(fsl_create_mc_io);
>> +
>> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
>> +{
>> +	if (WARN_ON(mc_io->portal_virt_addr == NULL))
>> +		return;
>
> this is unnecessary - you'll get the stack trace anyway, and users
> calling destroy on a not successfully created mc_io object should
> not get the luxury of maybe being able to continue after the stack
> trace, after possibly leaking memory.
Ok, I'ĺl remove this WARN_ON in the v3 respin.

>
>> +	mc_io->portal_virt_addr = NULL;
>> +	devm_kfree(mc_io->dev, mc_io);
>
> like I said before, there's really no point in clearing something
> out right before it's freed.
>
I disagree. This can help detect cases of double-freeing.

>> +}
>> +EXPORT_SYMBOL_GPL(fsl_destroy_mc_io);
>> +
>> +static int mc_status_to_error(enum mc_cmd_status status)
>> +{
>> +	static const int mc_status_to_error_map[] = {
>> +		[MC_CMD_STATUS_OK] = 0,
>> +		[MC_CMD_STATUS_AUTH_ERR] = -EACCES,
>> +		[MC_CMD_STATUS_NO_PRIVILEGE] = -EPERM,
>> +		[MC_CMD_STATUS_DMA_ERR] = -EIO,
>> +		[MC_CMD_STATUS_CONFIG_ERR] = -ENXIO,
>> +		[MC_CMD_STATUS_TIMEOUT] = -ETIMEDOUT,
>> +		[MC_CMD_STATUS_NO_RESOURCE] = -ENAVAIL,
>> +		[MC_CMD_STATUS_NO_MEMORY] = -ENOMEM,
>> +		[MC_CMD_STATUS_BUSY] = -EBUSY,
>> +		[MC_CMD_STATUS_UNSUPPORTED_OP] = -ENOTSUPP,
>> +		[MC_CMD_STATUS_INVALID_STATE] = -ENODEV,
>> +	};
>> +
>> +	if (WARN_ON(status >= ARRAY_SIZE(mc_status_to_error_map)))
>> +		return -EINVAL;
>> +	return mc_status_to_error_map[status];
>> +}
>
> great - CONFIG_ERR is now -ENXIO instead of -EINVAL, so at least
> it's now mutually exclusive, but it doesn't handle
> MC_CMD_STATUS_READY - should it?
>
No. MC_CMD_STATUS_READY does not need to be seen by mc_send_command()
callers. It is only used to know when to stop polling the MC for
command completion.

>> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
>> +{
>> +	enum mc_cmd_status status;
>> +	int error;
>> +	unsigned long irqsave_flags = 0;
>> +	unsigned long jiffies_until_timeout =
>> +	    jiffies + MC_CMD_COMPLETION_TIMEOUT_JIFFIES;
>> +
>> +	/*
>> +	 * Acquire lock depending on mc_io flags:
>> +	 */
>> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS) {
>> +		if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
>> +			spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
>> +		else
>> +			spin_lock(&mc_io->spinlock);
>> +	} else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS) {
>> +		mutex_lock(&mc_io->mutex);
>> +	}
>
> again, I think we need to drop the coming from h/w IRQ context here
> (SHARED_BY_INT_HANDLERS); there's no IRQ handlers in this
> patchseries, and calling this function from an IRQ handler would be
> prohibitively wasteful, guessing by the udelay and timeout values
> below.
>
> Can we just mutex_lock for now, and unconditionally (no
> SHARED_BY_THREADS check), to protect from nesting?
>
I would still prefer to keep the SHARED_BY_THREADS flag, to give option 
of not doing any locking, in cases where the portal used in 
mc_send_command() is not shared among concurrent callers

What do you mean by nesting in this case?

>> +	/*
>> +	 * Wait for response from the MC hardware:
>> +	 */
>> +	for (;;) {
>> +		status = mc_read_response(mc_io->portal_virt_addr, cmd);
>> +		if (status != MC_CMD_STATUS_READY)
>> +			break;
>> +
>> +		/*
>> +		 * TODO: When MC command completion interrupts are supported
>> +		 * call wait function here instead of udelay()
>> +		 */
>> +		udelay(MC_CMD_COMPLETION_POLLING_INTERVAL_USECS);
>
> this pauses any caller for 0.5ms on every successful command
> write.  Can the next submission of the patchseries wait until
> completion IRQs are indeed supported, since both that and the above
> locking needs to be resolved?
>
No. Interrupt handlers will come in a later patch series as they are
not needed for using the basic MC functionality.

> Kim
>
