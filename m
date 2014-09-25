Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaIYDpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:45:23 -0400
Received: from mail-bn1bon0145.outbound.protection.outlook.com ([157.56.111.145]:19841
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751351AbaIYDpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:45:22 -0400
Date: Wed, 24 Sep 2014 22:40:06 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: German Rivera <German.Rivera@freescale.com>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <stuart.yoder@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        Erez Nir-RM30794 <nir.erez@freescale.com>
Subject: Re: [PATCH 1/3 v2] drivers/bus: Added Freescale Management Complex
 APIs
Message-ID: <20140924224006.f924cefdd347464519da8190@freescale.com>
In-Reply-To: <54237CBF.2010706@freescale.com>
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
	<1411166981-3610-2-git-send-email-German.Rivera@freescale.com>
	<20140923194901.894483bfaef97d13d12c75a5@freescale.com>
	<54237CBF.2010706@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(377454003)(24454002)(479174003)(52314003)(19580395003)(83322001)(107046002)(84676001)(47776003)(120916001)(4396001)(77156001)(110136001)(105606002)(74502003)(104166001)(104016003)(33646002)(50466002)(23676002)(44976005)(20776003)(19580405001)(99396003)(76482002)(50986999)(86362001)(36756003)(6806004)(31966008)(85306004)(97736003)(77982003)(64706001)(21056001)(90102001)(87286001)(92566001)(92726001)(102836001)(79102003)(93916002)(88136002)(106466001)(50226001)(74662003)(76176999)(83072002)(93886004)(80022003)(89996001)(68736004)(81342003)(81542003)(62966002)(85852003)(95666004)(46102003)(10300001)(87936001)(100306002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0734;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0734;
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 21:23:59 -0500
German Rivera <German.Rivera@freescale.com> wrote:

> On 09/23/2014 07:49 PM, Kim Phillips wrote:
> > On Fri, 19 Sep 2014 17:49:39 -0500
> > "J. German Rivera" <German.Rivera@freescale.com> wrote:
> >
> >> + * Delay in microseconds between polling iterations while
> >> + * waiting for MC command completion
> >> + */
> >> +#define MC_CMD_COMPLETION_POLLING_INTERVAL_USECS    500	/* 0.5 ms */
> >> +
> >> +int __must_check fsl_create_mc_io(struct device *dev,
> >> +				  phys_addr_t mc_portal_phys_addr,
> >> +				  uint32_t mc_portal_size,
> >> +				  uint32_t flags, struct fsl_mc_io **new_mc_io)
> >> +{
> >> +	struct fsl_mc_io *mc_io;
> >> +	void __iomem *mc_portal_virt_addr;
> >> +	struct resource *res;
> >> +
> >> +	mc_io = devm_kzalloc(dev, sizeof(*mc_io), GFP_KERNEL);
> >> +	if (mc_io == NULL)
> >> +		return -ENOMEM;
> >> +
> >> +	mc_io->dev = dev;
> >> +	mc_io->flags = flags;
> >> +	mc_io->portal_phys_addr = mc_portal_phys_addr;
> >> +	mc_io->portal_size = mc_portal_size;
> >> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS)
> >> +		spin_lock_init(&mc_io->spinlock);
> >
> > I'm confused - this patseries doesn't register an interrupt handler,
> > so this can't be true (or it's premature if it will, in which case
> > it should be left out for now).
> >
> > However, if somehow users of this code register an IRQ handler for
> > the portal (I don't see any users to tell how they get the IRQ line
> > either?), then it's up to them to establish mutual exclusion rules
> > for access, among themselves.  Unless you think they will be calling
> > mc_send_command from h/w IRQ context, in which case I'd reconsider
> > that assumption because send_command looks like it'd take too long
> > to get an answer from the h/w - IRQ handlers should just ack the h/w
> > IRQ, and notify the scheduler that the driver has work to do (in s/w
> > IRQ context perhaps).
> >
> Although not included in this patch series, there are cases in
> subsequent patch series, in which mc_send_command() will need to be
> called from interrupt context.
> 
> For example, the dprc_get_irq_status() needs to be called from the DPRC
> ISR to determine the actual cause of the interrupt. Also, to clear
> the interrupt the dprc_clear_irq_status() needs to be called from the
> ISR. Both od these functions call mc_send_command():

yet mc_send_command itself has the capability to trigger a h/w IRQ,
no?  So how is that expected to work, given h/w IRQ handlers run
with IRQs turned off?

> >> +	else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
> >> +		mutex_init(&mc_io->mutex);
> >
> > I'd assume SHARED_BY_THREADS to always be true in linux.
> >
> Not, if mc_send_command() is called from interrupt context, as
> explained above. However, since this patch series does not include
> any interrupt handlers, we can remove the
> FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS flag and the associated spinlock,
> from this patch series.
> 
> >> +	res = devm_request_mem_region(dev,
> >> +				      mc_portal_phys_addr,
> >> +				      mc_portal_size,
> >> +				      "mc_portal");
> >> +	if (res == NULL) {
> >> +		dev_err(dev,
> >> +			"devm_request_mem_region failed for MC portal %#llx\n",
> >> +			mc_portal_phys_addr);
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	mc_portal_virt_addr = devm_ioremap_nocache(dev,
> >> +						   mc_portal_phys_addr,
> >> +						   mc_portal_size);
> >> +	if (mc_portal_virt_addr == NULL) {
> >> +		dev_err(dev,
> >> +			"devm_ioremap_nocache failed for MC portal %#llx\n",
> >> +			mc_portal_phys_addr);
> >> +		return -ENXIO;
> >> +	}
> >> +
> >> +	mc_io->portal_virt_addr = mc_portal_virt_addr;
> >> +	*new_mc_io = mc_io;
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(fsl_create_mc_io);
> >> +
> >> +void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
> >> +{
> >> +	if (WARN_ON(mc_io->portal_virt_addr == NULL))
> >> +		return;
> >
> > this is unnecessary - you'll get the stack trace anyway, and users
> > calling destroy on a not successfully created mc_io object should
> > not get the luxury of maybe being able to continue after the stack
> > trace, after possibly leaking memory.
> Ok, I'ĺl remove this WARN_ON in the v3 respin.

subsequent code will cause a stack trace when dereferencing
portal_virt_addr anyway, so the if statement isn't needed at all.

> >> +	mc_io->portal_virt_addr = NULL;
> >> +	devm_kfree(mc_io->dev, mc_io);
> >
> > like I said before, there's really no point in clearing something
> > out right before it's freed.
> >
> I disagree. This can help detect cases of double-freeing.

?  freeing NULL does nothing - it just returns - which doesn't help
detect anything.  What's more, the kernel has a memory debugging
infrastructure that detects double freeing of the same object.

> >> +int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
> >> +{
> >> +	enum mc_cmd_status status;
> >> +	int error;
> >> +	unsigned long irqsave_flags = 0;
> >> +	unsigned long jiffies_until_timeout =
> >> +	    jiffies + MC_CMD_COMPLETION_TIMEOUT_JIFFIES;
> >> +
> >> +	/*
> >> +	 * Acquire lock depending on mc_io flags:
> >> +	 */
> >> +	if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_INT_HANDLERS) {
> >> +		if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS)
> >> +			spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
> >> +		else
> >> +			spin_lock(&mc_io->spinlock);
> >> +	} else if (mc_io->flags & FSL_MC_PORTAL_SHARED_BY_THREADS) {
> >> +		mutex_lock(&mc_io->mutex);
> >> +	}
> >
> > again, I think we need to drop the coming from h/w IRQ context here
> > (SHARED_BY_INT_HANDLERS); there's no IRQ handlers in this
> > patchseries, and calling this function from an IRQ handler would be
> > prohibitively wasteful, guessing by the udelay and timeout values
> > below.
> >
> > Can we just mutex_lock for now, and unconditionally (no
> > SHARED_BY_THREADS check), to protect from nesting?
> >
> I would still prefer to keep the SHARED_BY_THREADS flag, to give option 
> of not doing any locking, in cases where the portal used in 
> mc_send_command() is not shared among concurrent callers

how can you guarantee there won't be concurrent callers?  The linux
kernel is multithreaded.

> What do you mean by nesting in this case?

when a thread gets interrupted by another thread, and/or another
IRQ: this would cause an unrecoverable race condition.

> >> +	/*
> >> +	 * Wait for response from the MC hardware:
> >> +	 */
> >> +	for (;;) {
> >> +		status = mc_read_response(mc_io->portal_virt_addr, cmd);
> >> +		if (status != MC_CMD_STATUS_READY)
> >> +			break;
> >> +
> >> +		/*
> >> +		 * TODO: When MC command completion interrupts are supported
> >> +		 * call wait function here instead of udelay()
> >> +		 */
> >> +		udelay(MC_CMD_COMPLETION_POLLING_INTERVAL_USECS);
> >
> > this pauses any caller for 0.5ms on every successful command
> > write.  Can the next submission of the patchseries wait until
> > completion IRQs are indeed supported, since both that and the above
> > locking needs to be resolved?
> >
> No. Interrupt handlers will come in a later patch series as they are
> not needed for using the basic MC functionality.

meanwhile unnecessarily udelaying kernel threads for .5ms upsets
basic kernel functionality :)  Would using the kernel's
wait_for_completion API be a good compromise here?  See
include/linux/completion.h.

Kim
