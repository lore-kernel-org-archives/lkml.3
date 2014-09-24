Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaIXAyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:54:22 -0400
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:44175
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751920AbaIXAyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:54:21 -0400
Date: Tue, 23 Sep 2014 19:49:01 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: "J. German Rivera" <German.Rivera@freescale.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <Kim.Phillips@freescale.com>, <scottwood@freescale.com>,
        <agraf@suse.de>, <linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 1/3 v2] drivers/bus: Added Freescale Management Complex
 APIs
Message-ID: <20140923194901.894483bfaef97d13d12c75a5@freescale.com>
In-Reply-To: <1411166981-3610-2-git-send-email-German.Rivera@freescale.com>
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
	<1411166981-3610-2-git-send-email-German.Rivera@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(979002)(6009001)(189002)(24454002)(199003)(52314003)(20776003)(92726001)(100306002)(80022003)(83322001)(107046002)(36756003)(21056001)(85306004)(92566001)(81342003)(99396002)(104016003)(110136001)(76176999)(19580405001)(62966002)(87936001)(50986999)(86362001)(88136002)(23726002)(4396001)(89996001)(84676001)(106466001)(46102003)(33646002)(74662003)(19580395003)(44976005)(104166001)(105606002)(64706001)(50466002)(77982003)(102836001)(76482002)(6806004)(46406003)(95666004)(79102003)(90102001)(93916002)(47776003)(50226001)(87286001)(97736003)(74502003)(31966008)(83072002)(81542003)(85852003)(68736004)(10300001)(77156001)(120916001)(393794003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0749;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2014 17:49:39 -0500
"J. German Rivera" <German.Rivera@freescale.com> wrote:

> +int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
...
> +	err = mc_send_command(mc_io, &cmd);
> +	if (err)
> +		return err;
> +
> +		DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);

alignment

> +int dpmng_load_aiop(struct fsl_mc_io *mc_io,
> +		    int aiop_tile_id, uint8_t *img_addr, int img_size)
> +{
> +	struct mc_command cmd = { 0 };
> +	uint64_t img_paddr = virt_to_phys(img_addr);

Direct use of virt_to_phys by drivers is deprecated; this code needs
to map the i/o space via the DMA API.  This is in order to handle
situations where e.g., the device sitting behind an IOMMU.  See
Documentation/DMA-API* for more info.

> +/**
> + * Delay in microseconds between polling iterations while
> + * waiting for MC command completion
> + */
> +#define MC_CMD_COMPLETION_POLLING_INTERVAL_USECS    500	/* 0.5 ms */
> +
> +int __must_check fsl_create_mc_io(struct device *dev,
> +				  phys_addr_t mc_portal_phys_addr,
> +				  uint32_t mc_portal_size,
> +				  uint32_t flags, struct fsl_mc_io **new_mc_io)
> +{
> +	struct fsl_mc_io *mc_io;
> +	void __iomem *mc_portal_virt_addr;
> +	struct resource *res;
> +
> +	mc_io = devm_kzalloc(dev, sizeof(*mc_io), GFP_KERNEL);
> +	if (mc_io == NULL)
> +		return -ENOMEM;
> +
> +	mc_io->dev = dev;
> +	mc_io->flags = flags;
> +	mc_io->portal_phys_addr = mc_portal_phys_addr;
> +	mc_io->portal_size = mc_portal_size;
> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS)
> +		spin_lock_init(&mc_io->spinlock);

I'm confused - this patseries doesn't register an interrupt handler,
so this can't be true (or it's premature if it will, in which case
it should be left out for now).

However, if somehow users of this code register an IRQ handler for
the portal (I don't see any users to tell how they get the IRQ line
either?), then it's up to them to establish mutual exclusion rules
for access, among themselves.  Unless you think they will be calling
mc_send_command from h/w IRQ context, in which case I'd reconsider
that assumption because send_command looks like it'd take too long
to get an answer from the h/w - IRQ handlers should just ack the h/w
IRQ, and notify the scheduler that the driver has work to do (in s/w
IRQ context perhaps).

> +	else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
> +		mutex_init(&mc_io->mutex);

I'd assume SHARED_BY_THREADS to always be true in linux.

> +	res = devm_request_mem_region(dev,
> +				      mc_portal_phys_addr,
> +				      mc_portal_size,
> +				      "mc_portal");
> +	if (res == NULL) {
> +		dev_err(dev,
> +			"devm_request_mem_region failed for MC portal %#llx\n",
> +			mc_portal_phys_addr);
> +		return -EBUSY;
> +	}
> +
> +	mc_portal_virt_addr = devm_ioremap_nocache(dev,
> +						   mc_portal_phys_addr,
> +						   mc_portal_size);
> +	if (mc_portal_virt_addr == NULL) {
> +		dev_err(dev,
> +			"devm_ioremap_nocache failed for MC portal %#llx\n",
> +			mc_portal_phys_addr);
> +		return -ENXIO;
> +	}
> +
> +	mc_io->portal_virt_addr = mc_portal_virt_addr;
> +	*new_mc_io = mc_io;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fsl_create_mc_io);
> +
> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
> +{
> +	if (WARN_ON(mc_io->portal_virt_addr == NULL))
> +		return;

this is unnecessary - you'll get the stack trace anyway, and users
calling destroy on a not successfully created mc_io object should
not get the luxury of maybe being able to continue after the stack
trace, after possibly leaking memory.

> +	mc_io->portal_virt_addr = NULL;
> +	devm_kfree(mc_io->dev, mc_io);

like I said before, there's really no point in clearing something
out right before it's freed.

> +}
> +EXPORT_SYMBOL_GPL(fsl_destroy_mc_io);
> +
> +static int mc_status_to_error(enum mc_cmd_status status)
> +{
> +	static const int mc_status_to_error_map[] = {
> +		[MC_CMD_STATUS_OK] = 0,
> +		[MC_CMD_STATUS_AUTH_ERR] = -EACCES,
> +		[MC_CMD_STATUS_NO_PRIVILEGE] = -EPERM,
> +		[MC_CMD_STATUS_DMA_ERR] = -EIO,
> +		[MC_CMD_STATUS_CONFIG_ERR] = -ENXIO,
> +		[MC_CMD_STATUS_TIMEOUT] = -ETIMEDOUT,
> +		[MC_CMD_STATUS_NO_RESOURCE] = -ENAVAIL,
> +		[MC_CMD_STATUS_NO_MEMORY] = -ENOMEM,
> +		[MC_CMD_STATUS_BUSY] = -EBUSY,
> +		[MC_CMD_STATUS_UNSUPPORTED_OP] = -ENOTSUPP,
> +		[MC_CMD_STATUS_INVALID_STATE] = -ENODEV,
> +	};
> +
> +	if (WARN_ON(status >= ARRAY_SIZE(mc_status_to_error_map)))
> +		return -EINVAL;
> +	return mc_status_to_error_map[status];
> +}

great - CONFIG_ERR is now -ENXIO instead of -EINVAL, so at least
it's now mutually exclusive, but it doesn't handle
MC_CMD_STATUS_READY - should it?

> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
> +{
> +	enum mc_cmd_status status;
> +	int error;
> +	unsigned long irqsave_flags = 0;
> +	unsigned long jiffies_until_timeout =
> +	    jiffies + MC_CMD_COMPLETION_TIMEOUT_JIFFIES;
> +
> +	/*
> +	 * Acquire lock depending on mc_io flags:
> +	 */
> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS) {
> +		if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
> +			spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
> +		else
> +			spin_lock(&mc_io->spinlock);
> +	} else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS) {
> +		mutex_lock(&mc_io->mutex);
> +	}

again, I think we need to drop the coming from h/w IRQ context here
(SHARED_BY_INT_HANDLERS); there's no IRQ handlers in this
patchseries, and calling this function from an IRQ handler would be
prohibitively wasteful, guessing by the udelay and timeout values
below.

Can we just mutex_lock for now, and unconditionally (no
SHARED_BY_THREADS check), to protect from nesting?

> +	/*
> +	 * Wait for response from the MC hardware:
> +	 */
> +	for (;;) {
> +		status = mc_read_response(mc_io->portal_virt_addr, cmd);
> +		if (status != MC_CMD_STATUS_READY)
> +			break;
> +
> +		/*
> +		 * TODO: When MC command completion interrupts are supported
> +		 * call wait function here instead of udelay()
> +		 */
> +		udelay(MC_CMD_COMPLETION_POLLING_INTERVAL_USECS);

this pauses any caller for 0.5ms on every successful command
write.  Can the next submission of the patchseries wait until
completion IRQs are indeed supported, since both that and the above
locking needs to be resolved?

Kim
