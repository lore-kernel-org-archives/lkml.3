Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaG2Dhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 23:37:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36755 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaG2Dhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 23:37:45 -0400
Message-ID: <53D71707.6000200@gmail.com>
Date: Mon, 28 Jul 2014 20:37:43 -0700
From: Alexander Duyck <alexander.duyck@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: ethan zhao <ethan.zhao@oracle.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: Re: [PATCH 1/4] PCI: introduce helper functions for device flag operation
References: <1406045944-1587-1-git-send-email-ethan.zhao@oracle.com>   <1406045944-1587-2-git-send-email-ethan.zhao@oracle.com>  <1406581206.1011.133.camel@ul30vt.home> <53D6FE95.6040605@oracle.com> <1406601073.1011.157.camel@ul30vt.home> <53D70A55.20805@oracle.com>
In-Reply-To: <53D70A55.20805@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 07:43 PM, ethan zhao wrote:
> 
> On 2014/7/29 10:31, Alex Williamson wrote:
>> On Tue, 2014-07-29 at 09:53 +0800, ethan zhao wrote:
>>> On 2014/7/29 5:00, Alex Williamson wrote:
>>>> On Wed, 2014-07-23 at 00:19 +0800, Ethan Zhao wrote:
>>>>> This patch introduced three helper functions to hide direct
>>>>> device flag operation.
>>>>>
>>>>> void pci_set_dev_assigned(struct pci_dev *pdev);
>>>>> void pci_set_dev_deassigned(struct pci_dev *pdev);
>>>>> bool pci_is_dev_assigned(struct pci_dev *pdev);
>>>>>
>>>>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>>>>> ---
>>>>>    include/linux/pci.h |   13 +++++++++++++
>>>>>    1 files changed, 13 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>>>>> index aab57b4..5f6f8fa 100644
>>>>> --- a/include/linux/pci.h
>>>>> +++ b/include/linux/pci.h
>>>>> @@ -1129,6 +1129,19 @@ resource_size_t
>>>>> pcibios_window_alignment(struct pci_bus *bus,
>>>>>       int pci_set_vga_state(struct pci_dev *pdev, bool decode,
>>>>>                  unsigned int command_bits, u32 flags);
>>>>> +/* helper functions for operation of device flag */
>>>>> +static inline void pci_set_dev_assigned(struct pci_dev *pdev)
>>>>> +{
>>>>> +    pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
>>>>> +}
>>>>> +static inline void pci_set_dev_deassigned(struct pci_dev *pdev)
>>>>> +{
>>>>> +    pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
>>>>> +}
>>>> I think pci_clear_dev_assigned() would make more sense, we're not
>>>> setting a flag named DEASSIGNED.
>>>     Though it is a flag operation now, may not later, we define it
>>> because we want to hide the internal operation.
>>>     'set' to 'deassigned'  status is enough. So I would like keep it.
>> I disagree, the opposite of a 'set' is a 'clear', or at least an
>> 'unset'.  Using bit-ops-like terminology doesn't lock us into an
>> implementation.  As written, this could just as easily be setting two
>> different variables.
>  So there are two pairs of opposite:
> 
>  set assigned ---> unset assigned
>  set assigned ---> set deassigned
> 
>  Here you prefer the 'verb' set /unset, and I prefer the 'adj.' assigned
> / deassigned.
> 
>  Do they really have different meaning or make confusion ? I don't think
> so.
> 
>  Thanks,
>  Ethan
> 

I agree with Alex W.  If you are going to use the "set" name you should
probably use "clear" for the operation that undoes it.  Using the term
set implies that it is setting a bit and we currently don't have a
deassigned/unassigned bit.

If that doesn't work perhaps you could use something like
get/put_assigned_device or acquire/release_assigned_device.  You just
need to describe what it is you are doing.  You could even consider
adding some tests to return an error if you attempt to assign a device
that is already assigned.

Thanks,

Alex D

