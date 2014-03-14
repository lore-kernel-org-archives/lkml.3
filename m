Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaCNPrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:47:08 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:49072
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389AbaCNPrE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:47:04 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z569dhzbb2dI98dI9371Ic89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz8275bh1de097h186068hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Fri, 14 Mar 2014 08:46:49 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <monstr@monstr.eu>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: Zynq macb
References: <c6344e9b-fa32-4313-8950-59030c4bffb8@AM1EHSMHS003.ehs.local>
 <73734ba5-00d3-445d-8c6f-a1a868cdd537@CH1EHSMHS024.ehs.local>
 <53229584.7000100@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <53229584.7000100@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d1a10044-b85c-4664-8fc3-2fb3c7e1a274@CO9EHSMHS026.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-14 at 06:37AM +0100, Michal Simek wrote:
> On 03/13/2014 11:33 PM, Sören Brinkmann wrote:
> > On Thu, 2014-03-13 at 03:16PM -0700, Sören Brinkmann wrote:
> >> Hi Nicolas,
> >>
> >> I did some testing on the current linux-next tree and ran iperf on Zynq.
> >> It seems that network and even the whole system can collapse when doing
> >> that.
> >> I don't really know what's going on, but once I saw the message:
> >> 	"inconsistent Rx descriptor chain"
> >> printed twice (system frozen afterwards).
> >>
> >> I don't know what exactly is going wrong, but suspect something around
> >> memory/DMA. I have no clue whether it makes any sense or not, but I
> >> tried using the macb_* functions instead of the gem_* ones (see diff below).
> >> That seems to result in a stable system and working Ethernet.
> > 
> > That was a little too early. After roughly 25 minutest the system runs
> > into a deadlock:
> >   BUG: spinlock lockup suspected on CPU#1, iperf/774
> >    lock: 0xeda0366c, .magic: dead4ead, .owner: swapper/0/0, .owner_cpu: 0
> >   CPU: 1 PID: 774 Comm: iperf Tainted: G        W    3.14.0-rc6-next-20140312-xilinx-dirty #41
> >   [<c00153c0>] (unwind_backtrace) from [<c0011e70>] (show_stack+0x10/0x14)
> >   [<c0011e70>] (show_stack) from [<c03d6b50>] (dump_stack+0x80/0xcc)
> >   [<c03d6b50>] (dump_stack) from [<c00670ac>] (do_raw_spin_lock+0xd4/0x190)
> >   [<c00670ac>] (do_raw_spin_lock) from [<c03dc79c>] (_raw_spin_lock_irqsave+0x58/0x64)
> >   [<c03dc79c>] (_raw_spin_lock_irqsave) from [<c02b0810>] (macb_start_xmit+0x24/0x2d0)
> >   [<c02b0810>] (macb_start_xmit) from [<c0321b10>] (dev_hard_start_xmit+0x334/0x470)
> >   [<c0321b10>] (dev_hard_start_xmit) from [<c0339aa8>] (sch_direct_xmit+0x78/0x2f8)
> >   [<c0339aa8>] (sch_direct_xmit) from [<c0321f60>] (__dev_queue_xmit+0x314/0x704)
> >   [<c0321f60>] (__dev_queue_xmit) from [<c034cb3c>] (ip_finish_output+0x6c4/0x894)
> >   [<c034cb3c>] (ip_finish_output) from [<c034cf24>] (ip_local_out+0x74/0x90)
> >   [<c034cf24>] (ip_local_out) from [<c034d340>] (ip_queue_xmit+0x400/0x5c4)
> >   [<c034d340>] (ip_queue_xmit) from [<c03634b8>] (tcp_transmit_skb+0xa18/0xab0)
> >   [<c03634b8>] (tcp_transmit_skb) from [<c035856c>] (tcp_recvmsg+0x92c/0xae4)
> >   [<c035856c>] (tcp_recvmsg) from [<c03806f0>] (inet_recvmsg+0x1c0/0x1fc)
> >   [<c03806f0>] (inet_recvmsg) from [<c030769c>] (sock_recvmsg+0x7c/0x98)
> >   [<c030769c>] (sock_recvmsg) from [<c0309988>] (SyS_recvfrom+0x9c/0x108)
> >   [<c0309988>] (SyS_recvfrom) from [<c0309a08>] (sys_recv+0x14/0x18)
> >   [<c0309a08>] (sys_recv) from [<c000ea60>] (ret_fast_syscall+0x0/0x48)
> 
> Do you have this change in your tree?
> https://github.com/Xilinx/linux-xlnx/commit/1a85939af40acca2bf963407b497cc31c303ff3e
> 
> I don't think we have sent this to mainline yet.

If it's not in next, it wasn't in my kernel.

	Sören


