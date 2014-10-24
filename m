Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaJXKzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:55:21 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54052 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123AbaJXKzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:55:18 -0400
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20141024105200.GA20775@amd>
Date: Fri, 24 Oct 2014 13:55:10 +0300
Cc: atull@opensource.altera.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        Michal Simek <monstr@monstr.eu>, michal.simek@xilinx.com,
        rdunlap@infradead.org, linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        philip@balister.org, rubini@gnudd.com,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, akpm@linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Content-Transfer-Encoding: 8BIT
Message-Id: <B914D894-E486-4EF1-8F84-169E939C58B4@konsulko.com>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com> <1414007405-32186-3-git-send-email-atull@opensource.altera.com> <20141024105200.GA20775@amd>
To: Pavel Machek <pavel@denx.de>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> On Oct 24, 2014, at 1:52 PM, Pavel Machek <pavel@denx.de> wrote:
> 
> Hi!
> 
>> * /sys/class/fpga_manager/<fpga>/firmware
>>  Name of FPGA image file to load using firmware class.
>>  $ echo image.rbf > /sys/class/fpga_manager/<fpga>/firmware
> 
> I .. still don't think this is good idea. What about namespaces?
> The path corresponds to path in which namespace?
> 

FWIW the overlays patchset uses binary configfs attribute to make this work.

>> +int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count)
>> +{
>> +	int ret;
>> +
>> +	if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
>> +		return -EBUSY;
>> +
>> +	dev_info(mgr->dev, "writing buffer to %s\n", mgr->name);
>> +
>> +	ret = __fpga_mgr_write(mgr, buf, count);
>> +	clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(fpga_mgr_write);
> 
> Is the EBUSY -- userspace please try again, but you don't know when to
> try again -- right interface? I mean, normally kernel would wait, so
> that userland does not have to poll?
> 
>> +static ssize_t fpga_mgr_firmware_store(struct device *dev,
>> +				       struct device_attribute *attr,
>> +				       const char *buf, size_t count)
>> +{
>> +	struct fpga_manager *mgr = dev_get_drvdata(dev);
>> +	unsigned int len;
>> +	char image_name[NAME_MAX];
>> +	int ret;
>> +
>> +	/* lose terminating \n */
>> +	strcpy(image_name, buf);
>> +	len = strlen(image_name);
>> +	if (image_name[len - 1] == '\n')
>> +		image_name[len - 1] = 0;
>> +
>> +	ret = fpga_mgr_firmware_write(mgr, image_name);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return count;
>> +}
> 
> This shows why the interface is not right... Valid filename may
> contain \n, right? It may even end with \n.
> 

I could argue that a valid firmware file is one that’s well formed and does not
contain those characters.

I guess this is only for make echo file >foo work. You could specify that echo -n file >foo is
required.


> Best regards,
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Regards

— Pantelis

