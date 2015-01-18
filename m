Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbbAROQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 09:16:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:23136 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbbAROQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 09:16:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,421,1418112000"; 
   d="scan'208";a="638990343"
From: "Jamet, Michael" <michael.jamet@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Levy, Amir (Jer)" <amir.jer.levy@intel.com>,
        "Alloun, Dan" <dan.alloun@intel.com>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        Andreas Noever <andreas.noever@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: RE: [PATCH] pci: support Thunderbolt requirements for I/O resources.
Thread-Topic: [PATCH] pci: support Thunderbolt requirements for I/O
 resources.
Thread-Index: AQHP/ohLgY5RjnqrwESQUJmb1M7dNZxdHb+AgAju7eCAAGW4AIAI/fSAgA2OkYCASVK6oA==
Date: Sun, 18 Jan 2015 14:15:59 +0000
Message-ID: <BC567D27D6B7384F84318942321624DE269180EC@hasmsx109.ger.corp.intel.com>
References: <1415847123-15558-1-git-send-email-michael.jamet@intel.com>
 <CAErSpo7Z5x=U3vSnxrFpwYUDrUrnrrBCe1F9_GQNYqWWQFWNpQ@mail.gmail.com>
 <BC567D27D6B7384F84318942321624DE16179E60@hasmsx109.ger.corp.intel.com>
 <CAErSpo5z41ZOL3xUwwSZ8UE_KGmCDOUmFQ3CY_QwF7JVhU1-EQ@mail.gmail.com>
 <20141124091729.3de7ae7b@lxorguk.ukuu.org.uk>
 <CAErSpo407-LFjFh=224qGu5UC4pfMyd8FvWpNDEOsXqSAFfJeQ@mail.gmail.com>
In-Reply-To: <CAErSpo407-LFjFh=224qGu5UC4pfMyd8FvWpNDEOsXqSAFfJeQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0IEGD0T031056

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Wednesday, December 03, 2014 02:19
> To: One Thousand Gnomes
> Cc: Jamet, Michael; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
> Levy, Amir (Jer); Alloun, Dan; Rafael Wysocki; Andreas Noever
> Subject: Re: [PATCH] pci: support Thunderbolt requirements for I/O resources.
> 
> On Mon, Nov 24, 2014 at 2:17 AM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
> >> > This was also discussed internally and the only way to identify Thunderbolt
> devices is to check the device IDs.
> >> > As you said, this will require us to maintain and keep the list up-to-date as
> we deliver new devices.
> >>
> >> I don't really see how this can work.  You're asking me to put
> >> changes based on a secret spec into generic code that is used on
> >> every machine with PCI.  I have no way to maintain something like that.
> >
> >>
> >> This seems like a major screw up in the design and documentation of
> Thunderbolt.
> >
> > See
> > https://developer.apple.com/library/mac/documentation/HardwareDrivers/
> > Conceptual/ThunderboltDevGuide/ThunderboltDevGuide.pdf
> >
> > page 10 for one of the brief public notes on the not relying on I/O space.
> 
> I agree with that recommendation not to rely on I/O space.  It applies equally
> to *all* PCI devices, not just to Thunderbolt.
> 
> Presumably this patch fixes a problem.  The changelog says:
> 
>     Kernel shouldn't allocate the PCI I/O resources
>     as it interferes with BIOS operation.
>     Doing this may cause the devices in the Thunderbolt chain
>     not being detected or added, or worse to stuck the
>     Thunderbolt Host controller.
> 
> The problem of devices not being detected sounds like a general problem (I
> assume the problem is actually that we do enumerate the device, but we may
> not be able to assign I/O port space to it, which means we may not be able to
> operate it).  This could happen with any device.  If you can come up with a
> generic way to deal with it, that might work.  Note that we do already have
> pci_enable_device_mem() for drivers that don't need I/O space to operate
> their device.
> 
> If assigning I/O port space to a device can hang the Thunderbolt controller, that
> sounds like a controller defect, and maybe you could write a quirk to work
> around it.  I'm not opposed to adding device-specific workarounds for things
> like that.  I just have trouble with putting undocumented workarounds in the
> common path that everybody uses.
> 
> Bjorn

The actual problem the patch is meant to address is related to the PCI 
limitation of 64KB I/O space and the fact that allocations are 
performed in chunks of 4KB behind PCI-to-PCI bridges.
After a certain amount of devices the I/O resources may be exhausted. 
This is indeed a general issue, not only related to Thunderbolt, and 
as Bjorn suggested a general fix is advised.
 
Following further investigations it seems that we may not really need 
this patch for the following reasons:

1. It seems that the controller issues (written on the changelog) were 
related to the lack of support of hotplug topology changes in the old 
tested kernel (3.15) rather than the I/O space issue.

2. Kernel PCI driver handles properly allocations of I/O resources and 
prevents I/O resources exhaustion which may have caused issues (if not 
handled properly) to any PCI or Thunderbolt controller. Looks like 
first device asking I/O is the first served and this mechanism works fine.

3. For most devices supported today on Thunderbolt such as AHCI or  
iGB (E1000E), if no I/O resources is allocated, the device seems to 
continue to operate through the memory BARs.
 
/Michael
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
