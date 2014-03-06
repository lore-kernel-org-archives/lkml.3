Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaCFRld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 12:41:33 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60778 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbaCFRlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 12:41:15 -0500
MIME-Version: 1.0
In-Reply-To: <5318160D.8070305@amd.com>
References: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com>
 <CAErSpo4MMJh9b0aivwGSbxCMVw24He1+Vo_LH0R0E+fYM5aThg@mail.gmail.com>
 <5317D9B0.1080502@amd.com> <5318160D.8070305@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Mar 2014 10:40:54 -0700
Message-ID: <CAErSpo59=52bqgyvqk1x7kcgFmRtdZhT6faYTi3wy7KDtk5=Pw@mail.gmail.com>
Subject: Re: [PATCH 0/3] amd/pci: Add AMD hostbridge supports for newer AMD systems
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Yinghai, sorry I didn't think of it before]

On Wed, Mar 5, 2014 at 11:30 PM, Suravee Suthikulpanit
<suravee.suthikulpanit@amd.com> wrote:
> On 3/5/2014 8:13 PM, Suravee Suthikulanit wrote:
>>
>> On 3/5/2014 3:24 PM, Bjorn Helgaas wrote:
>>>
>>> [+cc linux-acpi]
>>>
>>> On Wed, Mar 5, 2014 at 2:06 PM,  <suravee.suthikulpanit@amd.com> wrote:
>>>>
>>>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>>>
>>>> The current code only supports upto AMD hostbridge for family11h.
>>>> This causes PCI numa_node information to be reported incorrectly
>>>> for newer family with multi sockets.
>>>
>>>
>>> Where is the incorrect reporting?  In ACPI tables?  Is this patch a
>>> way to cover up firmware defects in the ACPI description?  Or is this
>>> for machines without ACPI (it seems unlikely that machines with new
>>> AMD processors would not have ACPI)?
>>
>>
>> This is incorrectly reported in the sysfs for each PCI device (e.g.
>> /devices/pci0000:50/0000:50:00.2/numa_node). Without the patch, they
>> return -1.
>>
>> In file arch/x86/pci/acpi.c, in function pci_acpi_scan_root(), it is
>> queries the node information as following:
>>
>> #ifdef CONFIG_ACPI_NUMA
>>      pxm = acpi_get_pxm(device->handle);
>>      if (pxm >= 0)
>>          node = pxm_to_node(pxm);
>>      if (node != -1)
>>          set_mp_bus_to_node(busnum, node);
>>      else
>> #endif
>>          node = get_mp_bus_to_node(busnum);
>>
>> In this case, I see that the acpi_get_pxm() returns -1.  Therefore, it
>> falls back to using the node information in mp_bus_to_node[].  So,
>> without this patch, it would also returning -1.
>>
>> Also, the spec mentioned that the _PXM is optional, so I am not sure if
>> this is a firmware bug.
>
> I am not quite familiar with the ACPI for this part.  However, after taking
> a look at the code (in driver/acpi/pci_root.c: acpi_pci_root_add()), I
> believe it's trying to locate _PXM method in the DSDT table, in which I
> don't see any _PXM methods.

This sure looks like a firmware bug.  True, _PXM is optional, but if
the firmware doesn't provide it, nobody should be surprised that the
OS thinks everything is in the same proximity domain.

I would not endorse extending amd_bus.c for new CPUs.  That just
covers up firmware problems like this, and if you ever run a different
OS on the box, you'll trip over them again.  And I don't think a patch
like this will even be a possibility for Windows.

Bjorn
