Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3JDSwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 14:52:13 -0400
Received: from [216.32.180.189] ([216.32.180.189]:53312 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750983Ab3JDSwL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 14:52:11 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -10
X-BigFish: VS-10(z551bizbb2dI98dI9371I936eI1454I1432I4015I13e6K1521Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh2a8h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
Message-ID: <1380912653.2920.35.camel@atx-linux-37>
Subject: Re: [RFC PATCH v2] fpga: Introduce new fpga subsystem
From: Alan Tull <atull@altera.com>
To: Michal Simek <monstr@monstr.eu>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, <linux-doc@vger.kernel.org>
Date: Fri, 4 Oct 2013 13:50:53 -0500
In-Reply-To: <524EECA7.7040409@monstr.eu>
References: <cover.1380727889.git.michal.simek@xilinx.com>
	 <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com>
	 <20131002174640.GA10287@obsidianresearch.com> <524EECA7.7040409@monstr.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-04 at 18:28 +0200, Michal Simek wrote:
> On 10/02/2013 07:46 PM, Jason Gunthorpe wrote:
> > On Wed, Oct 02, 2013 at 05:35:58PM +0200, Michal Simek wrote:
> > 
> >> +What:		/sys/class/fpga_manager/fpga<dev-id>/fpga_config_state
> >> +Date:		October 2013
> >> +KernelVersion:	3.12
> >> +Contact:	Michal Simek <michal.simek@xilinx.com>
> >> +Description:
> >> +		By reading this file you will get current fpga manager state.
> >> +		Flag bits are present in include/linux/fpga.h (FPGA_MGR_XX).
> >> +		By writing to this file you can change fpga manager state.
> >> +		Valid options are: write_init, write_complete, read_init,
> >> +		read_complete.
> > 
> > This shouldn't be asymmetric - read/write should be in the same
> > format.
> > 
> > I strongly encourage you to use text strings to indicate the state of
> > the configuration FSM, and I *really* think you should rework things
> > to have an explicit configuration FSM rather than trying to bodge one
> > together with a bunch of bit flags.
> 
> Any favourite names for states?
> Or ready, write_init, write_complete is enough for now?

Currently the only state I want to attempt to *set* from sysfs would be
reset. 

For Altera fpga, the states I want to *report* are:

static const char *const altera_fpga_state_str[] = {
        [ALT_FPGAMGR_STAT_POWER_UP] = "power up phase",
        [ALT_FPGAMGR_STAT_RESET] = "reset phase",
        [ALT_FPGAMGR_STAT_CFG] = "configuration phase",
        [ALT_FPGAMGR_STAT_INIT] = "initialization phase",
        [ALT_FPGAMGR_STAT_USER_MODE] = "user mode",
        [ALT_FPGAMGR_STAT_UNKNOWN] = "undetermined",
        [ALT_FPGAMGR_STAT_POWER_OFF] = "powered off",
};

Setting write_init and write_complete explicitly is fine, but not needed
for me.  I'm fine with the driver knowing that if I request to write
data, it knows that it needs to write_init and write_complete.  Either
way works for me here.


> 
> Alan: This should be unified way for user to get proper states from the
> driver. It means from my point of view will be better to have set of states
> which this function can return instead of calling origin status function
> where we can't control states for all these drivers.

I agree with both you and Jason on this :)  I agree that it should be
strings, and also that it probably should come from the framework
instead of directly from the low level driver.  The framework should
query the low level driver for state.  Not all vendors' fpgas support
exactly the same set of states, so we can hash out a superset that we
can agree on that fits all our needs (mine are above). 

I think this is separate from your 'flags' implementation.  I like that
implementation for locking, but I want something that actually goes to
the low level driver to find out what state the fpga manager has to
report.

> 
> > Plus error handling is missing, failures need to be reported back.
> 
> Will fix this.
> 
> > Noticed several typos:
> 
> Ah yeah c&p. :-(
> 
> > 
> >> +
> >> +	if (mgr->mops->read_init) {
> >> +		ret = mgr->mops->read_init(mgr);
> >> +		if (ret) {
> >> +			dev_dbg(mgr->dev, "Failed to write_init\n");
> >                                                     ^^^^^^^^
> > read_init
> > 
> >> +	if (mgr->mops->write) {
> >                    ^^^^^^^^^^
> > read
> > 
> >> +		ret = mgr->mops->read(mgr, buf, count);
> >> +		if (ret) {
> >> +			dev_dbg(mgr->dev, "Failed to write\n");
> >                                              ^^^^^^^^^^^^^^^^^
> > read
> > 
> >> +
> >> +	if (mgr->mops->write_complete) {
> >                     ^^^^^^^^^^
> > read
> >> +		ret = mgr->mops->read_complete(mgr);
> >> +		if (ret) {
> >> +			dev_dbg(mgr->dev, "Failed to write_complete\n");
> >   					  	  ^^^^^^^^^^^^
> > read
> > 
> >> +static inline int fpga_mgr_write(struct fpga_manager *mgr, const u8 *buf,
> >> +				 ssize_t count)
> >> +{
> >> +	int bit, ret;
> >> +
> >> +	dev_dbg(mgr->dev, "%s %lx\n", __func__, mgr->flags);
> >> +
> >> +	/* FPGE init has to be done to be able to continue */
> >            ^^^^^^
> > FPGA
> > 
> >> +static struct device_attribute fpga_mgr_attrs[] = {
> >> +	__ATTR(name, S_IRUGO, fpga_mgr_name_show, NULL),
> >> +	__ATTR(firmware, S_IWUSR, NULL, fpga_mgr_attr_write),
> >> +	__ATTR(fpga_config_state, S_IRUSR | S_IWUSR,
> >> +	       fpga_mgr_status_read, fpga_mgr_status_write),
> >> +	__ATTR_NULL
> >> +};
> > 
> > AFAIK it is preferred to use DEVICE_ATTR_RO(), ATTRIBUTE_GROUPS()
> > and struct class.dev_groups
> > 
> > eg see this note in linux/device.h
> > 
> > struct class {
> >         struct device_attribute         *dev_attrs;     /* use dev_groups instead */
> >         const struct attribute_group    **dev_groups;
> > }
> > 
> 
> This will be fixed in v3. I have already changed this.
> 
> >> +	struct fpga_manager *mgr;
> >> +	int ret;
> >> +
> >> +	if (!mops) {
> >> +		dev_dbg(&pdev->dev, "Register failed: NO fpga_manager_ops\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	if (!name || !strlen(name)) {
> >> +		dev_dbg(&pdev->dev, "Register failed: NO name specific\n");
> >> +		return -EINVAL;
> >> +	}
> >> +
> >> +	mgr = devm_kzalloc(&pdev->dev, sizeof(*mgr), GFP_KERNEL);
> >> +	if (!mgr)
> >> +		return -ENOMEM;
> > 
> > I wonder if this is right, it seems like a strange way to make a class
> > subsystem, usually the struct fpga_manager would contain the 'struct
> > device' (not a pointer, so you can use container_of) and drvdata would
> > be reserved for something else.
> 
> I am not following you here. mrg structure is connected with the driver
> it means when driver is removed then this structure is freed.
> 
> 
> > 
> > This seems to create lifetime issues since the devm above will be
> > free'd when the platform driver is released, but the class device will
> > live on with the stray pointer. Better to allocate everything against
> > the class device below.
> 
> device in unregistered before this structure is freed.
> fpga_mgr_unregister() is called in the platform driver in remove function.
> 
> > 
> > Plus you need to ensure the device is fully functionally before
> > device_register is called, otherwise you race with notifications to
> > userspace.
> 
> fpga_mgr_register() should be called as the latest function in the probe
> in platform_driver. At least it is what I have for zynq.
> 
> >> +/**
> >> + * fpga_mgr_unregister: Remove fpga manager
> >> + * @pdev: Pointer to the platform device of fpga manager
> >> + *
> >> + * Function unregister fpga manager and release all temporary structures
> >> + *
> >> + * Returns 0 for all cases
> >> + */
> >> +int fpga_mgr_unregister(struct platform_device *pdev)
> >> +{
> >> +	struct fpga_manager *mgr = platform_get_drvdata(pdev);
> >> +
> >> +	if (mgr && mgr->mops && mgr->mops->fpga_remove)
> >> +		mgr->mops->fpga_remove(mgr);
> >> +
> >> +	device_unregister(mgr->dev);
> >> +
> >> +	spin_lock(&fpga_mgr_idr_lock);
> >> +	idr_remove(&fpga_mgr_idr, mgr->nr);
> >> +	spin_unlock(&fpga_mgr_idr_lock);
> > 
> > What happens when userspace is holding one of the sysfs files open and
> > you unload the module? Looks like bad things?
> 
> I didn't test this but feel free to check it.
> 
> Thanks,
> Michal
> 


