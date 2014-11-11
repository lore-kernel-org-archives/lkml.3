Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbaKKIVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:21:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaKKIVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:21:33 -0500
Message-Id: <cover.1415692212.git.mkubecek@suse.cz>
From: Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 0/3] dev_disable_lro() improvements for stacked devices
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, Jiri Pirko <jiri@resnulli.us>
Date: Tue, 11 Nov 2014 09:21:30 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Large receive offloading is known to cause problems if received packets
are passed to other host. Therefore the kernel disables it by calling
dev_disable_lro() whenever a network device is enslaved in a bridge or
forwarding is enabled for it (or globally). For virtual devices we need
to disable LRO on the underlying physical device (which is actually
receiving the packets).

Current dev_disable_lro() code handles this propagation for a vlan
(including 802.1ad nested vlan), macvlan or a vlan on top of a macvlan.
This patch adds LRO disabling propagation for

  - macvlan on top of a vlan or any stacked combination of those
  - bonding
  - teaming

In the bonding and teaming case, it is necessary to disable LRO not only
on slaves when dev_disable_lro() is called but also on any slave (port)
added later.

Michal Kubecek (3):
  net: handle more general stacking in dev_disable_lro()
  team: add helper to check if device is a team master
  net: propagate LRO disabling to bond and team slaves

 drivers/net/bonding/bond_main.c |  3 +++
 drivers/net/team/team.c         |  6 +++++-
 include/linux/netdevice.h       |  7 +++++++
 net/core/dev.c                  | 31 ++++++++++++++++++++++---------
 4 files changed, 37 insertions(+), 10 deletions(-)

-- 
1.8.4.5

