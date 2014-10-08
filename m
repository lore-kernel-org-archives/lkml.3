Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaJHVVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:21:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57836 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbaJHVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:21:05 -0400
Date: Wed, 08 Oct 2014 17:20:58 -0400 (EDT)
Message-Id: <20141008.172058.241925468546747538.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Oct 2014 14:21:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s98LNTu5027068


I did a test merge with your tree and there are three conflicts to resolve:

1) net/ipv4/tcp

   This is overlapping stuff with the CONFIG_NET_DMA removal.  Keep the
   net-next conflict hunks but kill the third boolean argument to
   sk_eat_skb().

2) Documentation/networking/timestamping/Makefile

   net-next adds a leading comment to this file, and adds a new
   target to hostprogs-y.  Preserve all of this, and do that the
   change in your tree did, which is make the list of targets
   in hostprogs-y alphabetical.

   Your side removes the obj- := dummy.o thing, as well as the
   clean target, and those should be preserved as well.

3) include/linux/skbuff.h

   More overlapping stuff with the CONFIG_NET_DMA removal.

   Preserve net-next hunks, and then change the:

#if defined CONFIG_NET_DMA || defined CONFIG_NET_RX_BUSY_POLL
      union {
              unsigned int    napi_id;
              dma_cookie_t    dma_cookie;
      };
#endif

   into:

#ifdef CONFIG_NET_RX_BUSY_POLL
      unsigned int    napi_id;
#endif

Most notable changes in here:

1) By far the biggest accomplishment, thanks to a large range of contributors,
   is the addition of multi-send for transmit.  This is the result of discussions
   back in Chicago, and the hard work of several individuals.

   Now, when the ->ndo_start_xmit() method of a driver sees skb->xmit_more as
   true, it can choose to defer the doorbell telling the driver to start
   processing the new TX queue entires.

   skb->xmit_more means that the generic networking is guaranteed to call the
   driver immediately with another SKB to send.

   There is logic added to the qdisc layer to dequeue multiple packets
   at a time, and the handling mis-predicted offloads in software is
   now done with no locks held.

   Finally, pktgen is extended to have a "burst" parameter that can be used to
   test a multi-send implementation.

   Several drivers have xmit_more support: i40e, igb, ixgbe, mlx4, virtio_net

   Adding support is almost trivial, so export more drivers to support this
   optimization soon.

   I want to thank, in no particular or implied order, Jesper Dangaard
   Brouer, Eric Dumazet, Alexander Duyck, Tom Herbert, Jamal Hadi
   Salim, John Fastabend, Florian Westphal, Daniel Borkmann, David
   Tat, Hannes Frederic Sowa, and Rusty Russell.

2) PTP and timestamping support in bnx2x, from Michal Kalderon.

3) Allow adjusting the rx_copybreak threshold for a driver via
   ethtool, and add rx_copybreak support to enic driver.  From
   Govindarajulu Varadarajan.

4) Significant enhancements to the generic PHY layer and the
   bcm7xxx driver in particular (EEE support, auto power down,
   etc.) from Florian Fainelli.

5) Allow raw buffers to be used for flow dissection, allowing drivers
   to determine the optimal "linear pull" size for devices that
   DMA into pools of pages.  The objective is to get exactly the
   necessary amount of headers into the linear SKB area pre-pulled,
   but no more.  The new interface drivers use is eth_get_headlen().
   From WANG Cong, with driver conversions (several had their own
   by-hand duplicated implementations) by Alexander Duyck and
   Eric Dumazet.

6) Support checksumming more smoothly and efficiently for encapsulations,
   and add "foo over UDP" facility.  From Tom Herbert.

7) Add Broadcom SF2 switch driver to DSA layer, from Florian Fainelli.

8) eBPF now can load programs via a system call and has an extensive
   testsuite.  Alexei Starovoitov and Daniel Borkmann.

9) Major overhaul of the packet scheduler to use RCU in several major
   areas such as the classifiers and rate estimators.  From John
   Fastabend.

10) Add driver for Intel FM10000 Ethernet Switch, from Alexander Duyck.

11) Rearrange TCP_SKB_CB() to reduce cache line misses, from Eric
    Dumazet.

12) Add Datacenter TCP congestion control algorithm support, From
    Florian Westphal.

13) Reorganize sk_buff so that __copy_skb_header() is significantly
    faster.  From Eric Dumazet.

Please pull, thanks a lot!

The following changes since commit ee042ec88022249b848306dd6e87ffd2fd88a839:

  Merge tag 'md/3.17-final-fix' of git://neil.brown.name/md (2014-10-03 08:40:37 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to 64b1f00a0830e1c53874067273a096b228d83d36:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-10-08 16:22:22 -0400)

----------------------------------------------------------------

Ajit Khaparde (1):
      be2net: fix RX fragment posting for jumbo frames

Alex Gartrell (10):
      ipvs: Add destination address family to netlink interface
      ipvs: Supply destination addr family to ip_vs_{lookup_dest,find_dest}
      ipvs: Pass destination address family to ip_vs_trash_get_dest
      ipvs: Supply destination address family to ip_vs_conn_new
      ipvs: prevent mixing heterogeneous pools and synchronization
      ipvs: Pull out crosses_local_route_boundary logic
      ipvs: Pull out update_pmtu code
      ipvs: Add generic ensure_mtu_is_adequate to handle mixed pools
      ipvs: support ipv4 in ipv6 and ipv6 in ipv4 tunnel forwarding
      ipvs: Allow heterogeneous pools now that we support them

Alexander Aring (1):
      ieee802154: 6lowpan: remove unused function

Alexander Bondar (1):
      iwlwifi: mvm: Allow schedule scan while connected

Alexander Duyck (47):
      ixgbe: Cleanup FDB handling code
      net-timestamp: Merge shared code between phy and regular timestamping
      net-timestamp: Make the clone operation stand-alone from phy timestamping
      net: merge cases where sock_efree and sock_edemux are the same function
      net: Add function for parsing the header length out of linear ethernet frames
      igb: use new eth_get_headlen interface
      ixgbe: use new eth_get_headlen interface
      dp83640: Make use of skb_queue_purge instead of reimplementing the code
      ixgbe: Drop Rx alloc at end of Rx cleanup
      ixgbe: Refactor busy poll socket code to address multiple issues
      skb: Add documentation for skb_clone_sk
      mac80211: Resolve sk_refcnt/sk_wmem_alloc issue in wifi ack path
      netdevice: Support DSA tagging when DSA is built as a module
      dsa: Split ops up, and avoid assigning tag_protocol and receive separately
      dsa: Replace mii_bus with a generic host device
      fm10k: Add skeletal frame for Intel(R) FM10000 Ethernet Switch Host Interface Driver
      fm10k: Add register defines and basic structures
      fm10k: Add support for TLV message parsing and generation
      fm10k: Add support for basic interaction with hardware
      fm10k: Add support for mailbox
      fm10k: Implement PF <-> SM mailbox operations
      fm10k: Add support for PF
      fm10k: Add support for configuring PF interface
      fm10k: Add netdev
      fm10k: Add support for L2 filtering
      fm10k: Add support for ndo_open/stop
      fm10k: Add interrupt support
      fm10k: add support for Tx/Rx rings
      fm10k: Add service task to handle delayed events
      fm10k: Add Tx/Rx hardware ring bring-up/tear-down
      fm10k: Add transmit and receive fastpath and interrupt handlers
      fm10k: Add ethtool support
      fm10k: Add support for PCI power management and error handling
      fm10k: Add support for multiple queues
      fm10k: Add support for netdev offloads
      fm10k: Add support for MACVLAN acceleration
      fm10k: Add support for PF <-> VF mailbox
      fm10k: Add support for VF
      fm10k: Add support for SR-IOV to PF core files
      fm10k: Add support for SR-IOV to driver
      fm10k: Add support for IEEE DCBx
      fm10k: Add support for debugfs
      fm10k: Add support for ptp to hw specific files
      fm10k: Add support for PTP
      fm10k: Reduce buffer size when pages are larger than 4K
      fm10k: Correctly set the number of Tx queues
      Update Intel Ethernet Driver maintainers list

Alexei Starovoitov (20):
      bpf: x86: add missing 'shift by register' instructions to x64 eBPF JIT
      net: filter: add "load 64-bit immediate" eBPF instruction
      net: filter: split filter.h and expose eBPF to user space
      sparc: bpf_jit: add SKF_AD_PKTTYPE support to JIT
      net: bpf: fix compiler warnings in test_bpf
      bpf: introduce BPF syscall and maps
      bpf: enable bpf syscall on x64 and i386
      bpf: add lookup/update/delete/iterate methods to BPF maps
      bpf: expand BPF syscall with program load/unload
      bpf: handle pseudo BPF_CALL insn
      bpf: verifier (add docs)
      bpf: verifier (add ability to receive verification log)
      bpf: handle pseudo BPF_LD_IMM64 insn
      bpf: verifier (add branch/goto checks)
      bpf: verifier (add verifier core)
      bpf: mini eBPF library, test stubs and verifier testsuite
      sparc: bpf_jit: add support for BPF_LD(X) | BPF_LEN instructions
      bpf: add search pruning optimization to verifier
      bpf: add tests to verifier testsuite
      net: pktgen: packet bursting via skb->xmit_more

Alexey Perevalov (1):
      netfilter: nfnetlink_acct: add filter support to nfacct counter list/reset

Amir Vadai (3):
      crash_dump: Make is_kdump_kernel() accessible from modules
      net/mlx4: Use is_kdump_kernel() to detect kdump kernel
      net/bnx2x: Use is_kdump_kernel() to detect kdump kernel

Amitkumar Karwar (11):
      mwifiex: fix left_len calculation issue
      mwifiex: rename macro and variables related to API revision
      mwifiex: use firmware API revision from GET_HW_SPEC response
      mwifiex: fix a bug in Tx multiport aggregation
      mwifiex: minor cleanup in multiport aggregation
      mwifiex: remove redundant variable report_scan_result
      mwifiex: remove low priority scan handling
      Bluetooth: btmrvl: rename definitions from 88xx to 8897
      Bluetooth: btusb: remove redundant lock variable
      mwifiex: error path handling in pcie firmware dump
      mwifiex: add more dump information for PCIe interface

Ana Rey (3):
      netfilter: nft_meta: add pkttype support
      netfilter: nft_meta: Add cpu attribute support
      netfilter: nf_tables: add devgroup support in meta expresion

Andreea-Cristina Bernat (9):
      cnic: Replace rcu_dereference() with rcu_access_pointer()
      bonding: Replace rcu_dereference() with rcu_access_pointer()
      net/ipv4/igmp.c: Replace rcu_dereference() with rcu_access_pointer()
      net/openvswitch/flow.c: Replace rcu_dereference() with rcu_access_pointer()
      br_multicast: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
      mac80211: scan: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
      mac80211: Replace rcu_dereference() with rcu_access_pointer()
      carl9170: Remove redundant protection check
      carl9170: tx: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Andrei Otcheretianski (4):
      ieee80211: Support parsing TPC report element in action frames
      iwlwifi: mvm: Update TX power in TPC reports
      iwlwifi: mvm: Set RRM_ENABLED bit in scan commands
      iwlwifi: mvm: Refactor and fix max probe len computation

Andrew Lunn (1):
      net: DSA: Marvell mv88e6171 switch driver

Andy Gospodarek (1):
      bonding: make global bonding stats more reliable

Andy Shevchenko (3):
      rose: use %*ph specifier
      irda: vlsi_ir: use %*ph specifier
      hostap: proc: substitute loops by %*phN

Andy Zhou (13):
      l2tp: fix missing line continuation
      openvswitch: simplify sample action implementation
      openvswitch: Add recirc and hash action.
      udp_tunnel: Seperate ipv6 functions into its own file.
      udp-tunnel: Add a few more UDP tunnel APIs
      vxlan: Refactor vxlan driver to make use of the common UDP tunnel functions.
      l2tp: Refactor l2tp core driver to make use of the common UDP tunnel functions
      udp_tunnel: Only build ip6_udp_tunnel.c when IPV6 is selected
      vxlan: Fix bug introduced by commit acbf74a76300
      net: Add Geneve tunneling protocol driver
      net: fix a sparse warning
      openvswitch: fix a sparse warning
      openvswitch: fix a compilation error when CONFIG_INET is not setW!

Anjali Singhai Jain (5):
      i40e: Some FD message fixes
      i40e: ATR policy change to flush the table to clean stale ATR rules
      i40e: Add a FD flush counter to ethtool
      i40e/i40evf: Ignore a driver perceived Tx hang if the number of desc pending < 4
      i40e: Fix an issue when PF reset fails

Antoine T√©nart (13):
      net: pxa168_eth: clean up
      net: pxa168_eth: add device tree support
      Documentation: bindings: net: add the Marvell PXA168 Ethernet controller
      net: pxa168_eth: fix Ethernet flow control status
      net: pxa168_eth: set the mac address on the Ethernet controller
      net: pxa168_eth: rework the MAC address setup
      net: pxa168_eth: allow Berlin SoCs to use the pxa168_eth driver
      net: pxa168_eth: allow to compile the pxa168_eth driver for tests
      ARM: dts: berlin: add the Ethernet node
      ARM: dts: berlin: enable the Ethernet port on the BG2Q DMP
      net: spider_net: do not read mac address again after setting it
      net: spider_net: avoid using signed char for bitops
      net: pxa168_eth: avoid using signed char for bitops

Anton Danilov (5):
      netfilter: ipset: Add skbinfo extension kernel support in the ipset core.
      netfilter: ipset: Add skbinfo extension kernel support for the bitmap set types.
      netfilter: ipset: Add skbinfo extension kernel support for the hash set types.
      netfilter: ipset: Add skbinfo extension kernel support for the list set type.
      netfilter: ipset: Add skbinfo extension support to SET target.

Arend van Spriel (1):
      brcmfmac: assure P2P discovery is disabled when setting P2P_DEVICE mac address

Ariel Elior (1):
      bnx2x: FW assertion changes

Arik Nemtsov (3):
      mac80211: set network header in TDLS frames
      iwlwifi: mvm: move TDLS code to separate file
      iwlwifi: mvm: fix PSM disable during TDLS

Arturo Borrero (11):
      netfilter: nf_tables: refactor rule deletion helper
      netfilter: nf_tables: add helper to unregister chain hooks
      netfilter: nf_tables: rename nf_table_delrule_by_chain()
      netfilter: nf_tables: add helpers to schedule objects deletion
      netfilter: nf_tables: extend NFT_MSG_DELTABLE to support flushing the ruleset
      netfilter: nft_nat: include a flag attribute
      netfilter: nf_nat: generalize IPv4 masquerading support for nf_tables
      netfilter: nf_nat: generalize IPv6 masquerading support for nf_tables
      netfilter: nf_tables: add new nft_masq expression
      netfilter: nf_tables: store and dump set policy
      netfilter: nft_masq: register/unregister notifiers on module init/exit

Ashish Shah (1):
      i40e: set num_queue_pairs to num configured by VF

Assaf Krauss (4):
      nl80211: Allow declaring RRM-related features
      nl80211: Add flag attribute for RRM connections
      mac80211: Add RRM support to assoc request
      iwlwifi: mvm: Announce Quiet Period support

Avinash Patil (17):
      mwifiex: set fw api info for backword compatibility
      mwifiex: fix probable memory corruption while processing TDLS frame
      mwifiex: avoid processing RX packets with invalid length
      mwifiex: rework internal scan for association
      mwifiex: support for event done interrupt
      mwifiex: set passive scan type for scan requests with no ssid
      mwifiex: bring in scan channel gap feature
      mwifiex: remove restriction of single channel scan when connected
      mwifiex: process TX even when scan is ongoing
      mwifiex: add rx workqueue support
      mwifiex: modify TX/RX window sizes for AP interface
      mwifiex: ensure user_scan_in not NULL while setting scan channel gap
      mwifiex: fix soft lockup during iperf UDP RX
      mwifiex: do not decrement rx_pending count twice
      mwifiex: remove unnecessary rx_q lock
      mwifiex: few more register offset entries for sdio card structure
      mwifiex: add support for SD8887 chipset

Avri Altman (5):
      iwlwifi: consolidate hw scheduler configuration code
      iwlwifi: trans: configure the scheduler enable register
      iwlwifi: mvm: remove unused static inline function
      iwlwifi: mvm: Fix skip over dtim configuration in d0i3
      iwlwifi: mvm: prepare for scheduler config command

Axel Lin (1):
      NFC: st21nfca: Convert to use devm_gpio_request_one

Behan Webster (1):
      Bluetooth: LLVMLinux: Remove VLAIS from bluetooth/amp.c

Ben Greear (5):
      ath10k: improve 'hard' simulate fw crash
      ath10k: improve vdev map handling
      ath10k: fix typo in error message
      ath10k: provide firmware crash info via debugfs
      ath10k: support firmware crash-by-assert

Beniamino Galvani (3):
      net: phy: mdio-sun4i: don't select REGULATOR
      net: stmmac: add Amlogic Meson glue layer
      net: stmmac: meson: document device tree bindings

Bernhard Kaindl (1):
      igb: remove blocking phy read from inside spinlock

Bernhard Thaler (1):
      Bluetooth: Check for SCO type before setting retransmission effort

Bo Shen (1):
      net/macb: Add hardware revision information during probe

Bob Copeland (4):
      mac80211: mesh_plink: use get_unaligned_le16 instead of memcpy
      ath5k: drop useless comparison
      ath5k: ensure led name is null terminated
      ath5k: remove redundant null check before kfree()

Bojan Prtvar (1):
      netfilter: xt_string: Remove unnecessary initialization of struct ts_state

Canek Pel√°ez Vald√©s (1):
      rt2x00: support Ralink 5362.

Carolyn Wyborny (2):
      i40e: Update flow director error messages to reduce user confusion
      i40e: Add checks and message for Qualified Module info

Catherine Sullivan (5):
      i40e/i40evf: Bump i40e & i40evf version
      i40e: Add dual speed module support
      i40e: Allow user to change link settings if link is down
      i40e: Tell OS link is going down when calling set_phy_config
      i40e/i40evf: Bump i40e/i40evf versions

Champion Chen (1):
      Bluetooth: Fix issue with USB suspend in btusb driver

Chen Gang (5):
      drivers/net/can/Kconfig: Let CAN_AT91 depend on HAS_IOMEM
      drivers/net/dsa/Kconfig: Let NET_DSA_BCM_SF2 depend on HAS_IOMEM
      drivers/net/ethernet/marvell/Kconfig: Let PXA168_ETH depend on HAS_IOMEM
      drivers/net/irda/Kconfig: Let SH_IRDA depend on HAS_IOMEM
      drivers/net/phy/Kconfig: Let MDIO_BCM_UNIMAC depend on HAS_IOMEM

Christian Riesch (1):
      dp83640: Fix length check for event timestamp status messages

Christophe Gouault (2):
      xfrm: hash prefixed policies based on preflen thresholds
      xfrm: configure policy hash table thresholds by netlink

Christophe Ricard (29):
      NFC: st21nfca: Fix sparse: cast to restricted __be32
      NFC: st21nfca: Fix scripts/checkpatch.pl warnings "Missing a blank line after declarations"
      NFC: st21nfcb: Fix scripts/checkpatch.pl error "code indent should use tabs where possible"
      NFC: st21nfcb: Convert to use devm_gpio_request_one
      NFC: st21nfcb: Remove double assignment of .owner in struct device_driver
      NFC: st21nfcb: Remove useless new line in nfc_err call
      NFC: st21nfcb: Remove inappropriate kfree on a previously devm_kzalloc pointer
      NFC: st21nfca: Fix logic when setting session_id
      NFC: st21nfca: Remove useless new line in nfc_err call
      NFC: st21nfca: Change nfcid3 generation
      NFC: st21nfca: Remove useless err == 0 condition
      NFC: st21nfca: Remove useless IS_ERR(skb) conditions
      NFC: st21nfca: Add condition to make sure atr_req->length is valid.
      NFC: st21nfcb: Fix logic when running into i2c read retry
      NFC: st21nfca: Clean up st21nfca.h macros
      NFC: st21nfca: Clean up macros alignment
      NFC: st21nfca: fix "WARNING: else is not generally useful after a break or return"
      NFC: st21nfcb: Remove useless headers
      NFC: st21nfca: Fix few coding style issue
      NFC: st21nfca: Fix potential skb leaks in NFC-DEP code
      NFC: st21nfca: Fix recursive fault when doing p2p in target mode.
      NFC: dts: st21nfcb_i2c: Fix invalid interrupts polarity.
      NFC: st21nfcb: Fix improper management of -EREMOTEIO error code.
      NFC: st21nfcb: Fix improper ndlc T2 management
      NFC: nci: Add support for proprietary RF Protocols
      NFC: st21nfcb: Add ISO15693 Reader/Writer support
      NFC: st21nfcb: remove error output
      NFC: st21nfca: ERR_PTR vs NULL fix
      NFC: st21nfca: Fix potential double kfree_skb error

Chun-Hao Lin (12):
      r8169:add support for RTL8168H and RTL8107E
      r8169:change uppercase number to lowercase number
      r8169:add disable/enable RTL8168G pll function
      r8169:add disable/enable RTL8411B pll function
      r8169:add support more chips to get mac address from backup mac address register
      r8169:add more chips to support magic packet v2
      r8169:for function "rtl_w1w0_phy" change its name and behavior
      r8169:change the name of function"rtl_w1w0_eri"
      r8169:change the name of function "r8168dp_check_dash" to "r8168_check_dash"
      r8169:modify the behavior of function "rtl8168_oob_notify"
      r8169:call "rtl8168_driver_start" "rtl8168_driver_stop" only when hardware dash function is enabled
      r8169:add support for RTL8168EP

Colin Ian King (1):
      mISDN: remove DSP_NEVER_DEFINED and adjust code identation

Csaba Kiraly (1):
      ath9k_htc: advertise support for TDLS

Dan Carpenter (4):
      MAINTAINTERS: The NFC list is subscribers-only
      hyperv: NULL dereference on error
      cxgb4: potential shift wrapping bug
      cxgb4: clean up a type issue

Daniel Borkmann (17):
      net: use reciprocal_scale() helper
      random32: improvements to prandom_bytes
      ixgbe: support skb->xmit_more in netdev_ops->ndo_start_xmit()
      ixgbe: flush when in xmit_more mode and under descriptor pressure
      net: add skb_get_tx_queue() helper
      net: bpf: make eBPF interpreter images read-only
      dev_ioctl: remove dev_load() CAP_SYS_MODULE message
      net: bpf: consolidate JIT binary allocator
      net: bpf: arm: address randomize and write protect JIT code
      net: bpf: be friendly to kmemcheck
      ipv6: mcast: remove dead debugging defines
      net: bpf: only build bpf_jit_binary_{alloc, free}() when jit selected
      ipv6: mld: answer mldv2 queries with mldv1 reports in mldv1 fallback
      net: bpf: arm: make hole-faulting more robust
      net: tcp: add flag for ca to indicate that ECN is required
      net: tcp: add DCTCP congestion control algorithm
      ipv4: igmp: fix v3 general query drop monitor false positive

Daniel Mack (1):
      net: ethernet: cpsw: improve interrupt lookup logic in cpsw_probe()

Darek Marcinkiewicz (1):
      net: ec_bhf: remove excessive debug messages

David L Stevens (5):
      sunvnet: upgrade to VIO protocol version 1.6
      sunvnet: make transmit path zero-copy in the kernel
      sunvnet: allow admin to set sunvnet MTU
      sunvnet: generate ICMP PTMUD messages for smaller port MTUs
      sunvnet: fix potential NULL pointer dereference

David S. Miller (120):
      Merge branch 'bnx2x-next'
      Merge tag 'linux-can-next-for-3.18-20140820' of git://gitorious.org/linux-can/linux-can-next
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'tipc-next'
      Merge branch 'bcm7xxx_apd_eee'
      net: Allow raw buffers to be passed into the flow dissector.
      Merge branch 'csums-next'
      net: Add ops->ndo_xmit_flush()
      igb: Support netdev_ops->ndo_xmit_flush()
      virtio_net: Support netdev_ops->ndo_xmit_flush()
      Merge branch 'ndo_xmit_flush'
      Merge branch 'is_kdump_kernel'
      net: Remove ndo_xmit_flush netdev operation, use signalling instead.
      Merge branch 'bnx2x-next'
      net: Update sk_buff flag bit availability comment.
      f_ncm: Don't use netdev_start_xmit().
      tulip: dmfe: Fix global namespace pollution of phy accessors.
      sungem: Fix global namespace pollution of phy accessors.
      sungem: Fix global namespace pollution of phy accessors.
      Merge branch 'sf2'
      Merge branch 'bcm7xxx'
      igb: flush when in xmit_more mode and under descriptor pressure
      virtio_net: flush when in xmit_more mode and under descriptor pressure
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'qlcnic-next'
      Merge branch 'csums-next'
      net: Do txq_trans_update() in netdev_start_xmit()
      net: Create xmit_one() helper for dev_hard_start_xmit()
      net: Move main gso loop out of dev_hard_start_xmit() into helper.
      net: Pass a "more" indication down into netdev_start_xmit() code paths.
      net: Have xmit_list() signal more==true when appropriate.
      net: Separate out SKB validation logic from transmit path.
      net: Validate xmit SKBs right when we pull them out of the qdisc.
      net: Don't keep around original SKB when we software segment GSO frames.
      net: xmit_list() becomes dev_hard_start_xmit().
      Merge branch 'xmit_list'
      Merge branch 'csums-next'
      Merge branch 'be2net-next'
      Merge branch 'netdev_modified'
      Merge branch 'rx_copybreak'
      Merge branch 'r8152-next'
      Merge branch 'amd-xgbe-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'timestamping'
      Merge branch 'eth_get_headlen'
      Merge branch 'tcp'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge git://git.kernel.org/.../davem/net
      Merge tag 'master-2014-09-08' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'ebpf'
      Merge branch 'bridge_rtnl_link'
      Merge branch 'bpf-next'
      Merge branch 'bond_lock_removal'
      Merge branch 'ipip_sit_gro'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'cxgb4-next'
      Merge branch 'sock_queue_err_skb'
      Merge branch 'sched_rcu'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'bonding-next'
      Merge branch 'ipv6-cleanups'
      Merge branch 'be2net-next'
      Merge branch 'fec-next'
      Merge branch 'tcpflags'
      Merge branch 'bonding-cleanups'
      Merge branch 'dsa-next'
      Merge branch 'net_next_ovs' of git://git.kernel.org/.../pshelar/openvswitch
      Merge branch 'fec-next'
      Merge branch 'udp-tunnel-common'
      Merge branch 'fec-next'
      Merge branch 'bnx2x-next'
      Merge branch 'fou-next'
      Merge branch 'mlx4-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'qlge'
      Merge branch 'dsa-suspend'
      Merge branch 'be2net-next'
      Merge git://git.kernel.org/.../davem/net
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'stmmac'
      Merge branch 'gso_send_check'
      Merge branch 'bpf-next'
      Merge tag 'master-2014-09-16' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'fec'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'tcp_skb_cb'
      Merge branch 'dsa_eee'
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'defxx-next'
      Merge branch 'r8152'
      Merge branch 'cxgb4-next'
      Merge branch 'dctcp'
      Merge branch 'qca7000_spi'
      Merge branch 'arcnet-EAE'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'am335x'
      Merge branch 'mlx4-next'
      Merge branch 'pxa168_eth'
      Merge branch 'sunvnet-jumbograms'
      Merge branch 'bpf-next'
      Merge branch 'udp_gso'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'qdisc_bulk_dequeue'
      Merge branch 'rds-net'
      Merge branch 'mlx5-next'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'gudp'
      Merge branch 'spider_net'
      Merge branch 'isdn-next'
      Merge branch 'bridge_default_pvid'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge tag 'master-2014-10-02' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'altera_tse'
      Merge branch 'geneve'
      Merge branch 'mlx4-next'
      Merge branch 'net_sched-next'
      Merge branch 'ipv6-next'
      ipv6: Do not warn for informational ICMP messages, regardless of type.
      Merge branch 'fs_enet_napi'
      Merge git://git.kernel.org/.../davem/net

David Spinadel (2):
      iwlwifi: mvm: enable passive fragmented scan changes
      iwlwifi: mvm: reduce active dwell time

David Wood (1):
      ethernet: nvidia: Remove extra parens

Dedy Lansky (7):
      wil6210: Limit max number of associated stations
      wil6210: fix for memory corruption while insmod
      wil6210: fix for memory corruption upon rmmod
      wil6210: fix race condition of disconnect while BACK event
      wil6210: modify confusing printout
      wil6210: fix race condition between BACK event and Rx data
      wil6210: introduce separate completion for WMI

Dmitry Kravkov (6):
      bnx2x: Utilize FW 7.10.51
      bnx2x: ethtool -d might cause timeout in log
      bnx2x: Be more forgiving toward SW GRO
      bnx2x: prevent incorrect byte-swap in BE
      bnx2x: fix tunneled GSO over IPv6
      bnx2x: Changes with storage & MAC macros

Dong Aisheng (2):
      can: m_can: add device tree binding documentation
      can: m_can: add Bosch M_CAN controller support

Eli Cohen (5):
      net/mlx5_core: Update device capabilities handling
      net/mlx5_core: Use hardware registers description header file
      net/mlx5_core: use set/get macros in device caps
      net/mlx5_core: Identify resources by their type
      net/mlx5_core: Add ConnectX-4 to list of supported devices

Eliad Peller (11):
      mac80211: disable 40MHz support in case of 20MHz AP
      iwlwifi: mvm: add use_ps-poll debugfs power option
      iwlwifi: mvm: clear d0i3 state on recovery
      cfg80211: avoid duplicate entries on regdomain intersection
      mac80211: adjust roc duration when combining ROCs
      mac80211: combine roc with the "next roc" if possible
      cfg80211/mac80211: add wmm info to assoc event
      cfg80211: allow requesting SMPS mode on ap start
      mac80211: set smps_mode according to ap params
      mac80211: replace SMPS hw flags with wiphy feature bits
      iwlwifi: mvm: move IWL_MVM_UAPSD_QUEUES to constants.h

Emil Goode (1):
      NFC: st21nfca: Remove double assignment of .owner in struct device_driver

Emil Tantilov (4):
      ixgbe: reset interface on link loss with pending Tx work from the VF
      ixgbevf: introduce delay for checking VFLINKS on 82599
      ixgbe: remove wait loop on autoneg for copper devices
      ixgbe: fix setting of TXDCTL.WTRHESH when ITR is set to 0 and no BQL

Emmanuel Grumbach (8):
      iwlwifi: mvm: reduce the AMPDU size in low latency mode
      iwlwifi: mvm: use dynamic SMPS for P2P Client
      iwlwifi: mvm: force protection for P2P
      Merge remote-tracking branch 'iwlwifi-fixes/master' into NEXT
      iwlwifi: trans: don't configure the set_active in SCD for dvm
      iwlwifi: define the non shared antenna per hardware
      iwlwifi: mvm: allow to collect debug data when restart is disabled
      iwlwifi: mvm: disable BT Co-running by default

Eran Harary (3):
      iwlwifi: mvm: fix the dump_umac_error_log
      iwlwifi: mvm: fix comment typo
      iwlwifi: mvm: allow preventing dummy notifications

Eric Dumazet (60):
      net: use ktime_get_ns() and ktime_get_real_ns() helpers
      net: remove dead code after sk_data_ready change
      ipv4: fix a race in update_or_create_fnhe()
      ipv4: harden fnhe_hashfun()
      tcp: introduce TCP_SKB_CB(skb)->tcp_tw_isn
      tcp: remove TCP_SKB_CB(skb)->when
      mlx4: only pull headers into skb head
      tcp: remove dst refcount false sharing for prequeue mode
      ipv4: rcu cleanup in ip_ra_control()
      ipv6: udp6_gro_complete() is static
      netns: remove one sparse warning
      ipv4: udp4_gro_complete() is static
      tcp: use TCP_SKB_CB(skb)->tcp_flags in input path
      tcp: allow segment with FIN in tcp_try_coalesce()
      tcp: do not copy headers in tcp_collapse()
      tcp: do not fake tcp headers in tcp_send_rcvq()
      net: add alloc_skb_with_frags() helper
      net: sched: use __skb_queue_head_init() where applicable
      tcp: avoid possible arithmetic overflows
      net: sched: fix compile warning in cls_u32
      icmp: add a global rate limitation
      tcp: add coalescing attempt in tcp_ofo_queue()
      net: sched: use pinned timers
      net: introduce __skb_header_release()
      net : optimize skb_release_data()
      ipv4: rename ip_options_echo to __ip_options_echo()
      ipv6: add a struct inet6_skb_parm param to ipv6_opt_accepted()
      tcp: better TCP_SKB_CB layout to reduce cache line misses
      tcp: change tcp_skb_pcount() location
      mlx4: exploit skb->xmit_more to conditionally send doorbell
      dql: dql_queued() should write first to reduce bus transactions
      net: reorganize sk_buff for faster __copy_skb_header()
      ipv4: mentions skb_gro_postpull_rcsum() in inet_gro_receive()
      net: cleanup and document skb fclone layout
      net: avoid one atomic operation in skb_clone()
      qdisc: validate skb without holding lock
      net: do not export skb_gro_receive()
      mlx4: add a new xmit_more counter
      net: skb_segment() provides list head and tail
      net: sched: avoid costly atomic operation in fq_dequeue()
      net/mlx4_en: Code cleanups in tx path
      net/mlx4_en: Align tx path structures to cache lines
      net/mlx4_en: Avoid calling bswap in tx fast path
      net/mlx4_en: tx_info allocated with kmalloc() instead of vmalloc()
      net/mlx4_en: Avoid a cache line miss in TX completion for single frag skb's
      net/mlx4_en: Use prefetch in tx path
      net/mlx4_en: Avoid false sharing in mlx4_en_en_process_tx_cq()
      net/mlx4_en: mlx4_en_xmit() reads ring->cons once, and ahead of time to avoid stalls
      net/mlx4_en: Use local var in tx flow for skb_shinfo(skb)
      net/mlx4_en: Use local var for skb_headlen(skb)
      net/mlx4_en: tx_info->ts_requested was not cleared
      net/mlx4_en: Enable the compiler to make is_inline() inlined
      ethtool: Ethtool parameter to dynamically change tx_copybreak
      net/mlx4_en: Use the new tx_copybreak to set inline threshold
      net: introduce netdevice gso_min_segs attribute
      net: validate_xmit_vlan() is static
      net/mlx4_en: remove NETDEV_TX_BUSY
      net: better IFF_XMIT_DST_RELEASE support
      i40e: skb->xmit_more support
      net: add netdev_txq_bql_{enqueue, complete}_prefetchw() helpers

Erik Hugne (3):
      tipc: refactor name table updates out of named packet receive routine
      tipc: add name distributor resiliency queue
      tipc: fix sparse warnings

Ethan Zhao (4):
      i40e: use global pci_vfs_assigned() to replace local i40e_vfs_are_assigned()
      ixgbevf: remove useless bd_number from struct ixgbevf_adapter
      ixgbe: remove useless bd_number from adapter struct
      ixgbe: delete one duplicate marcro definition of IXGBE_MAX_L2A_QUEUES

Eyal Shapira (11):
      iwlwifi: mvm: disable tx aggregation on low latency vifs
      mac80211: fix broken use of VHT/20Mhz with some APs
      iwlwifi: mvm: add LDPC support
      iwlwifi: enable LDPC in 8000 chip family
      iwlwifi: mvm: rs: remove max_rate_idx
      iwlwifi: mvm: rs: don't zero tx stats after idle
      iwlwifi: mvm: choose an initial tx rate based on rssi conditions
      iwlwifi: mvm: rs: refactor to allow direct rs updating
      iwlwifi: mvm: limit aggregation size in low latency to 6
      iwlwifi: mvm: report all BA notifs to RS
      iwlwifi: mvm: rs: fix logic in case of multiple TIDs

Fabian Frederick (16):
      net: fec: use container_of to resolve bufdesc_ex from bufdesc
      bna: use container_of to resolve bufdesc_ex from bufdesc
      brcm80211: use container_of to resolve brcms_phy from brcms_phy_pub
      brcm80211: use container_of to resolve dma_info from dma_pub
      irda: add __init to irlan_open
      ieee802154: add __init to lowpan_frags_sysctl_register
      ieee802154: fix __init functions
      tcp: add __init to tcp_init_mem
      inet: frags: add __init to ip4_frags_ctl_register
      cipso: add __init to cipso_v4_cache_init
      net/dccp/proto.c: add __init to dccp_mib_init
      net/dccp/ccid.c: add __init to ccid_activate
      net: fix rcu access on phonet_routes
      af_unix: remove 0 assignment on static
      wimax: convert printk to pr_foo()
      netlabel: directly return netlbl_unlabel_genl_init()

Fabio Estevam (2):
      fec: Remove fec_enet_select_queue()
      fec: Fix fec_enet_alloc_buffers() error path

Felix Fietkau (7):
      ath5k: add missing include for debug code
      ath9k: use ah->get_mac_revision for all SoC devices if available
      ath9k_hw: disable hardware ad-hoc flag on ar934x rev 3
      Revert "ath9k_hw: reduce ANI firstep range for older chips"
      ath9k_hw: reduce ANI spur immunity setting on HT40 extension channel
      ath9k_hw: fix PLL clock initialization for newer SoC
      ath9k: fix getting tx duration for dynack

Florian Fainelli (52):
      net: phy: broadcom: extract all registers to brcmphy.h
      net: phy: broadcom: move shadow 0x1C register accessors to brcmphy.h
      net: phy: bcm7xxx: enable auto power down
      net: phy: fixed: return an error for Clause 45 over 22 reads
      net: phy: export phy_{read,write}_mmd_indirect
      net: phy: allow phy_init_eee() to work with internal PHYs
      net: phy: bcm7xxx: enable EEE at the PHY level
      net: dsa: reduce number of protocol hooks
      net: phy: add generic UniMAC MDIO bus driver
      net: phy: provide stub for fixed_phy_set_link_update
      net: dsa: provide a switch device device tree node pointer
      net: dsa: retain a per-port device_node pointer
      net: dsa: allow for more complex PHY setups
      net: dsa: allow switches to work without tagging
      net: dsa: allow drivers to do link adjustment
      net: dsa: allow updating fixed PHY link information
      net: dsa: add Broadcom tag RX/TX handler
      net: dsa: add Broadcom SF2 switch driver
      Documentation: devicetree: update dsa binding with optional properties
      Documentation: devicetree: add Broadcom Starfighter 2 binding
      net: phy: bcm7xxx: introduce helper macro
      net: phy: broadcom: fix PHY_BCM_OUI_4
      net: phy: broadcom: add new Broadcom OUI
      net: phy: bcm7xxx: add BCM7250 and BCM7364 PHY entries
      net: phy: properly report internal PHYs through sysfs
      net: systemport: tell RXCHK if we are using Broadcom tags
      net: dsa: make dsa_pack_type static
      net: phy: mdio-bcm-unimac: NULL-terminate unimac_mdio_ids
      net: systemport: update UMAC_CMD only when link is detected
      net: dsa: change tag_protocol to an enum
      net: dsa: fix mii_bus to host_dev replacement
      of: mdio: honor flags passed to of_phy_connect
      net: phy: broadcom: add helper for PHY revision and patch level
      net: phy: bcm7xxx: do not use PHY_BRCM_100MBPS_WAR
      net: bcmgenet: remove PHY_BRCM_100MBPS_WAR
      net: bcmgenet: communicate integrated PHY revision to PHY driver
      net: dsa: allow switch drivers to specify phy_device::dev_flags
      net: dsa: bcm_sf2: communicate integrated PHY revision to PHY driver
      net: phy: bcm7xxx: utilize PHY revision in config_init
      net: dsa: allow switch drivers to implement suspend/resume hooks
      net: dsa: bcm_sf2: add suspend/resume callbacks
      net: dsa: add {get, set}_wol callbacks to slave devices
      net: dsa: bcm_sf2: add support for Wake-on-LAN
      net: dsa: start and stop the PHY state machine
      net: dsa: allow enabling and disable switch ports
      net: dsa: bcm_sf2: disable RGMII interface(s) when link is down
      net: dsa: bcm_sf2: add port_enable/disable callbacks
      net: dsa: allow switches driver to implement get/set EEE
      net: dsa: bcm_sf2: add support for controlling EEE
      net: bridge: add a br_set_state helper function
      net: systemport: fix bcm_sysport_insert_tsb()
      net: dsa: do not call phy_start_aneg

Florian Westphal (18):
      tcp: syncookies: mark cookie_secret read_mostly
      net_sched: sfq: remove unused macro
      net: use kfree_skb_list() helper in more places
      e1000: move e1000_tbi_adjust_stats to where its used
      e1000: move tbi workaround code into helper function
      e1000: perform copybreak ahead of DMA unmap
      e1000: add and use e1000_rx_buffer info for Rx
      e1000: rename struct e1000_buffer to e1000_tx_buffer
      e1000: convert to build_skb
      e1000: switch to napi_gro_frags api
      net: tcp: assign tcp cong_ops when tcp sk is created
      net: tcp: split ack slow/fast events from cwnd_event
      net: tcp: more detailed ACK events and events for CE marked packets
      netfilter: conntrack: disable generic tracking for known protocols
      tcp: move TCP_ECN_create_request out of header
      tcp: change TCP_ECN prefixes to lower case
      netfilter: bridge: build br_nf_core only if required
      r8169: add support for Byte Queue Limits

Francois Romieu (1):
      r8169: add missing MODULE_FIRMWARE.

Frank Li (7):
      net: fec: init multi queue date structure
      net: fec: add enet-avb IP support
      ARM: Documentation: Update fec dts binding doc
      ARM: dts: imx6sx: add multi-queue support enet
      net: fec: fix build error at m68k platform
      net: fec: refine error handle of parser queue number from DT
      net: fec: fix build error at m68k platform

Fugang Duan (11):
      net:fec: add enet refrence clock for i.MX 6SX chip
      net:fec: add enet AVB feature macro define for imx6sx
      net: fec: change data structure to support multiqueue
      net: fec: parser max queue number from dt file
      net:fec: Disable enet-avb MAC instead of reset MAC
      net:fec: Add fsl,imx6sx-fec compatible strings
      net: fec: change FEC alignment according to i.mx6 sx requirement
      net: fec: init complete variable in early to avoid kernel dump
      net: fec: add interrupt coalescence feature support
      net:fec: increase DMA queue number
      net: fec: Workaround for imx6sx enet tx hang when enable three queues

Govindarajulu Varadarajan (3):
      enic: implement rx_copybreak
      ethtool: Add generic options for tunables
      enic: Add tunable_ops support for rx_copybreak

Guenter Roeck (1):
      next: mips: bpf: Fix build failure

Haiyang Zhang (1):
      hyperv: Increase the buffer length for netvsc_channel_cb()

Hannes Frederic Sowa (8):
      ipv6: add sysctl_mld_qrv to configure query robustness variable
      ipv4: implement igmp_qrv sysctl to tune igmp robustness variable
      net: filter: constify detection of pkt_type_offset
      ipv6: minor fib6 cleanups like type safety, bool conversion, inline removal
      ipv6: make rt_sernum atomic and serial number fields ordinary ints
      ipv6: only generate one new serial number per fib mutation
      ipv6: make fib6 serial number per namespace
      ipv6: don't walk node's leaf during serial number update

Hans Wennborg (4):
      ath6kl: fix %d confusingly prefixed with 0x in format strings
      mwifiex: fix decimal printf format specifiers prefixed with 0x
      iwl4965: fix %d confusingly prefixed with 0x in format string
      rtlwifi: fix %d confusingly prefixed with 0x in format strings

Hante Meuleman (5):
      brcmfmac: On scan timeout do send received results.
      brcmfmac: Fix sign issue with IOCTL return code in msgbuf.
      brcmfmac: Avoid usage of GFP_ATOMIC.
      brcmfmac: Fix crash on cleanup.
      brcmfmac: Add wowl support for PCIE devices.

Hariprasad Shenai (9):
      cxgb4: Allow T4/T5 firmware sizes up to 1MB
      cxgb4: Add support to S25FL032P flash
      cxgb4: Fix t4_flash_erase_sectors() to throw an error when requested to erase sectors which aren't in the FLASH
      cxgb4: Add warning msg when attaching to adapters which have FLASHes smaller than 2Mb
      cxgb4/cxgb4vf: Add device ID for new adapter and remove for dbg adapter
      cxgb4: Use BAR2 Going To Sleep (GTS) for T5 and later.
      cxgb4vf: Remove superfluous "idx" parameter of CH_DEVICE() macro.
      cxgb4/cxgb4vf: Add Devicde ID for two more adapter
      cxgb4: Add support for adaptive rx

Harish Patil (2):
      qlge: Fix compilation warning
      Update qlge driver maintainers list

Hauke Mehrtens (9):
      bcma: only map wrapper if its address is available
      bcma: store more alternative addresses
      bcma: add support for chipcommon B core
      b43: tell the ucode the mac capabilities
      b43: tell ucode the phy type and version
      b43: add missing rate
      b43: update some transmit header constants
      b43: add support for setting the beacon listen interval
      bcma: register bcma as device tree driver

Herbert Xu (2):
      ipsec: Remove obsolete MAX_AH_AUTH_LEN
      bridge: Save frag_max_size between PRE_ROUTING and POST_ROUTING

Herton R. Krzesinski (3):
      net/rds: call rds_conn_drop instead of open code it at rds_connect_complete
      net/rds: do proper house keeping if connection fails in rds_tcp_conn_connect
      net/rds: fix possible double free on sock tear down

Himangi Saraogi (17):
      ath6kl: convert a driver to use module_usb_driver()
      Bluetooth: Remove typedef bluecard_info_t
      Bluetooth: Remove typedef btuart_info_t
      Bluetooth: Remove typedefs nsh_t and dtl1_info_t
      Bluetooth: Remove typedef bt3c_info_t
      can: mcp251x: Use dmam_alloc_coherent
      isdn/gigaset: use USB API functions rather than constants
      isdn/bas_gigaset: use USB API functions rather than constants
      dn_dev: Use time_before
      ipconfig: Use time_before
      decnet: Use time_after_eq
      af_decnet: Use time_after_eq
      net: wireless: wl1251: Remove unnecessary free_irq
      cw1200: Introduce the use of devm_kzalloc
      wireless: wlcore: Use devm_kzalloc
      atmel_cs: Remove typedef local_info_t
      orinoco_usb: use USB API functions rather than constants

Ian Morris (3):
      ipv6: White-space cleansing : Line Layouts
      ipv6: White-space cleansing : Structure layouts
      ipv6: White-space cleansing : gaps between function and symbol export

Ido Shamay (3):
      net/mlx4_core: Enable CQE/EQE stride support
      net/mlx4_core: Cache line EQE size support
      net/mlx4_en: Add mlx4_en_get_cqe helper

Ido Yariv (3):
      mac80211: Fix accounting of the tailroom-needed counter
      mac80211: don't resize skbs needlessly
      iwlwifi: mvm: support cloned tx skbs

Ignacy Gawƒôdzki (1):
      ematch: Fix early ending of inverted containers.

Ivan Vecera (1):
      bna: allow transmit tagged frames

Jack Morgenstein (3):
      net/mlx4_core: Don't disable SRIOV if there are active VFs
      net/mlx4_core: Protect QUERY_PORT wrapper from untrusted guests
      net/mlx4_core: Deprecate error message at ConnectX-2 cards startup to debug

Jacob Keller (10):
      ixgbe: add comment noting recalculation of queues
      ixgbe: limit combined total of macvlan and SR-IOV VFs
      ixgbe: use e_dev_warn instead of netif_printk
      ixgbe: return integer from ixgbe_acquire_msix_vectors
      ixgbe: move msix_entries allocation into ixgbe_acquire_msix_vectors
      ixgbe: determine vector count inside ixgbe_acquire_msix_vectors
      ixgbe: use e_dev_warn instead of e_err for displaying warning
      ixgbe: use e_dev_warn instead of netif_printk
      ixgbe: add warnings for other disabled features without MSI-X support
      ixgbe: remove IXGBE_FLAG_MSI(X)_CAPABLE flags

Jade Bilkey (1):
      ath5k: added debugfs file for dumping eeprom

Janusz Dziedzic (1):
      ath10k: extend debug code for RX path

Jason Wang (1):
      net: keep original skb which only needs header checking during software GSO

Jeff Kirsher (1):
      am2150: Update nmclan_cs.c to use update PCMCIA API

Jesper Dangaard Brouer (6):
      pktgen: add flag NO_TIMESTAMP to disable timestamping
      qdisc: adjustments for API allowing skb list xmits
      qdisc: exit case fixes for skb list handling in qdisc layer
      qdisc: validate frames going through the direct_xmit path
      qdisc: bulk dequeue support for qdiscs with TCQ_F_ONETXQUEUE
      qdisc: dequeue bulking also pickup GSO/TSO packets

Jesse Brandeburg (2):
      i40e: make warning less verbose
      i40e: fix panic due to too-early Tx queue enable

Jesse Gross (5):
      openvswitch: Eliminate memset() from flow_extract.
      openvswitch: Add support for matching on OAM packets.
      openvswitch: Wrap struct ovs_key_ipv4_tunnel in a new structure.
      openvswitch: Factor out allocation and verification of actions.
      openvswitch: Add support for Geneve tunneling.

Jingoo Han (1):
      ethernet: arc: remove unused dev

Jiri Pirko (8):
      bonding: create netlink event when bonding option is changed
      team: set IFF_TEAM_PORT priv_flag after rx_handler is registered
      bonding: add slave netlink policy and put slave-related ops together
      bridge: switch order of rx_handler reg and upper dev link
      bridge: implement rtnl_link_ops->get_slave_size and rtnl_link_ops->fill_slave_info
      bridge: implement rtnl_link_ops->slave_changelink
      bridge: implement rtnl_link_ops->get_size and rtnl_link_ops->fill_info
      bridge: implement rtnl_link_ops->changelink

Jitendra Kalsaria (2):
      qlcnic: Update Link speed and port type info for 83xx adapter
      qlcnic: Use usleep_range() instead of msleep() for sleep less than 20ms

Joe Lawrence (1):
      team: avoid race condition in scheduling delayed work

Joe Perches (8):
      drivers/net: Convert remaining uses of pr_warning to pr_warn
      atm: Convert pr_warning to pr_warn
      pktgen: Convert pr_warning to pr_warn
      iucv: Convert pr_warning to pr_warn
      netfilter: Convert pr_warning to pr_warn
      Bluetooth: Convert bt_<level> logging functions to return void
      mellanox: Change en_print to return void
      net: Change netdev_<level> logging functions to return void

Johan Hedberg (82):
      Bluetooth: Add convenience function to check for pending power off
      Bluetooth: Create unified helper function for updating page scan
      Bluetooth: Disable page scan if all whitelisted devices are connected
      Bluetooth: Remove redundant check for remote_key_dist
      Bluetooth: Fix confusion between parent and child channel for 6lowpan
      Bluetooth: Fix reference counting of global L2CAP channels
      Bluetooth: Fix __l2cap_no_conn_pending() usage with all channels
      Bluetooth: Resume BT_CONNECTED state after LE security elevation
      Bluetooth: Remove special handling of ATT in l2cap_security_cfm()
      Bluetooth: Refactor l2cap_connect_cfm
      Bluetooth: Move L2CAP fixed channel creation into l2cap_conn_cfm
      Bluetooth: Improve fixed channel lookup based on link type
      Bluetooth: Remove special ATT data channel handling
      Bluetooth: Move parts of fixed channel initialization to l2cap_add_scid
      Bluetooth: Call L2CAP teardown callback before clearing chan->conn
      Bluetooth: Call l2cap_le_conn_ready after notifying channels
      Bluetooth: Fix using HCI_CONN_LE_SMP_PEND to check for SMP context
      Bluetooth: Fix hci_update_random_address() error return for no crypto
      Bluetooth: Fix IRK lookup when tfm_aes is not available
      Bluetooth: Refactor SMP (de)initialization into separate functions
      Bluetooth: Move SMP initialization after HCI init
      Bluetooth: Move SMP (de)initialization to smp.c
      Bluetooth: Add more L2CAP convenience callbacks
      Bluetooth: Add SMP L2CAP channel skeleton
      Bluetooth: Make AES crypto context private to SMP
      Bluetooth: Convert SMP to use l2cap_chan infrastructure
      Bluetooth: Use L2CAP resume callback to call smp_distribute_keys
      Bluetooth: Add public l2cap_conn_shutdown() API to request disconnection
      Bluetooth: Call l2cap_conn_shutdown() when SMP recv callback fails
      Bluetooth: Fix double free of SMP data skb
      Bluetooth: Add SMP-internal timeout callback
      Bluetooth: Remove unused l2cap_conn->security_timer
      Bluetooth: Move canceling security_timer into smp_chan_destroy()
      Bluetooth: Always call smp_distribute_keys() from a workqueue
      Bluetooth: Make smp_chan_destroy() private to smp.c
      Bluetooth: Fix incorrect LE CoC PDU length restriction based on HCI MTU
      Bluetooth: Remove unnecessary l2cap_chan_unlock before l2cap_chan_add
      Bluetooth: Fix hci_conn reference counting for fixed channels
      Bluetooth: Set addr_type only when it's needed
      Bluetooth: Optimize connection parameter lookup for LE connections
      Bluetooth: Improve *_get() functions to return the object type
      Bluetooth: Fix using hci_conn_get() for hci_conn pointers
      Bluetooth: Refactor connection parameter freeing into its own function
      Bluetooth: Use zero timeout for immediate scheduling
      Bluetooth: Fix hci_conn reference counting with hci_chan
      Bluetooth: Set disc_timeout to 0 when calling hci_chan_del
      Bluetooth: Ignore incoming data after initiating disconnection
      Bluetooth: Remove hci_conn_hold/drop from hci_chan
      Bluetooth: Set discon_timeout to 0 in l2cap_conn_del
      Bluetooth: Use hci_disconnect for immediate disconnection from SMP
      Bluetooth: Remove unused l2cap_conn_shutdown API
      Bluetooth: Fix SMP error and response to be mutually exclusive
      Bluetooth: Update hci_disconnect() to return an error value
      Bluetooth: Use hci_disconnect() for mgmt_disconnect_device()
      Bluetooth: Move clock offset reading into hci_disconnect()
      Bluetooth: Add clarifying comment for LE CoC result value
      Bluetooth: Remove unnecessary checks after canceling SMP security timer
      Bluetooth: Don't take any action in smp_resume_cb if not encrypted
      Bluetooth: Move identity address update behind a workqueue
      Bluetooth: Remove unnecessary deferred work for SMP key distribution
      Bluetooth: Fix locking of the SMP context
      Bluetooth: Add define for key distribution mask
      Bluetooth: Fix calling smp_distribute_keys() when still waiting for keys
      Bluetooth: Add strict checks for allowed SMP PDUs
      Bluetooth: Fix dereferencing conn variable before NULL check
      Bluetooth: Fix mgmt pairing failure when authentication fails
      Bluetooth: Fix allowing SMP Signing info PDU
      Bluetooth: Remove unnecessary early initialization of variable
      Bluetooth: Fix ignoring unknown SMP authentication requirement bits
      Bluetooth: Centralize disallowing SMP commands to a single place
      Bluetooth: Fix SMP security level when we have no IO capabilities
      Bluetooth: Add smp_ltk_sec_level() helper function
      Bluetooth: Fix L2CAP information request handling for fixed channels
      Bluetooth: Avoid hard-coded IO capability values in SMP
      Bluetooth: Expire RPA if encryption fails
      Bluetooth: Fix re-setting RPA as expired when deferring update
      Bluetooth: btusb: Use GFP_KERNEL in btusb_send_frame()
      Bluetooth: Fix setting correct security level when initiating SMP
      Bluetooth: Fix reason code used for rejecting SCO connections
      Bluetooth: Add retransmission effort into SCO parameter table
      Bluetooth: Rename sco_param_wideband table to esco_param_msbc
      Bluetooth: Fix lockdep warning with l2cap_chan_connect

Johannes Berg (34):
      mac80211: don't duplicate station QoS capability data
      mac80211: make ieee80211_vif_use_reserved_switch static
      cfg80211: clarify BSS probe response vs. beacon data
      cfg80211: allow passing frame type to cfg80211_inform_bss()
      iwlwifi: make U-APSD default configurable at compile time
      iwlwifi: trans: refactor txq_enable arguments
      iwlwifi: mvm: add some debugging to quota allocation
      iwlwifi: don't export tracepoints unnecessarily
      iwlwifi: trans: allow skipping scheduler hardware config
      iwlwifi: trans: make aggregation explicit for TX queue handling
      iwlwifi: add Intel Mobile Communications copyright
      iwlwifi: mvm: correct firmware disassoc command sequence
      iwlwifi: mvm: clean up FIFO definitions
      iwlwifi: mvm: clarify stop_count, remove transport_stopped
      iwlwifi: mvm: use tdls indication from mac80211
      iwlwifi: mvm: use iwl_mvm_mac_get_queues_mask() more
      iwlwifi: mvm: clean up broadcast station handling
      iwlwifi: mvm: clean up AUX station handling
      mac80211: clean up ieee80211_i.h
      mac80211: add Intel Mobile Communications copyright
      cfg80211: add Intel Mobile Communications copyright
      mac80211: annotate MMIC head/tailroom warning
      cfg80211: clear connect keys when freeing them
      mac80211: clear key material when freeing keys
      cfg80211: clear wext keys when freeing and removing them
      cfg80211: don't put kek/kck/replay counter on the stack
      cfg80211: clear nl80211 messages carrying keys after processing
      cfg80211: add WMM traffic stream API
      iwlwifi: mvm: disable aggregation queues in station DB in FW
      iwlwifi: pcie: clear command data on freeing
      iwlwifi: mvm: don't update quota in firmware too often
      iwlwifi: mvm: update d0i3 debugfs
      iwlwifi: mvm: fix quota update avoidance
      iwlwifi: mvm: update QoS parameters when they change

John Fastabend (41):
      net: qdisc: use rcu prefix and silence sparse warnings
      net: rcu-ify tcf_proto
      net: sched: cls_basic use RCU
      net: sched: cls_cgroup use RCU
      net: sched: cls_flow use RCU
      net: sched: fw use RCU
      net: sched: RCU cls_route
      net: sched: RCU cls_tcindex
      net: sched: make cls_u32 per cpu
      net: sched: make cls_u32 lockless
      net: sched: rcu'ify cls_rsvp
      net: sched: rcu'ify cls_bpf
      net: qdisc: use rcu prefix and silence sparse warnings
      net: rcu-ify tcf_proto
      net: sched: cls_basic use RCU
      net: sched: cls_cgroup use RCU
      net: sched: cls_flow use RCU
      net: sched: fw use RCU
      net: sched: RCU cls_route
      net: sched: RCU cls_tcindex
      net: sched: make cls_u32 per cpu
      net: sched: make cls_u32 lockless
      net: sched: rcu'ify cls_rsvp
      net: sched: rcu'ify cls_bpf
      net: sched: fix unsued cpu variable
      net: sched: cls_u32 add missing rcu_assign_pointer and annotation
      net: sched: cls_cgroup fix possible memory leak of 'new'
      net: sched: cls_fw: add missing tcf_exts_init call in fw_change()
      net: sched: cls_cgroup need tcf_exts_init in all cases
      net: sched: cls_u32: rcu can not be last node
      net: cls_u32: fix missed pcpu_success free_percpu
      net: sched: cls_u32 changes to knode must appear atomic to readers
      net: sched: cls_rcvp, complete rcu conversion
      net: sched: make bstats per cpu and estimator RCU safe
      net: sched: implement qstat helper routines
      net: sched: restrict use of qstats qlen
      net: sched: enable per cpu qstats
      net: sched: suspicious RCU usage in qdisc_watchdog
      net: sched: remove tcf_proto from ematch calls
      net: sched: cls_cgroup tear down exts and ematch from rcu callback
      net: sched: do not use tcf_proto 'tp' argument from call_rcu

John W. Linville (13):
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge tag 'mac80211-next-for-john-2014-08-29' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'mac80211-next-for-john-2014-09-12' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge tag 'nfc-next-3.18-1' of git://git.kernel.org/.../sameo/nfc-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next

Jon Maloy (1):
      tipc: fix bug in multicast congestion handling

Jon Paul Maloy (15):
      tipc: introduce new function tipc_msg_create()
      tipc: use pseudo message to wake up sockets after link congestion
      tipc: use message to abort connections when losing contact to node
      tipc: clean up socket timer function
      tipc: eliminate function tipc_port_shutdown()
      tipc: eliminate port_connect()/port_disconnect() functions
      tipc: redefine message acknowledge function
      tipc: eliminate functions tipc_port_init and tipc_port_destroy
      tipc: use registry when scanning sockets
      tipc: replace port pointer with socket pointer in registry
      tipc: remove port_lock
      tipc: remove source file port.c
      tipc: remove include file port.h
      tipc: remove files ref.h and ref.c
      tipc: merge struct tipc_port into struct tipc_sock

Jozsef Kadlecsik (4):
      netfilter: ipset: Fix warn: integer overflows 'sizeof(*map) + size * set->dsize'
      netfilter: ipset: Fix static checker warning in ip_set_core.c
      netfilter: ipset: send nonzero skbinfo extensions only
      netfilter: ipset: hash:mac type added to ipset

Jukka Rissanen (11):
      Bluetooth: 6lowpan: Increase the connection timeout value
      Bluetooth: 6lowpan: Set the peer IPv6 address correctly
      Bluetooth: 6lowpan: Route packets that are not meant to peer via correct device
      MAINTAINERS: add maintainer for generic 6LoWPAN
      Bluetooth: 6lowpan: Make sure skb exists before accessing it
      Bluetooth: 6lowpan: Ensure header compression does not corrupt IPv6 header
      Bluetooth: 6lowpan: Enable multicast support
      Bluetooth: 6lowpan: Memory leak as the skb is not freed
      Bluetooth: 6lowpan: Avoid memory leak if memory allocation fails
      Bluetooth: 6lowpan: Return EAGAIN error also for multicast packets
      Bluetooth: 6lowpan: Check transmit errors for multicast packets

Julian Anastasov (5):
      ipvs: reduce stack usage for sockopt data
      ipvs: address family of LBLC entry depends on svc family
      ipvs: address family of LBLCR entry depends on svc family
      ipvs: use correct address family in scheduler logs
      ipvs: use the new dest addr family field

KY Srinivasan (1):
      hyperv: Fix a bug in netvsc_send()

Kalesh AP (16):
      be2net: Add TX completion error statistics in ethtool
      be2net: fix log messages in lancer FW download path
      be2net: remove unncessary gotos
      be2net: define BE_MAX_MTU
      be2net: send a max of 8 EQs to be_cmd_modify_eqd() on Lancer
      be2net: enable PCIe error reporting on VFs too
      be2net: fix a sparse warning in be_cmd_modify_eqd()
      be2net: add speed reporting for 40G/KR interface
      be2net: remove return statements for void functions
      be2net: add blank line after declarations
      be2net: remove multiple blank lines
      be2net: insert a blank line after function/struct//enum definitions
      be2net: remove unnecessary blank lines after an open brace
      be2net: remove space after typecasts
      be2net: remove multiple assignments on a single line
      be2net: fix alignment on line wrap

Kalle Valo (15):
      ath10k: add ath10k_pci_diag_* helpers
      ath10k: rename ath10k_pci_hif_dump_area() to ath10k_pci_fw_crashed_dump()
      ath10k: print more driver info when firmware crashes
      ath10k: make ath10k_wmi_cmd_send() public
      ath10k: add testmode
      ath10k: fix parenthesis alignment warning in ath10k_htt_rx_alloc()
      ath10k: fix checkpatch warnings about parenthesis alignment
      ath10k: fix use of multiple blank lines
      ath10k: fix missing a blank line after declarations
      ath10k: fix space after a cast style errors
      ath10k: don't use return on void functions
      ath10k: else is not generally useful after a break or return
      ath10k: miscellaneous checkpatch fixes
      ath10k: reformat help text in ath10k_read_simulate_fw_crash()
      ath10k: use ether_addr_copy()

Kenny Mathis (1):
      ipvs: Add simple weighted failover scheduler

Krzysztof Majzerowicz-Jaszcz (1):
      e1000: e1000_ethertool.c coding style fixes

LEROY Christophe (4):
      net: optimise csum_replace4()
      net: optimise inet_proto_csum_replace4()
      net: fs_enet: Remove non NAPI RX
      net: fs_enet: Add NAPI TX

Lad, Prabhakar (1):
      can: dev: remove unused variable from can_calc_bittiming() function

Larry Finger (31):
      rtlwifi: btcoexist: Modify btcoexist for changes in the V062814 Realtek version
      rtlwifi: btcoexist: Modify rtl_btc for changes in latest Realtek code
      rtlwifi: btcoexist: Modify driver for V062814 Realtek driver
      rtlwifi: btcoexist: Modify driver to support BT coexistence in rtl8723be
      rtlwifi: btcoexist: Add BT coexistence routines for driver rtl8821ae
      rtlwifi: btcoexist: Add second part of BT coexistence routines for rtl8821ae
      rtlwifi: btcoexist: Update remaining old parts of the driver
      rtlwifi: btcoexist: Fix "always true" warning from commit ed364abffd6e
      rtlwifi: btcoexist: avoid format string in printk
      rtlwifi: btcoexist: Change local debugging macros CL_*** into the standard varieties
      rtlwifi: btcoexist: Fix Smatch warning
      rtlwifi: Remove extra workqueue for enter/leave power state
      rtlwifi: rtl_pci: Start modification for new drivers
      rtlwifi: Modify core.c for new drivers
      rtlwifi: Modify base.{c,h} for new drivers
      rtlwifi: Modify cam.{c,h} and efuse.{c,h} for new drivers
      rtlwifi: Update power-save routines for 062814 driver
      rtlwifi: Finish modifying core routines for new drivers
      rtlwifi: rtl8188ee: Update driver to match Realtek release of 06282014
      rtlwifi: rtl8821ae: Move driver from staging to regular tree
      rtlwifi: Fix problems with building an allyesconfig
      rtlwifi: rtl8188ee: rtl8821ae: Fix a queue locking problem
      rtlwifi: rtl8192ee: Move driver from staging to the regular tree
      rtlwifi: rtl8723ae: Update driver to match 06/28/14 Realtek version
      rtlwifi: rtl8723be: Update driver to match Realtek release of 06/28/14
      rtlwifi: rtl8192ce: rtl8192common: Update for latest version of Realtek drivers
      rtlwifi: rtl8188ee: rtl8192com: rtl8192cu: rtl8192ee: rtl8723ae: rtl87323be: rtl8821ae: Use common cmd_send_packet
      rtlwifi: rtl8188ee: rtl8723ae: rtl8821ae: Initialize some variables
      rtlwifi: Fix randconfig build error with next-20140930
      rtlwifi: Fix Kconfig for RTL8192EE
      rtlwifi: Fix static checker warnings for various drivers

Lendacky, Thomas (4):
      amd-xgbe-phy: Check device for current speed mode (KR/KX)
      amd-xgbe-phy: Enhance parallel detection to support KR speed
      amd-xgbe: Checkpatch driver fixes
      amd-xgbe-phy: Checkpatch driver fixes

Ley Foon Tan (2):
      net: stmmac: add fix_mac_speed support for socfpga
      net: stmmac: fix warning from Sparse for socfpga

Li RongQing (3):
      openvswitch: change the data type of error status to atomic_long_t
      tcp: remove unnecessary assignment.
      tcp: Change tcp_slow_start function to return void

Liad Kaufman (6):
      iwlwifi: mvm: wait for TE notif when protecting TDLS session
      mac80211: fix description comment of ieee80211_subif_start_xmit
      mac80211: add TDLS connection timeout
      iwlwifi: make hw rev checking more readable
      iwlwifi: pcie: fix HW_REV saving for 8000 series
      iwlwifi: 8000: fix fw name to account for revision

Loic Poulain (1):
      Bluetooth: Fix HCI H5 corrupted ack value

Lorenzo Bianconi (14):
      cfg80211: enable dynack through nl80211
      mac80211: extend set_coverage_class signature
      ath9k: fix radar parameters initialization
      ath9k: export methods related to ACK timeout estimation
      ath9k: add duration field to ath_tx_status
      ath9k: add dynamic ACK timeout estimation
      ath9k: add config for (en|dis)abling ACK timeout estimation
      ath9k: do not overwrite ACK timeout estimation
      ath9k: add sampling methods for (tx|rx) timestamp
      ath9k: enable control frame reception
      ath9k: add debugfs support for dynack
      ath9k: enable dynack using set_coverage_class codepath
      ath9k: initialize ath_node linked list
      ath9k: enable ext channel pulse detection

Luciano Coelho (13):
      iwlwifi: mvm: reset the temperature when temperature test is disabled
      iwlwifi: mvm: don't run automatic checks if CT was caused by debugfs
      iwlwifi: mvm: add debugfs entry for ps_disabled
      iwlwifi: mvm: re-enable ps when monitor interfaces are removed
      iwlwifi: mvm: refactor iwl_mvm_power_set_pm() to spin the ps part off
      iwlwifi: mvm: add function to update only ps
      iwlwifi: mvm: add option that allows a vif to disable PS
      iwlwifi: mvm: set the TX disable bit when doing a chanctx switch
      iwlwifi: mvm: reset ucode_loaded flag when mac80211 stop is called
      iwlwifi: mvm: fail temp test enabling if the ucode is not loaded
      iwlwifi: mvm: use the firmware to get the temperature during CT kill
      iwlwifi: mvm: align CSA GO NOA time event naming with the firmware
      iwlwifi: mvm: add debugfs entry to read the current temperature

Lukasz Rymanowski (2):
      Bluetooth: Improve data packing in SAR mode
      Bluetooth: Fix ERTM L2CAP resend packet

Maciej W. Rozycki (3):
      defxx: Correct DEFEA's ESIC port I/O accesses
      defxx: DEFEA's Burst Holdoff register initialization fix
      defxx: DEFEA's ESIC port I/O decoding cleanup

Mahesh Bandewar (2):
      bonding: display xmit_hash_policy for non-dynamic-tlb mode
      bonding: Simplify the xmit function for modes that use xmit_hash

Maithili Hinge (1):
      mwifiex: add client mac address while configuring keys on GO.

Majd Dibbiny (1):
      net/mlx4_core: New init and exit flow for mlx4_core

Marcel Holtmann (7):
      Bluetooth: btusb: Separate TX URB allocation and submission
      Bluetooth: Add BUILD_BUG_ON check for SKB control buffer size
      Bluetooth: Provide HCI command opcode information to driver
      Bluetooth: btusb: Fix old coding style issues
      Bluetooth: btusb: Split fragement receiption into separate functions
      Bluetooth: btusb: Implement driver internal packet reassembly
      Bluetooth: Remove exported hci_recv_fragment function

Mark A. Greer (44):
      NFC: digital: Add Inititor-side PSL support
      NFC: trf7970a: Add VIN voltage override support
      NFC: trf7970a: Document the 'vin-voltage-override' DTS property
      NFC: trf7970a: Move IRQ Status Read quirk to device tree
      NFC: trf7970a: Document the 'irq-status-read-quirk' DT property
      NFC: trf7970a: Add quirk to keep EN2 low
      NFC: trf7970a: Document the 'en2-rf-quirk' DT property
      NFC: trf7970a: Make gpio labels more readable
      NFC: trf7970a: Remove incorrect of_node_put() call
      NFC: trf7970a: Remove trf7970a_tg_listen_mdaa()
      NFC: trf7970a: Call spi_setup() to configure SPI communication
      NFC: trf7970a: Use spi_sync() instead of spi_write_then_read()
      NFC: trf7970a: Ignore Overflow bit in FIFO Status Register
      NFC: trf7970a: FIFO Size is really 127 bytes
      NFC: trf7970a: Remove unnecessary sleep
      NFC: trf7970a: Disable SYS_CLK Output
      NFC: trf7970a: Initialize when enabling RF
      NFC: trf7970a: Add RF technology specific guard times
      NFC: trf7970a: Recalculate driver timeout values
      NFC: trf7970a: Clear possible spurious interrupt before transmitting
      NFC: trf7970a: Remove unnecessary FIFO reset & RSSI read
      NFC: trf7970a: Prefix TX data when refilling FIFO
      NFC: trf7970a: Only fill FIFO if there is space
      NFC: trf7970a: Handle low-watermark IRQ when transmitting
      NFC: trf7970a: Reread FIFO Status Register when draining FIFO
      NFC: trf7970a: Ensure no more RX data before completing receive
      NFC: trf7970a: Return error code when turning on RF fails
      NFC: trf7970a: Rename TRF7970A_ST_OFF to TRF7970A_ST_RF_OFF
      NFC: trf7970a: Don't assume CONFIG_PM_RUNTIME is enabled
      NFC: trf7970a: Create startup and shutdown routines
      NFC: trf7970a: Add System Suspend/Resume support
      NFC: trf7970a: Delay after initialization
      NFC: trf7970a: Add '_in_' to initiator routines
      NFC: trf7970a: Don't turn off RF if its already off
      NFC: trf7970a: trf7970a_init() turns off the RF transmitter
      NFC: trf7970a: Don't turn on RF if there is already an RF field
      NFC: trf7970a: Cancel timer when error encountered
      NFC: trf7970a: Handle timeout values of zero
      NFC: trf7970a: Add Target Mode Support
      NFC: trf7970a: Add Target Mode Detection Support
      NFC: trf7970a: Remove useless local variable
      NFC: trf7970a: Remove unnecessary local variable initialization
      NFC: trf7970a: Unlock mutex before exiting trf7970a_irq()
      NFC: trf7970a: Unlock mutex before exiting _trf7970a_tg_listen()

Mark Einon (1):
      et131x: Add PCIe gigabit ethernet driver et131x to drivers/net

Mark Leonard (1):
      be2net: add ethtool "-m" option support

Mark Rustad (4):
      netfilter: ipset: Resolve missing-field-initializer warnings
      ixgbe: Resolve warnings produced in W=2 builds
      ixgbevf: Resolve missing-field-initializers warnings
      ixgbe: Do not schedule an uninitialized workqueue entry

Markus Pargmann (7):
      DT doc: net: cpsw mac-address is optional
      net: cpsw: Add missing return value
      net: cpsw: header, Add missing include
      net: cpsw: Replace pr_err by dev_err
      net: cpsw: Add am33xx MACID readout
      am33xx: define syscon control module device node
      arm: dts: am33xx, Add syscon phandle to cpsw node

Masanari Iida (1):
      net: description of dma_cookie cause make xmldocs warning

Matteo Croce (1):
      ath10k: ATH10K_DEBUGFS depends on DEBUG_FS

Matti Gottlieb (2):
      iwlwifi: mvm: Add set NIC temperature debug option
      iwlwifi: mvm: Add marker command 0xcb

Max Stepanov (1):
      iwlwifi: mvm: add MVM_FW_MCAST_FILTER_PASS_ALL option

Michael Braun (1):
      macvlan: add source mode

Michael Grzeschik (5):
      ARCNET: return IRQ_NONE if the interface isn't running
      ARCNET: add com20020_set_hwddr to change address
      ARCNET: add com20020 PCI IDs with metadata
      ARCNET: add support for multi interfaces on com20020
      ARCNET: enable eae arcnet card support

Michal Kalderon (2):
      bnx2x: Add timestamping and PTP hardware clock support
      bnx2x: Fix timesync endianity

Michal Kazior (42):
      ath10k: add support for 10.2 firmware
      ath10k: fix aggregated 4addr Rx
      ath10k: improve channel switching
      ath10k: fix wmi service bitmap debug
      ath10k: simplify scan debug prints
      ath10k: introduce a stricter scan state machine
      ath10k: embed ar_pci inside ar
      ath10k: remove target soc ps code
      ath10k: remove pci features var
      ath10k: group some pci probing helpers
      ath10k: remove htc->stopped
      ath10k: fix a conflict bug in wmi service bitmap
      ath10k: move fw init print
      ath10k: fix legacy irq workaround
      ath10k: setup irq method in probe
      ath10k: split ce irq/handler setup
      ath10k: make sure to really disable irqs
      ath10k: remove early irq handling
      ath10k: rework posting pci rx buffers
      ath10k: update comment regarding warm reset
      ath10k: ignore ar_pci->started in pipe cleanup
      ath10k: remove ar_pci->started
      ath10k: flush hif buffers before recovery
      cfg80211: re-enable CSA for drivers that support it
      ath10k: improve logging to include dev id
      ath10k: fix fw crash dumping
      ath10k: move pci init structures
      ath10k: dont duplicate service-pipe mapping
      ath10k: make target endianess more explicit
      mac80211: fix chantype recalc warning
      ath10k: re-enable interrupts properly in hw recovery
      ath10k: fix num_legacy_stations tracking
      ath10k: kill tasklets after free_irq
      ath10k: fix monitor start/stop sequences
      ath10k: stop monitor vdev for sta assoc
      ath10k: remove diag_*_access functions
      ath10k: add device/driver strings to tracepoints
      ath10k: don't access tx_info while overwriting it
      mac80211: fix offloaded BA session traffic after hw restart
      ath10k: move fw_crash_dump allocation
      ath10k: use proper service bitmap size
      ath10k: fix debugfs_create_dir() checking

Michel Stam (1):
      asix: Don't reset PHY on if_up for ASIX 88772

Mika Westerberg (1):
      net: rfkill: gpio: Add more Broadcom bluetooth ACPI IDs

Mike Frysinger (1):
      uapi: netfilter_arp: use __u8 instead of u_int8_t

Mugunthan V N (1):
      drivers: net: cpsw: Add support for pause frames

Neal Cardwell (1):
      tcp: remove obsolete comment about TCP_SKB_CB(skb)->when in tcp_fragment()

Nicolas Dichtel (6):
      rtnl/do_setlink(): set modified when IFLA_TXQLEN is updated
      rtnl/do_setlink(): set modified when IFLA_LINKMODE is updated
      rtnl/do_setlink(): last arg is now a set of flags
      rtnl/do_setlink(): notify when a netdev is modified
      netfilter: ebtables: create audit records for replaces
      ip6_gre: fix flowi6_proto value in xmit path

Nikolay Aleksandrov (18):
      bonding: add slave_changelink support and use it for queue_id
      cxgb4: remove bond->lock
      bonding: 3ad: use curr_slave_lock instead of bond->lock
      bonding: alb: clean bond->lock
      bonding: convert primary_slave to use RCU
      bonding: procfs: clean bond->lock usage and use RCU
      bonding: options: remove bond->lock usage
      bonding: remove last users of bond->lock and bond->lock itself
      bonding: 3ad: clean up curr_slave_lock usage
      bonding: alb: remove curr_slave_lock
      bonding: clean curr_slave_lock use
      bonding: convert curr_slave_lock to a spinlock and rename it
      bonding: alb: convert to bond->mode_lock
      bonding: 3ad: convert to bond->mode_lock
      bonding: adjust locking comments
      bonding: consolidate the two rlb_next_rx_slave functions into one
      bonding: trivial: style and comment fixes
      bonding: consolidate ASSERT_RTNL()s and remove the unnecessary

Nimrod Andy (6):
      net: fec: fix code identation
      net: fec: Add Ftype to BD to distiguish three tx queues for AVB
      net: fec: remove the ERR006358 workaround for imx6sx enet
      net: fec: align rx data buffer size for dma map/unmap
      net: fec: free resource after phy probe failed
      net: fec: implement rx_copybreak to improve rx performance

Oren Givon (2):
      iwlwifi: add and edit 8000 series PCI IDs
      iwlwifi: Add missing PCI IDs for the 7260 series

Pablo Neira Ayuso (20):
      netfilter: nat: move specific NAT IPv4 to core
      netfilter: nft_chain_nat_ipv4: use generic IPv4 NAT code from core
      netfilter: nat: move specific NAT IPv6 to core
      netfilter: nft_chain_nat_ipv6: use generic IPv6 NAT code from core
      netfilter: fix compilation of masquerading without IP_NF_TARGET_MASQUERADE
      netfilter: nf_tables: add NFTA_MASQ_UNSPEC to nft_masq_attributes
      netfilter: NFT_CHAIN_NAT_IPV* is independent of NFT_NAT
      netfilter: masquerading needs to be independent of x_tables in Kconfig
      Merge branch 'ipvs-next'
      netfilter: nfnetlink: use original skbuff when committing/aborting
      netfilter: nf_tables: export rule-set generation ID
      netfilter: bridge: nf_bridge_copy_header as static inline in header
      netfilter: bridge: move br_netfilter out of the core
      netfilter: nft_reject: introduce icmp code abstraction for inet and bridge
      netfilter: move nf_send_resetX() code to nf_reject_ipvX modules
      netfilter: use IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
      netfilter: nf_tables: wait for call_rcu completion on module removal
      netfilter: nft_compat: remove incomplete 32/64 bits arch compat code
      netfilter: nf_tables: allow to filter from prerouting and postrouting
      netfilter: explicit module dependency between br_netfilter and physdev

Paul Bolle (1):
      ath5k: Remove AHB bus support

Pavel Machek (1):
      stmmac: simple cleanups

Peter Pan(ÊΩòÂç´Âπ≥) (1):
      tcp: use tcp_flags in tcp_data_queue()

Petri Gynther (5):
      net: bcmgenet: fix bcmgenet_put_tx_csum()
      net: phy: add BCM7425 and BCM7429 PHYs
      net: bcmgenet: improve bcmgenet_mii_setup()
      net: phy: adjust fixed_phy_register() return value
      net: bcmgenet: fix Tx ring priority programming

Pravin B Shelar (3):
      openvswitch: Remove pkt_key from OVS_CB
      openvswitch: refactor ovs flow extract API.
      openvswitch: Use tun_key only for egress tunnel path.

Rafa≈Ç Mi≈Çecki (23):
      b43: update flushing many writes performed in a row
      b43: don't duplicate common PHY read/write ops
      b43: flush some writes on Broadcom MIPS SoCs
      b43: N-PHY: update rev3+ gain control workarounds
      b43: N-PHY: add RF power tables for radio 0x2057 revs 9 & 14
      b43: implement PPR (Power Per Rate) management/API
      b43: N-PHY: support setting custom TX power
      bcma: get info about flash type SoC booted from
      bcma: move bus struct setup into early part of host specific code
      bcma: use separated function to initialize bus on SoC
      bcma: move code for core registration into separate function
      bcma: register NAND and QSPI cores early
      b43: HT-PHY: Move radio preparation into init function
      b43: HT-PHY: Move radio calibration to separated functions
      b43: HT-PHY: Define some regs for 0x2059 radio
      b43: HT-PHY: Complete radio init (add missing entries)
      b43: HT-PHY: Set MAC frequency to correct values
      b43: HT-PHY: Implement band switching
      b43: HT-PHY: Update values for frequency calibration
      b43: Implement PHY PLL reset
      bcma: print chip ID in a more user-friendly form
      bcma: gpio: use ChipCommon GPIO IRQ on BCM47XX arch only
      bcma: use chipcommon node from DT for SoC GPIO chip

Rami Rosen (1):
      bridge: Cleanup of unncessary check.

Randy Dunlap (1):
      net: bnx2x: fix build error with ptp

Rasmus Villemoes (5):
      ray_cs: Add include guards
      include/linux/cycx_x25.h: Remove unused header
      include/linux/i82593.h: Remove unused header
      include/linux/phonedev.h: Remove unused header
      include/rxrpc/types.h: Remove unused header

Ravikumar Nelavelli (1):
      be2net: fix port-type reporting in get_settings

Rick Jones (7):
      be2net: Use dev_consume_skb_any() in the non-drop path
      mlx4_en: Convert the normal skb free path to dev_consume_skb_any()
      hp100: Convert the normal skb free path to dev_consume_skb_any()
      sfc: Convert the normal transmit complete path to dev_consume_skb_any()
      arp: Do not perturb drop profiles with ignored ARP packets
      ixgbe: Convert the normal transmit complete path to dev_consume_skb_any()
      i40e/igb: Convert to dev_consume_skb_any()

Rickard Strandqvist (3):
      net: wireless: ipw2x00: ipw2200.c: Cleaning up missing null-terminate in conjunction with strncpy
      net: ethernet: freescale: fec_main.c: Cleaning up missing null-terminate in conjunction with strncpy
      net: ethernet: neterion: vxge: vxge-main.c: Cleaning up missing null-terminate in conjunction with strncpy

Rob Jones (1):
      net/netfilter/x_tables.c: use __seq_open_private()

Romain Perier (8):
      ethernet: arc: remove use of 'struct platform_device'
      ethernet: arc: mdio changes for future SoC glue layer devtree support
      ethernet: arc: Add support for specific SoC layer device tree bindings
      ethernet: arc: Add support for Rockchip SoC layer device tree bindings
      dt-bindings: Document EMAC Rockchip
      ARM: dts: Add emac nodes to the rk3188 device tree
      ARM: dts: Enable emac node on the rk3188-radxarock boards
      net: ethernet: arc: Don't free Rockchip resources before disconnect from phy

Rusty Russell (3):
      virtio_net: pass well-formed sgs to virtqueue_add_*()
      virtio_ring: assume sgs are always well-formed.
      virtio_ring: unify direct/indirect code paths.

Sabrina Dubroca (1):
      net: fix sparse warnings in SNMP_UPD_PO_STATS(_BH)

Sasha Levin (1):
      net: bpf: correctly handle errors in sk_attach_filter()

Sathya Perla (5):
      be2net: add a few log messages
      be2net: shorten AMAP_GET/SET_BITS() macro calls
      be2net: add a description for counter rx_input_fifo_overflow_drop
      be2net: get rid of TX budget
      be2net: define macro for_all_tx_queues_on_eq()

Scott Wood (1):
      udp: Fix inverted NAPI_GRO_CB(skb)->flush test

Serey Kong (2):
      i40e: Change wording to be more consistent
      i40e: Remove unnecessary assignment

Sergei Shtylyov (4):
      can: rcar_can: support all input clocks
      can: rcar_can: document device tree bindings
      can: rcar_can: add device tree support
      phylib: use MDIO_DEVS[12]

Sergey Popovich (1):
      netfilter: ipset: netnet,netportnet: Fix value range support for IPv4

Shahed Shaikh (4):
      qlcnic: Add support for 0x8830 device ID
      qlcnic: Add support to run firmware POST
      MAINTAINERS: Update group email alias for qlcnic driver
      qlcnic: Update version to 5.3.62

Shannon Nelson (3):
      i40e: Enable l2tsel bit for VLAN tag control
      i40e/i40evf: add max buf len to aq debug print helper
      i40e: quiet complaints when removing default MAC VLAN filter and make set_mac reversible

Simon Horman (1):
      ipvs: Clean up comment style in ip_vs.h

Simon Vincent (1):
      ieee802154: 6lowpan: ensure header compression does not corrupt ipv6 header

Simon Wunderlich (2):
      ath10k: add spectral scan feature
      ath10k: unregister spectral before mac

Sowmini Varadhan (1):
      sunvnet: Avoid sending superfluous LDC messages.

Srinivas Kandagatla (1):
      ath6kl: Add SDIO device ID for QCA6234X Support

Stanislaw Gruszka (2):
      rt2800: correct BBP1_TX_POWER_CTRL mask
      MAINTAINERS: change rt2x00 maintainer

Stefan Agner (2):
      can: flexcan: flexcan_get_berr_counter(): switch on clocks before accessing ecr register
      can: flexcan: add vf610 support for FlexCAN

Stefan Wahren (2):
      Documentation: add Device tree bindings for QCA7000
      net: qualcomm: new Ethernet over SPI driver for QCA7000

Steinar H. Gunderson (2):
      mac80211: split 802.11h parsing from transmit power policy
      mac80211: support DTPC IE (from Cisco Client eXtensions)

Stephen Rothwell (2):
      ath5k: Add missing vmalloc.h include.
      fm10k: using vmalloc requires including linux/vmalloc.h

Subbaraya Sundeep Bhatta (2):
      net: axienet: remove unnecessary ether_setup after alloc_etherdev
      net: ll_temac: Remove unnecessary ether_setup after alloc_etherdev

Sujith Manoharan (79):
      ath9k: Add a debug level for channel context
      ath9k: Handle failure to allocate HW timer
      ath9k: Move channel operations to channel.c
      ath9k: Add debug information
      ath9k: Add a config option for channel context
      ath9k: Move P2P functions to channel.c
      ath9k: Isolate P2P powersave routines
      ath9k: Isolate ath9k_use_chanctx module parameter
      ath9k: Add a routine for initializing channel contexts
      ath9k: Add a routine to tear down channel contexts
      ath9k: Make ath_chanctx_work static
      ath9k: Cleanup mgd_prepare_tx callback
      ath9k: Conditionally compile a few functions
      ath9k: Exclude more functions
      ath9k: Conditionally compile more functions
      ath9k: Make ath_chanctx_offchan_switch static
      ath9k: Make ath_chanctx_get_oper_chan static
      ath9k: Make ath_chanctx_switch static
      ath9k: Fix channel context events
      ath9k: Fix function declarations
      ath9k: Add wrappers for beacon events
      ath9k: Add ath9k_chanctx_wake_queues
      ath9k: Add ath9k_offchannel_init
      ath9k: Use ath_chanctx_check_active properly
      ath9k: Fix function argument type
      ath9k: Fix 'offchannel' in ath_softc
      ath9k: Fix channel context variables in ath_softc
      ath9k: Remove redundant ifdef
      ath9k: Move ath9k_beacon_add_noa to channel.c
      ath9k: Fix ath_chanctx_get()
      ath9k: Add new chanctx events
      ath9k: Print the event/state in ath_chanctx_event
      ath9k: Fix interface limits
      ath9k: Fix channel context creation
      ath9k: Disable fastcc for channel context mode
      ath9k: Add more debug statements for channel context
      ath9k: Fix channel context timer
      ath9k: Fix beacon configuration for channel contexts
      ath9k: Fix beacons for managed mode
      ath9k: Fix panic when adding an AP interface
      ath9k: Fix NoA start time calculation
      ath9k: Fix offchannel duration calculation
      ath9k: Add CTWindow support
      ath9k: Fix RX filter calculation
      ath9k: Fix ath_startrecv()
      ath9k: Fix COMP_BAR filter
      ath9k: Fix RX filters in channel contexts
      ath9k: Fix interface accounting
      ath9k: Use a subroutine to assign HW queues
      ath9k: Fix offchannel operation
      ath9k: Fix MCC scanning
      ath9k: Assign offchannel duration properly
      ath9k: Fix Notice of Absence issues
      ath9k: Clear offchannel duration properly
      ath9k: Fix channel switch time duration
      ath9k: Fix beacon miss handling
      ath9k: Fix beacon processing in offchannel
      ath9k: Remove unnecessary tbtt assignment
      ath9k: Check beaconing mode properly
      ath9k: Set offchannel state properly
      ath9k: Remove useless opmode check
      ath9k: Fix primary station configuration
      ath9k: Fix build error
      ath9k: Cache BSS information
      ath9k: Fix p2p address management
      ath9k: Fix queue management
      ath9k: Use normal queues for offchannel frames
      ath9k: Fix offchannel queuing
      ath9k: Check early for HW reset
      ath: Add support for tracing
      ath9k: Print RoC expiration
      ath9k: Check pending frames properly
      ath9k: Fix pending frame check
      ath9k: Remove duplicate code
      ath9k: Fix queue handling in flush()
      ath9k: Pass context to ath9k_chanctx_wake_queues()
      ath9k: Add ath9k_chanctx_stop_queues()
      ath9k: Fix queue handling for channel contexts
      ath9k: Fix flushing in MCC mode

Suresh Reddy (3):
      be2net: query max_tx_qs for BE3 super-nic profile from FW
      be2net: use v1 of SET_FLOW_CONTROL command
      be2net: fix sparse warnings in be_cmd_req_port_type{}

Sven Eckelmann (1):
      ath: Move spectral debugfs structs to shared header

Sylvain "ythier" Hitier (1):
      3c59x: fix bad split of cpu_to_le32(pci_map_single())

S√©bastien Barr√© (3):
      ipv4: Restore accept_local behaviour in fib_validate_source()
      Revert "ipv4: Clarify in docs that accept_local requires rp_filter."
      Removed unused inet6 address state

Thierry Reding (1):
      net: dsa: Fix build warning for !PM_SLEEP

Thomas Huehn (2):
      mac80211: Unify rate statistic variables between Minstrel & Minstrel_HT
      mac80211: improve minstrel_ht rate sorting by throughput & probability

Tilman Schmidt (4):
      isdn/capi: drop two dead if branches
      isdn/gigaset: improve error handling when leaving DLE mode
      isdn/gigaset: drop unused cardstate structure member
      isdn/gigaset: use USB API function usb_endpoint_num()

Tobias Klauser (2):
      net: bcmgenet: Fix compile warning
      net: ethernet: Remove superfluous ether_setup after alloc_etherdev

Todd Fujinaka (2):
      igb: add flags to set eee advertisement mode
      igb: bump version to 5.2.15

Tom Herbert (45):
      net: skb_gro_checksum_* functions
      net: add gro_compute_pseudo functions
      gre: call skb_gro_checksum_simple_validate
      tcp: Call skb_gro_checksum_validate
      udp: additional GRO support
      gre: When GRE csum is present count as encap layer wrt csum
      net: Allocate a new 16 bits for flags in skbuff
      net: Clarification of CHECKSUM_UNNECESSARY
      net: Allow GRO to use and set levels of checksum unnecessary
      sctp: Change sctp to implement csum_levels
      benet: Set skb->csum_level for encapsulated checksum
      i40e: Set skb->csum_level for encapsulated checksum
      i40evf: Set skb->csum_level for encapsulated checksum
      mlx4: Set skb->csum_level for encapsulated checksum
      qlcnic: Set skb->csum_level for encapsulated checksum
      net: Support for csum_bad in skbuff
      net: Infrastructure for checksum unnecessary conversions
      udp: Add support for doing checksum unnecessary conversion
      gre: Add support for checksum unnecessary conversions
      vxlan: Enable checksum unnecessary conversions for vxlan/UDP sockets
      l2tp: Enable checksum unnecessary conversions for l2tp/UDP sockets
      net: Fix GRE RX to use skb_transport_header for GRE header offset
      ipv6: Clear flush_id to make GRO work
      ipip: Add gro callbacks to ipip offload
      sit: Add gro callbacks to sit_offload
      net: Export inet_offloads and inet6_offloads
      fou: Support for foo-over-udp RX path
      fou: Add GRO support
      net: Changes to ip_tunnel to support foo-over-udp encapsulation
      sit: Setup and TX path for sit/UDP foo-over-udp encapsulation
      ipip: Setup and TX path for ipip/UDP foo-over-udp encapsulation
      gre: Setup and TX path for gre/UDP foo-over-udp encapsulation
      udp: Need to make ip6_udp_tunnel.c have GPL license
      tcp: move logic out of tcp_v[64]_gso_send_check
      udp: move logic out of udp[46]_ufo_send_check
      net: Remove gso_send_check as an offload callback
      udp: Generalize skb_udp_segment
      sit: Set inner IP protocol in sit
      ipip: Set inner IP protocol in ipip
      gre: Set inner protocol in v4 and v6 GRE transmit
      vxlan: Set inner protocol before transmit
      ip_tunnel: Account for secondary encapsulation header in max_headroom
      fou: eliminate IPv4,v6 specific GRO functions
      gue: Receive side for Generic UDP Encapsulation
      ip_tunnel: Add GUE support

Tom Lendacky (1):
      amd-xgbe-phy: Fix build break for missing declaration

Tomasz Bursztyka (1):
      wireless: core: Reorder wiphy_register() notifications relevantly

Toralf F√∂rster (1):
      iwlwifi/iwl-drv.c: fix typo defualt -> default

Varka Bhadram (9):
      MAINTAINERS: update maintainers info
      mac802154: cleanup in rx path
      mac802154: common error path
      mac802154: common tx error path
      ethernet: ti: remove unwanted THIS_MODULE macro
      ethernet: amd: use pr_info_once()
      mrf24j40: fix Missing a blank line after declarations
      mrf24j40: remove unnecessary return statement
      mrf24j40: use pr_* / dev_* instead of printk()

Vasundhara Volam (5):
      be2net: Add a dma_mapping_error counter in ethtool
      be2net: make be_cmd_get_regs() return a status
      be2net: fix some log messages
      be2net: replace strcpy with strlcpy
      be2net: add speed reporting for 20G-KR interface

Vijay Subramanian (1):
      net: Cleanup skb cloning by adding SKB_FCLONE_FREE

Vincent Bernat (1):
      net/ipv4: bind ip_nonlocal_bind to current netns

Vincent Cuissard (3):
      NFC: NCI: Add support of ISO15693
      NFC: NCI: Fix nci_register_device init sequence
      NFC: NCI: Fix NCI RF FRAME interface usage

Vincent Zwanenburg (1):
      Add a new PID/VID 0227/0930 for AR3012.

Vlad Yasevich (4):
      bridge: Add a default_pvid sysfs attribute
      bridge: Simplify pvid checks.
      bridge: Add filtering support for default_pvid
      sctp: handle association restarts when the socket is closed.

Vladimir Kondratiev (33):
      wil6210: map MAC timer for packet lifetime into debugfs
      wil6210: fix race in reset
      wil6210: update copyright year 2014
      wil6210: check error in wil_target_reset()
      wil6210: wait longer for hardware reset completion
      wil6210: Workaround for Sparrow with bad device id
      wil6210: convert debugfs to the table mode
      wil6210: fix beamforming data reporting
      wil6210: fix false "scan timeout"
      wil6210: fix free'd memory access in wil_if_free()
      wil6210: cfg80211_rx_mgmt to use GFP_ATOMIC
      wil6210: fix access after free in wil_pcie_remove()
      cfg80211: remove @gfp parameter from cfg80211_rx_mgmt()
      wil6210: firmware download
      wil6210: debug prints for vring de-allocation
      wil6210: print more information when connecting
      wil6210: some more debug for the WMI mechanism
      wil6210: coding style fixes
      wil6210: platform specific module
      wil6210: add more debug printouts
      wil6210: fix usage of print_hex_dump_debug
      wil6210: send connect request IEs to FW also for non-secure connection
      wil6210: add change_beacon() driver callback
      wil6210: enlarge TX/RX buffer length
      wil6210: specify max. IE length
      wil6210: fix typo in comment
      wil6210: rename [en|dis]able irq to [un]mask
      wil6210: fix for oops while stopping interface
      wil6210: fix PTR_ERR() usage after initialization to constant
      fixup! wil6210: fix usage of print_hex_dump_debug
      wil6210: ethtool ops
      wil6210: manual FW error recovery mode
      wil6210: atomic I/O for the card memory

Vytas Dauksa (1):
      netfilter: ipset: Removed invalid IPSET_ATTR_MARKMASK validation

WANG Cong (24):
      net: fix comments for __skb_flow_get_ports()
      net: make skb an optional parameter for__skb_flow_dissect()
      ipv6: drop useless rcu_read_lock() in anycast
      ipv6: remove ipv6_sk_ac_lock
      ipv6: clean up ipv6_dev_ac_inc()
      ipv6: refactor __ipv6_dev_ac_inc()
      ipv6: drop ipv6_sk_mc_lock in mcast
      ipv6: drop some rcu_read_lock in mcast
      ipv6: update the comment in mcast.c
      ipv6: refactor ipv6_dev_mc_inc()
      ipv6: exit early in addrconf_notify() if IPv6 is disabled
      net_sched: fix suspicious RCU usage in cls_bpf_classify()
      net_sched: fix an allocation bug in tcindex_set_parms()
      net_sched: fix suspicious RCU usage in tcindex_classify()
      net_sched: use tcindex_filter_result_init()
      net_sched: fix memory leak in cls_tcindex
      net_sched: fix a null pointer dereference in tcindex_set_parms()
      net_sched: remove the first parameter from tcf_exts_destroy()
      net_sched: fix errno in tcindex_set_parms()
      net_sched: fix another regression in cls_tcindex
      net_sched: fix another crash in cls_tcindex
      net_sched: avoid calling tcf_unbind_filter() in call_rcu callback
      net_sched: fix unused variables in __gnet_stats_copy_basic_cpu()
      net_sched: copy exts->type in tcf_exts_change()

Walter Lozano (2):
      Altera TSE: Move PHY get addr and MDIO create
      Altera TSE: Add support for no PHY

Wang Sheng-Hui (1):
      net/openvswitch: remove dup comment in vport.h

Wei Yongjun (1):
      net: stmmac: fix return value check in socfpga_dwmac_parse_data()

Willem de Bruijn (5):
      net-timestamp: expand documentation
      sock: deduplicate errqueue dequeue
      net-timestamp: fix allocation error in test
      inet: remove dead inetpeer sequence code
      net-timestamp: optimize sock_tx_timestamp default path

Wolfram Sang (1):
      net: can: use kbuild magic to inherit debug settings

Xinming Hu (2):
      mwifiex: fix 5G association failure after leaving 2.4G IBSS
      Bluetooth: btmrvl: support Marvell Bluetooth device SD8887

Ying Xue (3):
      xfrm: remove useless hash_resize_mutex locks
      tipc: fix a potential oops
      lib/rhashtable: allow user to set the minimum shifts of shrinking

Yuchung Cheng (2):
      tcp: improve undo on timeout
      tcp: abort orphan sockets stalling on zero window probes

Yuval Mintz (12):
      bnx2x: Code cleanup
      bnx2x: Update driver version to 1.710.51
      bnx2x: Safe bnx2x_panic_dump()
      bnx2x: Prevent IOV if no entries in CAM
      bnx2x: Prevent pci_disable_sriov with assigned VFs
      bnx2x: Make BP_VF more robust
      bnx2x: Fix stop-on-error
      bnx2x: VF clean statistics
      bnx2x: Fix static checker warning regarding `txdata_ptr'
      bnx2x: Fix sparse warnings
      bnx2x: New multi-function mode: UFP
      bnx2x: Add a fallback multi-function mode NPAR1.5

andrea.merello (1):
      rtl818x_pci: add RSSI information for rtl8187SE

dingtianhong (2):
      bonding: slight optimization for bond_xmit_roundrobin()
      bonding: remove the unnecessary notes for bond_xmit_broadcast()

hayeswang (13):
      r8152: check code with checkpatch.pl
      r8152: replace strncpy with strlcpy
      r8152: reduce the number of Tx
      r8152: rename rx_buf_sz
      r8152: change the location of rtl8152_set_mac_address
      r8152: use eth_hw_addr_random
      r8152: use usleep_range
      r8152: support VLAN
      r8152: change the EEE definition
      r8152: add functions to set EEE
      r8152: support ethtool eee
      r8152: autoresume before setting MAC address
      r8152: nway reset after setting eee

stephen hemminger (2):
      neigh: document gc_thresh2
      tcp: whitespace fixes

 Documentation/devicetree/bindings/bus/bcma.txt                 |   32 +
 Documentation/devicetree/bindings/net/broadcom-mdio-unimac.txt |   39 +
 Documentation/devicetree/bindings/net/broadcom-sf2.txt         |   78 +
 Documentation/devicetree/bindings/net/can/m_can.txt            |   67 +
 Documentation/devicetree/bindings/net/can/rcar_can.txt         |   43 +
 Documentation/devicetree/bindings/net/cpsw.txt                 |    6 +-
 Documentation/devicetree/bindings/net/dsa/dsa.txt              |   17 +
 Documentation/devicetree/bindings/net/emac_rockchip.txt        |   50 +
 Documentation/devicetree/bindings/net/fsl-fec.txt              |    6 +
 Documentation/devicetree/bindings/net/marvell-pxa168.txt       |   36 +
 Documentation/devicetree/bindings/net/meson-dwmac.txt          |   25 +
 Documentation/devicetree/bindings/net/nfc/st21nfcb.txt         |    2 +-
 Documentation/devicetree/bindings/net/nfc/trf7970a.txt         |    8 +
 Documentation/devicetree/bindings/net/qca-qca7000-spi.txt      |   47 +
 Documentation/devicetree/bindings/net/socfpga-dwmac.txt        |    4 +
 Documentation/networking/dctcp.txt                             |   43 +
 Documentation/networking/filter.txt                            |  271 +++-
 Documentation/networking/ip-sysctl.txt                         |   40 +-
 Documentation/networking/pktgen.txt                            |    3 +
 Documentation/networking/timestamping.txt                      |  368 ++++-
 Documentation/networking/timestamping/Makefile                 |   10 +-
 Documentation/networking/timestamping/txtimestamp.c            |  469 ++++++
 Documentation/sysctl/net.txt                                   |   16 +
 MAINTAINERS                                                    |   38 +-
 arch/arm/boot/dts/am33xx.dtsi                                  |    6 +
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts                     |    4 +
 arch/arm/boot/dts/berlin2q.dtsi                                |   17 +
 arch/arm/boot/dts/imx6sx.dtsi                                  |    2 +
 arch/arm/boot/dts/rk3188-radxarock.dts                         |   22 +
 arch/arm/boot/dts/rk3188.dtsi                                  |   22 +
 arch/arm/boot/dts/rk3xxx.dtsi                                  |   17 +
 arch/arm/net/bpf_jit_32.c                                      |   37 +-
 arch/arm/net/bpf_jit_32.h                                      |   14 +
 arch/arm/plat-orion/common.c                                   |    2 +-
 arch/mips/bcm47xx/setup.c                                      |    4 +
 arch/mips/net/bpf_jit.c                                        |   33 +-
 arch/powerpc/net/bpf_jit_comp.c                                |    5 +-
 arch/s390/net/bpf_jit_comp.c                                   |   84 +-
 arch/sparc/include/asm/vio.h                                   |   44 +-
 arch/sparc/kernel/ldc.c                                        |    2 +-
 arch/sparc/kernel/viohs.c                                      |   14 +-
 arch/sparc/net/bpf_jit_comp.c                                  |   21 +-
 arch/x86/net/bpf_jit_comp.c                                    |  129 +-
 arch/x86/syscalls/syscall_32.tbl                               |    1 +
 arch/x86/syscalls/syscall_64.tbl                               |    1 +
 drivers/bcma/Makefile                                          |    1 +
 drivers/bcma/bcma_private.h                                    |   18 +
 drivers/bcma/driver_chipcommon_b.c                             |   61 +
 drivers/bcma/driver_gpio.c                                     |    8 +-
 drivers/bcma/driver_mips.c                                     |   62 +
 drivers/bcma/host_pci.c                                        |    3 +
 drivers/bcma/host_soc.c                                        |   99 +-
 drivers/bcma/main.c                                            |  150 +-
 drivers/bcma/scan.c                                            |   34 +-
 drivers/bluetooth/Kconfig                                      |    4 +-
 drivers/bluetooth/ath3k.c                                      |    2 +
 drivers/bluetooth/bluecard_cs.c                                |   35 +-
 drivers/bluetooth/bt3c_cs.c                                    |   27 +-
 drivers/bluetooth/btmrvl_sdio.c                                |   36 +-
 drivers/bluetooth/btuart_cs.c                                  |   27 +-
 drivers/bluetooth/btusb.c                                      |  525 ++++--
 drivers/bluetooth/dtl1_cs.c                                    |   36 +-
 drivers/bluetooth/hci_h5.c                                     |    2 +-
 drivers/infiniband/hw/mlx5/cq.c                                |    8 +-
 drivers/infiniband/hw/mlx5/mad.c                               |    2 +-
 drivers/infiniband/hw/mlx5/main.c                              |   83 +-
 drivers/infiniband/hw/mlx5/qp.c                                |   72 +-
 drivers/infiniband/hw/mlx5/srq.c                               |    6 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c                      |    2 +-
 drivers/isdn/capi/capiutil.c                                   |    3 -
 drivers/isdn/gigaset/bas-gigaset.c                             |    2 +-
 drivers/isdn/gigaset/ev-layer.c                                |    3 +-
 drivers/isdn/gigaset/usb-gigaset.c                             |   14 +-
 drivers/isdn/mISDN/dsp_cmx.c                                   |  109 +-
 drivers/net/Kconfig                                            |    1 -
 drivers/net/appletalk/ipddp.c                                  |    2 +-
 drivers/net/arcnet/arcnet.c                                    |    2 +-
 drivers/net/arcnet/com20020-pci.c                              |  369 ++++-
 drivers/net/arcnet/com20020.c                                  |   14 +
 drivers/net/arcnet/com20020_cs.c                               |    4 -
 drivers/net/bonding/bond_3ad.c                                 |  230 +--
 drivers/net/bonding/bond_3ad.h                                 |    1 -
 drivers/net/bonding/bond_alb.c                                 |  305 +---
 drivers/net/bonding/bond_alb.h                                 |   10 -
 drivers/net/bonding/bond_debugfs.c                             |    8 +-
 drivers/net/bonding/bond_main.c                                |  629 +++----
 drivers/net/bonding/bond_netlink.c                             |   41 +-
 drivers/net/bonding/bond_options.c                             |   39 +-
 drivers/net/bonding/bond_procfs.c                              |   27 +-
 drivers/net/bonding/bond_sysfs.c                               |   11 +-
 drivers/net/bonding/bonding.h                                  |   45 +-
 drivers/net/can/Kconfig                                        |    4 +-
 drivers/net/can/Makefile                                       |    3 +-
 drivers/net/can/c_can/Makefile                                 |    2 -
 drivers/net/can/cc770/Makefile                                 |    2 -
 drivers/net/can/dev.c                                          |    3 +-
 drivers/net/can/flexcan.c                                      |  114 +-
 drivers/net/can/m_can/Kconfig                                  |    4 +
 drivers/net/can/m_can/Makefile                                 |    5 +
 drivers/net/can/m_can/m_can.c                                  | 1202 ++++++++++++++
 drivers/net/can/mscan/Makefile                                 |    2 -
 drivers/net/can/rcar_can.c                                     |   66 +-
 drivers/net/can/sja1000/Makefile                               |    2 -
 drivers/net/can/softing/Makefile                               |    2 -
 drivers/net/can/spi/Makefile                                   |    2 -
 drivers/net/can/spi/mcp251x.c                                  |   16 +-
 drivers/net/can/usb/Makefile                                   |    2 -
 drivers/net/dsa/Kconfig                                        |   21 +
 drivers/net/dsa/Makefile                                       |    4 +
 drivers/net/dsa/bcm_sf2.c                                      |  887 ++++++++++
 drivers/net/dsa/bcm_sf2.h                                      |  147 ++
 drivers/net/dsa/bcm_sf2_regs.h                                 |  231 +++
 drivers/net/dsa/mv88e6060.c                                    |   15 +-
 drivers/net/dsa/mv88e6123_61_65.c                              |   10 +-
 drivers/net/dsa/mv88e6131.c                                    |    8 +-
 drivers/net/dsa/mv88e6171.c                                    |  411 +++++
 drivers/net/dsa/mv88e6xxx.c                                    |   10 +-
 drivers/net/dsa/mv88e6xxx.h                                    |    1 +
 drivers/net/eql.c                                              |    2 +-
 drivers/net/ethernet/3com/3c509.c                              |    6 +-
 drivers/net/ethernet/3com/3c515.c                              |   25 +-
 drivers/net/ethernet/3com/3c59x.c                              |   29 +-
 drivers/net/ethernet/Kconfig                                   |    2 +
 drivers/net/ethernet/Makefile                                  |    2 +
 drivers/net/ethernet/adi/bfin_mac.c                            |    3 -
 drivers/net/ethernet/agere/Kconfig                             |   31 +
 drivers/net/ethernet/agere/Makefile                            |    5 +
 drivers/net/ethernet/agere/et131x.c                            | 4121 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/agere/et131x.h                            | 1433 ++++++++++++++++
 drivers/net/ethernet/allwinner/sun4i-emac.c                    |    2 -
 drivers/net/ethernet/altera/altera_tse_main.c                  |   66 +-
 drivers/net/ethernet/amd/au1000_eth.c                          |    6 +-
 drivers/net/ethernet/amd/nmclan_cs.c                           |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h                    |   11 -
 drivers/net/ethernet/amd/xgbe/xgbe-dcb.c                       |    1 -
 drivers/net/ethernet/amd/xgbe/xgbe-debugfs.c                   |    1 -
 drivers/net/ethernet/amd/xgbe/xgbe-desc.c                      |    6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c                       |    1 -
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c                       |    1 -
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c                   |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c                      |    1 -
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c                      |    1 -
 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c                       |    1 -
 drivers/net/ethernet/amd/xgbe/xgbe.h                           |    2 -
 drivers/net/ethernet/arc/Kconfig                               |   18 +-
 drivers/net/ethernet/arc/Makefile                              |    4 +-
 drivers/net/ethernet/arc/emac.h                                |    8 +-
 drivers/net/ethernet/arc/emac_arc.c                            |   95 ++
 drivers/net/ethernet/arc/emac_main.c                           |  129 +-
 drivers/net/ethernet/arc/emac_mdio.c                           |    7 +-
 drivers/net/ethernet/arc/emac_rockchip.c                       |  229 +++
 drivers/net/ethernet/broadcom/Kconfig                          |    1 +
 drivers/net/ethernet/broadcom/b44.c                            |    2 +-
 drivers/net/ethernet/broadcom/bcmsysport.c                     |   31 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h                    |   93 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c                |  140 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h                |   19 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c                |    5 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_dump.h               |   14 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c            |   44 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h            |  222 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h                |  257 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c               | 1048 ++++++++++--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h                |  178 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c                 |  169 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h                 |   85 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c              |   48 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h              |    3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c              |   10 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c               |    9 -
 drivers/net/ethernet/broadcom/cnic.c                           |    6 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                 |   88 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h                 |    6 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c                   |   91 +-
 drivers/net/ethernet/brocade/bna/bna_enet.c                    |    9 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c                   |    6 +-
 drivers/net/ethernet/brocade/bna/bnad.c                        |    2 +-
 drivers/net/ethernet/cadence/at91_ether.c                      |    1 -
 drivers/net/ethernet/cadence/macb.c                            |    6 +-
 drivers/net/ethernet/calxeda/xgmac.c                           |    1 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h                     |    5 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c                |   32 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c                       |  218 ++-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                     |   27 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h                     |    9 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h                   |   20 +
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c            |  107 +-
 drivers/net/ethernet/cisco/enic/enic.h                         |    1 +
 drivers/net/ethernet/cisco/enic/enic_ethtool.c                 |   39 +
 drivers/net/ethernet/cisco/enic/enic_main.c                    |   50 +-
 drivers/net/ethernet/cisco/enic/vnic_dev.c                     |    3 +-
 drivers/net/ethernet/davicom/dm9000.c                          |    3 -
 drivers/net/ethernet/dec/tulip/dmfe.c                          |  152 +-
 drivers/net/ethernet/ec_bhf.c                                  |  101 +-
 drivers/net/ethernet/emulex/benet/be.h                         |   30 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c                    |  182 ++-
 drivers/net/ethernet/emulex/benet/be_cmds.h                    |   48 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c                 |  173 +-
 drivers/net/ethernet/emulex/benet/be_hw.h                      |   12 +
 drivers/net/ethernet/emulex/benet/be_main.c                    |  368 +++--
 drivers/net/ethernet/emulex/benet/be_roce.c                    |    1 +
 drivers/net/ethernet/ethoc.c                                   |    2 -
 drivers/net/ethernet/freescale/fec.h                           |  204 ++-
 drivers/net/ethernet/freescale/fec_main.c                      | 1218 ++++++++++----
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c          |  211 +--
 drivers/net/ethernet/freescale/fs_enet/fs_enet.h               |    9 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fcc.c               |   29 +
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c               |   29 +
 drivers/net/ethernet/freescale/fs_enet/mac-scc.c               |   29 +
 drivers/net/ethernet/hp/hp100.c                                |    4 +-
 drivers/net/ethernet/intel/Kconfig                             |   19 +
 drivers/net/ethernet/intel/Makefile                            |    1 +
 drivers/net/ethernet/intel/e1000/e1000.h                       |   19 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c               |  187 +--
 drivers/net/ethernet/intel/e1000/e1000_hw.c                    |   78 -
 drivers/net/ethernet/intel/e1000/e1000_hw.h                    |    2 -
 drivers/net/ethernet/intel/e1000/e1000_main.c                  |  498 +++---
 drivers/net/ethernet/intel/fm10k/Makefile                      |   33 +
 drivers/net/ethernet/intel/fm10k/fm10k.h                       |  530 ++++++
 drivers/net/ethernet/intel/fm10k/fm10k_common.c                |  534 ++++++
 drivers/net/ethernet/intel/fm10k/fm10k_common.h                |   65 +
 drivers/net/ethernet/intel/fm10k/fm10k_dcbnl.c                 |  174 ++
 drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c               |  259 +++
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c               | 1071 ++++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_iov.c                   |  536 ++++++
 drivers/net/ethernet/intel/fm10k/fm10k_main.c                  | 1979 +++++++++++++++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c                   | 2125 ++++++++++++++++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.h                   |  307 ++++
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c                | 1435 ++++++++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c                   | 2166 +++++++++++++++++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c                    | 1880 +++++++++++++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_pf.h                    |  135 ++
 drivers/net/ethernet/intel/fm10k/fm10k_ptp.c                   |  463 ++++++
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c                   |  863 ++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.h                   |  186 +++
 drivers/net/ethernet/intel/fm10k/fm10k_type.h                  |  770 +++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_vf.c                    |  578 +++++++
 drivers/net/ethernet/intel/fm10k/fm10k_vf.h                    |   78 +
 drivers/net/ethernet/intel/i40e/i40e.h                         |    9 +
 drivers/net/ethernet/intel/i40e/i40e_adminq.c                  |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c                  |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c                 |    3 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c                 |   70 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c                    |  259 ++-
 drivers/net/ethernet/intel/i40e/i40e_prototype.h               |    6 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c                    |  182 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h                    |    1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |   50 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h             |    2 +-
 drivers/net/ethernet/intel/i40evf/i40e_adminq.c                |    9 +-
 drivers/net/ethernet/intel/i40evf/i40e_common.c                |    8 +-
 drivers/net/ethernet/intel/i40evf/i40e_prototype.h             |    6 +-
 drivers/net/ethernet/intel/i40evf/i40e_txrx.c                  |    8 +-
 drivers/net/ethernet/intel/i40evf/i40e_txrx.h                  |    1 +
 drivers/net/ethernet/intel/i40evf/i40evf_main.c                |    2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                   |   31 +-
 drivers/net/ethernet/intel/igb/e1000_82575.h                   |    4 +-
 drivers/net/ethernet/intel/igb/e1000_hw.h                      |    5 -
 drivers/net/ethernet/intel/igb/igb.h                           |    1 -
 drivers/net/ethernet/intel/igb/igb_ethtool.c                   |   24 +-
 drivers/net/ethernet/intel/igb/igb_main.c                      |  220 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe.h                       |  117 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c               |    7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c                   |  160 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |  316 ++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c                   |   41 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c                 |   14 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h                  |    7 +
 drivers/net/ethernet/intel/ixgbevf/ethtool.c                   |    2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h                   |    1 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c              |    4 -
 drivers/net/ethernet/intel/ixgbevf/vf.c                        |   15 +
 drivers/net/ethernet/lantiq_etop.c                             |    1 -
 drivers/net/ethernet/marvell/Kconfig                           |    2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c                      |  219 ++-
 drivers/net/ethernet/marvell/skge.c                            |    6 +-
 drivers/net/ethernet/marvell/sky2.c                            |    2 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c                       |   14 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                |   45 +
 drivers/net/ethernet/mellanox/mlx4/en_main.c                   |   17 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                 |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_port.c                   |   17 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c                     |   23 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c                     |  400 +++--
 drivers/net/ethernet/mellanox/mlx4/eq.c                        |   30 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c                        |   47 +-
 drivers/net/ethernet/mellanox/mlx4/fw.h                        |    2 +
 drivers/net/ethernet/mellanox/mlx4/main.c                      |  482 +++---
 drivers/net/ethernet/mellanox/mlx4/mlx4.h                      |    3 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                   |  101 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c                  |   77 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c                   |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c                   |   81 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c                 |  230 ++-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c                   |   60 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c                  |    4 +-
 drivers/net/ethernet/moxa/moxart_ether.c                       |    1 -
 drivers/net/ethernet/neterion/vxge/vxge-main.c                 |    2 +-
 drivers/net/ethernet/netx-eth.c                                |    2 -
 drivers/net/ethernet/nuvoton/w90p910_ether.c                   |    1 -
 drivers/net/ethernet/nvidia/forcedeth.c                        |    2 +-
 drivers/net/ethernet/nxp/lpc_eth.c                             |    3 -
 drivers/net/ethernet/packetengines/yellowfin.c                 |    4 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c           |    5 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h                    |    8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c            |  218 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h            |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c          |  156 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c                 |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c               |    6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c                 |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c               |   10 +-
 drivers/net/ethernet/qlogic/qlge/qlge_main.c                   |    4 +-
 drivers/net/ethernet/qualcomm/Kconfig                          |   30 +
 drivers/net/ethernet/qualcomm/Makefile                         |    6 +
 drivers/net/ethernet/qualcomm/qca_7k.c                         |  149 ++
 drivers/net/ethernet/qualcomm/qca_7k.h                         |   72 +
 drivers/net/ethernet/qualcomm/qca_debug.c                      |  311 ++++
 drivers/net/ethernet/qualcomm/qca_debug.h                      |   34 +
 drivers/net/ethernet/qualcomm/qca_framing.c                    |  156 ++
 drivers/net/ethernet/qualcomm/qca_framing.h                    |  134 ++
 drivers/net/ethernet/qualcomm/qca_spi.c                        |  991 ++++++++++++
 drivers/net/ethernet/qualcomm/qca_spi.h                        |  114 ++
 drivers/net/ethernet/realtek/r8169.c                           | 1437 +++++++++++++---
 drivers/net/ethernet/sfc/tx.c                                  |    2 +-
 drivers/net/ethernet/smsc/smc911x.c                            |    3 -
 drivers/net/ethernet/smsc/smc91x.c                             |    3 -
 drivers/net/ethernet/smsc/smsc911x.c                           |    1 -
 drivers/net/ethernet/stmicro/stmmac/Kconfig                    |   10 +
 drivers/net/ethernet/stmicro/stmmac/Makefile                   |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c              |   67 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c            |   62 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h                   |    3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c           |   18 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c              |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c              |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c          |    3 +
 drivers/net/ethernet/sun/cassini.c                             |    2 +-
 drivers/net/ethernet/sun/niu.c                                 |    4 +-
 drivers/net/ethernet/sun/sungem.c                              |   34 +-
 drivers/net/ethernet/sun/sunvnet.c                             |  433 ++++-
 drivers/net/ethernet/sun/sunvnet.h                             |   20 +-
 drivers/net/ethernet/ti/Kconfig                                |    2 +
 drivers/net/ethernet/ti/cpmac.c                                |    1 -
 drivers/net/ethernet/ti/cpsw-phy-sel.c                         |    1 -
 drivers/net/ethernet/ti/cpsw.c                                 |  105 +-
 drivers/net/ethernet/ti/cpsw.h                                 |    1 +
 drivers/net/ethernet/ti/davinci_emac.c                         |    1 -
 drivers/net/ethernet/ti/davinci_mdio.c                         |    1 -
 drivers/net/ethernet/tile/tilepro.c                            |    8 +-
 drivers/net/ethernet/toshiba/spider_net.c                      |   42 +-
 drivers/net/ethernet/wiznet/w5100.c                            |    1 -
 drivers/net/ethernet/wiznet/w5300.c                            |    1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c                    |    1 -
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c              |    1 -
 drivers/net/fddi/defxx.c                                       |   64 +-
 drivers/net/fddi/defxx.h                                       |   12 +-
 drivers/net/hyperv/hyperv_net.h                                |    4 +-
 drivers/net/hyperv/netvsc.c                                    |   37 +-
 drivers/net/ieee802154/mrf24j40.c                              |   19 +-
 drivers/net/ifb.c                                              |    3 +-
 drivers/net/irda/Kconfig                                       |    2 +-
 drivers/net/irda/vlsi_ir.c                                     |    8 +-
 drivers/net/loopback.c                                         |    2 +-
 drivers/net/macvlan.c                                          |  307 +++-
 drivers/net/phy/Kconfig                                        |   11 +-
 drivers/net/phy/Makefile                                       |    1 +
 drivers/net/phy/amd-xgbe-phy.c                                 |  168 +-
 drivers/net/phy/bcm7xxx.c                                      |  153 +-
 drivers/net/phy/broadcom.c                                     |  122 --
 drivers/net/phy/dp83640.c                                      |   35 +-
 drivers/net/phy/fixed.c                                        |   27 +-
 drivers/net/phy/mdio-bcm-unimac.c                              |  213 +++
 drivers/net/phy/mdio_bus.c                                     |    8 +-
 drivers/net/phy/phy.c                                          |   12 +-
 drivers/net/phy/phy_device.c                                   |    4 +-
 drivers/net/ppp/ppp_generic.c                                  |    2 +-
 drivers/net/sungem_phy.c                                       |  304 ++--
 drivers/net/team/team.c                                        |   56 +-
 drivers/net/usb/asix_devices.c                                 |    2 +-
 drivers/net/usb/r8152.c                                        |  509 ++++--
 drivers/net/virtio_net.c                                       |    9 +-
 drivers/net/vxlan.c                                            |   97 +-
 drivers/net/wan/dlci.c                                         |    6 +-
 drivers/net/wan/hdlc_fr.c                                      |    2 +-
 drivers/net/wireless/ath/Kconfig                               |    8 +
 drivers/net/wireless/ath/Makefile                              |    4 +
 drivers/net/wireless/ath/ath.h                                 |    4 +
 drivers/net/wireless/ath/ath10k/Kconfig                        |    3 +-
 drivers/net/wireless/ath/ath10k/Makefile                       |    2 +
 drivers/net/wireless/ath/ath10k/bmi.c                          |   52 +-
 drivers/net/wireless/ath/ath10k/bmi.h                          |    1 -
 drivers/net/wireless/ath/ath10k/ce.c                           |  185 +--
 drivers/net/wireless/ath/ath10k/ce.h                           |   41 +-
 drivers/net/wireless/ath/ath10k/core.c                         |  340 ++--
 drivers/net/wireless/ath/ath10k/core.h                         |   89 +-
 drivers/net/wireless/ath/ath10k/debug.c                        |  399 ++++-
 drivers/net/wireless/ath/ath10k/debug.h                        |   46 +-
 drivers/net/wireless/ath/ath10k/hif.h                          |    1 -
 drivers/net/wireless/ath/ath10k/htc.c                          |  121 +-
 drivers/net/wireless/ath/ath10k/htc.h                          |    8 +-
 drivers/net/wireless/ath/ath10k/htt.c                          |   11 +-
 drivers/net/wireless/ath/ath10k/htt.h                          |    3 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c                       |  217 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c                       |   48 +-
 drivers/net/wireless/ath/ath10k/hw.h                           |    7 +-
 drivers/net/wireless/ath/ath10k/mac.c                          |  898 +++++-----
 drivers/net/wireless/ath/ath10k/mac.h                          |    6 +-
 drivers/net/wireless/ath/ath10k/pci.c                          | 1638 ++++++++-----------
 drivers/net/wireless/ath/ath10k/pci.h                          |  104 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h                      |    1 -
 drivers/net/wireless/ath/ath10k/spectral.c                     |  561 +++++++
 drivers/net/wireless/ath/ath10k/spectral.h                     |   90 ++
 drivers/net/wireless/ath/ath10k/targaddrs.h                    |    1 -
 drivers/net/wireless/ath/ath10k/testmode.c                     |  382 +++++
 drivers/net/wireless/ath/ath10k/testmode.h                     |   46 +
 drivers/net/wireless/ath/ath10k/testmode_i.h                   |   70 +
 drivers/net/wireless/ath/ath10k/trace.h                        |  105 +-
 drivers/net/wireless/ath/ath10k/txrx.c                         |   19 +-
 drivers/net/wireless/ath/ath10k/wmi.c                          | 1184 ++++++++++----
 drivers/net/wireless/ath/ath10k/wmi.h                          |  726 +++++++--
 drivers/net/wireless/ath/ath5k/Kconfig                         |   14 +-
 drivers/net/wireless/ath/ath5k/Makefile                        |    1 -
 drivers/net/wireless/ath/ath5k/ahb.c                           |  234 ---
 drivers/net/wireless/ath/ath5k/ath5k.h                         |   28 -
 drivers/net/wireless/ath/ath5k/attach.c                        |    3 +-
 drivers/net/wireless/ath/ath5k/base.c                          |   16 +-
 drivers/net/wireless/ath/ath5k/debug.c                         |   98 ++
 drivers/net/wireless/ath/ath5k/led.c                           |    7 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c                  |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c                     |    1 +
 drivers/net/wireless/ath/ath6kl/init.c                         |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c                         |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c                         |    1 +
 drivers/net/wireless/ath/ath6kl/usb.c                          |   21 +-
 drivers/net/wireless/ath/ath6kl/wmi.c                          |   48 +-
 drivers/net/wireless/ath/ath9k/Kconfig                         |   18 +
 drivers/net/wireless/ath/ath9k/Makefile                        |    3 +
 drivers/net/wireless/ath/ath9k/ar5008_phy.c                    |    9 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c                    |   19 +
 drivers/net/wireless/ath/ath9k/ar9003_mac.c                    |   19 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                    |   24 +-
 drivers/net/wireless/ath/ath9k/ath9k.h                         |  169 +-
 drivers/net/wireless/ath/ath9k/beacon.c                        |   73 +-
 drivers/net/wireless/ath/ath9k/channel.c                       | 1485 ++++++++++++-----
 drivers/net/wireless/ath/ath9k/debug.c                         |   30 +-
 drivers/net/wireless/ath/ath9k/dynack.c                        |  351 ++++
 drivers/net/wireless/ath/ath9k/dynack.h                        |  103 ++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c                  |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_main.c                  |    2 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h                        |    6 +
 drivers/net/wireless/ath/ath9k/hw.c                            |   51 +-
 drivers/net/wireless/ath/ath9k/hw.h                            |    8 +
 drivers/net/wireless/ath/ath9k/init.c                          |   90 +-
 drivers/net/wireless/ath/ath9k/mac.h                           |    1 +
 drivers/net/wireless/ath/ath9k/main.c                          |  700 ++++----
 drivers/net/wireless/ath/ath9k/recv.c                          |   62 +-
 drivers/net/wireless/ath/ath9k/reg.h                           |   15 +
 drivers/net/wireless/ath/ath9k/spectral.h                      |   71 +-
 drivers/net/wireless/ath/ath9k/tx99.c                          |    2 +-
 drivers/net/wireless/ath/ath9k/wow.c                           |    5 +-
 drivers/net/wireless/ath/ath9k/xmit.c                          |   41 +-
 drivers/net/wireless/ath/carl9170/main.c                       |   11 +-
 drivers/net/wireless/ath/carl9170/tx.c                         |    2 +-
 drivers/net/wireless/ath/main.c                                |    3 +
 drivers/net/wireless/ath/spectral_common.h                     |  113 ++
 drivers/net/wireless/ath/trace.c                               |   20 +
 drivers/net/wireless/ath/trace.h                               |   71 +
 drivers/net/wireless/ath/wil6210/Kconfig                       |    9 +
 drivers/net/wireless/ath/wil6210/Makefile                      |    5 +
 drivers/net/wireless/ath/wil6210/cfg80211.c                    |  136 +-
 drivers/net/wireless/ath/wil6210/debug.c                       |   18 +-
 drivers/net/wireless/ath/wil6210/debugfs.c                     |  456 ++++--
 drivers/net/wireless/ath/wil6210/ethtool.c                     |  103 ++
 drivers/net/wireless/ath/wil6210/fw.c                          |   45 +
 drivers/net/wireless/ath/wil6210/fw.h                          |  149 ++
 drivers/net/wireless/ath/wil6210/fw_inc.c                      |  495 ++++++
 drivers/net/wireless/ath/wil6210/interrupt.c                   |   45 +-
 drivers/net/wireless/ath/wil6210/ioctl.c                       |  173 ++
 drivers/net/wireless/ath/wil6210/main.c                        |  277 +++-
 drivers/net/wireless/ath/wil6210/netdev.c                      |   38 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c                    |   46 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c                  |   29 +-
 drivers/net/wireless/ath/wil6210/txrx.c                        |   69 +-
 drivers/net/wireless/ath/wil6210/txrx.h                        |   11 +-
 drivers/net/wireless/ath/wil6210/wil6210.h                     |   94 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c                |   49 +
 drivers/net/wireless/ath/wil6210/wil_platform.h                |   34 +
 drivers/net/wireless/ath/wil6210/wil_platform_msm.c            |  257 +++
 drivers/net/wireless/ath/wil6210/wil_platform_msm.h            |   24 +
 drivers/net/wireless/ath/wil6210/wmi.c                         |   90 +-
 drivers/net/wireless/ath/wil6210/wmi.h                         |   22 +-
 drivers/net/wireless/atmel_cs.c                                |   22 +-
 drivers/net/wireless/b43/Makefile                              |    1 +
 drivers/net/wireless/b43/b43.h                                 |   27 +
 drivers/net/wireless/b43/bus.c                                 |   10 +
 drivers/net/wireless/b43/bus.h                                 |   15 +
 drivers/net/wireless/b43/main.c                                |   88 +-
 drivers/net/wireless/b43/main.h                                |    2 +
 drivers/net/wireless/b43/phy_a.c                               |    4 +-
 drivers/net/wireless/b43/phy_common.c                          |   25 +-
 drivers/net/wireless/b43/phy_g.c                               |    8 +-
 drivers/net/wireless/b43/phy_ht.c                              |  225 +--
 drivers/net/wireless/b43/phy_ht.h                              |    7 +-
 drivers/net/wireless/b43/phy_lcn.c                             |   20 +-
 drivers/net/wireless/b43/phy_lp.c                              |   20 +-
 drivers/net/wireless/b43/phy_n.c                               |  130 +-
 drivers/net/wireless/b43/phy_n.h                               |    4 +
 drivers/net/wireless/b43/ppr.c                                 |  199 +++
 drivers/net/wireless/b43/ppr.h                                 |   45 +
 drivers/net/wireless/b43/radio_2059.c                          |  341 +++-
 drivers/net/wireless/b43/radio_2059.h                          |   14 +
 drivers/net/wireless/b43/tables_nphy.c                         |  128 +-
 drivers/net/wireless/b43/tables_nphy.h                         |    2 +
 drivers/net/wireless/b43/xmit.h                                |   22 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h              |   11 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.c              |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/feature.h              |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/flowring.c             |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h           |   56 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c             |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c               |  133 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                  |   11 +-
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c                 |   74 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c          |  132 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h          |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c                  |   38 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c          |  122 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c          |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c            |    8 +-
 drivers/net/wireless/brcm80211/include/defs.h                  |    5 +-
 drivers/net/wireless/cw1200/cw1200_spi.c                       |    4 +-
 drivers/net/wireless/hostap/hostap_proc.c                      |    6 +-
 drivers/net/wireless/ipw2x00/ipw2200.c                         |    6 +-
 drivers/net/wireless/iwlegacy/4965-mac.c                       |    7 +-
 drivers/net/wireless/iwlwifi/Kconfig                           |   10 +
 drivers/net/wireless/iwlwifi/dvm/mac80211.c                    |    4 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c                          |    6 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c                        |   17 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c                        |   18 +-
 drivers/net/wireless/iwlwifi/iwl-config.h                      |    6 +
 drivers/net/wireless/iwlwifi/iwl-csr.h                         |   12 +
 drivers/net/wireless/iwlwifi/iwl-debug.h                       |    2 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.c                    |    7 -
 drivers/net/wireless/iwlwifi/iwl-drv.c                         |   30 +-
 drivers/net/wireless/iwlwifi/iwl-drv.h                         |    2 +
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c                |    3 +
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h               |    2 +
 drivers/net/wireless/iwlwifi/iwl-fw-file.h                     |    2 +
 drivers/net/wireless/iwlwifi/iwl-fw.h                          |   24 +-
 drivers/net/wireless/iwlwifi/iwl-io.c                          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                   |    5 +
 drivers/net/wireless/iwlwifi/iwl-op-mode.h                     |    2 +
 drivers/net/wireless/iwlwifi/iwl-prph.h                        |    3 +
 drivers/net/wireless/iwlwifi/iwl-scd.h                         |  118 ++
 drivers/net/wireless/iwlwifi/iwl-trans.h                       |   63 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile                      |    2 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c                        |    6 +
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c                 |    2 +
 drivers/net/wireless/iwlwifi/mvm/constants.h                   |   13 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c                          |    4 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c                 |   10 +
 drivers/net/wireless/iwlwifi/mvm/debugfs.c                     |  116 ++
 drivers/net/wireless/iwlwifi/mvm/debugfs.h                     |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h                 |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h                   |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h                |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h                 |    5 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h                  |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                   |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                      |  144 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c                          |    9 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c                    |  126 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                    |  293 ++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h                         |  114 +-
 drivers/net/wireless/iwlwifi/mvm/nvm.c                         |    5 +-
 drivers/net/wireless/iwlwifi/mvm/offloading.c                  |    2 +
 drivers/net/wireless/iwlwifi/mvm/ops.c                         |   35 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                    |    2 +
 drivers/net/wireless/iwlwifi/mvm/power.c                       |  210 ++-
 drivers/net/wireless/iwlwifi/mvm/quota.c                       |   46 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c                          |  372 +++--
 drivers/net/wireless/iwlwifi/mvm/rs.h                          |   14 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c                          |   62 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c                        |  133 +-
 drivers/net/wireless/iwlwifi/mvm/sf.c                          |    6 +
 drivers/net/wireless/iwlwifi/mvm/sta.c                         |  122 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h                         |   24 +-
 drivers/net/wireless/iwlwifi/mvm/tdls.c                        |  149 ++
 drivers/net/wireless/iwlwifi/mvm/testmode.h                    |    2 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c                  |   71 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h                  |   16 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c                          |  322 +---
 drivers/net/wireless/iwlwifi/mvm/tx.c                          |   64 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c                       |   69 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c                        |    7 +
 drivers/net/wireless/iwlwifi/pcie/internal.h                   |   10 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c                         |    3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c                      |    5 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c                         |  145 +-
 drivers/net/wireless/libertas/cfg.c                            |    2 +
 drivers/net/wireless/mac80211_hwsim.c                          |    8 +-
 drivers/net/wireless/mwifiex/11n_rxreorder.c                   |   14 +
 drivers/net/wireless/mwifiex/Kconfig                           |    4 +-
 drivers/net/wireless/mwifiex/cfg80211.c                        |   18 +-
 drivers/net/wireless/mwifiex/cmdevt.c                          |   31 +-
 drivers/net/wireless/mwifiex/decl.h                            |    4 +-
 drivers/net/wireless/mwifiex/fw.h                              |   17 +-
 drivers/net/wireless/mwifiex/init.c                            |   24 +-
 drivers/net/wireless/mwifiex/main.c                            |  190 ++-
 drivers/net/wireless/mwifiex/main.h                            |   49 +-
 drivers/net/wireless/mwifiex/pcie.c                            |   54 +-
 drivers/net/wireless/mwifiex/pcie.h                            |    5 +-
 drivers/net/wireless/mwifiex/scan.c                            |  116 +-
 drivers/net/wireless/mwifiex/sdio.c                            |   69 +-
 drivers/net/wireless/mwifiex/sdio.h                            |  114 +-
 drivers/net/wireless/mwifiex/sta_cmd.c                         |    4 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c                     |    4 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c                       |   13 +-
 drivers/net/wireless/mwifiex/tdls.c                            |    4 +-
 drivers/net/wireless/mwifiex/usb.c                             |    2 +-
 drivers/net/wireless/mwifiex/util.c                            |    2 +-
 drivers/net/wireless/orinoco/orinoco_usb.c                     |   38 +-
 drivers/net/wireless/orinoco/scan.c                            |   14 +-
 drivers/net/wireless/p54/main.c                                |    3 +-
 drivers/net/wireless/ray_cs.h                                  |    5 +-
 drivers/net/wireless/rayctl.h                                  |    5 +-
 drivers/net/wireless/rndis_wlan.c                              |   14 +-
 drivers/net/wireless/rt2x00/rt2800.h                           |    6 +-
 drivers/net/wireless/rt2x00/rt2800lib.c                        |    6 +
 drivers/net/wireless/rtl818x/rtl8180/dev.c                     |   28 +-
 drivers/net/wireless/rtlwifi/Kconfig                           |   29 +-
 drivers/net/wireless/rtlwifi/Makefile                          |    2 +
 drivers/net/wireless/rtlwifi/base.c                            |  661 +++++---
 drivers/net/wireless/rtlwifi/base.h                            |   55 +-
 drivers/net/wireless/rtlwifi/btcoexist/halbt_precomp.h         |    6 +
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c       | 3849 +++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.h       |  185 +++
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.c       | 3170 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.h       |  184 +++
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c       |  550 ++++---
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.h       |   31 +-
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.c       | 2970 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.h       |  188 +++
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.c       | 3879 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.h       |  205 +++
 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c          |   50 +-
 drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h          |  120 +-
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.c               |   27 +-
 drivers/net/wireless/rtlwifi/btcoexist/rtl_btc.h               |    6 +-
 drivers/net/wireless/rtlwifi/cam.c                             |   61 +-
 drivers/net/wireless/rtlwifi/cam.h                             |   10 +-
 drivers/net/wireless/rtlwifi/core.c                            |  888 +++++++---
 drivers/net/wireless/rtlwifi/core.h                            |   11 +-
 drivers/net/wireless/rtlwifi/debug.c                           |   10 +-
 drivers/net/wireless/rtlwifi/debug.h                           |   11 +-
 drivers/net/wireless/rtlwifi/efuse.c                           |  228 +--
 drivers/net/wireless/rtlwifi/efuse.h                           |   17 +-
 drivers/net/wireless/rtlwifi/pci.c                             |  859 ++++++----
 drivers/net/wireless/rtlwifi/pci.h                             |   56 +-
 drivers/net/wireless/rtlwifi/ps.c                              |  283 ++--
 drivers/net/wireless/rtlwifi/ps.h                              |   71 +-
 drivers/net/wireless/rtlwifi/{rtl8723ae => }/pwrseqcmd.h       |    6 +-
 drivers/net/wireless/rtlwifi/rc.c                              |   97 +-
 drivers/net/wireless/rtlwifi/rc.h                              |    9 +-
 drivers/net/wireless/rtlwifi/regd.c                            |  108 +-
 drivers/net/wireless/rtlwifi/regd.h                            |   11 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/def.h                   |   66 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c                    |  881 +++++-----
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.h                    |   23 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.c                    |  259 ++-
 drivers/net/wireless/rtlwifi/rtl8188ee/fw.h                    |   29 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c                    | 1251 +++++++-------
 drivers/net/wireless/rtlwifi/rtl8188ee/led.c                   |   49 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/led.h                   |    4 -
 drivers/net/wireless/rtlwifi/rtl8188ee/phy.c                   | 2151 +++++++++++++-----------
 drivers/net/wireless/rtlwifi/rtl8188ee/phy.h                   |   49 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.c                |  100 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseq.h                |  415 +++--
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c             |  139 --
 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h             |   97 --
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h                   | 2936 ++++++++++++++++-----------------
 drivers/net/wireless/rtlwifi/rtl8188ee/rf.c                    |  282 ++--
 drivers/net/wireless/rtlwifi/rtl8188ee/rf.h                    |    7 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.c                    |   43 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/sw.h                    |    6 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/table.c                 |    6 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/table.h                 |   12 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c                   |  443 +++--
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.h                   |   83 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c              |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c              |  447 +++--
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h              |   40 +-
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c             |  815 +++-------
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h             |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h                   |   15 -
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h                    |   64 -
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c                    |   16 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.h                    |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c                   |    3 +
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.h                   |  107 --
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c                    |    5 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c                   |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/def.h                   |    3 -
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c                    |   17 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c                   |    3 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c                   |    3 +
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c                    |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c                   |    1 +
 drivers/net/wireless/rtlwifi/rtl8192de/fw.h                    |   12 -
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c                   |    8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c                   |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ee/Makefile                |   19 +
 drivers/net/wireless/rtlwifi/rtl8192ee/def.h                   |  101 ++
 drivers/net/wireless/rtlwifi/rtl8192ee/dm.c                    | 1263 +++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/dm.h                    |  267 +++
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.c                    |  906 +++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/fw.h                    |  208 +++
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c                    | 2569 +++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/hw.h                    |   62 +
 drivers/net/wireless/rtlwifi/rtl8192ee/led.c                   |  145 ++
 drivers/net/wireless/rtlwifi/rtl8192ee/led.h                   |   34 +
 drivers/net/wireless/rtlwifi/rtl8192ee/phy.c                   | 3219 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/phy.h                   |  153 ++
 drivers/net/wireless/rtlwifi/rtl8192ee/pwrseq.c                |  112 ++
 drivers/net/wireless/rtlwifi/rtl8192ee/pwrseq.h                |  340 ++++
 drivers/net/wireless/rtlwifi/rtl8192ee/reg.h                   | 2231 +++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/rf.c                    |  152 ++
 drivers/net/wireless/rtlwifi/rtl8192ee/rf.h                    |   36 +
 drivers/net/wireless/rtlwifi/rtl8192ee/sw.c                    |  399 +++++
 drivers/net/wireless/rtlwifi/rtl8192ee/sw.h                    |   33 +
 drivers/net/wireless/rtlwifi/rtl8192ee/table.c                 |  882 ++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/table.h                 |   45 +
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c                   | 1293 +++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8192ee/trx.h                   |  860 ++++++++++
 drivers/net/wireless/rtlwifi/rtl8192se/fw.h                    |    1 -
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c                   |    4 -
 drivers/net/wireless/rtlwifi/rtl8723ae/btc.h                   |    7 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/def.h                   |  197 ++-
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.c                    |  422 +++--
 drivers/net/wireless/rtlwifi/rtl8723ae/dm.h                    |   50 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.c                    |  255 ++-
 drivers/net/wireless/rtlwifi/rtl8723ae/fw.h                    |   54 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.c        |  414 +++--
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_bt_coexist.h        |   38 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.c               | 1234 +++++++-------
 drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h               |   66 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c                    | 1513 +++++++++--------
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.h                    |   66 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/led.c                   |   54 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/led.h                   |   13 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c                   |  884 +++++-----
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.h                   |   67 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.c                |   93 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseq.h                |  543 ++++---
 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.c             |  129 --
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h                   | 2718 ++++++++++++++++---------------
 drivers/net/wireless/rtlwifi/rtl8723ae/rf.c                    |  261 +--
 drivers/net/wireless/rtlwifi/rtl8723ae/rf.h                    |   18 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c                    |  222 +--
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.h                    |   12 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/table.c                 |    8 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/table.h                 |    8 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c                   |  460 ++++--
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.h                   |  325 ++--
 drivers/net/wireless/rtlwifi/rtl8723be/def.h                   |  178 +-
 drivers/net/wireless/rtlwifi/rtl8723be/dm.c                    |  243 +--
 drivers/net/wireless/rtlwifi/rtl8723be/dm.h                    |   30 +-
 drivers/net/wireless/rtlwifi/rtl8723be/fw.c                    |  194 ++-
 drivers/net/wireless/rtlwifi/rtl8723be/fw.h                    |  200 +--
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c                    | 1320 +++++++++------
 drivers/net/wireless/rtlwifi/rtl8723be/hw.h                    |    1 +
 drivers/net/wireless/rtlwifi/rtl8723be/led.c                   |    6 +-
 drivers/net/wireless/rtlwifi/rtl8723be/phy.c                   | 1783 +++++++++++++-------
 drivers/net/wireless/rtlwifi/rtl8723be/phy.h                   |  110 +-
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.c                |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseq.h                |  131 +-
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c             |  139 --
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.h             |   95 --
 drivers/net/wireless/rtlwifi/rtl8723be/reg.h                   | 1135 ++++++-------
 drivers/net/wireless/rtlwifi/rtl8723be/rf.c                    |  144 +-
 drivers/net/wireless/rtlwifi/rtl8723be/sw.c                    |   42 +-
 drivers/net/wireless/rtlwifi/rtl8723be/table.c                 | 1053 ++++++------
 drivers/net/wireless/rtlwifi/rtl8723be/table.h                 |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/trx.c                   |  314 ++--
 drivers/net/wireless/rtlwifi/rtl8723be/trx.h                   |   34 +-
 drivers/net/wireless/rtlwifi/rtl8723com/dm_common.c            |   14 +-
 drivers/net/wireless/rtlwifi/rtl8723com/fw_common.c            |   90 +-
 drivers/net/wireless/rtlwifi/rtl8723com/fw_common.h            |   59 +-
 drivers/net/wireless/rtlwifi/rtl8723com/phy_common.c           |   57 +-
 drivers/net/wireless/rtlwifi/rtl8821ae/Makefile                |   19 +
 drivers/net/wireless/rtlwifi/rtl8821ae/def.h                   |  450 ++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/dm.c                    | 3019 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/dm.h                    |  356 ++++
 drivers/net/wireless/rtlwifi/rtl8821ae/fw.c                    | 1857 +++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/fw.h                    |  351 ++++
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c                    | 4218 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/hw.h                    |   70 +
 drivers/net/wireless/rtlwifi/rtl8821ae/led.c                   |  237 +++
 drivers/net/wireless/rtlwifi/rtl8821ae/led.h                   |   37 +
 drivers/net/wireless/rtlwifi/rtl8821ae/phy.c                   | 4855 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/phy.h                   |  259 +++
 drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.c                |  182 +++
 drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h                |  738 +++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/reg.h                   | 2464 ++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/rf.c                    |  465 ++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/rf.h                    |   43 +
 drivers/net/wireless/rtlwifi/rtl8821ae/sw.c                    |  484 ++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/sw.h                    |   34 +
 drivers/net/wireless/rtlwifi/rtl8821ae/table.c                 | 4572 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/table.h                 |   60 +
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.c                   | 1236 ++++++++++++++
 drivers/net/wireless/rtlwifi/rtl8821ae/trx.h                   |  620 +++++++
 drivers/net/wireless/rtlwifi/stats.c                           |   50 +-
 drivers/net/wireless/rtlwifi/stats.h                           |    7 +-
 drivers/net/wireless/rtlwifi/usb.c                             |    4 +-
 drivers/net/wireless/rtlwifi/wifi.h                            |  253 ++-
 drivers/net/wireless/ti/wl1251/spi.c                           |    1 -
 drivers/net/wireless/ti/wlcore/debug.h                         |    2 +-
 drivers/net/wireless/ti/wlcore/spi.c                           |   20 +-
 drivers/nfc/st21nfca/i2c.c                                     |   34 +-
 drivers/nfc/st21nfca/st21nfca.c                                |   59 +-
 drivers/nfc/st21nfca/st21nfca.h                                |   21 -
 drivers/nfc/st21nfca/st21nfca_dep.c                            |   59 +-
 drivers/nfc/st21nfcb/i2c.c                                     |   67 +-
 drivers/nfc/st21nfcb/ndlc.c                                    |    6 +-
 drivers/nfc/st21nfcb/ndlc.h                                    |    4 +
 drivers/nfc/st21nfcb/st21nfcb.c                                |   27 +-
 drivers/nfc/st21nfcb/st21nfcb.h                                |    2 -
 drivers/nfc/trf7970a.c                                         | 1059 ++++++++++--
 drivers/of/of_mdio.c                                           |    9 +-
 drivers/s390/net/qeth_l3_main.c                                |    2 +-
 drivers/staging/Kconfig                                        |    2 -
 drivers/staging/Makefile                                       |    1 -
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c                  |    2 +-
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c              |    5 +-
 drivers/staging/wlan-ng/cfg80211.c                             |    1 +
 drivers/usb/gadget/function/f_ncm.c                            |    8 +
 drivers/usb/host/bcma-hcd.c                                    |    2 +-
 drivers/virtio/virtio_ring.c                                   |  186 +--
 include/linux/bcma/bcma.h                                      |    6 +-
 include/linux/bcma/bcma_driver_chipcommon.h                    |    8 +
 include/linux/bcma/bcma_regs.h                                 |    5 +
 include/linux/bcma/bcma_soc.h                                  |    1 +
 include/linux/bpf.h                                            |  136 ++
 include/linux/brcmphy.h                                        |  137 +-
 include/linux/com20020.h                                       |   29 +
 include/linux/cycx_x25.h                                       |  125 --
 include/linux/dynamic_queue_limits.h                           |   12 +-
 include/linux/etherdevice.h                                    |    1 +
 include/linux/ethtool.h                                        |    4 +
 include/linux/filter.h                                         |  196 ++-
 include/linux/fs_enet_pd.h                                     |    1 -
 include/linux/i82593.h                                         |  229 ---
 include/linux/ieee80211.h                                      |   73 +-
 include/linux/if_macvlan.h                                     |    1 +
 include/linux/igmp.h                                           |    1 +
 include/linux/mlx4/device.h                                    |   17 +-
 include/linux/mlx5/device.h                                    |  152 +-
 include/linux/mlx5/driver.h                                    |  118 +-
 include/linux/mlx5/mlx5_ifc.h                                  |  349 ++++
 include/linux/mlx5/qp.h                                        |    3 +-
 include/linux/netdevice.h                                      |  248 ++-
 include/linux/netfilter/ipset/ip_set.h                         |   60 +-
 include/linux/netfilter/ipset/ip_set_list.h                    |    1 +
 include/linux/netfilter_bridge.h                               |   50 +-
 include/linux/phonedev.h                                       |   25 -
 include/linux/phy.h                                            |   27 +
 include/linux/phy_fixed.h                                      |   31 +-
 include/linux/random.h                                         |    4 +-
 include/linux/rhashtable.h                                     |    2 +
 include/linux/rtnetlink.h                                      |   10 +
 include/linux/skbuff.h                                         |  343 +++-
 include/linux/syscalls.h                                       |    3 +-
 include/linux/tcp.h                                            |    2 +-
 include/linux/udp.h                                            |   16 +-
 include/net/addrconf.h                                         |    2 +-
 include/net/ah.h                                               |    3 -
 include/net/bluetooth/bluetooth.h                              |    5 +-
 include/net/bluetooth/hci.h                                    |    1 +
 include/net/bluetooth/hci_core.h                               |   23 +-
 include/net/bluetooth/l2cap.h                                  |   35 +-
 include/net/cfg80211.h                                         |   69 +-
 include/net/checksum.h                                         |    4 +-
 include/net/codel.h                                            |    2 +-
 include/net/dsa.h                                              |   95 +-
 include/net/flow_keys.h                                        |   16 +-
 include/net/gen_stats.h                                        |   15 +-
 include/net/geneve.h                                           |   97 ++
 include/net/gue.h                                              |   23 +
 include/net/if_inet6.h                                         |    1 -
 include/net/inet_connection_sock.h                             |    9 +
 include/net/inetpeer.h                                         |    1 -
 include/net/ip.h                                               |   29 +-
 include/net/ip6_checksum.h                                     |    8 +
 include/net/ip6_fib.h                                          |   20 +-
 include/net/ip_fib.h                                           |    5 +-
 include/net/ip_tunnels.h                                       |   38 +-
 include/net/ip_vs.h                                            |  223 +--
 include/net/ipv6.h                                             |    4 +-
 include/net/mac80211.h                                         |   34 +-
 include/net/mld.h                                              |    5 +-
 include/net/neighbour.h                                        |    2 +-
 include/net/netfilter/br_netfilter.h                           |    6 +
 include/net/netfilter/ipv4/nf_nat_masquerade.h                 |   14 +
 include/net/netfilter/ipv4/nf_reject.h                         |  119 +-
 include/net/netfilter/ipv6/nf_nat_masquerade.h                 |   10 +
 include/net/netfilter/ipv6/nf_reject.h                         |    2 +-
 include/net/netfilter/nf_nat.h                                 |   10 +-
 include/net/netfilter/nf_nat_l3proto.h                         |   75 +
 include/net/netfilter/nf_tables.h                              |    2 +
 include/net/netfilter/nft_masq.h                               |   16 +
 include/net/netfilter/nft_reject.h                             |    9 +-
 include/net/netns/ipv4.h                                       |    1 +
 include/net/netns/ipv6.h                                       |    2 +-
 include/net/netns/xfrm.h                                       |   14 +
 include/net/nfc/nci.h                                          |   16 +-
 include/net/nfc/nci_core.h                                     |    9 +-
 include/net/pkt_cls.h                                          |   18 +-
 include/net/pkt_sched.h                                        |    8 +-
 include/net/sch_generic.h                                      |  119 +-
 include/net/sctp/command.h                                     |    2 +-
 include/net/snmp.h                                             |    8 +-
 include/net/sock.h                                             |   16 +-
 include/net/tcp.h                                              |   85 +-
 include/net/udp.h                                              |   21 +-
 include/net/udp_tunnel.h                                       |   85 +-
 include/net/xfrm.h                                             |    1 +
 include/rxrpc/types.h                                          |   41 -
 include/uapi/asm-generic/unistd.h                              |    4 +-
 include/uapi/linux/Kbuild                                      |    1 +
 include/uapi/linux/bpf.h                                       |  155 ++
 include/uapi/linux/ethtool.h                                   |   29 +
 include/uapi/linux/fou.h                                       |   39 +
 include/uapi/linux/if_ether.h                                  |    1 +
 include/uapi/linux/if_link.h                                   |   24 +
 include/uapi/linux/if_tunnel.h                                 |   17 +
 include/uapi/linux/inet_diag.h                                 |   13 +-
 include/uapi/linux/ip_vs.h                                     |    3 +
 include/uapi/linux/netfilter/ipset/ip_set.h                    |   12 +
 include/uapi/linux/netfilter/nf_nat.h                          |    5 +
 include/uapi/linux/netfilter/nf_tables.h                       |   59 +
 include/uapi/linux/netfilter/nfnetlink_acct.h                  |    8 +
 include/uapi/linux/netfilter/xt_set.h                          |   10 +
 include/uapi/linux/netfilter_arp/arpt_mangle.h                 |    2 +-
 include/uapi/linux/nl80211.h                                   |  116 +-
 include/uapi/linux/openvswitch.h                               |   31 +-
 include/uapi/linux/wil6210_uapi.h                              |   87 +
 include/uapi/linux/xfrm.h                                      |    7 +
 kernel/bpf/Makefile                                            |    6 +-
 kernel/bpf/core.c                                              |  127 +-
 kernel/bpf/syscall.c                                           |  606 +++++++
 kernel/bpf/test_stub.c                                         |  116 ++
 kernel/bpf/verifier.c                                          | 1923 ++++++++++++++++++++++
 kernel/crash_dump.c                                            |    1 +
 kernel/seccomp.c                                               |    7 +-
 kernel/sys_ni.c                                                |    3 +
 lib/Kconfig.debug                                              |    3 +-
 lib/random32.c                                                 |   39 +-
 lib/rhashtable.c                                               |   12 +-
 lib/test_bpf.c                                                 |   63 +-
 net/8021q/vlan_dev.c                                           |    3 +-
 net/Kconfig                                                    |    7 +-
 net/atm/clip.c                                                 |    6 +-
 net/atm/common.c                                               |    2 +-
 net/atm/mpc.c                                                  |    2 +-
 net/bluetooth/6lowpan.c                                        |  229 ++-
 net/bluetooth/af_bluetooth.c                                   |    3 +
 net/bluetooth/amp.c                                            |   13 +-
 net/bluetooth/hci_conn.c                                       |   92 +-
 net/bluetooth/hci_core.c                                       |  122 +-
 net/bluetooth/hci_event.c                                      |   44 +-
 net/bluetooth/hidp/core.c                                      |   10 +-
 net/bluetooth/l2cap_core.c                                     |  406 +++--
 net/bluetooth/l2cap_sock.c                                     |   23 +-
 net/bluetooth/lib.c                                            |   14 +-
 net/bluetooth/mgmt.c                                           |  161 +-
 net/bluetooth/smp.c                                            |  903 +++++++----
 net/bluetooth/smp.h                                            |   20 +-
 net/bridge/Makefile                                            |    4 +-
 net/bridge/br.c                                                |   14 +-
 net/bridge/br_device.c                                         |   12 +-
 net/bridge/br_forward.c                                        |    2 +
 net/bridge/br_if.c                                             |   20 +-
 net/bridge/br_input.c                                          |    1 +
 net/bridge/br_multicast.c                                      |    2 +-
 net/bridge/br_netfilter.c                                      |  132 +-
 net/bridge/br_netlink.c                                        |  116 +-
 net/bridge/br_nf_core.c                                        |   96 ++
 net/bridge/br_private.h                                        |   40 +-
 net/bridge/br_stp.c                                            |   15 +-
 net/bridge/br_stp_if.c                                         |    4 +-
 net/bridge/br_stp_timer.c                                      |    4 +-
 net/bridge/br_sysfs_br.c                                       |   21 +-
 net/bridge/br_vlan.c                                           |  147 +-
 net/bridge/netfilter/ebtables.c                                |   15 +
 net/bridge/netfilter/nf_tables_bridge.c                        |    2 +
 net/bridge/netfilter/nft_reject_bridge.c                       |   95 +-
 net/core/dev.c                                                 |  459 +++---
 net/core/dev_ioctl.c                                           |    7 +-
 net/core/ethtool.c                                             |   82 +
 net/core/filter.c                                              |   45 +-
 net/core/flow_dissector.c                                      |  115 +-
 net/core/gen_estimator.c                                       |   29 +-
 net/core/gen_stats.c                                           |  112 +-
 net/core/net_namespace.c                                       |    2 +-
 net/core/netpoll.c                                             |    7 +-
 net/core/pktgen.c                                              |   76 +-
 net/core/rtnetlink.c                                           |   66 +-
 net/core/secure_seq.c                                          |    6 +-
 net/core/skbuff.c                                              |  395 +++--
 net/core/sock.c                                                |  110 +-
 net/core/timestamping.c                                        |   43 +-
 net/core/utils.c                                               |   12 +-
 net/dccp/ccid.c                                                |    2 +-
 net/dccp/ipv6.c                                                |    2 +-
 net/dccp/proto.c                                               |    2 +-
 net/decnet/af_decnet.c                                         |    3 +-
 net/decnet/dn_dev.c                                            |    3 +-
 net/decnet/dn_timer.c                                          |    3 +-
 net/dsa/Kconfig                                                |    3 +
 net/dsa/Makefile                                               |    1 +
 net/dsa/dsa.c                                                  |  186 ++-
 net/dsa/dsa_priv.h                                             |   29 +-
 net/dsa/slave.c                                                |  304 +++-
 net/dsa/tag_brcm.c                                             |  171 ++
 net/dsa/tag_dsa.c                                              |    9 +-
 net/dsa/tag_edsa.c                                             |    9 +-
 net/dsa/tag_trailer.c                                          |    9 +-
 net/ethernet/eth.c                                             |   34 +-
 net/ieee802154/6lowpan_rtnl.c                                  |  127 +-
 net/ieee802154/reassembly.c                                    |    4 +-
 net/ipv4/Kconfig                                               |   51 +-
 net/ipv4/Makefile                                              |    3 +
 net/ipv4/af_inet.c                                             |   47 +-
 net/ipv4/ah4.c                                                 |    2 -
 net/ipv4/arp.c                                                 |    6 +-
 net/ipv4/cipso_ipv4.c                                          |    2 +-
 net/ipv4/fib_frontend.c                                        |   14 +-
 net/ipv4/fib_semantics.c                                       |    8 +-
 net/ipv4/fou.c                                                 |  514 ++++++
 net/ipv4/geneve.c                                              |  373 +++++
 net/ipv4/gre_demux.c                                           |    9 +-
 net/ipv4/gre_offload.c                                         |   55 +-
 net/ipv4/icmp.c                                                |   64 +-
 net/ipv4/igmp.c                                                |   35 +-
 net/ipv4/inet_hashtables.c                                     |    2 +-
 net/ipv4/inetpeer.c                                            |   21 -
 net/ipv4/ip_fragment.c                                         |    4 +-
 net/ipv4/ip_gre.c                                              |   94 +-
 net/ipv4/ip_options.c                                          |    6 +-
 net/ipv4/ip_output.c                                           |   10 +-
 net/ipv4/ip_sockglue.c                                         |   19 +-
 net/ipv4/ip_tunnel.c                                           |  106 +-
 net/ipv4/ip_vti.c                                              |    2 +-
 net/ipv4/ipconfig.c                                            |    3 +-
 net/ipv4/ipip.c                                                |   82 +-
 net/ipv4/netfilter/Kconfig                                     |   39 +-
 net/ipv4/netfilter/Makefile                                    |    5 +
 net/ipv4/netfilter/ipt_CLUSTERIP.c                             |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c                            |  108 +-
 net/ipv4/netfilter/ipt_REJECT.c                                |    2 +-
 net/ipv4/netfilter/iptable_nat.c                               |  233 +--
 net/ipv4/netfilter/nf_defrag_ipv4.c                            |    2 +-
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c                       |  199 +++
 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c                    |  153 ++
 net/ipv4/netfilter/nf_reject_ipv4.c                            |  127 ++
 net/ipv4/netfilter/nft_chain_nat_ipv4.c                        |  157 +-
 net/ipv4/netfilter/nft_masq_ipv4.c                             |   77 +
 net/ipv4/netfilter/nft_reject_ipv4.c                           |    1 -
 net/ipv4/ping.c                                                |    2 +-
 net/ipv4/protocol.c                                            |    1 +
 net/ipv4/route.c                                               |   14 +-
 net/ipv4/syncookies.c                                          |    2 +-
 net/ipv4/sysctl_net_ipv4.c                                     |   40 +-
 net/ipv4/tcp.c                                                 |   36 +-
 net/ipv4/tcp_bic.c                                             |   11 +-
 net/ipv4/tcp_cong.c                                            |   55 +-
 net/ipv4/tcp_cubic.c                                           |   18 +-
 net/ipv4/tcp_dctcp.c                                           |  344 ++++
 net/ipv4/tcp_diag.c                                            |    5 +-
 net/ipv4/tcp_fastopen.c                                        |    2 +-
 net/ipv4/tcp_highspeed.c                                       |  145 +-
 net/ipv4/tcp_htcp.c                                            |    6 +-
 net/ipv4/tcp_hybla.c                                           |    1 -
 net/ipv4/tcp_illinois.c                                        |    3 +-
 net/ipv4/tcp_input.c                                           |  285 ++--
 net/ipv4/tcp_ipv4.c                                            |   68 +-
 net/ipv4/tcp_minisocks.c                                       |   13 +-
 net/ipv4/tcp_offload.c                                         |   72 +-
 net/ipv4/tcp_output.c                                          |  124 +-
 net/ipv4/tcp_probe.c                                           |    6 +-
 net/ipv4/tcp_scalable.c                                        |    2 +-
 net/ipv4/tcp_timer.c                                           |   52 +-
 net/ipv4/tcp_vegas.c                                           |    3 -
 net/ipv4/tcp_veno.c                                            |    1 -
 net/ipv4/tcp_westwood.c                                        |   35 +-
 net/ipv4/tcp_yeah.c                                            |    9 +-
 net/ipv4/udp.c                                                 |   13 +-
 net/ipv4/udp_offload.c                                         |  171 +-
 net/ipv4/udp_tunnel.c                                          |  138 +-
 net/ipv6/Makefile                                              |    4 +
 net/ipv6/addrconf.c                                            |   17 +-
 net/ipv6/af_inet6.c                                            |   20 +-
 net/ipv6/ah6.c                                                 |   23 +-
 net/ipv6/anycast.c                                             |  108 +-
 net/ipv6/datagram.c                                            |   23 +-
 net/ipv6/esp6.c                                                |   15 +-
 net/ipv6/exthdrs.c                                             |    2 +-
 net/ipv6/icmp.c                                                |   34 +-
 net/ipv6/inet6_connection_sock.c                               |    6 +-
 net/ipv6/inet6_hashtables.c                                    |    7 +-
 net/ipv6/ip6_fib.c                                             |  142 +-
 net/ipv6/ip6_flowlabel.c                                       |   19 +-
 net/ipv6/ip6_gre.c                                             |   14 +-
 net/ipv6/ip6_icmp.c                                            |    2 +-
 net/ipv6/ip6_input.c                                           |    6 +-
 net/ipv6/ip6_offload.c                                         |   34 +-
 net/ipv6/ip6_output.c                                          |   27 +-
 net/ipv6/ip6_tunnel.c                                          |   34 +-
 net/ipv6/ip6_udp_tunnel.c                                      |  107 ++
 net/ipv6/ip6_vti.c                                             |    2 +-
 net/ipv6/ip6mr.c                                               |    4 +-
 net/ipv6/ipcomp6.c                                             |    6 +-
 net/ipv6/ipv6_sockglue.c                                       |   26 +-
 net/ipv6/mcast.c                                               |  302 ++--
 net/ipv6/mip6.c                                                |   10 +-
 net/ipv6/ndisc.c                                               |   17 +-
 net/ipv6/netfilter/Kconfig                                     |   43 +-
 net/ipv6/netfilter/Makefile                                    |    5 +
 net/ipv6/netfilter/ip6t_MASQUERADE.c                           |   76 +-
 net/ipv6/netfilter/ip6table_nat.c                              |  233 +--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c                      |    2 +-
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c                       |  199 +++
 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c                    |  120 ++
 net/ipv6/netfilter/nf_reject_ipv6.c                            |  163 ++
 net/ipv6/netfilter/nft_chain_nat_ipv6.c                        |  165 +-
 net/ipv6/netfilter/nft_masq_ipv6.c                             |   77 +
 net/ipv6/output_core.c                                         |    2 +-
 net/ipv6/proc.c                                                |    2 +-
 net/ipv6/protocol.c                                            |    1 +
 net/ipv6/raw.c                                                 |    8 +-
 net/ipv6/reassembly.c                                          |   12 +-
 net/ipv6/route.c                                               |   22 +-
 net/ipv6/sit.c                                                 |  123 +-
 net/ipv6/syncookies.c                                          |    4 +-
 net/ipv6/sysctl_net_ipv6.c                                     |   10 +
 net/ipv6/tcp_ipv6.c                                            |   32 +-
 net/ipv6/tcpv6_offload.c                                       |   69 +-
 net/ipv6/tunnel6.c                                             |    4 +-
 net/ipv6/udp.c                                                 |   26 +-
 net/ipv6/udp_offload.c                                         |   92 +-
 net/ipv6/xfrm6_input.c                                         |    6 +-
 net/ipv6/xfrm6_output.c                                        |    1 -
 net/ipv6/xfrm6_policy.c                                        |   22 +-
 net/ipv6/xfrm6_state.c                                         |   14 +-
 net/ipv6/xfrm6_tunnel.c                                        |    4 +-
 net/irda/irlan/irlan_common.c                                  |    4 +-
 net/iucv/iucv.c                                                |    9 +-
 net/l2tp/l2tp_core.c                                           |   24 +-
 net/mac80211/agg-rx.c                                          |    5 +-
 net/mac80211/cfg.c                                             |  114 +-
 net/mac80211/chan.c                                            |  191 ++-
 net/mac80211/debugfs.c                                         |    6 +-
 net/mac80211/debugfs_netdev.c                                  |    4 +-
 net/mac80211/debugfs_sta.c                                     |    4 +-
 net/mac80211/driver-ops.h                                      |    2 +-
 net/mac80211/ibss.c                                            |    3 +-
 net/mac80211/ieee80211_i.h                                     |    9 +-
 net/mac80211/iface.c                                           |   15 +-
 net/mac80211/key.c                                             |   15 +-
 net/mac80211/main.c                                            |    1 +
 net/mac80211/mesh_pathtbl.c                                    |    4 +-
 net/mac80211/mesh_plink.c                                      |   14 +-
 net/mac80211/mlme.c                                            |  162 +-
 net/mac80211/rc80211_minstrel.c                                |   98 +-
 net/mac80211/rc80211_minstrel.h                                |   43 +-
 net/mac80211/rc80211_minstrel_debugfs.c                        |   19 +-
 net/mac80211/rc80211_minstrel_ht.c                             |  303 ++--
 net/mac80211/rc80211_minstrel_ht.h                             |   41 +-
 net/mac80211/rc80211_minstrel_ht_debugfs.c                     |   10 +-
 net/mac80211/rx.c                                              |   13 +-
 net/mac80211/scan.c                                            |    3 +-
 net/mac80211/sta_info.c                                        |    5 +-
 net/mac80211/sta_info.h                                        |    9 +-
 net/mac80211/status.c                                          |   22 +-
 net/mac80211/tdls.c                                            |    7 +-
 net/mac80211/trace.h                                           |    4 +-
 net/mac80211/tx.c                                              |   32 +-
 net/mac80211/util.c                                            |   26 +
 net/mac80211/wme.c                                             |    5 +-
 net/mac80211/wpa.c                                             |    7 +-
 net/mac802154/rx.c                                             |    5 +-
 net/mac802154/tx.c                                             |   15 +-
 net/mac802154/wpan.c                                           |   10 +-
 net/mpls/mpls_gso.c                                            |    7 -
 net/netfilter/Kconfig                                          |    9 +
 net/netfilter/Makefile                                         |    1 +
 net/netfilter/ipset/Kconfig                                    |    9 +
 net/netfilter/ipset/Makefile                                   |    1 +
 net/netfilter/ipset/ip_set_bitmap_gen.h                        |    4 +
 net/netfilter/ipset/ip_set_bitmap_ip.c                         |   15 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c                      |   15 +-
 net/netfilter/ipset/ip_set_bitmap_port.c                       |   15 +-
 net/netfilter/ipset/ip_set_core.c                              |   53 +-
 net/netfilter/ipset/ip_set_hash_gen.h                          |   30 +-
 net/netfilter/ipset/ip_set_hash_ip.c                           |   22 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c                       |   14 +-
 net/netfilter/ipset/ip_set_hash_ipport.c                       |   22 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c                     |   22 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c                    |   14 +-
 net/netfilter/ipset/ip_set_hash_mac.c                          |  173 ++
 net/netfilter/ipset/ip_set_hash_net.c                          |   16 +-
 net/netfilter/ipset/ip_set_hash_netiface.c                     |   20 +-
 net/netfilter/ipset/ip_set_hash_netnet.c                       |   29 +-
 net/netfilter/ipset/ip_set_hash_netport.c                      |   16 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c                   |   22 +-
 net/netfilter/ipset/ip_set_list_set.c                          |   23 +-
 net/netfilter/ipvs/Kconfig                                     |   10 +
 net/netfilter/ipvs/Makefile                                    |    1 +
 net/netfilter/ipvs/ip_vs_conn.c                                |   74 +-
 net/netfilter/ipvs/ip_vs_core.c                                |   15 +-
 net/netfilter/ipvs/ip_vs_ctl.c                                 |  223 ++-
 net/netfilter/ipvs/ip_vs_dh.c                                  |    2 +-
 net/netfilter/ipvs/ip_vs_fo.c                                  |   79 +
 net/netfilter/ipvs/ip_vs_ftp.c                                 |    6 +-
 net/netfilter/ipvs/ip_vs_lblc.c                                |   12 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                               |   12 +-
 net/netfilter/ipvs/ip_vs_lc.c                                  |    2 +-
 net/netfilter/ipvs/ip_vs_nq.c                                  |    3 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c                          |    2 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c                           |    2 +-
 net/netfilter/ipvs/ip_vs_rr.c                                  |    2 +-
 net/netfilter/ipvs/ip_vs_sed.c                                 |    3 +-
 net/netfilter/ipvs/ip_vs_sh.c                                  |    8 +-
 net/netfilter/ipvs/ip_vs_sync.c                                |   13 +-
 net/netfilter/ipvs/ip_vs_wlc.c                                 |    3 +-
 net/netfilter/ipvs/ip_vs_wrr.c                                 |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                                |  388 +++--
 net/netfilter/nf_conntrack_core.c                              |    4 +-
 net/netfilter/nf_conntrack_expect.c                            |    3 +-
 net/netfilter/nf_conntrack_netlink.c                           |    2 +-
 net/netfilter/nf_conntrack_proto_generic.c                     |   26 +-
 net/netfilter/nf_conntrack_standalone.c                        |    2 +-
 net/netfilter/nf_log_common.c                                  |    2 +-
 net/netfilter/nf_nat_core.c                                    |    5 +-
 net/netfilter/nf_queue.c                                       |    4 +-
 net/netfilter/nf_tables_api.c                                  |  601 ++++---
 net/netfilter/nfnetlink.c                                      |    6 +-
 net/netfilter/nfnetlink_acct.c                                 |   54 +
 net/netfilter/nfnetlink_log.c                                  |    8 +-
 net/netfilter/nfnetlink_queue_core.c                           |   12 +-
 net/netfilter/nft_compat.c                                     |  116 +-
 net/netfilter/nft_masq.c                                       |   59 +
 net/netfilter/nft_meta.c                                       |   45 +
 net/netfilter/nft_nat.c                                        |   16 +
 net/netfilter/nft_reject.c                                     |   37 +
 net/netfilter/nft_reject_inet.c                                |   94 +-
 net/netfilter/x_tables.c                                       |   30 +-
 net/netfilter/xt_HMARK.c                                       |    2 +-
 net/netfilter/xt_RATEEST.c                                     |    2 +-
 net/netfilter/xt_cluster.c                                     |    3 +-
 net/netfilter/xt_connbytes.c                                   |    2 +-
 net/netfilter/xt_hashlimit.c                                   |    4 +-
 net/netfilter/xt_physdev.c                                     |    3 +
 net/netfilter/xt_set.c                                         |  191 ++-
 net/netfilter/xt_string.c                                      |    1 -
 net/netlabel/netlabel_user.c                                   |    6 +-
 net/nfc/digital_dep.c                                          |  101 ++
 net/nfc/nci/core.c                                             |   21 +-
 net/nfc/nci/data.c                                             |    7 +-
 net/nfc/nci/ntf.c                                              |   40 +-
 net/openvswitch/Kconfig                                        |   11 +
 net/openvswitch/Makefile                                       |    4 +
 net/openvswitch/actions.c                                      |  261 ++-
 net/openvswitch/datapath.c                                     |   96 +-
 net/openvswitch/datapath.h                                     |   23 +-
 net/openvswitch/flow.c                                         |  123 +-
 net/openvswitch/flow.h                                         |   54 +-
 net/openvswitch/flow_netlink.c                                 |  292 +++-
 net/openvswitch/flow_netlink.h                                 |    4 +-
 net/openvswitch/vport-geneve.c                                 |  235 +++
 net/openvswitch/vport-gre.c                                    |   33 +-
 net/openvswitch/vport-vxlan.c                                  |   27 +-
 net/openvswitch/vport.c                                        |   45 +-
 net/openvswitch/vport.h                                        |   14 +-
 net/packet/af_packet.c                                         |   12 +-
 net/phonet/pn_dev.c                                            |    6 +-
 net/rds/send.c                                                 |   11 +-
 net/rds/tcp_connect.c                                          |    5 +-
 net/rds/threads.c                                              |    3 +-
 net/rose/rose_link.c                                           |    3 +-
 net/rxrpc/ar-error.c                                           |   14 +-
 net/rxrpc/ar-input.c                                           |    9 +-
 net/sched/act_api.c                                            |    9 +-
 net/sched/act_police.c                                         |    6 +-
 net/sched/cls_api.c                                            |   33 +-
 net/sched/cls_basic.c                                          |   89 +-
 net/sched/cls_bpf.c                                            |  102 +-
 net/sched/cls_cgroup.c                                         |   79 +-
 net/sched/cls_flow.c                                           |  151 +-
 net/sched/cls_fw.c                                             |  120 +-
 net/sched/cls_route.c                                          |  241 +--
 net/sched/cls_rsvp.h                                           |  208 ++-
 net/sched/cls_tcindex.c                                        |  273 ++--
 net/sched/cls_u32.c                                            |  407 +++--
 net/sched/em_canid.c                                           |    4 +-
 net/sched/em_ipset.c                                           |    7 +-
 net/sched/em_meta.c                                            |    4 +-
 net/sched/em_nbyte.c                                           |    2 +-
 net/sched/em_text.c                                            |    4 +-
 net/sched/ematch.c                                             |   15 +-
 net/sched/sch_api.c                                            |   65 +-
 net/sched/sch_atm.c                                            |   28 +-
 net/sched/sch_cbq.c                                            |   35 +-
 net/sched/sch_choke.c                                          |   29 +-
 net/sched/sch_codel.c                                          |    2 +-
 net/sched/sch_drr.c                                            |   27 +-
 net/sched/sch_dsmark.c                                         |   11 +-
 net/sched/sch_fifo.c                                           |    2 +-
 net/sched/sch_fq.c                                             |   14 +-
 net/sched/sch_fq_codel.c                                       |   24 +-
 net/sched/sch_generic.c                                        |   82 +-
 net/sched/sch_gred.c                                           |    4 +-
 net/sched/sch_hfsc.c                                           |   32 +-
 net/sched/sch_hhf.c                                            |    8 +-
 net/sched/sch_htb.c                                            |   48 +-
 net/sched/sch_ingress.c                                        |   10 +-
 net/sched/sch_mq.c                                             |    6 +-
 net/sched/sch_mqprio.c                                         |   20 +-
 net/sched/sch_multiq.c                                         |   17 +-
 net/sched/sch_netem.c                                          |   15 +-
 net/sched/sch_pie.c                                            |    2 +-
 net/sched/sch_prio.c                                           |   20 +-
 net/sched/sch_qfq.c                                            |   25 +-
 net/sched/sch_red.c                                            |    8 +-
 net/sched/sch_sfb.c                                            |   25 +-
 net/sched/sch_sfq.c                                            |   35 +-
 net/sched/sch_tbf.c                                            |   17 +-
 net/sched/sch_teql.c                                           |   20 +-
 net/sctp/input.c                                               |    8 +-
 net/sctp/protocol.c                                            |    2 +-
 net/sctp/sm_statefuns.c                                        |   19 +-
 net/socket.c                                                   |    7 +-
 net/tipc/Makefile                                              |    2 +-
 net/tipc/bcast.c                                               |   20 +-
 net/tipc/bcast.h                                               |    2 +-
 net/tipc/config.c                                              |    4 +-
 net/tipc/core.c                                                |    9 +-
 net/tipc/core.h                                                |    6 +-
 net/tipc/link.c                                                |  120 +-
 net/tipc/link.h                                                |    7 +-
 net/tipc/msg.c                                                 |   38 +-
 net/tipc/msg.h                                                 |    5 +
 net/tipc/name_distr.c                                          |  140 +-
 net/tipc/name_distr.h                                          |    1 +
 net/tipc/name_table.c                                          |    9 +-
 net/tipc/net.c                                                 |    3 +-
 net/tipc/node.c                                                |   95 ++
 net/tipc/node.h                                                |    8 +-
 net/tipc/port.c                                                |  514 ------
 net/tipc/port.h                                                |  190 ---
 net/tipc/ref.c                                                 |  266 ---
 net/tipc/ref.h                                                 |   48 -
 net/tipc/socket.c                                              |  884 ++++++++--
 net/tipc/socket.h                                              |   55 +-
 net/tipc/subscr.c                                              |    1 -
 net/tipc/sysctl.c                                              |    7 +
 net/unix/garbage.c                                             |    2 +-
 net/wimax/id-table.c                                           |    2 +-
 net/wimax/op-msg.c                                             |    9 +-
 net/wimax/op-reset.c                                           |    3 +-
 net/wimax/op-rfkill.c                                          |    3 +-
 net/wimax/op-state-get.c                                       |    3 +-
 net/wimax/stack.c                                              |    7 +-
 net/wimax/wimax-internal.h                                     |    6 +
 net/wireless/chan.c                                            |    1 +
 net/wireless/core.c                                            |   16 +-
 net/wireless/ibss.c                                            |    4 +-
 net/wireless/mlme.c                                            |    8 +-
 net/wireless/nl80211.c                                         |  249 ++-
 net/wireless/nl80211.h                                         |    3 +-
 net/wireless/rdev-ops.h                                        |   31 +
 net/wireless/reg.c                                             |   82 +-
 net/wireless/scan.c                                            |   22 +-
 net/wireless/sme.c                                             |    6 +-
 net/wireless/trace.h                                           |   45 +
 net/wireless/util.c                                            |    3 +-
 net/wireless/wext-compat.c                                     |    2 +
 net/wireless/wext-sme.c                                        |    2 +-
 net/xfrm/xfrm_hash.h                                           |   76 +-
 net/xfrm/xfrm_output.c                                         |    6 +-
 net/xfrm/xfrm_policy.c                                         |  144 +-
 net/xfrm/xfrm_state.c                                          |   13 +-
 net/xfrm/xfrm_user.c                                           |   83 +-
 samples/bpf/Makefile                                           |   12 +
 samples/bpf/libbpf.c                                           |   94 ++
 samples/bpf/libbpf.h                                           |  172 ++
 samples/bpf/test_verifier.c                                    |  678 ++++++++
 1399 files changed, 153111 insertions(+), 37907 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/bcma.txt
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-mdio-unimac.txt
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-sf2.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/m_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/rcar_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/emac_rockchip.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell-pxa168.txt
 create mode 100644 Documentation/devicetree/bindings/net/meson-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/qca-qca7000-spi.txt
 create mode 100644 Documentation/networking/dctcp.txt
 create mode 100644 Documentation/networking/timestamping/txtimestamp.c
 create mode 100644 drivers/bcma/driver_chipcommon_b.c
 create mode 100644 drivers/net/can/m_can/Kconfig
 create mode 100644 drivers/net/can/m_can/Makefile
 create mode 100644 drivers/net/can/m_can/m_can.c
 create mode 100644 drivers/net/dsa/bcm_sf2.c
 create mode 100644 drivers/net/dsa/bcm_sf2.h
 create mode 100644 drivers/net/dsa/bcm_sf2_regs.h
 create mode 100644 drivers/net/dsa/mv88e6171.c
 create mode 100644 drivers/net/ethernet/agere/Kconfig
 create mode 100644 drivers/net/ethernet/agere/Makefile
 create mode 100644 drivers/net/ethernet/agere/et131x.c
 create mode 100644 drivers/net/ethernet/agere/et131x.h
 create mode 100644 drivers/net/ethernet/arc/emac_arc.c
 create mode 100644 drivers/net/ethernet/arc/emac_rockchip.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/Makefile
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k.h
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_common.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_common.h
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_dcbnl.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_iov.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_main.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_mbx.h
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_pci.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_pf.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_pf.h
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_ptp.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_tlv.h
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_type.h
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_vf.c
 create mode 100644 drivers/net/ethernet/intel/fm10k/fm10k_vf.h
 create mode 100644 drivers/net/ethernet/qualcomm/Kconfig
 create mode 100644 drivers/net/ethernet/qualcomm/Makefile
 create mode 100644 drivers/net/ethernet/qualcomm/qca_7k.c
 create mode 100644 drivers/net/ethernet/qualcomm/qca_7k.h
 create mode 100644 drivers/net/ethernet/qualcomm/qca_debug.c
 create mode 100644 drivers/net/ethernet/qualcomm/qca_debug.h
 create mode 100644 drivers/net/ethernet/qualcomm/qca_framing.c
 create mode 100644 drivers/net/ethernet/qualcomm/qca_framing.h
 create mode 100644 drivers/net/ethernet/qualcomm/qca_spi.c
 create mode 100644 drivers/net/ethernet/qualcomm/qca_spi.h
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c
 create mode 100644 drivers/net/phy/mdio-bcm-unimac.c
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.c
 create mode 100644 drivers/net/wireless/ath/ath10k/spectral.h
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode.c
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode.h
 create mode 100644 drivers/net/wireless/ath/ath10k/testmode_i.h
 delete mode 100644 drivers/net/wireless/ath/ath5k/ahb.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.c
 create mode 100644 drivers/net/wireless/ath/ath9k/dynack.h
 create mode 100644 drivers/net/wireless/ath/spectral_common.h
 create mode 100644 drivers/net/wireless/ath/trace.c
 create mode 100644 drivers/net/wireless/ath/trace.h
 create mode 100644 drivers/net/wireless/ath/wil6210/ethtool.c
 create mode 100644 drivers/net/wireless/ath/wil6210/fw.c
 create mode 100644 drivers/net/wireless/ath/wil6210/fw.h
 create mode 100644 drivers/net/wireless/ath/wil6210/fw_inc.c
 create mode 100644 drivers/net/wireless/ath/wil6210/ioctl.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform.h
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform_msm.c
 create mode 100644 drivers/net/wireless/ath/wil6210/wil_platform_msm.h
 create mode 100644 drivers/net/wireless/b43/ppr.c
 create mode 100644 drivers/net/wireless/b43/ppr.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-scd.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tdls.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b1ant.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a1ant.h
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.c
 create mode 100644 drivers/net/wireless/rtlwifi/btcoexist/halbtc8821a2ant.h
 rename drivers/net/wireless/rtlwifi/{rtl8723ae => }/pwrseqcmd.h (92%)
 delete mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c
 delete mode 100644 drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/pwrseq.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/pwrseq.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8192ee/trx.h
 delete mode 100644 drivers/net/wireless/rtlwifi/rtl8723ae/pwrseqcmd.c
 delete mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c
 delete mode 100644 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/Makefile
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/def.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/dm.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/dm.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/fw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/fw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/hw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/hw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/led.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/led.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/phy.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/phy.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/reg.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/rf.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/rf.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/sw.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/sw.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/table.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/table.h
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/trx.c
 create mode 100644 drivers/net/wireless/rtlwifi/rtl8821ae/trx.h
 create mode 100644 include/linux/bpf.h
 delete mode 100644 include/linux/cycx_x25.h
 delete mode 100644 include/linux/i82593.h
 create mode 100644 include/linux/mlx5/mlx5_ifc.h
 delete mode 100644 include/linux/phonedev.h
 create mode 100644 include/net/geneve.h
 create mode 100644 include/net/gue.h
 create mode 100644 include/net/netfilter/br_netfilter.h
 create mode 100644 include/net/netfilter/ipv4/nf_nat_masquerade.h
 create mode 100644 include/net/netfilter/ipv6/nf_nat_masquerade.h
 create mode 100644 include/net/netfilter/nft_masq.h
 delete mode 100644 include/rxrpc/types.h
 create mode 100644 include/uapi/linux/bpf.h
 create mode 100644 include/uapi/linux/fou.h
 create mode 100644 include/uapi/linux/wil6210_uapi.h
 create mode 100644 kernel/bpf/syscall.c
 create mode 100644 kernel/bpf/test_stub.c
 create mode 100644 kernel/bpf/verifier.c
 create mode 100644 net/bridge/br_nf_core.c
 create mode 100644 net/dsa/tag_brcm.c
 create mode 100644 net/ipv4/fou.c
 create mode 100644 net/ipv4/geneve.c
 create mode 100644 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
 create mode 100644 net/ipv4/netfilter/nf_reject_ipv4.c
 create mode 100644 net/ipv4/netfilter/nft_masq_ipv4.c
 create mode 100644 net/ipv4/tcp_dctcp.c
 create mode 100644 net/ipv6/ip6_udp_tunnel.c
 create mode 100644 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
 create mode 100644 net/ipv6/netfilter/nf_reject_ipv6.c
 create mode 100644 net/ipv6/netfilter/nft_masq_ipv6.c
 create mode 100644 net/netfilter/ipset/ip_set_hash_mac.c
 create mode 100644 net/netfilter/ipvs/ip_vs_fo.c
 create mode 100644 net/netfilter/nft_masq.c
 create mode 100644 net/openvswitch/vport-geneve.c
 delete mode 100644 net/tipc/port.c
 delete mode 100644 net/tipc/port.h
 delete mode 100644 net/tipc/ref.c
 delete mode 100644 net/tipc/ref.h
 create mode 100644 samples/bpf/Makefile
 create mode 100644 samples/bpf/libbpf.c
 create mode 100644 samples/bpf/libbpf.h
 create mode 100644 samples/bpf/test_verifier.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
