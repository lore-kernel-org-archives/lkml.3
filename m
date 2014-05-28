Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaE1Qjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:39:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:26660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093AbaE1Qju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:39:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,929,1392192000"; 
   d="scan'208";a="547879394"
Message-ID: <53861154.4080402@intel.com>
Date: Wed, 28 May 2014 09:39:48 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH] pci: Save and restore VFs as a part of a reset
References: <20140505212346.18767.34117.stgit@ahduyck-cp2.jf.intel.com>	 <20140527222256.GC11907@google.com> <5385255D.5060204@intel.com>	 <CAErSpo5QU1LsKVqyGbT07mhF-t5L1y3NxD4JhJ6N3AM0XT0c2A@mail.gmail.com> <1401250378.3289.774.camel@ul30vt.home>
In-Reply-To: <1401250378.3289.774.camel@ul30vt.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 09:12 PM, Alex Williamson wrote:
> On Tue, 2014-05-27 at 19:19 -0600, Bjorn Helgaas wrote:
>> [+cc Alex, Don]
>>
>> On Tue, May 27, 2014 at 5:53 PM, Alexander Duyck
>> <alexander.h.duyck@intel.com> wrote:
>>> On 05/27/2014 03:22 PM, Bjorn Helgaas wrote:
>>>> On Mon, May 05, 2014 at 02:25:17PM -0700, Alexander Duyck wrote:
>>>>> This fixes an issue I found in which triggering a reset via the PCI sysfs
>>>>> reset while SR-IOV was enabled would leave the VFs in a state in which the
>>>>> BME and MSI-X enable bits were all cleared.
>>>>>
>>>>> To correct that I have added code so that the VF state is saved and restored
>>>>> as a part of the PF save and restore state functions.  By doing this the VF
>>>>> state is restored as well as the IOV state allowing the VFs to resume function
>>>>> following a reset.
>>>>>
>>>>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>>>>> ---
>>>>>  drivers/pci/iov.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
>>>>>  drivers/pci/pci.c |    2 ++
>>>>>  drivers/pci/pci.h |    5 +++++
>>>>>  3 files changed, 53 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>>>>> index de7a747..645ed71 100644
>>>>> --- a/drivers/pci/iov.c
>>>>> +++ b/drivers/pci/iov.c
>>>>> @@ -521,13 +521,57 @@ resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
>>>>>  }
>>>>>
>>>>>  /**
>>>>> + * pci_save_iov_state - Save the state of the VF configurations
>>>>> + * @dev: the PCI device
>>>>> + */
>>>>> +int pci_save_iov_state(struct pci_dev *dev)
>>>>> +{
>>>>> +    struct pci_dev *vfdev = NULL;
>>>>> +    unsigned short dev_id;
>>>>> +
>>>>> +    /* only search if we are a PF */
>>>>> +    if (!dev->is_physfn)
>>>>> +            return 0;
>>>>> +
>>>>> +    /* retrieve VF device ID */
>>>>> +    pci_read_config_word(dev, dev->sriov->pos + PCI_SRIOV_VF_DID, &dev_id);
>> ...
>>
>>>>> +    /* loop through all the VFs and save their state information */
>>>>> +    while ((vfdev = pci_get_device(dev->vendor, dev_id, vfdev))) {
>>>>> +            if (vfdev->is_virtfn && (vfdev->physfn == dev)) {
>>>>> +                    int err = pci_save_state(vfdev);
>>>>
>>>> It makes me uneasy to operate on another device (we're resetting A, and
>>>> here we save state for B).  I know B is dependent on A, since B is a VF
>>>> related to PF A, but what synchronization is there to serialize this
>>>> against any other save/restore operations that may be in progress by B's
>>>> driver or by a sysfs operation on B?
>>>
>>> I don't believe there is any synchronization mechanism in place
>>> currently.  I can look into that as well.  Odds are we probably need to
>>> have the VFs check the parent lock before they take any independent action.
>>
>> It's just the whole question of how we manage the single "saved-state"
>> area.  Right now, I think almost all use of it is under control of the
>> driver that owns the device, in suspend/resume methods.  The
>> exceptions are the PM suspend/freeze/etc. routines in
>> pci/pci-driver.c, which I assume prevent the driver from running and
>> are therefore safe, and the reset path.  I don't know how the
> 
> Makes me a little uneasy too, what happens to a transaction headed
> to/from the VF while the PF is in a reset state?  I suspect not good
> things.  OTOH, the reset interface and a good bit of pci-sysfs have
> always been at-your-own-risk interfaces and this restores some bits that
> might get us closer to it being survivable.
> 
> We do have a way for drivers to get a long-term save state that they can
> keep on their own, pci_save_state(); pci_store_saved_state() along with
> pci_load_saved_state(); pci_restore_state().  Both KVM and VFIO use this
> for assigning a device so we can attempt to re-load the pre-assigned
> saved state.

So it sounds like this patch would interfere with the functioning of KVM
and VFIO then.  So perhaps I should just not take the direct approach of
saving it myself then.  Perhaps it would be better to just use the
notifier provided below to notify the VFs that an event has occurred.

>>>> Is there anything in the reset path that pays attention to whether
>>>> resetting this PF will clobber VFs?  Do we care whether those VFs are in
>>>> use?  I assume they might be in use by guests?
>>>
>>> The problem I found was that the sysfs reset call doesn't bother to
>>> check with the PF driver at all.  It just clobbers the PF and any VFs on
>>> it without talking to the PF driver.
>>
>> There is Keith Busch's recent patch:
>> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/hotplug&id=3ebe7f9f7e4a4fd1f6461ecd01ff2961317a483a
>> .  I dunno if that's useful to you or not.
>>
>> And I'm not sure there's actually a requirement to *have* a PF driver.
>>  Obviously there has to be a way to enable the VFs, but once they're
>> enabled, it might be possible to keep using them via VF drivers even
>> without a PF driver in the picture.
>>
>> Maybe resetting the PF should just fail if there's an active VF.  If
>> you need to reset the PF, you'd have to unbind the VFs first.
> 
> The use case is certainly questionable, personally I'm not going to
> expect VFs to continue working after the PF is reset.  Driver binding
> gets complicated, especially when KVM doesn't actually bind devices to
> use them.  Hopefully we'll get that out of the tree some day though.  I
> suppose we could -EBUSY the PF reset as long as VFs are enabled.

What I could do is go through and notify the VFs that they are about to
get hit by a reset.  What they do with that information would be up to them.

So if the VFs are loaded on the host I could then at least allow them to
recover by saving and restoring the config space within the driver
themselves.

>>>> But I'm not really keen on pci_get_device() in the first place.  It works
>>>> by iterating over all PCI devices in the system, which seems like a
>>>> sledgehammer approach.  It *is* widely used, but mostly in quirk-type code
>>>> from which I avert my eyes.
>>>>
>>>> Maybe you could do something based on pci_walk_bus()?  If you did that, I
>>>> think the PCI_SRIOV_VF_DID would become superfluous.
>>>>
>>>
>>> I can look into that, I'm not familiar with the interface.  I'll have to
>>> see what the relationship is between the PF and VF in terms of busses as
>>> I don't recall it off of the top of my head.
>>
>> This reminds me about an open problem: VFs can be on "virtual" buses,
>> which aren't really connected in the hierarchy, and I don't think we
>> have a nice way to iterate over them.  So probably pci_get_device() is
>> the best we can do now.
> 
> Yeah, those virtual buses don't have a bus->self, we just have to skip
> to bus->parent->self.  pci_walk_bus() goes in the opposite direction,
> but without an actual device hosting the bus, I don't see how it finds
> it.  Thanks,
> 
> Alex

It seems like we should be able to come up with something like
pci_walk_vbus() though or something similar.  All we would need to do is
search the VFs on the bus of the PF and all child busses to that bus if
I am not mistaken.

Thanks,

Alex

