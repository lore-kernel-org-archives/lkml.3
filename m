Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaIVW7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:59:40 -0400
Received: from exprod5og123.obsmtp.com ([64.18.0.198]:59893 "HELO
	exprod5og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755303AbaIVW7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:59:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140922222727.GC15822@obsidianresearch.com>
References: <1410906824-9321-1-git-send-email-tinamdar@apm.com>
	<1410906824-9321-2-git-send-email-tinamdar@apm.com>
	<20140919223258.GA32208@google.com>
	<CACoXjcnVU3+fQHQ0-zEVRjoedrrod-aua6AVybj7UuSHO9HBaw@mail.gmail.com>
	<CAErSpo4C_6mh7hais14254rYBeMYArvf=nETmgvBjgP290aD4Q@mail.gmail.com>
	<20140922222727.GC15822@obsidianresearch.com>
Date: Mon, 22 Sep 2014 15:59:35 -0700
Message-ID: <CACoXjcmuVZbAQcHyunxu4DaY3Wew2tttydWsSmneYiUf73dRow@mail.gmail.com>
Subject: Re: [PATCH v9 1/4] pci:host: APM X-Gene PCIe host controller driver
From: Tanmay Inamdar <tinamdar@apm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 3:27 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Mon, Sep 22, 2014 at 04:09:03PM -0600, Bjorn Helgaas wrote:
>> On Mon, Sep 22, 2014 at 3:33 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
>>
>> >>> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
>> >>> +{
>> >>> +     int i;
>> >>> +
>> >>> +     /* Hide the PCI host BARs from the kernel as their content doesn't
>> >>> +      * fit well in the resource management
>> >>> +      */
>> >>
>> >> This needs a better explanation than "doesn't fit well."
>> >>
>> >> I *think* you're probably talking about something similar to the MVEBU
>> >> devices mentioned here:
>> >> http://lkml.kernel.org/r/CAErSpo56jB1Bf2JtYCGKXZBZqRF1jXFxGmeewPX_e6vSXueGyA@mail.gmail.com
>> >>
>> >> where the device can be configured as either an endpoint or a root port,
>> >> and the endpoint BARs are still visible when configured as a root port.
>> >>
>> >
>> > It is true that X-Gene PCIe port can be configured as EP, however the
>> > the FIXUP is required not because of the BARs are still visible when
>> > configured as EP in past. X-Gene PCIe port, when configured as RC,
>> > uses BAR0-BAR1 of RC's configuration space as inbound BARs. Entire DDR
>> > region is mapped in these BARs so that it is accessible for EP devices
>> > for DMA. So if the fixup is not done during enumeration, whole
>> > outbound memory resource space gets assigned to RC and nothing is left
>> > EP devices.
>>
>> I'm not familiar with the concept of an "inbound BAR"; at least I'm
>> not aware of anything like this in the PCI specs.  I think it might
>> reduce confusion if we avoided calling them "BARs".  They happen to be
>> at the same addresses where real BARs would be, but they certainly
>> don't behave like real BARs.
>
> So what does the lspci look like?
>

[root@mustang ~]# lspci -s 0000:00:00.0 -v
0000:00:00.0 PCI bridge: Applied Micro Circuits Corp. Device e004 (rev
04) (prog-if 00 [Normal decode])
Flags: bus master, fast devsel, latency 0
Memory at <ignored> (64-bit, prefetchable)
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
Memory behind bridge: 80800000-809fffff
Prefetchable memory behind bridge: 0000000080000000-00000000807fffff
Capabilities: [40] Express Root Port (Slot+), MSI 00
Capabilities: [80] Power Management version 3
Capabilities: [100] Advanced Error Reporting
Capabilities: [180] #19
Capabilities: [150] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
Kernel driver in use: pcieport

> If x-gene has an otherwise correct bridge config space and only the
> 0/1 BARs have a non-standard meaning, that I'd agree with Bjorn, hide
> all access to these registers from the kernel (and tell your HW crew
> to read the specs, because it is very clear what those registers are
> supposed to do) .
>

Ok.

> If x-gene doesn't even have a bridge config space, then there are much
> bigger problems, and these corrupt BARs are just the start.
>
> Jason
