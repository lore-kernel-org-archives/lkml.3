Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaIJQd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 12:33:26 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37100 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbaIJQdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 12:33:24 -0400
Date: Wed, 10 Sep 2014 10:32:50 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yijing Wang <wangyijing@huawei.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
Message-ID: <20140910163250.GA22910@obsidianresearch.com>
References: <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com>
 <20140908145459.GO27864@e106497-lin.cambridge.arm.com>
 <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com>
 <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
 <540E960D.7080408@huawei.com>
 <20140909084621.GS27864@e106497-lin.cambridge.arm.com>
 <540EC8CB.7010106@huawei.com>
 <CAErSpo4cAfom2=07NYDRfTCdHO22M0v+ueiaZuG6v2Xd18wEnQ@mail.gmail.com>
 <20140909154123.GA12906@obsidianresearch.com>
 <CAL_JsqJMRqbwNkB2K6Mg2DU9mSHwAObtD7LLG2_n=4jGDAFhyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqJMRqbwNkB2K6Mg2DU9mSHwAObtD7LLG2_n=4jGDAFhyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 09:44:56PM -0500, Rob Herring wrote:
> On Tue, Sep 9, 2014 at 10:41 AM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > On Tue, Sep 09, 2014 at 08:26:19AM -0600, Bjorn Helgaas wrote:
> >
> >> So as long as the DT tells you the ECAM information for each host
> >> bridge, that should be sufficient.  The domain number is then just a
> >> Linux convenience and is not tied to the platform as it is on ia64.
> >
> > I think this is right for DT systems - the domain is purely internal
> > to the kernel and userspace, it is used to locate the proper host
> > bridge driver instance, which contains the proper config accessor (and
> > register bases, etc).
> >
> > AFAIK the main reason to have a DT alias to learn the domain number is
> > to make it stable so things like udev/etc can reliably match on the
> > PCI location.
> 
> For what purpose?

udev places PCI D:B:D.F's all over the place, eg:

$ ls /dev/serial/by-path/
pci-0000:00:1a.0-usb-0:1.4.2.5:1.0@
pci-0000:00:1a.0-usb-0:1.4.2.6:1.0@
$ ls /dev/disk/by-path/
pci-0000:03:00.0-sas-0x5fcfffff00000001-lun-0@
pci-0000:03:00.0-sas-0x5fcfffff00000001-lun-0-part1@
pci-0000:03:00.0-sas-0x5fcfffff00000001-lun-0-part2@
pci-0000:03:00.0-sas-0x5fcfffff00000001-lun-0-part3@
    ^^^^
domain number

It is part of the stable naming scheme udev uses - and that scheme is
predicated on the PCI location being stable.

> IMO they should not. We really want to move away from aliases, not
> expand their use. They are used for serial because there was no good
> way to not break things like "console=ttyS0". I2C I think was more
> internal, but may have been for i2c-dev. What are we going to break if
> we don't have consistent domain numbering? 

Well, DT needs some kind of solution to produce stable names for
things. It is no good if the names unpredictably randomize.

Lets use I2C as an example. My embedded systems have multiple I2C
busses, with multiple drivers (so load order is not easily ensured).
I am relying on DT aliases to force the bus numbers to stable values,
but if I don't do that - then how do I find things in user space?

$ ls -l /sys/bus/i2c/devices
lrwxrwxrwx    1 root     root            0 Sep 10 16:12 i2c-2 -> ../../../devices/pci0000:00/0000:00:01.0/i2c_qsfp.4/i2c-2

Oh, I have to search based on the HW path, which includes the domain
number.

So that *must* be really stable, or user space has no hope of mapping
real hardware back to an I2C bus number.

The same is true for pretty much every small IDR scheme in the kernel
- they rely on the HW path for stable names.

As an aside, I think for embedded being able to directly specify
things like the bus number for I2C, ethX for ethernet, etc is very
valuable, I would be sad to see that go away.

> DT, I'd rather see it as part of the PCI root node. But I'm not
> convinced it is needed.
 
> It doesn't really sound like we have any actual need to solve this for
> DT ATM. It's not clear to me if all buses should be domain 0 or a
> simple incrementing index for each bus in absence of any firmware set
> value.

There are already ARM DTs in the kernel that require multiple domains,
so that ship has sailed.

I don't think it really matters where the number comes from, so long
as it doesn't change after a kernel upgrade, or with a different
module load order, or if the DT is recompiled, or whatever. It needs
to be stable.

Jason
