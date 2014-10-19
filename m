Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaJSLif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 07:38:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:55847 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaJSLib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 07:38:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,749,1406617200"; 
   d="scan'208";a="591789675"
Message-ID: <5443A1F3.7020500@linux.intel.com>
Date: Sun, 19 Oct 2014 19:35:15 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>, Myron Stowe <mstowe@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Alexander Duyck <alexander.h.duyck@redhat.com>
Subject: Re: [PATCH] pci, add sysfs numa_node write function
References: <1413399924-599-1-git-send-email-prarit@redhat.com>  <CAErSpo6Oy1S1OECirp6=tz+pQWUtkFE6p1LTzNaYtzxoX73FWw@mail.gmail.com>  <543ECF6F.2030705@redhat.com>  <CAErSpo76g-EPsUsMjhBpnnbKD3QufHz1xkvYaqXd8hYtgQ5u1g@mail.gmail.com>  <543FBAEF.7030905@redhat.com> <1413488723.2539.72.camel@zim.stowe> <544104BC.4000104@redhat.com>
In-Reply-To: <544104BC.4000104@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/10/17 19:59, Prarit Bhargava wrote:
> 
> 
> On 10/16/2014 03:45 PM, Myron Stowe wrote:
>> On Thu, 2014-10-16 at 08:32 -0400, Prarit Bhargava wrote:
>>>
>>> On 10/15/2014 05:20 PM, Bjorn Helgaas wrote:
>>>> On Wed, Oct 15, 2014 at 1:47 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>>>> On 10/15/2014 03:23 PM, Bjorn Helgaas wrote:
>>>>>> Hi Prarit,
>>>>>>
>>>>>> On Wed, Oct 15, 2014 at 1:05 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>>>>>> Consider a multi-node, multiple pci root bridge system which can be
>>>>>>> configured into one large node or one node/socket.  When configuring the
>>>>>>> system the numa_node value for each PCI root bridge is always set
>>>>>>> incorrectly to -1, or NUMA_NO_NODE, rather than to the node value of each
>>>>>>> socket.  Each PCI device inherits the numa value directly from it's parent
>>>>>>> device, so that the NUMA_NO_NODE value is passed through the entire PCI
>>>>>>> tree.
>>>>>>>
>>>>>>> Some new drivers, such as the Intel QAT driver, drivers/crypto/qat,
>>>>>>> require that a specific node be assigned to the device in order to
>>>>>>> achieve maximum performance for the device, and will fail to load if the
>>>>>>> device has NUMA_NO_NODE.
>>>>>>
>>>>>> It seems ... unfriendly for a driver to fail to load just because it
>>>>>> can't guarantee maximum performance.  Out of curiosity, where does
>>>>>> this actually happen?  I had a quick look for NUMA_NO_NODE and
>>>>>> module_init() functions in drivers/crypto/qat, and I didn't see the
>>>>>> spot.
>>>>>
>>>>> The whole point of the Intel QAT driver is to guarantee max performance.  If
>>>>> that is not possible the driver should not load (according to the thread
>>>>> mentioned below)
>>>>>
>>>>>>
>>>>>>> The driver would load if the numa_node value
>>>>>>> was equal to or greater than -1 and quickly hacking the driver results in
>>>>>>> a functional QAT driver.
>>>>>>>
>>>>>>> Using lspci and numactl it is easy to determine what the numa value should
>>>>>>> be.  The problem is that there is no way to set it.  This patch adds a
>>>>>>> store function for the PCI device's numa_node value.
>>>>>>
>>>>>> I'm not familiar with numactl.  It sounds like it can show you the
>>>>>> NUMA topology?  Where does that information come from?
> 
> numactl simply determines the number of nodes on the system by traversing
> 
> /sys/devices/system/node
> 
> For example, the output of 'numactl --hardware'
> 
> available: 2 nodes (0-1)
> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 24 25 26 27 28 29 30 31 32 33 34 35
> node 0 size: 32075 MB
> node 0 free: 30862 MB
> node 1 cpus: 12 13 14 15 16 17 18 19 20 21 22 23 36 37 38 39 40 41 42 43 44 45 46 47
> node 1 size: 32239 MB
> node 1 free: 31251 MB
> node distances:
> node   0   1
>   0:  10  21
>   1:  21  10
> 
> I then use lpsci to determine what pci root nodes there are, and knowing a
> little bit about the system architecture (are the IOHs shared between sockets,
> are they 1/socket, etc.) I can make an educated guess on what the numa_node
> value should be.
Hi Prarit,
	It may be a little hard for normal users to figure out NUMA node
id from [segment:bus]. [segment:bus] for PCIe host bridge are under
control of BIOS/firmware. For example, one a four socket system, I have
observed one vender putting all four PCIe host brdiges into PCI segment
0, another vender assigning different segment for each PCIe host bridge.
And socket hotplug may also make the scenario more complex.
	Actually I ran into the same issue when trying to optimize
interrupt vector allocation according to NUMA affinity. So it will
be great if we could find an acceptable solution here:)
Regard!
Gerry
> 
> I thought about hardcoding something similar in the kernel ... but there are
> some significant issues (which Myron points out as well).  The code would have
> to be constantly maintained.  That is not something we can do long term.  Every
> new processor & chipset would have to be added to the code to determine exactly
> how the pci root bridge was connected.  Even then, it is entirely possible (as
> in the case with some cpu hotplug systems) that IOH-less sockets were populated
> [1] which would severely hamper any assumptions in a calculation.
> 
> That also doesn't take into account systems where the manufacturer *wants*
> NUMA_NO_NODE, and doesn't want per-node allocations.
> 
> Alexander has suggested that modifying my original patch to do (sorry for the
> cut-and-paste)
> 
> static ssize_t numa_node_store(struct device *dev,
>                                struct device_attribute *attr,
>                                const char *buf, size_t count)
> {
>         int node, ret;
> 
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
> 
>         ret = kstrtoint(buf, 0, &node);
>         if (ret)
>                 return ret;
> 
>         if (!node_online(node))
>                 return -EINVAL;
> 
>         WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
>                    FW_BUG "ACPI _PXM should have set this device's root bridge
> numa_node to %d but set it to %d.  Please contact your hardware vendor for
> updates.",
>                    node, dev->numa_node);
> 
>         dev->numa_node = node;
> 
>         return count;
> }
> 
> *might* be amenable to everyone.  I think it nicely handles Bjorn's concern
> about being loud when overriding the _PXM entries ...
> 
> P.
> 
> [1] These sockets really aren't IOH-less.  The IOH has been disabled in BIOS.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
