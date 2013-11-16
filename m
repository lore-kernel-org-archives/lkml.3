Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3KPCKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 21:10:04 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:63087 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3KPCJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 21:09:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUV2cmFgfX78GYbcbuVvpefnteqv-1_eMujjOBZx7_f+A@mail.gmail.com>
References: <1383749353-3510-1-git-send-email-ethan.kernel@gmail.com>
	<CABawtvOXCOhLDy5nQ2OOQGCqkoi2fwa3tPwEYjwBkRa0ZrHNzQ@mail.gmail.com>
	<CAE9FiQUV2cmFgfX78GYbcbuVvpefnteqv-1_eMujjOBZx7_f+A@mail.gmail.com>
Date: Sat, 16 Nov 2013 10:09:55 +0800
Message-ID: <CABawtvPf3dCnRy2rcXKTbuXD6LzWHx9WE33mGqaUvjotS48NkQ@mail.gmail.com>
Subject: Re: [PATCH] PCI: Init NumVFs register to zero in sriov_init()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Yu Zhao <yu.zhao@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 2:59 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Nov 13, 2013 at 5:57 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
>> On Wed, Nov 6, 2013 at 10:49 PM, ethan.zhao <ethan.kernel@gmail.com> wrote:
>>> Though no specification about NumVFs register initial value after POST, to void the confusion
>>> lspci output as following before VF was enabled, we should clear the NumVFs value left by BIOS
>>> to zero:
>
> Does BIOS need to clear it?

No, don't think BIOS need to clear it, according to the SR-IOV and PCI
specification, BIOS hasn't the responsibility to clear NumVFs register
 or not.  "The initial value of NumVFs is undefined." (SINGLE ROOT I/O
VIRTUALIZATION AND SHARING SPECIFICATION, REV. 1.1 chapter 3.3.7 ).
In fact, Linux doesn't trust the PCI_SRIOV_XX registers initial value
left by BIOS, exactly, it did in iov.c , Linux will re-initialize the
PCI_SRIOV_XX registers' value whatever their original value left by
BIOS.

static int sriov_init(struct pci_dev *dev, int pos)
{
  ... ...
  pci_read_config_word(dev, pos + PCI_SRIOV_CTRL, &ctrl);
  if (ctrl & PCI_SRIOV_CTRL_VFE) {
  pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, 0);
  ssleep(1);
  }

... ...
ctrl = 0;
... ...
found:
pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
... ...
}

If so, why leave  value of NumVFs register un-initialized, till be
exposed to user via lspci etc.

>
>
>>>
>>> $lspci -vvv -s 03:00.0
>>> Ethernet controller: Intel Corporation 82599EB 10-Gigabit SFI/SFP+ Network Connection (rev 01)
>>> ~
>>> Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
>>>                 IOVCap: Migration-, Interrupt Message Number: 000
>>>                 IOVCtl: Enable+ Migration- Interrupt- MSE+ ARIHierarchy+
>>>                 IOVSta: Migration-
>>>                 Initial VFs: 64, Total VFs: 64, Number of VFs: 64, Function Dependency Link: 00
>>>                                                                            ^dazed !
>>> ~
>
> just display problem?

So far, only catch the issue via lspci, "seems' only confuses user,
the VFs are enabled to 64. in fact, they are disabled. but it is not
bug of lspci, binary dump of lspci could prove it.


Thanks,
Ethan
>
>>> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
>>> ---
>>>  drivers/pci/iov.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
>>> index de8ffac..a4941ad 100644
>>> --- a/drivers/pci/iov.c
>>> +++ b/drivers/pci/iov.c
>>> @@ -439,6 +439,8 @@ static int sriov_init(struct pci_dev *dev, int pos)
>>>
>>>  found:
>>>         pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
>>> +       /* VF Enable is cleared, so we could init the NumVFs register to 0 */
>>> +       pci_write_config_word(dev, pos + PCI_SRIOV_NUM_VF, 0);
>>>         pci_read_config_word(dev, pos + PCI_SRIOV_VF_OFFSET, &offset);
>>>         pci_read_config_word(dev, pos + PCI_SRIOV_VF_STRIDE, &stride);
>>>         if (!offset || (total > 1 && !stride))
>
> Thanks
>
> Yinghai
