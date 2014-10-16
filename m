Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaJPMcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:32:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaJPMcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:32:50 -0400
Message-ID: <543FBAEF.7030905@redhat.com>
Date: Thu, 16 Oct 2014 08:32:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myron Stowe <mstowe@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] pci, add sysfs numa_node write function
References: <1413399924-599-1-git-send-email-prarit@redhat.com> <CAErSpo6Oy1S1OECirp6=tz+pQWUtkFE6p1LTzNaYtzxoX73FWw@mail.gmail.com> <543ECF6F.2030705@redhat.com> <CAErSpo76g-EPsUsMjhBpnnbKD3QufHz1xkvYaqXd8hYtgQ5u1g@mail.gmail.com>
In-Reply-To: <CAErSpo76g-EPsUsMjhBpnnbKD3QufHz1xkvYaqXd8hYtgQ5u1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/15/2014 05:20 PM, Bjorn Helgaas wrote:
> On Wed, Oct 15, 2014 at 1:47 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>> On 10/15/2014 03:23 PM, Bjorn Helgaas wrote:
>>> Hi Prarit,
>>>
>>> On Wed, Oct 15, 2014 at 1:05 PM, Prarit Bhargava <prarit@redhat.com> wrote:
>>>> Consider a multi-node, multiple pci root bridge system which can be
>>>> configured into one large node or one node/socket.  When configuring the
>>>> system the numa_node value for each PCI root bridge is always set
>>>> incorrectly to -1, or NUMA_NO_NODE, rather than to the node value of each
>>>> socket.  Each PCI device inherits the numa value directly from it's parent
>>>> device, so that the NUMA_NO_NODE value is passed through the entire PCI
>>>> tree.
>>>>
>>>> Some new drivers, such as the Intel QAT driver, drivers/crypto/qat,
>>>> require that a specific node be assigned to the device in order to
>>>> achieve maximum performance for the device, and will fail to load if the
>>>> device has NUMA_NO_NODE.
>>>
>>> It seems ... unfriendly for a driver to fail to load just because it
>>> can't guarantee maximum performance.  Out of curiosity, where does
>>> this actually happen?  I had a quick look for NUMA_NO_NODE and
>>> module_init() functions in drivers/crypto/qat, and I didn't see the
>>> spot.
>>
>> The whole point of the Intel QAT driver is to guarantee max performance.  If
>> that is not possible the driver should not load (according to the thread
>> mentioned below)
>>
>>>
>>>> The driver would load if the numa_node value
>>>> was equal to or greater than -1 and quickly hacking the driver results in
>>>> a functional QAT driver.
>>>>
>>>> Using lspci and numactl it is easy to determine what the numa value should
>>>> be.  The problem is that there is no way to set it.  This patch adds a
>>>> store function for the PCI device's numa_node value.
>>>
>>> I'm not familiar with numactl.  It sounds like it can show you the
>>> NUMA topology?  Where does that information come from?
>>
>> You can map at least what nodes are available (although I suppose you can get
>> the same information from dmesg).  You have to do a bit of hunting through the
>> PCI tree to determine the root PCI devices, but you can determine which root
>> device is connected to which node.
> 
> Is numactl reading SRAT?  SLIT?  SMBIOS tables?  Presumably the kernel
> has access to whatever information you're getting from numactl and
> lspci, and if so, maybe we can do the workaround automatically in the
> kernel.

I'll go figure that out ...

> 
>>>> To use this, one can do
>>>>
>>>> echo 3 > /sys/devices/pci0000:ff/0000:ff:1f.3/numa_node
>>>>
>>>> to set the numa node for PCI device 0000:ff:1f.3.
>>>
>>> It definitely seems wrong that we don't set the node number correctly.
>>> pci_acpi_scan_root() sets the node number by looking for a _PXM method
>>> that applies to the host bridge.  Why does that not work in this case?
>>>  Does the BIOS not supply _PXM?
>>
>> Yeah ... unfortunately the BIOS is broken in this case.  And I know what you're
>> thinking ;) -- why not get the BIOS fixed?  I'm through relying on BIOS fixes
>> which can take six months to a year to appear in a production version... I've
>> been bitten too many times by promises of BIOS fixes that never materialize.
> 
> Yep, I understand.  The question is how we implement a workaround so
> it doesn't become the accepted way to do things.  Obviously we don't
> want people manually grubbing through numactl/lspci output or writing
> shell scripts to do things that *should* happen automatically.
> 
>> We have systems that only have a support cycle of 3 years, and things like ACPI
>> _PXM updates are at the bottom of the list :/.
> 

> 
> Somewhere in the picture there needs to be a feedback loop that
> encourages the vendor to fix the problem.  I don't see that happening
> yet.  Having QAT fail because the platform didn't supply the
> information required to make it work would be a nice loop.  I don't
> want to completely paper over the problem without providing some other
> kind of feedback at the same time.

Okay -- I see what you're after here and I completely agree with it.  But
sometimes I feel like I banging on a silent drum with some of these companies
about this stuff :(  My frustration with these companies is starting to show I
guess...

> 
> You're probably aware of [1], which was the same problem.  Apparently
> it was originally reported to RedHat as [2] (which is private, so I
> can't read it).  That led to a workaround hack for some AMD systems
> [3, 4].

Yeah ... part of me was thinking that maybe I should do something like
the above but I didn't know how you'd feel about expanding that hack.  I'll look
into it.  I'd prefer it to be opt-in with a kernel parameter.

P.
