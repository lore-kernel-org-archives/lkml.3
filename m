Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaJXKwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:52:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50485 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbaJXKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:52:05 -0400
Date: Fri, 24 Oct 2014 12:52:00 +0200
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: gregkh@linuxfoundation.org, jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        monstr@monstr.eu, michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
Message-ID: <20141024105200.GA20775@amd>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
 <1414007405-32186-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414007405-32186-3-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * /sys/class/fpga_manager/<fpga>/firmware
>   Name of FPGA image file to load using firmware class.
>   $ echo image.rbf > /sys/class/fpga_manager/<fpga>/firmware

I .. still don't think this is good idea. What about namespaces?
The path corresponds to path in which namespace?

> +int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count)
> +{
> +	int ret;
> +
> +	if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
> +		return -EBUSY;
> +
> +	dev_info(mgr->dev, "writing buffer to %s\n", mgr->name);
> +
> +	ret = __fpga_mgr_write(mgr, buf, count);
> +	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(fpga_mgr_write);

Is the EBUSY -- userspace please try again, but you don't know when to
try again -- right interface? I mean, normally kernel would wait, so
that userland does not have to poll?

> +static ssize_t fpga_mgr_firmware_store(struct device *dev,
> +				       struct device_attribute *attr,
> +				       const char *buf, size_t count)
> +{
> +	struct fpga_manager *mgr = dev_get_drvdata(dev);
> +	unsigned int len;
> +	char image_name[NAME_MAX];
> +	int ret;
> +
> +	/* lose terminating \n */
> +	strcpy(image_name, buf);
> +	len = strlen(image_name);
> +	if (image_name[len - 1] == '\n')
> +		image_name[len - 1] = 0;
> +
> +	ret = fpga_mgr_firmware_write(mgr, image_name);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +}

This shows why the interface is not right... Valid filename may
contain \n, right? It may even end with \n.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
