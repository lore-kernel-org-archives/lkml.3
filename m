Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3JBQGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:06:45 -0400
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:55366 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753046Ab3JBQGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:06:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::::::::::::::::::::::::::::::::::::cesarb@cesarb
X-HE-Tag: drain81_912bb347b1712
X-Filterd-Recvd-Size: 4653
Message-ID: <1380729996.2081.59.camel@joe-AO722>
Subject: Re: [RFC PATCH v2] fpga: Introduce new fpga subsystem
From: Joe Perches <joe@perches.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org
Date: Wed, 02 Oct 2013 09:06:36 -0700
In-Reply-To: <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com>
References: <cover.1380727889.git.michal.simek@xilinx.com>
	 <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 17:35 +0200, Michal Simek wrote:
> This new fpga subsystem core should unify all fpga drivers/managers which
> do the same things. Load configuration data to fpga or another programmable
> logic through common interface. It doesn't matter if it is MMIO device,
> gpio bitbanging, etc. connection. The point is to have the same
> interface for these drivers.

Does this interface support partial reprogramming/configuration
for FPGAs that can do that?

trivial notes:

There are a _lot_ of dev_dbg statements.

I hope some of these would be removed one day,
especially the function tracing style ones, because
there's already a generic kernel mechanism for that.

Maybe perf/trace support could be added eventually.

> diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c
[]
> +/**
> + * fpga_mgr_status_write - Write fpga manager status
> + * @dev: Pointer to the device structure
> + * @attr: Pointer to the device attribute structure
> + * @buf: Pointer to the buffer location
> + * @count: Number of characters in @buf
> + *
> + * Returns the number of bytes copied to @buf, a negative error number otherwise
> + */
> +static ssize_t fpga_mgr_status_write(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct fpga_manager *mgr = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (test_and_set_bit_lock(FPGA_MGR_DEV_BUSY, &mgr->flags))
> +		return -EBUSY;
> +
> +	ret = strcmp(buf, "write_init");
> +	if (!ret) {
> +		ret = fpga_mgr_write_init(mgr);
> +		goto out;
> +	}
> +
> +	ret = strcmp(buf, "write_complete");
> +	if (!ret) {
> +		ret = fpga_mgr_write_complete(mgr);
> +		goto out;
> +	}
> +
> +	ret = strcmp(buf, "read_init");
> +	if (!ret) {
> +		ret = fpga_mgr_read_init(mgr);
> +		goto out;
> +	}
> +
> +	ret = strcmp(buf, "read_complete");
> +	if (!ret) {
> +		ret = fpga_mgr_read_complete(mgr);
> +		goto out;
> +	}
> +
> +	ret = -EINVAL;
> +out:
> +	clear_bit_unlock(FPGA_MGR_DEV_BUSY, &mgr->flags);
> +
> +	return ret ? : count;
> +}

I think this style is awkward and this would be
better written as:

	if (!strcmp(buf, "write_init"))
		ret = fpga_mgr_write_init(mgr);
	else if (!strcmp(buf, "write_complete"))
		ret = fpga_mgr_write_complete(mgr);
	else if (!strcmp(buf, "read_init"))
		ret = fpga_mgr_read_init(mgr);
	else if (!strcmp(buf, "read_complete"))
		ret = fpga_mgr_read_complete(mgr);
	else
		ret = -EINVAL;

	clear_bit_unlock(FPGA_MGR_DEV_BUSY, &mgr->flags);

	if (ret)
		return ret;

	return count;
}

Maybe use (strcmp(...) == 0) if you prefer that.
Both styles are commonly used in linux.

Probably all of the "return ret ?: count;" uses
would be more easily understood on 3 lines.


