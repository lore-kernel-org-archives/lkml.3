Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaCDAja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:39:30 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:36291 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbaCDAj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:39:28 -0500
MIME-Version: 1.0
In-Reply-To: <3049227.1OEyu61877@vostro.rjw.lan>
References: <CAMwGMjwjyZkj3_bKUcx4GXNP764UaUG=d6V1us8GgMKj=HoXVw@mail.gmail.com>
	<3049227.1OEyu61877@vostro.rjw.lan>
Date: Mon, 3 Mar 2014 19:39:26 -0500
X-Google-Sender-Auth: 5E_pKKS9NDaGhksrQeR1R4dunRo
Message-ID: <CAMwGMjzSSDc4W8KUmwzm5yqzgS-aVnAPKyuio2Ox84zN--0nuQ@mail.gmail.com>
Subject: Re: Ethernet controller not starting
From: Jon Ringle <jon@ringle.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        rafael.j.wysocki@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 6:43 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Monday, March 03, 2014 02:41:01 PM Jon Ringle wrote:
>> I'm working on porting an ARM board from linux-3.10 to linux-3.12 (now
>> the latest LTS kernel).
>> I found that Ethernet controller on the board no longer comes up on linux-3.12.
>> I was able to bisect the issue I'm having to the following commit:
>>
>> >   45f0a85c8258741d11bda25c0a5669c06267204a is the first bad commit
>> >   commit 45f0a85c8258741d11bda25c0a5669c06267204a
>> >   Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >   Date:   Mon Jun 3 21:49:52 2013 +0200
>> >
>> >       PM / Runtime: Rework the "runtime idle" helper routine
>> >
>> >       The "runtime idle" helper routine, rpm_idle(), currently ignores
>> >       return values from .runtime_idle() callbacks executed by it.
>> >       However, it turns out that many subsystems use
>> >       pm_generic_runtime_idle() which checks the return value of the
>> >       driver's callback and executes pm_runtime_suspend() for the device
>> >       unless that value is not 0.  If that logic is moved to rpm_idle()
>> >       instead, pm_generic_runtime_idle() can be dropped and its users
>> >       will not need any .runtime_idle() callbacks any more.
>> >
>> >       Moreover, the PCI, SCSI, and SATA subsystems' .runtime_idle()
>> >       routines, pci_pm_runtime_idle(), scsi_runtime_idle(), and
>> >       ata_port_runtime_idle(), respectively, as well as a few drivers'
>> >       ones may be simplified if rpm_idle() calls rpm_suspend() after 0 has
>> >       been returned by the .runtime_idle() callback executed by it.
>> >
>> >       To reduce overall code bloat, make the changes described above.
>> >
>> >       Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> >       Tested-by: Kevin Hilman <khilman@linaro.org>
>> >       Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> >       Acked-by: Kevin Hilman <khilman@linaro.org>
>> >       Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
>> >       Acked-by: Alan Stern <stern@rowland.harvard.edu>
>>
>> Can anyone offer any suggestions on what I should be looking for to
>> fix this on my board?
>
> Any pointers to the driver in question?

drivers/net/ethernet/ti/davinci_emac.c

I also get the following output:

         Starting Network Manager Wait Online...
[   30.946509] davinci_mdio davinci_mdio.0: resetting idled controller
[   30.953220] net net0: attached PHY driver [Generic PHY]
(mii_bus:phy_addr=davinci_mdio-0:00, id=7c0f1)
[   30.962938] IPv6: ADDRCONF(NETDEV_UP): net0: link is not ready
[   31.082087] genirq: Flags mismatch irq 33. 00000000 (net0) vs.
00000000 (net0)
[   31.089425] CPU: 0 PID: 679 Comm: NetworkManager Not tainted
3.12.13-fs1-003-g5ae24fe-dirty+ #1218
[   31.098496] Function entered at [<c000d6dc>] from [<c000baa8>]
[   31.104398] Function entered at [<c000baa8>] from [<c0042d9c>]
[   31.110292] Function entered at [<c0042d9c>] from [<c0042fa4>]
[   31.116180] Function entered at [<c0042fa4>] from [<c0044794>]
[   31.122069] Function entered at [<c0044794>] from [<c02a7954>]
[   31.127958] Function entered at [<c02a7954>] from [<c03289b8>]
[   31.133852] Function entered at [<c03289b8>] from [<c0328bd8>]
[   31.139741] Function entered at [<c0328bd8>] from [<c0328ce4>]
[   31.145630] Function entered at [<c0328ce4>] from [<c03340fc>]
[   31.151523] Function entered at [<c03340fc>] from [<c0335104>]
[   31.157412] Function entered at [<c0335104>] from [<c033547c>]
[   31.163303] Function entered at [<c033547c>] from [<c033e858>]
[   31.169193] Function entered at [<c033e858>] from [<c0333db8>]
[   31.175080] Function entered at [<c0333db8>] from [<c033e238>]
[   31.180969] Function entered at [<c033e238>] from [<c033e6b4>]
[   31.186857] Function entered at [<c033e6b4>] from [<c0314460>]
[   31.192747] Function entered at [<c0314460>] from [<c0315598>]
[   31.198637] Function entered at [<c0315598>] from [<c0316580>]
[   31.204528] Function entered at [<c0316580>] from [<c00093c0>]
[   31.210600] net net0: DaVinci EMAC: devm_request_irq() failed
[FAILED] Failed to start Network Manager Wait Online.

Putting a breakpoint on the genirq message, the backtrace is:

#0  __setup_irq (irq=irq@entry=33, desc=desc@entry=0xc0d24b10
<irq_desc+3960>, new=new@entry=0xc0a6a320) at kernel/irq/manage.c:1177
#1  0xc0042fa4 in request_threaded_irq (irq=irq@entry=33,
handler=handler@entry=0xc02a6bbc <emac_irq>,
thread_fn=thread_fn@entry=0x0 <__vectors_start>, irqflags=0,
irqflags@entry=3234987536, devname=0xc2f87000 \"net0\",
devname@entry=0xc02a7954 <emac_dev_open+284> \"\",
dev_id=dev_id@entry=0xc2f87000) at kernel/irq/manage.c:1438
#2  0xc0044794 in devm_request_threaded_irq (dev=0xc0d1e688
<da8xx_emac_device+16>, irq=irq@entry=33,
handler=handler@entry=0xc02a6bbc <emac_irq>,
thread_fn=thread_fn@entry=0x0 <__vectors_start>,
irqflags=irqflags@entry=0, devname=devname@entry=0xc2f87000 \"net0\",
dev_id=dev_id@entry=0xc2f87000) at kernel/irq/devres.c:60
#3  0xc02a7954 in devm_request_irq (dev_id=0xc2f87000,
devname=0xc2f87000 \"net0\", irqflags=0, handler=0xc02a6bbc
<emac_irq>, irq=33, dev=<optimized out>) at
include/linux/interrupt.h:158
#4  emac_dev_open (ndev=0xc2f87000) at
drivers/net/ethernet/ti/davinci_emac.c:1569
#5  0xc03289b8 in __dev_open (dev=0xc2f87000) at net/core/dev.c:1256
#6  0xc0328bd8 in __dev_change_flags (dev=dev@entry=0xc2f87000,
flags=4099) at net/core/dev.c:5042
#7  0xc0328ce4 in dev_change_flags (dev=dev@entry=0xc2f87000,
flags=<optimized out>) at net/core/dev.c:5103
#8  0xc03340fc in do_setlink (dev=dev@entry=0xc2f87000,
ifm=ifm@entry=0xc2e67ed0, tb=tb@entry=0xc0a5dc64,
ifname=ifname@entry=0xc0a5dc18 \"\", modified=0) at
net/core/rtnetlink.c:1437
#9  0xc0335104 in rtnl_newlink (skb=<optimized out>, nlh=0xc2e67ec0)
at net/core/rtnetlink.c:1822
#10 0xc033547c in rtnetlink_rcv_msg (skb=0xc29aeb60, nlh=<optimized
out>) at net/core/rtnetlink.c:2691
#11 0xc033e858 in netlink_rcv_skb (skb=skb@entry=0xc29aeb60,
cb=cb@entry=0xc03352e0 <rtnetlink_rcv_msg>) at
net/netlink/af_netlink.c:2774
#12 0xc0333db8 in rtnetlink_rcv (skb=0xc29aeb60) at net/core/rtnetlink.c:2697
#13 0xc033e238 in netlink_unicast_kernel (ssk=0xc2af0800,
skb=0xc29aeb60, sk=0xc3857e00) at net/netlink/af_netlink.c:1708
#14 netlink_unicast (ssk=ssk@entry=0xc2af0800,
skb=skb@entry=0xc29aeb60, portid=portid@entry=0, nonblock=<optimized
out>) at net/netlink/af_netlink.c:1734
#15 0xc033e6b4 in netlink_sendmsg (kiocb=<optimized out>,
sock=<optimized out>, msg=0xc0a5df7c, len=32) at
net/netlink/af_netlink.c:2290
#16 0xc0314460 in __sock_sendmsg_nosec (size=32, msg=0xc0a5df7c,
sock=0xc34220c0, iocb=0xc0a5ddd8) at net/socket.c:632
#17 __sock_sendmsg (size=32, msg=0xc0a5df7c, sock=0xc34220c0,
iocb=0xc0a5ddd8) at net/socket.c:640
#18 sock_sendmsg (sock=sock@entry=0xc34220c0,
msg=msg@entry=0xc0a5df7c, size=size@entry=32) at net/socket.c:651
#19 0xc0315598 in ___sys_sendmsg (sock=sock@entry=0xc34220c0,
msg_sys=0xc0a5df7c, msg_sys@entry=0xc0a5df74, flags=flags@entry=0,
used_address=0x0 <__vectors_start>, msg=0xbef014c4) at
net/socket.c:2072
#20 0xc0316580 in ___sys_sendmsg (used_address=0x0 <__vectors_start>,
flags=0, msg_sys=0xc0a5df74, msg=0xbef014c4, sock=0xc34220c0) at
net/socket.c:2000
#21 __sys_sendmsg (fd=<optimized out>, msg=0xbef014c4, flags=0) at
net/socket.c:2108
#22 0xc00093c0 in ?? ()
#23 0xc00093c0 in ?? ()
Backtrace stopped: previous frame identical to this frame (corrupt stack?)


Jon
