Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaEWCzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 22:55:18 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:54752 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaEWCzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 22:55:15 -0400
MIME-Version: 1.0
In-Reply-To: <537E8ACF.6000103@amd.com>
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521231817.26447.55150.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521233802.GA21575@pd.tnic> <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
 <20140522191746.GL4383@pd.tnic> <CAErSpo7=0-xdnu4DQufu_6eS=6AYhnDRaQvzeiMEC5a=zKU0Jg@mail.gmail.com>
 <537E8ACF.6000103@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 22 May 2014 20:54:54 -0600
Message-ID: <CAErSpo6AMGPFELx+2qJXYaxaLRhk2F2J=wn4=gLgmvYGdLup7A@mail.gmail.com>
Subject: Re: [PATCH V5 3/4] x86/PCI: Stop enabling ECS for AMD CPUs after Fam16h
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Robert Richter <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 5:39 PM, Suravee Suthikulanit
<suravee.suthikulpanit@amd.com> wrote:
> On 5/22/2014 3:20 PM, Bjorn Helgaas wrote:
>> On Thu, May 22, 2014 at 1:17 PM, Borislav Petkov <bp@alien8.de> wrote:
>>> On Thu, May 22, 2014 at 11:56:03AM -0600, Bjorn Helgaas wrote:
>>>>
>>>> I chose Fam16h (0x16) because it looks like that's the newest stuff
>>>> that's in the field. I suspect things would probably work if we
>>>> changed this patch to leave ECS disabled on some Fam16h, Fam15h, etc.,
>>>> but that would change behavior on existing systems, which obviously
>>>> adds some risk. I didn't think there was much benefit that makes the
>>>> risk worthwhile.
>>>>
>>>> My goal is to stop needing CPU-specific changes in the future, not
>>>> necessarily to remove the CPU-specific code we already have.
>>>>
>>>> Does that make sense? I'm not sure whether I understood your real
>>>> question.
>>>
>>> No, you got it right. I'm just wondering why only the newest stuff.
>>> MMCONFIG is supposed to work just fine on everything from Fam10h
>>> onwards, I'm not sure all Fam10h supported it though. Maybe Suravee can
>>> verify that...
>>
>> Even if MMCONFIG does work fine on everything from Fam10h onwards, we
>> still depend on the BIOS to provide a correct MCFG table.  I don't
>> think we can guarantee that changing from ECS to MMCONFIG on a Fam16h
>> box in the field is safe, because we'd then be using a feature we've
>> never used before.
>
> At this point, family11h and later (upto 16h which is our most current
> processor) should already have supports for the MCFG. However, we can't
> guarantee that all the systems currently out there would not use the ECS.
> So, I think it is ok to say we won't support it post 16h as Bjorn suggests.

I think this is more a BIOS question than a hardware question.  I'm
sure all current AMD hardware supports ECAM just fine.  But it's still
up to the BIOS to produce a valid MCFG table, so OEMs could still have
issues, and *that's* what I'm worried about.

I've been poking around for recent dmesg logs that contain "PCI: Using
configuration type 1 for extended access", and there are quite a few.
In most cases there *is* an MCFG table, but apparently we decide not
to use it for some reason (unfortunately we don't print the specific
reason).  One example is at
https://bugzilla.kernel.org/show_bug.cgi?id=68591 .

I'm going to go out on a limb and guess that Windows does not enable
ECS, so it probably uses ECAM.  Therefore, I suspect Linux's parsing
of MCFG is broken in some way, and we probably *could* use ECAM in all
these cases I'm seeing.

It would probably be prudent to figure out why Linux is rejecting
these MCFG tables.  We'll probably see similar tables on Fam17h
systems, and if we continue rejecting them, and we don't turn on ECS,
we won't be able to access extended config space.

I opened a bugzilla for this issue:
https://bugzilla.kernel.org/show_bug.cgi?id=76771

I'm wavering on whether it's a good idea to put this patch in before
understanding the issue.  As much as I'd like to stop fiddling with
ECS, we'd likely end up with a v3.15 where extended config space
doesn't work on some Fam17h systems.

Bjorn
