Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbaISVOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:14:11 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51846 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728AbaISVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:14:09 -0400
Date: Fri, 19 Sep 2014 14:14:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anish Bhatt <anish@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: linux-next: Tree for Sep 19
Message-ID: <20140919211404.GA24856@roeck-us.net>
References: <20140919165817.225eb8b8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140919165817.225eb8b8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:58:17PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20140917:
> 
> The fsl tree still had its build failure so I used the version from
> next-20140917.
> 
> The v4l-dvb tree lost its build failure.
> 
> The security tree gained a conflict against the file-locks tree.
> 
> Non-merge commits (relative to Linus' tree): 6014
>  5488 files changed, 217522 insertions(+), 129375 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
Guess this is most difficult one.

mips:nlm_xlp_defconfig:

warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has
unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)
warning: (SCSI_BNX2X_FCOE && LIBFCOE && TCM_QLA2XXX) selects LIBFC which has
unmet direct dependencies (SCSI_LOWLEVEL && SCSI && SCSI_FC_ATTRS)

followed by:

ERROR: "scsi_is_fc_rport" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "fc_get_event_number" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "skb_trim" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "fc_host_post_event" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "__alloc_skb" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "fc_remote_port_delete" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "kfree_skb" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "fc_block_scsi_eh" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "fc_remote_port_add" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "skb_put" [drivers/scsi/libfc/libfc.ko] undefined!
ERROR: "skb_clone" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "dev_get_by_name" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "register_netdevice_notifier" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "unregister_netdevice_notifier" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "skb_trim" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "__netdev_alloc_skb" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "__pskb_pull_tail" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "skb_queue_purge" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "__ethtool_get_settings" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "skb_push" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "skb_pull" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "init_net" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "skb_queue_tail" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "kfree_skb" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "skb_dequeue" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "consume_skb" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "dev_queue_xmit" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "skb_put" [drivers/scsi/fcoe/libfcoe.ko] undefined!
ERROR: "dev_get_stats" [drivers/scsi/fcoe/libfcoe.ko] undefined!

The problem is that there are many different errors seen at various stages
during bisect, making a bisect a bit tricky.

--------
At commit 'xfrm: Generate blackhole routes only from route lookup functions',
the error is:

drivers/scsi/scsi_transport_fc.c: In function 'fc_host_post_event':
drivers/scsi/scsi_transport_fc.c:543:7: error: 'scsi_nl_sock' undeclared
drivers/scsi/scsi_transport_fc.c: In function 'fc_host_post_vendor_event':
drivers/scsi/scsi_transport_fc.c:611:7: error: 'scsi_nl_sock' undeclared

--------
At commit 'bnx2i/bnx2fc : fix randconfig error in next-20140909' and
'scsi_netlink : Make SCSI_NETLINK dependent on NET instead of selecting NET',
the error is:

drivers/built-in.o: In function `scsi_nl_rcv_msg':
drivers/scsi/scsi_netlink.c:114: undefined reference to `netlink_ack'
drivers/scsi/scsi_netlink.c:116: undefined reference to `skb_pull'
drivers/scsi/scsi_netlink.c:80: undefined reference to `netlink_capable'
drivers/built-in.o: In function `netlink_kernel_create':
include/linux/netlink.h:60: undefined reference to `init_net'
include/linux/netlink.h:60: undefined reference to `init_net'
include/linux/netlink.h:60: undefined reference to `__netlink_kernel_create'
drivers/built-in.o: In function `scsi_netlink_exit':
drivers/scsi/scsi_netlink.c:153: undefined reference to `netlink_kernel_release'

-------

Bisect reports commit 5d6be6a5d486 ('scsi_netlink : Make SCSI_NETLINK dependent
on NET instead of selecting NET') as first bad commit.

bisect log:

# bad: [6a10bca9b608df445baa23c3bfafc510d93d425b] Add linux-next specific files for 20140919
# good: [9e82bf014195d6f0054982c463575cdce24292be] Linux 3.17-rc5
git bisect start 'HEAD' 'v3.17-rc5'
# bad: [fde058e2322b9098251d7cf798cac4327a29c004] Merge remote-tracking branch 'drm/drm-next'
git bisect bad fde058e2322b9098251d7cf798cac4327a29c004
# bad: [8fdb4a28beeda1e6626c43b70cd0575512173c3a] Merge remote-tracking branch 'v4l-dvb/master'
git bisect bad 8fdb4a28beeda1e6626c43b70cd0575512173c3a
# bad: [067cd6bcf6f5be3fd82b7e71cbc27f1e0695d673] Merge remote-tracking branch 'tegra/for-next'
git bisect bad 067cd6bcf6f5be3fd82b7e71cbc27f1e0695d673
# good: [37bd1119d8b2e8bdf4e211e096da6fb84c0af45e] arm-soc: document merges
git bisect good 37bd1119d8b2e8bdf4e211e096da6fb84c0af45e
# bad: [0f50dd028d3b77bd422df1f4609510a8f70c88c0] Merge remote-tracking branch 'ep93xx/ep93xx-for-next'
git bisect bad 0f50dd028d3b77bd422df1f4609510a8f70c88c0
# good: [bcca6923950b0d952dd03855dc6aadc0848d3e22] Merge remote-tracking branch 'sparc/master'
git bisect good bcca6923950b0d952dd03855dc6aadc0848d3e22
# bad: [99f3bddf52a8dc454ade167099a9e6d5b6dcd8f6] Merge remote-tracking branch 'ipsec/master'
git bisect bad 99f3bddf52a8dc454ade167099a9e6d5b6dcd8f6
# good: [a7f8289d1291a8e1b9d4e39c770467d3dac0d382] Merge tag 'linux-can-fixes-for-3.17-20140911' of git://gitorious.org/linux-can/linux-can
git bisect good a7f8289d1291a8e1b9d4e39c770467d3dac0d382
# good: [48c20407f49039d8da155ca00877ec5f057799e6] r8169: fix the default setting of rx vlan
git bisect good 48c20407f49039d8da155ca00877ec5f057799e6
# good: [d6ce2628f32271c037a8c12e1994c9fba3a4af49] cxgb4: Don't allocate adapter structure for all PF's
git bisect good d6ce2628f32271c037a8c12e1994c9fba3a4af49
# bad: [f92ee61982d6da15a9e49664ecd6405a15a2ee56] xfrm: Generate blackhole routes only from route lookup functions
git bisect bad f92ee61982d6da15a9e49664ecd6405a15a2ee56
# bad: [23a3c99201954d8ffe92e599e3c3039985280f1b] bnx2i/bnx2fc : fix randconfig error in next-20140909
git bisect bad 23a3c99201954d8ffe92e599e3c3039985280f1b
# bad: [5d6be6a5d4864712832822efeb9c2d54e4063949] scsi_netlink : Make SCSI_NETLINK dependent on NET instead of selecting NET
git bisect bad 5d6be6a5d4864712832822efeb9c2d54e4063949
# first bad commit: [5d6be6a5d4864712832822efeb9c2d54e4063949] scsi_netlink : Make SCSI_NETLINK dependent on NET instead of selecting NET
