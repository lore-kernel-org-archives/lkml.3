Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaCQRTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:19:03 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33448 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaCQRS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:18:58 -0400
MIME-Version: 1.0
In-Reply-To: <53226433.3090803@amd.com>
References: <1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com>
 <CAErSpo4MMJh9b0aivwGSbxCMVw24He1+Vo_LH0R0E+fYM5aThg@mail.gmail.com>
 <5317D9B0.1080502@amd.com> <5318160D.8070305@amd.com> <CAErSpo59=52bqgyvqk1x7kcgFmRtdZhT6faYTi3wy7KDtk5=Pw@mail.gmail.com>
 <5318D475.9040701@amd.com> <CAErSpo5Dq3M5ik=dgF5dLsZV87XJeT3nEiYptPBXPCyLZ9xhgA@mail.gmail.com>
 <CAErSpo6ZbKFMgcm4upR7gTnYwZ15UJpxzctOwWMsGyONipq8aw@mail.gmail.com> <53226433.3090803@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Mar 2014 11:18:37 -0600
Message-ID: <CAErSpo6=pr4rouacs29ZpN2EbgPiUFWwSXVE+uUL+-H4CeTdzQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] amd/pci: Add AMD hostbridge supports for newer AMD systems
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael]

On Thu, Mar 13, 2014 at 8:06 PM, Suravee Suthikulpanit
<suravee.suthikulpanit@amd.com> wrote:
> On 3/12/2014 4:13 PM, Bjorn Helgaas wrote:
>>>
>>> I assume the system is fully functional even without these patches,
>>> >right?  The only effect of these changes should be a performance
>>> >improvement.
>
> [Suravee] Yes, the system is fully functional except the numa information
> for PCI ethernet adapters is returning -1.

This would normally be determined by the _PXM of the PCI host bridge
leading to the NIC.  The DSDT you attached to the bug report contains
no _PXM methods at all, so we have no idea what the NUMA information
should be.

>>> >So the choices are:
>>> >
>>> >   1) Change the BIOS to provide _PXM
>>> >   2) Change Linux with your patches
>>> >
>>> >Either way, the customer has to upgrade something.  Choice 1) gets you
>>> >the performance improvement on all Linux and Windows releases, even
>>> >the ones that are already in the field.
>
> [Suravee] I agree with you on both cases and I am working with the BIOS team
> to see if they can look into this and provide fixes for the future.  My only
> concern is the device _PXM information might be specific to each platform
> vendors since they are the one deciding the number of northbridge to be put
> on the systems. Also, it's quite difficult to influence HW/BIOS vendor to
> provide fixes for older platforms unless some important customers are
> complaining to them.

Yes, you're right that _PXM describes platform topology and can't be
implemented by the CPU vendor because it doesn't know the topology of
the system where the CPUs will end up.

>>> >Choice 2) fixes future Linux
>>> >distros and whatever old releases you can convince the distro to
>>> >backport to, and doesn't help Windows at all.  It makes work for all
>>> >the distros and we (i.e., I) have to worry about maintaining this in
>>> >the future.
>
> [Suravee] Actually, this was originally reported by Redhat (please see
> https://bugzilla.redhat.com/show_bug.cgi?id=1040440), and they are waiting
> for the fixes if we decide to fix it in the upstream Linux code base.

This RH bugzilla is private, so I can't see it.

> [Suravee] I am not sure which table is the _PXM method supposed to be apart
> of.

It would be in the DSDT (or an SSDT).  In this case, the PCI host
bridges (the PNP0A08 devices) are described in the DSDT you posted, so
_PXM would normally be there, too.

>> Can you collect an acpidump and complete dmesg log from a system with
>> the problem?
>
> [Suravee] Please see https://bugzilla.kernel.org/show_bug.cgi?id=72051
> I have included SRAT, SLIT and DSDT table as part of the bug. Please let me
> know if you are looking for more information.

One of my objections to your patches is that if we include them, it
will reinforce the perception that the BIOS is doing things correctly,
so there will be less incentive to actually fix the problem by
following the spec.  This has happened several times in the past,
e.g., quirk_amd_nb_node() and amd_bus.c itself.

Another is more of a question: as coded, your patch assumes *all* AMD
host bridge devices will have these registers at those locations
forever.  Are those registers documented as being architected?

Finally, your patch extracts a 3-bit number from a CPU register and
uses it as the node number.  The node numbers used by Linux are
logical and there's no reason they need to be identical to settings in
the CPU registers.  So if we got some node information in the normal
way (from _PXM, SLIT, SRAT, etc.) and some from your patch, there's no
reason to believe they would be compatible.

Bjorn
