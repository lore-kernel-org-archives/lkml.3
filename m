Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbaLHSbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 13:31:19 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45766 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaLHSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 13:31:17 -0500
MIME-Version: 1.0
In-Reply-To: <6B035765-3AFB-4A28-8A16-51D2E2737932@konsulko.com>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
 <1414007405-32186-3-git-send-email-atull@opensource.altera.com>
 <20141024105200.GA20775@amd> <B914D894-E486-4EF1-8F84-169E939C58B4@konsulko.com>
 <alpine.DEB.2.02.1410240906340.23446@atx-linux-37> <CACxGe6tiLxbCThzjOqrQg44Ue3XJuuRgti5jZY=UrssSY8=xqg@mail.gmail.com>
 <20141206135533.GA19672@amd> <20141208175050.92EDAC40D73@trevor.secretlab.ca> <6B035765-3AFB-4A28-8A16-51D2E2737932@konsulko.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 8 Dec 2014 18:30:56 +0000
X-Google-Sender-Auth: 50TGklWHVAdf3Hi0hlZe8_4VQ0c
Message-ID: <CACxGe6uy7FhAPC4PU8ciNEgg7d+oV+GR=8wYrO1YD7UuUfy7Bw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Pavel Machek <pavel@denx.de>, atull <atull@opensource.altera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ira Snyder <iws@ovro.caltech.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Philip Balister <philip@balister.org>,
        rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason <jason@lakedaemon.net>, kyle.teske@ni.com,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
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

On Mon, Dec 8, 2014 at 5:56 PM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Hi Grant,
>
>> On Dec 8, 2014, at 19:50 , Grant Likely <grant.likely@linaro.org> wrote:
>>
>> On Sat, 6 Dec 2014 14:55:33 +0100
>> , Pavel Machek <pavel@denx.de>
>> wrote:
>>> Hi!
>>>
>>>>> I am accustomed to doing 'echo -n' for most of sysfs anyway.  Once in a
>>>>> while I am a bonehead and forget the '-n' and spend a few minutes
>>>>> wondering why this thing that worked last week suddenly rejects all
>>>>> commands.  I'm just trying to make my user interface a bit user-friendly.
>>>>>
>>>>> I will take out the '\n' stripping and update the documentation.  I didn't
>>>>> realize this would be controversial.
>>>>
>>>> Don't. You're doing the right thing by scrubbing your input. Requiring
>>>> 'echo -n' is just stupid when it is so easy to make work easily.
>>>
>>> 'foo\nbar\n' is unusual but valid filename in linux. It is bad idea to
>>> echo filenames into files in the first place... and arbitrarily
>>> disallowing certain filenames is not helping.
>>
>> Meh. Just because it is a valid linux filename doesn't mean this
>> interface is forced to accept it. There should be tighter rules about
>> how the filename can be constructed. Allowing any arbitrary path for any
>> arbitrary valid linux filename makes for a large attack surface.
>>
>> I would like to know, what is the purpose of the interface? Why is it
>> important to provide the firmware filename in this manor? Are there
>> going to be a lot of different FPGA bitstreams that may need to be
>> loaded? How does userspace choose between them, and is there a better
>> way to do the selection without passing the firmware filename through
>> the kernel? Is this merely intended to get udev to behave in a certain
>> way? If so, then maybe there is a better way to go about it.
>>
>> We could for example use a UDEV 'PROGRAM=' rule to execute a userspace
>> app and have that program figure out which firmware file to provide to
>> the kernel.
>>
>
> Please, lets not depend at all on udev. Firmware can be embedded in the kernel
> image, which is pretty important to work before userland if you have to have
> the rootfs on a device that's instantiated via an FPGA bitstream.

It sounds like there are two issues here. One is the loading of a
default image (like when built into the kernel), and the other is
selecting between multiple firmware files, but the kernel won't know
which without either userspace or firmware assistance. For the second
issue is sounds to me like the rules for choosing between multiple
images needs to be well defined. Echoing an arbitrary filename into
the sysfs interface is too loosely defined.

g.
