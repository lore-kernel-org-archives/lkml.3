Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3JBRwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:52:17 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:57514 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511Ab3JBRwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:52:14 -0400
Date: Wed, 2 Oct 2013 11:46:40 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
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
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2] fpga: Introduce new fpga subsystem
Message-ID: <20131002174640.GA10287@obsidianresearch.com>
References: <cover.1380727889.git.michal.simek@xilinx.com>
 <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 05:35:58PM +0200, Michal Simek wrote:

> +What:		/sys/class/fpga_manager/fpga<dev-id>/fpga_config_state
> +Date:		October 2013
> +KernelVersion:	3.12
> +Contact:	Michal Simek <michal.simek@xilinx.com>
> +Description:
> +		By reading this file you will get current fpga manager state.
> +		Flag bits are present in include/linux/fpga.h (FPGA_MGR_XX).
> +		By writing to this file you can change fpga manager state.
> +		Valid options are: write_init, write_complete, read_init,
> +		read_complete.

This shouldn't be asymmetric - read/write should be in the same
format.

I strongly encourage you to use text strings to indicate the state of
the configuration FSM, and I *really* think you should rework things
to have an explicit configuration FSM rather than trying to bodge one
together with a bunch of bit flags.

Plus error handling is missing, failures need to be reported back.

Noticed several typos:

> +
> +	if (mgr->mops->read_init) {
> +		ret = mgr->mops->read_init(mgr);
> +		if (ret) {
> +			dev_dbg(mgr->dev, "Failed to write_init\n");
                                                    ^^^^^^^^
read_init

> +	if (mgr->mops->write) {
                   ^^^^^^^^^^
read

> +		ret = mgr->mops->read(mgr, buf, count);
> +		if (ret) {
> +			dev_dbg(mgr->dev, "Failed to write\n");
                                             ^^^^^^^^^^^^^^^^^
read

> +
> +	if (mgr->mops->write_complete) {
                    ^^^^^^^^^^
read
> +		ret = mgr->mops->read_complete(mgr);
> +		if (ret) {
> +			dev_dbg(mgr->dev, "Failed to write_complete\n");
  					  	  ^^^^^^^^^^^^
read

> +static inline int fpga_mgr_write(struct fpga_manager *mgr, const u8 *buf,
> +				 ssize_t count)
> +{
> +	int bit, ret;
> +
> +	dev_dbg(mgr->dev, "%s %lx\n", __func__, mgr->flags);
> +
> +	/* FPGE init has to be done to be able to continue */
           ^^^^^^
FPGA

> +static struct device_attribute fpga_mgr_attrs[] = {
> +	__ATTR(name, S_IRUGO, fpga_mgr_name_show, NULL),
> +	__ATTR(firmware, S_IWUSR, NULL, fpga_mgr_attr_write),
> +	__ATTR(fpga_config_state, S_IRUSR | S_IWUSR,
> +	       fpga_mgr_status_read, fpga_mgr_status_write),
> +	__ATTR_NULL
> +};

AFAIK it is preferred to use DEVICE_ATTR_RO(), ATTRIBUTE_GROUPS()
and struct class.dev_groups

eg see this note in linux/device.h

struct class {
        struct device_attribute         *dev_attrs;     /* use dev_groups instead */
        const struct attribute_group    **dev_groups;
}

> +	struct fpga_manager *mgr;
> +	int ret;
> +
> +	if (!mops) {
> +		dev_dbg(&pdev->dev, "Register failed: NO fpga_manager_ops\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!name || !strlen(name)) {
> +		dev_dbg(&pdev->dev, "Register failed: NO name specific\n");
> +		return -EINVAL;
> +	}
> +
> +	mgr = devm_kzalloc(&pdev->dev, sizeof(*mgr), GFP_KERNEL);
> +	if (!mgr)
> +		return -ENOMEM;

I wonder if this is right, it seems like a strange way to make a class
subsystem, usually the struct fpga_manager would contain the 'struct
device' (not a pointer, so you can use container_of) and drvdata would
be reserved for something else.

This seems to create lifetime issues since the devm above will be
free'd when the platform driver is released, but the class device will
live on with the stray pointer. Better to allocate everything against
the class device below.

Plus you need to ensure the device is fully functionally before
device_register is called, otherwise you race with notifications to
userspace.

> +/**
> + * fpga_mgr_unregister: Remove fpga manager
> + * @pdev: Pointer to the platform device of fpga manager
> + *
> + * Function unregister fpga manager and release all temporary structures
> + *
> + * Returns 0 for all cases
> + */
> +int fpga_mgr_unregister(struct platform_device *pdev)
> +{
> +	struct fpga_manager *mgr = platform_get_drvdata(pdev);
> +
> +	if (mgr && mgr->mops && mgr->mops->fpga_remove)
> +		mgr->mops->fpga_remove(mgr);
> +
> +	device_unregister(mgr->dev);
> +
> +	spin_lock(&fpga_mgr_idr_lock);
> +	idr_remove(&fpga_mgr_idr, mgr->nr);
> +	spin_unlock(&fpga_mgr_idr_lock);

What happens when userspace is holding one of the sysfs files open and
you unload the module? Looks like bad things?

Regards,
Jason
