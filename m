Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab3HFK1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:27:43 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:52611 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755772Ab3HFK1m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:27:42 -0400
Subject: Re: [PATCH 1/5] pdev: Fix platform device resource linking
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130806101527.GB29283@kroah.com>
Date: Tue, 6 Aug 2013 13:27:35 +0300
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        =?iso-8859-1?Q?Beno=EEt_Coussno?= <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <A7E5F769-6238-430C-AEE5-94598C334D5E@antoniou-consulting.com>
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-2-git-send-email-panto@antoniou-consulting.com> <20130806093601.GB27889@kroah.com> <311C42C3-6544-4058-ABE9-F9FAE72DD5CA@antoniou-consulting.com> <20130806101527.GB29283@kroah.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Aug 6, 2013, at 1:15 PM, Greg Kroah-Hartman wrote:

> On Tue, Aug 06, 2013 at 12:45:42PM +0300, Pantelis Antoniou wrote:
>> Hi Greg,
>> 
>> On Aug 6, 2013, at 12:36 PM, Greg Kroah-Hartman wrote:
>> 
>>> On Tue, Aug 06, 2013 at 10:53:40AM +0300, Pantelis Antoniou wrote:
>>>> Platform device removal uncovered a number of problems with
>>>> the way resources are handled in the core platform code.
>>>> 
>>>> Resources now form child/parent linkages and this requires
>>>> proper linking of the resources. On top of that the OF core
>>>> directly creates it's own platform devices. Simplify things
>>>> by providing helper functions that manage the linking properly.
>>> 
>>> Ugh, the OF core shouldn't be creating platform devices.  Well, yes, I
>>> know it does that today, but ick, ick, ick.
>>> 
>> 
>> Yep, ick, ick, ick is the correct form.
>> 
>>>> Two functions are provided:
>>>> 
>>>> platform_device_link_resources(), which links all the
>>>> linkable resources (if not already linked).
>>>> 
>>>> and platform_device_unlink_resources(), which unlinks all the
>>>> resources.
>>> 
>>> Why would anyone need to call this?  I'm getting the feeling that OF
>>> should just have it's own bus of devices to handle this type of mess.
>>> ACPI is going through the same rewrite for this same type of problem
>>> (they did things differently.)  I suggest you work with the ACPI
>>> developers to so the same thing they are, to solve it correctly for
>>> everyone.
>>> 
>> 
>> It's the same problem really. Another bus type might not fly well.
>> The same device driver should be (in theory) be made to work unchanged
>> either on an OF/ACPI/Fex( :) ) setup.
> 
> No, that's not quite true, a driver needs to know how to talk to the
> bus, as that is how it communicates to the hardware.  It can be done for
> different types of busses (see the OHCI USB controller for one example
> of this), but a driver will have to know what type of bus it is on in
> order to work properly.
> 

In the case of OF & ACPI there is no 'bus'. The device is probably integrated
in the SoC's silicon, but there is absolutely no way to 'probe' for it's existence;
you have to use a-priori knowledge of the SoC's topology in order to configure it
(along with any per-board specific information if there is any kind of shared 
resource configuration - i.e. pinmuxing or something else).

There are the 3 well known methods to do so in the Linux kernel right now:

1) Board files in which the configuration information is stored in the per-board
platform file encoded in platform data structures.

2) OF, in which case the information is provided via the flat device tree blob
the bootloader provides.

3) ACPI in which case the information is provided via the firmware's ACPI tables
(I'm not overly familiar with ACPI, so there might be some more nuance here).

The device driver for all these cases is absolutely the same; the only place where
it differs it's in the way it uses to retrieve that configuration information.

The board file method is pretty much no-go due to the need to support multiple
boards from a single kernel; that leaves OF and ACPI.

>From what I can tell what ACPI supports is a very small subset of what OF can support right now;
that is both number of device drivers, as well as what you can do with device driver
functionality (see things like gpios etc, how much easier is to use with OF).

Since we're in the let's make a wish stage, what I wish for is a board-file & ACPI
translator stage to OF data, and depreciating everything else gradually.
That would kill platform_device and ACPI specific data and move everything
to a common device structure supporting OF for configuration.
 
>> What would it take to move all this into driver core?
> 
> What specifically would you move into there?
> 

Pretty much everything that's in the union of platform_device & whatever 
acpi uses to hold it's configuration info.

> thanks,
> 
> greg k-h

Regards

-- Pantelis

