Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3F0Ax4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:53:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49421 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3F0Axx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:53:53 -0400
Date: Wed, 26 Jun 2013 17:53:43 -0700 (PDT)
Message-Id: <20130626.175343.1303631017869153742.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5R0s3OK010462


1) Found via trinity.

   If you connect up an ipv6 socket to an ipv4 mapped address then an
   ipv6 one, sendmsg() can croak because ip6_sk_dst_check() assumes
   the route cached in the socket is an ipv6 one.  In this case there
   is an ipv4 route attached, so it gets stomped on.

   Reported by Dave Jones and Hannes Frederic Sowa, fixed by Eric
   Dumazet.

2) AF_KEY notifications leak some kernel memory to userspace, fix
   from Mathias Krause.

3) DLCI calls __dev_get_by_name() without proper locking, and dlci_del
   doesn't validate that the device being deleted is actually a DLCI
   one.  Fixes from Li Zefan.

4) Length check on bluetooth l2cap information responses is wrong,
   each response type has a different lenth, so we should make sure
   it's in a given range rather than enforce one single valid length.
   From Jaganath Kanakkassery.

5) Receive FIFO overflow is really easy to trigger in stress scenerios
   in the sh_eth driver, but the event isn't being handled properly at
   all.  Specifically, the mask of error interrupts doesn't include the
   event so we never clear it, resulting in the driver becomming wedged
   processing an interrupt that never gets cleared.

   Fix from Sergei Shtylyov.

6) qlcnic sleeps while holding a spinlock, use mdelay() instead of
   msleep().  From Shahed Shaikh.

7) Missing curly braces causes SIP netfilter NAT module to always
   drop packets.  Fix from Balazs Peter Odor.

8) ipt_ULOG in netfilter passes the wrong value to timer setup, causing
   the timer to dereference crap when it fires.  Fix from Gao Feng.

9) Missing RCU protection around txq->axq_acq traversal in
   ath_txq_schedule().  Fix from Felix Fietkau.

10) Idle state transition test in ath9k_htc_config() is reversed, fix
    from Sujith Manoharan.

11) IPV6 forwarding handles unicast Router Alert packets incorrectly.
    It tests the wrong option state.  Previously opt->ra being
    non-zero indicated a router alert marking in the SKB, but now it's
    indicated by a bit in opt->flags.  Fix from YOSHIFUJI Hideaki.

12) SKB leak in GRE tunnel GSO handling, from Eric Dumazet.

13) get_user_pages_fast() error handling in TUN and MACVTAP use the
    same local variable for the base index and the loop iterator for
    page traversal, oops!  Fix from Michael S. Tsirkin.

14) ipv6_get_lladdr() can fail, and we must therefore check it's return
    value in inet6_set_iftoken().  For from Hannes Frederic Sowa.

15) If you change an interface name and meanwhile can sneak in something
    that looks up the name (like SO_BINDTODEVICE or SIOCGIFNAME) we can
    deadlock with CONFIG_PREEMPT=n.  Fix this by providing a helper function
    that properly uses raw_seqcount_begin().  From Nicolas Schichan.

16) Chain noise calibration test is inverted in iwlwifi, fix from Nikolay
    Martynov.

17) Properly set TX iwlwifi descriptor flags for back requests.  Fix from
    Emmanuel Grumbach.

18) We can't assume skb_transport_header() is set in xt_TCPOPTSTRAP module,
    fix from Pablo Neira Ayuso.

19) Some crummy APs don't provide the proper High Throughput info in
    association response frames.  Add a workaround by assume we'll use
    whatever is in the beacon/probe.  Fix from Johannes Berg.

20) mac80211 call to rate_idx_match_mask() swaps two arguments (mask
    and channel width).  Fix from Simon Wunderlich.

21) xt_TCPMSS (like xt_TCPOPTSTRAP) must not try to handle fragmented
    frames.  Fix from Phil Oester.

22) Fix rate control regression causing iwlwifi/iwlegacy chips to use
    1Mbit/s on pre-11n networks.  From Moshe Benji and Stanslaw
    Gruszka.

23) Disable brcmsmac power-save functions, they cause regressions.
    From Arend van Spriel.

24) Enforce a sane minimum MTU in l2cap_build_cmd() otherwise we can
    easily crash.  Fix from Anderson Lizardo.

25) If a learning packet arrives during vxlan_stop() we crash, easily
    fixed by checking netif_running().  From Stephen Hemminger.

26) Static vxlan FDB entries should not be migrated, also from
    Stephen.

27) skb_clone() failures not handled in vxlan_xmit(), oops.  Also
    from Stephen.

28) Add minimal driver for AR816x/AR817x ethernet chips, from Johannes
    Berg.

29) Fix regression in userspace VLAN acceleration control, added by
    the 802.1ad support changes.  Fix from Fernando Luis Vazquez Cao.

30) Interval selection for MLD queries in the bridging code was
    reversed.  Fix from Linus LÃ¼ssing.

31) ipv6's ndisc_send_redirect() erroneously writes to the packet we
    received not the packet we are building to send out.  Fix from
    Matthias Schiffer.

32) Don't free netdev before unregistering it, in usb_8dev can driver.
    From Marc Kleine-Budde.

33) Fix nl80211 attribute buffer races, from Johannes Berg.

34) Although netlink_diag.h is under uapi/ it isn't present in Kbuild.
    From Stephen Hemminger.

35) Wrong address and family passed to MD5 key lookups in TCP, from
    Aydin Arik.

36) phy_type attribute created by SFC driver should not be writable.
    From Ben Hutchings.

37) Receive/Transmit queue allocations in pxa168_eth and mv643xx_eth
    should use kzalloc().  Otherwise if setup fails half-way, we'll
    dereference garbage when trying to teardown the rings.  From
    Lubomir Rintel.

38) Fix double-allocation of dst (resulting in unfreeable net device)
    in ipv6's init_loopback().  From Gao Feng.

39) Fix fragmentation handling SKB leak in netfilter conntrack, we
    were freeing the wrong skb pointer.  From Phil Oester.

40) Don't report "-1" (SPEED_UNKNOWN) in bond_miimon_commit(), from
    Nikolay Aleksandrov.

41) davinci_cpdma doesn't check for DMA mapping errors, letting the
    device scribble to random addresses.  From Sebastian Siewior.

Please pull, thanks a lot!

The following changes since commit 8177a9d79c0e942dcac3312f15585d0344d505a5:

  lseek(fd, n, SEEK_END) does *not* go to eof - n (2013-06-16 08:10:53 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net master

for you to fetch changes up to 578a1310f2592ba90c5674bca21c1dbd1adf3f0a:

  dlci: validate the net device in dlci_del() (2013-06-26 15:36:42 -0700)

----------------------------------------------------------------
Amir Vadai (1):
      net/mlx_en: Timestamping is not supported in slave mode

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU

Arend van Spriel (2):
      brcmsmac: disable power-save related functions
      brcmfmac: free primary net_device when brcmf_bus_start() fails

Aydin Arik (1):
      ipv4: Fixed MD5 key lookups when adding/ removing MD5 to/ from TCP sockets.

Balazs Peter Odor (1):
      netfilter: nf_nat_sip: fix mangling

Ben Hutchings (1):
      sfc: Remove write permission from phy_type attribute

Dan Williams (1):
      qmi_wwan: add various Novatel Gobi1K IDs

Daniel Drake (1):
      Bluetooth: btmrvl: fix thread stopping race

David Daney (2):
      netdev: octeon_mgmt: Correct tx IFG workaround.
      netdev: octeon_mgmt: Fix structure layout for little-endian.

David S. Miller (4):
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless into wireless
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless

Emmanuel Grumbach (1):
      iwlwifi: mvm: correctly set the flags for BAR

Eric Dumazet (2):
      gre: fix a possible skb leak
      ipv6: ip6_sk_dst_check() must not assume ipv6 dst

Felix Fietkau (1):
      ath9k: fix an RCU issue in calling ieee80211_get_tx_rates

Fernando Luis Vazquez Cao (1):
      vlan: restore ethtool ABI to control VLAN hardware acceleration

Florian Westphal (1):
      netfilter: ctnetlink: send event when conntrack label was modified

Gao feng (2):
      ipv6: don't call addrconf_dst_alloc again when enable lo
      netfilter: ipt_ULOG: fix incorrect setting of ulog timer

Gavin Shan (1):
      net/tg3: Avoid delay during MMIO access

Giuseppe CAVALLARO (1):
      stmmac: fix EEE setup

Guenter Roeck (1):
      net: fec: Fix build for MCF5272

Haiyang Zhang (1):
      Fix the VLAN_TAG_PRESENT in netvsc_recv_callback()

Hannes Frederic Sowa (1):
      ipv6: check return value of ipv6_get_lladdr

Jaganath Kanakkassery (1):
      Bluetooth: Fix invalid length check in l2cap_information_rsp()

Johan Hedberg (1):
      Bluetooth: Fix conditions for HCI_Delete_Stored_Link_Key

Johannes Berg (4):
      iwlwifi: don't print module loading error if not modular
      mac80211: work around broken APs not including HT info
      alx: add a simple AR816x/AR817x device driver
      nl80211: fix attrbuf access race by allocating a separate one

John W. Linville (7):
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem
      Merge branch 'master' of git://git.kernel.org/.../bluetooth/bluetooth
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless into for-davem

Julian Anastasov (1):
      ipvs: SCTP ports should be writable in ICMP packets

Linus LÃ¼ssing (1):
      bridge: fix switched interval for MLD Query types

Lubomir Rintel (2):
      pxa168_eth: Allocate receive queue initialized to zero
      mv643xx_eth: Allocate receive queue initialized to zero

Marc Kleine-Budde (1):
      can: usb_8dev: unregister netdev before free()ing

Mathias Krause (1):
      af_key: fix info leaks in notify messages

Matthias Schiffer (1):
      ipv6: ndisc: fix ndisc_send_redirect writing to the wrong skb

Michael S. Tsirkin (2):
      tun: fix recovery from gup errors
      macvtap: fix recovery from gup errors

Moshe Benji (1):
      iwlwifi: fix rate control regression

Mugunthan V N (2):
      drivers: net: cpsw: fix cpsw clock gating issue across suspend/resume
      drivers: net: cpsw: fix compilation error with cpsw driver

Nicolas Schichan (1):
      net: fix kernel deadlock with interface rename and netdev name retrieval.

Nikolay Aleksandrov (1):
      bonding: fix slave speed reporting in bond_miimon_commit

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration

Olaf Hering (1):
      net: vlan: fix comment for vlan_ethhdr->h_vlan_proto

Pablo Neira Ayuso (1):
      netfilter: xt_TCPOPTSTRIP: don't use tcp_hdr()

Phil Oester (3):
      netfilter: xt_TCPMSS: Fix IPv6 default MSS too
      netfilter: xt_TCPMSS: Fix missing fragmentation handling
      netfilter: nf_conntrack_ipv6: Plug sk_buff leak in fragment handling

Sebastian Siewior (2):
      net: cpsw: check for cpts pointer after its allocation
      net: eth: davicnci_cpdma: check dma map error

Sergei Shtylyov (2):
      sh_eth: fix unhandled RFE interrupt
      sh_eth: fix misreporting of transmit abort

Shahed Shaikh (1):
      qlcnic: Do not sleep while holding spinlock

Shan Wei (1):
      tcp: doc : fix the syncookies default value

Simon Wunderlich (2):
      mac80211: abort CAC in stop_ap()
      mac80211: Fix rate control mask matching call

Stanislaw Gruszka (2):
      iwlegacy: fix rate control regression
      rt2800: fix RT5390 & RT3290 TX power settings regression

Sujith Manoharan (1):
      ath9k_htc: Handle IDLE state transition properly

YOSHIFUJI Hideaki / å‰è—¤è‹±æ˜ (1):
      ipv6: Process unicast packet with Router Alert by checking flag in skb.

Zefan Li (2):
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
      dlci: validate the net device in dlci_del()

stephen hemminger (5):
      vxlan: fix race between flush and incoming learning
      vxlan: only migrate dynamic FDB entries
      vxlan: handle skb_clone failure
      vxlan: fix check for migration of static entry
      netlink: export netlink_diag.h header

 Documentation/networking/ip-sysctl.txt              |    4 +-
 drivers/bluetooth/btmrvl_main.c                     |    9 +-
 drivers/net/bonding/bond_main.c                     |    3 +-
 drivers/net/can/usb/usb_8dev.c                      |    5 +-
 drivers/net/ethernet/atheros/Kconfig                |   18 +
 drivers/net/ethernet/atheros/Makefile               |    1 +
 drivers/net/ethernet/atheros/alx/Makefile           |    3 +
 drivers/net/ethernet/atheros/alx/alx.h              |  114 ++++++
 drivers/net/ethernet/atheros/alx/ethtool.c          |  272 +++++++++++++
 drivers/net/ethernet/atheros/alx/hw.c               | 1226 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/atheros/alx/hw.h               |  499 +++++++++++++++++++++++
 drivers/net/ethernet/atheros/alx/main.c             | 1625 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/atheros/alx/reg.h              |  810 +++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/broadcom/tg3.c                 |   36 ++
 drivers/net/ethernet/freescale/fec_main.c           |   14 +
 drivers/net/ethernet/marvell/mv643xx_eth.c          |    2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c           |    4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c           |    3 +
 drivers/net/ethernet/octeon/octeon_mgmt.c           |   31 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c     |    2 +-
 drivers/net/ethernet/renesas/sh_eth.c               |   38 +-
 drivers/net/ethernet/renesas/sh_eth.h               |    2 +-
 drivers/net/ethernet/sfc/efx.c                      |    2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h        |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   |   66 ++-
 drivers/net/ethernet/ti/cpsw.c                      |    5 +-
 drivers/net/ethernet/ti/davinci_cpdma.c             |    7 +
 drivers/net/hyperv/netvsc_drv.c                     |    4 +-
 drivers/net/macvtap.c                               |    6 +-
 drivers/net/tun.c                                   |    6 +-
 drivers/net/usb/qmi_wwan.c                          |    8 +-
 drivers/net/vxlan.c                                 |   40 +-
 drivers/net/wan/dlci.c                              |   26 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c       |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c               |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c |    4 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c      |   17 +-
 drivers/net/wireless/iwlegacy/3945-rs.c             |    1 +
 drivers/net/wireless/iwlegacy/4965-rs.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c               |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c              |    2 +
 drivers/net/wireless/iwlwifi/mvm/rs.c               |    1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c               |    3 +-
 drivers/net/wireless/rt2x00/rt2800lib.c             |   29 +-
 include/linux/if_vlan.h                             |    2 +-
 include/linux/netdevice.h                           |    1 +
 include/linux/skbuff.h                              |    1 +
 include/uapi/linux/Kbuild                           |    1 +
 net/bluetooth/hci_core.c                            |   15 +-
 net/bluetooth/l2cap_core.c                          |    5 +-
 net/bridge/br_multicast.c                           |    5 +-
 net/core/dev.c                                      |   34 ++
 net/core/dev_ioctl.c                                |   19 +-
 net/core/ethtool.c                                  |    6 +-
 net/core/skbuff.c                                   |   20 +-
 net/core/sock.c                                     |   17 +-
 net/ipv4/gre.c                                      |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c                       |   12 +-
 net/ipv4/tcp_ipv4.c                                 |    4 +-
 net/ipv6/addrconf.c                                 |   12 +-
 net/ipv6/ip6_output.c                               |   13 +-
 net/ipv6/ndisc.c                                    |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c      |    2 +-
 net/key/af_key.c                                    |    2 +
 net/mac80211/cfg.c                                  |    6 +
 net/mac80211/ieee80211_i.h                          |    5 +-
 net/mac80211/mlme.c                                 |   87 +++-
 net/mac80211/rate.c                                 |    2 +-
 net/mac80211/util.c                                 |    4 +-
 net/netfilter/ipvs/ip_vs_core.c                     |    3 +-
 net/netfilter/nf_conntrack_labels.c                 |    2 +-
 net/netfilter/nf_conntrack_netlink.c                |    1 +
 net/netfilter/nf_nat_sip.c                          |    3 +-
 net/netfilter/xt_TCPMSS.c                           |   25 +-
 net/netfilter/xt_TCPOPTSTRIP.c                      |    6 +-
 net/wireless/nl80211.c                              |   11 +-
 77 files changed, 5065 insertions(+), 231 deletions(-)
 create mode 100644 drivers/net/ethernet/atheros/alx/Makefile
 create mode 100644 drivers/net/ethernet/atheros/alx/alx.h
 create mode 100644 drivers/net/ethernet/atheros/alx/ethtool.c
 create mode 100644 drivers/net/ethernet/atheros/alx/hw.c
 create mode 100644 drivers/net/ethernet/atheros/alx/hw.h
 create mode 100644 drivers/net/ethernet/atheros/alx/main.c
 create mode 100644 drivers/net/ethernet/atheros/alx/reg.h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
