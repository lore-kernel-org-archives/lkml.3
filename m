Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab3FRXDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 19:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482Ab3FRXD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 19:03:29 -0400
Message-ID: <51C0E73F.1060708@redhat.com>
Date: Tue, 18 Jun 2013 19:03:27 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] pci: Enable overrides for missing ACS capabilities
References: <20130530183955.14686.89444.stgit@bling.home>  <20130618172819.GA16134@google.com>  <1371579648.22681.209.camel@ul30vt.home>  <CAErSpo5mRKhBYun_i=iFppmQ5+7ODCY7q=sehHjBXWqPRH=ZZw@mail.gmail.com> <1371594159.22659.34.camel@ul30vt.home>
In-Reply-To: <1371594159.22659.34.camel@ul30vt.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 06:22 PM, Alex Williamson wrote:
> On Tue, 2013-06-18 at 15:31 -0600, Bjorn Helgaas wrote:
>> On Tue, Jun 18, 2013 at 12:20 PM, Alex Williamson
>> <alex.williamson@redhat.com>  wrote:
>>> On Tue, 2013-06-18 at 11:28 -0600, Bjorn Helgaas wrote:
>>>> On Thu, May 30, 2013 at 12:40:19PM -0600, Alex Williamson wrote:
>>>>> PCIe ACS (Access Control Services) is the PCIe 2.0+ feature that
>>>>> allows us to control whether transactions are allowed to be redirected
>>>>> in various subnodes of a PCIe topology.  For instance, if two
>>>>> endpoints are below a root port or downsteam switch port, the
>>>>> downstream port may optionally redirect transactions between the
>>>>> devices, bypassing upstream devices.  The same can happen internally
>>>>> on multifunction devices.  The transaction may never be visible to the
>>>>> upstream devices.
>>>>>
>>>>> One upstream device that we particularly care about is the IOMMU.  If
>>>>> a redirection occurs in the topology below the IOMMU, then the IOMMU
>>>>> cannot provide isolation between devices.  This is why the PCIe spec
>>>>> encourages topologies to include ACS support.  Without it, we have to
>>>>> assume peer-to-peer DMA within a hierarchy can bypass IOMMU isolation.
>>>>>
>>>>> Unfortunately, far too many topologies do not support ACS to make this
>>>>> a steadfast requirement.  Even the latest chipsets from Intel are only
>>>>> sporadically supporting ACS.  We have trouble getting interconnect
>>>>> vendors to include the PCIe spec required PCIe capability, let alone
>>>>> suggested features.
>>>>>
>>>>> Therefore, we need to add some flexibility.  The pcie_acs_override=
>>>>> boot option lets users opt-in specific devices or sets of devices to
>>>>> assume ACS support.
>>>>
>>>> "ACS support" means the device provides an ACS capability and we
>>>> can change bits in the ACS Control Register to control how things
>>>> work.
>>>>
>>>> You are really adding a way to "assume this device always routes
>>>> peer-to-peer DMA upstream," which ultimately translates into "assume
>>>> this device can be isolated from others via the IOMMU."  I think.
>>>
>>> We've heard from one vendor that they support ACS with a NULL capability
>>> structure, ie. the ACS PCIe capability exists, but reports no ACS
>>> capabilities and allows no control.  This takes advantage of the "if
>>> supported" style wording of the spec to imply that peer-to-peer is not
>>> supported because the capability is not available.  This supported but
>>> not controllable version is what we're trying to enable here.
>>
>> I was wrong to say "we can change bits in the control register."  All
>> the control register bits are actually required to be hardwired to
>> zero when the relevant functionality is not implemented.
>>
>> The example you mention (a device with an ACS capability structure
>> that reports no supported capabilities and allows no control) sounds
>> perfectly legal as a description of a device that doesn't support
>> peer-to-peer, and I hope it doesn't require any user intervention
>> (e.g., this patch) or quirks to make it work.
>
> It requires:
>
> Subject: [PATCH v2 2/2] pci: Differentiate ACS controllable from enabled
>
>> The ACS P2P Request Redirect "must be implemented by Functions that
>> support peer-to-peer traffic with other Functions."  This example
>> device doesn't support peer-to-peer traffic, so why would it implement
>> the ACS R bit?  In fact, it looks like the R bit (and all the other
>> bits) *must* be hardwired to zero in both capability and control
>> registers.
>
> Right, if they don't support peer-to-peer then hardwiring capability and
> control to zero should indicate that and is fixed by the patch
> referenced above.
>
>>>>> The "downstream" option assumes full ACS support
>>>>> on root ports and downstream switch ports.  The "multifunction"
>>>>> option assumes the subset of ACS features available on multifunction
>>>>> endpoints and upstream switch ports are supported.  The "id:nnnn:nnnn"
>>>>> option enables ACS support on devices matching the provided vendor
>>>>> and device IDs, allowing more strategic ACS overrides.  These options
>>>>> may be combined in any order.  A maximum of 16 id specific overrides
>>>>> are available.  It's suggested to use the most limited set of options
>>>>> necessary to avoid completely disabling ACS across the topology.
>>>>
>>>> Probably I'm confused by your use of "assume full ACS support,"
>>>
>>> [on root ports and downstream ports]
>>>
>>>>   but I
>>>> don't understand the bit about "completely disabling ACS."
>>>
>>> [across the topology]
>>>
>>>>    If we use
>>>> more options than necessary, it seems like we'd assume more isolation
>>>> than really exists.  That sounds like pretending ACS is *enabled* in
>>>> more places than it really is.
>>>
>>> Exactly.  I'm just trying to suggest that booting with
>>> pcie_acs_override=downstream,multifunction is not generally recommended
>>> because it effectively disables ACS checking across the topology and
>>> assumes isolation where there may be none.  In other words, if
>>> everything is overriding ACS checks, then we've disabled any benefit of
>>> doing the checking in the first place (so I really mean disable
>>> checking, not disable ACS).
>>
>> Yep, the missing "checking" is what is confusing.  Also, I think it
>> would be good to make the implication more explicit -- using this
>> option makes the kernel assume isolation where it may not actually
>> exist -- because the users of this option don't know about checking
>> anyway; that's an internal implementation detail.
>
> More explicit in Documentation/kernel-parameters.txt?
>
>>> Instead, the recommendation is to be more
>>> selective, possibly opting for just "downstream" or even better, using
>>> the specific IDs for devices which are known or suspected to not allow
>>> peer-to-peer.
>>>
>>>>> Note to hardware vendors, we have facilities to permanently quirk
>>>>> specific devices which enforce isolation but not provide an ACS
>>>>> capability.  Please contact me to have your devices added and save
>>>>> your customers the hassle of this boot option.
>>>>
>>>> Who do you expect to decide whether to use this option?  I think it
>>>> requires intimate knowledge of how the device works.
>>>>
>>>> I think the benefit of using the option is that it makes assignment of
>>>> devices to guests more flexible, which will make it attractive to users.
>>>> But most users have no way of knowing whether it's actually *safe* to
>>>> use this.  So I worry that you're adding an easy way to pretend isolation
>>>> exists when there's no good way of being confident that it actually does.
>>>>
>>>> I see the warning you added for this case; I just don't feel good about
>>>> it.  Maybe the idea is that, e.g., Red Hat will research certain devices
>>>> and recommend the option for those cases, and sign up to support that
>>>> config.  I assume you would not be willing to support its use unless
>>>> Red Hat specifically recommended it.
>>>
>>> That pretty much sums it up.  We're working with vendors to try to
>>> figure out which devices do not support ACS but don't allow
>>> peer-to-peer, but it's difficult to get decisive statements to that
>>> affect.  Legacy KVM device assignment relied on libvirt to do this ACS
>>> checking and it does a poor job of it, allowing far more devices to be
>>> assigned with ACS enforced than it really should.  It's also trivial to
>>> disable libvirt's enforcement of ACS and people do it every day w/o
>>> really thinking of the implications.  With VFIO-based device assignment
>>> we move to a model where the kernel is enforcing device isolation rather
>>> than it being at the whim of a userspace service.  Now we have not only
>>> a more complete ACS test, but no way to make it more lenient.  Devices
>>> that were previously allowed, no longer are and there's no way around it
>>> without this patch.  However, this patch gives us more control than the
>>> global disable switch in libvirt.  We can still be selective and fine
>>> tune the shape of the groups, while hopefully adhering to the isolation
>>> exposed by the hardware elsewhere.
>>>
>>> I agree that it's difficult to determine whether it's safe to override,
>>> but I don't see a way around it.  If it was obvious how to maintain
>>> isolation, we'd do it automatically.  We need better ACS support from
>>> vendors.  In the mean time, this allows people to complain to their
>>> hardware vendors and opt-in to using the device anyway.  The warning is
>>> there because if I'm debugging odd problems, I want to know that
>>> isolation may be compromised, as the warning indicates.  Thanks,
>>
>> I wonder if we should taint the kernel if this option is used (but not
>> for specific devices added to pci_dev_acs_enabled[]).  It would also
>> be nice if pci_dev_specific_acs_enabled() gave some indication in
>> dmesg for the specific devices you're hoping to add to
>> pci_dev_acs_enabled[].  It's not an enumeration-time quirk right now,
>> so I'm not sure how we'd limit it to one message per device.
>
> Right, setup vs use and getting single prints is a lot of extra code.
> Tainting is troublesome for support, Don had some objections when I
> suggested the same to him.
>
For RH GSS (Global Support Services), a 'taint' in the kernel printk means
RH doesn't support that system.  The 'non-support' due to 'taint' being printed
out in this case may be incorrect -- RH may support that use, at least until
a more sufficient patched kernel is provided.
Thus my dissension that 'taint' be output.  WARN is ok. 'driver beware',
'unleashed dog afoot'.... sure...

>> I assume that if RH knows about certain devices that are safe in this
>> respect, you'd just add them to pci_dev_acs_enabled[] up front, and
>> the command-line option is really just a workaround until you can spin
>> a new kernel that has the table updated?
>
> Yep, needing to know about this option is not user friendly.  We want
> things to "just work" whenever possible.  There are going to be cases
> where there are obscure devices, even mainstream devices, that need
> this.  Whether it's a temporary or long lived solution depends on what
> kind of answers we can get from vendors.
>
>> It might even make sense to simplify this option so it just assumes
>> *all* devices can be isolated, and get rid of the
>> "downstream/multifunction/vendor&  device ID" stuff.  That would be
>> much easier to explain, and it would make it more obvious that we're
>> really doing something pretty scary here.
>
> Seems like that makes it harder to isolate specific devices for
> promotion to pci_dev_acs_enabled[] and more likely that the user will
> turn the whole thing off for a single device and forget about isolation
> of other devices.  It's a time bomb that legacy KVM assignment and
> libvirt make this so easy to work around today, I'd like to be more
> selective for vfio in the future.
>
>> Bjorn (there is one doc comment below)
>>
>>> Alex
>>>
>>>>> Signed-off-by: Alex Williamson<alex.williamson@redhat.com>
>>>>> ---
>>>>>   Documentation/kernel-parameters.txt |   10 +++
>>>>>   drivers/pci/quirks.c                |  102 +++++++++++++++++++++++++++++++++++
>>>>>   2 files changed, 112 insertions(+)
>>>>>
>>>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>>>> index 47bb23c..a60e6ad 100644
>>>>> --- a/Documentation/kernel-parameters.txt
>>>>> +++ b/Documentation/kernel-parameters.txt
>>>>> @@ -2349,6 +2349,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>>>>              nomsi   Do not use MSI for native PCIe PME signaling (this makes
>>>>>                      all PCIe root ports use INTx for all services).
>>>>>
>>>>> +   pcie_acs_override =
>>>>> +                   [PCIE] Override missing PCIe ACS support for:
>>>>> +           downstream
>>>>> +                   All downstream ports - full ACS capabilties
>>>>> +           multifunction
>>>>> +                   All multifunction devices - multifunction ACS subset
>>>>> +           id:nnnn:nnnn
>>>>> +                   Specfic device - full ACS capabilities
>>>>> +                   Specified as vid:did (vendor/device ID) in hex
>>
>> This should say something about "device isolation support," I think.
>> It's too big a leap from "missing ACS support" to expect users to make
>> it.
>
> Ok.  Thanks,
>
> Alex
>
>>>>> +
>>>>>      pcmv=           [HW,PCMCIA] BadgePAD 4
>>>>>
>>>>>      pd.             [PARIDE]
>>>>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>>>>> index 0369fb6..c7609f6 100644
>>>>> --- a/drivers/pci/quirks.c
>>>>> +++ b/drivers/pci/quirks.c
>>>>> @@ -3292,11 +3292,113 @@ struct pci_dev *pci_get_dma_source(struct pci_dev *dev)
>>>>>      return pci_dev_get(dev);
>>>>>   }
>>>>>
>>>>> +static bool acs_on_downstream;
>>>>> +static bool acs_on_multifunction;
>>>>> +
>>>>> +#define NUM_ACS_IDS 16
>>>>> +struct acs_on_id {
>>>>> +   unsigned short vendor;
>>>>> +   unsigned short device;
>>>>> +};
>>>>> +static struct acs_on_id acs_on_ids[NUM_ACS_IDS];
>>>>> +static u8 max_acs_id;
>>>>> +
>>>>> +static __init int pcie_acs_override_setup(char *p)
>>>>> +{
>>>>> +   if (!p)
>>>>> +           return -EINVAL;
>>>>> +
>>>>> +   while (*p) {
>>>>> +           if (!strncmp(p, "downstream", 10))
>>>>> +                   acs_on_downstream = true;
>>>>> +           if (!strncmp(p, "multifunction", 13))
>>>>> +                   acs_on_multifunction = true;
>>>>> +           if (!strncmp(p, "id:", 3)) {
>>>>> +                   char opt[5];
>>>>> +                   int ret;
>>>>> +                   long val;
>>>>> +
>>>>> +                   if (max_acs_id>= NUM_ACS_IDS - 1) {
>>>>> +                           pr_warn("Out of PCIe ACS override slots (%d)\n",
>>>>> +                                   NUM_ACS_IDS);
>>>>> +                           goto next;
>>>>> +                   }
>>>>> +
>>>>> +                   p += 3;
>>>>> +                   snprintf(opt, 5, "%s", p);
>>>>> +                   ret = kstrtol(opt, 16,&val);
>>>>> +                   if (ret) {
>>>>> +                           pr_warn("PCIe ACS ID parse error %d\n", ret);
>>>>> +                           goto next;
>>>>> +                   }
>>>>> +                   acs_on_ids[max_acs_id].vendor = val;
>>>>> +
>>>>> +                   p += strcspn(p, ":");
>>>>> +                   if (*p != ':') {
>>>>> +                           pr_warn("PCIe ACS invalid ID\n");
>>>>> +                           goto next;
>>>>> +                   }
>>>>> +
>>>>> +                   p++;
>>>>> +                   snprintf(opt, 5, "%s", p);
>>>>> +                   ret = kstrtol(opt, 16,&val);
>>>>> +                   if (ret) {
>>>>> +                           pr_warn("PCIe ACS ID parse error %d\n", ret);
>>>>> +                           goto next;
>>>>> +                   }
>>>>> +                   acs_on_ids[max_acs_id].device = val;
>>>>> +                   max_acs_id++;
>>>>> +           }
>>>>> +next:
>>>>> +           p += strcspn(p, ",");
>>>>> +           if (*p == ',')
>>>>> +                   p++;
>>>>> +   }
>>>>> +
>>>>> +   if (acs_on_downstream || acs_on_multifunction || max_acs_id)
>>>>> +           pr_warn("Warning: PCIe ACS overrides enabled; This may allow non-IOMMU protected peer-to-peer DMA\n");
>>>>> +
>>>>> +   return 0;
>>>>> +}
>>>>> +early_param("pcie_acs_override", pcie_acs_override_setup);
>>>>> +
>>>>> +static int pcie_acs_overrides(struct pci_dev *dev, u16 acs_flags)
>>>>> +{
>>>>> +   int i;
>>>>> +
>>>>> +   /* Never override ACS for legacy devices or devices with ACS caps */
>>>>> +   if (!pci_is_pcie(dev) ||
>>>>> +       pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ACS))
>>>>> +           return -ENOTTY;
>>>>> +
>>>>> +   for (i = 0; i<  max_acs_id; i++)
>>>>> +           if (acs_on_ids[i].vendor == dev->vendor&&
>>>>> +               acs_on_ids[i].device == dev->device)
>>>>> +                   return 1;
>>>>> +
>>>>> +   switch (pci_pcie_type(dev)) {
>>>>> +   case PCI_EXP_TYPE_DOWNSTREAM:
>>>>> +   case PCI_EXP_TYPE_ROOT_PORT:
>>>>> +           if (acs_on_downstream)
>>>>> +                   return 1;
>>>>> +           break;
>>>>> +   case PCI_EXP_TYPE_ENDPOINT:
>>>>> +   case PCI_EXP_TYPE_UPSTREAM:
>>>>> +   case PCI_EXP_TYPE_LEG_END:
>>>>> +   case PCI_EXP_TYPE_RC_END:
>>>>> +           if (acs_on_multifunction&&  dev->multifunction)
>>>>> +                   return 1;
>>>>> +   }
>>>>> +
>>>>> +   return -ENOTTY;
>>>>> +}
>>>>> +
>>>>>   static const struct pci_dev_acs_enabled {
>>>>>      u16 vendor;
>>>>>      u16 device;
>>>>>      int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
>>>>>   } pci_dev_acs_enabled[] = {
>>>>> +   { PCI_ANY_ID, PCI_ANY_ID, pcie_acs_overrides },
>>>>>      { 0 }
>>>>>   };
>>>>>
>>>>>
>>>
>>>
>>>
>
>
>

