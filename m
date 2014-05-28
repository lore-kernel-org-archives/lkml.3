Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaE1WYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:24:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:5954 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932337AbaE1WYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:24:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,930,1392192000"; 
   d="scan'208";a="548038559"
Message-ID: <538661FD.1040706@intel.com>
Date: Wed, 28 May 2014 15:23:57 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] pci: Save and restore VFs as a part of a reset
References: <20140505212346.18767.34117.stgit@ahduyck-cp2.jf.intel.com> <20140527222256.GC11907@google.com> <5385255D.5060204@intel.com> <CAErSpo5QU1LsKVqyGbT07mhF-t5L1y3NxD4JhJ6N3AM0XT0c2A@mail.gmail.com> <1401250378.3289.774.camel@ul30vt.home> <53861154.4080402@intel.com> <CAErSpo4htYwi3jfoxdj=W9VjVdd5gDjYcxg_i52VVz1sYQHL5A@mail.gmail.com> <5386483C.60506@redhat.com>
In-Reply-To: <5386483C.60506@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 01:34 PM, Don Dutile wrote:
> On 05/28/2014 04:14 PM, Bjorn Helgaas wrote:
>> On Wed, May 28, 2014 at 10:39 AM, Alexander Duyck
>> <alexander.h.duyck@intel.com> wrote:
>>> On 05/27/2014 09:12 PM, Alex Williamson wrote:
>>>> On Tue, 2014-05-27 at 19:19 -0600, Bjorn Helgaas wrote:
>>
>>>>> Maybe resetting the PF should just fail if there's an active VF.  If
>>>>> you need to reset the PF, you'd have to unbind the VFs first.
>>>>
>>>> The use case is certainly questionable, personally I'm not going to
>>>> expect VFs to continue working after the PF is reset.  Driver binding
>>>> gets complicated, especially when KVM doesn't actually bind devices to
>>>> use them.  Hopefully we'll get that out of the tree some day though.  I
>>>> suppose we could -EBUSY the PF reset as long as VFs are enabled.
>>>
>>> What I could do is go through and notify the VFs that they are about to
>>> get hit by a reset.  What they do with that information would be up
>>> to them.
>>>
>>> So if the VFs are loaded on the host I could then at least allow them to
>>> recover by saving and restoring the config space within the driver
>>> themselves.
>>
>> I really like the idea of punting by failing the PF reset if there are
>> any active VFs.  That's a really easy way of making sure we aren't
>> going to blow up any guests.  What problems would it cause if we went
>> this route?
>>
> I think this is the safest route.  PF<->VF interaction isn't architected,
> and resetting the PF with active VFs will probably hang a number of SRIOV
> implementations, requiring a system-level reset to correct the
> compounded problem.

Well it still might be worth while to allow a full PCIe reset in cases
where the hardware has gotten into a bad state.  It seems like it might
be worthwhile to update the newly added reset notifier to allow for the
device to indicate if it ready for a reset or not, with the default
being to return -ENOTTY if the function is not implemented.

> 
>>>>> This reminds me about an open problem: VFs can be on "virtual" buses,
>>>>> which aren't really connected in the hierarchy, and I don't think we
>>>>> have a nice way to iterate over them.  So probably pci_get_device() is
>>>>> the best we can do now.
>>>>
>>>> Yeah, those virtual buses don't have a bus->self, we just have to skip
>>>> to bus->parent->self.  pci_walk_bus() goes in the opposite direction,
>>>> but without an actual device hosting the bus, I don't see how it finds
>>>> it.  Thanks,
>>>
>>> It seems like we should be able to come up with something like
>>> pci_walk_vbus() though or something similar.  All we would need to do is
>>> search the VFs on the bus of the PF and all child busses to that bus if
>>> I am not mistaken.
>>
>> I don't think that's going to work because the virtual buses don't
>> appear as the child bus of anything.
>>
> +1.
> 

Maybe I don't understand something but I have a function that I am
already testing that seems to work for what I need.  Is there any reason
I couldn't use the bus->children list to navigate through the bus list
and get all of the children of a given bus?

I'll submit a couple patches for feedback on those bits.

Thanks,

Alex

