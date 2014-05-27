Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaE0XxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 19:53:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:9494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbaE0XxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 19:53:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,923,1392192000"; 
   d="scan'208";a="547457323"
Message-ID: <5385255D.5060204@intel.com>
Date: Tue, 27 May 2014 16:53:01 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH] pci: Save and restore VFs as a part of a reset
References: <20140505212346.18767.34117.stgit@ahduyck-cp2.jf.intel.com> <20140527222256.GC11907@google.com>
In-Reply-To: <20140527222256.GC11907@google.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 03:22 PM, Bjorn Helgaas wrote:
> On Mon, May 05, 2014 at 02:25:17PM -0700, Alexander Duyck wrote:
>> This fixes an issue I found in which triggering a reset via the PCI sysfs
>> reset while SR-IOV was enabled would leave the VFs in a state in which the
>> BME and MSI-X enable bits were all cleared.
>>
>> To correct that I have added code so that the VF state is saved and restored
>> as a part of the PF save and restore state functions.  By doing this the VF
>> state is restored as well as the IOV state allowing the VFs to resume function
>> following a reset.
>>
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>> ---
>>  drivers/pci/iov.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++--
>>  drivers/pci/pci.c |    2 ++
>>  drivers/pci/pci.h |    5 +++++
>>  3 files changed, 53 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>> index de7a747..645ed71 100644
>> --- a/drivers/pci/iov.c
>> +++ b/drivers/pci/iov.c
>> @@ -521,13 +521,57 @@ resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno)
>>  }
>>  
>>  /**
>> + * pci_save_iov_state - Save the state of the VF configurations
>> + * @dev: the PCI device
>> + */
>> +int pci_save_iov_state(struct pci_dev *dev)
>> +{
>> +	struct pci_dev *vfdev = NULL;
>> +	unsigned short dev_id;
>> +
>> +	/* only search if we are a PF */
>> +	if (!dev->is_physfn)
>> +		return 0;
>> +
>> +	/* retrieve VF device ID */
>> +	pci_read_config_word(dev, dev->sriov->pos + PCI_SRIOV_VF_DID, &dev_id);
> 
> This is just an optimization to reduce the number of things you get
> back from pci_get_device(), and hence reduce the number of times the
> "vfdev->is_virtfn && (vfdev->physfn == dev)" condition is false, right?
> 

Yes, this is just a mechanism to reduce the number of items we have to test.

>> +	/* loop through all the VFs and save their state information */
>> +	while ((vfdev = pci_get_device(dev->vendor, dev_id, vfdev))) {
>> +		if (vfdev->is_virtfn && (vfdev->physfn == dev)) {
>> +			int err = pci_save_state(vfdev);
> 
> It makes me uneasy to operate on another device (we're resetting A, and
> here we save state for B).  I know B is dependent on A, since B is a VF
> related to PF A, but what synchronization is there to serialize this
> against any other save/restore operations that may be in progress by B's
> driver or by a sysfs operation on B?

I don't believe there is any synchronization mechanism in place
currently.  I can look into that as well.  Odds are we probably need to
have the VFs check the parent lock before they take any independent action.

> 
> Is there anything in the reset path that pays attention to whether
> resetting this PF will clobber VFs?  Do we care whether those VFs are in
> use?  I assume they might be in use by guests?

The problem I found was that the sysfs reset call doesn't bother to
check with the PF driver at all.  It just clobbers the PF and any VFs on
it without talking to the PF driver.

> 
>> +			if (err)
>> +				return err;
>> +		}
>> +	}
> 
> pci_get_device() acquires a reference on each device it returns, so this
> strategy would require a pci_dev_put().

Yes, if I am not mistaken the pci_dev_put is called as a part of
pci_get_dev_by_id which is what pci_get_device ends up being.

> 
> But I'm not really keen on pci_get_device() in the first place.  It works
> by iterating over all PCI devices in the system, which seems like a
> sledgehammer approach.  It *is* widely used, but mostly in quirk-type code
> from which I avert my eyes.
> 
> Maybe you could do something based on pci_walk_bus()?  If you did that, I
> think the PCI_SRIOV_VF_DID would become superfluous.
> 

I can look into that, I'm not familiar with the interface.  I'll have to
see what the relationship is between the PF and VF in terms of busses as
I don't recall it off of the top of my head.

If it is simple enough I might submit a second patch to update the
pci_vfs_assigned since it is using similar logic.

Thanks,

Alex

