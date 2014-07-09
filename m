Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaGIMcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:32:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:36735 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaGIMcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:32:13 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="150935235"
Message-ID: <53BD364A.5020703@citrix.com>
Date: Wed, 9 Jul 2014 13:32:10 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/7] xen/pciback: Implement PCI reset slot or bus with
 'do_flr' SysFS attribute
References: <1404845909-13563-1-git-send-email-konrad@kernel.org> <1404845909-13563-5-git-send-email-konrad@kernel.org> <53BC324B.5090600@citrix.com> <20140708184626.GA15548@laptop.dumpdata.com>
In-Reply-To: <20140708184626.GA15548@laptop.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 19:46, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 08, 2014 at 07:02:51PM +0100, David Vrabel wrote:
>> On 08/07/14 19:58, konrad@kernel.org wrote:
>>> --- a/Documentation/ABI/testing/sysfs-driver-pciback
>>> +++ b/Documentation/ABI/testing/sysfs-driver-pciback
>>> @@ -82,3 +82,14 @@ Description:
>>>                  device is shared, enabled, or on a level interrupt line.
>>>                  Writing a string of DDDD:BB:DD.F will toggle the state.
>>>                  This is Domain:Bus:Device.Function where domain is optional.
>>> +
>>> +What:           /sys/bus/pci/drivers/pciback/do_flr
>>> +Date:           July 2014
>>> +KernelVersion:  3.16
>>> +Contact:        xen-devel@lists.xenproject.org
>>> +Description:
>>> +                An option to slot or bus reset an PCI device owned by
>>> +                Xen PCI backend. Writing a string of DDDD:BB:DD.F will cause
>>> +                the driver to perform an slot or bus reset if the device
>>> +                supports. It also checks to make sure that all of the devices
>>> +                under the bridge are owned by Xen PCI backend.
>>
>> Not sure I like this new interface.  I solved this by adding a new reset
>> file that looked like the regular one the pci would have if it supported
>> FLR.  I'm fairly sure I posted a series for this.  Was there a reason
>> you didn't do this?
> 
> It did not work.
> 
> During bootup kobject would complain about a secondary 'reset' SysFS
> on the PCI device.

I think this because of pciback registering a driver too early, before
the device is fully initialized.  You can see in the trace that it is
the common pci code that is trying to add the "reset" file so it must be
doing this /after/ pciback's probe has been called.

I would consider:

1. Removing the "hide" module parameter -- it doesn't work if pciback is
a module anyway.

2. Making pciback initialize like a regular driver module (no
fs_initcall() shenanigans).

3. Require userspace to sort out binding the device to pciback (e.g.,
libxl already does the unbind if requested).

4. Finally, I would consider generic driver core functionality for
prioritizing drivers so they get probed first.

David
