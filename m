Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab3G3WaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:30:10 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:37178 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960Ab3G3WaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4mHTwqrW-yq_1BkjD0GyFtVYZRm9+eGfASJ_aJCOagjg@mail.gmail.com>
References: <1360036520-31032-1-git-send-email-wangyijing@huawei.com>
 <51A42137.9090908@huawei.com> <CAErSpo7iyiq6H-BsPNO0Nyc1SF+JteOzBqNQ+d_D=RYE_pdTEA@mail.gmail.com>
 <51F73108.4070905@huawei.com> <CAErSpo4mHTwqrW-yq_1BkjD0GyFtVYZRm9+eGfASJ_aJCOagjg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 30 Jul 2013 16:29:38 -0600
Message-ID: <CAErSpo4xJk7bHQihtdN1UP+6Y17TOrBFhEsO_Zwyvz8iQMEXsw@mail.gmail.com>
Subject: Re: [PATCH] PCI: update device mps when doing pci hotplug
To: Yijing Wang <wangyijing@huawei.com>
Cc: Jon Mason <jdmason@kudzu.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing0307@gmail.com>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Joe Jin <joe.jin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 9:42 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jul 29, 2013 at 9:20 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> On 2013/7/30 7:33, Bjorn Helgaas wrote:
>>> On Mon, May 27, 2013 at 9:15 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>>>> Hi Bjorn and Jon,
>>>>    I'm sorry to disturb you. This patch is sent so long, but nobody seems had comment about it.
>>>> Do you have any comment with this patch?
>>>>
>>>> This patch try to update device mps in following case:
>>>> 1) target device under root port
>>>>    Because root port can split TLP, so target device mps greatr than root port mps is ok.
>>>>    But if root port mps greater than target device mps, it's bad, because target device cannot
>>>>    receive TLP payload size greater than its MPS. So if a target device under a root port, I think
>>>>    we should assign its mps greater than or equal root port mps.
>>>> 2) target device under non root port
>>>>    We assume the target device both is a transmitter and receiver, so the safest way is to assign target
>>>>    device mps equal to its parent device.
>>>
>>> Thanks, I just started reviewing this patch, and your notes above are
>>> exactly the question I was going to ask.  The comments in
>>> pcie_bus_update_set() only tell me what the code does.  I can read the
>>> C code just fine; what we need there is the explanation about *why* we
>>> handle devices below root ports differently than others.  Maybe we can
>>> adapt some of your notes as comments in the code.
>>
>> Hi Bjorn,
>>    Thanks for your review and comments!
>>
>>>
>>> Do you have references to the spec where it talks about this
>>> difference?  I want to make sure we can rely on the fact that a root
>>> port can accept TLPs larger than its MPS.
>>
>> PCIe Spec does not explicitly mention this issue, we can only get the message that
>> root port/ root complex can split the TLP into smaller packets. For instance
>> one 256B packet split into two 128B packet.
>>
>> I confirm this issue in my X86 machine and IA64 machine.
>> 1. I unload NIC driver to make sure the safety during  change the NIC MPS.
>> 2. Use setpci change NIC MPS to the max value it supports.
>> 3. Reload the NIC driver
>> 4. Ping and use scp cpoy large file bwtween machines. Result is ok.

Just as a way to confirm that the MPS change is actually doing
something, I assume you observe a performance difference between
MPS=128 and MPS=512 on the NIC (and the root port MPS=128 in both
cases)?  Or maybe you can confirm with an analyzer that there are
actually 512-byte TLPs on the link?

I assume there are no AER or other errors logged by the root port?
The test you showed was a copy *to* the local machine, so the NIC
would have been doing DMA writes to memory.  I assume it works equally
well doing a copy *from* the local machine to another machine across
the network, where the NIC is doing DMA reads from memory?

> The fact that it works on two pieces of hardware is not enough to be
> confident that it will work on all spec-conforming hardware.  Maybe we
> can deduce this from something in the spec, but I'll have to dig into
> it more tomorrow.  I just hoped that you had a spec reference that
> could save me some time.

The only mention I can find in the spec is sec 1.3.1, where it says "a
Root Complex is generally permitted to split a packet into smaller
packets when routing transactions peer-to-peer between hierarchy
domains ..."

I'm not a hardware guy (I often wish I were :)), but here's how I
interpret that statement.  Let's take the following example:

  00:01.0 Root port bridge to [bus 01] MPS=128
  01:00.1 Endpoint MPS=512

  00:02.0 Root Port bridge to [bus 02] MPS=256
  00:03.0 Root Port bridge to [bus 03] MPS=128
  02:00.0 Endpoint MPS=256
  03:00.0 Endpoint MPS=128

If 02:00.0 (MPS=256) generates a DMA write destined for 03:00.0, it
may transmit a TLP with a data payload of 256 bytes, and 00:02.0
(MPS=256 also) will accept it.  The root complex may route the packet
to 00:03.0 (MPS=128), and here it would need to be split into two
128-byte TLPs before being transmitted by 00:03.0 to 03:00.0
(MPS=128).

Your situation is basically 01:00.1 (MPS=512) doing a DMA write
destined for memory and sending a 512-byte TLP to 00:01.0 (MPS=128).
In this case, the root complex isn't doing any peer-to-peer routing
between hierarchy domains, so I don't think the statement in sec 1.3.1
applies.  So I don't understand why the root port would accept that
TLP.  I would think it would report a malformed TLP error.

Bjorn
