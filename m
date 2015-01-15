Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbbAOUy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 15:54:57 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42615 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbbAOUyy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 15:54:54 -0500
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20150115204502.591bca1d@lxorguk.ukuu.org.uk>
Date: Thu, 15 Jan 2015 22:54:46 +0200
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        atull <atull@opensource.altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, hpa@zytor.com,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>, rdunlap@infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        philip@balister.org, rubini@gnudd.com,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, akpm@linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devel@driverdev.osuosl.org,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Content-Transfer-Encoding: 8BIT
Message-Id: <A3B5BC9B-EB88-4C0E-B235-E9C86D23DC34@konsulko.com>
References: <20150107084819.GA1887@amd> <alpine.DEB.2.02.1501091302370.30067@linuxheads99> <20150109205643.GA5761@amd> <20150112210134.687176ed@lxorguk.ukuu.org.uk> <20150112214314.GA18610@obsidianresearch.com> <20150113162847.2778b5a5@lxorguk.ukuu.org.uk> <20150113200032.GA16205@obsidianresearch.com> <alpine.DEB.2.02.1501131455130.30192@linuxheads99> <20150113222450.GA17475@obsidianresearch.com> <alpine.DEB.2.02.1501150936390.16760@linuxheads99> <20150115184726.GA23247@obsidianresearch.com> <20150115204502.591bca1d@lxorguk.ukuu.org.uk>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> On Jan 15, 2015, at 22:45 , One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> 
> On Thu, 15 Jan 2015 11:47:26 -0700
> Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
>> It is a novel idea, my concern would be that embedding the FPGA in the
>> DT makes it permanent unswappable kernel memory.
>> Not having the kernel hold the FPGA is best for many uses.
> 
> If you have a filesysytem before the FPGA is set up then it belongs in
> the file system. As you presumably loaded the kernel from somewhere there
> ought to be a file system (even an initrd).
> 

Request firmware does not imply keeping it around. You can always re-request
when reloading (although there’s a nasty big of caching that needs to be
resolved with the firmware loader).

>> Having the kernel hold the FPGA as a swppable file handle/mmap of some
>> sort is next best (obviously the fs must be operating during resume)
> 
> For a lot of hardware that gets somewhat hairy because you don't know
> what the dependancies between devices are on the resume but yes.
> 
>> Unswappable kernel memory is the worst choice
> 
> There is another case here - which is where the firmware is somewhere
> else physically. For example in PCI ROM space, or flash, but designed to
> be loaded by the OS.
> 
> 

One of the ideas rolling about is to put the device tree overlay blob in
an EEPROM and then load it from there (not from the filesystem).

>> I think to justify the ioctls you need a reason to have the context
>> of a FD. sysfs is stateless, so if my process dies the kernel doesn't
>> know.
> 
> That isn't to say the stateless information doesn't belong in sysfs. Eg
> you don't neccessarily want to open the device node and go through ioctls
> just for bits of information that are interesting to reporting tools.
> 
> (Imagine an 'lsfpga' tool for the kind of things you'd leave in sysfs)
> 
>> Identifying the ioctls needed would probably clarify things. My
>> rough start would be 
>> 
>> - Get status: programed, not programmed, error?
>>  Bitfile type? (eg Xilinx has nearly every permutation of bit/byte
>>  ordering)
> 
> That's probably some kind of "what are you" ioctl that returns the
> vendor/type information.
> 

Can we please not use ioctls if possible. Configfs seems to work just fine
for configuration and for any other higher speed API we should use read/write/mmap.

Ioctls are a pain for scripting and interpreted languages usually.

>> - Hand over to a DT overlay (how does this work?) Lock transfers
>>  from FD to kernel
> 
> That bit isn't stateful so I would actually have expected something in
> the kernel ABI along the lines of 
> 
>           request_fpga(blah)
> 
> which does
> 
>             if in use by user
>                    EBUSY
>             lock it (all user opens will fail)
> 
> and
> 
>            release_fpga(blah)
> 
> and a sysfs node indicating its busy (and perhaps also what for if the
> request_fpga passes a textual name)
> 
>> Not sure about partial reconfiguration - clearly the kernel needs to
>> know and check that the bitfiles are of the correct family, I wonder
>> if the approach should be to program a basis on the FPGA which then
>> creates a new FPGA device in the system that can accept the partial
>> reconfiguration - this way the locking makes sense, the basis is
>> locked by the kernel and devices and the overlay remains
>> lockable/swappable/whatever by a dedicated /dev/ node ??
> 
> I think so.
> 
> If you closed the device you have no idea what happened between the close
> and a re-open, therefore you have no idea what the FPGA state is.
> 
>> Just thinking aloud, I've never had a use case for partial
>> reconfiguration.
> 
> The API handles it but whether it needs to be there from day one I don't
> know.
> 

Making the API handle partial reconfiguration from day one might be pushing tricky.
I don’t remember any case where I came across a need for it.

We could do with a virtual FPGA topology; have a root FPGA that’s keeping the
common unchanged bits and another that’s keeping the bits that do change.

Dunno how nice it would be in practice though.

> Alan
> 

Regards

— Pantelis

