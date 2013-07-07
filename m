Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3GGUVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 16:21:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58367 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3GGUVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 16:21:37 -0400
Date: Sun, 07 Jul 2013 13:21:33 -0700 (PDT)
Message-Id: <20130707.132133.1335860703202153192.davem@davemloft.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r67KMKjG001681


I did a test merge of this stuff into your tree and here are the
conflicts to resolve, many of which are trivial:

1) Documentation/networking/netlink_mmap.txt

   Two overlapping misspelling fixes, one for "physically" on the first
   line and one for "discontinuous" on the second line.

2) arch/arm/boot/dts/am335x-bone.dts
   arch/arm/boot/dts/am335x-evm.dts

   Overlapping additions.  &cpsw_emac1 stanza has the

	phy-mode = "mii";

   added to it, and two new stanzas for &mac and @davinci_mdio are
   added.

3) arch/arm/boot/dts/am335x-evmsk.dts

   Overlapping additions of 4 stanzas.

4) arch/arm/boot/dts/sun4i-a10.dtsi

   Likewise, overlapping additions.

5) arch/arm/mach-mxs/Kconfig

   Overlapping additions of select statements for SOC_IMX2.

6) arch/arm/mach-mxs/mach-mxs.c

   In mxs_machine_init(), the of_platform_populate() call has it's final
   two arguments changed to be NULL.

7) arch/arm/mach-shmobile/clock-r8a7740.c

   Choose the &mstp_clks[MSTP309] entry that uses the string
   "r8a7740-gether".  Preserve the surrounding additions.

8) arch/arm/mach-shmobile/clock-r8a7778.c

   Likewise, choose the &mstp_clks[MSTP114] entry that uses the
   string "r8a777x-ether".

9) arch/arm/mach-shmobile/clock-r8a7779.c

   Again, use the "r8a777x-ether" entry for &mstp_clks[MSTP114].

10) drivers/staging/silicom/bpctl_mod.c

    Two overlapping changes to the local variable declarations in
    bp_device_event().  The first makes 'dev' get assigned to
    netdev_notifier_info_to_dev(ptr), and the second removes the
    NULL initializers for the static bpctl_dev_t variables.

11) fs/select.c

    Overlapping additions of include directives, keep both.

Now, on to what's actually in here.  A smaller than usual set of
changes for the merge window by networking standards, but still
some interesting things in here.  Highlights:

1) Low latency device polling, eliminating the cost of interrupt
   handling and context switches.  Allows direct polling of a network
   device from socket operations, such as recvmsg() and poll().

   Currently ixgbe, mlx4, and bnx2x support this feature.

   Full high level description, performance numbers, and design in
   commit 0a4db187a999c4a715bf56b8ab6c4705b524e4bb ("Merge branch
   'll_poll'")
   
   From Eliezer Tamir.

2) With the routing cache removed, ip_check_mc_rcu() gets exercised
   more than ever before in the case where we have lots of multicast
   addresses.  Use a hash table instead of a simple linked list, from
   Eric Dumazet.

3) Add driver for Atheros CQA98xx 802.11ac wireless devices, from
   Bartosz Markowski, Janusz Dziedzic, Kalle Valo, Marek Kwaczynski,
   Marek Puzyniak, Michal Kazior, and Sujith Manoharan.

4) Support reporting the TUN device persist flag to userspace, from
   Pavel Emelyanov.

5) Allow controlling network device VF link state using netlink, from
   Rony Efraim.

6) Support GRE tunneling in openvswitch, from Pravin B Shelar.

7) Adjust SOCK_MIN_RCVBUF and SOCK_MIN_SNDBUF for modern times, from
   Daniel Borkmann and Eric Dumazet.

8) Allow controlling of TCP quickack behavior on a per-route basis,
   from Cong Wang.

9) Several bug fixes and improvements to vxlan from Stephen Hemminger,
   Pravin B Shelar, and Mike Rapoport.  In particular, support
   receiving on multiple UDP ports.

10) Major cleanups, particular in the area of debugging and cookie
    lifetime handline, to the SCTP protocol code.  From Daniel
    Borkmann.

11) Allow packets to cross network namespaces when traversing tunnel
    devices.   From Nicolas Dichtel.

12) Allow monitoring netlink traffic via AF_PACKET sockets, in a manner
    akin to how we monitor real network traffic via ptype_all.  From
    Daniel Borkmann.

13) Several bug fixes and improvements for the new alx device driver,
    from Johannes Berg.

14) Fix scalability issues in the netem packet scheduler's time queue,
    by using an rbtree.  From Eric Dumazet.

15) Several bug fixes in TCP loss recovery handling, from Yuchung
    Cheng.

16) Add support for GSO segmentation of MPLS packets, from Simon
    Horman.

17) Make network notifiers have a real data type for the opaque
    pointer that's passed into them.  Use this to properly handle
    network device flag changes in arp_netdev_event().  From Jiri
    Pirko and Timo Ter√§s.

18) Convert several drivers over to module_pci_driver(), from Peter
    Huewe.

19) tcp_fixup_rcvbuf() can loop 500 times over loopback, just use
    a O(1) calculation instead.  From Eric Dumazet.

20) Support setting of explicit tunnel peer addresses in ipv6, just
    like ipv4.  From Nicolas Dichtel.

21) Protect x86 BPF JIT against spraying attacks, from Eric Dumazet.

22) Prevent a single high rate flow from overruning an individual cpu
    during RX packet processing via selective flow shedding.  From
    Willem de Bruijn.

23) Don't use spinlocks in TCP md5 signing fast paths, from Eric
    Dumazet.

24) Don't just drop GSO packets which are above the TBF scheduler's
    burst limit, chop them up so they are in-bounds instead.  Also
    from Eric Dumazet.

25) VLAN offloads are missed when configured on top of a bridge, fix
    from Vlad Yasevich.

26) Support IPV6 in ping sockets.  From Lorenzo Colitti.

27) Receive flow steering targets should be updated at poll() time
    too, from David Majnemer.

28) Fix several corner case regressions in PMTU/redirect handling
    due to the routing cache removal, from Timo Ter√§s.

29) We have to be mindful of ipv4 mapped ipv6 sockets in
    upd_v6_push_pending_frames().  From Hannes Frederic Sowa.

30) Fix L2TP sequence number handling bugs, from James Chapman.

Please pull, thanks a lot!

The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to c7e8e8a8f7a70b343ca1e0f90a31e35ab2d16de1:

  bridge: fix some kernel warning in multicast timer (2013-07-06 18:12:47 -0700)

----------------------------------------------------------------
Aaron Marburg (1):
      net: ipheth: Add USB ID for iPad mini

Akeem G. Abodunrin (6):
      e1000e: Release mutex lock only if it has been initially acquired
      igb: Changed LEDs blink mechanism to include designs using cathode
      igb: Support for SFP modules discovery
      igb: SerDes flow control setting
      igb: Implementation of i210/i211 LED support
      igb: Removed unused i2c function

Alexander Bondar (12):
      mac80211: enable power save only if DTIM period is available
      iwlwifi: mvm: Add number of DTIMs to skip
      iwlwifi: mvm: configure power management in D3
      iwlwifi: mvm: Add beacon abort enablement
      iwlwifi: mvm: Change number of DTIMs to skip semantics
      iwlwifi: mvm: add debugfs for powersave
      iwlwifi: mvm: Change location of vif_count verification for PM
      mac80211: fix powersave bug and clean up ieee80211_rx_bss_info
      iwlwifi: mvm: enable PM always in unassociated mode
      mac80211: Use suitable semantics for beacon availability indication
      mac80211: track AP's beacon rate and give it to the driver
      iwlwifi: mvm: Add support for Low Power RX

Alexander Frolkin (2):
      ipvs: sloppy TCP and SCTP
      ipvs: SH fallback and L4 hashing

Alexandre Rames (1):
      sfc: Fix EEH with legacy interrupts.

Alexey Brodkin (2):
      ethernet/arc/arc_emac - Add new driver
      arc_emac: fix compile-time errors & warnings on PPC64

Alexey Khoroshilov (1):
      orinoco_usb: fix memory leak in ezusb_access_ltv() when device disconnected

Amerigo Wang (2):
      netpoll: fix position of network header
      ipv6,mcast: always hold idev->lock before mca_lock

Amir Hanania (1):
      IXGBE: Set the SW prio_tc values at initialization to the HW setting.

Amir Vadai (2):
      net/mlx4_en: Add Low Latency Socket (LLS) support
      net/mlx4_en: Low Latency recv statistics

Amitkumar Karwar (16):
      mwifiex: rename mwifiex_free_adapter() routine in init.c
      mwifiex: scan delay timer cleanup in unload path
      mwifiex: remove global user_scan_cfg variable
      mwifiex: add calibration data download feature
      mwifiex: use u32 variables for SDIO read/write port bitmap
      mwifiex: store SDIO chip specific information in separate structure
      mwifiex: replace unnecessary u32 variables with u8 in sdio.c
      mwifiex: code rearrangement in mwifiex_get_rd_port()
      mwifiex: do port calculations separately
      mwifiex: define a macro for MPA base address
      mwifiex: remove unnecessary macros in sdio.h
      mwifiex: code rearrangement in multiport aggregation path
      mwifiex: fix regression issue for usb interface
      mwifiex: code rearrangement for better readability
      mwifiex: add basic 11h support for station
      mwifiex: channel switch handling for station

Andre Guedes (14):
      Bluetooth: Make inquiry_cache_flush non-static
      Bluetooth: Update start_discovery to use HCI request
      Bluetooth: Remove start discovery handling from hci_event.c
      Bluetooth: Make mgmt_start_discovery_failed static
      Bluetooth: Move discovery macros to hci_core.h
      Bluetooth: Use HCI request in interleaved discovery
      Bluetooth: Update stop_discovery to use HCI request
      Bluetooth: Remove stop discovery handling from hci_event.c
      Bluetooth: Make mgmt_stop_discovery_failed static
      Bluetooth: Refactor hci_cc_le_set_scan_enable
      Bluetooth: Remove LE scan helpers
      Bluetooth: Remove inquiry helpers
      Bluetooth: Remove empty event handler
      Bluetooth: Mgmt Device Found Event

Andrei Emeltchenko (2):
      Bluetooth: Use HCI_MGMT instead of HCI_LINK_KEYS flag
      Bluetooth: Remove unneeded flag

Andy Hill (1):
      openvswitch: Fix misspellings in comments and docs.

Andy Lutomirski (1):
      sfc: Enable accelerated RFS on vlans

Andy Shevchenko (7):
      net/usb/kalmia: use %*phC to dump small buffers
      mwifiex: dump small buffers with help of %*ph
      wireless: ath6kl: re-use native helper to parse MAC
      netiucv: remove unused macro
      pch_gbe: remove inline keyword for exported functions
      pch_gbe: convert pr_* to netdev_*
      pch_gbe: use managed functions pcim_* and devm_*

Antonio Quartulli (20):
      batman-adv: drop useless argument seqno in neighbor creation
      batman-adv: slightly improve neighbor creation debug message
      batman-adv: don't check the source address twice
      batman-adv: don't check compat version twice
      batman-adv: do not silently ignore wrong condition
      batman-adv: don't initialise batman_iv private members in hard-interface.c
      batman-adv: use eth_hdr() when it makes sense
      batman-adv: move ring_buffer helper functions in bat_iv_ogm
      batman-adv: move batadv_slide_own_bcast_window to bat_iv_ogm.c
      batman-adv: refactor batadv_tt_local_event()
      batman-adv: don't deal with NET_IP_ALIGN manually
      batman-adv: pass a 16bit long flag argument to tt_global_add()
      batman-adv: change VID semantic in the BLA code
      batman-adv: print the VID properly
      mac80211: make mgmt_tx accept a NULL channel
      brcm80211: make mgmt_tx in brcmfmac accept a NULL channel
      ath6kl: make mgmt_tx accept a NULL channel
      nl80211: allow sending CMD_FRAME without specifying any frequency
      Revert "mac80211: in IBSS use the Auth frame to trigger STA reinsertion"
      brcm80211: fix null pointer access

Arend van Spriel (22):
      brcmfmac: allow firmware-signal tlv to be longer than specified
      brcmfmac: remove fifo bitfield from brcmf_skbuff_cb::if_flags
      brcmfmac: rework credit pickup to assure consistent handling
      brcmfmac: explicitly indicate sk_buff is sent upon request credit
      brcmfmac: reducing debug logging in firmware-signalling code
      brcmfmac: fix send_pkts statistic counter in firmware-signalling
      brcmfmac: add trace event for capturing BDC header
      brcmfmac: increment hard_header_len instead of overriding
      brcmfmac: Sent TIM information in case of data available.
      brcmfmac: free primary net_device when brcmf_bus_start() fails
      brcmfmac: add debugfs statistics for firmware-signalling
      brcmfmac: rename variable prec to more appropriate name, ie. fifo
      brcmfmac: remove dependency with nl80211.h
      brcmfmac: consolidate mac_descriptor related function names
      brcmfmac: simplify dpc handling using atomic operations
      cfg80211: fix compilation warning for cfg80211_leave_all()
      brcmfmac: simplify transmit path
      brcmfmac: remove (ab)use of NL80211_NUM_ACS
      brcmfmac: tag packet in the netdev transmit callback
      brcmfmac: cleanup debug messages in brcmf_fws_hdrpush()
      brcmfmac: reduce firmware-signalling locking scope in rx path
      brcmfmac: remove code and comment for older kernel support

Ariel Elior (5):
      bnx2x: Zero VFs starting MACs
      bnx2x: Ack unknown VF messages
      bnx2x: Improve PF behaviour toward VF
      bnx2x: VF ndo sanity
      bnx2x: improve VF timings

Arik Nemtsov (2):
      wlcore: cancel channel switch work on interface removal
      wlcore: hold jiffies in unsigned long

Arnd Bergmann (2):
      net: mv643xx_eth: add missing semicolon
      net: sun4i-emac: remove erroneous assignment

Arron Wang (2):
      NFC: pn544: Identify Type F NFC-DEP through NFCID2
      NFC: pn544: Remove Felica and Jewel device presence check

Ashok Nagarajan (3):
      mac80211: Move mesh estab_plinks outside mesh_stats debug group
      {cfg,mac}80211: move mandatory rates calculation to cfg80211
      {nl,mac,cfg}80211: Allow user to configure basic rates for mesh

Asias He (4):
      VSOCK: Introduce vsock_auto_bind helper
      VSOCK: Return VMCI_ERROR_NO_MEM when fails to allocate skb
      VSOCK: Remove unnecessary label
      VSOCK: Fix VSOCK_HASH and VSOCK_CONN_HASH

Avinash Patil (5):
      mwifiex: avoid deleting all stations during mwifiex_del_sta_entry()
      mwifiex: add del_station handler
      mwifiex: replace spin_lock_irqsave with spin_lock and fix warn_on
      mwifiex: enable/disable tx_amsdu support via module parameter
      mwifiex: Add module parameter for regdomain

Baruch Siach (1):
      net: mark netdev_create_hash __net_init

Ben Greear (6):
      mac80211: Ensure tid_start_tx is protected by sta->lock
      wireless: Make sure __cfg80211_connect_result always puts bss
      wireless: add comments about bss refcounting
      wireless: check for dangling wdev->current_bss pointer
      ath9k_htc: Support reporting tx and rx chain mask.
      ath9k_htc: Add ethtool stats support.

Ben Hutchings (12):
      sfc: Store port number in private data, not net_device::dev_id
      cxgb4: Do not set net_device::dev_id to VI index
      net: Move MII out from under NET_CORE and hide it
      at91_ether: Do not select NET_CORE
      net: Add missing dependencies on NETDEVICES
      sfc: Report software timestamping capabilities
      sfc: Define and set RX buffer flag for packets parsed as TCP
      sfc: Do not pass non-TCP packets into GRO code
      sfc: Fix IRQ cleanup in case of a probe failure
      sfc: Improve test for IOMMU in use
      cassini: Make missing firmware non-fatal
      sfc: Fix memory leak when discarding scattered packets

Benjamin Herrenschmidt (1):
      cxgb3: Missing rtnl lock in error recovery

Bing Zhao (1):
      mwifiex: abort remaining scan commands when association started

Bj√∏rn Mork (4):
      net: qmi_wwan: fixup Sierra Wireless MC8305 entry
      net: qmi_wwan: add Option GTM681W
      net: qmi_wwan: add TP-LINK MA260
      net: cdc_ether: allow combined control and data interface

Bruce Allan (2):
      e1000e: cleanup whitespace
      e1000e: prevent warning from -Wunused-parameter

Byungho An (2):
      net: stmmac: fixed operator typo
      net: stmmac: fixed enh_desc set always zero

Carolyn Wyborny (2):
      igb: Fix set_ethtool function to call update nvm for entire image
      igb: Fix possible panic caused by Rx traffic arrival while interface is down

Changli Gao (1):
      net: Swap ver and type in pppoe_hdr

Chen Gang (2):
      bridge: netfilter: using strlcpy() instead of strncpy()
      Bluetooth: hidp: using strlcpy instead of strncpy, also beautify code.

Cho, Yu-Chen (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

Chris Healy (2):
      fec: Add support to restart autonegotiate
      fec: Add support for reading RMON registers

Christian Lamparter (1):
      carl9170: add support for the new rate control API

Christoph M√ºllner (1):
      net: fec: Fix multicast list setup in fec_restart().

Claudiu Manoil (1):
      gianfar: Add backwards compatible Single Queue mode polling

Colleen Twitty (4):
      cfg80211: Userspace may inform kernel of mesh auth method.
      mac80211: enable Auth Protocol Identifier on mesh config.
      {nl,cfg}80211: make peer link expiration time configurable
      mac80211: expire mesh peers based on mesh configuration

Cong Wang (23):
      bridge: use the bridge IP addr as source addr for querier
      bridge: only expire the mdb entry when query is received
      bridge: send query as soon as leave is received
      ipv6: use ipv6_addr_any() helper
      ipv6: use ipv6_addr_scope() helper
      bonding: remove ifenslave.c from kernel source
      net: always pass struct netdev_notifier_info to netdevice notifiers
      vxlan: remove the unused rcu head from struct vxlan_rdst
      vxlan: use unsigned int instead of unsigned
      vxlan: defer vxlan init as late as possible
      net: clean up skb headers code
      icmp: avoid allocating large struct on stack
      ping: always initialize ->sin6_scope_id and ->sin6_flowinfo
      net: remove last caller of skb_tail_offset() and itself
      net: add doc for ip_early_demux sysctl
      tcp: introduce a per-route knob for quick ack
      ipv6: remove a useless pr_info() in addrconf_gre_config()
      bridge: fix a typo in comments
      doc: fix some syntax errors in netlink mmap sample code
      gre: fix a regression in ioctl
      vti: remove duplicated code to fix a memory leak
      ipip: fix a regression in ioctl
      bridge: fix some kernel warning in multicast timer

Dan Carpenter (6):
      cw1200: read beyond end of array in debug code
      cw1200: handle allocation failure in wsm_event_indication()
      ath10k: off by one sanity check
      xen-netback: double free on unload
      ipw2x00: printing the wrong array in debug code
      net/mlx4: fix small memory leak on error

Daniel Borkmann (33):
      net: ipv6: remove 'next' member from inet6_dev
      ppc: bpf_jit: can call module_free() from any context
      arm: bpf_jit: can call module_free() from any context
      doc: packet: simplify tpacket example code
      net: vlan: minor: remove unused HAVE_VLAN_PUT_TAG
      net: minor: tcp: use tcp_skb_mss helper in tcp_tso_segment
      net: tcp: move GRO/GSO functions to tcp_offload
      net: udp4: move GSO functions to udp_offload
      pktgen: ipv6: numa: consolidate skb allocation to pktgen_alloc_skb
      net: sctp: sideeffect: throw BUG if primary_path is NULL
      net: sctp: sctp_sf_do_prm_asoc: do SCTP_CMD_INIT_CHOOSE_TRANSPORT first
      net: sctp: minor: remove variable in sctp_init_sock
      net: sctp: sctp_association_init: put refs in reverse order
      net: sctp: get rid of t_new macro for kzalloc
      net: sctp: remove SCTP_STATIC macro
      net: sock: adapt SOCK_MIN_RCVBUF and SOCK_MIN_SNDBUF
      netfilter: check return code from nla_parse_tested
      net: if_arp: add ARPHRD_NETLINK type
      net: netlink: virtual tap device management
      packet: nlmon: virtual netlink monitoring device for packet sockets
      net: sctp: remove TEST_FRAME ifdef
      ktime: add ms_to_ktime() and ktime_add_ms() helpers
      net: sctp: migrate cookie life from timeval to ktime
      net: sctp: minor: sctp_seq_dump_local_addrs add missing newline
      net: sctp: decouple cleaning some socket data from endpoint
      net: sctp: simplify sctp_get_port
      nlmon: fix comparison in nlmon_is_valid_mtu
      lib: vsprintf: add IPv4/v6 generic %p[Ii]S[pfs] format specifier
      net: sctp: rework debugging framework to use pr_debug and friends
      net: sctp: get rid of SCTP_DBG_TSNS entirely
      tools: selftests: psock_tpacket: get rid of macro wrappers
      net: sctp: prevent checksum.h from double inclusion
      net: gre: move GSO functions to gre_offload

Daniel Drake (1):
      mwifiex: fix memory corruption when unsetting multicast list

Daniel Mack (1):
      drivers: net: cpsw: add newline after MACID log

Dave Jones (2):
      sctp: Convert __list_for_each use to list_for_each
      x25: Fix broken locking in ioctl error paths.

David Chang (2):
      usbnet: ax88179_178a: Correct a typo in description
      usbnet: ax88179_178a: add .reset_resume hook

David Majnemer (1):
      net: Update RFS target at poll for tcp/udp

David S. Miller (35):
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'tg3_eee'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'xen_split_event_channels'
      Merge branch 'bnx2x'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'qlcnic'
      Merge branch 'fec_regulator_suspend_resume'
      Merge branch 'mpls_gso'
      net: Fix build warnings after mac_header and transport_header became __u16.
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'netxen_nic'
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge git://git.kernel.org/.../davem/net
      sh_eth: Fix warnings on 64-bit.
      Merge branch 'll_poll'
      Merge branch 'bridge_flags'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'tipc'
      Merge git://git.kernel.org/.../davem/net
      openvswitch: gre tunneling support.
      Merge branch 'bnx2x'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      net: Restore unintentional reverts.
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'master' of git://git.kernel.org/.../shemminger/vxlan-next
      Merge branch 'l2tp_seq'
      Merge git://git.kernel.org/.../davem/net

David Spinadel (1):
      iwlwifi: remove calib channel section from PHY DB

Dmitry Kravkov (5):
      bnx2x: Link-flap avoidance in switch dependent mode
      bnx2x: Add and correct PCI link speed prints
      bnx2x: Count number of possible FCoE interfaces
      bnx2x: add support for ndo_ll_poll
      bnx2x: replace mechanism to check for next available packet

Dotan Barak (4):
      net/mlx4_en: Fix resource leak in error flow
      net/mlx4_en: Remove an unnecessary test
      net/mlx4_core: Replace sscanf() with kstrtoint()
      net/mlx4_core: Add warning in case of command timeouts

Eliad Peller (1):
      wlcore: configure rates in multiple cases

Eliezer Tamir (15):
      net: add napi_id and hash
      net: add low latency socket poll
      udp: add low latency socket poll support
      tcp: add low latency socket poll support.
      ixgbe: add support for ndo_ll_poll
      ixgbe: add extra stats for ndo_ll_poll
      net: change sysctl_net_ll_poll into an unsigned int
      net: convert low latency sockets to sched_clock()
      net: remove NET_LL_RX_POLL config menue
      net: add socket option for low latency polling
      net: poll/select low latency socket support
      net: fix LLS debug_smp_processor_id() warning
      net: avoid calling sched_clock when LLS is off
      net: convert lls to use time_in_range()
      net: lls fix build with allnoconfig

Emilio L√≥pez (4):
      net: ethernet: sun: initialize variables directly
      net: ethernet: apple: initialize variables directly
      net: ethernet: davicom: dm9000: initialize variables directly
      net: ethernet: korina: initialize variables directly

Emmanuel Grumbach (27):
      iwlwifi: move BUILD_RAxTID to transport
      iwlwifi: pcie: prefer to load the firmware in one shot
      iwlwifi: enable shadow registers for 7000
      iwlwifi: mvm: add a missing define in firmware API
      iwlwifi: constify the source buffer of iwl_trans_write_mem
      iwlwifi: mvm: use proper scan type for P2P
      iwlwifi: take valid ant for HT caps from TLV
      iwlwifi: mvm: fix the LUT for BT Coex
      iwlwifi: mvm: limit the length of the AMPDU when BT is running
      iwlwifi: mvm: don't start BA agreement when BT is active
      iwlwifi: mvm: don't enable MIMO when BT is active
      iwlwifi: mvm: reorder Rx handler for performance purposes
      iwlwifi: mvm: correctly configure MCAST in AP mode
      iwlwifi: mvm: fix MCAST in AP mode
      iwlwifi: mvm: remove unused wait_for_ba field
      iwlwifi: mvm: fix irrelevant comment
      iwlwifi: ignore 0-length PHY DB sections
      iwlwifi: mvm: properly tell the fw that a STA is awake
      iwlwifi: mvm: don't set the MCAST queue in STA's queue list
      iwlwifi: mvm: take the seqno from packet if transmit failed
      iwlwifi: mvm: remove obsolete comment
      iwlwifi: pcie: fix race in queue unmapping
      iwlwifi: pcie: wake the queue if stopped when being unmapped
      iwlwifi: remove bt_ch_announce module param
      iwlwifi: remove plcp_check module parameter
      iwlwifi: remove auto_agg module parameter
      iwlwifi: mvm: add BT-Coex LUT for 1x1 products

Enrico Mioso (1):
      qmi_wwan: add ONDA MT689DC device ID (fwd)

Eran Harary (3):
      iwlwifi: support loading NVM data from file
      iwlwifi: fix initialisation while RF-kill is asserted
      iwlwifi: don't return -ERFKILL if SEND_IF_RFKILL is set

Eric Dumazet (32):
      tcp: speedup tcp_fixup_rcvbuf()
      x86: bpf_jit_comp: can call module_free() from any context
      sparc: bpf_jit_comp: can call module_free() from any context
      x86: bpf_jit_comp: secure bpf jit against spraying attacks
      filter: do not output bpf image address for security reason
      net-bnx2x: dont reload on GRO change
      tcp: md5: remove spinlock usage in fast path
      sch_tbf: segment too big GSO packets
      netfilter: xt_CT: optimize XT_CT_NOTRACK
      netfilter: xt_socket: use IP early demux
      tcp: remove one indentation level in tcp_rcv_state_process()
      gro: should aggregate frames without DF
      bnx2x: use XPS if possible for bnx2x_select_queue instead of pure hash
      net/mlx4: use one page fragment per incoming frame
      net_sched: add 64bit rate estimators
      net_sched: psched_ratecfg_precompute() improvements
      net_sched: htb: do not setup default rate estimators
      igmp: hash a hash table to speedup ip_check_mc_rcu()
      igmp: fix new sparse errors
      gro: remove a sparse error
      udp: fix two sparse errors
      htb: reorder struct htb_class fields for performance
      htb: refactor struct htb_sched fields for performance
      netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag
      net: allow large number of tx queues
      tcp: remove invalid __rcu annotation
      ipv6: add include file to suppress sparse warnings
      mlx4: allow order-0 memory allocations in RX path
      neighbour: fix a race in neigh_destroy()
      netem: use rb tree to implement the time queue
      net: sock: fix TCP_SKB_MIN_TRUESIZE
      netem: fix possible NULL deref in netem_dequeue()

Eric Lapuyade (2):
      NFC: Add firmware upload netlink command
      NFC: HCI: Implement fw_upload ops

Erik Hugne (1):
      tipc: allow implicit connect for stream sockets

Eugenia Emantayev (3):
      net/mlx4_en: Move register_netdev() to the end of initialization function
      net/mlx4_en: Change log level from error to debug for vlan related messages
      net/mlx4_en: Fix a race between napi poll function and RX ring cleanup

Eytan Lifshitz (2):
      iwlwifi: mvm: add thermal throttling and CT kill
      iwlwifi: mvm: don't request SMPS on non-STA iface

Fabio Estevam (12):
      fec: Let device core handle pinctrl
      fec: Use DIV_ROUND_UP macro
      fec: Place the phy regulator in the private structure
      fec: Invert the order of error path sequence
      fec: Disable the PHY regulator on error and removal
      fec: Remove irqs first
      fec: Handle the regulator in suspend/resume
      can: flexcan: Let device core handle pinctrl
      can: flexcan: Use SIMPLE_DEV_PM_OPS
      fec: Only pass pdev in fec_ptp_init()
      can: flexcan: Use a regulator to control the CAN transceiver
      ARM: imx: flexcan: Remove platform file

Fan Du (1):
      xfrm: add LINUX_MIB_XFRMACQUIREERROR statistic counter

Felix Fietkau (12):
      cfg80211: add support for per-chain signal strength reporting
      mac80211: add support for per-chain signal strength reporting
      cfg80211: support an active monitor interface flag
      mac80211: support active monitor interfaces
      ath9k_hw: fix PA predistortion miscalibration
      ath9k: advertise support for active monitor interfaces
      mac80211: add a tx control flag to indicate PS-Poll/uAPSD response
      nl80211: add kernel-doc for NL80211_FEATURE_ACTIVE_MONITOR
      ath9k: add support for IEEE80211_TX_CTL_PS_RESPONSE
      ath9k: implement support for .release_buffered_frames()
      ath9k: limit multicast buffer hardware queue depth
      ath9k: fix queue depth accounting in ath_tx_txqaddbuf

Flavio Leitner (1):
      net: make all team port device link events urgent

Florian Fainelli (7):
      phy: fix the use of PHY_IGNORE_INTERRUPT
      phy: add phy_mac_interrupt() to use with PHY_IGNORE_INTERRUPT
      net: ethtool: disambiguate XCVR_* meaning
      phy: allow drivers to flag a PHY device as internal
      phy: bcm63xx: report Broadcom BCM63xx PHYs as internal
      phy: add reverse MII PHY connection type
      bcm63xx_enet: add support Broadcom BCM6345 Ethernet

Florian Westphal (5):
      netfilter: nfnetlink_queue: avoid peer_portid test
      netfilter: nfnetlink_queue: cleanup copy_range usage
      netfilter: nfnetlink_queue: only add CAP_LEN attr when needed
      netfilter: nf_conntrack: avoid large timeout for mid-stream pickup
      netfilter: nf_queue: add NFQA_SKB_CSUM_NOTVERIFIED info flag

Franky Lin (6):
      brcmfmac: remove redundant chip ID check in dhd_sdio
      brcmfmac: replace brcmf_sdioh_request_buffer with brcmf_sdio_buffrw
      brcmfmac: add sdio sg list support
      brcmfmac: remove SDIO_REQ_ASYNC flag
      brcmfmac: use unified dongle address preparation function
      brcmfmac: add broken scatter-gather DMA support

Frederic Danis (4):
      NFC: NCI: Fix skb->dev usage
      NFC: Add basic NCI over SPI
      NFC: Add NCI over SPI send
      NFC: Add NCI over SPI receive

Gabor Juhos (29):
      rt2x00: rt2x00dev: use rt2x00dev->tx->limit
      rt2x00: rt61pci: use rt2x00dev->tx->limit
      rt2x00: rt2800pci: use rt2x00dev->tx->limit
      rt2x00: rt2800usb: use rt2x00dev->rx->limit
      rt2x00: rt2800lib: use rt2x00dev->bcn->winfo_size
      rt2x00: rt2x00dev: defer operational mode detection
      rt2x00: rt2x00queue: initialize data_queue fields earlier
      rt2x00: rt2x00queue: add priv_size field to struct data_queue
      rt2x00: rt2x00queue: remove qdesc parameter of rt2x00queue_alloc_entries
      rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
      rt2x00: rt2x00queue: setup queue->threshold from queue->limit
      rt2x00: add queue_init callback to rt2x00_ops
      rt2x00: rt2800usb: implement queue_init callback
      rt2x00: rt2800pci: implement queue_init callback
      rt2x00: rt73usb: implement queue_init callback
      rt2x00: rt2400pci: implement queue_init callback
      rt2x00: rt2500pci: implement queue_init callback
      rt2x00: rt61pci: implement queue_init callback
      rt2x00: rt2500usb: implement queue_init callback
      rt2x00: remove data_queue_desc struct
      rt2x00: move extra_tx_headroom field from rt2x00_ops to rt2x00_dev
      rt2x00: rt2800usb: nuke rt2800usb_ops_5592
      rt2x00: read 5GHz TX power values from the correct offset
      rt2x00: rt2800pci: don't use TXWI_DESC_SIZE directly
      rt2x00: rt2800: unify [RT]XWI_SIZE defines
      rt2x00: rt2800: increase EEPROM_SIZE to 512 bytes
      rt2x00: rt2800lib: turn on secondary PAs/LNAs for 3T/3R devices
      rt2x00: rt2800lib: turn on tertiary PAs/LNAs for 3T/3R devices
      rt2x00: rt2800lib: fix default TX power check for RT55xx

Gao feng (5):
      netlink: Add compare function for netlink_table
      netlink: make compare exist all the time
      neigh: no need to call lookup_neigh_parms in neigh_parms_alloc
      neigh: only allow init_net to change the default neigh_parms
      neigh: disallow un-init_net to change thresh of neigh

Geert Uytterhoeven (1):
      ath6kl: Unify sg_sz and buf_sz in ath6kl_sdio_alloc_prep_scat_req()

Giuseppe CAVALLARO (2):
      stmmac: dity-up and rework the driver debug levels
      net:stmmac: fix memleak in the open method

Gustavo Padovan (1):
      Bluetooth: Improve comments on the HCI_Delete_Store_Link_Key issue

Hannes Frederic Sowa (10):
      ipv6: split duplicate address detection and router solicitation timer
      ipv6: don't disable interface if last ipv6 address is removed
      ipv6: remove old token ipv6 address as soon as possible
      ipv6: rearm router solicitaion timer when setting new tokenized address
      ipv6: introduce per-interface counter for dad-completed ipv6 addresses
      ipv6: resend MLD report if a link-local address completes DAD
      ipv6: only apply anti-spoofing checks to not-pointopoint tunnels
      ipv6: call udp_push_pending_frames when uncorking a socket with AF_INET pending data
      ipv6: ip6_append_data_mtu did not care about pmtudisc and frag_size
      ipv6: rt6_check_neigh should successfully verify neigh if no NUD information are available

Hante Meuleman (12):
      brcmfmac: Take bus flowcontrol at credit mgmt into account.
      brcmfmac: On bus flow control use fw signalling or netif.
      brcmfmac: For FW signalling it is necessary to track gen bit.
      brcmfmac: Correct creditmap when credit borrowing is active.
      brcmfmac: Find correct MAC descriptor in case of TDLS.
      brcmfmac: fix invalid ifp lookup in firmware-signalling
      brcmfmac: Accept only first creditmap event.
      brcmfmac: Signalling header push and pull on logic places.
      brcmfmac: Fix endless loop when brcmf_fws_commit_skb fails.
      brcmfmac: Simplify counting transit count.
      brcmfmac: Always use fifo_credits, also for requested credits.
      brcmfmac: Only use credits for bcmc when firmware indicates it.

Hauke Mehrtens (4):
      wil6210: fix name of tracing config option
      b43: ensue that BCMA is "y" when B43 is "y"
      bcma: activate PCI host option by default
      b43: activate N-PHY and HT-PHY support by default

Hila Gonen (2):
      iwlwifi: mvm: Add beacon filtering support
      iwlwifi: mvm: Add support for connection monitor offload

Himanshu Madhani (3):
      qlcnic: Disable INT-x interrupt for 83xx on driver unload
      qlcnic: Update IRQ name for 8200 and 8300 Series adapter.
      qlcnic: Implement GET_LED_STATUS command for 82xx adapter.

Hong zhi guo (1):
      veth: remove redundant call of dev_alloc_name

Ido Reis (1):
      wl18xx: FDSP Code RAM Corruption fix

Ilan Peer (7):
      iwlwifi: mvm: Loosen the channel context/phy context coupling
      iwlwifi: mvm: Change PHY context handling
      iwlwifi: mvm: Allow P2P Device to use an existing PHY context
      iwlwifi: mvm: Fix quota command settings
      iwlwifi: mvm: Update the supported interface combinations
      mac80211: Fix VHT bandwidth change event
      iwlwifi: mvm: Change the settings of AP beacon time

Isaku Yamahata (6):
      net, atm/ambassader: convert skb->tail into skb_tail_pointer(skb)
      net, scsi/csgb4i: convert skb->transport_header into skb_transport_header(skb)
      mv643xx_eth.c: convert skb->end into skb_end_poitner(skb)
      pxa168_eth: convert skb->end into skb_end_pointer(skb)
      staging/rtl8192u: convert skb->tail into skb_tail_pointer(skb)
      core/dev: set pkt_type after eth_type_trans() in dev_forward_skb()

Jack Morgenstein (3):
      net/mlx4_en: Do not query stats when device port is down
      net/mlx4_core: Fail device init if num_vfs is negative
      net/mlx4_core: Dynamic VST to VST vlan/qos changes

Jacob Minshall (1):
      mac80211: set mesh formation field properly

Jakub Kicinski (1):
      rt2x00pci: Use PCI MSIs whenever possible

James Chapman (3):
      l2tp: do data sequence number handling in a separate func
      l2tp: make datapath sequence number support RFC-compliant
      l2tp: make datapath resilient to packet loss when sequence numbers enabled

Jason Wang (10):
      macvtap: fix a possible race between queue selection and changing queues
      macvtap: do not add self to waitqueue if doing a nonblock read
      macvlan: switch to use IS_ENABLED()
      macvtap: introduce macvtap_get_vlan()
      macvlan: change the max number of queues to 16
      macvtap: eliminate linear search
      macvtap: add TUNSETQUEUE ioctl
      macvtap: enable multiqueue flag
      macvtap: slient sparse warnings
      macvtap: fix uninitialized return value macvtap_ioctl_set_queue()

Javier Cardona (2):
      ath9k_htc: Add support for mesh interfaces
      ath9k_htc: Claim support for mgmt frame protection

Jay Fenlason (1):
      cxgb3: Fix warning about using rcu_dereference when not in a rcu-locked section

Jay Hernandez (1):
      cxgb4: Force uninitialized state if FW_ON_ADAPTER is < FW_VERSION and we're the MASTER_PF

Jay Vosburgh (2):
      bonding: Convert hw addr handling to sync/unsync, support ucast addresses
      bonding: disallow change of MAC if fail_over_mac enabled

Jean Sacren (3):
      xfrm: simplify the exit path of xfrm_output_one()
      net: do not manually initialize enumerators
      Kconfig: remove dangling references to the deleted file

Jean-Christophe PLAGNIOL-VILLARD (1):
      net: micrel : ks8851-ml: add dt support

Jeff Mahoney (1):
      netfilter: Implement RFC 1123 for FTP conntrack

Jens Renner \(EFE\) (1):
      net: emaclite: Fix typo in error message

Jesse Gross (3):
      openvswitch: Immediately exit on error in ovs_vport_cmd_set().
      openvswitch: Remove unused get_config vport op.
      ip_tunnel: Protect tunnel functions with CONFIG_INET guard.

Jim Baxter (3):
      net: fec: Fix Transmitted bytes counter
      net: fec: Fix RMON registers on imx6
      net: fec: Add VLAN receive HW support.

Jingoo Han (14):
      net: can: at91_can: remove unnecessary platform_set_drvdata()
      net: can: c_can: remove unnecessary platform_set_drvdata()
      net: can: flexcan: remove unnecessary platform_set_drvdata()
      net: can: ti_hecc: remove unnecessary platform_set_drvdata()
      net: ethernet: use platform_{get,set}_drvdata()
      net: ethernet: remove unnecessary platform_set_drvdata()
      net: irda: remove unnecessary platform_set_drvdata()
      net: wireless: remove unnecessary platform_set_drvdata()
      net: wan: remove unnecessary platform_set_drvdata()
      net: can: replace strict_strtoul() with kstrtoul()
      net: ethernet: replace strict_strtoul() with kstrtoul()
      net: wireless: replace strict_strtoul() with kstrtoul()
      ssb: sprom: replace strict_strtoul() with kstrtoul()
      net: can: use platform_{get,set}_drvdata()

Jiri Pirko (7):
      net: add netnotifier event for upper device change
      net: pass info struct via netdevice notifier
      net: pass changed flags along with NETDEV_CHANGE event
      team: remove synchronize_rcu() called during queue override change
      team: use kfree_rcu instead of synchronize_rcu in team_port_dev
      team: remove synchronize_rcu() called during port disable
      nlmon: use standard rtnetlink link api for add/del devices

Jitendra Kalsaria (4):
      qlcnic: Convert nested if-else to switch-case
      qlcnic: Secondary unicast MAC address support.
      qlcnic: Minimize sleep duration within loopback diagnostic test.
      qlcnic: Update version to 5.2.44

Joe Perches (8):
      tcp: Remove another indentation level in tcp_rcv_state_process
      tcp: Remove 2 indentation levels in tcp_rcv_state_process
      transp_v6.h: style neatening
      cw1200: hwio: Remove an unnecessary goto
      net: Convert uses of typedef ctl_table to struct ctl_table
      ipv6: Convert use of typedef ctl_table to struct ctl_table
      ndisc: Convert use of typedef ctl_table to struct ctl_table
      xen: Use more current logging styles

Joe Stringer (1):
      core: Copy inner_protocol in copy_skb_header()

Johan Hedberg (12):
      Bluetooth: Handle LE L2CAP signalling in its own function
      Bluetooth: Rename L2CAP_CID_LE_DATA to L2CAP_CID_ATT
      Bluetooth: Fix LE vs BR/EDR selection when connecting
      Bluetooth: Fix EBUSY condition test in l2cap_chan_connect
      Bluetooth: Fix hardcoding ATT CID in __l2cap_chan_add()
      Bluetooth: Add clarifying comment to l2cap_conn_ready()
      Bluetooth: Fix duplicate call to l2cap_chan_ready()
      Bluetooth: Remove useless sk variable in l2cap_le_conn_ready
      Bluetooth: Remove unnecessary L2CAP channel state check
      Bluetooth: Simplify hci_conn_hold/drop logic for L2CAP
      Bluetooth: Remove useless hci_conn disc_timeout setting
      Bluetooth: Fix multiple LE socket handling

Johannes Berg (79):
      iwlwifi: mvm: don't assume data section is at 0x800000
      iwlwifi: pcie: dump stack on NIC error in sync commands
      iwlwifi: nvm: honour VHT enable flag
      iwlwifi: mvm: optionally store D3 SRAM after resume
      iwlwifi: mvm: sanity check context in iwl_mvm_phy_ctxt_unref()
      mac80211: fix HT beacon-based channel switch handling
      wireless: move crypto constants to ieee80211.h
      mac80211: write memcpy differently for smatch
      cfg80211: use C99 initialisers to simplify code a bit
      iwlwifi: mvm: fix NVM parsing error path
      iwlwifi: reverse DATA/INST section order
      iwlwifi: nvm: don't print NVM section reads by default
      iwlwifi: mvm: don't store section offset/length in debugfs
      iwlwifi: mvm: adjust firmware D3 configuration API
      iwlwifi: mvm: remove P2P_DEVICE support
      mac80211_hwsim: remove P2P_DEVICE support
      mac80211: assign AP_VLAN hw queues correctly
      mac80211: close AP_VLAN interfaces before unregistering all
      Merge remote-tracking branch 'mac80211/master' into mac80211-next
      cfg80211: move cfg80211_get_dev_from_ifindex under wext
      cfg80211: use atomic_t for wiphy counter
      cfg80211: vastly simplify locking
      cfg80211/mac80211: use cfg80211 wdev mutex in mac80211
      cfg80211: simplify and correct P2P-Device scan check
      regulatory: use RCU in regulatory_hint_11d()
      regulatory: remove reg_mutex
      cfg80211: remove some locked wrappers from mlme API
      cfg80211: remove some locked wrappers from sme API
      iwlwifi: move D3_CFG_COMPLETE handling into DVM
      iwlwifi: dvm: rename iwl_lib_ops to iwl_dvm_cfg
      iwlwifi: move some configuration parameters into DVM
      iwlwifi: dvm: constify configuration structs
      Merge remote-tracking branch 'iwlwifi-fixes/master' into HEAD
      cfg80211: make WoWLAN configuration available to drivers
      cfg80211: remove cleanup_work kernel-doc
      mac80211: always send multicast on CAB queue
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: implement D3 testing
      Revert "iwlwifi: mvm: remove P2P_DEVICE support"
      Revert "mac80211_hwsim: remove P2P_DEVICE support"
      mac80211: fix sdata locking around __ieee80211_request_smps
      cfg80211: take WoWLAN support information out of wiphy struct
      nl80211: remove bogus genlmsg_end() error checking
      Merge remote-tracking branch 'wireless-next/master' into HEAD
      cfg80211/mac80211: clean up cfg80211 SME APIs
      cfg80211: separate internal SME implementation
      regulatory: use proper enum return value
      cfg80211: fix potential deadlock regression
      cfg80211: make wiphy index start at 0 again
      wireless: fix kernel-doc
      iwlwifi: mvm: remove iwl_mvm_dbgfs_set_fw_dbg_log declaration
      cfg80211: fix rtnl leak in wiphy dump error cases
      iwlwifi: include export.h instead of module.h
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      mac80211: fix TX aggregation TID struct leak
      iwlwifi: make TX seqno validation more efficient
      iwlwifi: pcie: don't read INTA register in ICT IRQ handler
      iwlwifi: reduce debug ifdefs using the optimiser
      iwlwifi: mvm: mark scratch area in TX command
      iwlwifi: create opmode/device dependencies
      iwlwifi: bump required firmware API version for 3160/7260
      iwlwifi: mvm: allow firmware crashes to wake system for debug
      iwlwifi: remove testmode
      Merge remote-tracking branch 'mac80211/master' into HEAD
      nl80211: use small state buffer for wiphy_dump
      cfg80211: require passing BSS struct back to cfg80211_assoc_timeout
      cfg80211: hold BSS over association process
      iwlwifi: pcie: rework RX buffer list init and freeing
      iwlwifi: always use 'rxq' as RX queue struct name
      iwlwifi: always use 'trans_pcie' name
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      alx: treat flow control correctly in alx_set_pauseparam()
      alx: fix 100mbit/half duplex speed translation
      alx: remove NET_CORE Kconfig select
      alx: make sizes unsigned
      alx: separate link speed/duplex fields
      alx: fix MAC address alignment problem
      alx: fix ethtool support code
      alx: remove WoL support

John Greene (1):
      brcmsmac: Reduce log spam in heavy tx, make err print in debug

John W. Linville (22):
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath6kl
      Merge branch 'for-linville-ath10k' of git://github.com/kvalo/ath6kl
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'nfc-next-3.11-1' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge branch 'for-linville' of git://git.kernel.org/.../luca/wl12xx
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      ath10k: minimally handle new channel width enumeration values
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jon Cooper (2):
      sfc: Enable RX checksum offload for packets not handled by GRO
      sfc: Increase size of RX SKB header area

Jouni Malinen (2):
      cfg80211: Allow TDLS peer AID to be configured for VHT
      cfg80211: fix VHT TDLS peer AID verification

Julian Anastasov (4):
      ipvs: provide iph to schedulers
      ipvs: replace the SCTP state machine
      ipvs: drop SCTP connections depending on state
      ipvs: add sync_persist_mode flag

JunweiZhang (2):
      kernel: remove unnecessary head file
      netns: exclude ipvs from struct net when IPVS disabled

Kalle Valo (1):
      ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices

Kirshenbaum Erez (3):
      wil6210: Fix AP/PCP start flow
      wil6210: set vring index for all descriptors
      wil6210: add HW write-back option in TX descriptor

Lad, Prabhakar (3):
      net: davinci: emac: Convert to devm_* api
      net: davinci_emac: simplify the OF parser code
      net: davinci_mdio: gaurd the DT code with IS_ENABLED(CONFIG_OF)

Larry Finger (3):
      rtlwifi: rtl8192cu: Add new USB ID for TP-Link TL-WN8200ND
      rtlwifi: rtl8192cu: Fix duplicate if test
      rtlwifi: rtl8723ae: Fix typo in firmware names

Laurent Navet (1):
      drivers: net: can: grcan: use devm_ioremap_resource()

Li RongQing (2):
      cxgb3: Correct comparisons and calculations using skb->tail and skb-transport_header
      xen-netfront: use skb_partial_csum_set() to simplify the codes

Libo Chen (1):
      drivers/net/wireless/brcm80211/brcmfmac: add missing platform_driver owner

Linus L√ºssing (1):
      batman-adv: Remove unnecessary INIT_HLIST_NODE() calls

Lorand Jakab (1):
      openvswitch: fix variable names in comment

Lorenzo Colitti (7):
      net: ipv6: Add IPv6 support to the ping socket.
      Clean up indentation in net/ipv6/transp_v6.h
      net: ipv6: Unify {raw,udp}6_sock_seq_show.
      net: ipv4: make the ping /proc code AF-independent
      net: ipv6: Implement /proc/net/icmp6.
      net: ipv6: add missing lock in ping_v6_sendmsg
      net: ipv6: fix wrong ping_v6_sendmsg return value

Luciano Coelho (3):
      wlcore: some non-functional clean-ups in main.c
      wlcore: move sysfs handling to a separate file
      wl18xx: use locally administered MAC address if not available from fuse

Luis R. Rodriguez (1):
      ath: add VHT80 support for regulatory domains

Manish Chopra (7):
      qlcnic: qlcnic_get_board_name() function cleanup
      qlcnic: Enhance virtual NIC logging
      netxen_nic: Log driver version with firmware version
      netxen_nic: Log proper error message in case of mismatched adapter type
      netxen_nic: netxen_setup_intr() function code cleanup
      netxen_nic: Avoid mixed mode interrupts
      netxen_nic: Update version to 4.0.81

Marc Kleine-Budde (2):
      can: flexcan: remove HAVE_CAN_FLEXCAN Kconfig symbol
      ARM: imx: prepare for removal of flexcan_platform_data

Marcel Holtmann (1):
      nl80211: Add generic netlink module alias for cfg80211/nl80211

Marek Lindner (2):
      batman-adv: fix typos in kernel doc & comments
      batman-adv: do not print orig nodes without nc neighbors on nc table print

Mark Rutland (1):
      net: smsc911x: don't artificially limit build

Martin Hundeb√∏ll (1):
      batman-adv: Move call to batadv_nc_skb_forward() from routing.c to send.c

Masanari Iida (1):
      doc:networking: Fix typo in documentation/networking

Matthew Vick (1):
      igb: Add update to last_rx_timestamp in Rx rings

Matthias Schiffer (2):
      batman-adv: split batadv_is_wifi_iface() into two functions
      batman-adv: send each broadcast only once on non-wireless interfaces

Maxime Bizon (3):
      bcm63xx_enet: implement reset autoneg ethtool callback
      bcm63xx_enet: split DMA channel register accesses
      bcm63xx_enet: add support for Broadcom BCM63xx integrated gigabit switch

Maxime Ripard (4):
      net: Add MDIO bus driver for the Allwinner EMAC
      ARM: sun4i: Add muxing options for the ethernet controller
      ARM: sunxi: Add EMAC controller node to sun4i DTSI
      ARM: sunxi: Add EMAC Controller to Hackberry dt

Michael Chan (1):
      tg3: Prevent system hang during repeated EEH errors.

Michal Kazior (3):
      ath10k: fix MSI-X setup failpath
      ath10k: fix 5ghz channel definitions
      ath10k: leave MMIC generation to the HW

Michal Schmidt (4):
      bnx2x: remove zeroing of dump data buffer
      bnx2x: fix dump flag handling
      bnx2x: fill in sane dump flag information
      ethtool: make .get_dump_data() harder to misuse by drivers

Michal Simek (12):
      net: emaclite: Report failures in mdio setup
      net: emaclite: Support multiple phys connected to one MDIO bus
      net: emaclite: Let's make xemaclite_adjust_link static
      net: emaclite: Do not use microblaze and ppc IO functions
      net: emaclite: Enable emaclite for Xilinx Arm Zynq platform
      net: emaclite: Update driver header
      phy: Clean coding style in vitesse phy
      phy: Add Vitesse 8211 phy ID
      phy: Use macros instead of hardcoded values in marvell phy driver
      phy: Add Marvell 88E1116R phy ID
      phy: Add Marvell 88E1510 phy ID
      net: emaclite: Use platform resource table

Mike Rapoport (6):
      vxlan: add implicit fdb entry for default destination
      vxlan: introduce vxlan_fdb_find_rdst
      vxlan: introduce vxlan_fdb_parse
      vxlan: allow removal of single destination from fdb entry
      rtnetlink: allow using zero MAC address in rtnl_fdb_{add,del}
      vxlan: fdb: allow specifying multiple destinations for zero MAC

Mohammed Shafi Shajakhan (2):
      ath6kl: Rename USB driver's suspend/resume/reset_resume
      ath6kl: Fix a suspend/resume crash in AR6004 USB

Mugunthan V N (9):
      drivers: net: davinci_cpdma: remove CRC bytes from skb added by CPDMA
      drivers: net: phy: at803x code cleanup on register and unregister driver
      drivers: net: phy: at803x: seperate wol specific code to wol standard apis
      drivers: net: phy: at803x: add interface mode support
      drivers: net: phy: at803x: add support for AT8031
      ARM: OMAP2+: omap2plus_defconfig: Enable Atheros support
      ARM: dts: AM33XX: Add CPSW phy_id device tree data to am335x-evmsk
      drivers: net: ethernet: cpsw: add phy-mode support to cpsw driver
      ARM: dts: AM33XX: Add phy-mode to CPSW node

Narendra K (1):
      doc:networking: Update comment for dev_id field in netdevice.h

Nicolas Dichtel (10):
      dev: remove duplicate 'skb->dev = dev' in dev_forward_skb()
      ipv6: add support of peer address
      iptunnel: specify protocol outside IP header
      sit: add IPv4 over IPv4 support
      sit: fix an oops when IFLA_IPTUN_PROTO is not set
      sit: fix 4in4 + IPsec scenario
      dev: introduce skb_scrub_packet()
      sit: add support of x-netns
      ipv6: fix ecmp lookup when oif is specified
      sit: fix tunnel update via netlink

Nicolas Ferre (2):
      net/macb: increase RX buffer size for GEM
      net/macb: change RX path for GEM

Nikolay Aleksandrov (2):
      bonding: allow xmit hash policy change while bond dev is up
      bonding: combine pr_debugs in bond_set_dev_addr into one

Nishant Sarmukadam (1):
      mwl8k: Fix the firmware hang issue for 8764

Nithin Sujir (10):
      tg3: Add ethtool_eee struct and tg3_setup_eee()
      tg3: Add tg3_eee_pull_config() function
      tg3: Simplify tg3_phy_eee_config_ok() by reusing tg3_eee_pull_config()
      tg3: Implement set/get_eee handlers
      tg3: Split APE driver state change out of boot reset signature update
      tg3: Simplify ring control block setup
      tg3: Make tg3_rings_reset() more concise
      tg3: Use descriptive label names in tg3_start
      tg3: Fix misplaced empty line
      tg3: Remove unnecessary lock around tg3_flag_set

Nobuhiro Iwamatsu (8):
      sh_eth: remove #ifdef around EDSR and GECMR bit definitions
      sh_eth: use EDSR_ENALL to set EDSR
      sh_eth: remove duplicate sh_eth_set_duplex() definitions
      sh_eth: remove SH_ETH_HAS_TSU
      sh_eth: add IRQ flags to 'struct sh_eth_cpu_data'
      sh_eth: remove #ifdef around sh_eth_select_mii()
      sh_eth: consolidate sh_eth_reset()
      sh_eth: enclose PM code into #ifdef CONFIG_PM

Oleksij Rempel (4):
      mac80211: add STBC flag for radiotap
      ath9k: remove useless flag conversation.
      ath9k: check for Rx-STBC flag and pass it to ieee80211
      ath9k_htc: add STBC TX support

Olivier Guiter (1):
      NFC: pn533: Fix ACR122 related debug output

Oren Givon (2):
      iwlwifi: add new 7260 and 3160 series device IDs
      iwlwifi: mvm: removed an unused parameter from a function

Pablo Neira (1):
      netlink: fix splat in skb_clone with large messages

Pablo Neira Ayuso (3):
      netfilter: don't panic on error while walking through the init path
      netfilter: {ipt,ebt}_ULOG: rise warning on deprecation
      netlink: allow large data transfers from user-space

Paul Gortmaker (2):
      ibm-ethernet: delete stale MCA and duplicate PSERIES dependency
      tipc: cosmetic realignment of function arguments

Pavel Emelyanov (2):
      tun: Report "persist" flag to userspace
      tun: Turn tun_flow_init() into void fn

Peter Huewe (1):
      net/wireless/ti/wlcore/spi: Use module_spi_driver to register driver

Peter H√ºwe (19):
      net/ethernet/silan/sc92031: Use module_pci_driver to register driver
      net/ethernet/atheros/atl1c/atl1c_main: Use module_pci_driver to register driver
      net/ethernet/atheros/atl1e/atl1e_main: Use module_pci_driver to register driver
      net/ethernet/atheros/atlx/atl1: Use module_pci_driver to register driver
      net/ethernet/sis/sis190: Use module_pci_driver to register driver
      net/ethernet/dec/tulip/xircom_cb: Use module_pci_driver to register driver
      net/ethernet/toshiba/tc35815: Use module_pci_driver to register driver
      net/ethernet/icplus/ipg: Use module_pci_driver to register driver
      net/ethernet/alteon/acenic: Use module_pci_driver to register driver
      net/ethernet/broadcom/bnx2: Use module_pci_driver to register driver
      net/ethernet/broadcom/tg3: Use module_pci_driver to register driver
      net/ethernet/sgi/ioc3-eth: Use module_pci_driver to register driver
      net/ethernet/qlogic/qlge/qlge_main: Use module_pci_driver to register driver
      net/ethernet/sun/sungem: Use module_pci_driver to register driver
      net/ethernet/amd/amd8111e: Use module_pci_driver to register driver
      net/hippi/rrunner: Use module_pci_driver to register driver
      net/fddi/skfp/skfddi: Use module_pci_driver to register driver
      net/ethernet/chelsio/cxgb/cxgb2: Use module_pci_driver to register driver
      net/ethernet/nvidia/forcedeth: Use module_pci_driver to register driver

Peter Pan(ÊΩòÂç´Âπ≥) (1):
      net: pass correct parameter to skb_headers_offset_update()

Pontus Fuchs (1):
      mac80211: set IEEE80211_TX_CTL_REQ_TX_STATUS on nullframes

Pratik Pujar (2):
      qlcnic: Cleanup of structure qlcnic_hardware_context
      qlcnic: Add support for 'set driver version' in 83XX

Pravin B Shelar (20):
      openvswitch: Unify vport error stats handling.
      openvswitch: Fix struct comment.
      openvswitch: make skb->csum consistent with rest of networking stack.
      openvswitch: Simplify interface ovs_flow_metadata_from_nlattrs()
      gre: Simplify gre protocol registration locking.
      gre: Allow multiple protocol listener for gre protocol.
      gre: export gre_build_header() function.
      gre: export gre_handle_offloads() function.
      ip_tunnels: extend iptunnel_xmit()
      ip_tunnel: push generic protocol handling to ip_tunnel module.
      ip_tunnel: Add dont fragment flag.
      openvswitch: Copy individual actions.
      openvswitch: Add tunneling interface.
      openvswitch: Expand action buffer size.
      openvswitch: Optimize flow key match for non tunnel flows.
      openvswitch: Add gre tunnel support.
      openvswitch: Use correct config guard.
      vxlan: Fix sparse warnings.
      openvswitch: Add Kconfig dependency on GRE-DEMUX.
      ip_tunnels: Use skb-len to PMTU check.

Rafa≈Ç Mi≈Çecki (10):
      bcma: don't hardcode SPROM length
      bcma: prepare for supporting more SPROM sizes
      bcma: support SPROM rev 10
      bcma: update core (en|dis)abling functions
      ssb: use const for serial flash hardware table
      bcma: use const for serial flash hardware table
      ssb: add struct for serial flash
      ssb: register serial flash as platform device
      b43: replace B43_BCMA_EXTRA with modparam allhwsupport
      bcma: add support for BCM43142

Raja Mani (1):
      ath6kl: Check wmi ready event status before validating abi version

Rajesh Borundia (2):
      qlcnic: Support spoof check config.
      qlcnic: Add support for 83xx suspend and resume.

Rami Rosen (6):
      Documentation/sysctl/net.txt: fix (attribute removal).
      ] icmp: fix icmp_unreach() comment.
      doc:networking: Fix default value (icmp_ignore_bogus_error_responses).
      ipv4: remove is_data also from ip_options documentation.
      inet: frag , remove an empty ifdef.
      ipv4: remove fib_update_nh_saddrs() declaration.

Rasesh Mody (4):
      bna: Clear Driver Config Flags When HW Resets
      bna: Fix Ucast Failure Handling
      bna: Enahncement to Identify Default IOC Function
      bna: Driver and Firmware Updated

Robert P. J. Day (1):
      wireless: fix kerneldoc content in *80211.h files.

Rolf Eike Beer (1):
      ThunderLAN: remove is_eisa flag

Rony Efraim (3):
      net/core: Add VF link state control
      net/mlx4: Add VF link state support
      net/mlx4_core: Add HW enforcement to VF link state

Sachin Kamat (10):
      net/usb: r8152: Remove redundant version.h header inclusion
      net/usb: r8152: Use module_usb_driver()
      net/phy: Use module_spi_driver in spi_ks8995.c
      net: wireless: p54spi: Use module_spi_driver macro
      net: wireless: p54spi: Fix commenting style
      net: sun4i-emac: Remove redundant platform_set_drvdata()
      net: sun4i-emac: Staticize local symbols
      net: wireless: wl1251: Use module_spi_driver macro
      net: wireless: wl1251: Fix commenting style
      can: at91_can: Use of_match_ptr()

Samuel Ortiz (14):
      NFC: HCI: Follow a positive code path in the HCI ops implementations
      NFC: pn533: Use 0x3 for SENSF_REQ Time Slot Number (TSN)
      NFC: pn533: Copy NFCID2 through ATR_REQ
      NFC: Remove the static supported_se field
      NFC: Extend and fix the internal secure element API
      NFC: Add secure elements addition and removal API
      NFC: Send netlink events for secure elements additions and removals
      NFC: Remove and free all SEs when releasing an NFC device
      NFC: Add secure element enablement internal API
      NFC: Add secure element enablement netlink API
      NFC: llcp: Fix non blocking sockets connections
      NFC: llcp: Do not send pending Tx frames when the remote is not ready
      NFC: llcp: Set the LLC Link Management well known service bit
      NFC: llcp: Fix the well known services endianness

Santosh Rastapur (1):
      cxgb3: Check and handle the dma mapping errors

Sathya Perla (2):
      be2net: refactor HW workarounds in be_xmit()
      be2net: use pci_vfs_assigned()/pci_num_vf() instead of be_find_vfs()

Sebastian Hesselbarth (6):
      net: mv643xx_eth: use phy_disconnect instead of phy_detach
      net: mv643xx_eth: use managed devm_ioremap for port registers
      net: mv643xx_eth: add phy_node to platform_data struct
      net: mv643xx_eth: use of_phy_connect if phy_node present
      net: mv643xx_eth: proper initialization for Kirkwood SoCs
      net: mv643xx_eth: add DT parsing support

Sebastian Ott (1):
      qeth: use default napi weight

Sergei Shtylyov (19):
      3c59x: remove useless VORTEX_PCI() invocations
      sh_eth: create initial ID table
      sh_eth: get SH771x support out of #ifdef
      sh_eth: get SH7619 support out of #ifdef
      sh_eth: get R8A7740 support out of #ifdef
      sh_eth: get SH77{34|63} support out of #ifdef
      sh_eth: get SH7757 support out of #ifdef
      sh_eth: get SH7724 support out of #ifdef
      sh_eth: get R8A777x support out of #ifdef
      sh_eth: remove dependencies from Kconfig
      3c59x: consolidate error cleanup in vortex_init_one()
      sh_eth: split 'sh_eth_netdev_ops'
      sh_eth: remove '__maybe_unused' annotations
      sh_eth: define/use EESR_RX_CHECK macro
      sh_eth: add NAPI support
      sh_eth: remove 'tx_error_check' field of 'struct sh_eth_cpu_data'
      sh_eth: remove redundant bits from 'eesipr_value' field initializer
      sh_eth: cleanup 'enum TD_STS_BIT'
      sh_eth: get R8A7740 Rx descriptor word 0 shift out of #ifdef

Shahed Shaikh (4):
      qlcnic: Remove qlcnic_config_npars module parameter
      qlcnic: Update version to 5.2.43
      qlcnic: Handle qlcnic_alloc_mbx_args() failure
      qlcnic: Add support for PEX DMA method to read memory section of adapter dump

Shawn Bohrer (1):
      igmp: remove unnecessary in_device member zeroing

Shuah Khan (1):
      Bluetooth: Add missing reset_resume dev_pm_ops

Simon Horman (15):
      net: Loosen constraints for recalculating checksum in skb_segment()
      sched: add cond_resched_rcu() helper
      ipvs: use cond_resched_rcu() helper when walking connections
      net: Use 16bits for *_headers fields of struct skbuff
      MPLS: Add limited GSO support
      isdn: Correct comparison of skb->tail and skb-transport_header
      cxgb3: Correct comparisons and calculations using skb->tail and skb-transport_header
      net: Correct comparisons and calculations using skb->tail and skb-transport_header
      ipv6: Correct comparisons and calculations using skb->tail and skb-transport_header
      ipv4: Correct comparisons and calculations using skb->tail and skb-transport_header
      sctp: Correct access to skb->{network, transport}_header
      net, ipv4, ipv6: Correct assignment of skb->network_header to skb->tail
      sctp: Correct byte order of access to skb->{network, transport}_header
      netfilter: Correct calculation using skb->tail and skb-network_header
      sctp: Correct byte order of access to skb->{network, transport}_header

Simon Wunderlich (6):
      batman-adv: Start new development cycle
      nl80211: use attributes to parse beacons
      nl80211/cfg80211: add 5 and 10 MHz defines and wiphy flag
      nl80211: add rate flags for 5/10 Mhz channels
      mac80211: fix various components for the new 5 and 10 MHz widths
      mac80211: change IBSS channel state to chandef

Solomon Peachy (13):
      cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets
      cw1200: Fix compile with CONFIG_PM=n
      cw1200: Rename 'sbus' to 'hwbus'
      cw1200: move platform_data header to correct location.
      cw1200: Reference correct 'powerup' GPIO signal.
      cw1200: Replace use of 'struct resource' with 'int' for GPIO fields.
      cw1200: Rework SDIO platform support to prevent build problems.
      cw1200: rename the cw1200 platform definition header
      cw1200: Sanity-check arguments in copy_from_user()
      cw1200: Remove "ITP" debug subsystem.
      cw1200: Eliminate the ETF debug/engineering code.
      cw1200: Fix an assorted pile of checkpatch warnings.
      cw1200: Fix up a large pile of sparse warnings

Somnath Kotur (4):
      be2net: cleanup be_get_drvinfo()
      be2net: Pad skb to meet min Tx pkt size in lancer
      be2net: Trim padded packets for Lancer
      be2net: Implement initiate FW dump feature for Lancer

Sony Chacko (2):
      qlcnic: diagnostics routine changes
      qlcnic: modify reset recovery path in diag mode

Srinivas Kandagatla (3):
      dt:net:stmmac: Allocate platform data only if its NULL.
      dt:net:stmmac: Add support to dwmac version 3.610 and 3.710
      dt:net:stmmac: Add dt specific phy reset callback support.

Stanislaw Gruszka (37):
      rt2800: make rt2800_init_bbp return void
      rt2800: prepare for rt2800_init_bbp spit
      rt2800: add rt2800_init_bbp_305x_soc subroutine
      rt2800: move 3352 bbp specific code
      rt2800: move rt2800_bbp4_mac_if_ctrl to proper subroutines
      rt2800: initialize BBP_R31 on proper subroutines
      rt2800: initialize BBP_R47 on 3352 subroutine
      rt2800: initialize BBP_R65 & BBP_R66 on all subroutines (except 5592)
      rt2800: initialize BBP_R68 on proper subroutines
      rt2800: initialize BBP_R69 - BBP_R77 on proper subroutines
      rt2800: initialize BBP_R70 on all subroutines (except 5592)
      rt2800: initialize BBP_R74 - BBP_R80 on all subroutines (except 5592)
      rt2800: initialize BBP_R82 on all subroutines (except 5592)
      rt2800: initialize BBP_R83 on all subroutines (except 5592)
      rt2800: initialize BBP_R84 on all subroutines (except 5592)
      rt2800: initialize BBP_R86 on all subroutines (except 5592)
      rt2800: initialize BBP_R88 on proper subroutines
      rt2800: initialize BBP_R91 on all subroutines (except 5592)
      rt2800: initialize BBP_R92 on all subroutines (except 5592)
      rt2800: move initialization of BBP_95 & BBP_98 to 53xx subroutine
      rt2800: initialize BBP_R103 on all subroutines (except 5592)
      rt2800: initialize BBP_R104 on proper subroutines
      rt2800: initialize BBP_R105 on all subroutines (except 5592)
      rt2800: initialize BBP_R106 on all subroutines (except 5592)
      rt2800: initialize BBP_R120 on 3352 subroutine
      rt2800: initialize BBP_R128 on proper subroutines
      rt2800: initialize BBP_R134 & BBP_R135 on 53xx subroutine
      rt2800: initialize BBP_R104 on 3352 subroutine
      rt2800: initialize BBP_R108 on proper subroutines
      rt2800: move 3352 specific bbp initialization
      rt2800: move 3290 specific bbp initialization
      rt2800: move 53xx specific bbp initialization
      iwlegacy: small refactoring of il_{stop,wake}_queue
      iwlegacy: add il_{stop,wake}_queues_by_reason functions
      iwl4965: workaround for firmware frame tx rejection
      iwl3945: workaround for firmware frame tx rejection
      Revert "iwl4965: workaround connection regression on passive channel"

Stefan Raspl (2):
      qeth: Increase default MTU for OSA devices
      qeth: Fix crash on initial MTU size change

Stefan Roese (2):
      net: Add EMAC ethernet driver found on Allwinner A10 SoC's
      ARM: cubieboard: Enable ethernet (EMAC) support in dts

Stephen Hemminger (14):
      vxlan: fix out of order operation on module removal
      vxlan: fix crash from work pending on module removal
      vxlan: move IGMP join/leave to work queue
      vxlan: send notification when MAC migrates
      vxlan: fix race caused by dropping rtnl_unlock
      vxlan: move cleanup to uninit
      vxlan: make vxlan_xmit_one void
      vxlan: convert remotes list to list_rcu
      vxlan: port module param should be ushort
      vxlan: Use initializer for dummy structures
      vxlan: cosmetic cleanup's
      bridge: check for zero ether address in fdb add
      Merge ../vxlan-x
      vxlan: fix function name spelling

Sucheta Chakraborty (1):
      qlcnic: Initialize trans_work and idc_aen_work at VF probe.

Sujith Manoharan (37):
      ath9k: Remove MAC_DEBUG
      ath9k: Use bitops for scan flag
      ath9k: Do not use local_bh_disable in ampdu_action
      ath9k: Return early for invalid rates
      ath9k: Enable WoW only for AR9462
      ath9k: Remove unused structure ath_dbg_bb_mac_samp
      ath9k: Simplify ANI initialization
      ath9k: Set ofdmWeakSigDetect directly
      ath9k: Print ANI statistics in debugfs
      ath9k: Do not maintain ANI state per-channel
      ath9k: Fix OFDM weak signal detection for AP mode
      ath9k: Fix ANI monitoring
      ath9k: Fix ANI levels
      ath9k: Fix ofdm weak signal configuration
      ath9k: Remove redundant code
      ath9k: Remove unused ANI macros
      ath9k_hw: Assign default xlna config for AR9485
      ath9k: Fix noisefloor calibration
      ath9k: Do not assign noise for NULL caldata
      ath9k: Fix ANI trigger threshold
      ath9k: Add custom parameters for CUS198
      ath9k: Fix LNA gpio for AR9485
      ath9k: Fix ANI for AP mode
      ath9k: Merge HWTIMER debug level with BTCOEX
      ath9k: Convert a couple of debug messages
      ath9k: Update AR9462 2.0 initvals
      ath9k: Add support for 5G-XLNA/AR9462
      ath9k: Modify IDs to identify CUS230
      ath9k: Add PCI IDs for CUS217
      ath9k: Add initvals required for CUS217
      ath9k: Program initvals for CUS217
      ath9k: Enable WoW only for supported models
      ath9k: Add version macros for AR9462 2.1
      ath9k: Add initvals for AR9462 2.1
      ath9k: Program initvals for AR9462 2.1
      ath9k: Add support for AR9462 2.1
      ath9k: Add mix tx gain table for AR9462 2.0

Thierry Escande (4):
      NFC: Rename nfc_llcp_disconnect() to nfc_llcp_send_disconnect()
      NFC: Keep socket alive until the DISC PDU is actually sent
      NFC: Fix a potential memory leak
      NFC: Add a nfc hardware simulation driver

Thomas Graf (1):
      pktgen: Fix position of ip and udp header

Thomas Huehn (1):
      ath5k: make use of the new rate control API

Thomas Pedersen (7):
      ath9k: use ap style beaconing for mesh
      mac80211: don't check local mesh TTL on TX
      mac80211: fix mesh deadlock
      mac80211: update mesh beacon on workqueue
      mac80211: allow self-protected frame tx without sta
      mac80211: initialize power mode for mesh STAs
      ath9k_htc: ifdef out IFTYPE_MESH advertisement

Thomas Petazzoni (1):
      net: mvneta: read MAC address from hardware when available

Timo Ter√§s (5):
      arp: flush arp cache on IFF_NOARP change
      ipv4: properly refresh rtable entries on pmtu/redirect events
      ipv4: rate limit updating of next hop exceptions with same pmtu
      ipv4: use separate genid for next hop exceptions
      ipv4: use next hop exceptions also for input routes

Tomasz Figa (1):
      net: dm9000: Allow instantiation using device tree

Tony Prisk (3):
      net: velocity: Rename vptr->dev to vptr->netdev
      net: velocity: Convert to generic dma functions
      net: velocity: Add platform device support to VIA velocity driver

Tushar Behera (3):
      net: fec: Convert to use devm_ioremap_resource
      net: emaclite: Convert to use devm_ioremap_resource
      net: can: Convert to use devm_ioremap_resource

Ursula Braun (1):
      qeth: change default standard blkt settings for OSA

Valentin Ilie (1):
      NFC: mei_phy: Clean up file

Veaceslav Falico (10):
      bonding: trivial: remove unused parameter from alb_swap_mac_addr()
      bonding: trivial: update the comments to reflect the reality
      bonding: don't call alb_set_slave_mac_addr() while atomic
      bonding: trivial: make alb use bond_slave_has_mac()
      bonding: add helper function bond_get_targets_ip(targets, ip)
      bonding: don't add duplicate targets to arp_ip_target
      bonding: don't validate arp if we don't have to
      bonding: don't trust arp requests unless active slave really works
      bonding: doc: some details on backup slave arp validation
      bonding: add an option to fail when any of arp_ip_target is inaccessible

Victor Goldenshtein (1):
      wlcore: fix occasional AP TX stop after recovery

Vlad Yasevich (7):
      bridge: Set vlan_features to allow offloads on vlans.
      bridge: Add flag to control mac learning.
      bridge: Add a flag to control unicast packet flood.
      macvtap: Convert to using rtnl lock
      macvtap: Consistently use rcu functions
      macvtap: Let TUNSETOFFLOAD actually controll offload features.
      macvtap: Perform GSO on forwarding path.

Vladimir Kondratiev (16):
      cfg80211: add 60GHz regulatory class
      wil6210: 'length' in Tx/Rx descriptors is little endian
      wil6210: Sanity check for reported DMA length
      wil6210: debug dump packet content right after DMA
      wil6210: trace support
      wil6210: use NAPI
      wil6210: fix remaining use of non-cached copy of tx/rx descriptors
      wil6210: do not stop Tx queue on packet drop
      wil6210: channel off by 1
      wil6210: Don't use wdev->sme_state
      wil6210: fix timeout for start_pcp
      wil6210: map more FW memory
      wil6210: improve frame type reporting
      wil6210: Derive IE's for AP
      wil6210: Send EAPOL frames using normal Tx queue
      wil6210: Init Rx vring right after reset

Wedson Almeida Filho (1):
      net: Unmap fragment page once iterator is done

Wei Liu (7):
      xen-netback: remove dead code
      xen-netback: enable user to unload netback module
      xen-netfront: avoid leaking resources when setup_netfront fails
      xen-netback: split event channels support for Xen backend driver
      xen-netfront: split event channels support for Xen frontend driver
      xen: netif.h: document feature-split-event-channels
      xen-netback: xenbus.c: use more current logging styles

Wei Yongjun (13):
      wil6210: use kfree_skb() instead of kfree()
      cw1200: remove duplicated include from wsm.c
      cw1200: convert to use simple_open()
      cw1200: use module_spi_driver to simplify the code
      cw1200: remove unused including <linux/version.h>
      net: sun4i-emac: fix a typo in emac_probe()
      iwlegacy: fix error return code in il3945_pci_probe()
      Bluetooth: btmrvl: fix error return code in btmrvl_sdio_card_to_host()
      NFC: pn533: Fix error return code in pn533_probe()
      bcm63xx_enet: fix return value check in bcm_enet_shared_probe()
      ipw2200: fix error return code in ipw_load()
      net: ethernet: davinci_emac: remove redundant dev_err call in davinci_emac_probe()
      l2tp: add missing .owner to struct pppox_proto

Weiping Pan (1):
      tcp:typo unset should be unsent

Willem de Bruijn (3):
      rps: selective flow shedding during softnet overflow
      rps: document flow limit in scaling.txt
      net-rps: fixes for rps flow limit

Wolfram Sang (1):
      drivers/net/ethernet/renesas: don't check resource with devm_ioremap_resource

Wu Fengguang (1):
      net: ping_check_bind_addr() etc. can be static

Yan Burman (1):
      net/ethtool: Fix comment regarding location of dev_ethtool() call

Yaniv Rosner (2):
      bnx2x: Enable `set_phys_id' for all functions
      bnx2x: Fix 20G KR2 support claims

Yann Droneaud (1):
      sctp: use get_unused_fd_flags(0) instead of get_unused_fd()

Yevgeny Petrilin (1):
      net/mlx4_en: Add prints when TX timeout occurs

Yijing Wang (10):
      net, jme: remove redundant D0 power state set
      qlcnic: remove redundant D0 power state set
      tulip: remove redundant D0 power state set
      tg3: remove redundant pm init code
      net, ipw2x00: remove redundant D0 power state set
      Bnx2x: remove redundant D0 power state set
      amd8111e: use pdev->pm_cap instead of pci_find_capability(.., PCI_CAP_ID_PM)
      bnx2: use pdev->pm_cap instead of pci_find_capability(.., PCI_CAP_ID_PM)
      net/trivial: replace numeric with standard PM state macros
      ssb/trivial: replace numeric with standard PM state macros

Ying Xue (14):
      tipc: update code comments to reflect new uapi header path
      tipc: change socket buffer overflow control to respect sk_rcvbuf
      tipc: introduce new TIPC server infrastructure
      tipc: convert topology server to use new server facility
      tipc: convert configuration server to use new server facility
      tipc: delete code orphaned by new server infrastructure
      tipc: remove user_port instance from tipc_port structure
      tipc: rename tipc_createport_raw to tipc_createport
      tipc: convert config_lock from spinlock to mutex
      tipc: save sock structure pointer instead of void pointer to tipc_port
      tipc: enhance priority of link protocol packet
      tipc: make tipc_link_send_sections_fast exit earlier
      tipc: fix wrong return value for link_send_sections_long routine
      tipc: remove dev_base_lock use from enable_bearer

Yogesh Ashok Powar (1):
      mwifiex: add support for Marvell SD8897 chipset

Yoni Divinsky (1):
      wlcore: set default_wep_key when configured

Yuchung Cheng (6):
      tcp: remove bad timeout logic in fast recovery
      tcp: consolidate PRR packet accounting
      tcp: refactor undo functions
      tcp: fix undo on partial ack in recovery
      tcp: undo on DSACK during recovery
      tcp: properly send new data in fast recovery in first RTT

Yunlian Jiang (1):
      rtlwifi: initialize local array and set value.

Yuval Mintz (12):
      bnx2x: Add Private Flags Support
      bnx2x: Wait for MCP validity during AER
      bnx2x: Implement PCI shutdown
      bnx2x: Change to D3hot only on removal
      bnx2x: Semantic change of empty lines
      bnx2x: Revise comments and alignment
      bnx2x: Semantic removal and beautification
      bnx2x: Revise prints
      bnx2x: semi-Semantic changes
      bnx2x: fix a power state test
      bnx2x: Fix compilation with no IOV support
      bnx2x: Remove sparse and coccinelle warnings

Zhang Yanfei (1):
      ipvs: change type of netns_ipvs->sysctl_sync_qlen_max

dingtianhong (1):
      netpoll: remove return value from netpoll_rx_disable()

eytan lifshitz (1):
      iwlwifi: mvm: add thermal throttling debugging

govindarajulu.v (2):
      net: 3com: 3c509: remove unnecessary code
      mlx4: use __netdev_pick_tx instead of __skb_tx_hash in mlx4_en_select_queue

nikolay@redhat.com (3):
      bonding: remove unnecessary setup_by_slave member
      bonding: remove unnecessary dev_addr_from_first member
      bonding: when cloning a MAC use NET_ADDR_STOLEN

stephen hemminger (1):
      vxlan: listen on multiple ports

 Documentation/DocBook/80211.tmpl                               |   13 +-
 Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt |   22 +
 Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt |   26 +
 Documentation/devicetree/bindings/net/arc_emac.txt             |   38 +
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt      |    2 +
 Documentation/devicetree/bindings/net/cpsw.txt                 |    6 +
 Documentation/devicetree/bindings/net/davicom-dm9000.txt       |   26 +
 Documentation/devicetree/bindings/net/marvell-orion-net.txt    |   85 +
 Documentation/devicetree/bindings/net/micrel-ks8851.txt        |    9 +
 Documentation/devicetree/bindings/net/stmmac.txt               |   10 +
 Documentation/devicetree/bindings/net/via-velocity.txt         |   20 +
 Documentation/devicetree/bindings/vendor-prefixes.txt          |    1 +
 Documentation/networking/.gitignore                            |    1 -
 Documentation/networking/00-INDEX                              |    2 -
 Documentation/networking/Makefile                              |    5 -
 Documentation/networking/bonding.txt                           |   79 +-
 Documentation/networking/ifenslave.c                           | 1105 -------------
 Documentation/networking/ip-sysctl.txt                         |   13 +-
 Documentation/networking/ipvs-sysctl.txt                       |   13 +
 Documentation/networking/netlink_mmap.txt                      |   18 +-
 Documentation/networking/packet_mmap.txt                       |  133 +-
 Documentation/networking/scaling.txt                           |   58 +
 Documentation/printk-formats.txt                               |   32 +
 Documentation/sysctl/net.txt                                   |   41 +-
 MAINTAINERS                                                    |    5 +
 arch/alpha/include/uapi/asm/socket.h                           |    2 +
 arch/arm/boot/dts/am335x-bone.dts                              |    2 +
 arch/arm/boot/dts/am335x-evm.dts                               |    2 +
 arch/arm/boot/dts/am335x-evmsk.dts                             |   10 +
 arch/arm/boot/dts/imx28-evk.dts                                |   12 +
 arch/arm/boot/dts/sun4i-a10-cubieboard.dts                     |   15 +
 arch/arm/boot/dts/sun4i-a10-hackberry.dts                      |   41 +
 arch/arm/boot/dts/sun4i-a10.dtsi                               |   27 +
 arch/arm/configs/omap2plus_defconfig                           |    1 +
 arch/arm/mach-imx/Kconfig                                      |    4 -
 arch/arm/mach-imx/devices-imx25.h                              |    8 +-
 arch/arm/mach-imx/devices-imx35.h                              |    8 +-
 arch/arm/mach-imx/devices/Kconfig                              |    1 -
 arch/arm/mach-imx/devices/devices-common.h                     |    4 +-
 arch/arm/mach-imx/devices/platform-flexcan.c                   |    5 +-
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c                 |    2 +-
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c                 |    2 +-
 arch/arm/mach-imx/mach-mx25_3ds.c                              |    2 +-
 arch/arm/mach-imx/mach-pcm043.c                                |    2 +-
 arch/arm/mach-mxs/Kconfig                                      |    1 -
 arch/arm/mach-mxs/mach-mxs.c                                   |   50 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c                 |    2 +-
 arch/arm/mach-shmobile/clock-r8a7740.c                         |    2 +-
 arch/arm/mach-shmobile/clock-r8a7778.c                         |    2 +-
 arch/arm/mach-shmobile/clock-r8a7779.c                         |    2 +-
 arch/arm/net/bpf_jit_32.c                                      |   18 +-
 arch/avr32/include/uapi/asm/socket.h                           |    2 +
 arch/cris/arch-v10/drivers/Kconfig                             |    4 +-
 arch/cris/arch-v32/drivers/Kconfig                             |    4 +-
 arch/cris/include/uapi/asm/socket.h                            |    2 +
 arch/frv/include/uapi/asm/socket.h                             |    2 +
 arch/h8300/include/uapi/asm/socket.h                           |    2 +
 arch/ia64/hp/sim/simeth.c                                      |    2 +-
 arch/ia64/include/uapi/asm/socket.h                            |    2 +
 arch/m32r/include/uapi/asm/socket.h                            |    2 +
 arch/mips/bcm63xx/boards/board_bcm963xx.c                      |    4 +
 arch/mips/bcm63xx/dev-enet.c                                   |  181 ++-
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_cpu.h               |    7 +-
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_enet.h          |  122 ++
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h              |   93 +-
 arch/mips/include/asm/mach-bcm63xx/board_bcm963xx.h            |    2 +
 arch/mips/include/uapi/asm/socket.h                            |    2 +
 arch/mips/txx9/generic/setup_tx4939.c                          |    3 +-
 arch/mn10300/include/uapi/asm/socket.h                         |    2 +
 arch/parisc/include/uapi/asm/socket.h                          |    2 +
 arch/powerpc/Kconfig                                           |    1 -
 arch/powerpc/include/uapi/asm/socket.h                         |    2 +
 arch/powerpc/net/bpf_jit_comp.c                                |   19 +-
 arch/s390/include/uapi/asm/socket.h                            |    2 +
 arch/sh/boards/board-espt.c                                    |    2 +-
 arch/sh/boards/board-sh7757lcr.c                               |    8 +-
 arch/sh/boards/mach-ecovec24/setup.c                           |    4 +-
 arch/sh/boards/mach-se/770x/setup.c                            |    8 +-
 arch/sh/boards/mach-se/7724/setup.c                            |    4 +-
 arch/sh/boards/mach-sh7763rdp/setup.c                          |    2 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c                          |    4 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c                         |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7734.c                         |    2 +-
 arch/sparc/include/uapi/asm/socket.h                           |    2 +
 arch/sparc/net/bpf_jit_comp.c                                  |   20 +-
 arch/x86/net/bpf_jit_comp.c                                    |   61 +-
 arch/xtensa/include/uapi/asm/socket.h                          |    2 +
 drivers/atm/ambassador.c                                       |    2 +-
 drivers/bcma/Kconfig                                           |    1 +
 drivers/bcma/bcma_private.h                                    |    2 +
 drivers/bcma/core.c                                            |   28 +-
 drivers/bcma/driver_chipcommon.c                               |   11 +-
 drivers/bcma/driver_chipcommon_pmu.c                           |  123 ++
 drivers/bcma/driver_chipcommon_sflash.c                        |    8 +-
 drivers/bcma/host_pci.c                                        |    1 +
 drivers/bcma/main.c                                            |   19 +
 drivers/bcma/sprom.c                                           |   72 +-
 drivers/bluetooth/btmrvl_sdio.c                                |    1 +
 drivers/bluetooth/btusb.c                                      |    4 +
 drivers/infiniband/core/cma.c                                  |    4 +-
 drivers/infiniband/hw/mlx4/main.c                              |    2 +-
 drivers/isdn/i4l/isdn_net.c                                    |    2 +-
 drivers/net/Kconfig                                            |   20 +-
 drivers/net/Makefile                                           |    1 +
 drivers/net/bonding/bond_alb.c                                 |   99 +-
 drivers/net/bonding/bond_main.c                                |  290 ++--
 drivers/net/bonding/bond_sysfs.c                               |  133 +-
 drivers/net/bonding/bonding.h                                  |   49 +-
 drivers/net/can/Kconfig                                        |    5 +-
 drivers/net/can/at91_can.c                                     |    8 +-
 drivers/net/can/bfin_can.c                                     |   10 +-
 drivers/net/can/c_can/c_can_platform.c                         |    6 +-
 drivers/net/can/cc770/cc770_isa.c                              |    5 +-
 drivers/net/can/cc770/cc770_platform.c                         |    4 +-
 drivers/net/can/flexcan.c                                      |   52 +-
 drivers/net/can/grcan.c                                        |   12 +-
 drivers/net/can/janz-ican3.c                                   |    2 +-
 drivers/net/can/led.c                                          |    4 +-
 drivers/net/can/mscan/mpc5xxx_can.c                            |   10 +-
 drivers/net/can/sja1000/sja1000_isa.c                          |    5 +-
 drivers/net/can/sja1000/sja1000_of_platform.c                  |    6 +-
 drivers/net/can/sja1000/sja1000_platform.c                     |    5 +-
 drivers/net/can/slcan.c                                        |    2 +-
 drivers/net/can/softing/softing_main.c                         |    2 +-
 drivers/net/can/ti_hecc.c                                      |    1 -
 drivers/net/ethernet/3com/3c509.c                              |   19 -
 drivers/net/ethernet/3com/3c59x.c                              |   42 +-
 drivers/net/ethernet/3com/Kconfig                              |    1 -
 drivers/net/ethernet/8390/ne.c                                 |    1 -
 drivers/net/ethernet/8390/ne2k-pci.c                           |    2 +-
 drivers/net/ethernet/Kconfig                                   |    6 +-
 drivers/net/ethernet/Makefile                                  |    2 +
 drivers/net/ethernet/adaptec/Kconfig                           |    1 -
 drivers/net/ethernet/adi/Kconfig                               |    1 -
 drivers/net/ethernet/adi/bfin_mac.c                            |    4 -
 drivers/net/ethernet/aeroflex/greth.c                          |    4 +-
 drivers/net/ethernet/allwinner/Kconfig                         |   35 +
 drivers/net/ethernet/allwinner/Makefile                        |    5 +
 drivers/net/ethernet/allwinner/sun4i-emac.c                    |  954 +++++++++++
 drivers/net/ethernet/allwinner/sun4i-emac.h                    |  108 ++
 drivers/net/ethernet/alteon/acenic.c                           |   15 +-
 drivers/net/ethernet/amd/Kconfig                               |    2 -
 drivers/net/ethernet/amd/amd8111e.c                            |   19 +-
 drivers/net/ethernet/amd/au1000_eth.c                          |    2 -
 drivers/net/ethernet/amd/sunlance.c                            |    6 +-
 drivers/net/ethernet/apple/bmac.c                              |    5 +-
 drivers/net/ethernet/arc/Kconfig                               |   31 +
 drivers/net/ethernet/arc/Makefile                              |    6 +
 drivers/net/ethernet/arc/emac.h                                |  214 +++
 drivers/net/ethernet/arc/emac_main.c                           |  819 ++++++++++
 drivers/net/ethernet/arc/emac_mdio.c                           |  152 ++
 drivers/net/ethernet/atheros/Kconfig                           |    5 -
 drivers/net/ethernet/atheros/alx/alx.h                         |    8 +-
 drivers/net/ethernet/atheros/alx/ethtool.c                     |  132 +-
 drivers/net/ethernet/atheros/alx/hw.c                          |  212 +--
 drivers/net/ethernet/atheros/alx/hw.h                          |   25 +-
 drivers/net/ethernet/atheros/alx/main.c                        |  173 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c                |   25 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c                |   25 +-
 drivers/net/ethernet/atheros/atlx/atl1.c                       |   27 +-
 drivers/net/ethernet/broadcom/Kconfig                          |    2 -
 drivers/net/ethernet/broadcom/bcm63xx_enet.c                   | 1188 ++++++++++++--
 drivers/net/ethernet/broadcom/bcm63xx_enet.h                   |   86 +
 drivers/net/ethernet/broadcom/bnx2.c                           |   18 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                    |  185 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                |  211 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                |   75 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c                |   52 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h                |    3 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dump.h               |    7 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c            |  115 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h                |    5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c               |  687 +++++---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h                |    6 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c                 |  284 ++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h                 |   55 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c              |   89 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h              |    9 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c              |    1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h              |    4 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c               |   33 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h               |    5 +-
 drivers/net/ethernet/broadcom/cnic.c                           |    2 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c                     |    9 +-
 drivers/net/ethernet/broadcom/tg3.c                            |  425 +++--
 drivers/net/ethernet/broadcom/tg3.h                            |    2 +
 drivers/net/ethernet/brocade/bna/bfa_defs.h                    |    3 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c                     |    7 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.h                     |    2 +
 drivers/net/ethernet/brocade/bna/bna.h                         |    2 +
 drivers/net/ethernet/brocade/bna/bna_enet.c                    |    7 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c                   |   15 +
 drivers/net/ethernet/brocade/bna/bnad.c                        |    3 +
 drivers/net/ethernet/brocade/bna/bnad.h                        |    2 +-
 drivers/net/ethernet/brocade/bna/cna.h                         |    4 +-
 drivers/net/ethernet/cadence/Kconfig                           |    1 -
 drivers/net/ethernet/cadence/at91_ether.c                      |    1 -
 drivers/net/ethernet/cadence/macb.c                            |  325 +++-
 drivers/net/ethernet/cadence/macb.h                            |   14 +
 drivers/net/ethernet/calxeda/xgmac.c                           |    2 -
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c                      |   15 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c                |    2 +
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_offload.c             |    9 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c                       |  116 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                     |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                |   27 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                       |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                     |   10 +-
 drivers/net/ethernet/cirrus/Kconfig                            |    1 -
 drivers/net/ethernet/cirrus/ep93xx_eth.c                       |    1 -
 drivers/net/ethernet/davicom/Kconfig                           |    1 -
 drivers/net/ethernet/davicom/dm9000.c                          |   53 +-
 drivers/net/ethernet/dec/tulip/Kconfig                         |    1 -
 drivers/net/ethernet/dec/tulip/tulip_core.c                    |    6 -
 drivers/net/ethernet/dec/tulip/xircom_cb.c                     |   14 +-
 drivers/net/ethernet/dlink/Kconfig                             |    1 -
 drivers/net/ethernet/emulex/benet/be.h                         |    4 +
 drivers/net/ethernet/emulex/benet/be_cmds.c                    |   66 +
 drivers/net/ethernet/emulex/benet/be_cmds.h                    |    3 +
 drivers/net/ethernet/emulex/benet/be_ethtool.c                 |   37 +-
 drivers/net/ethernet/emulex/benet/be_hw.h                      |    2 +
 drivers/net/ethernet/emulex/benet/be_main.c                    |  150 +-
 drivers/net/ethernet/ethoc.c                                   |    2 -
 drivers/net/ethernet/faraday/Kconfig                           |    1 -
 drivers/net/ethernet/faraday/ftgmac100.c                       |    2 -
 drivers/net/ethernet/faraday/ftmac100.c                        |    2 -
 drivers/net/ethernet/freescale/fec.h                           |   61 +-
 drivers/net/ethernet/freescale/fec_main.c                      |  254 ++-
 drivers/net/ethernet/freescale/fec_mpc52xx.c                   |    9 +-
 drivers/net/ethernet/freescale/fec_ptp.c                       |    3 +-
 drivers/net/ethernet/freescale/fs_enet/Kconfig                 |    1 -
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c          |    5 +-
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c           |    6 +-
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c               |    6 +-
 drivers/net/ethernet/freescale/gianfar.c                       |   57 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c                   |    4 +-
 drivers/net/ethernet/freescale/ucc_geth.c                      |    4 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c                    |    4 +-
 drivers/net/ethernet/ibm/Kconfig                               |    3 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c                      |    4 +-
 drivers/net/ethernet/ibm/emac/mal.c                            |    6 +-
 drivers/net/ethernet/ibm/emac/rgmii.c                          |   18 +-
 drivers/net/ethernet/ibm/emac/tah.c                            |   14 +-
 drivers/net/ethernet/ibm/emac/zmii.c                           |   18 +-
 drivers/net/ethernet/icplus/Kconfig                            |    1 -
 drivers/net/ethernet/icplus/ipg.c                              |   13 +-
 drivers/net/ethernet/intel/Kconfig                             |    1 -
 drivers/net/ethernet/intel/e100.c                              |    4 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.c                |   24 +-
 drivers/net/ethernet/intel/e1000e/82571.c                      |   30 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c                    |   34 +-
 drivers/net/ethernet/intel/e1000e/hw.h                         |   34 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                    |   62 +-
 drivers/net/ethernet/intel/e1000e/netdev.c                     |   55 +-
 drivers/net/ethernet/intel/e1000e/nvm.c                        |    1 -
 drivers/net/ethernet/intel/e1000e/phy.c                        |   22 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                   |  120 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h                 |   36 +-
 drivers/net/ethernet/intel/igb/e1000_hw.h                      |    2 +
 drivers/net/ethernet/intel/igb/e1000_i210.h                    |    6 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c                     |   45 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c                     |  124 ++
 drivers/net/ethernet/intel/igb/e1000_phy.h                     |   20 +
 drivers/net/ethernet/intel/igb/igb.h                           |   14 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c                   |   74 +-
 drivers/net/ethernet/intel/igb/igb_main.c                      |    9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                       |  134 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.c                   |   23 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb.h                   |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82599.h             |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c                |    3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c               |   40 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                   |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |   69 +-
 drivers/net/ethernet/jme.c                                     |    1 -
 drivers/net/ethernet/korina.c                                  |    7 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c                     |  200 ++-
 drivers/net/ethernet/marvell/mvneta.c                          |   46 +-
 drivers/net/ethernet/marvell/pxa168_eth.c                      |    3 +-
 drivers/net/ethernet/marvell/skge.c                            |    2 +-
 drivers/net/ethernet/marvell/sky2.c                            |    2 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c                       |  196 ++-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c                     |    3 +
 drivers/net/ethernet/mellanox/mlx4/en_dcb_nl.c                 |    3 -
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                |   20 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c                   |    2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                 |   88 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                     |  184 ++-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                     |    2 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c                        |    9 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                        |   13 +-
 drivers/net/ethernet/mellanox/mlx4/main.c                      |   11 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                      |   22 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                   |  145 +-
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c          |  163 +-
 drivers/net/ethernet/micrel/Kconfig                            |    4 -
 drivers/net/ethernet/micrel/ks8695net.c                        |    1 -
 drivers/net/ethernet/micrel/ks8842.c                           |    1 -
 drivers/net/ethernet/micrel/ks8851_mll.c                       |   34 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c               |    2 +-
 drivers/net/ethernet/netx-eth.c                                |    5 +-
 drivers/net/ethernet/nuvoton/Kconfig                           |    1 -
 drivers/net/ethernet/nuvoton/w90p910_ether.c                   |    2 -
 drivers/net/ethernet/nvidia/forcedeth.c                        |   17 +-
 drivers/net/ethernet/nxp/lpc_eth.c                             |    2 -
 drivers/net/ethernet/octeon/octeon_mgmt.c                      |    4 +-
 drivers/net/ethernet/oki-semi/pch_gbe/Kconfig                  |    1 -
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h                |    2 +
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_api.c            |   70 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c        |    2 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c           |  327 ++--
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c          |   63 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c            |   26 +-
 drivers/net/ethernet/packetengines/Kconfig                     |    1 -
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h                |   14 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hdr.h            |    3 +
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c           |  133 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                    |   59 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c            |  346 +++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h            |   13 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c          |   59 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c          |   62 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c                |  172 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c            |    6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hdr.h                |    1 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c                 |  103 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h                 |    8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c               |  226 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c           |  225 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h              |    4 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c       |   60 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c           |   36 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c              |  126 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                   |   13 +-
 drivers/net/ethernet/rdc/Kconfig                               |    1 -
 drivers/net/ethernet/realtek/8139cp.c                          |    2 +-
 drivers/net/ethernet/realtek/Kconfig                           |    3 -
 drivers/net/ethernet/renesas/Kconfig                           |    7 -
 drivers/net/ethernet/renesas/sh_eth.c                          |  521 +++---
 drivers/net/ethernet/renesas/sh_eth.h                          |   29 +-
 drivers/net/ethernet/s6gmac.c                                  |    1 -
 drivers/net/ethernet/seeq/sgiseeq.c                            |    1 -
 drivers/net/ethernet/sfc/efx.c                                 |   42 +-
 drivers/net/ethernet/sfc/efx.h                                 |    1 +
 drivers/net/ethernet/sfc/ethtool.c                             |   16 +-
 drivers/net/ethernet/sfc/filter.c                              |   15 +-
 drivers/net/ethernet/sfc/net_driver.h                          |    5 +-
 drivers/net/ethernet/sfc/nic.c                                 |   74 +-
 drivers/net/ethernet/sfc/nic.h                                 |    4 +-
 drivers/net/ethernet/sfc/ptp.c                                 |   13 +-
 drivers/net/ethernet/sfc/rx.c                                  |   35 +-
 drivers/net/ethernet/sfc/siena.c                               |    2 +-
 drivers/net/ethernet/sgi/Kconfig                               |    1 -
 drivers/net/ethernet/sgi/ioc3-eth.c                            |   14 +-
 drivers/net/ethernet/sgi/meth.c                                |    1 -
 drivers/net/ethernet/silan/sc92031.c                           |   14 +-
 drivers/net/ethernet/sis/Kconfig                               |    2 -
 drivers/net/ethernet/sis/sis190.c                              |   13 +-
 drivers/net/ethernet/smsc/Kconfig                              |    7 +-
 drivers/net/ethernet/smsc/smc911x.c                            |    2 -
 drivers/net/ethernet/smsc/smc91x.c                             |    3 -
 drivers/net/ethernet/smsc/smsc911x.c                           |    2 -
 drivers/net/ethernet/stmicro/stmmac/Kconfig                    |    1 -
 drivers/net/ethernet/stmicro/stmmac/common.h                   |   10 -
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c           |   57 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c            |   10 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c            |    4 -
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c             |    8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c                |   72 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c                 |   95 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c                |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |  160 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c              |   48 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c          |   34 +-
 drivers/net/ethernet/sun/cassini.c                             |   18 +-
 drivers/net/ethernet/sun/niu.c                                 |    5 +-
 drivers/net/ethernet/sun/sunbmac.c                             |    6 +-
 drivers/net/ethernet/sun/sungem.c                              |   13 +-
 drivers/net/ethernet/sun/sunhme.c                              |    4 +-
 drivers/net/ethernet/sun/sunqe.c                               |   10 +-
 drivers/net/ethernet/ti/cpsw.c                                 |    7 +-
 drivers/net/ethernet/ti/davinci_cpdma.c                        |    5 +
 drivers/net/ethernet/ti/davinci_emac.c                         |  119 +-
 drivers/net/ethernet/ti/davinci_mdio.c                         |    5 +-
 drivers/net/ethernet/ti/tlan.c                                 |    3 +-
 drivers/net/ethernet/ti/tlan.h                                 |    1 -
 drivers/net/ethernet/toshiba/tc35815.c                         |   14 +-
 drivers/net/ethernet/tundra/tsi108_eth.c                       |    1 -
 drivers/net/ethernet/via/Kconfig                               |    5 +-
 drivers/net/ethernet/via/via-velocity.c                        |  507 ++++--
 drivers/net/ethernet/via/via-velocity.h                        |    8 +-
 drivers/net/ethernet/wiznet/w5100.c                            |    2 -
 drivers/net/ethernet/wiznet/w5300.c                            |    2 -
 drivers/net/ethernet/xilinx/Kconfig                            |    4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c                    |    5 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c              |    6 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c                  |  236 ++-
 drivers/net/ethernet/xscale/ixp4xx_eth.c                       |    2 -
 drivers/net/fddi/skfp/skfddi.c                                 |   13 +-
 drivers/net/hamradio/bpqether.c                                |    7 +-
 drivers/net/hippi/rrunner.c                                    |   13 +-
 drivers/net/irda/bfin_sir.c                                    |    1 -
 drivers/net/irda/sh_irda.c                                     |    1 -
 drivers/net/irda/sh_sir.c                                      |    1 -
 drivers/net/macvlan.c                                          |   12 +-
 drivers/net/macvtap.c                                          |  341 +++-
 drivers/net/netconsole.c                                       |    5 +-
 drivers/net/nlmon.c                                            |  181 +++
 drivers/net/phy/Kconfig                                        |   10 +
 drivers/net/phy/Makefile                                       |    1 +
 drivers/net/phy/at803x.c                                       |  128 +-
 drivers/net/phy/bcm63xx.c                                      |    4 +-
 drivers/net/phy/marvell.c                                      |  108 +-
 drivers/net/phy/mdio-sun4i.c                                   |  194 +++
 drivers/net/phy/phy.c                                          |   26 +-
 drivers/net/phy/phy_device.c                                   |   11 +-
 drivers/net/phy/spi_ks8995.c                                   |   14 +-
 drivers/net/phy/vitesse.c                                      |   38 +-
 drivers/net/ppp/pppoe.c                                        |    2 +-
 drivers/net/team/team.c                                        |   86 +-
 drivers/net/team/team_mode_loadbalance.c                       |    3 +-
 drivers/net/team/team_mode_roundrobin.c                        |    3 +-
 drivers/net/tun.c                                              |   12 +-
 drivers/net/usb/Kconfig                                        |    4 -
 drivers/net/usb/ax88179_178a.c                                 |    5 +-
 drivers/net/usb/cdc_ether.c                                    |   22 +-
 drivers/net/usb/ipheth.c                                       |    5 +
 drivers/net/usb/kalmia.c                                       |   45 +-
 drivers/net/usb/qmi_wwan.c                                     |    4 +-
 drivers/net/usb/r8152.c                                        |   14 +-
 drivers/net/veth.c                                             |    7 -
 drivers/net/vxlan.c                                            |  788 +++++----
 drivers/net/wan/dlci.c                                         |    2 +-
 drivers/net/wan/hdlc.c                                         |    2 +-
 drivers/net/wan/ixp4xx_hss.c                                   |    1 -
 drivers/net/wan/lapbether.c                                    |    2 +-
 drivers/net/wireless/Kconfig                                   |    1 +
 drivers/net/wireless/Makefile                                  |    2 +
 drivers/net/wireless/ath/Kconfig                               |    1 +
 drivers/net/wireless/ath/Makefile                              |    1 +
 drivers/net/wireless/ath/ath.h                                 |   13 +-
 drivers/net/wireless/ath/ath10k/Kconfig                        |   39 +
 drivers/net/wireless/ath/ath10k/Makefile                       |   20 +
 drivers/net/wireless/ath/ath10k/bmi.c                          |  295 ++++
 drivers/net/wireless/ath/ath10k/bmi.h                          |  224 +++
 drivers/net/wireless/ath/ath10k/ce.c                           | 1189 ++++++++++++++
 drivers/net/wireless/ath/ath10k/ce.h                           |  516 ++++++
 drivers/net/wireless/ath/ath10k/core.c                         |  665 ++++++++
 drivers/net/wireless/ath/ath10k/core.h                         |  369 +++++
 drivers/net/wireless/ath/ath10k/debug.c                        |  503 ++++++
 drivers/net/wireless/ath/ath10k/debug.h                        |   90 +
 drivers/net/wireless/ath/ath10k/hif.h                          |  137 ++
 drivers/net/wireless/ath/ath10k/htc.c                          | 1000 ++++++++++++
 drivers/net/wireless/ath/ath10k/htc.h                          |  368 +++++
 drivers/net/wireless/ath/ath10k/htt.c                          |  152 ++
 drivers/net/wireless/ath/ath10k/htt.h                          | 1338 +++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c                       | 1167 +++++++++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c                       |  510 ++++++
 drivers/net/wireless/ath/ath10k/hw.h                           |  304 ++++
 drivers/net/wireless/ath/ath10k/mac.c                          | 3069 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h                          |   61 +
 drivers/net/wireless/ath/ath10k/pci.c                          | 2507 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/pci.h                          |  355 ++++
 drivers/net/wireless/ath/ath10k/rx_desc.h                      |  990 +++++++++++
 drivers/net/wireless/ath/ath10k/targaddrs.h                    |  449 +++++
 drivers/net/wireless/ath/ath10k/trace.c                        |   20 +
 drivers/net/wireless/ath/ath10k/trace.h                        |  170 ++
 drivers/net/wireless/ath/ath10k/txrx.c                         |  417 +++++
 drivers/net/wireless/ath/ath10k/txrx.h                         |   39 +
 drivers/net/wireless/ath/ath10k/wmi.c                          | 2081 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h                          | 3052 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/ahb.c                           |    2 -
 drivers/net/wireless/ath/ath5k/base.c                          |   79 +-
 drivers/net/wireless/ath/ath5k/base.h                          |   14 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c                  |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                     |   51 +-
 drivers/net/wireless/ath/ath6kl/debug.c                        |    8 +-
 drivers/net/wireless/ath/ath6kl/init.c                         |   14 +-
 drivers/net/wireless/ath/ath6kl/sdio.c                         |   12 +-
 drivers/net/wireless/ath/ath6kl/usb.c                          |   36 +-
 drivers/net/wireless/ath/ath9k/Kconfig                         |    8 -
 drivers/net/wireless/ath/ath9k/ahb.c                           |    2 -
 drivers/net/wireless/ath/ath9k/ani.c                           |   89 +-
 drivers/net/wireless/ath/ath9k/ani.h                           |   23 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c                    |    6 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c                     |    4 -
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h               |   14 -
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c                 |   33 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c                     |   80 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c                    |    5 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c                  |   19 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                    |  107 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h                    |    6 +-
 drivers/net/wireless/ath/ath9k/ar9462_2p0_initvals.h           |  345 +++-
 drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h           | 1774 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h                         |   16 +-
 drivers/net/wireless/ath/ath9k/beacon.c                        |   31 +-
 drivers/net/wireless/ath/ath9k/calib.c                         |    1 -
 drivers/net/wireless/ath/ath9k/debug.c                         |  430 +----
 drivers/net/wireless/ath/ath9k/debug.h                         |   59 -
 drivers/net/wireless/ath/ath9k/dfs_debug.c                     |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c                       |    8 +-
 drivers/net/wireless/ath/ath9k/htc.h                           |   24 +
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c                |    5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c                 |   99 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                  |   17 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c                  |   81 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c                  |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                            |   28 +-
 drivers/net/wireless/ath/ath9k/hw.h                            |   20 +-
 drivers/net/wireless/ath/ath9k/init.c                          |   66 +-
 drivers/net/wireless/ath/ath9k/link.c                          |    9 +-
 drivers/net/wireless/ath/ath9k/mac.c                           |   16 +-
 drivers/net/wireless/ath/ath9k/mac.h                           |    4 +-
 drivers/net/wireless/ath/ath9k/main.c                          |   55 +-
 drivers/net/wireless/ath/ath9k/pci.c                           |  101 ++
 drivers/net/wireless/ath/ath9k/recv.c                          |    9 +-
 drivers/net/wireless/ath/ath9k/reg.h                           |   13 +-
 drivers/net/wireless/ath/ath9k/wow.c                           |  168 +-
 drivers/net/wireless/ath/ath9k/xmit.c                          |  343 +++-
 drivers/net/wireless/ath/carl9170/carl9170.h                   |    3 +
 drivers/net/wireless/ath/carl9170/main.c                       |    3 +
 drivers/net/wireless/ath/carl9170/tx.c                         |  182 ++-
 drivers/net/wireless/ath/regd.c                                |    6 +-
 drivers/net/wireless/ath/wil6210/Kconfig                       |   12 +
 drivers/net/wireless/ath/wil6210/Makefile                      |   21 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c                    |   38 +-
 drivers/net/wireless/ath/wil6210/debug.c                       |   69 +
 drivers/net/wireless/ath/wil6210/debugfs.c                     |    8 +-
 drivers/net/wireless/ath/wil6210/interrupt.c                   |   29 +-
 drivers/net/wireless/ath/wil6210/main.c                        |   64 +-
 drivers/net/wireless/ath/wil6210/netdev.c                      |   54 +
 drivers/net/wireless/ath/wil6210/trace.c                       |   20 +
 drivers/net/wireless/ath/wil6210/trace.h                       |  235 +++
 drivers/net/wireless/ath/wil6210/txrx.c                        |  205 ++-
 drivers/net/wireless/ath/wil6210/txrx.h                        |   36 +-
 drivers/net/wireless/ath/wil6210/wil6210.h                     |   28 +-
 drivers/net/wireless/ath/wil6210/wmi.c                         |   60 +-
 drivers/net/wireless/b43/Kconfig                               |   12 +-
 drivers/net/wireless/b43/main.c                                |   12 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c               |  302 +++-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c         |  117 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h                  |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c              |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c              |   18 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h              |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c            |   52 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c             |  176 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h                 |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c             |  943 +++++------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h             |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h            |   20 +-
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h           |   21 +
 drivers/net/wireless/brcm80211/brcmfmac/usb.c                  |    8 +
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c          |   18 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c                |    2 +-
 drivers/net/wireless/cw1200/Kconfig                            |   30 +
 drivers/net/wireless/cw1200/Makefile                           |   21 +
 drivers/net/wireless/cw1200/bh.c                               |  619 +++++++
 drivers/net/wireless/cw1200/bh.h                               |   28 +
 drivers/net/wireless/cw1200/cw1200.h                           |  323 ++++
 drivers/net/wireless/cw1200/cw1200_sdio.c                      |  425 +++++
 drivers/net/wireless/cw1200/cw1200_spi.c                       |  471 ++++++
 drivers/net/wireless/cw1200/debug.c                            |  428 +++++
 drivers/net/wireless/cw1200/debug.h                            |   93 ++
 drivers/net/wireless/cw1200/fwio.c                             |  520 ++++++
 drivers/net/wireless/cw1200/fwio.h                             |   39 +
 drivers/net/wireless/cw1200/hwbus.h                            |   33 +
 drivers/net/wireless/cw1200/hwio.c                             |  312 ++++
 drivers/net/wireless/cw1200/hwio.h                             |  247 +++
 drivers/net/wireless/cw1200/main.c                             |  605 +++++++
 drivers/net/wireless/cw1200/pm.c                               |  367 +++++
 drivers/net/wireless/cw1200/pm.h                               |   43 +
 drivers/net/wireless/cw1200/queue.c                            |  583 +++++++
 drivers/net/wireless/cw1200/queue.h                            |  116 ++
 drivers/net/wireless/cw1200/scan.c                             |  461 ++++++
 drivers/net/wireless/cw1200/scan.h                             |   56 +
 drivers/net/wireless/cw1200/sta.c                              | 2403 +++++++++++++++++++++++++++
 drivers/net/wireless/cw1200/sta.h                              |  123 ++
 drivers/net/wireless/cw1200/txrx.c                             | 1473 +++++++++++++++++
 drivers/net/wireless/cw1200/txrx.h                             |  106 ++
 drivers/net/wireless/cw1200/wsm.c                              | 1822 +++++++++++++++++++++
 drivers/net/wireless/cw1200/wsm.h                              | 1870 +++++++++++++++++++++
 drivers/net/wireless/ipw2x00/ipw2100.c                         |    2 -
 drivers/net/wireless/ipw2x00/ipw2200.c                         |    1 +
 drivers/net/wireless/ipw2x00/libipw_rx.c                       |    2 +-
 drivers/net/wireless/iwlegacy/3945-mac.c                       |    5 +-
 drivers/net/wireless/iwlegacy/3945.c                           |   18 +
 drivers/net/wireless/iwlegacy/4965-mac.c                       |   25 +-
 drivers/net/wireless/iwlegacy/commands.h                       |    8 -
 drivers/net/wireless/iwlegacy/common.c                         |   11 +
 drivers/net/wireless/iwlegacy/common.h                         |   41 +-
 drivers/net/wireless/iwlwifi/Kconfig                           |   10 -
 drivers/net/wireless/iwlwifi/Makefile                          |    7 +-
 drivers/net/wireless/iwlwifi/dvm/Makefile                      |    1 -
 drivers/net/wireless/iwlwifi/dvm/agn.h                         |   58 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c                       |    8 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h                    |   12 -
 drivers/net/wireless/iwlwifi/dvm/dev.h                         |   73 +-
 drivers/net/wireless/iwlwifi/dvm/devices.c                     |  107 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c                         |   26 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                    |   37 +-
 drivers/net/wireless/iwlwifi/dvm/main.c                        |   67 +-
 drivers/net/wireless/iwlwifi/dvm/power.c                       |    6 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c                          |   51 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c                          |   42 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c                        |   12 +-
 drivers/net/wireless/iwlwifi/dvm/testmode.c                    |  471 ------
 drivers/net/wireless/iwlwifi/dvm/tt.c                          |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                          |   24 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c                       |   10 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c                        |    3 -
 drivers/net/wireless/iwlwifi/iwl-2000.c                        |   39 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c                        |    4 -
 drivers/net/wireless/iwlwifi/iwl-6000.c                        |   32 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c                        |   65 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                      |   54 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h                         |   19 +
 drivers/net/wireless/iwlwifi/iwl-debug.h                       |    4 +
 drivers/net/wireless/iwlwifi/iwl-drv.c                         |   19 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h                         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c                |   15 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h                |    3 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h                          |    7 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h                   |    9 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                   |   20 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h                   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-phy-db.c                      |   39 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h                        |   12 +
 drivers/net/wireless/iwlwifi/iwl-test.c                        |  852 ----------
 drivers/net/wireless/iwlwifi/iwl-test.h                        |  161 --
 drivers/net/wireless/iwlwifi/iwl-testmode.h                    |  309 ----
 drivers/net/wireless/iwlwifi/iwl-trans.h                       |   21 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile                      |    2 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c                     |   29 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c                          |  197 ++-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                     |  453 +++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h                   |    4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h                  |    8 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h                |   98 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                   |   10 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                      |  233 +++
 drivers/net/wireless/iwlwifi/mvm/fw.c                          |   37 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                    |   97 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                    |  299 +++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h                         |  204 ++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c                         |  212 ++-
 drivers/net/wireless/iwlwifi/mvm/ops.c                         |   37 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                    |   76 +-
 drivers/net/wireless/iwlwifi/mvm/power.c                       |  218 ++-
 drivers/net/wireless/iwlwifi/mvm/quota.c                       |   25 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c                          |  171 +-
 drivers/net/wireless/iwlwifi/mvm/rs.h                          |   17 +
 drivers/net/wireless/iwlwifi/mvm/rx.c                          |   22 +
 drivers/net/wireless/iwlwifi/mvm/scan.c                        |    6 -
 drivers/net/wireless/iwlwifi/mvm/sta.c                         |   24 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h                         |    8 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c                          |  530 ++++++
 drivers/net/wireless/iwlwifi/mvm/tx.c                          |    7 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c                       |   41 +
 drivers/net/wireless/iwlwifi/pcie/drv.c                        |   54 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h                   |    2 +
 drivers/net/wireless/iwlwifi/pcie/rx.c                         |  115 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c                      |   68 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c                         |   40 +-
 drivers/net/wireless/libertas/mesh.c                           |    2 +-
 drivers/net/wireless/mwifiex/11h.c                             |  101 ++
 drivers/net/wireless/mwifiex/Kconfig                           |    4 +-
 drivers/net/wireless/mwifiex/Makefile                          |    1 +
 drivers/net/wireless/mwifiex/cfg80211.c                        |  122 +-
 drivers/net/wireless/mwifiex/cmdevt.c                          |    1 +
 drivers/net/wireless/mwifiex/fw.h                              |   33 +
 drivers/net/wireless/mwifiex/init.c                            |  115 +-
 drivers/net/wireless/mwifiex/join.c                            |    7 +-
 drivers/net/wireless/mwifiex/main.c                            |  101 +-
 drivers/net/wireless/mwifiex/main.h                            |   32 +-
 drivers/net/wireless/mwifiex/scan.c                            |   60 +-
 drivers/net/wireless/mwifiex/sdio.c                            |  463 ++++--
 drivers/net/wireless/mwifiex/sdio.h                            |  340 ++--
 drivers/net/wireless/mwifiex/sta_cmd.c                         |   62 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c                     |   17 +
 drivers/net/wireless/mwifiex/sta_event.c                       |   11 +
 drivers/net/wireless/mwifiex/sta_ioctl.c                       |   52 +-
 drivers/net/wireless/mwifiex/uap_cmd.c                         |   21 +
 drivers/net/wireless/mwifiex/uap_event.c                       |   25 +-
 drivers/net/wireless/mwifiex/wmm.c                             |    5 +-
 drivers/net/wireless/mwl8k.c                                   |   11 +-
 drivers/net/wireless/orinoco/orinoco_pci.h                     |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c                     |    3 +-
 drivers/net/wireless/p54/p54spi.c                              |   37 +-
 drivers/net/wireless/rt2x00/rt2400pci.c                        |   66 +-
 drivers/net/wireless/rt2x00/rt2500pci.c                        |   66 +-
 drivers/net/wireless/rt2x00/rt2500usb.c                        |   66 +-
 drivers/net/wireless/rt2x00/rt2800.h                           |   12 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                        |  835 ++++++----
 drivers/net/wireless/rt2x00/rt2800pci.c                        |   68 +-
 drivers/net/wireless/rt2x00/rt2800usb.c                        |  127 +-
 drivers/net/wireless/rt2x00/rt2x00.h                           |    9 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c                        |   54 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c                        |    9 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c                      |   32 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h                      |   21 +-
 drivers/net/wireless/rt2x00/rt61pci.c                          |   60 +-
 drivers/net/wireless/rt2x00/rt73usb.c                          |   58 +-
 drivers/net/wireless/rtlwifi/base.c                            |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c                    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c                    |    1 +
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c                    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c                    |    6 +-
 drivers/net/wireless/ti/wl1251/spi.c                           |   30 +-
 drivers/net/wireless/ti/wl18xx/main.c                          |   47 +-
 drivers/net/wireless/ti/wl18xx/reg.h                           |   15 +
 drivers/net/wireless/ti/wlcore/Makefile                        |    2 +-
 drivers/net/wireless/ti/wlcore/main.c                          |  284 +---
 drivers/net/wireless/ti/wlcore/ps.c                            |    2 +-
 drivers/net/wireless/ti/wlcore/spi.c                           |   14 +-
 drivers/net/wireless/ti/wlcore/sysfs.c                         |  216 +++
 drivers/net/wireless/ti/wlcore/sysfs.h                         |   28 +
 drivers/net/wireless/ti/wlcore/tx.c                            |    2 +-
 drivers/net/xen-netback/common.h                               |   14 +-
 drivers/net/xen-netback/interface.c                            |  102 +-
 drivers/net/xen-netback/netback.c                              |   42 +-
 drivers/net/xen-netback/xenbus.c                               |   53 +-
 drivers/net/xen-netfront.c                                     |  253 ++-
 drivers/nfc/Kconfig                                            |   10 +
 drivers/nfc/Makefile                                           |    1 +
 drivers/nfc/mei_phy.c                                          |    6 +-
 drivers/nfc/microread/microread.c                              |    6 +-
 drivers/nfc/nfcsim.c                                           |  541 ++++++
 drivers/nfc/nfcwilink.c                                        |   18 +-
 drivers/nfc/pn533.c                                            |   31 +-
 drivers/nfc/pn544/pn544.c                                      |   40 +-
 drivers/of/of_net.c                                            |    1 +
 drivers/s390/net/netiucv.c                                     |   20 -
 drivers/s390/net/qeth_core.h                                   |    2 +-
 drivers/s390/net/qeth_core_main.c                              |   23 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                             |    2 +-
 drivers/scsi/fcoe/fcoe.c                                       |    2 +-
 drivers/scsi/fcoe/fcoe_transport.c                             |    2 +-
 drivers/scsi/libiscsi_tcp.c                                    |    1 -
 drivers/ssb/driver_chipcommon_sflash.c                         |   34 +-
 drivers/ssb/main.c                                             |    8 +
 drivers/ssb/pcihost_wrapper.c                                  |    2 +-
 drivers/ssb/sprom.c                                            |    2 +-
 drivers/ssb/ssb_private.h                                      |    4 +
 drivers/staging/csr/netdev.c                                   |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c             |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c                |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c                         |    4 +-
 drivers/staging/silicom/Kconfig                                |    7 +-
 drivers/staging/silicom/bpctl_mod.c                            |    2 +-
 fs/select.c                                                    |   39 +-
 include/linux/bcma/bcma.h                                      |    1 +
 include/linux/bcma/bcma_driver_chipcommon.h                    |   55 +
 include/linux/can/platform/flexcan.h                           |   20 -
 include/linux/filter.h                                         |    4 +-
 include/linux/ieee80211.h                                      |   10 +
 include/linux/if_link.h                                        |    1 +
 include/linux/if_macvlan.h                                     |   12 +-
 include/linux/if_team.h                                        |   11 +
 include/linux/if_vlan.h                                        |    2 -
 include/linux/igmp.h                                           |    1 +
 include/linux/inetdevice.h                                     |    5 +
 include/linux/jiffies.h                                        |    4 +
 include/linux/ktime.h                                          |   13 +
 include/linux/marvell_phy.h                                    |    2 +
 include/linux/mlx4/cmd.h                                       |    3 +-
 include/linux/mlx4/device.h                                    |    3 +-
 include/linux/mlx4/qp.h                                        |   36 +
 include/linux/mv643xx_eth.h                                    |    2 +
 include/linux/net.h                                            |    6 +-
 include/linux/netdev_features.h                                |    4 +-
 include/linux/netdevice.h                                      |   85 +-
 include/linux/netfilter.h                                      |    2 +-
 include/linux/netlink.h                                        |   27 +
 include/linux/netpoll.h                                        |    4 +-
 include/linux/phy.h                                            |   27 +
 include/linux/platform_data/brcmfmac-sdio.h                    |    5 +
 include/linux/platform_data/net-cw1200.h                       |   81 +
 include/linux/sched.h                                          |    9 +
 include/linux/skbuff.h                                         |  137 +-
 include/linux/ssb/ssb_driver_mips.h                            |   15 +
 include/linux/ssb/ssb_regs.h                                   |    1 +
 include/linux/stmmac.h                                         |    4 +
 include/linux/tcp.h                                            |    1 -
 include/net/act_api.h                                          |    2 +-
 include/net/addrconf.h                                         |    4 +
 include/net/bluetooth/hci.h                                    |    1 -
 include/net/bluetooth/hci_core.h                               |   29 +-
 include/net/bluetooth/l2cap.h                                  |    2 +-
 include/net/cfg80211.h                                         |  236 +--
 include/net/gen_stats.h                                        |   10 +-
 include/net/gre.h                                              |   31 +
 include/net/ieee80211_radiotap.h                               |    7 +
 include/net/if_inet6.h                                         |   13 +-
 include/net/inet_ecn.h                                         |    6 +-
 include/net/inet_sock.h                                        |    1 -
 include/net/ip_fib.h                                           |    5 +-
 include/net/ip_tunnels.h                                       |   36 +-
 include/net/ip_vs.h                                            |   92 +-
 include/net/ipv6.h                                             |   10 +-
 include/net/ll_poll.h                                          |  200 +++
 include/net/mac80211.h                                         |   27 +-
 include/net/ndisc.h                                            |    2 +-
 include/net/net_namespace.h                                    |   13 +
 include/net/netfilter/xt_rateest.h                             |    2 +-
 include/net/netns/x_tables.h                                   |    6 +
 include/net/nfc/hci.h                                          |    7 +-
 include/net/nfc/nci_core.h                                     |   58 +-
 include/net/nfc/nfc.h                                          |   35 +-
 include/net/ping.h                                             |   65 +-
 include/net/sch_generic.h                                      |   17 +-
 include/net/sctp/checksum.h                                    |    5 +
 include/net/sctp/sctp.h                                        |  111 --
 include/net/sctp/structs.h                                     |    6 +-
 include/net/sock.h                                             |   21 +-
 include/net/tcp.h                                              |   29 +-
 include/net/transp_v6.h                                        |   79 +-
 include/net/udp.h                                              |    8 +-
 include/uapi/asm-generic/poll.h                                |    2 +
 include/uapi/asm-generic/socket.h                              |    2 +
 include/uapi/linux/ethtool.h                                   |    4 +-
 include/uapi/linux/gen_stats.h                                 |   11 +
 include/uapi/linux/if_arp.h                                    |    1 +
 include/uapi/linux/if_link.h                                   |   15 +
 include/uapi/linux/if_pppox.h                                  |    4 +-
 include/uapi/linux/if_tun.h                                    |    2 +
 include/uapi/linux/ip_vs.h                                     |    6 +
 include/uapi/linux/netfilter/nfnetlink_queue.h                 |    2 +
 include/uapi/linux/netfilter/xt_socket.h                       |    7 +
 include/uapi/linux/nfc.h                                       |   18 +-
 include/uapi/linux/nl80211.h                                   |   37 +
 include/uapi/linux/openvswitch.h                               |   20 +-
 include/uapi/linux/rtnetlink.h                                 |    2 +
 include/uapi/linux/snmp.h                                      |    2 +
 include/uapi/linux/tipc.h                                      |    2 +-
 include/uapi/linux/tipc_config.h                               |    2 +-
 include/xen/interface/io/netif.h                               |   12 +
 kernel/sysctl_binary.c                                         |    1 -
 lib/vsprintf.c                                                 |  124 +-
 net/8021q/vlan.c                                               |    2 +-
 net/Kconfig                                                    |   17 +
 net/Makefile                                                   |    1 +
 net/appletalk/aarp.c                                           |    2 +-
 net/appletalk/ddp.c                                            |    2 +-
 net/atm/clip.c                                                 |    8 +-
 net/atm/mpc.c                                                  |    6 +-
 net/ax25/af_ax25.c                                             |    6 +-
 net/ax25/sysctl_net_ax25.c                                     |    2 +-
 net/batman-adv/Makefile                                        |    1 -
 net/batman-adv/bat_iv_ogm.c                                    |  123 +-
 net/batman-adv/bridge_loop_avoidance.c                         |   94 +-
 net/batman-adv/bridge_loop_avoidance.h                         |   12 +-
 net/batman-adv/distributed-arp-table.c                         |   82 +-
 net/batman-adv/hard-interface.c                                |   98 +-
 net/batman-adv/icmp_socket.c                                   |    4 +-
 net/batman-adv/main.c                                          |    1 -
 net/batman-adv/main.h                                          |   18 +-
 net/batman-adv/network-coding.c                                |   22 +-
 net/batman-adv/network-coding.h                                |    6 +-
 net/batman-adv/originator.c                                    |    6 +-
 net/batman-adv/originator.h                                    |    2 +-
 net/batman-adv/ring_buffer.c                                   |   51 -
 net/batman-adv/ring_buffer.h                                   |   27 -
 net/batman-adv/routing.c                                       |   64 +-
 net/batman-adv/routing.h                                       |    1 -
 net/batman-adv/send.c                                          |   36 +-
 net/batman-adv/send.h                                          |    6 +-
 net/batman-adv/soft-interface.c                                |    6 +-
 net/batman-adv/translation-table.c                             |   74 +-
 net/batman-adv/translation-table.h                             |    2 +-
 net/batman-adv/types.h                                         |    6 +-
 net/batman-adv/unicast.c                                       |    2 +-
 net/batman-adv/vis.c                                           |   19 +-
 net/bluetooth/hci_core.c                                       |  192 +--
 net/bluetooth/hci_event.c                                      |   71 +-
 net/bluetooth/hidp/core.c                                      |   14 +-
 net/bluetooth/l2cap_core.c                                     |  121 +-
 net/bluetooth/l2cap_sock.c                                     |    4 +-
 net/bluetooth/mgmt.c                                           |  229 ++-
 net/bridge/br_device.c                                         |   21 +-
 net/bridge/br_fdb.c                                            |    5 +
 net/bridge/br_forward.c                                        |   14 +-
 net/bridge/br_if.c                                             |    2 +-
 net/bridge/br_input.c                                          |   15 +-
 net/bridge/br_mdb.c                                            |    2 +-
 net/bridge/br_multicast.c                                      |   74 +-
 net/bridge/br_netfilter.c                                      |    4 +-
 net/bridge/br_netlink.c                                        |   10 +-
 net/bridge/br_notify.c                                         |    2 +-
 net/bridge/br_private.h                                        |    9 +-
 net/bridge/br_sysfs_br.c                                       |   26 +
 net/bridge/br_sysfs_if.c                                       |    4 +
 net/bridge/netfilter/ebt_ulog.c                                |    6 +
 net/bridge/netfilter/ebtables.c                                |    6 +-
 net/caif/caif_dev.c                                            |    4 +-
 net/caif/caif_usb.c                                            |    4 +-
 net/can/af_can.c                                               |    4 +-
 net/can/bcm.c                                                  |    4 +-
 net/can/gw.c                                                   |    4 +-
 net/can/raw.c                                                  |    4 +-
 net/core/datagram.c                                            |    4 +
 net/core/dev.c                                                 |  238 ++-
 net/core/drop_monitor.c                                        |    4 +-
 net/core/dst.c                                                 |    2 +-
 net/core/ethtool.c                                             |   24 +-
 net/core/fib_rules.c                                           |    4 +-
 net/core/gen_estimator.c                                       |   12 +-
 net/core/gen_stats.c                                           |   22 +-
 net/core/link_watch.c                                          |    3 +
 net/core/neighbour.c                                           |   34 +-
 net/core/net-procfs.c                                          |   16 +-
 net/core/netpoll.c                                             |   16 +-
 net/core/netprio_cgroup.c                                      |    2 +-
 net/core/pktgen.c                                              |   81 +-
 net/core/rtnetlink.c                                           |   32 +-
 net/core/skbuff.c                                              |   69 +-
 net/core/sock.c                                                |   26 +
 net/core/sysctl_net_core.c                                     |  139 +-
 net/decnet/af_decnet.c                                         |    4 +-
 net/decnet/dn_dev.c                                            |    6 +-
 net/decnet/sysctl_net_decnet.c                                 |    6 +-
 net/ieee802154/6lowpan.c                                       |    5 +-
 net/ipv4/Kconfig                                               |   11 +-
 net/ipv4/Makefile                                              |    7 +-
 net/ipv4/af_inet.c                                             |   26 +-
 net/ipv4/ah4.c                                                 |    7 +-
 net/ipv4/arp.c                                                 |    8 +-
 net/ipv4/devinet.c                                             |    9 +-
 net/ipv4/esp4.c                                                |    7 +-
 net/ipv4/fib_frontend.c                                        |    4 +-
 net/ipv4/fib_semantics.c                                       |    3 +-
 net/ipv4/gre.c                                                 |  253 ---
 net/ipv4/gre_demux.c                                           |  414 +++++
 net/ipv4/gre_offload.c                                         |  127 ++
 net/ipv4/icmp.c                                                |   51 +-
 net/ipv4/igmp.c                                                |   79 +-
 net/ipv4/inet_fragment.c                                       |    2 -
 net/ipv4/ip_gre.c                                              |  258 +--
 net/ipv4/ip_tunnel.c                                           |  177 +-
 net/ipv4/ip_tunnel_core.c                                      |  122 ++
 net/ipv4/ip_vti.c                                              |    7 -
 net/ipv4/ipcomp.c                                              |    7 +-
 net/ipv4/ipip.c                                                |   20 +-
 net/ipv4/ipmr.c                                                |    4 +-
 net/ipv4/netfilter/Kconfig                                     |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                            |    7 +-
 net/ipv4/netfilter/ipt_ULOG.c                                  |    6 +
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                 |    2 +-
 net/ipv4/ping.c                                                |  641 +++++---
 net/ipv4/proc.c                                                |    1 +
 net/ipv4/route.c                                               |  144 +-
 net/ipv4/sysctl_net_ipv4.c                                     |   31 +-
 net/ipv4/tcp.c                                                 |  344 +---
 net/ipv4/tcp_input.c                                           |  517 +++---
 net/ipv4/tcp_ipv4.c                                            |   78 +-
 net/ipv4/tcp_minisocks.c                                       |    6 +-
 net/ipv4/tcp_offload.c                                         |  332 ++++
 net/ipv4/tcp_output.c                                          |   39 +-
 net/ipv4/udp.c                                                 |   90 +-
 net/ipv4/udp_offload.c                                         |  100 ++
 net/ipv4/xfrm4_tunnel.c                                        |    2 +-
 net/ipv6/Makefile                                              |    2 +-
 net/ipv6/addrconf.c                                            |  304 ++--
 net/ipv6/addrconf_core.c                                       |    1 +
 net/ipv6/af_inet6.c                                            |   12 +
 net/ipv6/datagram.c                                            |   27 +
 net/ipv6/exthdrs_core.c                                        |    2 +-
 net/ipv6/icmp.c                                                |   23 +-
 net/ipv6/ip6_offload.c                                         |    1 +
 net/ipv6/ip6_output.c                                          |   16 +-
 net/ipv6/ip6mr.c                                               |    2 +-
 net/ipv6/mcast.c                                               |   75 +-
 net/ipv6/mip6.c                                                |    6 +-
 net/ipv6/ndisc.c                                               |   11 +-
 net/ipv6/netfilter/ip6t_MASQUERADE.c                           |    6 +-
 net/ipv6/output_core.c                                         |    3 +-
 net/ipv6/ping.c                                                |  277 ++++
 net/ipv6/raw.c                                                 |   48 +-
 net/ipv6/route.c                                               |   24 +-
 net/ipv6/sit.c                                                 |  211 ++-
 net/ipv6/sysctl_net_ipv6.c                                     |    4 +-
 net/ipv6/tcp_ipv6.c                                            |    2 +
 net/ipv6/udp.c                                                 |   62 +-
 net/ipv6/udp_offload.c                                         |    3 +-
 net/ipx/af_ipx.c                                               |    2 +-
 net/irda/irsysctl.c                                            |    6 +-
 net/iucv/af_iucv.c                                             |    2 +-
 net/l2tp/l2tp_core.c                                           |  114 +-
 net/l2tp/l2tp_core.h                                           |    5 +
 net/l2tp/l2tp_ppp.c                                            |    3 +-
 net/mac80211/aes_ccm.c                                         |    6 +-
 net/mac80211/cfg.c                                             |   67 +-
 net/mac80211/debugfs_netdev.c                                  |   15 +-
 net/mac80211/driver-ops.h                                      |    3 +-
 net/mac80211/ht.c                                              |    8 +-
 net/mac80211/ibss.c                                            |  114 +-
 net/mac80211/ieee80211_i.h                                     |   37 +-
 net/mac80211/iface.c                                           |   34 +-
 net/mac80211/key.c                                             |   24 +-
 net/mac80211/key.h                                             |   15 +-
 net/mac80211/main.c                                            |    7 +-
 net/mac80211/mesh.c                                            |  107 +-
 net/mac80211/mesh.h                                            |    7 +-
 net/mac80211/mesh_plink.c                                      |    8 +-
 net/mac80211/mlme.c                                            |  436 ++---
 net/mac80211/rate.c                                            |    8 +-
 net/mac80211/rx.c                                              |   56 +-
 net/mac80211/scan.c                                            |    9 +
 net/mac80211/sta_info.c                                        |    8 +-
 net/mac80211/sta_info.h                                        |    9 +
 net/mac80211/tx.c                                              |   11 +-
 net/mac80211/util.c                                            |   41 +-
 net/mac80211/vht.c                                             |    2 +-
 net/mac80211/wep.c                                             |   48 +-
 net/mac80211/wpa.c                                             |   68 +-
 net/mpls/Kconfig                                               |    9 +
 net/mpls/Makefile                                              |    4 +
 net/mpls/mpls_gso.c                                            |  108 ++
 net/netfilter/core.c                                           |   21 +-
 net/netfilter/ipvs/ip_vs_conn.c                                |   35 +-
 net/netfilter/ipvs/ip_vs_core.c                                |    4 +-
 net/netfilter/ipvs/ip_vs_ctl.c                                 |   35 +-
 net/netfilter/ipvs/ip_vs_dh.c                                  |   10 +-
 net/netfilter/ipvs/ip_vs_lblc.c                                |   14 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                               |   14 +-
 net/netfilter/ipvs/ip_vs_lc.c                                  |    3 +-
 net/netfilter/ipvs/ip_vs_nq.c                                  |    3 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c                          |  860 ++--------
 net/netfilter/ipvs/ip_vs_proto_tcp.c                           |   14 +-
 net/netfilter/ipvs/ip_vs_rr.c                                  |    3 +-
 net/netfilter/ipvs/ip_vs_sed.c                                 |    3 +-
 net/netfilter/ipvs/ip_vs_sh.c                                  |  108 +-
 net/netfilter/ipvs/ip_vs_sync.c                                |   19 +-
 net/netfilter/ipvs/ip_vs_wlc.c                                 |    3 +-
 net/netfilter/ipvs/ip_vs_wrr.c                                 |    3 +-
 net/netfilter/nf_conntrack_ftp.c                               |   73 +-
 net/netfilter/nf_conntrack_netlink.c                           |   30 +-
 net/netfilter/nf_conntrack_proto_tcp.c                         |    6 +
 net/netfilter/nf_conntrack_standalone.c                        |    4 +-
 net/netfilter/nf_log.c                                         |    6 +-
 net/netfilter/nf_nat_helper.c                                  |    2 +-
 net/netfilter/nfnetlink_cthelper.c                             |   16 +-
 net/netfilter/nfnetlink_cttimeout.c                            |    6 +-
 net/netfilter/nfnetlink_queue_core.c                           |   47 +-
 net/netfilter/xt_CT.c                                          |   10 +-
 net/netfilter/xt_TEE.c                                         |    2 +-
 net/netfilter/xt_rateest.c                                     |    2 +-
 net/netfilter/xt_socket.c                                      |   96 +-
 net/netlabel/netlabel_unlabeled.c                              |    7 +-
 net/netlink/af_netlink.c                                       |  178 +-
 net/netlink/af_netlink.h                                       |    1 +
 net/netrom/af_netrom.c                                         |    2 +-
 net/netrom/sysctl_net_netrom.c                                 |    2 +-
 net/nfc/core.c                                                 |  224 ++-
 net/nfc/hci/core.c                                             |   75 +-
 net/nfc/llcp.h                                                 |    3 +-
 net/nfc/llcp_commands.c                                        |   22 +-
 net/nfc/llcp_core.c                                            |   16 +-
 net/nfc/llcp_sock.c                                            |   19 +-
 net/nfc/nci/Kconfig                                            |   10 +
 net/nfc/nci/Makefile                                           |    4 +-
 net/nfc/nci/core.c                                             |   37 +-
 net/nfc/nci/data.c                                             |    2 -
 net/nfc/nci/spi.c                                              |  378 +++++
 net/nfc/netlink.c                                              |  183 ++-
 net/nfc/nfc.h                                                  |   11 +
 net/openvswitch/Kconfig                                        |   14 +
 net/openvswitch/Makefile                                       |    3 +-
 net/openvswitch/actions.c                                      |    8 +
 net/openvswitch/datapath.c                                     |  371 ++++-
 net/openvswitch/datapath.h                                     |    4 +
 net/openvswitch/dp_notify.c                                    |    2 +-
 net/openvswitch/flow.c                                         |  211 ++-
 net/openvswitch/flow.h                                         |   47 +-
 net/openvswitch/vport-gre.c                                    |  275 ++++
 net/openvswitch/vport-internal_dev.c                           |    3 +-
 net/openvswitch/vport-netdev.c                                 |    9 +-
 net/openvswitch/vport-netdev.h                                 |    1 -
 net/openvswitch/vport.c                                        |   34 +-
 net/openvswitch/vport.h                                        |   23 +-
 net/packet/af_packet.c                                         |    5 +-
 net/phonet/pn_dev.c                                            |    4 +-
 net/phonet/sysctl.c                                            |    4 +-
 net/rds/ib_sysctl.c                                            |    2 +-
 net/rds/iw_sysctl.c                                            |    2 +-
 net/rds/sysctl.c                                               |    2 +-
 net/rose/af_rose.c                                             |    6 +-
 net/rose/sysctl_net_rose.c                                     |    2 +-
 net/sched/act_mirred.c                                         |    2 +-
 net/sched/sch_cbq.c                                            |    2 +-
 net/sched/sch_drr.c                                            |    2 +-
 net/sched/sch_generic.c                                        |   44 +-
 net/sched/sch_hfsc.c                                           |    2 +-
 net/sched/sch_htb.c                                            |  261 +--
 net/sched/sch_netem.c                                          |  111 +-
 net/sched/sch_qfq.c                                            |    2 +-
 net/sched/sch_tbf.c                                            |   47 +-
 net/sctp/Kconfig                                               |   11 +-
 net/sctp/associola.c                                           |   84 +-
 net/sctp/bind_addr.c                                           |    2 +-
 net/sctp/chunk.c                                               |    7 +-
 net/sctp/debug.c                                               |    4 -
 net/sctp/endpointola.c                                         |   25 +-
 net/sctp/input.c                                               |   12 +-
 net/sctp/inqueue.c                                             |    9 +-
 net/sctp/ipv6.c                                                |   29 +-
 net/sctp/output.c                                              |   40 +-
 net/sctp/outqueue.c                                            |  205 +--
 net/sctp/proc.c                                                |   12 +-
 net/sctp/protocol.c                                            |   56 +-
 net/sctp/sm_make_chunk.c                                       |   54 +-
 net/sctp/sm_sideeffect.c                                       |  101 +-
 net/sctp/sm_statefuns.c                                        |   85 +-
 net/sctp/socket.c                                              |  289 ++--
 net/sctp/sysctl.c                                              |   10 +-
 net/sctp/transport.c                                           |   51 +-
 net/sctp/tsnmap.c                                              |   10 +-
 net/sctp/ulpevent.c                                            |   10 +-
 net/socket.c                                                   |   23 +-
 net/sunrpc/sysctl.c                                            |   10 +-
 net/sunrpc/xprtrdma/svc_rdma.c                                 |    8 +-
 net/sunrpc/xprtrdma/transport.c                                |    4 +-
 net/sunrpc/xprtsock.c                                          |    4 +-
 net/tipc/Makefile                                              |    3 +-
 net/tipc/bcast.c                                               |    3 +-
 net/tipc/bcast.h                                               |    3 +-
 net/tipc/config.c                                              |  119 +-
 net/tipc/core.c                                                |   22 +-
 net/tipc/core.h                                                |   17 +-
 net/tipc/discover.c                                            |    7 +-
 net/tipc/eth_media.c                                           |   19 +-
 net/tipc/ib_media.c                                            |   17 +-
 net/tipc/link.c                                                |   88 +-
 net/tipc/msg.c                                                 |   19 +-
 net/tipc/msg.h                                                 |    8 +-
 net/tipc/name_table.c                                          |   10 +-
 net/tipc/name_table.h                                          |   11 +-
 net/tipc/node_subscr.c                                         |    2 +-
 net/tipc/port.c                                                |  320 +---
 net/tipc/port.h                                                |   85 +-
 net/tipc/server.c                                              |  596 +++++++
 net/tipc/server.h                                              |   94 ++
 net/tipc/socket.c                                              |  146 +-
 net/tipc/subscr.c                                              |  348 ++--
 net/tipc/subscr.h                                              |   21 +-
 net/tipc/sysctl.c                                              |   64 +
 net/unix/sysctl_net_unix.c                                     |    2 +-
 net/vmw_vsock/af_vsock.c                                       |   55 +-
 net/vmw_vsock/vmci_transport.c                                 |   18 +-
 net/wireless/chan.c                                            |   57 +-
 net/wireless/core.c                                            |  270 +--
 net/wireless/core.h                                            |  123 +-
 net/wireless/debugfs.c                                         |    4 +-
 net/wireless/ibss.c                                            |   16 +-
 net/wireless/mesh.c                                            |   15 +-
 net/wireless/mlme.c                                            |  433 ++---
 net/wireless/nl80211.c                                         |  814 +++++-----
 net/wireless/reg.c                                             |  138 +-
 net/wireless/scan.c                                            |   51 +-
 net/wireless/sme.c                                             |  652 ++++----
 net/wireless/sysfs.c                                           |    8 +-
 net/wireless/trace.h                                           |   46 +-
 net/wireless/util.c                                            |   39 +-
 net/wireless/wext-compat.c                                     |   22 +-
 net/wireless/wext-sme.c                                        |   49 +-
 net/x25/af_x25.c                                               |   17 +-
 net/xfrm/xfrm_input.c                                          |    5 +
 net/xfrm/xfrm_output.c                                         |    9 +-
 net/xfrm/xfrm_policy.c                                         |    2 +-
 net/xfrm/xfrm_proc.c                                           |    1 +
 security/selinux/netif.c                                       |    2 +-
 tools/testing/selftests/net/psock_tpacket.c                    |   59 +-
 1173 files changed, 73885 insertions(+), 21757 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt
 create mode 100644 Documentation/devicetree/bindings/net/allwinner,sun4i-mdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/arc_emac.txt
 create mode 100644 Documentation/devicetree/bindings/net/davicom-dm9000.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell-orion-net.txt
 create mode 100644 Documentation/devicetree/bindings/net/micrel-ks8851.txt
 create mode 100644 Documentation/devicetree/bindings/net/via-velocity.txt
 delete mode 100644 Documentation/networking/ifenslave.c
 create mode 100644 drivers/net/ethernet/allwinner/Kconfig
 create mode 100644 drivers/net/ethernet/allwinner/Makefile
 create mode 100644 drivers/net/ethernet/allwinner/sun4i-emac.c
 create mode 100644 drivers/net/ethernet/allwinner/sun4i-emac.h
 create mode 100644 drivers/net/ethernet/arc/Kconfig
 create mode 100644 drivers/net/ethernet/arc/Makefile
 create mode 100644 drivers/net/ethernet/arc/emac.h
 create mode 100644 drivers/net/ethernet/arc/emac_main.c
 create mode 100644 drivers/net/ethernet/arc/emac_mdio.c
 create mode 100644 drivers/net/nlmon.c
 create mode 100644 drivers/net/phy/mdio-sun4i.c
 create mode 100644 drivers/net/wireless/ath/ath10k/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath10k/Makefile
 create mode 100644 drivers/net/wireless/ath/ath10k/bmi.c
 create mode 100644 drivers/net/wireless/ath/ath10k/bmi.h
 create mode 100644 drivers/net/wireless/ath/ath10k/ce.c
 create mode 100644 drivers/net/wireless/ath/ath10k/ce.h
 create mode 100644 drivers/net/wireless/ath/ath10k/core.c
 create mode 100644 drivers/net/wireless/ath/ath10k/core.h
 create mode 100644 drivers/net/wireless/ath/ath10k/debug.c
 create mode 100644 drivers/net/wireless/ath/ath10k/debug.h
 create mode 100644 drivers/net/wireless/ath/ath10k/hif.h
 create mode 100644 drivers/net/wireless/ath/ath10k/htc.c
 create mode 100644 drivers/net/wireless/ath/ath10k/htc.h
 create mode 100644 drivers/net/wireless/ath/ath10k/htt.c
 create mode 100644 drivers/net/wireless/ath/ath10k/htt.h
 create mode 100644 drivers/net/wireless/ath/ath10k/htt_rx.c
 create mode 100644 drivers/net/wireless/ath/ath10k/htt_tx.c
 create mode 100644 drivers/net/wireless/ath/ath10k/hw.h
 create mode 100644 drivers/net/wireless/ath/ath10k/mac.c
 create mode 100644 drivers/net/wireless/ath/ath10k/mac.h
 create mode 100644 drivers/net/wireless/ath/ath10k/pci.c
 create mode 100644 drivers/net/wireless/ath/ath10k/pci.h
 create mode 100644 drivers/net/wireless/ath/ath10k/rx_desc.h
 create mode 100644 drivers/net/wireless/ath/ath10k/targaddrs.h
 create mode 100644 drivers/net/wireless/ath/ath10k/trace.c
 create mode 100644 drivers/net/wireless/ath/ath10k/trace.h
 create mode 100644 drivers/net/wireless/ath/ath10k/txrx.c
 create mode 100644 drivers/net/wireless/ath/ath10k/txrx.h
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath10k/wmi.h
 create mode 100644 drivers/net/wireless/ath/ath9k/ar9462_2p1_initvals.h
 create mode 100644 drivers/net/wireless/ath/wil6210/debug.c
 create mode 100644 drivers/net/wireless/ath/wil6210/trace.c
 create mode 100644 drivers/net/wireless/ath/wil6210/trace.h
 create mode 100644 drivers/net/wireless/cw1200/Kconfig
 create mode 100644 drivers/net/wireless/cw1200/Makefile
 create mode 100644 drivers/net/wireless/cw1200/bh.c
 create mode 100644 drivers/net/wireless/cw1200/bh.h
 create mode 100644 drivers/net/wireless/cw1200/cw1200.h
 create mode 100644 drivers/net/wireless/cw1200/cw1200_sdio.c
 create mode 100644 drivers/net/wireless/cw1200/cw1200_spi.c
 create mode 100644 drivers/net/wireless/cw1200/debug.c
 create mode 100644 drivers/net/wireless/cw1200/debug.h
 create mode 100644 drivers/net/wireless/cw1200/fwio.c
 create mode 100644 drivers/net/wireless/cw1200/fwio.h
 create mode 100644 drivers/net/wireless/cw1200/hwbus.h
 create mode 100644 drivers/net/wireless/cw1200/hwio.c
 create mode 100644 drivers/net/wireless/cw1200/hwio.h
 create mode 100644 drivers/net/wireless/cw1200/main.c
 create mode 100644 drivers/net/wireless/cw1200/pm.c
 create mode 100644 drivers/net/wireless/cw1200/pm.h
 create mode 100644 drivers/net/wireless/cw1200/queue.c
 create mode 100644 drivers/net/wireless/cw1200/queue.h
 create mode 100644 drivers/net/wireless/cw1200/scan.c
 create mode 100644 drivers/net/wireless/cw1200/scan.h
 create mode 100644 drivers/net/wireless/cw1200/sta.c
 create mode 100644 drivers/net/wireless/cw1200/sta.h
 create mode 100644 drivers/net/wireless/cw1200/txrx.c
 create mode 100644 drivers/net/wireless/cw1200/txrx.h
 create mode 100644 drivers/net/wireless/cw1200/wsm.c
 create mode 100644 drivers/net/wireless/cw1200/wsm.h
 delete mode 100644 drivers/net/wireless/iwlwifi/dvm/testmode.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-test.c
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-test.h
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-testmode.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tt.c
 create mode 100644 drivers/net/wireless/mwifiex/11h.c
 create mode 100644 drivers/net/wireless/ti/wlcore/sysfs.c
 create mode 100644 drivers/net/wireless/ti/wlcore/sysfs.h
 create mode 100644 drivers/nfc/nfcsim.c
 delete mode 100644 include/linux/can/platform/flexcan.h
 create mode 100644 include/linux/platform_data/net-cw1200.h
 create mode 100644 include/net/ll_poll.h
 delete mode 100644 net/batman-adv/ring_buffer.c
 delete mode 100644 net/batman-adv/ring_buffer.h
 delete mode 100644 net/ipv4/gre.c
 create mode 100644 net/ipv4/gre_demux.c
 create mode 100644 net/ipv4/gre_offload.c
 create mode 100644 net/ipv4/ip_tunnel_core.c
 create mode 100644 net/ipv4/tcp_offload.c
 create mode 100644 net/ipv4/udp_offload.c
 create mode 100644 net/ipv6/ping.c
 create mode 100644 net/mpls/Kconfig
 create mode 100644 net/mpls/Makefile
 create mode 100644 net/mpls/mpls_gso.c
 create mode 100644 net/nfc/nci/spi.c
 create mode 100644 net/openvswitch/vport-gre.c
 create mode 100644 net/tipc/server.c
 create mode 100644 net/tipc/server.h
 create mode 100644 net/tipc/sysctl.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
