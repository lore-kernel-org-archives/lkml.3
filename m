Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaGUJ7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:59:47 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:58157 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaGUJ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAMs-qv-Fqq7PA1=cUdApT-wXfjiq3jtb9B_R_qdF2i-QfdYLAA@mail.gmail.com>
References: <CAMs-qv8rzUK_iyS5K7D0qg8FqNnsb4QL7dK-wspxCDiyQQ_mog@mail.gmail.com>
 <CAMs-qv-Fqq7PA1=cUdApT-wXfjiq3jtb9B_R_qdF2i-QfdYLAA@mail.gmail.com>
From: Xuefer <xuefer@gmail.com>
Date: Mon, 21 Jul 2014 17:59:24 +0800
Message-ID: <CAMs-qv-L6mL6TqYrSp=HMv=X7tzWx1VxrOK2xx7Ax4cYyYsCZw@mail.gmail.com>
Subject: Fwd: [3.14.7] tinc vpn can no longer be added to bonding: Warning:
 The first slave device specified does not support setting the MAC address.
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(i failed to contact the authors of bonding code so i post in the
lkml. CC me in reply)

tinc vpn interface cannot be added to bond0, and dmesg says: Warning:
The first slave device specified does not support setting the MAC
address
and yes, the tun device indeed is not ether based tun device because
tinc is running in router mode


# cat /proc/version
Linux version 3.14.7 (xuefer@gentoo) (gcc version 4.8.0 (OpenWrt GCC
4.8.0 r41227) ) #17 SMP Fri Jun 20 21:26:49 CST 2014

# dmesg
[413007.454543] bonding: bond0: Adding slave vpn3.
[413007.454640] bonding: bond0: Warning: The first slave device
specified does not support setting the MAC address.
[413007.522291] bonding: bond0: Adding slave vpn2.
[413007.522300] bonding: bond0: Warning: The first slave device
specified does not support setting the MAC address.
[413007.555482] bonding: bond0: Adding slave vpn1.
[413007.555492] bonding: bond0: Warning: The first slave device
specified does not support setting the MAC address.
[413007.564077] bonding: bond0: Adding slave vpn4.
[413007.564087] bonding: bond0: Warning: The first slave device
specified does not support setting the MAC address.

# tinc --version
tinc version 1.1pre10 (built Jun 18 2014 13:05:02, protocol 17.3)

=========
problem reproduced with kernel 3.14.7 and tinc.conf below
# cat /etc/tinc/vpn1/tinc.conf
Name = x1
Port = 651
Mode = router
(in router mode, the tun device created by vpn is NOT ether based, and
do NOT support setting mac address)

(workaround1) not reproduced with the config below
# cat /etc/tinc/vpn1/tinc.conf
Name = x1
Port = 651
Mode = switch
(in switch mode, the tun device created by vpn is ether based, and
support setting mac address)

(workaround2)
downgrade to 3.10.x
=========

every other settings is by default, default bonding mode balance-rr

# grep '' /sys/devices/virtual/net/bond0/bonding/*
/sys/devices/virtual/net/bond0/bonding/ad_select:stable 0
/sys/devices/virtual/net/bond0/bonding/all_slaves_active:0
/sys/devices/virtual/net/bond0/bonding/arp_all_targets:any 0
/sys/devices/virtual/net/bond0/bonding/arp_interval:0
/sys/devices/virtual/net/bond0/bonding/arp_validate:none 0
/sys/devices/virtual/net/bond0/bonding/downdelay:0
/sys/devices/virtual/net/bond0/bonding/fail_over_mac:none 0
/sys/devices/virtual/net/bond0/bonding/lacp_rate:slow 0
/sys/devices/virtual/net/bond0/bonding/lp_interval:1
/sys/devices/virtual/net/bond0/bonding/mii_status:up
/sys/devices/virtual/net/bond0/bonding/miimon:0
/sys/devices/virtual/net/bond0/bonding/min_links:0
/sys/devices/virtual/net/bond0/bonding/mode:balance-rr 0
/sys/devices/virtual/net/bond0/bonding/num_grat_arp:1
/sys/devices/virtual/net/bond0/bonding/num_unsol_na:1
/sys/devices/virtual/net/bond0/bonding/packets_per_slave:1
/sys/devices/virtual/net/bond0/bonding/primary_reselect:always 0
/sys/devices/virtual/net/bond0/bonding/queue_id:
/sys/devices/virtual/net/bond0/bonding/resend_igmp:1
/sys/devices/virtual/net/bond0/bonding/slaves:
/sys/devices/virtual/net/bond0/bonding/updelay:0
/sys/devices/virtual/net/bond0/bonding/use_carrier:1
/sys/devices/virtual/net/bond0/bonding/xmit_hash_policy:layer2 0


non-ether based tun device seems to compatible with active-backup mode
of bonding but that is not the mode i want
