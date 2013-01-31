Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964769Ab3AaW2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:28:47 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:46502 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3AaW2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:28:45 -0500
MIME-Version: 1.0
Date: Fri, 1 Feb 2013 00:28:44 +0200
Message-ID: <CA+MedixNn7Nxu8LMpPWF8AKWpzPh6qt-Hx2=t02MhCX=OUd7Dg@mail.gmail.com>
Subject: [BUG][bonding][3.7.+] - bonding with 802.3ad mode send all traffic
 via a single interface only
From: Nikolay Ulyanitsky <lystor@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Bonding with 802.3ad mode send all traffic via a single interface on
kernel 3.7.+

Tested kernels with the issue: 3.7.5, 3.7.0
Tested kernels without the issue: 3.6.11, 3.4.28 and older
CentOS 6 x86_64

All kernels are compiled from the same config (http://pastebin.com/SPbgAAVt).
A screenshot from a router with 4 NICs on bond0 (eth0, eth1) and bond1
(eth2, eth3):
http://s17.postimage.org/f5a4owrsf/bonding.png

STEPS TO REPRODUCE ON TEST HOST:
Sorry, I have no any managed switches with 802.3ad at home. So I use
Virtualbox for bug reporting with two bridged adapters on the guest
attached to TAP devices on the host.

STEP 1. VIRTUALBOX HOST – INIT:
# cat /etc/modprobe.d/bonding.conf:
alias bond0 bonding
options bond0 mode=4 xmit_hash_policy=layer3+4 miimon=100

# ip tuntap add dev tap0 mode tap
# ip tuntap add dev tap1 mode tap
# modprobe -v bond0
# ip l set dev tap0 up
# ip l set dev tap1 up
# ip l set dev bond0 up
# ifenslave bond0 tap0 tap1
# ip a add 192.168.10.10/24 dev bond0

STEP 2. VIRTUALBOX GUEST – INIT:
# cat /etc/modprobe.d/bonding.conf:
alias bond0 bonding
options bond0 mode=4 xmit_hash_policy=layer3+4 miimon=100

# modprobe -v bond0
# ip l set dev p2p1 up
# ip l set dev p7p1 up
# ip l set dev bond0 up
# ifenslave bond0 p2p1 p7p1
# ip a add 192.168.10.20/24 dev bond0
# ip r add default via 192.168.10.10

STEP 3. VIRTUALBOX HOST – INIT SNIFFERS:
# tcpdump -n -nn -l -i tap0 > tap0.txt &
# tcpdump -n -nn -l -i tap1 > tap1.txt &

STEP 4. VIRTUALBOX HOST – GENERATE SOME TRAFFIC:
# nmap -sU -v -T 5 192.168.10.20

On 3.7.5, 3.7.0 the bonding will place all traffic only to a single
interface (tap0 or tap1).
On 3.6.11, 3.4.28 and older kernels the bonding will place all traffic
to both interfaces (tap0 and tap1).


# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer3+4 (1)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
802.3ad info
LACP rate: slow
Min links: 0
Aggregator selection policy (ad_select): stable
Active Aggregator Info:
Aggregator ID: 1
Number of ports: 2
Actor Key: 5
Partner Key: 17
Partner Mac Address: 08:00:27:af:dd:45

Slave Interface: tap0
MII Status: up
Speed: 10 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: ba:2f:b5:25:d0:67
Aggregator ID: 1
Slave queue ID: 0

Slave Interface: tap1
MII Status: up
Speed: 10 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 6a:ce:e4:d0:0c:05
Aggregator ID: 1
Slave queue ID: 0


Any ideas?
Thanks

–
With best regards,
Nikolay Ulyanitsky
