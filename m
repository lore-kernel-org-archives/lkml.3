Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab3FNCJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:09:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57574 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3FNCJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:09:37 -0400
Message-ID: <51BA7B3D.1020402@huawei.com>
Date: Fri, 14 Jun 2013 10:09:01 +0800
From: "Jiang Liu (Gerry)" <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUGFIX 0/9] Fix bug 59501 and code improvement for dock driver
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
In-Reply-To: <CAE9FiQX1xVJA3MZc4LndWU7kx0mxC-YPE1R8JD4W2-Gg9zq3Zw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.77.35]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/14 2:42, Yinghai Lu wrote:
> On Thu, Jun 13, 2013 at 9:32 AM, Jiang Liu <jiang.liu@huawei.com> wrote:
>> Alexander E. Patrakov <patrakov@gmail.com> reports two bugs related to
>> dock station support on Sony VAIO VPCZ23A4R. Actually there are at least
>> four bugs related to Sony VAIO VPCZ23A4R dock support.
>> 1) can't correctly detect hotplug slot for dock state
>> 2) resource leak on undocking
>> 3) resource allocation failure for dock devices
>> 4) one bug in intel_snd_hda driver
>>
>> The first patch fixes issue 1, and the second patch fixes issue 2.
>> These two patches, if accepted, should be material for stable branches
>> too.
>> Patch 3-9 are code improvement for ACPI and dock driver.
>>
>> I have found the root cause for issue three, but still working on
>> solutions, and seems can't be solve in short time. So please help
>> to review and test patches for issue 1) and 2) first.
>
> the 3) is about pci resource allocation?
> because pcibios_add_bus is called too early?
>
> If that is case, we should have something like attached patch for it.
>
> With that, we will not need to worry about _OSC set for 3.10 etc.
>
Hi Yinghai,
    Seems not related to pcibios_add_bus(). According to my
investigation, the issue is caused by difference in PCI resource
assignment between boot time and runtime hotplug. On x86 platforms,
it respects PCI resource assignment from BIOS and only reassign
resources for unassigned BARs. But with acpiphp, it ignores BIOS
resource assignment and reassign all resources by OS.
    If we have enough resources, reassigning all PCI resources should
work too, but may fail if we are under resource constraints. On the
other handle, current PCI IOMM align algorithm may waste huge MMIO
address space if we have some PCI devices with huge IOMM BAR.
    On this Sony laptop, BIOS allocates limited IOMM resources for
the dock station and the dock station has a gfx which has a 256MB
IOMM BAR. So current acpiphp driver fails to allocate resources
for most devices on the dock station.
     Currently I'm trying to change acpiphp to respect BIOS resource 
assignment by calling pcibios_survey_resource_bus(), as in pci_root.c.
The other way is to change the IOMM resource allocation algorithm,
but obviously it's much more risky of regressions if changing the
algorithm.
Regards!
Gerry

