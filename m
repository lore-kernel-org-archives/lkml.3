Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab3IEUiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:38:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42805 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3IEUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:37:28 -0400
Date: Thu, 05 Sep 2013 16:37:25 -0400 (EDT)
Message-Id: <20130905.163725.106795517693348522.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 13:37:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r85KcNHe000628


There are three textual conflicts:

1) Overlapping changes with Greg KH's device tree, wrt. attributes.
   Greg's tree modifies net/core/net-sysfs.c to use "struct attribute"
   whilst the net-next tree adds a new read-only attribute named phys_port_id.

   Resolve by renaming "show_phys_port_id" to "phys_port_id_show", adding
   a "static DEVICE_ATTR_RO(phys_port_id);" right underneath that function,
   and then adding a "&dev_attr_phys_port_id.attr," entry to net_class_attrs[].

2) include/net/netprio_cgroup.h, overlapping changes with Tejun's tree, retain
   the removal of "struct cgroup_netprio_state" in one hunk and the removal
   of "extern" from the function declaration in the other hunk.

3) include/linux/usb/usbnet.h, overlapping additions, retain them both.
   One adds the "can_dma_sg" member, the other adds "rx_qlen" and "tx_tqlen".
   Again, resolve by keeping them all.

And there is one semantic change, as mentioned by Stephen Rothwell, in
drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c.  bond_for_each_slave() no
longer has a final 'cnt' argument.  Resolve by removing the final argument
to the bond_for_each_slave() call in cxgb4_inet6addr_handler(), and also remove
the local 'cnt' variable as it is no longer used.

Noteworthy changes this time around:

1) Multicast rejoin support for team driver, from Jiri Pirko.

2) Centralize and simplify TCP RTT measurement handling in order to
   reduce the impact of bad RTO seeding from SYN/ACKs.  Also, when
   both timestamps and local RTT measurements are available prefer the
   later because there are broken middleware devices which scramble
   the timestamp.

   From Yuchung Cheng.

3) Add TCP_NOTSENT_LOWAT socket option to limit the amount of kernel memory
   consumed to queue up unsend user data.  From Eric Dumazet.

4) Add a "physical port ID" abstraction for network devices, from Jiri Pirko.

5) Add a "suppress" operation to influence fib_rules lookups, from Stefan
   Tomanek.

6) Add a networking development FAQ, from Paul Gortmaker.

7) Extend the information provided by tcp_probe and add ipv6 support, from
   Daniel Borkmann.

8) Use RCU locking more extensively in openvswitch data paths, from Pravin
   B. Shelar.

9) Add SCTP support to openvswitch, from Joe Stringer.

10) Add EF10 chip support to SFC driver, from Ben Hutchings.

11) Add new SYNPROXY netfilter target, from Patrick McHardy.

12) Compute a rate approximation for sending in TCP sockets, and use this
    to more intelligently coalesce TSO frames.  Furthermore, add a new
    packet scheduler which takes advantage of this estimate when available.
    From Eric Dumazet.

13) Allow AF_PACKET fanouts with random selection, from Daniel Borkmann.

14) Add ipv6 support to vxlan driver, from Cong Wang.

Please pull, thanks a lot!

The following changes since commit a8787645e14ce7bbc3db9788526ed0be968c0df2:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-08-30 17:43:17 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master

for you to fetch changes up to 0d40f75bdab241868c0eb6f97aef9f8b3a66f7b3:

  openvswitch: Fix alignment of struct sw_flow_key. (2013-09-05 15:54:37 -0400)

----------------------------------------------------------------
Ajit Khaparde (1):
      be2net: set and query VEB/VEPA mode of the PF interface

Akeem G Abodunrin (11):
      igb: Reset the link when EEE setting changed
      igb: Read register for latch_on without return value
      igb: Added rcu_lock to avoid race
      igb: Implementation of 1-sec delay for i210 devices
      igb: New PHY_ID for i354 device
      igb: M88E1543 PHY downshift implementation
      igb: No PHPM support in i354 devices
      igb: Support to get 2_5G link status for appropriate media type
      igb: Get speed and duplex for 1G non_copper devices
      igb: Implementation to report advertised/supported link on i354 devices
      igb: Update version number

Alexander Aring (5):
      6lowpan: init ipv6hdr buffer to zero
      6lowpan: introduce lowpan_fetch_skb function
      6lowpan: add function to uncompress multicast addr
      6lowpan: lowpan_uncompress_addr with address_mode
      6lowpan: handle context based source address

Alexander Bondar (6):
      iwlwifi: mvm: Upgrade to a new power management uAPSD API
      iwlwifi: mvm: Change AM->PSM timeout for EAPOL frames
      iwlwifi: mvm: Change beacon abort escape time value
      iwlwifi: mvm: Fix beacon filtering enablement via debugfs
      iwlwifi: mvm: Add basic uAPSD client support
      iwlwifi: mvm: Add PBW snoozing enablement

Alexander Duyck (2):
      ixgbe: Use pci_vfs_assigned instead of ixgbe_vfs_are_assigned
      igb: Update MTU so that it is always at least a standard frame size

Alexander Shiyan (3):
      can: mcp251x: Replace power callbacks with regulator API
      can: mcp251x: Eliminate irq_flags from driver platform_data
      can: mcp251x: Allow tuning SPI mode and limit maximal SPI speed

Alexander Sverdlin (1):
      net: sctp: Fix data chunk fragmentation for MTU values which are not multiple of 4

Alexandre Rames (3):
      sfc: Add EF10 support for TX/RX DMA error events handling.
      sfc: Return an error code when a sensor is busy.
      sfc: Use a global count of active queues instead of pending drains

Alexandru Juncu (1):
      mISDN: replace sum of bitmasks with OR operation.

Alexey Khoroshilov (1):
      hostap: do not return positive number on failure path in prism2_open()

Amerigo Wang (1):
      vti: switch to new ip tunnel code

Amir Vadai (4):
      net/mlx4_en: Coding style cleanup in mlx4_en_dcbnl_ieee_setpfc()
      net/mlx4_en: Notify user when TX ring in error state
      net/mlx4_en: Fix handling of dma_map failure
      net/mlx4_en: Reduce scope of local variables in mlx4_en_xmit

Amit Uttamchandani (1):
      net/velocity: add poll controller function for velocity nic

Amitkumar Karwar (19):
      cfg80211/nl80211: rename packet pattern related structures and enums
      cfg80211/nl80211: Add packet coalesce support
      mwifiex: add PCIe shutdown handler to avoid system hang on reboot
      mwifiex: move del_timer_sync(scan_delay_timer) call to fix memleak
      mwifiex: remove unnecessary del_timer(cmd_timer)
      mwifiex: move if_ops.cleanup_if() call
      mwifiex: add unregister_dev handler for usb interface
      mwifiex: reduce firmware poll retries
      mwifiex: replace mdelay with msleep
      mwifiex: correction in mwifiex_check_fw_status() return status
      mwifiex: remove duplicate structure host_cmd_tlv
      mwifiex: handle driver initialization error paths
      mwifiex: code rearrangement in sdio.c
      mwifiex: fix adapter pointer dereference issue
      mwifiex: rename mef macros
      mwifiex: modify mwifiex_is_pattern_supported() routine
      mwifiex: increase max supported pattern offset
      mwifiex: add packet coalesce support
      mwifiex: fix driver unload problem for usb chipsets

Anders Larsen (1):
      pch_gbe: ethtool cannot change parameters when link is down

Andi Shyti (2):
      net: trans_rdma: remove unused function
      9p: client: remove unused code and any reference to "cancelled" function

Andrea Merello (1):
      Update e-mail address for Andrea Merello (resubmit)

Andrei Otcheretianski (1):
      iwlwifi: mvm: Implement CQM offloading

Andy King (1):
      VMXNET3: Add support for virtual IOMMU

Andy Shevchenko (4):
      e100: dump small buffers via %*ph
      Bluetooth: use DIV_ROUND_UP in suitable places in btmrvl_sdio
      atm: nicstar: re-use native mac_pton() helper
      atm: he: print MAC via %pM

Andy Zhou (3):
      openvswitch: Mega flow implementation
      openvswitch: Rename key_len to key_end
      openvswitch: optimize flow compare and mask functions

Anton Blanchard (1):
      ibmveth: Fix little endian issues

Antonio Quartulli (4):
      mac80211: ibss - remove not authorized station earlier
      mac80211: ibss - do not scan if not needed when creating an IBSS
      batman-adv: move enum definition at the top of the file
      batman-adv: send GW_DEL event when the gw client mode is deselected

Arend van Spriel (17):
      brcmfmac: use irq safe spinlock in brcmf_sdbrcm_txdata()
      brcmfmac: .txdata() bus callback should not call brcmf_txcomplete()
      brcmfmac: add AMPDU reordering functionality
      brcmfmac: ignore IF event if firmware indicates it
      brcmfmac: add support for manual TDLS operations
      brcmsmac: cosmetic change in phy_lcn.c
      brcmsmac: change pa_gain for bcm4313 iPA
      brcmsmac: use ARRAY_SIZE in phytbl_lcn.c
      brcmsmac: add debug info message providing phy and radio info
      brcmsmac: update transmit gain table for lcn phy
      brcmsmac: change lcnphy receive i/q calibration routine
      brcmsmac: fix TSSI idle estimation
      brcmsmac: avoid calling set_txpwr_by_index() twice
      brcmsmac: rework switch control table init including iPA BT-combo
      brcmsmac: correct phy registers for TSSI-based power control
      brcmsmac: reinitialize TSSI power control upon channel switch
      brcmsmac: add support for BCM4313 iPA variant

Ariel Elior (2):
      bnx2x: VF RSS support - PF side
      bnx2x: VF RSS support - VF side

Arron Wang (2):
      NFC: Fix secure element state check
      NFC: Update secure element state

Asias He (2):
      VSOCK: Move af_vsock.h and vsock_addr.h to include/net
      vhost: Include linux/uio.h instead of linux/socket.h

Avinash Patil (9):
      mwifiex: rename pkt_count to ba_pkt_count in mwifiex_ra_list_tbl struct
      mwifiex: maintain outstanding packet count for RA list instead of packet size
      mwifiex: delete AP TX queues when bridged packets reach threshold
      mwifiex: correct max IE length check for WPS IE
      mwifiex: modify mwifiex_ap_sta_limits to advertise support for P2P
      ieee80211: add definition for interworking support
      mwifiex: populate rates in probe request using cfg80211_scan_request
      mwifiex: fix ext_capab IE structure definition
      mwifiex: drop gratuitous ARP frames

Avri Altman (2):
      iwlwifi: mvm: new api to get signal strength
      iwlwifi: mvm: fix signal reporting for < 3 antennas

Bartosz Markowski (1):
      ath10k: add SoC power save option to PCI features map

Ben Hutchings (70):
      Merge branch 'sfc-3.11'
      sfc: const-qualify source pointers for MMIO write functions
      sfc: Use efx_mcdi_mon() to find efx_mcdi_mon structure from efx_nic
      sfc: Move details of a Falcon bug workaround out of ethtool.c
      sfc: Move more Falcon-specific code and definitions into falcon.c
      sfc: Introduce and use MCDI_DECLARE_BUF macro
      sfc: Rationalise MCDI buffer accessors
      sfc: Fill out the set of MCDI accessors
      sfc: Introduce and use MCDI_CTL_SDU_LEN_MAX_V1 macro for Siena-specific code
      sfc: Use proper macros to declare and access MCDI arrays
      sfc: Ensure MCDI buffers, but not lengths, are dword aligned
      sfc: Add and use MCDI_SET_QWORD() and MCDI_SET_ARRAY_QWORD()
      sfc: Move siena_reset_hw() and siena_map_reset_reason() into MCDI module
      sfc: Move efx_mcdi_mac_reconfigure() to siena.c and rename
      sfc: Collect all MCDI port functions into mcdi_port.c
      sfc: Make efx_mcdi_init() call efx_mcdi_handle_assertion()
      sfc: Make MCDI independent of Siena
      sfc: Add GFP flags to efx_nic_alloc_buffer() and make most callers allow blocking
      sfc: Make struct efx_special_buffer less special
      sfc: Rename Falcon-architecture register definitions
      sfc: Remove efx_process_channel_now()
      sfc: Rework IRQ enable/disable
      sfc: Limit scope of a Falcon A1 IRQ workaround
      sfc: Stop RX refill before flushing RX queues
      sfc: Remove bogus call to efx_release_tx_buffers()
      sfc: Refactor queue teardown sequence to allow for EF10 flush behaviour
      sfc: Move and rename Falcon/Siena common NIC operations
      sfc: Translate MCDI error numbers received in events
      sfc: Update MCDI protocol definitions for EF10
      sfc: Add support for MCDI v2
      sfc: Fix race in completion handling
      sfc: Update and improve kernel-doc for efx_mcdi_state & efx_mcdi_iface
      sfc: Get rid of per-NIC-type phys_addr_channels and mem_map_size
      sfc: EFX_WORKAROUND_ALWAYS is really specific to Falcon-architecture
      sfc: Do not assume efx_nic_type::ev_fini is idempotent
      sfc: Remove unused filter_flags variables and efx_farch_filter_id_flags()
      sfc: Rename Falcon-arch filter implementation types and functions
      sfc: Name the RX drop queue ID
      sfc: Extend and abstract efx_filter_spec to cover Huntington/EF10
      sfc: Split Falcon-arch-specific and common filter state
      sfc: Refactor Falcon-arch search limit reset
      sfc: Make most filter operations NIC-type-specific
      sfc: Refactor Falcon-arch filter removal
      sfc: Add flag for stack-owned RX MAC filters
      sfc: Define and use MCDI_POPULATE_DWORD_{1,2,3,4,5,6,7}
      sfc: Cleanup Falcon-arch simple MAC filter state
      sfc: Rename SPI stuff to show that it is Falcon-specific
      sfc: Eliminate struct efx_mtd
      sfc: Move NIC-type-specific MTD partition date into separate structures
      sfc: Move MTD operations into efx_nic_type
      sfc: Remove more left-overs from Falcon GMAC support
      sfc: Remove driver-local struct ethtool_string
      sfc: Delegate MAC/NIC statistic description to efx_nic_type
      sfc: Remove early call to efx_nic_type::reconfigure_mac in efx_reset_up()
      sfc: Rename EFX_PAGE_BLOCK_SIZE to EFX_VI_PAGE_SIZE and adjust comments
      sfc: Add TX merged completion counter
      sfc: Add support for reading packet length from prefix
      sfc: Use extended MC_CMD_SENSOR_INFO and MC_CMD_READ_SENSORS
      sfc: Add support for new board sensors
      sfc: Refactor efx_mcdi_rpc_start() and efx_mcdi_copyin()
      sfc: Remove unnecessary use of atomic_t
      sfc: Implement asynchronous MCDI requests
      sfc: Document conditions for multicast replication vs filter replacement
      sfc: Allow efx_nic_type::dimension_resources to fail
      sfc: Initialise IRQ moderation for all NIC types from efx_init_eventq()
      sfc: Extend struct efx_tx_buffer to allow pushing option descriptors
      sfc: Add EF10 register and structure definitions
      sfc: Make efx_mcdi_{init,fini}() call efx_mcdi_drv_attach()
      sfc: Add support for Solarflare SFC9100 family
      sfc: Update copyright banners

Benjamin Tissoires (2):
      Bluetooth: hidp: implement hidinput_input_event callback
      Bluetooth: hidp: remove wrong send_report at init

Bing Zhao (3):
      mwifiex: fix build error when CONFIG_PM is not set
      mwifiex: do not create AP and P2P interfaces upon driver loading
      mwifiex: break a long line into two lines

Bj√∏rn Mork (10):
      net: etherdevice: add address inherit helper
      net: vlan: inherit addr_assign_type along with dev_addr
      net: dsa: inherit addr_assign_type along with dev_addr
      net: macvlan: inherit addr_assign_type along with dev_addr
      net: team: inherit addr_assign_type along with dev_addr
      net: airo: inherit addr_assign_type along with dev_addr
      net: hostap: inherit addr_assign_type along with dev_addr
      net: libertas: inherit addr_assign_type along with dev_addr
      staging: vt6655: inherit addr_assign_type along with dev_addr
      net: usbnet: update addr_assign_type if appropriate

Bob Copeland (1):
      mac80211: assign seqnums for group QoS frames

Boris BREZILLON (4):
      net/cadence/macb: add support for dt phy definition
      ARM: at91/dt: define phy available on sama5d3 mother board
      net/cadence/macb: fix invalid 0 return if no phy is discovered on mii init
      ARM: at91/dt: fix phy address in sama5xmb to match the reg property

Bruce Allan (10):
      e1000e: disable ASPM L1 on 82583
      e1000e: iAMT connections drop on driver unload when jumbo frames enabled
      e1000e: low throughput using 4K jumbos on I218
      e1000e: Tx hang on I218 when linked at 100Half and slow response at 10Mbps
      e1000e: ethtool unnecessarily takes device out of RPM suspend
      e1000e: enable support for new device IDs
      e1000e: do not resume device from RPM suspend to read PHY status registers
      e1000e: fix I217/I218 PHY initialization flow
      e1000e: cleanup whitespace in recent commit
      e1000e: resolve checkpatch JIFFIES_COMPARISON warning

Carlos O'Donell (1):
      net: sync some IP headers with glibc

Carolyn Wyborny (5):
      igb: Refactor of init_nvm_params
      igb: Refactor NVM read functions to accommodate devices with no flash
      igb: Add device support for flashless SKU of i210 device
      igb: Fix get_fw_version function for all parts
      e1000e: Add code to check for failure of pci_disable_link_state call

Chen Gang (2):
      can: c_can: fix error checking of priv->instance in probe()
      drivers: net: ethernet: 8390: Kconfig: add H8300H_AKI3068NET and H8300H_H8MAX dependancy for NE_H8300

Chris Metcalf (14):
      tile: handle 64-bit statistics in tilepro network driver
      tile: set hw_features and vlan_features in setup
      tile: support rx_dropped/rx_errors in tilepro net driver
      tile: avoid bug in tilepro net driver built with old hypervisor
      tile: remove dead is_dup_ack() function from tilepro net driver
      tile: support jumbo frames in the tilegx network driver
      tile: update dev->stats directly in tilegx network driver
      tile: fix panic bug in napi support for tilegx network driver
      tile: enable GRO in the tilegx network driver
      tile: support multiple mPIPE shims in tilegx network driver
      tile: support TSO for IPv6 in tilegx network driver
      tile: make "tile_net.custom" a proper bool module parameter
      tile: remove deprecated NETIF_F_LLTX flag from tile drivers
      tile: support PTP using the tilegx mPIPE (IEEE 1588)

Christoph Paasch (1):
      tcp: trivial: Remove nocache argument from tcp_v4_send_synack

Chun-Yeow Yeoh (3):
      mac80211: set forwarding in mesh capability info
      mac80211: allow lowest basic rate for unicast management for mesh
      mac80211: only respond to probe request with mesh ID

Claudiu Manoil (5):
      gianfar: Remove unused field grp_id from gfar_priv_grp
      gianfar: Fix Tx csum generation errata handling
      gianfar: Cleanup TxFCB insertion on xmit
      gianfar: Add flow control support
      gianfar: Fix reported number of sent bytes to BQL

Cong Wang (15):
      openvswitch: check CONFIG_OPENVSWITCH_GRE in makefile
      ipv6: move ip6_dst_hoplimit() into core kernel
      ipv6: move ip6_local_out into core kernel
      ipv6: export a stub for IPv6 symbols used by vxlan
      ipv6: export in6addr_loopback to modules
      ipv6: do not call ndisc_send_rs() with write lock
      vxlan: add ipv6 support
      vxlan: add ipv6 route short circuit support
      ipv6: move in6_dev_finish_destroy() into core kernel
      vxlan: add ipv6 proxy support
      ipv6: Add generic UDP Tunnel segmentation
      net: unify skb_udp_tunnel_segment() and skb_udp6_tunnel_segment()
      vxlan: fix flowi6_proto value
      vxlan: include net/ip6_checksum.h for csum_ipv6_magic()
      net: make snmp_mib_free static inline

Dan Aloni (1):
      netconsole: avoid a crash with multiple sysfs writers

Dan Carpenter (12):
      net: remove an unneeded check
      iwlwifi: pcie: returning positive instead of negative
      NFC: hci: Fix enable/disable confusion
      rtnetlink: remove an unneeded test
      ipip: dereferencing an ERR_PTR in ip_tunnel_init_net()
      ipip: potential race in ip_tunnel_init_net()
      qlcnic: underflow in qlcnic_validate_max_tx_rings()
      net/fec: cleanup types in fec_get_mac()
      caif: add a sanity check to the tty name
      x25: add a sanity check parsing X.25 facilities
      qlcnic: remove a stray semicolon
      sfc: check for allocation failure

Daniel Borkmann (30):
      net: sctp: trivial: update mailing list address
      net: sctp: trivial: add uapi/linux/sctp.h into maintainers
      net: netlink: minor: remove unused pointer in alloc_pg_vec
      ipvs: ip_vs_sh: ip_vs_sh_get_port: check skb_header_pointer for NULL
      net: sctp: convert sctp_checksum_disable module param into sctp sysctl
      net: sctp: trivial: update bug report in header comment
      net: ipv6: igmp6_event_query: use msecs_to_jiffies
      net: ipv6: minor: *_start_timer: rather use unsigned long
      net: ipv6: mcast: minor: use defines for rfc3810/8.1 lengths
      net: tcp_probe: also include rcv_wnd next to snd_wnd
      net: tcp_probe: kprobes: adapt jtcp_rcv_established signature
      net: tcp_probe: add IPv6 support
      net: sctp_probe: simplify code by using %pISc format specifier
      net: tcp_probe: allow more advanced ingress filtering by mark
      net: sctp: reorder sctp_globals to reduce cacheline usage
      net: sctp: sctp_verify_init: clean up mandatory checks and add comment
      net: packet: add randomized fanout scheduler
      net: packet: use reciprocal_divide in fanout_demux_hash
      net: packet: document available fanout policies
      net: sctp: probe: allow more advanced ingress filtering by mark
      net: tcp_probe: adapt tbuf size for recent changes
      net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv
      net: ipv6: mld: fix v1/v2 switchback timeout to rfc3810, 9.12.
      net: ipv6: mld: clean up MLD_V1_SEEN macro
      net: ipv6: mld: get rid of MLDV2_MRC and simplify calculation
      net: ipv6: mld: implement RFC3810 MLDv2 mode only
      net: ipv6: mld: similarly to MLDv2 have min max_delay of 1
      net: ipv6: mld: refactor query processing into v1/v2 functions
      net: ipv6: mld: introduce mld_{gq, ifc, dad}_stop_timer functions
      net: ipv6: mld: document force_mld_version in ip-sysctl.txt

Daniel Mack (1):
      net: ethernet: davinci_cpdma: export cpdma_chan_get_stats

Daniel Pieczko (1):
      sfc: use MCDI epoch flag to improve MC reboot detection in the driver

Darren Hart (2):
      pch_gbe: Use PCH_GBE_PHY_REGS_LEN instead of 32
      pch_gbe: Add MinnowBoard support

Dave Jones (3):
      bnx2x: Add missing braces in bnx2x:bnx2x_link_initialize
      caif: Add missing braces to multiline if in cfctrl_linkup_request
      tcp: Add missing braces to do_tcp_setsockopt

David Hauweele (1):
      6lowpan: Fix fragmentation with link-local compressed addresses

David S. Miller (51):
      Merge branch 'fec'
      Merge branch 'tcp'
      Merge branch 'team' ("add support for peer notifications and igmp rejoins for team")
      Merge branch 'be2net'
      Merge branch 'minnow/net-next' of git://git.infradead.org/users/dvhart/linux-2.6 into minnow
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'phys_port'
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'bond_rcu'
      Merge branch 'qlcnic'
      Merge branch 'eth_alen'
      Merge branch 'bond_neigh_parms'
      Merge git://git.kernel.org/.../davem/net
      packet: Revert recent header parsing changes.
      Revert "net: sctp: convert sctp_checksum_disable module param into sctp sysctl"
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'x-netns'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'openvswitch_vxlan'
      Merge branch '6lowpan'
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Revert "ipv6: fix checkpatch errors in net/ipv6/addrconf.c"
      Merge branch 'tuntap'
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next into cpsw
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'cadence'
      Merge git://git.kernel.org/.../davem/net
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge branch 'master' of git://git.kernel.org/.../jesse/openvswitch
      Merge branch 'xen-netback'
      Merge tag 'batman-adv-for-davem' of git://git.open-mesh.org/linux-merge
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'bond_vlan'
      Merge branch 'for-davem' of git://git.kernel.org/.../bwh/sfc-next
      Merge branch 'qlcnic'
      Merge branch 'addr_assign_type'
      Merge branch 'for-davem' of git://git.kernel.org/.../linville/wireless-next
      Merge branch 'for-davem' of git://gitorious.org/linux-can/linux-can-next
      Merge branch 'calxedaxgmac'
      Merge branch 'master' of git://git.kernel.org/.../pablo/nf-next
      Merge branch 'master' of git://git.kernel.org/.../jkirsher/net-next
      Merge branch 'enic'
      netfilter: Fix build errors with xt_socket.c
      Merge git://git.kernel.org/.../davem/net

David Spinadel (3):
      iwlwifi: mvm: enable pre-scan passive to active
      cfg80211: add wdev to testmode cmd
      mac80211: add vif to testmode cmd

Dean Nelson (1):
      e1000e: restore call to pci_clear_master()

Denis Kirjanov (3):
      sis900: don't restart auto-negotiation each time after link resume.
      sundance: Add netpoll support
      sundance: Add myself as a maintainer

Djalal Harouni (1):
      ath5k: debugfs: NULL-terminate strings

Dmitry Popov (1):
      tcp: Remove unused tcpct declarations and comments

Don Skidmore (6):
      ixgbe: fix fc autoneg ethtool reporting.
      ixgbe: add new media type.
      ixgbe: bump version number
      ixgbe: add support for quad-port x520 adapter
      ixgbe: fix incorrect limit value in ring transverse
      ixgbe: cleanup some log messages

Dragos Foianu (2):
      net/irda: fixed style issues in irttp
      ipvs: fixed spacing at for statements

Duan Fugang-B38611 (1):
      net: fec: fix the error to get the previous BD entry

Duan Jiong (1):
      ipv6:introduce function to find route for redirect

Eddie Wai (3):
      cnic: Reset tcp_flags during cnic_cm_create().
      cnic: Update TCP options setup for iSCSI.
      cnic: Add missing error checking for RAMROD_CMD_ID_CLOSE

Eliad Peller (5):
      iwlwifi: fix some documentation typos
      iwlwifi: pcie: some little cleanups
      iwlwifi: mvm: add some missing cleanups in iwl_mvm_mac_add_interface
      iwlwifi: mvm: use designated initialization for some arrays
      iwlwifi: mvm: don't clear tbl->win mistakenly

Emil Tantilov (9):
      ixgbe: fix semaphore lock for I2C read/writes on 82598
      ixgbe: fix SFF data dumps of SFP+ modules
      ixgbe: clear semaphore bits on timeouts
      ixgbe: fix link test when connected to 1Gbps link partner
      ixgbe: zero out mailbox buffer on init
      ixgbe: fix SFF data dumps of SFP+ modules from an offset
      ixgbe: add 1Gbps support for QSFP+
      ixgbe: include QSFP PHY types in ixgbe_is_sfp()
      ixgbe: add support for older QSFP active DA cables

Emmanuel Grumbach (8):
      iwlwifi: pcie: don't disable L1 for newest NICs
      iwlwifi: mvm: better handle several several vifs in BT Coex
      iwlwifi: mvm: fix the ACK / CTS kill mask upon RSSI event
      iwlwifi: mvm: don't allocate BT_COEX cmd on stack
      iwlwifi: mvm: remove the default calibration values for 7000
      iwlwifi: mvm: register vif debugfs for AP mode too
      iwlwifi: mvm: remove obsolete flag in TX command API
      iwlwifi: mvm: advertise support for DYNAMIC / STATIC SMPS

Eran Harary (1):
      iwlwifi: mvm: fix debugfs restart if fw_restart is disabled

Eric Dumazet (16):
      iwl3945: better skb management in rx path
      net: add sk_stream_is_writeable() helper
      tcp: TCP_NOTSENT_LOWAT socket option
      netem: Introduce skb_orphan_partial() helper
      net: skb_orphan() changes
      net: add a temporary sanity check in skb_orphan()
      fib_rules: reorder struct fib_rules fields
      ax88179_178a: avoid copy of tx tcp packets
      net: add SNMP counters tracking incoming ECN bits
      af_unix: improve STREAM behavior with fragmented memory
      net: attempt high order allocations in sock_alloc_send_pskb()
      af_unix: fix bug on large send()
      ipv4: raise IP_MAX_MTU to theoretical limit
      tcp: TSO packets automatic sizing
      pkt_sched: fq: Fair Queue packet scheduler
      pkt_sched: fq: prefetch() fix

Eric Lapuyade (5):
      NFC: Move nfc_fw_download_done() definition from private to public
      NFC: pn544: i2c: Add firmware download mode power-on support
      NFC: netlink: Add result of firmware operation to completion event
      NFC: pn544: Add firmware operations hci ops
      NFC: pn544: i2c: Add firmware download implementation for pn544

Eugenia Emantayev (2):
      net/mlx4_en: Fix BlueFlame race
      net/mlx4_en: Disable global flow control when PFC enabled

Eyal Shapira (6):
      iwlwifi: remove duplicate rate scale init code
      iwlwifi: mvm: remove traffic load monitoring in rs
      iwlwifi: mvm: remove rate_scale_data debugfs entry
      iwlwifi: mvm: remove unused fields of iwl_rs_rate_info
      iwlwifi: mvm: remove MIMO3 from rate scale code
      iwlwifi: mvm: remove unused param of rs_dbgfs_set_mcs

Eytan Lifshitz (2):
      iwlwifi: mvm: add high temperature SKU thermal throttling parameters
      iwlwifi: mvm: add support to the new FW time event API

Fabio Baltieri (1):
      mac80211: use oneshot blink API for LED triggers

Fabio Estevam (9):
      fec: Do not enable/disable optional clocks unconditionally
      fec: Fix the order for enabling/disabling the clocks
      fec: Enable/disable clk_ptp in suspend/resume
      fec: Check the return value from clk_prepare_enable()
      fec: Remove unneeded check in platform_get_resource()
      fec: Use devm_request_irq()
      can: flexcan: Use devm_ioremap_resource()
      can: flexcan: Check the return value from clk_prepare_enable()
      fec: Use NAPI_POLL_WEIGHT

Fan Du (3):
      xfrm: Delete hold_timer when destroy policy
      xfrm: Remove rebundant address family checking
      xfrm: Make xfrm_state timer monotonic

Felix Fietkau (19):
      ath9k: add utility functions for accessing tid queues
      ath9k: split tid retry packets into a separate queue
      ath9k: add function for getting the tx tid for a packet
      ath9k: add CAB queue info to debugfs
      ath9k: simplify ath_tx_form_aggr
      ath9k: fix block ack window tracking check
      ath9k: prepare queueing code for handling unaggregated traffic
      ath9k: fix clearing expired A-MPDU subframes in tx completion
      ath9k: always clear ps filter bit on new assoc
      ath9k: use software queues for un-aggregated data packets
      ath9k: improve tx scheduling fairness
      ath9k: use software queueing for multicast traffic
      ath9k: fix rx descriptor related race condition
      ath9k: shrink a few data structures by reordering fields
      ath9k: remove ath9k_sta_remove_debugfs
      ath9k: simplify debugfs chainmask handling
      ath9k: avoid accessing MRC registers on single-chain devices
      ath9k: simplify ath_tid_drain
      ath9k: reset buffer stale flag in ath_tx_get_tid_subframe

Florian Fainelli (2):
      bridge: inherit slave devices needed_headroom
      net: fix comment typo for __skb_alloc_pages()

Florian Westphal (8):
      netfilter: connlabels: remove unneeded includes
      netfilter: nf_queue: relax NFQA_CT attribute check
      netfilter: tproxy: remove nf_tproxy_core, keep tw sk assigned to skb
      netfilter: tproxy: remove nf_tproxy_core.h
      netfilter: nf_conntrack: remove duplicate code in ctnetlink
      netfilter: tproxy: fix build with IP6_NF_IPTABLES=n
      netfilter: nf_conntrack: don't send destroy events from iterator
      netfilter: ctnetlink: fix uninitialized variable

Francesco Fusco (1):
      net: proc_fs: trivial: print UIDs as unsigned int

Franky Lin (4):
      brcmfmac: abstract tx packet processing functions
      brcmfmac: remove align from brcmf_bus structure
      brcmfmac: streamline sdio bus header code
      brcmfmac: use configurable sdio bus header length for tx packet

Fred Zhou (1):
      ieee80211: add definition for 802.11ac information elements

Fr√©d√©ric Dalleau (10):
      Bluetooth: Use hci_connect_sco directly
      Bluetooth: Remove unused mask parameter in sco_conn_defer_accept
      Bluetooth: Add Bluetooth socket voice option
      Bluetooth: Add constants for SCO airmode
      Bluetooth: Use voice setting in deferred SCO connection request
      Bluetooth: Parameters for outgoing SCO connections
      Bluetooth: Add constants and macro declaration for transparent data
      Bluetooth: Prevent transparent SCO on older devices
      Bluetooth: Handle specific error for SCO connection fallback
      Bluetooth: Add SCO connection fallback

Gabor Juhos (37):
      rt2x00: rt2800lib: introduce rt2800_eeprom_word enum
      rt2x00: rt2800lib: introduce local EEPROM access functions
      rt2x00: rt2800lib: introduce rt2800_eeprom_read_from_array helper
      rt2x00: rt2800lib: introduce rt2800_eeprom_word_index helper
      rt2x00: rt2800lib: add EEPROM map for the RT3593 chipset
      rt2x00: rt2800lib: add MAC register initialization for RT3593
      rt2x00: rt2800lib: add BBP register initialization for RT3593
      rt2x00: rt2800lib: add RFCSR register initialization for RT3593
      rt2x00: rt2800lib: add BBP post initialization for RT3593
      rt2x00: rt2800lib: add TX power configuration for RT3593
      rt2x00: rt2800lib: fix BBP1_TX_ANTENNA field configuration for 3T devices
      rt2x00: rt2800lib: fix antenna configuration for RT3593
      rt2x00: rt2800lib: add rt2800_txpower_to_dev helper
      rt2x00: rt2800lib: fix default TX power values for RT3593
      rt2x00: rt2800lib: introduce rt2800_get_txmixer_gain_{24,5}g helpers
      rt2x00: rt2800lib: hardcode TX mixer gain values for RT3593
      rt2x00: rt2800lib: fix LNA_A[12] gain values for RT3593
      rt2x00: rt2800lib: add default_power3 field for three-chain devices
      rt2x00: rt2800lib: add rf_vals for RF3053
      rt2x00: rt2800lib: add channel configuration for RF3053
      rt2x00: rt2800lib: enable VCO recalibration for RF3053
      rt2x00: rt2800lib: enable RF3053 support
      rt2x00: rt2800lib: enable RT3593 support
      rt2x00: rt2800usb: use correct [RT]XWI size for RT3593
      rt2x00: rt2800usb: add USB device ID for Linksys AE3000
      rt2x00: rt2800lib: introduce rt2800_get_txwi_rxwi_size helper
      rt2x00: rt2800pci: fix AUX_CTRL register setup for RT3090/3390/3593/5592
      rt2x00: rt2800: rename HW_BEACON_OFFSET macro
      rt2x00: rt2800lib: pass beacon index to rt2800_clear_beacon_register
      rt2x00: rt2800lib: fix frequency offset boundary calculation
      rt2x00: rt2800lib: optimize frequency offset adjustment
      rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices
      rt2x00: rt2800lib: use step-by-step frequency offset adjustment on MMIO devices
      rt2x00: rt2800lib: move rt2800_adjust_freq_offset function
      rt2x00: rt2800lib: adjust frequency offset for RF3053
      rt2x00: rt2800lib: add rt2800_hw_beacon_base helper
      rt2x00: rt2800lib: don't hardcode beacon offsets

Gerhard Sittig (4):
      fs_enet: silence a build warning (unused variable)
      fs_enet: cleanup clock API use
      can: mscan: add a comment on reg to idx mapping
      can: mscan: improve clock API use

Gianluca Anzolin (6):
      Bluetooth: Take proper tty_struct references
      Bluetooth: Remove the device from the list in the destructor
      Bluetooth: Move the tty initialization and cleanup out of open/close
      Bluetooth: Implement .activate, .shutdown and .carrier_raised methods
      Bluetooth: Fix the reference counting of tty_port
      Bluetooth: Purge the dlc->tx_queue to avoid circular dependency

Giuseppe CAVALLARO (1):
      stmmac: remove useless csum flag

Greg Rose (1):
      ixgbe: Retain VLAN filtering in promiscuous + VT mode

Gustavo Padovan (1):
      Bluetooth: Add missing braces to an "else if"

Hannes Frederic Sowa (6):
      ipv4, ipv6: send igmpv3/mld packets with TC_PRIO_CONTROL
      tcp: add tcp_syncookies mode to allow unconditionally generation of syncookies
      ipv6: fib6_rules should return exact return value
      ipv6: make unsolicited report intervals configurable for mld
      ipv6: drop fragmented ndisc packets by default (RFC 6980)
      ipv6: fix null pointer dereference in __ip6addrlbl_add

Hante Meuleman (2):
      brcmfmac: always use worker thread for tx data.
      brcmfmac: no fws locking outside fws module.

Hauke Mehrtens (12):
      bcma: add some more core names
      bcma: make it possible to select SoC support without mips
      bcma: add constants for new ARM based SoCs
      bcma: return correct error code when bus scan failed
      bcma: fix handling of big addrl
      bgmac: make bgmac depend on bcm47xx
      bcma: change max PCI read request size to 128
      bcma: add method to power up and down the PCIe core by wifi driver
      brcmsmac: use bcma PCIe up and down functions
      bcma: do not export bcma_core_pci_extend_L1timer()
      bcma: add bcma_core_pci_power_save()
      b43: call PCIe up and down functions

Hila Gonen (1):
      iwlwifi: mvm: Change beacon filtering command

Himanshu Madhani (6):
      qlcnic: Update version to 5.2.45
      qlcnic: Update version to 5.3.47
      qlcnic: Multi Tx queue support for 82xx Series adapter.
      qlcnic: Enable Tx queue changes using ethtool for 82xx Series adapter.
      qlcnic: Enable diagnostic test for multiple Tx queues.
      qlcnic: Update version to 5.3.48

Huawei Yang (2):
      mwifiex: remove stop_net_dev_queue operation in AP forwarding
      mwifiex: add tx info to skb when forming mgmt frame

Hyong-Youb Kim (1):
      myri10ge: Add support for ndo_busy_poll

Ido Yariv (3):
      iwlwifi: pcie: Refactor iwl_queue_space
      iwlwifi: pcie: Refactor iwl_rxq_space
      iwlwifi: pcie: Remove duplicate code from pcie irq handlers

Ilan Peer (1):
      iwlwifi: mvm: Return on inconsistency in add interface

Inbal Hacohen (1):
      iwlwifi: move dump_fh into common code

Ivan Vecera (1):
      be2net: don't use dev_err when AER enabling fails

Jacob Keller (7):
      PCI: expose pcie_link_speed and pcix_bus_speed arrays
      PCI: move enum pcie_link_width into pci.h
      PCI: Add function to obtain minimum link width and speed
      ixgbe: call pcie_get_mimimum_link to check if device has enough bandwidth
      ixgbe: fix lockdep annotation issue for ptp's work item
      ixgbe: rename LL_EXTENDED_STATS to use queue instead of q
      ixgbe: disable link when adapter goes down

Jason Wang (15):
      tuntap: hardware vlan tx support
      net: move iov_pages() to net/core/iovec.c
      net: move zerocopy_sg_from_iovec() to net/core/datagram.c
      net: use skb_fill_page_desc() in zerocopy_sg_from_iovec()
      net: remove the useless comment in zerocopy_sg_from_iovec()
      net: use release_pages() in zerocopy_sg_from_iovec()
      net: use skb_copy_datagram_from_iovec() in zerocopy_sg_from_iovec()
      vhost_net: make vhost_zerocopy_signal_used() return void
      vhost_net: use vhost_add_used_and_signal_n() in vhost_zerocopy_signal_used()
      vhost: switch to use vhost_add_used_n()
      vhost_net: determine whether or not to use zerocopy at one time
      vhost_net: poll vhost queue after marking DMA is done
      vhost_net: correctly limit the max pending buffers
      tuntap: purge socket error queue on detach
      tuntap: orphan frags before trying to set tx timestamp

Jeff Kirsher (1):
      Documentation/networking/: Update Intel wired LAN driver documentation

Jesper Dangaard Brouer (2):
      netfilter: more strict TCP flag matching in SYNPROXY
      netfilter: SYNPROXY: let unrelated packets continue

Jesse Gross (1):
      openvswitch: Fix alignment of struct sw_flow_key.

Jingoo Han (47):
      Bluetooth: replace strict_strtol() with kstrtol()
      bna: Staticize local functions
      be2net: Staticize local functions
      net: micrel: Staticize local functions
      net: mlx4: Staticize local functions
      net: phy: micrel: Staticize ksz8873mll_read_status()
      net: phy: mdio: add missing __iomem annotation
      net: wireless: rt2x00: Staticize rt2x00queue_pause_queue_nocheck()
      ethernet: moxa: remove unnecessary platform_set_drvdata()
      ethernet: broadcom: remove unnecessary platform_set_drvdata()
      net: ax88796: use dev_get_platdata()
      net: bfin_mac: use dev_get_platdata()
      net: au1000_eth: use dev_get_platdata()
      net: bcm63xx_enet: use dev_get_platdata()
      net: ep93xx_eth: use dev_get_platdata()
      net: dm9000: use dev_get_platdata()
      net: ethoc: use dev_get_platdata()
      net: fec: use dev_get_platdata()
      net: mv643xx_eth: use dev_get_platdata()
      net: pxa168_eth: use dev_get_platdata()
      net: ks8842: use dev_get_platdata()
      net: ks8851-ml: use dev_get_platdata()
      net: netx-eth: use dev_get_platdata()
      net: sh_eth: use dev_get_platdata()
      net: seeq: use dev_get_platdata()
      net: smc91x: use dev_get_platdata()
      net: smc911x: use dev_get_platdata()
      net: smsc911x: use dev_get_platdata()
      net: niu: use dev_get_platdata()
      net: cpmac: use dev_get_platdata()
      net: davinci_emac: use dev_get_platdata()
      net: davinci_mdio: use dev_get_platdata()
      net: tsi108: use dev_get_platdata()
      net: w5300: use dev_get_platdata()
      net: w5100: use dev_get_platdata()
      net: ixp4xx_eth: use dev_get_platdata()
      net: mdio-gpio: use dev_get_platdata()
      net: mdio-mux-gpio: use dev_get_platdata()
      net: at91_ether: use dev_get_platdata()
      net: macb: use dev_get_platdata()
      net: stmmac: use dev_get_platdata()
      net: emac: use platform_{get,set}_drvdata()
      net: sunhme: use platform_{get,set}_drvdata()
      net: mdio-octeon: use platform_{get,set}_drvdata()
      net: tulip: use pci_{get,set}_drvdata()
      net: sunhme: use pci_{get,set}_drvdata()
      net: netx-eth: remove unnecessary casting

Jiri Bohac (1):
      ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

Jiri Pirko (7):
      team: add peer notification
      net: convert resend IGMP to notifier event
      team: add support for sending multicast rejoins
      net: add ndo to get id of physical port of the device
      rtnl: export physical port id via RT netlink
      net: export physical port id via sysfs
      openvswitch:: link upper device for port devices

Jisheng Zhang (1):
      net: mdio-sun4i: Convert to devm_* api

Jitendra Kalsaria (1):
      qlcnic: Enhance diagnostic loopback error codes.

Joe Perches (17):
      net: Remove extern from include/net/ scheduling prototypes
      addrconf.h: Remove extern function prototypes
      af_unix.h: Remove extern from function prototypes
      af_rxrpc.h: Remove extern from function prototypes
      arp/neighbour.h: Remove extern from function prototypes
      ax25.h: Remove extern from function prototypes
      cfg80211.h/mac80211.h: Remove extern from function prototypes
      checksum: Remove extern from function prototypes
      cls_cgroup.h netprio_cgroup.h: Remove extern from function prototypes
      uapi: Convert some uses of 6 to ETH_ALEN
      include: Convert ethernet mac address declarations to use ETH_ALEN
      ethernet: Convert mac address uses of 6 to ETH_ALEN
      drivers:net: Convert dma_alloc_coherent(...__GFP_ZERO) to dma_zalloc_coherent
      drivers/net: Convert uses of compare_ether_addr to ether_addr_equal
      llc: Use normal etherdevice.h tests
      batman: Remove reference to compare_ether_addr
      wireless: scan: Remove comment to compare_ether_addr

Joe Stringer (3):
      net/sctp: Refactor SCTP skb checksum computation
      net: Add NEXTHDR_SCTP to ipv6.h
      openvswitch: Add SCTP support

Johan Almbladh (1):
      mac80211: perform power save processing before decryption

Johan Hedberg (1):
      Bluetooth: Fix getting SCO socket options in deferred state

Johannes Berg (31):
      wireless: indent kernel-doc with tabs
      mac80211: add per-chain signal information to radiotap
      mac80211_hwsim: use ieee80211_free_txskb
      mac80211_hwsim: claim uAPSD support
      mac80211_hwsim: claim active monitor support
      mac80211: make active monitor injection work w/ HW queue
      iwlwifi: remove forward debugfs function declarations
      iwlwifi: mvm: remove unneeded argument from iwl_mvm_tx_protection()
      iwlwifi: pcie: make unused queue warning more readable
      ath9k: make rfkill configurable
      iwlwifi: dvm: remove P2P support
      iwlwifi: mvm: reprobe device on firmware error during restart
      iwlwifi: mvm: support six IPv6 addresses in D3
      iwlwifi: mvm: assign quota per virtual interface
      iwlwifi: mvm: split constants into separate file
      iwlwifi: mvm: report per-chain signal to mac80211
      iwlwifi: list Emmanuel in maintainers file
      mac80211: add debugfs for driver-buffered TID bitmap
      iwlwifi: pcie: fix resume when no opmode is present
      iwlwifi: mvm: small cleanups in quota management code
      iwlwifi: remove transport suspend/resume indirection
      wireless: make TU conversion macros available
      brcmfmac: use CFG80211_TESTMODE_CMD
      nl80211: clean up CQM settings code
      mac80211: add control port protocol TX control flag
      iwlwifi: mvm: refactor resume from WoWLAN code
      mac80211: add APIs to allow keeping connections after WoWLAN
      mac80211: minstrel_ht: don't use control.flags in TX status path
      mac80211: move setting WIPHY_FLAG_SUPPORTS_SCHED_SCAN into drivers
      mac80211: ignore (E)CSA in probe response frames
      mac80211: fix change_interface queue assignments

John Greene (1):
      brcmsmac: Further reduce log spam from tx phy messages

John W. Linville (19):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'for-linville-20130730' of git://github.com/kvalo/ath6kl
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem
      Merge branch 'for-linville' of git://github.com/kvalo/ath
      Merge tag 'nfc-next-3.12-1' of git://git.kernel.org/.../sameo/nfc-next
      brcmsmac: Fix WARNING caused by lack of calls to dma_mapping_error()
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'for-john' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge branch 'master' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless
      ath9k: ar9003_eeprom.c:3618 fix variable name typo
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211
      Merge branch 'for-john' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-next into for-davem

Jon Cooper (3):
      sfc: Generalise packet hash lookup to support EF10 RX prefix
      sfc: Allow event queue initialisation to fail
      sfc: Prepare for RX scatter on EF10

Jon Mason (1):
      icplus: Use netif_running to determine device state

Jonas Jensen (1):
      net: Add MOXA ART SoCs ethernet driver

Joseph Gasparakis (1):
      vxlan: Notify drivers for listening UDP port changes

Julia Lawall (2):
      bcm63xx_enet: replace devm_request_and_ioremap by devm_ioremap_resource
      drivers:net: delete premature free_irq

Justin Pettit (1):
      openvswitch: Fix argument descriptions in vport.c.

Kalle Valo (2):
      MAINTAINERS: add ath10k
      MAINTAINERS: update ath6kl git location

Karl Beldan (1):
      mac80211: report some VHT radiotap infos for tx status

Kirshenbaum Erez (1):
      wil6210: Enable TCP/UDP checksum HW offload

Kouei Abe (2):
      sh_eth: Fix cache invalidation omission of receive buffer
      sh_eth: Enable Rx descriptor word 0 shift for r8a7790

Laura Mihaela Vasilescu (2):
      igb: Add macro for size of RETA indirection table
      igb: Expose RSS indirection table for ethtool

Laurence Evans (2):
      sfc: PTP MCDI requests need to initialise periph ID field
      sfc: Add a function pointer to abstract write of host time into NIC shared memory

Laurent Pinchart (1):
      sh_eth: r8a7790: Handle the RFE (Receive FIFO overflow Error) interrupt

Li Zhang (1):
      e1000e: Avoid kernel crash during shutdown

Libo Chen (19):
      net: fsl_pq_mdio: use platform_{get,set}_drvdata()
      net: ucc_geth: use platform_{get,set}_drvdata()
      net: fec_mpc52xx_phy: use platform_{get,set}_drvdata()
      net: sunbmac: use platform_{get,set}_drvdata()
      net: sunhme: use platform_{get,set}_drvdata()
      net: xilinx_emaclite: use platform_{get,set}_drvdata()
      net: davinci_mdio: use platform_{get,set}_drvdata()
      net: fsl_pq_mdio: remove unnecessary dev_set_drvdata()
      net: ucc_geth: remove unnecessary dev_set_drvdata()
      net: fec_mpc52xx_phy: remove unnecessary dev_set_drvdata()
      net: sunbmac: remove unnecessary dev_set_drvdata()
      net: sunhme: remove unnecessary dev_set_drvdata()
      net: xilinx_emaclite: remove unnecessary dev_set_drvdata()
      net: davinci_mdio: remove unnecessary dev_set_drvdata()
      net: emac: remove unnecessary dev_set_drvdata()
      net: irda: pxaficp_ir: use platform_set_drvdata()
      net: phy: mdio-octeon: use platform_set_drvdata()
      can: at91_can: use platform_set_drvdata()
      can: flexcan: use platform_set_drvdata()

Linus L√ºssing (2):
      bridge: prevent flooding IPv6 packets that do not have a listener
      bridge: apply multicast snooping to IPv6 link-local, too

Liu Junliang (1):
      USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support

Luciano Coelho (4):
      iwlwifi: pcie: don't swallow error codes in iwl_trans_pcie_alloc()
      iwlwifi: use a macro for default probe length
      iwlwifi: Kconfig: fix help texts wrt 7260 and 3160 devices
      iwlwifi: return -ENOMEM instead of NULL when OOM in iwl_drv_start()

Luis Henriques (1):
      net: rfkill: Do not ignore errors from regulator_enable()

Lutz Jaenicke (1):
      macvlan: fix typo in assignment

Manish Chopra (12):
      qlcnic: Interrupt based driver firmware mailbox mechanism
      qlcnic: Replace poll mode mailbox interface with interrupt based mailbox interface
      qlcnic: Enable mailbox interface in poll mode when interrupts are not available
      qlcnic: Reinitialize mailbox data structures after firmware reset
      qlcnic: Flush mailbox command list when mailbox is not available
      qlcnic: Fix driver initialization for 83xx adapters
      qlcnic: Dump mailbox command data when a command times out
      qlcnic: Enable support for 844X adapter
      qlcnic: Add PVID support for 84xx adapters
      qlcnic: Loopback Inter Driver Communication AEN handler
      qlcnic: Enhance PVID handling for 84xx adapters
      qlcnic: Remove inline keyword

Marcel Holtmann (2):
      Bluetooth: Fix simple whitespace vs tab style issue
      Bluetooth: Set different event mask for LE-only controllers

Mark Brown (2):
      net: asix: Staticise non-exported symbols
      net: asix: Move declaration of ax88172a_info to shared header

Mark Rustad (1):
      ixgbe: Check return value on eeprom reads

Mark Schulte (2):
      rtlwifi: rtl8192cu: fix function declaration header
      rtlwifi: sparse warnings: cast to restricted type

Masami Ichikawa (1):
      rt2800usb: Add WLI-UC-G300HP's Product ID.

Mathias Krause (2):
      xfrm: constify mark argument of xfrm_find_acq()
      af_key: constify lookup tables

Matthew Slattery (1):
      sfc: Allocate NVRAM partition ID range for PHY images

Matti Gottlieb (4):
      iwlwifi: mvm: sram hex dump on NIC error
      iwlwifi: mvm: Enable user set TX power
      iwlwifi: mvm: Add RX statistics debugfs entry
      iwlwifi: introduce external debug level

Matus Ujhelyi (1):
      net: cpsw: Add support for wake-on-lan for cpsw

Michael Chan (15):
      cnic: Simplify netdev events handling.
      cnic: Simplify cnic_release().
      cnic: Update version to 2.5.17 and copyright year.
      cnic, bnx2i: Fix bug on some bnx2x devices that don't support iSCSI
      bnx2: Handle error condition in ->slot_reset()
      bnx2: Use kernel APIs for WoL and power state changes.
      bnx2: Refactor WoL setup into a separate function.
      bnx2: Use SIMPLE_DEV_PM_OPS.
      bnx2: Add pci shutdown handler.
      bnx2: Update version to 2.2.4
      cnic: Use CHIP_NUM macros from bnx2x.h
      cnic: Redefine BNX2X_HW_CID using existing bnx2x macros
      cnic: Eliminate CNIC_PORT macro and port_mode in local struct.
      cnic: Eliminate local copy of pfid.
      cnic: Update version to 2.5.18.

Michael S. Tsirkin (1):
      virtio-net: put virtio net header inline with data

Michal Kazior (45):
      ath10k: fix teardown ordering
      ath10k: fix possible deadlock
      ath10k: setup rts/frag thresholds upon vdev creation
      ath10k: do not setup rts/frag thresholds for suspended interfaces
      ath10k: remove ath10k_bus
      ath10k: fix typo in define name
      ath10k: silent warning in IBSS mode
      ath10k: lower print level for a message
      ath10k: provide errno if bmi read/write fails
      ath10k: change function to take struct ath10k as arg
      ath10k: rename hif callback
      ath10k: embed HTC struct inside ath10k
      ath10k: embed HTT struct inside ath10k
      ath10k: improve locking
      ath10k: abort scan properly if wmi_scan_stop fails
      ath10k: add missing debug prints
      ath10k: decouple pci start/stop logic
      ath10k: decouple core start/stop logic
      ath10k: allow deferred regd update
      ath10k: reset BMI state upon init
      ath10k: decouple suspend code
      ath10k: move free_vdev_map initialization
      ath10k: make sure all resources are freed upon ath10k_stop()
      ath10k: defer hw setup to start/stop mac80211 hooks
      ath10k: store firmware files in memory
      ath10k: skip fw stats debugfs interface if device is down
      ath10k: implement device recovery
      ath10k: implement fw crash simulation command
      ath10k: fix NULL dereference for injected packets
      ath10k: create debugfs interface to trigger fw crash
      ath10k: prevent HTC from being used after stopping
      ath10k: don't reset HTC endpoints unnecessarily
      ath10k: fix memleak in mac setup
      ath10k: fix rts/fragmentation threshold setup
      ath10k: improve tx throughput on slow machines
      ath10k: detect the number of spatial streams supported by hw
      ath10k: implement rx checksum offloading
      ath10k: implement tx checksum offloading
      ath10k: implement get_survey()
      ath10k: prevent using invalid ringbuffer indexes
      ath10k: make sure to use passive scan when n_ssids is 0
      ath10k: advertise more conservative intf combinations
      ath10k: zero arvif memory on add_interface()
      ath10k: fix failpath in MSI-X setup
      ath10k: fix device teardown

Michal Schmidt (1):
      qlcnic: use standard NAPI weights

Mikel Astiz (3):
      Bluetooth: Add HCI authentication capabilities macros
      Bluetooth: Use defines in in hci_get_auth_req()
      Bluetooth: Use defines instead of integer literals

Ming Lei (2):
      USBNET: centralize computing of max rx/tx qlen
      USBNET: increase max rx/tx qlen for improving USB3 thoughtput

Mitch A Williams (1):
      igb: don't allow SR-IOV without MSI-X

Mohammed Shafi Shajakhan (1):
      ath6kl: Fix invalid pointer access on fuzz testing with AP mode

Mugunthan V N (5):
      drivers: net: cpsw: add support to show hw stats via ethtool
      drivers: net: cpsw: Add support for set MAC address
      drivers: net: cpsw: Add support for new CPSW IP version
      drivers: net: cpsw: Add support for new CPSW IP version present in AM43xx SoC
      drivers: net: cpsw: remove platform data header file of cpsw

Nathan Hintz (1):
      netfilter: nf_defrag_ipv6.o included twice

Neel Patel (4):
      drivers/net: enic: Move ethtool code to a separate file
      drivers/net: enic: Adding support for Cisco Low Latency NIC
      drivers/net: enic: Add an interface for USNIC to interact with firmware
      drivers/net: enic: Generate notification of hardware crash

Nicolas Dichtel (12):
      netfilter: export xt_rpfilter.h to userland
      netfilter: export xt_HMARK.h to userland
      dev: move skb_scrub_packet() after eth_type_trans()
      ipv4 tunnels: use net_eq() helper to check netns
      ipip: add x-netns support
      ip6tnl: add x-netns support
      ip6_tunnel: ensure to always have a link local address
      iptunnels: remove net arg from iptunnel_xmit()
      vxlan: remove net arg from vxlan[6]_xmit_skb()
      skb: allow skb_scrub_packet() to be used by tunnels
      tunnels: harmonize cleanup done on skb on xmit path
      tunnels: harmonize cleanup done on skb on rx path

Nikolay Aleksandrov (3):
      bonding: fix system hang due to fast igmp timer rescheduling
      bonding: simplify broadcast_xmit function
      bonding: factor out slave id tx code and simplify xmit paths

Nithin Sujir (7):
      tg3: Remove incorrect switch to aux power
      tg3: Allow NVRAM programming when interface is down
      tg3: Implement the shutdown handler
      tg3: Enable support for timesync gpio output
      tg3: Fix UDP fragments treated as RMCP
      tg3: Update version to 3.133
      tg3: Don't turn off led on 5719 serdes port 0

Oleksij Rempel (1):
      ath9k_htc: do not use bulk on EP3 and EP4

Oliver Hartkopp (1):
      can: gw: add a per rule limitation of frame hops

Olivier Guiter (3):
      NFC: pn533: Add extended information frame decoding support
      NFC: pn533: Split large Tx frames in chunks
      NFC: pn533: Store the correct frame size (normal vs ext)

Pablo Neira Ayuso (2):
      netfilter: ctnetlink: refactor ctnetlink_create_expect
      netfilter: nfnetlink_queue: allow to attach expectations to conntracks

Patrick McHardy (11):
      netfilter: nf_conntrack: remove net_ratelimit() for LOG_INVALID()
      netfilter: nf_conntrack: constify sk_buff argument to nf_ct_attach()
      netfilter: nf_nat: fix locking in nf_nat_seq_adjust()
      netfilter: nf_nat: change sequence number adjustments to 32 bits
      netfilter: nf_nat: use per-conntrack locking for sequence number adjustments
      netfilter: nf_conntrack: make sequence number adjustments usuable without NAT
      net: syncookies: export cookie_v4_init_sequence/cookie_v4_check
      netfilter: add SYNPROXY core/target
      net: syncookies: export cookie_v6_init_sequence/cookie_v6_check
      netfilter: add IPv6 SYNPROXY target
      netfilter: synproxy_core: fix warning in __nf_ct_ext_add_length()

Paul Gortmaker (1):
      Documentation: add networking/netdev-FAQ.txt

Pavel Emelyanov (4):
      tun: Add ability to create tun device with given index
      tun: Report whether the queue is attached or not
      tun: Allow to skip filter on attach
      tun: Get skfilter layout

Peter Wu (2):
      r8169,sis190: remove unnecessary length check
      r8169: fix invalid register dump

Petr Holasek (1):
      ipv6: ipv6_create_tempaddr cleanup

Phil Oester (3):
      netfilter: xt_addrtype: fix trivial typo
      netfilter: ip[6]t_REJECT: tcp-reset using wrong MAC source if bridged
      netfilter: xt_TCPMSS: correct return value in tcpmss_mangle_packet

Phil Sutter (3):
      af_packet: when sending ethernet frames, parse header for skb->protocol
      af_packet: fix for sending VLAN frames via packet_mmap
      af_packet: simplify VLAN frame check in packet_snd

Pratik Pujar (4):
      qlcnic: Add support for 84xx adapters to load firmware from file
      qlcnic: Add AER callback handlers.
      qlcnic: Add AER support for 83xx adapter
      qlcnic: Restructuring of qlc_83xx_fw_info structure.

Pravin B Shelar (14):
      netlink: Eliminate kmalloc in netlink dump operation.
      vxlan: Restructure vxlan socket apis.
      vxlan: Restructure vxlan receive.
      vxlan: Add vxlan recv demux.
      vxlan: Extend vxlan handlers for openvswitch.
      vxlan: Factor out vxlan send api.
      vxlan: Improve vxlan headroom calculation.
      vxlan: Add tx-vlan offload support.
      openvswitch: Add vxlan tunneling support.
      openvswitch: Use RCU lock for flow dump operation.
      openvswitch: Use RCU lock for dp dump operation.
      openvswitch: Use non rcu hlist_del() flow table entry.
      vxlan: Optimize vxlan rcv
      vxlan: Fix kernel panic on device delete.

Rafa≈Ç Mi≈Çecki (1):
      ssb: drop BROKEN from SSB_SFLASH

Rami Rosen (3):
      ipmr: change the prototype of ip_mr_forward().
      ip6mr: change the prototype of ip6_mr_forward().
      xfrm: remove irrelevant comment in xfrm_input().

Rasesh Mody (1):
      bna: firmware update to 3.2.1.1

Richard Cochran (2):
      net: Provide a generic socket error queue delivery method for Tx time stamps.
      tun: Support software transmit time stamping.

Rob Herring (11):
      net: calxedaxgmac: remove NETIF_F_FRAGLIST setting
      net: calxedaxgmac: read correct field in xgmac_desc_get_buf_len
      net: calxedaxgmac: fix race between xgmac_tx_complete and xgmac_tx_err
      net: calxedaxgmac: fix possible skb free before tx complete
      net: calxedaxgmac: update ring buffer tx_head after barriers
      net: calxedaxgmac: fix race with tx queue stop/wake
      net: calxedaxgmac: enable interrupts after napi_enable
      net: calxedaxgmac: fix various errors in xgmac_set_rx_mode
      net: calxedaxgmac: remove some unused statistic counters
      net: calxedaxgmac: fix rx DMA mapping API size mismatches
      net: calxedaxgmac: fix xgmac_xmit DMA mapping error handling

Sachin Kamat (2):
      net: wan: sbni: Fix incorrect placement of __initdata
      net: via-rhine: Fix incorrect placement of __initdata

Samuel Ortiz (12):
      MAINTAINERS: Change the NFC subsystem status to Supported
      NFC: Document secure element addition/removal netlink events
      NFC: Define secure element connectivity and transaction events
      NFC: pn533: Fix hardware busy loop when establishing the LLCP link
      NFC: pn533: Fix the pn533 polling loop
      NFC: pn533: Request System code from SENSF_REQ
      NFC: pn533: Unconditionaly select the highest p2p bit rate
      NFC: pn533: Enable AUTO RFCA
      NFC: Fix SE discovery failure warning condition
      NFC: Add a GET_SE netlink API
      NFC: pn533: Add delay between each poll frame
      NFC: pn533: Add some polling entropy

Sathya Perla (12):
      be2net: fix MAC address modification for VF
      be2net: allow VFs to program MAC and VLAN filters
      be2net: fix pmac_id for BE3 VFs
      be2net: refactor MAC-addr setup code
      be2net: use SET/GET_MAC_LIST for SH-R
      be2net: delete primary MAC address while unloading
      be2net: update driver version
      be2net: use EQ_CREATEv2 for SH-R
      be2net: refactor be_get_resources() code
      be2net: Fix be_cmd_if_create() to use MBOX if MCCQ is not created
      be2net: refactor be_setup() to consolidate queue creation routines
      be2net: implement ethtool set/get_channel hooks

Sean Cross (1):
      net/phy: micrel: Add OF configuration support for ksz9021

Sergei Shtylyov (9):
      SH7619: fix Ether support
      SolutionEngine7724: fix Ether support
      sh_eth: get register layout from 'struct sh_eth_cpu_data'
      sh_eth: remove 'register_type' field from 'struct sh_eth_plat_data'
      SH7619: fix typo in Ether platform data
      SolutionEngine7724: fix typo in Ether platform data
      sh_eth: no need to call ether_setup()
      sh_eth: NAPI requires netif_receive_skb()
      sh_eth: fix napi_{en|dis}able() calls racing against interrupts

Shahed Shaikh (4):
      qlcnic: Implement ndo_get_phys_port_id for 82xx adapter
      qlcnic: Use firmware recommended dump capture mask as default
      qlcnic: Store firmware dump state in CAMRAM register
      qlcnic: Update version to 5.3.50

Shuah Khan (1):
      wireless: Convert mwifiex/pcie to dev_pm_ops from legacy pm_ops

Simon Horman (2):
      sh_eth: add support for RMIIMODE register
      sh_eth: Add support for r8a7790 SoC

Simon Wunderlich (29):
      nl80211: enable HT overrides for ibss
      mac80211: enable HT overrides for ibss
      nl80211: add scan width to bss and scan request structs
      mac80211/rc80211: add chandef to rate initialization
      mac80211: fix timing for 5 MHz and 10 MHz channels
      mac80211: add radiotap flag and handling for 5/10 MHz
      mac80211: select and adjust bitrates according to channel mode
      cfg80211/mac80211: get mandatory rates based on scan width
      cfg80211/mac80211: use reduced txpower for 5 and 10 MHz
      mac80211: allow scanning for 5/10 MHz channels in IBSS
      mac80211: return if IBSS chandef can not be used
      nl80211: allow 5 and 10 MHz channels for IBSS
      mac80211: fix regression when initializing ibss wmm params
      mac80211: fix off-by-one regression in ibss beacon generation
      nl80211/cfg80211: add channel switch command
      mac80211: add channel switch command and beacon callbacks
      mac80211: fix ieee80211_sta_process_chanswitch for 5/10 MHz channels
      mac80211: move ibss presp generation in own function
      ath9k: always use SIFS times from OFDM for 5/10 MHz
      ath9k: use chandef instead of channel_type
      ath9k: report 5/10 MHz channels
      ath9k: set 5/10 MHz supported channels and fix bitrate
      ath9k: announce that ath9k supports 5/10 MHz
      ath5k: report 5/10 MHz channels
      ath5k: set 5/10 MHz supported channels and fix duration
      ath5k: enable support for 5 MHz and 10 MHz channels
      ath9k: enable CSA functionality in ath9k
      batman-adv: set skb priority according to content
      batman-adv: Start new development cycle

Solomon Peachy (3):
      cw1200: Fix incorrect endianness annotation in a header field
      cw1200: Display the correct default reference clock.
      cw1200: When debug is enabled, display all wakeup conditions for the wait_event_interruptible_timeout() call.

Sonic Zhang (2):
      driver:net:stmmac: Disable DMA store and forward mode if platform data force_thresh_dma_mode is set.
      driver:stmmac: Adjust time stamp increase for 0.465 ns accurate only when Time stamp binary rollover is set.

Sony Chacko (1):
      qlcnic: Add support for per port eswitch configuration

Stanislaw Gruszka (2):
      iwl4965: better skb management in rx path
      rt2800: fix wrong TX power compensation

Stefan Tomanek (3):
      fib_rules: add .suppress operation
      fib_rules: add route suppression based on ifgroup
      fib_rules: fix suppressor names and default values

Stephen Rothwell (1):
      pktgen: add needed include file

Steven La (1):
      e1000e: balance semaphore put/get for 82573

Stone Piao (3):
      mwifiex: discard deauth and disassoc event during WPS session
      mwifiex: skip registering mgmt frame that has already registered
      mwifiex: support to send deauth for P2P client

Sucheta Chakraborty (7):
      qlcnic: Update version to 5.2.46.
      qlcnic: dcb: Query adapter DCB capabilities.
      qlcnic: dcb: Get DCB parameters from the adapter.
      qlcnic: dcb: Register DCB AEN handler.
      qlcnic: dcb: Add support for CEE Netlink interface.
      qlcnic: Update version to 5.3.49.
      qlcnic: Fix sparse warning.

Sujith Manoharan (61):
      ath9k: Fix RTS threshold
      ath9k: Move INI overrides to ar9003_hw_override_ini
      ath9k: Add a HW flag for FCC
      ath9k: Fix FastChannelChange for AR9462/AR9565
      ath9k: Use correct channel when switching bands
      ath9k: Program correct initvals for FCC
      ath9k: Release the RF bus after setting board values
      ath9k: Fix diversity combining for AR9285
      ath9k: Add a debugfs file for antenna diversity
      ath9k: Do a quick scan only when scan_not_start is true
      ath9k: Use a subroutine to check for short scan
      ath9k: Add ALT check for cards with GROUP-3 config
      ath9k: Use a subroutine to try LNA switch
      ath9k: Use a helper function for checking LNA options
      ath9k: Simplify checks in quick_scan
      ath9k: Use a subroutine to calculate ALT ratio
      ath9k: Add statistics for antenna diversity
      ath9k: Add information about antenna diversity
      ath9k: Print LNA combining mode during init
      ath9k: Fix antenna diversity for CUS198
      ath9k: Cleanup WLAN/BT RX diversity
      ath9k: Add a HW capability for WLAN/BT RX diversity
      ath9k: Rename ath9k_hw_antctrl_shared_chain_lnadiv
      ath9k: Enable WLAN/BT Ant Diversity for WB225/WB195
      ath9k: Program HW for WB195 diversity
      ath9k: Remove "shared_chain_lnadiv"
      ath9k: Set SWCOM value for CUS198
      ath9k: Support ANT diversity for WB225
      ath9k: Remove ath_ant_comb_update()
      ath9k: Fix antenna control init for AR9485
      ath9k: Add more PCI IDs for WB225 cards
      ath9k: Fix build failure
      ath9k: Fix BTCOEX usage for RX diversity
      ath9k: Run the LNA combining algorithm properly
      ath9k: Use a subroutine to check for "mybeacon"
      ath9k: Fix phy error handling for DFS
      ath9k: Discard invalid frames early
      ath9k: Fix RX crypto processing
      ath9k: Fix TSF processing
      ath9k: Reorder some functions
      ath9k: Fix PHY error processing
      ath9k: Fix RX debug statistics
      ath9k: Fix RX packet counter
      ath9k: Fix RX beacon processing
      ath9k: Move the RX poll check to preprocess()
      ath9k: Handle corrupt descriptors properly
      ath9k: Fix error condition for corrupt descriptors
      ath9k: Remove unused function argument
      ath9k: Handle invalid RSSI
      ath9k: Identify first subframe in an A-MPDU
      ath9k: Optimize LNA check
      ath9k: Use lockless variant to initialize RX fifo
      ath9k: Add support for AR9485 1.2
      ath9k: Add antenna diversity tweak for CUS198
      ath9k: Add one more PCI ID for CUS198
      ath9k: Fix ASPM for AR9462
      ath9k: Fix ASPM workaround usage
      ath9k: Fix TX poll work locking
      ath9k: Fix DEBUG_FS dependency for ath9k
      ath9k: Remove unused ANI commands
      ath9k: Enable D3/L1 ASPM fix for AR9462

Thierry Escande (1):
      NFC: Fix missing static declarations

Thomas Gleixner (1):
      net: Make devnet_rename_seq static

Thomas Graf (5):
      pktgen: Add UDPCSUM flag to support UDP checksums
      pktgen: Use ip_send_check() to compute checksum
      pktgen: Require CONFIG_INET due to use of IPv4 checksum function
      ipv6: Remove redundant sk variable
      ipv6: Don't depend on per socket memory for neighbour discovery messages

Thomas Huth (1):
      virtio-net: Set RXCSUM feature if GUEST_CSUM is available

Thomas Petazzoni (4):
      net: mvneta: move the RX and TX desc macros outside of the structs
      net: mvneta: support big endian
      net: mvneta: properly disable HW PHY polling and ensure adjust_link() works
      net: mvneta: implement ->ndo_do_ioctl() to support PHY ioctls

Thomas Richter (2):
      vxlan fdb replace an existing entry
      macvlan fdb replace support

Tim Gardner (1):
      net: neighbour: Remove CONFIG_ARPD

Tobias Waldekranz (1):
      mwifiex: add missing endian conversions

Todd Fujinaka (1):
      igb: Don't look for a PBA in the iNVM when flashless

Tom Herbert (2):
      flow_dissector: clean up IPIP case
      flow_dissector: add support for IPPROTO_IPV6

Vasanthakumar Thiagarajan (1):
      ath6kl: Fix race in heart beat polling

Vasundhara Volam (7):
      be2net: Adding more speeds reported by get_settings
      be2net: Do not call get_die_temperature cmd for VF
      be2net: don't limit max MAC and VLAN counts
      be2net: Fix displaying supported speeds for BE2
      be2net: fixup log msgs for async events
      be2net: Initialize "status" in be_cmd_get_die_temperature()
      be2net: Fixup profile management routines

Veaceslav Falico (21):
      neighbour: populate neigh_parms on alloc before calling ndo_neigh_setup
      bonding: modify only neigh_parms owned by us
      bonding: call slave_last_rx() only once per slave
      bonding: add bond_time_in_interval() and use it for time comparison
      bonding: remove locking from bond_set_rx_mode()
      net: rename netdev_upper to netdev_adjacent
      net: add lower_dev_list to net_device and make a full mesh
      net: remove search_list from netdev_adjacent
      net: add netdev_upper_get_next_dev_rcu(dev, iter)
      net: add netdev_for_each_upper_dev_rcu()
      bonding: use netdev_upper list in bond_vlan_used
      bonding: make bond_arp_send_all use upper device list
      bonding: convert bond_has_this_ip() to use upper devices
      bonding: use vlan_uses_dev() in __bond_release_one()
      bonding: split alb_send_learning_packets()
      bonding: make alb_send_learning_packets() use upper dev list
      bonding: remove vlan_list/current_alb_vlan
      bonding: pr_debug instead of pr_warn in bond_arp_send_all
      bonding: remove bond_vlan_used()
      bonding: use rlb_client_info->vlan_id instead of ->tag
      net: correctly interlink lower/upper devices

Vijay Subramanian (1):
      tcp: Change return value of tcp_rcv_established()

Vineet Gupta (1):
      ethernet/arc/arc_emac: Fix huge delays in large file copies

Vlad Yasevich (1):
      net: sctp: Add rudimentary infrastructure to account for control chunks

Vladimir Kondratiev (9):
      wil6210: Align WMI header with latest FW
      wil6210: fix wrong index in wil_vring_free
      wil6210: Optimize Tx completion
      wil6210: Introduce struct for sw context
      wil6210: fix subtle race in wil_tx_vring
      wil6210: fix error path in wil_tx_vring
      wil6210: drop -Werror compiler flag
      wil6210: let IP stack re-check HW TCP/UDP csum errors
      cfg80211: add flags to cfg80211_rx_mgmt()

Wang Sheng-Hui (2):
      bonding: use pre-defined macro in bond_mode_name instead of magic number 0
      vlan: cleanup the usage of vlan_dev_priv(dev)

Wei Liu (3):
      xen-netback: remove page tracking facility
      xen-netback: switch to NAPI + kthread 1:1 model
      xen-netback: rename functions

Wei Yang (2):
      e1000e: Remove duplicate assignment of default rx/tx ring size
      e1000e: Use marco instead of digit for defining e1000_rx_desc_packet_split

Wei Yongjun (6):
      tile: fix missing unlock on error in tile_net_open()
      vxlan: using kfree_rcu() to simplify the code
      moxa: fix missing unlock on error in moxart_mac_start_xmit()
      bonding: fix error return code in bond_enslave()
      mac80211_hwsim: fix error return code in init_mac80211_hwsim()
      zd1201: fix error return code

Werner Almesberger (2):
      icmpv6_filter: fix "_hdr" incorrectly being a pointer
      icmpv6_filter: allow ICMPv6 messages with bodies < 4 bytes

William Manley (3):
      net: igmp: Reduce Unsolicited report interval to 1s when using IGMPv3
      net: igmp: Don't flush routing cache when force_igmp_version is modified
      net: igmp: Allow user-space configuration of igmp unsolicited report interval

Wolfram Sang (1):
      drivers/net/ethernet/stmicro/stmmac: don't check resource with devm_ioremap_resource

Xose Vazquez Perez (1):
      wireless: rt2x00: rt2800usb: add RT3573 devices

Yevgeny Petrilin (1):
      net/mlx4_core: Respond to operation request by firmware

Yijing Wang (5):
      bnx2: clean up unnecessary MSI/MSI-X capability find
      bnx2x: clean up unnecessary MSI/MSI-X capability find
      myri10ge: clean up unnecessary MSI/MSI-X capability find
      netxen: clean up unnecessary MSI/MSI-X capability find
      tg3: clean up unnecessary MSI/MSI-X capability find

Yuchung Cheng (9):
      tcp: consolidate SYNACK RTT sampling
      tcp: prefer packet timing to TS-ECR for RTT
      tcp: measure RTT from new SACK
      tcp: use RTT from SACK for RTO
      tcp: add server ip to encrypt cookie in fast open
      tcp: reset reordering est. selectively on timeout
      tcp: increase throughput when reordering is high
      tcp: do not use cached RTT for RTT estimation
      tcp: better comments for RTO initiallization

Yuval Mintz (1):
      bnx2x: Revising locking scheme for MAC configuration

dingtianhong (6):
      bonding: don't call slave_xxx_netpoll under spinlocks
      bonding: bond_sysfs.c checkpatch cleanup
      bonding: add rtnl protection for bonding_store_fail_over_mac
      bonding: Fixed up a error "do not initialise statics to 0 or NULL" in bond_main.c
      ipv6: convert the uses of ADBG and remove the superfluous parentheses
      ipv6: fix checkpatch errors in net/ipv6/addrconf.c

fan.du (6):
      net ipv6: Remove rebundant rt6i_nsiblings initialization
      net: ipv6 eliminate parameter "int addrlen" in function fib6_add_1
      net: split rt_genid for ipv4 and ipv6
      ipv6: bump genid when delete/add address
      sctp: Don't lookup dst if transport dst is still valid
      sctp: Pack dst_cookie into 1st cacheline hole for 64bit host

govindarajulu.v (5):
      driver/net: enic: Add multi tx support for enic
      driver/net: enic: record q_number and rss_hash for skb
      driver/net: enic: Try DMA 64 first, then failover to DMA
      driver/net: enic: Exposing symbols for Cisco's low latency driver
      driver/net: enic: update enic maintainers and driver

hayeswang (10):
      net/usb/r8152: support aggregation
      net/usb/r8152: enable tx checksum
      net/usb/r8152: enable interrupt transfer
      r8152: remove clearing the memory to zero for netdev priv
      r8152: replace void * with struct r8152 *
      r8152: replace lockflags with flags
      r8152: adjust some duplicated code
      r8152: move some declearation of variables
      r8152: adjust tx_bottom function
      r8152: add comments

nikolay@redhat.com (11):
      bonding: remove bond_resend_igmp_join_requests read_unlock leftover
      bonding: convert to list API and replace bond's custom list
      bonding: remove unnecessary read_locks of curr_slave_lock
      bonding: initial RCU conversion
      bonding: change the bond's vlan syncing functions with the standard ones
      bonding: unwind on bond_add_vlan failure
      bonding: simplify and fix peer notification
      bonding: trivial: remove outdated comment and braces
      bonding: simplify bond_3ad_update_lacp_rate and use RTNL for sync
      bonding: drop read_lock in bond_fix_features
      bonding: drop read_lock in bond_compute_features

stephen hemminger (11):
      bridge: cleanup netpoll code
      team: cleanup netpoll clode
      bond: cleanup netpoll code
      bridge: fix rcu check warning in multicast port group
      vxlan: fix rcu related warning
      ip_tunnel: embed hash list head
      pptp: fix sparse pointer warning
      pptp: fix byte order warnings
      qdisc: allow setting default queuing discipline
      qdisc: make args to qdisc_create_default const
      qdisc: fix build with !CONFIG_NET_SCHED

 Documentation/DocBook/80211.tmpl                   |    1 +
 .../devicetree/bindings/net/micrel-ksz9021.txt     |   49 +
 .../devicetree/bindings/net/moxa,moxart-mac.txt    |   21 +
 Documentation/devicetree/bindings/net/stmmac.txt   |    5 +
 Documentation/networking/00-INDEX                  |    2 +
 Documentation/networking/e100.txt                  |    4 +-
 Documentation/networking/e1000.txt                 |   12 +-
 Documentation/networking/e1000e.txt                |   16 +-
 Documentation/networking/igb.txt                   |   67 +-
 Documentation/networking/igbvf.txt                 |    8 +-
 Documentation/networking/ip-sysctl.txt             |   55 +
 Documentation/networking/ixgb.txt                  |   14 +-
 Documentation/networking/ixgbe.txt                 |  109 +-
 Documentation/networking/ixgbevf.txt               |    6 +-
 Documentation/networking/netdev-FAQ.txt            |  224 +
 Documentation/networking/openvswitch.txt           |   40 +
 Documentation/networking/packet_mmap.txt           |    8 +
 Documentation/networking/sctp.txt                  |    5 +-
 Documentation/networking/stmmac.txt                |    3 +
 Documentation/networking/tproxy.txt                |    5 +-
 Documentation/sysctl/net.txt                       |   13 +
 MAINTAINERS                                        |   14 +-
 arch/arm/boot/dts/sama5d3xmb.dtsi                  |    8 +
 arch/arm/mach-pxa/icontrol.c                       |    3 -
 arch/arm/mach-pxa/zeus.c                           |   46 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |    1 -
 arch/arm/mach-shmobile/board-bockw.c               |    1 -
 arch/sh/boards/board-espt.c                        |    1 -
 arch/sh/boards/board-sh7757lcr.c                   |    4 -
 arch/sh/boards/mach-ecovec24/setup.c               |    1 -
 arch/sh/boards/mach-se/7724/setup.c                |    3 +-
 arch/sh/boards/mach-sh7763rdp/setup.c              |    1 -
 arch/sh/kernel/cpu/sh2/setup-sh7619.c              |   11 +-
 arch/tile/gxio/iorpc_mpipe.c                       |   66 +
 arch/tile/gxio/iorpc_mpipe_info.c                  |   18 +
 arch/tile/gxio/mpipe.c                             |   43 +-
 arch/tile/include/gxio/iorpc_mpipe.h               |   14 +-
 arch/tile/include/gxio/iorpc_mpipe_info.h          |    4 +
 arch/tile/include/gxio/mpipe.h                     |  143 +-
 arch/tile/include/hv/drv_mpipe_intf.h              |    3 +
 drivers/atm/he.c                                   |   11 +-
 drivers/atm/nicstar.c                              |   26 +-
 drivers/bcma/Kconfig                               |   10 +-
 drivers/bcma/driver_pci.c                          |   65 +-
 drivers/bcma/driver_pci_host.c                     |    6 +
 drivers/bcma/main.c                                |    2 +-
 drivers/bcma/scan.c                                |   28 +-
 drivers/bluetooth/btmrvl_debugfs.c                 |    6 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    4 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |   12 +-
 drivers/net/bonding/bond_3ad.c                     |   52 +-
 drivers/net/bonding/bond_alb.c                     |  144 +-
 drivers/net/bonding/bond_alb.h                     |    3 -
 drivers/net/bonding/bond_main.c                    |  961 ++--
 drivers/net/bonding/bond_procfs.c                  |   12 +-
 drivers/net/bonding/bond_sysfs.c                   |   90 +-
 drivers/net/bonding/bonding.h                      |   96 +-
 drivers/net/caif/caif_serial.c                     |    4 +-
 drivers/net/can/at91_can.c                         |    2 +-
 drivers/net/can/c_can/c_can_platform.c             |    2 +-
 drivers/net/can/flexcan.c                          |   83 +-
 drivers/net/can/mcp251x.c                          |   98 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |   23 +-
 drivers/net/can/mscan/mscan.c                      |   25 +-
 drivers/net/can/mscan/mscan.h                      |    3 +
 drivers/net/ethernet/8390/Kconfig                  |    2 +-
 drivers/net/ethernet/8390/ax88796.c                |    6 +-
 drivers/net/ethernet/Kconfig                       |    1 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/adi/bfin_mac.c                |    6 +-
 drivers/net/ethernet/aeroflex/greth.c              |   12 +-
 drivers/net/ethernet/amd/au1000_eth.c              |    2 +-
 drivers/net/ethernet/amd/pcnet32.c                 |    6 +-
 drivers/net/ethernet/arc/emac_main.c               |    4 +-
 drivers/net/ethernet/broadcom/Kconfig              |    2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |   23 +-
 drivers/net/ethernet/broadcom/bnx2.c               |  317 +-
 drivers/net/ethernet/broadcom/bnx2.h               |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   39 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  106 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |   11 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   |    3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   93 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_reg.h    |    1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |  309 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h     |   18 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |  396 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h  |   39 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c   |  221 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.h   |   41 +-
 drivers/net/ethernet/broadcom/cnic.c               |  189 +-
 drivers/net/ethernet/broadcom/cnic.h               |   69 +-
 drivers/net/ethernet/broadcom/cnic_defs.h          |    6 +-
 drivers/net/ethernet/broadcom/cnic_if.h            |   12 +-
 drivers/net/ethernet/broadcom/tg3.c                |  146 +-
 drivers/net/ethernet/broadcom/tg3.h                |   12 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c       |   10 +-
 drivers/net/ethernet/brocade/bna/cna.h             |    4 +-
 drivers/net/ethernet/cadence/at91_ether.c          |    2 +-
 drivers/net/ethernet/cadence/macb.c                |   53 +-
 drivers/net/ethernet/calxeda/xgmac.c               |  195 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |    2 +-
 drivers/net/ethernet/cisco/enic/Makefile           |    3 +-
 drivers/net/ethernet/cisco/enic/enic.h             |   55 +-
 drivers/net/ethernet/cisco/enic/enic_api.c         |   48 +
 drivers/net/ethernet/cisco/enic/enic_api.h         |   30 +
 drivers/net/ethernet/cisco/enic/enic_dev.h         |    1 +
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |  257 +
 drivers/net/ethernet/cisco/enic/enic_main.c        |  329 +-
 drivers/net/ethernet/cisco/enic/enic_res.h         |    9 +-
 drivers/net/ethernet/cisco/enic/vnic_dev.c         |   10 +
 drivers/net/ethernet/cisco/enic/vnic_dev.h         |    1 +
 drivers/net/ethernet/cisco/enic/vnic_devcmd.h      |  176 +-
 drivers/net/ethernet/cisco/enic/vnic_rq.c          |    5 +-
 drivers/net/ethernet/cisco/enic/vnic_rq.h          |    5 +-
 drivers/net/ethernet/cisco/enic/vnic_wq.c          |    3 -
 drivers/net/ethernet/cisco/enic/vnic_wq.h          |   14 +-
 drivers/net/ethernet/davicom/dm9000.c              |    2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |    2 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |    8 +-
 drivers/net/ethernet/dlink/sundance.c              |   14 +
 drivers/net/ethernet/emulex/benet/be.h             |   76 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  503 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |   97 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |   25 +
 drivers/net/ethernet/emulex/benet/be_main.c        |  777 +--
 drivers/net/ethernet/emulex/benet/be_roce.c        |    8 +-
 drivers/net/ethernet/emulex/benet/be_roce.h        |    4 +-
 drivers/net/ethernet/ethoc.c                       |    4 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |    7 +-
 drivers/net/ethernet/faraday/ftmac100.c            |    8 +-
 drivers/net/ethernet/freescale/fec.h               |    3 +
 drivers/net/ethernet/freescale/fec_main.c          |  245 +-
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c   |    4 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |   21 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |    4 +-
 drivers/net/ethernet/freescale/gianfar.c           |  168 +-
 drivers/net/ethernet/freescale/gianfar.h           |   16 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |   74 +
 drivers/net/ethernet/freescale/ucc_geth.c          |    4 +-
 drivers/net/ethernet/i825xx/sun3_82586.h           |    4 +-
 drivers/net/ethernet/ibm/emac/core.c               |   12 +-
 drivers/net/ethernet/ibm/emac/mal.c                |    4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |    4 +-
 drivers/net/ethernet/ibm/ibmveth.h                 |   19 +-
 drivers/net/ethernet/icplus/ipg.c                  |    2 +-
 drivers/net/ethernet/intel/e100.c                  |   15 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |    8 +-
 drivers/net/ethernet/intel/e1000e/82571.c          |    6 +
 drivers/net/ethernet/intel/e1000e/e1000.h          |    3 -
 drivers/net/ethernet/intel/e1000e/ethtool.c        |  107 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |   11 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |  140 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |    6 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |  130 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c       |  198 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h     |   42 +-
 drivers/net/ethernet/intel/igb/e1000_hw.h          |    3 +
 drivers/net/ethernet/intel/igb/e1000_i210.c        |  155 +-
 drivers/net/ethernet/intel/igb/e1000_i210.h        |    5 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c         |   11 -
 drivers/net/ethernet/intel/igb/e1000_nvm.c         |   80 +-
 drivers/net/ethernet/intel/igb/e1000_nvm.h         |    1 +
 drivers/net/ethernet/intel/igb/e1000_phy.c         |   31 +-
 drivers/net/ethernet/intel/igb/igb.h               |    8 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |  132 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |  148 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |    8 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c     |   34 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c     |  321 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |  157 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.h    |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |  133 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  180 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  542 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.h       |   46 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |   12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  105 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   14 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    4 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    4 +-
 drivers/net/ethernet/marvell/mvneta.c              |   90 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |   21 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   22 +-
 drivers/net/ethernet/mellanox/mlx4/en_dcb_nl.c     |   15 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |  177 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |    9 +
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  104 +
 drivers/net/ethernet/mellanox/mlx4/fw.h            |    1 +
 drivers/net/ethernet/mellanox/mlx4/main.c          |   35 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   11 -
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |   13 +
 drivers/net/ethernet/micrel/ks8842.c               |   12 +-
 drivers/net/ethernet/micrel/ks8851_mll.c           |    4 +-
 drivers/net/ethernet/moxa/Kconfig                  |   30 +
 drivers/net/ethernet/moxa/Makefile                 |    5 +
 drivers/net/ethernet/moxa/moxart_ether.c           |  559 ++
 drivers/net/ethernet/moxa/moxart_ether.h           |  330 ++
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  213 +-
 drivers/net/ethernet/netx-eth.c                    |    2 +-
 drivers/net/ethernet/nuvoton/w90p910_ether.c       |   15 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h    |   15 +
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c    |    1 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   67 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c    |   98 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.h    |    1 +
 drivers/net/ethernet/pasemi/pasemi_mac.c           |   20 +-
 drivers/net/ethernet/pasemi/pasemi_mac.h           |    2 +-
 drivers/net/ethernet/qlogic/Kconfig                |   11 +
 drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c |    4 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    8 +-
 drivers/net/ethernet/qlogic/qlcnic/Makefile        |    2 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h        |  304 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  743 ++-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h    |   50 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  292 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c  |   40 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c    |  237 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c    | 1179 +++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    |   41 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |  223 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c     |   18 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h     |   11 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_init.c   |   12 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |  179 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |  454 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |   13 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |  165 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |   21 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c  |   19 +-
 drivers/net/ethernet/qlogic/qlge/qlge.h            |    2 +-
 drivers/net/ethernet/realtek/r8169.c               |    9 +-
 drivers/net/ethernet/renesas/Kconfig               |    2 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   71 +-
 drivers/net/ethernet/renesas/sh_eth.h              |   10 +
 drivers/net/ethernet/seeq/sgiseeq.c                |    2 +-
 drivers/net/ethernet/sfc/Kconfig                   |    9 +-
 drivers/net/ethernet/sfc/Makefile                  |    7 +-
 drivers/net/ethernet/sfc/bitfield.h                |    8 +-
 drivers/net/ethernet/sfc/ef10.c                    | 3043 +++++++++++
 drivers/net/ethernet/sfc/ef10_regs.h               |  415 ++
 drivers/net/ethernet/sfc/efx.c                     |  500 +-
 drivers/net/ethernet/sfc/efx.h                     |  129 +-
 drivers/net/ethernet/sfc/enum.h                    |   10 +-
 drivers/net/ethernet/sfc/ethtool.c                 |  399 +-
 drivers/net/ethernet/sfc/falcon.c                  | 1171 ++++-
 drivers/net/ethernet/sfc/falcon_boards.c           |    4 +-
 drivers/net/ethernet/sfc/falcon_xmac.c             |  362 --
 drivers/net/ethernet/sfc/farch.c                   | 2942 +++++++++++
 drivers/net/ethernet/sfc/{regs.h => farch_regs.h}  |  272 +-
 drivers/net/ethernet/sfc/filter.c                  | 1274 -----
 drivers/net/ethernet/sfc/filter.h                  |  238 +-
 drivers/net/ethernet/sfc/io.h                      |   50 +-
 drivers/net/ethernet/sfc/mcdi.c                    | 1262 +++--
 drivers/net/ethernet/sfc/mcdi.h                    |  313 +-
 drivers/net/ethernet/sfc/mcdi_mac.c                |  130 -
 drivers/net/ethernet/sfc/mcdi_mon.c                |  274 +-
 drivers/net/ethernet/sfc/mcdi_pcol.h               | 5540 ++++++++++++++++++--
 .../net/ethernet/sfc/{mcdi_phy.c => mcdi_port.c}   |  345 +-
 drivers/net/ethernet/sfc/mdio_10g.c                |    2 +-
 drivers/net/ethernet/sfc/mdio_10g.h                |    2 +-
 drivers/net/ethernet/sfc/mtd.c                     |  634 +--
 drivers/net/ethernet/sfc/net_driver.h              |  408 +-
 drivers/net/ethernet/sfc/nic.c                     | 1928 +------
 drivers/net/ethernet/sfc/nic.h                     |  539 +-
 drivers/net/ethernet/sfc/phy.h                     |   19 +-
 drivers/net/ethernet/sfc/ptp.c                     |   95 +-
 drivers/net/ethernet/sfc/qt202x_phy.c              |    4 +-
 drivers/net/ethernet/sfc/rx.c                      |  176 +-
 drivers/net/ethernet/sfc/selftest.c                |   15 +-
 drivers/net/ethernet/sfc/selftest.h                |    4 +-
 drivers/net/ethernet/sfc/siena.c                   |  711 ++-
 drivers/net/ethernet/sfc/siena_sriov.c             |  102 +-
 drivers/net/ethernet/sfc/spi.h                     |   99 -
 drivers/net/ethernet/sfc/tenxpress.c               |    2 +-
 drivers/net/ethernet/sfc/tx.c                      |   35 +-
 drivers/net/ethernet/sfc/txc43128_phy.c            |    2 +-
 drivers/net/ethernet/sfc/vfdi.h                    |    2 +-
 drivers/net/ethernet/sfc/workarounds.h             |   22 +-
 drivers/net/ethernet/sgi/meth.c                    |    5 +-
 drivers/net/ethernet/sis/sis190.c                  |    3 -
 drivers/net/ethernet/sis/sis900.c                  |   28 +-
 drivers/net/ethernet/smsc/smc911x.c                |    2 +-
 drivers/net/ethernet/smsc/smc91x.c                 |    2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    1 -
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    9 +-
 drivers/net/ethernet/sun/niu.c                     |    8 +-
 drivers/net/ethernet/sun/sunbmac.c                 |    4 +-
 drivers/net/ethernet/sun/sunhme.c                  |   12 +-
 drivers/net/ethernet/ti/cpmac.c                    |    6 +-
 drivers/net/ethernet/ti/cpsw.c                     |  263 +-
 .../net/ethernet/ti}/cpsw.h                        |   12 +-
 drivers/net/ethernet/ti/davinci_cpdma.c            |    1 +
 drivers/net/ethernet/ti/davinci_emac.c             |    2 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |    7 +-
 drivers/net/ethernet/tile/Kconfig                  |   11 +
 drivers/net/ethernet/tile/tilegx.c                 | 1116 ++--
 drivers/net/ethernet/tile/tilepro.c                |  241 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |   10 +-
 drivers/net/ethernet/via/via-rhine.c               |    2 +-
 drivers/net/ethernet/via/via-velocity.c            |   20 +
 drivers/net/ethernet/wiznet/w5100.c                |    2 +-
 drivers/net/ethernet/wiznet/w5300.c                |    2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   12 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   14 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    4 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |    2 +-
 drivers/net/fddi/defxx.c                           |    6 +-
 drivers/net/irda/ali-ircc.c                        |    8 +-
 drivers/net/irda/nsc-ircc.c                        |    8 +-
 drivers/net/irda/pxaficp_ir.c                      |    2 +-
 drivers/net/irda/smsc-ircc2.c                      |    8 +-
 drivers/net/irda/via-ircc.c                        |    8 +-
 drivers/net/irda/w83977af_ir.c                     |    8 +-
 drivers/net/macvlan.c                              |    7 +-
 drivers/net/macvtap.c                              |  105 +-
 drivers/net/netconsole.c                           |   13 +-
 drivers/net/phy/mdio-gpio.c                        |    2 +-
 drivers/net/phy/mdio-mux-gpio.c                    |    2 +-
 drivers/net/phy/mdio-mux-mmioreg.c                 |    2 +-
 drivers/net/phy/mdio-octeon.c                      |    4 +-
 drivers/net/phy/mdio-sun4i.c                       |   18 +-
 drivers/net/phy/micrel.c                           |  105 +-
 drivers/net/ppp/pptp.c                             |   12 +-
 drivers/net/team/team.c                            |  203 +-
 drivers/net/tun.c                                  |  223 +-
 drivers/net/usb/Kconfig                            |    8 +
 drivers/net/usb/Makefile                           |    1 +
 drivers/net/usb/asix.h                             |    2 +
 drivers/net/usb/asix_devices.c                     |    5 +-
 drivers/net/usb/ax88172a.c                         |    8 +-
 drivers/net/usb/ax88179_178a.c                     |   24 +-
 drivers/net/usb/qmi_wwan.c                         |    2 +-
 drivers/net/usb/r8152.c                            |  845 ++-
 drivers/net/usb/sr9700.c                           |  560 ++
 drivers/net/usb/sr9700.h                           |  173 +
 drivers/net/usb/usbnet.c                           |   58 +-
 drivers/net/virtio_net.c                           |   44 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  211 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |   10 +-
 drivers/net/vxlan.c                                | 1308 ++++-
 drivers/net/wan/sbni.c                             |    2 +-
 drivers/net/wireless/airo.c                        |    2 +-
 drivers/net/wireless/ath/ath.h                     |    2 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |   12 +-
 drivers/net/wireless/ath/ath10k/bmi.h              |    1 +
 drivers/net/wireless/ath/ath10k/ce.c               |    7 +-
 drivers/net/wireless/ath/ath10k/core.c             |  321 +-
 drivers/net/wireless/ath/ath10k/core.h             |   58 +-
 drivers/net/wireless/ath/ath10k/debug.c            |   87 +-
 drivers/net/wireless/ath/ath10k/hif.h              |   49 +-
 drivers/net/wireless/ath/ath10k/htc.c              |   61 +-
 drivers/net/wireless/ath/ath10k/htc.h              |    8 +-
 drivers/net/wireless/ath/ath10k/htt.c              |   27 +-
 drivers/net/wireless/ath/ath10k/htt.h              |    3 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   43 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   14 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  488 +-
 drivers/net/wireless/ath/ath10k/mac.h              |    1 +
 drivers/net/wireless/ath/ath10k/pci.c              |  356 +-
 drivers/net/wireless/ath/ath10k/pci.h              |   15 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  127 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   24 +
 drivers/net/wireless/ath/ath5k/ath5k.h             |    1 +
 drivers/net/wireless/ath/ath5k/base.c              |   59 +-
 drivers/net/wireless/ath/ath5k/base.h              |    2 +-
 drivers/net/wireless/ath/ath5k/debug.c             |   24 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    2 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |    2 +
 drivers/net/wireless/ath/ath5k/qcu.c               |   25 +-
 drivers/net/wireless/ath/ath6kl/init.c             |    3 +
 drivers/net/wireless/ath/ath6kl/main.c             |    3 +
 drivers/net/wireless/ath/ath6kl/testmode.c         |    3 +-
 drivers/net/wireless/ath/ath6kl/testmode.h         |    7 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |    7 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   12 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    3 -
 drivers/net/wireless/ath/ath9k/ani.h               |   13 +-
 drivers/net/wireless/ath/ath9k/antenna.c           |  672 +--
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |    2 -
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   29 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |   67 +
 drivers/net/wireless/ath/ath9k/ar9002_phy.h        |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   31 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    2 +
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |   39 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    1 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |  190 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |    7 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   68 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   21 +
 drivers/net/wireless/ath/ath9k/common.c            |   67 +-
 drivers/net/wireless/ath/ath9k/common.h            |    3 +-
 drivers/net/wireless/ath/ath9k/debug.c             |  310 +-
 drivers/net/wireless/ath/ath9k/debug.h             |   33 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         |   19 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   38 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |    5 +-
 drivers/net/wireless/ath/ath9k/hw-ops.h            |   11 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  115 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   11 +-
 drivers/net/wireless/ath/ath9k/init.c              |   68 +-
 drivers/net/wireless/ath/ath9k/link.c              |    2 +-
 drivers/net/wireless/ath/ath9k/mac.c               |    4 +-
 drivers/net/wireless/ath/ath9k/mac.h               |    2 +
 drivers/net/wireless/ath/ath9k/main.c              |   45 +-
 drivers/net/wireless/ath/ath9k/pci.c               |  157 +-
 drivers/net/wireless/ath/ath9k/phy.h               |    7 +
 drivers/net/wireless/ath/ath9k/rc.c                |   11 +-
 drivers/net/wireless/ath/ath9k/recv.c              |  494 +-
 drivers/net/wireless/ath/ath9k/reg.h               |    6 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  533 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    4 +-
 drivers/net/wireless/ath/wil6210/Makefile          |    3 -
 drivers/net/wireless/ath/wil6210/debugfs.c         |    4 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |    2 +
 drivers/net/wireless/ath/wil6210/trace.h           |   22 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  160 +-
 drivers/net/wireless/ath/wil6210/txrx.h            |   20 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |   27 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   22 +-
 drivers/net/wireless/b43/dma.c                     |    6 +-
 drivers/net/wireless/b43/main.c                    |   14 +
 drivers/net/wireless/b43legacy/dma.c               |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c   |   16 +-
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   31 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    8 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |  279 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  481 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    4 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |   21 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  228 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |    4 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |    1 -
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   65 +-
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |   21 -
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |   15 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   16 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |  399 +-
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  405 +-
 .../wireless/brcm80211/brcmsmac/phy/phytbl_lcn.h   |    1 +
 drivers/net/wireless/cw1200/bh.c                   |    4 +-
 drivers/net/wireless/cw1200/main.c                 |    2 +-
 drivers/net/wireless/cw1200/wsm.h                  |    2 +-
 drivers/net/wireless/hostap/hostap_hw.c            |    2 +-
 drivers/net/wireless/hostap/hostap_main.c          |    6 +-
 drivers/net/wireless/iwlegacy/3945-rs.c            |    1 +
 drivers/net/wireless/iwlegacy/3945.c               |   31 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   18 +-
 drivers/net/wireless/iwlegacy/4965-rs.c            |    1 +
 drivers/net/wireless/iwlwifi/Kconfig               |   30 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h             |    6 -
 drivers/net/wireless/iwlwifi/dvm/debugfs.c         |   15 -
 drivers/net/wireless/iwlwifi/dvm/dev.h             |    7 -
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  172 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   62 -
 drivers/net/wireless/iwlwifi/dvm/rs.c              |    6 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |    6 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c            |  105 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |   21 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c            |   11 +
 drivers/net/wireless/iwlwifi/iwl-config.h          |    4 +
 drivers/net/wireless/iwlwifi/iwl-debug.h           |    2 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.h        |    7 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   10 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h              |   24 +-
 drivers/net/wireless/iwlwifi/iwl-io.c              |   67 +
 drivers/net/wireless/iwlwifi/iwl-io.h              |    3 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h         |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   25 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile          |    2 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c         |  162 +-
 drivers/net/wireless/iwlwifi/mvm/constants.h       |   80 +
 drivers/net/wireless/iwlwifi/mvm/d3.c              |  217 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs.c         |  271 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h       |   49 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h    |  147 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h     |    5 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h       |    2 -
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |  255 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c              |   55 -
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c        |    3 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   82 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |  112 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c             |   58 +-
 drivers/net/wireless/iwlwifi/mvm/power.c           |  383 +-
 drivers/net/wireless/iwlwifi/mvm/power_legacy.c    |  319 ++
 drivers/net/wireless/iwlwifi/mvm/quota.c           |   27 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c              |  653 +--
 drivers/net/wireless/iwlwifi/mvm/rs.h              |   80 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c              |  158 +-
 drivers/net/wireless/iwlwifi/mvm/scan.c            |    2 +
 drivers/net/wireless/iwlwifi/mvm/sta.c             |    3 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c      |  103 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c              |   32 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c              |   13 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c           |   23 +
 drivers/net/wireless/iwlwifi/pcie/drv.c            |   30 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h       |    1 -
 drivers/net/wireless/iwlwifi/pcie/rx.c             |   45 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  144 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |   60 +-
 drivers/net/wireless/libertas/mesh.c               |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   15 +-
 drivers/net/wireless/mwifiex/11n.c                 |   16 +-
 drivers/net/wireless/mwifiex/11n_aggr.c            |    7 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |  177 +-
 drivers/net/wireless/mwifiex/cfp.c                 |   42 +-
 drivers/net/wireless/mwifiex/decl.h                |   12 +-
 drivers/net/wireless/mwifiex/fw.h                  |   72 +-
 drivers/net/wireless/mwifiex/ie.c                  |    2 +-
 drivers/net/wireless/mwifiex/init.c                |   15 +-
 drivers/net/wireless/mwifiex/ioctl.h               |   43 +-
 drivers/net/wireless/mwifiex/join.c                |    1 +
 drivers/net/wireless/mwifiex/main.c                |  110 +-
 drivers/net/wireless/mwifiex/main.h                |   11 +-
 drivers/net/wireless/mwifiex/pcie.c                |   39 +-
 drivers/net/wireless/mwifiex/scan.c                |   63 +-
 drivers/net/wireless/mwifiex/sdio.c                |  219 +-
 drivers/net/wireless/mwifiex/sta_cmd.c             |   77 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |    4 +-
 drivers/net/wireless/mwifiex/sta_event.c           |   10 +
 drivers/net/wireless/mwifiex/sta_ioctl.c           |   11 +-
 drivers/net/wireless/mwifiex/sta_rx.c              |   49 +
 drivers/net/wireless/mwifiex/uap_cmd.c             |  130 +-
 drivers/net/wireless/mwifiex/uap_txrx.c            |   70 +-
 drivers/net/wireless/mwifiex/usb.c                 |   58 +-
 drivers/net/wireless/mwifiex/util.c                |    4 +-
 drivers/net/wireless/mwifiex/wmm.c                 |   16 +-
 drivers/net/wireless/rt2x00/Kconfig                |    6 +
 drivers/net/wireless/rt2x00/rt2800.h               |  279 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            | 1655 +++++-
 drivers/net/wireless/rt2x00/rt2800lib.h            |    4 +
 drivers/net/wireless/rt2x00/rt2800pci.c            |   19 +-
 drivers/net/wireless/rt2x00/rt2800usb.c            |   43 +-
 drivers/net/wireless/rt2x00/rt2x00.h               |    1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    6 +-
 drivers/net/wireless/rtl818x/rtl8180/grf5101.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/grf5101.h     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.h     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c     |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/sa2400.c      |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/sa2400.h      |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    6 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8187.h     |    4 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.c     |    4 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.h     |    4 +-
 drivers/net/wireless/rtl818x/rtl818x.h             |    4 +-
 drivers/net/wireless/rtlwifi/base.c                |    2 +-
 drivers/net/wireless/rtlwifi/ps.c                  |   18 +-
 drivers/net/wireless/rtlwifi/rc.c                  |    1 +
 drivers/net/wireless/rtlwifi/rtl8188ee/trx.c       |    9 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h        |    3 +
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.h        |    3 -
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |   20 +-
 drivers/net/wireless/ti/wlcore/main.c              |   13 +-
 drivers/net/wireless/ti/wlcore/testmode.c          |    3 +-
 drivers/net/wireless/ti/wlcore/testmode.h          |    3 +-
 drivers/net/wireless/zd1201.c                      |    8 +-
 drivers/net/xen-netback/common.h                   |  150 +-
 drivers/net/xen-netback/interface.c                |  135 +-
 drivers/net/xen-netback/netback.c                  |  833 +--
 drivers/nfc/nfcsim.c                               |    6 +-
 drivers/nfc/pn533.c                                |  389 +-
 drivers/nfc/pn544/i2c.c                            |  360 +-
 drivers/nfc/pn544/mei.c                            |    2 +-
 drivers/nfc/pn544/pn544.c                          |   20 +-
 drivers/nfc/pn544/pn544.h                          |    7 +-
 drivers/pci/pci.c                                  |   43 +
 drivers/pci/pci.h                                  |    3 +
 drivers/pci/probe.c                                |    4 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h                |   12 +-
 drivers/scsi/bnx2i/bnx2i_init.c                    |   12 +-
 drivers/ssb/Kconfig                                |    2 +-
 drivers/ssb/driver_chipcommon_sflash.c             |    8 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211.h    |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |    2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8187se/r8180.h                  |    2 +-
 drivers/staging/rtl8187se/r8180_93cx6.h            |    2 +-
 drivers/staging/rtl8187se/r8180_core.c             |    4 +-
 drivers/staging/rtl8187se/r8180_hw.h               |    2 +-
 drivers/staging/rtl8187se/r8180_rtl8225.h          |    2 +-
 drivers/staging/rtl8187se/r8180_rtl8225z2.c        |    2 +-
 drivers/staging/rtl8187se/r8180_wx.c               |    2 +-
 drivers/staging/rtl8187se/r8180_wx.h               |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.h     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.c        |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_cam.h        |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c       |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h       |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.c     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_eeprom.h     |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ethtool.c    |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.c        |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_pci.h        |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ps.c         |    2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_ps.h         |    2 +-
 drivers/staging/rtl8192e/rtllib.h                  |    2 +-
 drivers/staging/rtl8192e/rtllib_debug.h            |    2 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    2 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |    2 +-
 drivers/staging/rtl8192e/rtllib_softmac_wx.c       |    2 +-
 drivers/staging/rtl8192e/rtllib_tx.c               |    2 +-
 drivers/staging/rtl8192u/authors                   |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 .../rtl8192u/ieee80211/ieee80211_softmac_wx.c      |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    2 +-
 drivers/staging/rtl8192u/r8180_93cx6.c             |    2 +-
 drivers/staging/rtl8192u/r8180_93cx6.h             |    2 +-
 drivers/staging/rtl8192u/r8180_pm.c                |    2 +-
 drivers/staging/rtl8192u/r8180_pm.h                |    2 +-
 drivers/staging/rtl8192u/r8190_rtl8256.h           |    2 +-
 drivers/staging/rtl8192u/r8192U.h                  |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    2 +-
 drivers/staging/rtl8192u/r8192U_hw.h               |    2 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |    2 +-
 drivers/staging/rtl8192u/r8192U_wx.h               |    2 +-
 drivers/staging/vt6655/hostap.c                    |    2 +-
 drivers/staging/vt6655/ioctl.c                     |    2 +-
 drivers/staging/vt6655/wpactl.c                    |    2 +-
 drivers/vhost/net.c                                |   92 +-
 drivers/vhost/vhost.c                              |   56 +-
 include/linux/bcma/bcma.h                          |   17 +
 include/linux/bcma/bcma_driver_pci.h               |   24 +-
 include/linux/can/platform/mcp251x.h               |   15 +-
 include/linux/dm9000.h                             |    4 +-
 include/linux/dma-mapping.h                        |    5 +-
 include/linux/etherdevice.h                        |   15 +
 include/linux/fs_enet_pd.h                         |    6 +-
 include/linux/ieee80211.h                          |   72 +-
 include/linux/if_team.h                            |   14 +-
 include/linux/igmp.h                               |    1 -
 include/linux/ipv6.h                               |    3 +
 include/linux/mlx4/cmd.h                           |    1 +
 include/linux/mlx4/device.h                        |   12 +-
 include/linux/mlx4/qp.h                            |    5 +-
 include/linux/mv643xx_eth.h                        |    3 +-
 include/linux/netdevice.h                          |   54 +-
 include/linux/netfilter.h                          |   15 +-
 include/linux/pci.h                                |   15 +
 include/linux/pci_hotplug.h                        |   13 -
 include/linux/platform_data/brcmfmac-sdio.h        |    6 +
 include/linux/sh_eth.h                             |   10 +-
 include/linux/skbuff.h                             |   19 +-
 include/linux/smsc911x.h                           |    3 +-
 include/linux/socket.h                             |    2 +
 include/linux/stmmac.h                             |    1 +
 include/linux/tcp.h                                |    2 +-
 include/linux/usb/usbnet.h                         |    3 +
 include/linux/uwb/spec.h                           |    5 +-
 include/media/tveeprom.h                           |    4 +-
 include/net/9p/transport.h                         |    3 -
 include/net/act_api.h                              |   60 +-
 include/net/addrconf.h                             |  180 +-
 include/net/af_rxrpc.h                             |   35 +-
 include/net/af_unix.h                              |   17 +-
 {net/vmw_vsock => include/net}/af_vsock.h          |    0
 include/net/arp.h                                  |   30 +-
 include/net/ax25.h                                 |  215 +-
 include/net/bluetooth/bluetooth.h                  |    8 +
 include/net/bluetooth/hci.h                        |    7 +
 include/net/bluetooth/hci_core.h                   |   10 +-
 include/net/bluetooth/sco.h                        |    1 +
 include/net/cfg80211.h                             |  239 +-
 include/net/checksum.h                             |   10 +-
 include/net/cls_cgroup.h                           |    2 +-
 include/net/dst.h                                  |   12 +-
 include/net/fib_rules.h                            |   14 +-
 include/net/ieee80211_radiotap.h                   |    4 +
 include/net/if_inet6.h                             |    9 +-
 include/net/ip.h                                   |   12 +-
 include/net/ip6_route.h                            |    2 -
 include/net/ip6_tunnel.h                           |    2 +-
 include/net/ip_tunnels.h                           |   11 +-
 include/net/ipv6.h                                 |    3 +
 include/net/irda/irlan_common.h                    |    3 +-
 include/net/llc_if.h                               |   30 -
 include/net/mac80211.h                             |  192 +-
 include/net/mld.h                                  |   51 +-
 include/net/ndisc.h                                |    5 +
 include/net/neighbour.h                            |   98 +-
 include/net/net_namespace.h                        |   37 +-
 include/net/netfilter/nf_conntrack.h               |    9 +-
 include/net/netfilter/nf_conntrack_extend.h        |    6 +
 include/net/netfilter/nf_conntrack_l4proto.h       |    7 -
 include/net/netfilter/nf_conntrack_seqadj.h        |   51 +
 include/net/netfilter/nf_conntrack_synproxy.h      |   77 +
 include/net/netfilter/nf_nat.h                     |   10 -
 include/net/netfilter/nf_nat_helper.h              |   19 -
 include/net/netfilter/nf_tproxy_core.h             |  210 -
 include/net/netfilter/nfnetlink_queue.h            |    8 +
 include/net/netns/ipv4.h                           |    1 +
 include/net/netns/ipv6.h                           |    1 +
 include/net/netprio_cgroup.h                       |    2 +-
 include/net/nfc/nfc.h                              |    3 +
 include/net/pkt_cls.h                              |   42 +-
 include/net/pkt_sched.h                            |   53 +-
 include/net/sch_generic.h                          |   54 +-
 include/net/sctp/auth.h                            |    8 +-
 include/net/sctp/checksum.h                        |   23 +-
 include/net/sctp/command.h                         |   18 +-
 include/net/sctp/constants.h                       |    8 +-
 include/net/sctp/sctp.h                            |   10 +-
 include/net/sctp/sm.h                              |    8 +-
 include/net/sctp/structs.h                         |   29 +-
 include/net/sctp/tsnmap.h                          |    8 +-
 include/net/sctp/ulpevent.h                        |    8 +-
 include/net/sctp/ulpqueue.h                        |    8 +-
 include/net/sock.h                                 |   29 +-
 include/net/tcp.h                                  |   44 +-
 include/net/udp.h                                  |    1 +
 {net/vmw_vsock => include/net}/vsock_addr.h        |    0
 include/net/vxlan.h                                |   40 +
 include/net/xfrm.h                                 |    2 +-
 include/uapi/linux/Kbuild                          |    1 +
 include/uapi/linux/can/gw.h                        |    9 +-
 include/uapi/linux/dn.h                            |    3 +-
 include/uapi/linux/fib_rules.h                     |    4 +-
 include/uapi/linux/icmpv6.h                        |    2 +
 include/uapi/linux/if_bridge.h                     |    3 +-
 include/uapi/linux/if_link.h                       |    3 +
 include/uapi/linux/if_packet.h                     |    1 +
 include/uapi/linux/if_pppox.h                      |    2 +-
 include/uapi/linux/if_tun.h                        |    6 +
 include/uapi/linux/in.h                            |   49 +-
 include/uapi/linux/in6.h                           |   36 +-
 include/uapi/linux/ip.h                            |    2 +
 include/uapi/linux/ipv6.h                          |    3 +
 include/uapi/linux/libc-compat.h                   |  103 +
 include/uapi/linux/netfilter/Kbuild                |    2 +
 include/uapi/linux/netfilter/nf_conntrack_common.h |    3 +-
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |   15 +-
 include/uapi/linux/netfilter/nfnetlink_queue.h     |    1 +
 include/{ => uapi}/linux/netfilter/xt_HMARK.h      |    0
 include/uapi/linux/netfilter/xt_SYNPROXY.h         |   16 +
 include/{ => uapi}/linux/netfilter/xt_rpfilter.h   |    0
 include/uapi/linux/netfilter_bridge/ebt_802_3.h    |    5 +-
 include/uapi/linux/netfilter_ipv4/ipt_CLUSTERIP.h  |    3 +-
 include/uapi/linux/nfc.h                           |   20 +
 include/uapi/linux/nl80211.h                       |  199 +-
 include/uapi/linux/openvswitch.h                   |   26 +-
 include/uapi/linux/pkt_sched.h                     |   41 +
 include/uapi/linux/sctp.h                          |    2 +-
 include/uapi/linux/snmp.h                          |    4 +
 include/uapi/linux/tcp.h                           |    1 +
 include/uapi/linux/virtio_net.h                    |    6 +-
 include/uapi/linux/wimax/i2400m.h                  |    4 +-
 net/8021q/vlan.c                                   |   13 +-
 net/8021q/vlan_dev.c                               |    8 +-
 net/9p/client.c                                    |    9 +-
 net/9p/trans_rdma.c                                |   11 -
 net/Kconfig                                        |    2 +-
 net/appletalk/atalk_proc.c                         |    2 +-
 net/batman-adv/bat_iv_ogm.c                        |   32 +-
 net/batman-adv/gateway_client.c                    |   27 +
 net/batman-adv/gateway_client.h                    |    1 +
 net/batman-adv/icmp_socket.c                       |    1 +
 net/batman-adv/main.c                              |   58 +
 net/batman-adv/main.h                              |    5 +-
 net/batman-adv/routing.c                           |   20 +-
 net/batman-adv/send.c                              |    1 -
 net/batman-adv/soft-interface.c                    |    2 +
 net/batman-adv/sysfs.c                             |    4 +
 net/batman-adv/translation-table.c                 |    5 +
 net/batman-adv/unicast.c                           |    2 +
 net/batman-adv/vis.c                               |    2 +
 net/bluetooth/hci_conn.c                           |   62 +-
 net/bluetooth/hci_core.c                           |   14 +-
 net/bluetooth/hci_event.c                          |   29 +-
 net/bluetooth/hidp/core.c                          |   40 +-
 net/bluetooth/l2cap_core.c                         |    3 +-
 net/bluetooth/rfcomm/tty.c                         |  271 +-
 net/bluetooth/sco.c                                |   85 +-
 net/bridge/br_device.c                             |   12 +-
 net/bridge/br_if.c                                 |    6 +-
 net/bridge/br_mdb.c                                |    6 +-
 net/bridge/br_multicast.c                          |   17 +-
 net/bridge/br_notify.c                             |    5 +
 net/bridge/br_private.h                            |   22 +-
 net/caif/cfctrl.c                                  |    3 +-
 net/can/gw.c                                       |   35 +-
 net/ceph/messenger.c                               |    2 +-
 net/core/datagram.c                                |   72 +
 net/core/dev.c                                     |  371 +-
 net/core/fib_rules.c                               |   25 +
 net/core/flow_dissector.c                          |    6 +-
 net/core/iovec.c                                   |   24 +
 net/core/neighbour.c                               |    2 -
 net/core/net-sysfs.c                               |   22 +
 net/core/pktgen.c                                  |   61 +-
 net/core/rtnetlink.c                               |   29 +-
 net/core/skbuff.c                                  |   19 +-
 net/core/sock.c                                    |  166 +-
 net/core/stream.c                                  |    2 +-
 net/core/sysctl_net_core.c                         |   30 +-
 net/dccp/proto.c                                   |    4 +-
 net/dsa/slave.c                                    |    2 +-
 net/ieee802154/6lowpan.c                           |  286 +-
 net/ieee802154/6lowpan.h                           |   20 +-
 net/ipv4/Kconfig                                   |   16 -
 net/ipv4/af_inet.c                                 |   12 -
 net/ipv4/arp.c                                     |    2 -
 net/ipv4/devinet.c                                 |   17 +-
 net/ipv4/fib_rules.c                               |   25 +
 net/ipv4/igmp.c                                    |   80 +-
 net/ipv4/ip_gre.c                                  |    4 +-
 net/ipv4/ip_input.c                                |    8 +
 net/ipv4/ip_tunnel.c                               |   71 +-
 net/ipv4/ip_tunnel_core.c                          |   10 +-
 net/ipv4/ip_vti.c                                  |  528 +-
 net/ipv4/ipip.c                                    |    3 +-
 net/ipv4/ipmr.c                                    |   18 +-
 net/ipv4/netfilter/Kconfig                         |   13 +
 net/ipv4/netfilter/Makefile                        |    1 +
 net/ipv4/netfilter/ipt_MASQUERADE.c                |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |   21 +-
 net/ipv4/netfilter/ipt_SYNPROXY.c                  |  476 ++
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |    7 +-
 net/ipv4/ping.c                                    |    2 +-
 net/ipv4/proc.c                                    |    7 +-
 net/ipv4/raw.c                                     |    2 +-
 net/ipv4/route.c                                   |   24 +-
 net/ipv4/syncookies.c                              |   29 +-
 net/ipv4/sysctl_net_ipv4.c                         |   17 +
 net/ipv4/tcp.c                                     |   46 +-
 net/ipv4/tcp_fastopen.c                            |   13 +-
 net/ipv4/tcp_input.c                               |  201 +-
 net/ipv4/tcp_ipv4.c                                |   32 +-
 net/ipv4/tcp_metrics.c                             |   42 +-
 net/ipv4/tcp_minisocks.c                           |    8 +-
 net/ipv4/tcp_output.c                              |    5 +-
 net/ipv4/tcp_probe.c                               |   87 +-
 net/ipv4/udp.c                                     |   18 +-
 net/ipv6/addrconf.c                                |  165 +-
 net/ipv6/addrconf_core.c                           |   50 +
 net/ipv6/addrlabel.c                               |   48 +-
 net/ipv6/af_inet6.c                                |   15 +
 net/ipv6/ah6.c                                     |    2 +-
 net/ipv6/datagram.c                                |    2 +-
 net/ipv6/esp6.c                                    |    2 +-
 net/ipv6/fib6_rules.c                              |   37 +-
 net/ipv6/icmp.c                                    |   12 +-
 net/ipv6/ip6_fib.c                                 |   16 +-
 net/ipv6/ip6_gre.c                                 |   14 +-
 net/ipv6/ip6_input.c                               |    6 +-
 net/ipv6/ip6_offload.c                             |    4 +-
 net/ipv6/ip6_output.c                              |   25 -
 net/ipv6/ip6_tunnel.c                              |   46 +-
 net/ipv6/ip6mr.c                                   |   14 +-
 net/ipv6/ipcomp6.c                                 |    2 +-
 net/ipv6/mcast.c                                   |  289 +-
 net/ipv6/ndisc.c                                   |   45 +-
 net/ipv6/netfilter/Kconfig                         |   13 +
 net/ipv6/netfilter/Makefile                        |    3 +-
 net/ipv6/netfilter/ip6t_MASQUERADE.c               |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |   20 +-
 net/ipv6/netfilter/ip6t_SYNPROXY.c                 |  499 ++
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    7 +-
 net/ipv6/output_core.c                             |   48 +
 net/ipv6/proc.c                                    |    4 +
 net/ipv6/raw.c                                     |    9 +-
 net/ipv6/route.c                                   |  105 +-
 net/ipv6/sit.c                                     |   15 +-
 net/ipv6/syncookies.c                              |   25 +-
 net/ipv6/tcp_ipv6.c                                |   15 +-
 net/ipv6/udp_offload.c                             |  105 +-
 net/ipx/ipx_proc.c                                 |    2 +-
 net/irda/irttp.c                                   |   50 +-
 net/key/af_key.c                                   |   14 +-
 net/llc/af_llc.c                                   |    6 +-
 net/llc/llc_conn.c                                 |    6 +-
 net/llc/llc_proc.c                                 |    2 +-
 net/llc/llc_sap.c                                  |    4 +-
 net/mac80211/cfg.c                                 |  247 +-
 net/mac80211/chan.c                                |   58 +
 net/mac80211/debugfs_sta.c                         |    9 +
 net/mac80211/driver-ops.h                          |   13 +
 net/mac80211/ht.c                                  |   53 +-
 net/mac80211/ibss.c                                |  356 +-
 net/mac80211/ieee80211_i.h                         |   70 +-
 net/mac80211/iface.c                               |   30 +-
 net/mac80211/key.c                                 |  154 +-
 net/mac80211/led.c                                 |   19 +-
 net/mac80211/led.h                                 |    4 +-
 net/mac80211/main.c                                |   18 +-
 net/mac80211/mesh.c                                |   10 +-
 net/mac80211/mesh_plink.c                          |    2 +-
 net/mac80211/mlme.c                                |  118 +-
 net/mac80211/rate.c                                |   69 +-
 net/mac80211/rate.h                                |   22 +-
 net/mac80211/rc80211_minstrel.c                    |   33 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   17 +-
 net/mac80211/rc80211_pid_algo.c                    |    1 +
 net/mac80211/rx.c                                  |  504 +-
 net/mac80211/scan.c                                |   72 +-
 net/mac80211/status.c                              |   90 +-
 net/mac80211/trace.h                               |   26 +
 net/mac80211/tx.c                                  |  122 +-
 net/mac80211/util.c                                |  218 +-
 net/netfilter/Kconfig                              |   26 +-
 net/netfilter/Makefile                             |    6 +-
 net/netfilter/core.c                               |    7 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |    8 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |   23 +-
 net/netfilter/ipvs/ip_vs_sh.c                      |    6 +
 net/netfilter/nf_conntrack_core.c                  |   89 +-
 net/netfilter/nf_conntrack_labels.c                |    4 -
 net/netfilter/nf_conntrack_netlink.c               |  384 +-
 net/netfilter/nf_conntrack_proto.c                 |    4 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   36 +-
 net/netfilter/nf_conntrack_seqadj.c                |  238 +
 net/netfilter/nf_nat_core.c                        |   22 +-
 net/netfilter/nf_nat_helper.c                      |  230 +-
 net/netfilter/nf_nat_proto_sctp.c                  |    8 +-
 net/netfilter/nf_nat_sip.c                         |    3 +-
 net/netfilter/nf_synproxy_core.c                   |  432 ++
 net/netfilter/nf_tproxy_core.c                     |   62 -
 net/netfilter/nfnetlink_queue_core.c               |   11 +-
 net/netfilter/nfnetlink_queue_ct.c                 |   23 +-
 net/netfilter/xt_TCPMSS.c                          |    2 +-
 net/netfilter/xt_TPROXY.c                          |  169 +-
 net/netfilter/xt_addrtype.c                        |    2 +-
 net/netfilter/xt_socket.c                          |   66 +-
 net/netlink/af_netlink.c                           |  101 +-
 net/netlink/af_netlink.h                           |    3 +-
 net/nfc/core.c                                     |   22 +-
 net/nfc/hci/core.c                                 |    2 +-
 net/nfc/netlink.c                                  |   95 +-
 net/nfc/nfc.h                                      |    5 +-
 net/openvswitch/Kconfig                            |   14 +
 net/openvswitch/Makefile                           |    9 +-
 net/openvswitch/actions.c                          |   45 +-
 net/openvswitch/datapath.c                         |  176 +-
 net/openvswitch/datapath.h                         |    6 +
 net/openvswitch/flow.c                             | 1486 ++++--
 net/openvswitch/flow.h                             |   89 +-
 net/openvswitch/vport-gre.c                        |    7 +-
 net/openvswitch/vport-netdev.c                     |   20 +-
 net/openvswitch/vport-vxlan.c                      |  204 +
 net/openvswitch/vport.c                            |    6 +-
 net/openvswitch/vport.h                            |    1 +
 net/packet/af_packet.c                             |   65 +-
 net/phonet/socket.c                                |    2 +-
 net/rfkill/rfkill-regulator.c                      |    8 +-
 net/sched/Kconfig                                  |   14 +
 net/sched/Makefile                                 |    1 +
 net/sched/sch_api.c                                |   53 +
 net/sched/sch_fq.c                                 |  793 +++
 net/sched/sch_generic.c                            |   20 +-
 net/sched/sch_mq.c                                 |    2 +-
 net/sched/sch_mqprio.c                             |    2 +-
 net/sched/sch_netem.c                              |    5 +-
 net/sctp/associola.c                               |    8 +-
 net/sctp/auth.c                                    |    8 +-
 net/sctp/bind_addr.c                               |    8 +-
 net/sctp/chunk.c                                   |   12 +-
 net/sctp/command.c                                 |    8 +-
 net/sctp/debug.c                                   |    8 +-
 net/sctp/endpointola.c                             |    8 +-
 net/sctp/input.c                                   |   18 +-
 net/sctp/inqueue.c                                 |    8 +-
 net/sctp/ipv6.c                                    |   10 +-
 net/sctp/objcnt.c                                  |    8 +-
 net/sctp/output.c                                  |    8 +-
 net/sctp/outqueue.c                                |    8 +-
 net/sctp/primitive.c                               |    8 +-
 net/sctp/probe.c                                   |   27 +-
 net/sctp/proc.c                                    |   12 +-
 net/sctp/protocol.c                                |   10 +-
 net/sctp/sm_make_chunk.c                           |  133 +-
 net/sctp/sm_sideeffect.c                           |    8 +-
 net/sctp/sm_statefuns.c                            |    8 +-
 net/sctp/sm_statetable.c                           |    8 +-
 net/sctp/socket.c                                  |    8 +-
 net/sctp/ssnmap.c                                  |    8 +-
 net/sctp/sysctl.c                                  |    8 +-
 net/sctp/transport.c                               |    8 +-
 net/sctp/tsnmap.c                                  |    8 +-
 net/sctp/ulpevent.c                                |    8 +-
 net/sctp/ulpqueue.c                                |    8 +-
 net/sunrpc/svcsock.c                               |    2 +-
 net/sunrpc/xprtsock.c                              |    2 +-
 net/unix/af_unix.c                                 |   70 +-
 net/vmw_vsock/af_vsock.c                           |    3 +-
 net/vmw_vsock/vmci_transport.c                     |    2 +-
 net/vmw_vsock/vmci_transport.h                     |    4 +-
 net/vmw_vsock/vsock_addr.c                         |    3 +-
 net/wireless/core.c                                |    9 +
 net/wireless/core.h                                |    2 +
 net/wireless/mesh.c                                |    5 +-
 net/wireless/mlme.c                                |    4 +-
 net/wireless/nl80211.c                             |  560 +-
 net/wireless/nl80211.h                             |    4 +-
 net/wireless/rdev-ops.h                            |   17 +-
 net/wireless/scan.c                                |   35 +-
 net/wireless/trace.h                               |   53 +-
 net/wireless/util.c                                |   14 +-
 net/x25/x25_facilities.c                           |    4 +
 net/xfrm/xfrm_policy.c                             |   12 +-
 net/xfrm/xfrm_state.c                              |   15 +-
 security/selinux/include/xfrm.h                    |    7 +-
 1021 files changed, 56787 insertions(+), 23977 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/micrel-ksz9021.txt
 create mode 100644 Documentation/devicetree/bindings/net/moxa,moxart-mac.txt
 create mode 100644 Documentation/networking/netdev-FAQ.txt
 create mode 100644 drivers/net/ethernet/cisco/enic/enic_api.c
 create mode 100644 drivers/net/ethernet/cisco/enic/enic_api.h
 create mode 100644 drivers/net/ethernet/cisco/enic/enic_ethtool.c
 create mode 100644 drivers/net/ethernet/moxa/Kconfig
 create mode 100644 drivers/net/ethernet/moxa/Makefile
 create mode 100644 drivers/net/ethernet/moxa/moxart_ether.c
 create mode 100644 drivers/net/ethernet/moxa/moxart_ether.h
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.c
 create mode 100644 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
 create mode 100644 drivers/net/ethernet/sfc/ef10.c
 create mode 100644 drivers/net/ethernet/sfc/ef10_regs.h
 delete mode 100644 drivers/net/ethernet/sfc/falcon_xmac.c
 create mode 100644 drivers/net/ethernet/sfc/farch.c
 rename drivers/net/ethernet/sfc/{regs.h => farch_regs.h} (92%)
 delete mode 100644 drivers/net/ethernet/sfc/filter.c
 delete mode 100644 drivers/net/ethernet/sfc/mcdi_mac.c
 rename drivers/net/ethernet/sfc/{mcdi_phy.c => mcdi_port.c} (73%)
 delete mode 100644 drivers/net/ethernet/sfc/spi.h
 rename {include/linux/platform_data => drivers/net/ethernet/ti}/cpsw.h (86%)
 create mode 100644 drivers/net/usb/sr9700.c
 create mode 100644 drivers/net/usb/sr9700.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/constants.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/power_legacy.c
 rename {net/vmw_vsock => include/net}/af_vsock.h (100%)
 create mode 100644 include/net/netfilter/nf_conntrack_seqadj.h
 create mode 100644 include/net/netfilter/nf_conntrack_synproxy.h
 delete mode 100644 include/net/netfilter/nf_tproxy_core.h
 rename {net/vmw_vsock => include/net}/vsock_addr.h (100%)
 create mode 100644 include/net/vxlan.h
 create mode 100644 include/uapi/linux/libc-compat.h
 rename include/{ => uapi}/linux/netfilter/xt_HMARK.h (100%)
 create mode 100644 include/uapi/linux/netfilter/xt_SYNPROXY.h
 rename include/{ => uapi}/linux/netfilter/xt_rpfilter.h (100%)
 create mode 100644 net/ipv4/netfilter/ipt_SYNPROXY.c
 create mode 100644 net/ipv6/netfilter/ip6t_SYNPROXY.c
 create mode 100644 net/netfilter/nf_conntrack_seqadj.c
 create mode 100644 net/netfilter/nf_synproxy_core.c
 delete mode 100644 net/netfilter/nf_tproxy_core.c
 create mode 100644 net/openvswitch/vport-vxlan.c
 create mode 100644 net/sched/sch_fq.c
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
