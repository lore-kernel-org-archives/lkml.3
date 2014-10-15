Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaJOVUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:20:54 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:62036 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaJOVUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:20:52 -0400
MIME-Version: 1.0
In-Reply-To: <543ECF6F.2030705@redhat.com>
References: <1413399924-599-1-git-send-email-prarit@redhat.com>
 <CAErSpo6Oy1S1OECirp6=tz+pQWUtkFE6p1LTzNaYtzxoX73FWw@mail.gmail.com> <543ECF6F.2030705@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Oct 2014 15:20:30 -0600
Message-ID: <CAErSpo76g-EPsUsMjhBpnnbKD3QufHz1xkvYaqXd8hYtgQ5u1g@mail.gmail.com>
Subject: Re: [PATCH] pci, add sysfs numa_node write function
To: Prarit Bhargava <prarit@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myron Stowe <mstowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 1:47 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> On 10/15/2014 03:23 PM, Bjorn Helgaas wrote:
>> Hi Prarit,
>>
>> On Wed, Oct 15, 2014 at 1:05 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>> Consider a multi-node, multiple pci root bridge system which can be
>>> configured into one large node or one node/socket.  When configuring the
>>> system the numa_node value for each PCI root bridge is always set
>>> incorrectly to -1, or NUMA_NO_NODE, rather than to the node value of each
>>> socket.  Each PCI device inherits the numa value directly from it's parent
>>> device, so that the NUMA_NO_NODE value is passed through the entire PCI
>>> tree.
>>>
>>> Some new drivers, such as the Intel QAT driver, drivers/crypto/qat,
>>> require that a specific node be assigned to the device in order to
>>> achieve maximum performance for the device, and will fail to load if the
>>> device has NUMA_NO_NODE.
>>
>> It seems ... unfriendly for a driver to fail to load just because it
>> can't guarantee maximum performance.  Out of curiosity, where does
>> this actually happen?  I had a quick look for NUMA_NO_NODE and
>> module_init() functions in drivers/crypto/qat, and I didn't see the
>> spot.
>
> The whole point of the Intel QAT driver is to guarantee max performance.  If
> that is not possible the driver should not load (according to the thread
> mentioned below)
>
>>
>>> The driver would load if the numa_node value
>>> was equal to or greater than -1 and quickly hacking the driver results in
>>> a functional QAT driver.
>>>
>>> Using lspci and numactl it is easy to determine what the numa value should
>>> be.  The problem is that there is no way to set it.  This patch adds a
>>> store function for the PCI device's numa_node value.
>>
>> I'm not familiar with numactl.  It sounds like it can show you the
>> NUMA topology?  Where does that information come from?
>
> You can map at least what nodes are available (although I suppose you can get
> the same information from dmesg).  You have to do a bit of hunting through the
> PCI tree to determine the root PCI devices, but you can determine which root
> device is connected to which node.

Is numactl reading SRAT?  SLIT?  SMBIOS tables?  Presumably the kernel
has access to whatever information you're getting from numactl and
lspci, and if so, maybe we can do the workaround automatically in the
kernel.

>>> To use this, one can do
>>>
>>> echo 3 > /sys/devices/pci0000:ff/0000:ff:1f.3/numa_node
>>>
>>> to set the numa node for PCI device 0000:ff:1f.3.
>>
>> It definitely seems wrong that we don't set the node number correctly.
>> pci_acpi_scan_root() sets the node number by looking for a _PXM method
>> that applies to the host bridge.  Why does that not work in this case?
>>  Does the BIOS not supply _PXM?
>
> Yeah ... unfortunately the BIOS is broken in this case.  And I know what you're
> thinking ;) -- why not get the BIOS fixed?  I'm through relying on BIOS fixes
> which can take six months to a year to appear in a production version... I've
> been bitten too many times by promises of BIOS fixes that never materialize.

Yep, I understand.  The question is how we implement a workaround so
it doesn't become the accepted way to do things.  Obviously we don't
want people manually grubbing through numactl/lspci output or writing
shell scripts to do things that *should* happen automatically.

> We have systems that only have a support cycle of 3 years, and things like ACPI
> _PXM updates are at the bottom of the list :/.

Something's wrong with this picture.  If vendors are building systems
where node information is important, and the platform doesn't tell the
OS what the node numbers ARE, then in my opinion, the vendor is
essentially asking for low performance and is getting what he asked
for, and his customers should learn that the answer is to shop
elsewhere.

Somewhere in the picture there needs to be a feedback loop that
encourages the vendor to fix the problem.  I don't see that happening
yet.  Having QAT fail because the platform didn't supply the
information required to make it work would be a nice loop.  I don't
want to completely paper over the problem without providing some other
kind of feedback at the same time.

You're probably aware of [1], which was the same problem.  Apparently
it was originally reported to RedHat as [2] (which is private, so I
can't read it).  That led to a workaround hack for some AMD systems
[3, 4].

[1] https://bugzilla.kernel.org/show_bug.cgi?id=72051
[2] https://bugzilla.redhat.com/show_bug.cgi?id=1040440
[3] http://lkml.kernel.org/r/1394053603-3724-1-git-send-email-suravee.suthikulpanit@amd.com
[4] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=94d4bb5b1397

> FWIW, on this particular system I have a filed a bug with the vendor.
>
>>
>> If there's information that numactl uses, maybe the kernel should use that, too?
>>
>> A sysfs interface might be a useful workaround, but obviously it would
>> be far better if we could fix the BIOS and/or kernel so the workaround
>> isn't necessary in the first place.
>
> Yep ... but like I said, I don't think anyone wants to wait a year.  What if we
> never see a fix?
>
> Side issue:  While investigating this I noticed that plain kmalloc() is used in
> the setup code.  Is there a reason we don't use kmalloc_node() in
> pci_alloc_dev(), and other allocation functions?  It seems like we should be to
> optimize system performance.  OTOH ... I haven't done any measurements to see if
> it actually makes a difference :)

Yeah, that probably would make sense.  We do use kmalloc_node() for
some of the host bridge stuff, thanks to 965cd0e4a5e5 ("x86, PCI,
ACPI: Use kmalloc_node() to optimize for performance").  But it
probably would make sense to extend that farther down, too.

>>> Cc: Myron Stowe <mstowe@redhat.com>
>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>> Cc: linux-pci@vger.kernel.org
>>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>>> ---
>>>  drivers/pci/pci-sysfs.c |   23 ++++++++++++++++++++++-
>>>  1 file changed, 22 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>>> index 92b6d9a..c05ed30 100644
>>> --- a/drivers/pci/pci-sysfs.c
>>> +++ b/drivers/pci/pci-sysfs.c
>>> @@ -221,12 +221,33 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
>>>  static DEVICE_ATTR_RW(enabled);
>>>
>>>  #ifdef CONFIG_NUMA
>>> +static ssize_t numa_node_store(struct device *dev,
>>> +                              struct device_attribute *attr,
>>> +                              const char *buf, size_t count)
>>> +{
>>> +       int node, ret;
>>> +
>>> +       if (!capable(CAP_SYS_ADMIN))
>>> +               return -EPERM;
>>> +
>>> +       ret = kstrtoint(buf, 0, &node);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       if (!node_online(node))
>>> +               return -EINVAL;
>>> +
>>> +       dev->numa_node = node;
>>> +
>>> +       return count;
>>> +}
>>> +
>>>  static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
>>>                               char *buf)
>>>  {
>>>         return sprintf(buf, "%d\n", dev->numa_node);
>>>  }
>>> -static DEVICE_ATTR_RO(numa_node);
>>> +static DEVICE_ATTR_RW(numa_node);
>>>  #endif
>>>
>>>  static ssize_t dma_mask_bits_show(struct device *dev,
>>> --
>>> 1.7.9.3
>>>
>>
>>
>
