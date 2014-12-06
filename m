Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaLFNAl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 08:00:41 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:53435 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbaLFNAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 08:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141024105200.GA20775@amd>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
 <1414007405-32186-3-git-send-email-atull@opensource.altera.com> <20141024105200.GA20775@amd>
From: Grant Likely <grant.likely@linaro.org>
Date: Sat, 6 Dec 2014 13:00:17 +0000
X-Google-Sender-Auth: vtwksjVnS_hYJWrZlCtrx0k9klE
Message-ID: <CACxGe6sa=ysJAjx5TQZH5sKoas1PkoUUR4zT=Z35+uF6rrk-vw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
To: Pavel Machek <pavel@denx.de>
Cc: atull@opensource.altera.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>, Ira Snyder <iws@ovro.caltech.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, philip@balister.org,
        rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason <jason@lakedaemon.net>, kyle.teske@ni.com,
        Nicolas Pitre <nico@linaro.org>, "Balbi, Felipe" <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>, cesarb@cesarb.net,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        Yves Vandervennet <yvanderv@opensource.altera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:52 AM, Pavel Machek <pavel@denx.de> wrote:
> Hi!
>
>> * /sys/class/fpga_manager/<fpga>/firmware
>>   Name of FPGA image file to load using firmware class.
>>   $ echo image.rbf > /sys/class/fpga_manager/<fpga>/firmware
>
> I .. still don't think this is good idea. What about namespaces?
> The path corresponds to path in which namespace?

I don't understand your concern here. This allows userspace to name
the FPGA bitstream that the kernel will use during request_firmware(),
and it will show up as the $FIRMWARE value in the uevent file, but it
is still the responsibility of userspace to choose what to load, and
it can freely ignore the setting of $FIRMWARE if it needs to.

The process that actually loads the firmware into the kernel pretty
much has to run in the normal linux environment. How do namespaces
come into it? What exact problem do you see?

>
>> +int fpga_mgr_write(struct fpga_manager *mgr, const char *buf, size_t count)
>> +{
>> +     int ret;
>> +
>> +     if (test_and_set_bit_lock(FPGA_MGR_BUSY, &mgr->flags))
>> +             return -EBUSY;
>> +
>> +     dev_info(mgr->dev, "writing buffer to %s\n", mgr->name);
>> +
>> +     ret = __fpga_mgr_write(mgr, buf, count);
>> +     clear_bit_unlock(FPGA_MGR_BUSY, &mgr->flags);
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(fpga_mgr_write);
>
> Is the EBUSY -- userspace please try again, but you don't know when to
> try again -- right interface? I mean, normally kernel would wait, so
> that userland does not have to poll?

Custom locking schemes are just wrong. A mutex is the right thing to
do here and then an -EBUSY isn't required.

>
>> +static ssize_t fpga_mgr_firmware_store(struct device *dev,
>> +                                    struct device_attribute *attr,
>> +                                    const char *buf, size_t count)
>> +{
>> +     struct fpga_manager *mgr = dev_get_drvdata(dev);
>> +     unsigned int len;
>> +     char image_name[NAME_MAX];

Hard coding a string length is a warning sign. That is the sort of
thing that can memdup() or strdup() can handle.

>> +     int ret;
>> +
>> +     /* lose terminating \n */
>> +     strcpy(image_name, buf);
>> +     len = strlen(image_name);
>> +     if (image_name[len - 1] == '\n')
>> +             image_name[len - 1] = 0;
>> +
>> +     ret = fpga_mgr_firmware_write(mgr, image_name);
>> +     if (ret)
>> +             return ret;
>> +
>> +     return count;
>> +}
>
> This shows why the interface is not right... Valid filename may
> contain \n, right? It may even end with \n.

That's not an interface problem, it implementation problem. The
function absolutely should scrub and validate it's input. It should
also make sure that the string doesn't have any special characters so
that /bin/sh doesn't barf on it (because the string will appear in the
uevent file). I would check other users of request_firmware() to see
if any of them allow userspace to specify the filename.

That said, the other way to handle this is not to specify a valid
filename through this interface at all. Just use a dummy placeholder
name and expect userspace to load the correct file when the request is
posted.

g.
