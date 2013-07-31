Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260Ab3GaJUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:20:23 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51686 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3GaJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:20:19 -0400
Message-ID: <51F8D5C9.4020309@huawei.com>
Date: Wed, 31 Jul 2013 17:15:53 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jon Mason <jdmason@kudzu.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing0307@gmail.com>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Joe Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] PCI: update device mps when doing pci hotplug
References: <1360036520-31032-1-git-send-email-wangyijing@huawei.com> <51A42137.9090908@huawei.com> <CAErSpo7iyiq6H-BsPNO0Nyc1SF+JteOzBqNQ+d_D=RYE_pdTEA@mail.gmail.com> <51F73108.4070905@huawei.com> <CAErSpo4mHTwqrW-yq_1BkjD0GyFtVYZRm9+eGfASJ_aJCOagjg@mail.gmail.com> <CAErSpo4xJk7bHQihtdN1UP+6Y17TOrBFhEsO_Zwyvz8iQMEXsw@mail.gmail.com>
In-Reply-To: <CAErSpo4xJk7bHQihtdN1UP+6Y17TOrBFhEsO_Zwyvz8iQMEXsw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> PCIe Spec does not explicitly mention this issue, we can only get the message that
>>> root port/ root complex can split the TLP into smaller packets. For instance
>>> one 256B packet split into two 128B packet.
>>>
>>> I confirm this issue in my X86 machine and IA64 machine.
>>> 1. I unload NIC driver to make sure the safety during  change the NIC MPS.
>>> 2. Use setpci change NIC MPS to the max value it supports.
>>> 3. Reload the NIC driver
>>> 4. Ping and use scp cpoy large file bwtween machines. Result is ok.
> 
> Just as a way to confirm that the MPS change is actually doing
> something, I assume you observe a performance difference between
> MPS=128 and MPS=512 on the NIC (and the root port MPS=128 in both
> cases)?  Or maybe you can confirm with an analyzer that there are
> actually 512-byte TLPs on the link?

Hi Bjorn,
   I didn't observe a performance difference between MPS=128 and MPS=512. I use ping $dest_ip -s 65500(large size packet)
to test the different situations.

1. root port MPS = 128, EP MPS = 256.

root port --------Endpoint device
00:01.0           01:00.1

In this case, I use ping in the local machine, and result is ok.
linux:~ # ping 128.5.160.28 -s 65500
PING 128.5.160.28 (128.5.160.28) 65500(65528) bytes of data.
65508 bytes from 128.5.160.28: icmp_seq=1 ttl=64 time=1.43 ms
65508 bytes from 128.5.160.28: icmp_seq=2 ttl=64 time=1.42 ms
65508 bytes from 128.5.160.28: icmp_seq=3 ttl=64 time=1.41 ms
65508 bytes from 128.5.160.28: icmp_seq=4 ttl=64 time=1.37 ms
65508 bytes from 128.5.160.28: icmp_seq=5 ttl=64 time=1.43 ms
..........

 \-[0000:00]-+-00.0  Intel Corporation 5500 I/O Hub to ESI Port
             +-01.0-[01]--+-00.0  Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet
             |            \-00.1  Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet

linux:~ # lspci -vvv -s 01:00.1
01:00.1 Ethernet controller: Broadcom Corporation NetXtreme II BCM5709 Gigabit Ethernet (rev 20)
............[snip].............
	Capabilities: [ac] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <4us, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 256 bytes, MaxReadReq 512 bytes

linux:~ # lspci -vvv -s 00:01.0
00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 22) (prog-if 00 [Normal decode])
...........[snip]..............
	Capabilities: [90] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes


2. root port MPS = 256, EP MPS = 128.
In this case, use "ping $dest_ip -s 65500" to test, but result is fail.

So I guess the packet size during ping is larger than 128, EP device discard these TLPs.

I have no analyzer to catch the TLP packets. So I can not Guarantee this conclusion(EP MPS larger than Root port is 100% safe).

> 
> I assume there are no AER or other errors logged by the root port?
Yes, AER is not support in local machine.

> The test you showed was a copy *to* the local machine, so the NIC
> would have been doing DMA writes to memory.  I assume it works equally
> well doing a copy *from* the local machine to another machine across
> the network, where the NIC is doing DMA reads from memory?

Yes, I tested in both copy direction, and result is ok.

> The only mention I can find in the spec is sec 1.3.1, where it says "a
> Root Complex is generally permitted to split a packet into smaller
> packets when routing transactions peer-to-peer between hierarchy
> domains ..."
> 
> I'm not a hardware guy (I often wish I were :)), but here's how I
> interpret that statement.  Let's take the following example:
> 
>   00:01.0 Root port bridge to [bus 01] MPS=128
>   01:00.1 Endpoint MPS=512
> 
>   00:02.0 Root Port bridge to [bus 02] MPS=256
>   00:03.0 Root Port bridge to [bus 03] MPS=128
>   02:00.0 Endpoint MPS=256
>   03:00.0 Endpoint MPS=128
> 
> If 02:00.0 (MPS=256) generates a DMA write destined for 03:00.0, it
> may transmit a TLP with a data payload of 256 bytes, and 00:02.0
> (MPS=256 also) will accept it.  The root complex may route the packet
> to 00:03.0 (MPS=128), and here it would need to be split into two
> 128-byte TLPs before being transmitted by 00:03.0 to 03:00.0
> (MPS=128).
> 
> Your situation is basically 01:00.1 (MPS=512) doing a DMA write
> destined for memory and sending a 512-byte TLP to 00:01.0 (MPS=128).
> In this case, the root complex isn't doing any peer-to-peer routing
> between hierarchy domains, so I don't think the statement in sec 1.3.1
> applies.  So I don't understand why the root port would accept that
> TLP.  I would think it would report a malformed TLP error.

Hmmm, PCIe Spec does not involve too much about MPS setting. So maybe different platform
has different strategy.

Conservatively, as a improvement for mps setting after hotplug. I think update mps setting equal to its parent
make sense. This is no harm to other devices, we only modify the hotplug device itself mps register.

So if you agree, I will update my patch ,only try to modify hotplug device mps, make them equal to its parent.

Thanks!
Yijing.



-- 
Thanks!
Yijing

