Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3GVGzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 02:55:49 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:48681 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3GVGzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 02:55:45 -0400
From: Won Kang <wkang77@gmail.com>
To: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        jonathankim@gctsemi.com, deanahn@gctsemi.com, wonkang@gctsemi.com
Subject: [PATCH 1/2] staging: gdm7240: adding LTE USB driver
Date: Mon, 22 Jul 2013 15:56:31 +0900
Message-Id: <1374476192-7801-1-git-send-email-wonkang@gctsemi.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCT Semiconductor GDM7240 is 4G LTE chip.
This driver supports GCT reference platform as a USB device.

Signed-off-by: Won Kang <wonkang@gctsemi.com>
---
 drivers/staging/Kconfig              |    2 +
 drivers/staging/Makefile             |    1 +
 drivers/staging/gdm724x/Kconfig      |    9 +
 drivers/staging/gdm724x/Makefile     |    9 +
 drivers/staging/gdm724x/TODO         |    2 +
 drivers/staging/gdm724x/gdm_endian.c |   69 ++
 drivers/staging/gdm724x/gdm_endian.h |   49 ++
 drivers/staging/gdm724x/gdm_lte.c    | 1152 ++++++++++++++++++++++++++++++++++
 drivers/staging/gdm724x/gdm_lte.h    |   93 +++
 drivers/staging/gdm724x/gdm_mux.c    |  789 +++++++++++++++++++++++
 drivers/staging/gdm724x/gdm_mux.h    |   77 +++
 drivers/staging/gdm724x/gdm_tty.c    |  382 +++++++++++
 drivers/staging/gdm724x/gdm_tty.h    |   63 ++
 drivers/staging/gdm724x/gdm_usb.c    | 1105 ++++++++++++++++++++++++++++++++
 drivers/staging/gdm724x/gdm_usb.h    |   92 +++
 drivers/staging/gdm724x/hci.h        |   55 ++
 drivers/staging/gdm724x/hci_packet.h |   97 +++
 drivers/staging/gdm724x/lte_ioctl.h  |   73 +++
 drivers/staging/gdm724x/netlink_k.c  |  161 +++++
 drivers/staging/gdm724x/netlink_k.h  |   25 +
 20 files changed, 4305 insertions(+)
 create mode 100644 drivers/staging/gdm724x/Kconfig
 create mode 100644 drivers/staging/gdm724x/Makefile
 create mode 100644 drivers/staging/gdm724x/TODO
 create mode 100644 drivers/staging/gdm724x/gdm_endian.c
 create mode 100644 drivers/staging/gdm724x/gdm_endian.h
 create mode 100644 drivers/staging/gdm724x/gdm_lte.c
 create mode 100644 drivers/staging/gdm724x/gdm_lte.h
 create mode 100644 drivers/staging/gdm724x/gdm_mux.c
 create mode 100644 drivers/staging/gdm724x/gdm_mux.h
 create mode 100644 drivers/staging/gdm724x/gdm_tty.c
 create mode 100644 drivers/staging/gdm724x/gdm_tty.h
 create mode 100644 drivers/staging/gdm724x/gdm_usb.c
 create mode 100644 drivers/staging/gdm724x/gdm_usb.h
 create mode 100644 drivers/staging/gdm724x/hci.h
 create mode 100644 drivers/staging/gdm724x/hci_packet.h
 create mode 100644 drivers/staging/gdm724x/lte_ioctl.h
 create mode 100644 drivers/staging/gdm724x/netlink_k.c
 create mode 100644 drivers/staging/gdm724x/netlink_k.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 57d8b34..d55bc34 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -118,6 +118,8 @@ source "drivers/staging/ozwpan/Kconfig"
 
 source "drivers/staging/gdm72xx/Kconfig"
 
+source "drivers/staging/gdm724x/Kconfig"
+
 source "drivers/staging/silicom/Kconfig"
 
 source "drivers/staging/ced1401/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 429321f..c23cf3b 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_MFD_NVEC)		+= nvec/
 obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_USB_WPAN_HCD)	+= ozwpan/
 obj-$(CONFIG_WIMAX_GDM72XX)	+= gdm72xx/
+obj-$(CONFIG_LTE_GDM724X)	+= gdm724x/
 obj-$(CONFIG_NET_VENDOR_SILICOM)	+= silicom/
 obj-$(CONFIG_CED1401)		+= ced1401/
 obj-$(CONFIG_DRM_IMX)		+= imx-drm/
diff --git a/drivers/staging/gdm724x/Kconfig b/drivers/staging/gdm724x/Kconfig
new file mode 100644
index 0000000..84b35d7
--- /dev/null
+++ b/drivers/staging/gdm724x/Kconfig
@@ -0,0 +1,9 @@
+#
+# GCT GDM724x LTE driver configuration
+#
+
+config LTE_GDM724X
+	tristate "GCT GDM724x LTE support"
+	depends on NET && USB
+	help
+	  Support for the GCT GDM724x LTE chip
diff --git a/drivers/staging/gdm724x/Makefile b/drivers/staging/gdm724x/Makefile
new file mode 100644
index 0000000..4ee5426
--- /dev/null
+++ b/drivers/staging/gdm724x/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_LTE_GDM724X) := gdmulte.o
+gdmulte-y += gdm_lte.o netlink_k.o
+gdmulte-y += gdm_usb.o gdm_endian.o
+
+obj-$(CONFIG_LTE_GDM724X) += gdmtty.o
+gdmtty-y := gdm_tty.o gdm_mux.o
+
+EXTRA_CFLAGS += -DLTE_USB_PM
+
diff --git a/drivers/staging/gdm724x/TODO b/drivers/staging/gdm724x/TODO
new file mode 100644
index 0000000..b9e1177
--- /dev/null
+++ b/drivers/staging/gdm724x/TODO
@@ -0,0 +1,2 @@
+TODO:
+- Clean up coding style to meet kernel standard.
\ No newline at end of file
diff --git a/drivers/staging/gdm724x/gdm_endian.c b/drivers/staging/gdm724x/gdm_endian.c
new file mode 100644
index 0000000..e93d88f
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_endian.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/slab.h>
+#include "gdm_endian.h"
+
+void set_endian(struct gdm_endian *ed, u8 dev_endian)
+{
+	u8 a[2] = {0x12, 0x34};
+	u8 b[2] = {0, };
+	u16 c = 0x1234;
+
+	if (dev_endian == ENDIANNESS_BIG)
+		ed->dev_ed = ENDIANNESS_BIG;
+	else
+		ed->dev_ed = ENDIANNESS_LITTLE;
+
+	memcpy(b, &c, 2);
+
+	if (a[0] != b[0])
+		ed->host_ed = ENDIANNESS_LITTLE;
+	else
+		ed->host_ed = ENDIANNESS_BIG;
+
+	printk(KERN_INFO "glte: endian host(%d) device(%d)\n",
+	       ed->host_ed, ed->dev_ed);
+}
+
+u16 H2D(struct gdm_endian *ed, u16 x)
+{
+	if (ed->dev_ed == ed->host_ed)
+		return x;
+
+	return Endian16_Swap(x);
+}
+
+u16 D2H(struct gdm_endian *ed, u16 x)
+{
+	if (ed->dev_ed == ed->host_ed)
+		return x;
+
+	return Endian16_Swap(x);
+}
+
+u32 H4D(struct gdm_endian *ed, u32 x)
+{
+	if (ed->dev_ed == ed->host_ed)
+		return x;
+
+	return Endian32_Swap(x);
+}
+
+u32 D4H(struct gdm_endian *ed, u32 x)
+{
+	if (ed->dev_ed == ed->host_ed)
+		return x;
+
+	return Endian32_Swap(x);
+}
diff --git a/drivers/staging/gdm724x/gdm_endian.h b/drivers/staging/gdm724x/gdm_endian.h
new file mode 100644
index 0000000..705a484
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_endian.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __GDM_ENDIAN_H__
+#define __GDM_ENDIAN_H__
+
+#include <linux/types.h>
+
+#define Endian16_Swap(value) \
+	((((u16)((value) & 0x00FF)) << 8) | \
+	 (((u16)((value) & 0xFF00)) >> 8))
+
+#define Endian32_Swap(value) \
+	((((u32)((value) & 0x000000FF)) << 24) | \
+	 (((u32)((value) & 0x0000FF00)) << 8) | \
+	 (((u32)((value) & 0x00FF0000)) >> 8) | \
+	 (((u32)((value) & 0xFF000000)) >> 24))
+
+enum {
+	ENDIANNESS_MIN = 0,
+	ENDIANNESS_UNKNOWN,
+	ENDIANNESS_LITTLE,
+	ENDIANNESS_BIG,
+	ENDIANNESS_MIDDLE,
+	ENDIANNESS_MAX
+};
+
+struct gdm_endian {
+	u8 dev_ed;
+	u8 host_ed;
+};
+
+void set_endian(struct gdm_endian *ed, u8 dev_endian);
+u16 H2D(struct gdm_endian *ed, u16 x);
+u16 D2H(struct gdm_endian *ed, u16 x);
+u32 H4D(struct gdm_endian *ed, u32 x);
+u32 D4H(struct gdm_endian *ed, u32 x);
+
+#endif /*__GDM_ENDIAN_H__*/
diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
new file mode 100644
index 0000000..6c24055
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_lte.c
@@ -0,0 +1,1152 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/version.h>
+#include <linux/etherdevice.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/udp.h>
+#include <linux/in.h>
+#include <linux/if_arp.h>
+#include <linux/if_ether.h>
+#include <linux/if_vlan.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/udp.h>
+#include <linux/tcp.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/uaccess.h>
+#include <net/ndisc.h>
+
+#include "gdm_lte.h"
+#include "netlink_k.h"
+#include "hci.h"
+#include "hci_packet.h"
+#include "gdm_endian.h"
+#include "lte_ioctl.h"
+
+/*
+ * Emulate ARP and NDP NS
+ */
+#define EMULATE_ARP
+#define EMULATE_NDP
+
+/*
+ * Netlink protocol number
+ */
+#define NETLINK_LTE 30
+
+/*
+ * Default MTU Size
+ */
+#define DEFAULT_MTU_SIZE 1500
+
+#define gdm_dev_endian(n) (\
+	n->phy_dev->get_endian(n->phy_dev->priv_dev))
+
+#define gdm_lte_hci_send(n, d, l) (\
+	n->phy_dev->send_hci_func(n->phy_dev->priv_dev, d, l, NULL, NULL))
+
+#define gdm_lte_sdu_send(n, d, l, c, b, i, t) (\
+	n->phy_dev->send_sdu_func(n->phy_dev->priv_dev, d, l, n->pdn_table.dft_eps_id, 0, c, b, i, t))
+
+#define gdm_lte_rcv_with_cb(n, c, b, e) (\
+	n->rcv_func(n->priv_dev, c, b, e))
+
+#define IP_VERSION_4	4
+#define IP_VERSION_6	6
+
+static struct {
+	int ref_cnt;
+	struct sock *sock;
+} lte_event;
+
+static struct device_type wwan_type = {
+	.name   = "wwan",
+};
+
+static int gdm_lte_open(struct net_device *dev)
+{
+	netif_start_queue(dev);
+	return 0;
+}
+
+static int gdm_lte_close(struct net_device *dev)
+{
+	netif_stop_queue(dev);
+	return 0;
+}
+
+static int gdm_lte_set_config(struct net_device *dev, struct ifmap *map)
+{
+	if (dev->flags & IFF_UP)
+		return -EBUSY;
+	return 0;
+}
+
+static void tx_complete(void *arg)
+{
+	struct nic *nic = arg;
+
+	if (nic == NULL) {
+		printk(KERN_ERR "glte: tx complete - invalid nic\n");
+		return;
+	}
+
+	if (netif_queue_stopped(nic->netdev))
+		netif_wake_queue(nic->netdev);
+}
+
+static int gdm_lte_rx(struct sk_buff *skb, struct nic *nic, int nic_type)
+{
+	int ret;
+
+	if (nic == NULL) {
+		printk(KERN_ERR "glte: rx - invalid nic\n");
+		return -1;
+	}
+
+	ret = netif_rx_ni(skb);
+	if (ret == NET_RX_DROP) {
+		printk(KERN_ERR "glte: rx - dropped\n");
+		nic->stats.rx_dropped++;
+	} else {
+		nic->stats.rx_packets++;
+		nic->stats.rx_bytes += skb->len + ETH_HLEN;
+	}
+
+	return 0;
+}
+
+#ifdef EMULATE_ARP
+int gdm_lte_emulate_arp(struct sk_buff *skb_in, u32 nic_type)
+{
+	struct nic *nic = netdev_priv(skb_in->dev);
+	struct sk_buff *skb_out;
+	struct ethhdr eth;
+	struct vlan_ethhdr vlan_eth;
+	struct arphdr *arp_in;
+	struct arphdr *arp_out;
+	struct arpdata {
+		u8 ar_sha[ETH_ALEN];
+		u8 ar_sip[4];
+		u8 ar_tha[ETH_ALEN];
+		u8 ar_tip[4];
+	};
+	struct arpdata *arp_data_in;
+	struct arpdata *arp_data_out;
+	u8 arp_temp[60];
+	void *mac_header_data;
+	u32 mac_header_len;
+
+	/* Format the mac header so that it can be put to skb */
+	if (ntohs(((struct ethhdr *)skb_in->data)->h_proto) == ETH_P_8021Q) {
+		memcpy(&vlan_eth, skb_in->data, sizeof(struct vlan_ethhdr));
+		mac_header_data = &vlan_eth;
+		mac_header_len = VLAN_ETH_HLEN;
+	} else {
+		memcpy(&eth, skb_in->data, sizeof(struct ethhdr));
+		mac_header_data = &eth;
+		mac_header_len = ETH_HLEN;
+	}
+
+	/* Get the pointer of the original request */
+	arp_in = (struct arphdr *)(skb_in->data + mac_header_len);
+	arp_data_in = (struct arpdata *)(skb_in->data + mac_header_len + sizeof(struct arphdr));
+
+	/* Get the pointer of the outgoing response */
+	arp_out = (struct arphdr *)arp_temp;
+	arp_data_out = (struct arpdata *)(arp_temp + sizeof(struct arphdr));
+
+	/* Copy the arp header */
+	memcpy(arp_out, arp_in, sizeof(struct arphdr));
+	arp_out->ar_op = htons(ARPOP_REPLY);
+
+	/* Copy the arp payload: based on 2 bytes of mac and fill the IP */
+	arp_data_out->ar_sha[0] = arp_data_in->ar_sha[0];
+	arp_data_out->ar_sha[1] = arp_data_in->ar_sha[1];
+	memcpy(&arp_data_out->ar_sha[2], &arp_data_in->ar_tip[0], 4);
+	memcpy(&arp_data_out->ar_sip[0], &arp_data_in->ar_tip[0], 4);
+	memcpy(&arp_data_out->ar_tha[0], &arp_data_in->ar_sha[0], 6);
+	memcpy(&arp_data_out->ar_tip[0], &arp_data_in->ar_sip[0], 4);
+
+	/* Fill the destination mac with source mac of the received packet */
+	memcpy(mac_header_data, mac_header_data + ETH_ALEN, ETH_ALEN);
+	/* Fill the source mac with nic's source mac */
+	memcpy(mac_header_data + ETH_ALEN, nic->src_mac_addr, ETH_ALEN);
+
+	/* Alloc skb and reserve align */
+	skb_out = dev_alloc_skb(skb_in->len);
+	if (!skb_out)
+		return -1;
+	skb_reserve(skb_out, NET_IP_ALIGN);
+
+	memcpy(skb_put(skb_out, mac_header_len), mac_header_data, mac_header_len);
+	memcpy(skb_put(skb_out, sizeof(struct arphdr)), arp_out, sizeof(struct arphdr));
+	memcpy(skb_put(skb_out, sizeof(struct arpdata)), arp_data_out, sizeof(struct arpdata));
+
+	skb_out->protocol = ((struct ethhdr *)mac_header_data)->h_proto;
+	skb_out->dev = skb_in->dev;
+	skb_reset_mac_header(skb_out);
+	skb_pull(skb_out, ETH_HLEN);
+
+	gdm_lte_rx(skb_out, nic, nic_type);
+
+	return 0;
+}
+#endif
+
+#ifdef EMULATE_NDP
+int icmp6_checksum(struct ipv6hdr *ipv6, u16 *ptr, int len)
+{
+	unsigned short *w = ptr;
+	int sum = 0;
+	int i;
+
+	#pragma pack(1)
+	union {
+		struct {
+			u8 ph_src[16];
+			u8 ph_dst[16];
+			u32 ph_len;
+			u8 ph_zero[3];
+			u8 ph_nxt;
+		} ph;
+		u16 pa[20];
+	} pseudo_header;
+	#pragma pack()
+
+	memset(&pseudo_header, 0, sizeof(pseudo_header));
+	memcpy(&pseudo_header.ph.ph_src, &ipv6->saddr.in6_u.u6_addr8, 16);
+	memcpy(&pseudo_header.ph.ph_dst, &ipv6->daddr.in6_u.u6_addr8, 16);
+	pseudo_header.ph.ph_len = ipv6->payload_len;
+	pseudo_header.ph.ph_nxt = ipv6->nexthdr;
+
+	w = (u16 *)&pseudo_header;
+	for (i = 0; i < sizeof(pseudo_header.pa) / sizeof(pseudo_header.pa[0]); i++)
+		sum += pseudo_header.pa[i];
+
+	w = ptr;
+	while (len > 1) {
+		sum += *w++;
+		len -= 2;
+	}
+
+	sum = (sum >> 16) + (sum & 0xFFFF);
+	sum += (sum >> 16);
+	sum = ~sum & 0xffff;
+
+	return sum;
+}
+
+int gdm_lte_emulate_ndp(struct sk_buff *skb_in, u32 nic_type)
+{
+	struct nic *nic = netdev_priv(skb_in->dev);
+	struct sk_buff *skb_out;
+	struct ethhdr eth;
+	struct vlan_ethhdr vlan_eth;
+	struct neighbour_advertisement {
+		u8 target_address[16];
+		u8 type;
+		u8 length;
+		u8 link_layer_address[6];
+	};
+	struct neighbour_advertisement na;
+	struct neighbour_solicitation {
+		u8 target_address[16];
+	};
+	struct neighbour_solicitation *ns;
+	struct ipv6hdr *ipv6_in;
+	struct ipv6hdr ipv6_out;
+	struct icmp6hdr *icmp6_in;
+	struct icmp6hdr icmp6_out;
+
+	void *mac_header_data;
+	u32 mac_header_len;
+
+	/* Format the mac header so that it can be put to skb */
+	if (ntohs(((struct ethhdr *)skb_in->data)->h_proto) == ETH_P_8021Q) {
+		memcpy(&vlan_eth, skb_in->data, sizeof(struct vlan_ethhdr));
+		if (ntohs(vlan_eth.h_vlan_encapsulated_proto) != ETH_P_IPV6)
+			return -1;
+		mac_header_data = &vlan_eth;
+		mac_header_len = VLAN_ETH_HLEN;
+	} else {
+		memcpy(&eth, skb_in->data, sizeof(struct ethhdr));
+		if (ntohs(eth.h_proto) != ETH_P_IPV6)
+			return -1;
+		mac_header_data = &eth;
+		mac_header_len = ETH_HLEN;
+	}
+
+
+	/* Check if this is IPv6 ICMP packet */
+	ipv6_in = (struct ipv6hdr *)(skb_in->data + mac_header_len);
+	if (ipv6_in->version != 6 || ipv6_in->nexthdr != IPPROTO_ICMPV6)
+		return -1;
+
+	/* Check if this is NDP packet */
+	icmp6_in = (struct icmp6hdr *)(skb_in->data + mac_header_len + sizeof(struct ipv6hdr));
+	if (icmp6_in->icmp6_type == NDISC_ROUTER_SOLICITATION) { /* Check RS */
+		return -1;
+	} else if (icmp6_in->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) { /* Check NS */
+		u8 icmp_na[sizeof(struct icmp6hdr) + sizeof(struct neighbour_advertisement)];
+		u8 zero_addr8[16] = {0,};
+
+		if (memcmp(ipv6_in->saddr.in6_u.u6_addr8, zero_addr8, 16) == 0)
+			/* Duplicate Address Detection: Source IP is all zero */
+			return 0;
+
+		icmp6_out.icmp6_type = NDISC_NEIGHBOUR_ADVERTISEMENT;
+		icmp6_out.icmp6_code = 0;
+		icmp6_out.icmp6_cksum = 0;
+		icmp6_out.icmp6_dataun.un_data32[0] = htonl(0x60000000); /* R=0, S=1, O=1 */
+
+		ns = (struct neighbour_solicitation *)(skb_in->data + mac_header_len + sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr));
+		memcpy(&na.target_address, ns->target_address, 16);
+		na.type = 0x02;
+		na.length = 1;
+		na.link_layer_address[0] = 0x00;
+		na.link_layer_address[1] = 0x0a;
+		na.link_layer_address[2] = 0x3b;
+		na.link_layer_address[3] = 0xaf;
+		na.link_layer_address[4] = 0x63;
+		na.link_layer_address[5] = 0xc7;
+
+		memcpy(&ipv6_out, ipv6_in, sizeof(struct ipv6hdr));
+		memcpy(ipv6_out.saddr.in6_u.u6_addr8, &na.target_address, 16);
+		memcpy(ipv6_out.daddr.in6_u.u6_addr8, ipv6_in->saddr.in6_u.u6_addr8, 16);
+		ipv6_out.payload_len = htons(sizeof(struct icmp6hdr) + sizeof(struct neighbour_advertisement));
+
+		memcpy(icmp_na, &icmp6_out, sizeof(struct icmp6hdr));
+		memcpy(icmp_na + sizeof(struct icmp6hdr), &na, sizeof(struct neighbour_advertisement));
+
+		icmp6_out.icmp6_cksum = icmp6_checksum(&ipv6_out, (u16 *)icmp_na, sizeof(icmp_na));
+	} else {
+		return -1;
+	}
+
+	/* Fill the destination mac with source mac of the received packet */
+	memcpy(mac_header_data, mac_header_data + ETH_ALEN, ETH_ALEN);
+	/* Fill the source mac with nic's source mac */
+	memcpy(mac_header_data + ETH_ALEN, nic->src_mac_addr, ETH_ALEN);
+
+	/* Alloc skb and reserve align */
+	skb_out = dev_alloc_skb(skb_in->len);
+	if (!skb_out)
+		return -1;
+	skb_reserve(skb_out, NET_IP_ALIGN);
+
+	memcpy(skb_put(skb_out, mac_header_len), mac_header_data, mac_header_len);
+	memcpy(skb_put(skb_out, sizeof(struct ipv6hdr)), &ipv6_out, sizeof(struct ipv6hdr));
+	memcpy(skb_put(skb_out, sizeof(struct icmp6hdr)), &icmp6_out, sizeof(struct icmp6hdr));
+	memcpy(skb_put(skb_out, sizeof(struct neighbour_advertisement)), &na, sizeof(struct neighbour_advertisement));
+
+	skb_out->protocol = ((struct ethhdr *)mac_header_data)->h_proto;
+	skb_out->dev = skb_in->dev;
+	skb_reset_mac_header(skb_out);
+	skb_pull(skb_out, ETH_HLEN);
+
+	gdm_lte_rx(skb_out, nic, nic_type);
+
+	return 0;
+}
+#endif
+
+static s32 gdm_lte_tx_nic_type(struct net_device *dev, struct sk_buff *skb)
+{
+	struct nic *nic = netdev_priv(dev);
+	struct ethhdr *eth;
+	struct vlan_ethhdr *vlan_eth;
+	struct iphdr *ip;
+	struct ipv6hdr *ipv6;
+	int mac_proto;
+	void *network_data;
+	u32 nic_type = 0;
+
+	if (nic == NULL)
+		return -1;
+
+	if (nic->nic_id >= MAX_NIC_TYPE)
+		return -1;
+
+	/* NIC TYPE is based on the nic_id of this net_device */
+	nic_type = 0x00000010 | nic->nic_id;
+
+	/* Get ethernet protocol */
+	eth = (struct ethhdr *)skb->data;
+	if (ntohs(eth->h_proto) == ETH_P_8021Q) {
+		vlan_eth = (struct vlan_ethhdr *)skb->data;
+		mac_proto = ntohs(vlan_eth->h_vlan_encapsulated_proto);
+		network_data = skb->data + VLAN_ETH_HLEN;
+		nic_type |= NIC_TYPE_F_VLAN;
+	} else {
+		mac_proto = ntohs(eth->h_proto);
+		network_data = skb->data + ETH_HLEN;
+	}
+
+	/* Process packet for nic type */
+	switch (mac_proto) {
+	case ETH_P_ARP:
+		nic_type |= NIC_TYPE_ARP;
+		break;
+	case ETH_P_IP:
+		nic_type |= NIC_TYPE_F_IPV4;
+		ip = (struct iphdr *)network_data;
+
+		/* Check DHCPv4 */
+		if (ip->protocol == IPPROTO_UDP) {
+			struct udphdr *udp = (struct udphdr *)(network_data + sizeof(struct iphdr));
+			if (ntohs(udp->dest) == 67 || ntohs(udp->dest) == 68)
+				nic_type |= NIC_TYPE_F_DHCP;
+		}
+		break;
+	case ETH_P_IPV6:
+		nic_type |= NIC_TYPE_F_IPV6;
+		ipv6 = (struct ipv6hdr *)network_data;
+
+		if (ipv6->nexthdr == IPPROTO_ICMPV6) /* Check NDP request */ {
+			struct icmp6hdr *icmp6 = (struct icmp6hdr *)(network_data + sizeof(struct ipv6hdr));
+			if (/*icmp6->icmp6_type == NDISC_ROUTER_SOLICITATION || */
+				icmp6->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION)
+				nic_type |= NIC_TYPE_ICMPV6;
+		} else if (ipv6->nexthdr == IPPROTO_UDP) /* Check DHCPv6 */ {
+			struct udphdr *udp = (struct udphdr *)(network_data + sizeof(struct ipv6hdr));
+			if (ntohs(udp->dest) == 546 || ntohs(udp->dest) == 547)
+				nic_type |= NIC_TYPE_F_DHCP;
+		}
+		break;
+	default:
+		return -1;
+		break;
+	}
+
+	return nic_type;
+}
+
+static int gdm_lte_tx(struct sk_buff *skb, struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	u32 nic_type;
+	void *data_buf;
+	int data_len;
+	int idx;
+	int ret = 0;
+
+	nic_type = gdm_lte_tx_nic_type(dev, skb);
+	if (nic_type == 0) {
+		printk(KERN_ERR "glte: tx - invalid nic_type\n");
+		return -1;
+	}
+
+#ifdef EMULATE_ARP
+	if (nic_type & NIC_TYPE_ARP) {
+		if (gdm_lte_emulate_arp(skb, nic_type) == 0) {
+			dev_kfree_skb(skb);
+			return 0;
+		}
+	}
+#endif
+
+#ifdef EMULATE_NDP
+	if (nic_type & NIC_TYPE_ICMPV6) {
+		if (gdm_lte_emulate_ndp(skb, nic_type) == 0) {
+			dev_kfree_skb(skb);
+			return 0;
+		}
+	}
+#endif
+
+	/*
+	Need byte shift (that is, remove VLAN tag) if there is one
+	For the case of ARP, this breaks the offset as vlan_ethhdr+4 is treated as ethhdr
+	However, it shouldn't be a problem as the reponse starts from arp_hdr and ethhdr
+	is created by this driver based on the NIC mac
+	*/
+	if (nic_type & NIC_TYPE_F_VLAN) {
+		struct vlan_ethhdr *vlan_eth = (struct vlan_ethhdr *)skb->data;
+		nic->vlan_id = ntohs(vlan_eth->h_vlan_TCI) & VLAN_VID_MASK;
+		data_buf = skb->data + (VLAN_ETH_HLEN - ETH_HLEN);
+		data_len = skb->len - (VLAN_ETH_HLEN - ETH_HLEN);
+	} else {
+		nic->vlan_id = 0;
+		data_buf = skb->data;
+		data_len = skb->len;
+	}
+
+	/* If it is a ICMPV6 packet, clear all the other bits : for backward compatibilty with the firmware */
+	if (nic_type & NIC_TYPE_ICMPV6)
+		nic_type = NIC_TYPE_ICMPV6;
+
+	/* If it is not a dhcp packet, clear all the flag bits : original NIC, otherwise the special flag (IPVX | DHCP) */
+	if (!(nic_type & NIC_TYPE_F_DHCP))
+		nic_type &= NIC_TYPE_MASK;
+
+	sscanf(dev->name, "lte%d", &idx);
+
+	ret = gdm_lte_sdu_send(nic,
+			       data_buf,
+			       data_len,
+			       tx_complete,
+			       nic,
+			       idx,
+			       nic_type);
+
+	if (ret == TX_NO_BUFFER || ret == TX_NO_SPC) {
+		netif_stop_queue(dev);
+		if (ret == TX_NO_BUFFER)
+			ret = 0;
+		else
+			ret = -ENOSPC;
+	} else if (ret == TX_NO_DEV) {
+		ret = -ENODEV;
+	}
+
+	/* Updates tx stats */
+	if (ret) {
+		printk(KERN_ERR "glte: tx - sending sdu failed\n");
+		nic->stats.tx_dropped++;
+	} else {
+		nic->stats.tx_packets++;
+		nic->stats.tx_bytes += data_len;
+	}
+	dev_kfree_skb(skb);
+
+	return 0;
+}
+
+static struct net_device_stats *gdm_lte_stats(struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	return &nic->stats;
+}
+
+static void get_network_statics(struct data_t *data, struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	struct phy_dev *pdev = nic->phy_dev;
+	unsigned char *buf;
+	struct net_info_t *net_stats;
+	struct net_info_t *net_stats_requested = (struct net_info_t *)data->buf;
+	int i;
+	unsigned long ret;
+
+	buf = kmalloc(sizeof(*net_stats), GFP_KERNEL);
+	if (!buf)
+		return;
+
+	memset(buf, 0, sizeof(*net_stats));
+
+	net_stats = (struct net_info_t *)buf;
+	net_stats->nic_index = net_stats_requested->nic_index;
+
+	if (net_stats->nic_index > MAX_NIC_TYPE) {
+		printk(KERN_INFO "glte: stats - invalid nic_index\n");
+		kfree(buf);
+		return;
+	}
+
+	if (net_stats->nic_index == MAX_NIC_TYPE) {
+		for (i = 0; i < MAX_NIC_TYPE; i++) {
+			nic = netdev_priv(pdev->dev[i]);
+			net_stats->stats.tx_packets += nic->stats.tx_packets;
+			net_stats->stats.tx_bytes += nic->stats.tx_bytes;
+			net_stats->stats.tx_dropped += nic->stats.tx_dropped;
+			net_stats->stats.rx_packets += nic->stats.rx_packets;
+			net_stats->stats.rx_bytes += nic->stats.rx_bytes;
+			net_stats->stats.rx_dropped += nic->stats.rx_dropped;
+		}
+	} else {
+		nic = netdev_priv(pdev->dev[net_stats->nic_index]);
+		net_stats->stats.tx_packets = nic->stats.tx_packets;
+		net_stats->stats.tx_bytes = nic->stats.tx_bytes;
+		net_stats->stats.tx_dropped = nic->stats.tx_dropped;
+		net_stats->stats.rx_packets = nic->stats.rx_packets;
+		net_stats->stats.rx_bytes = nic->stats.rx_bytes;
+		net_stats->stats.rx_dropped = nic->stats.rx_dropped;
+	}
+
+	ret = copy_to_user(data->buf, buf, sizeof(*net_stats));
+	if (ret)
+		printk(KERN_INFO "glte: state - failed to copy\n");
+	kfree(buf);
+}
+
+static int get_ver(u8 *src, u8 *dst)
+{
+	u8 tmp_buf[4] = {0,};
+	int i = 0;
+
+	while (1) {
+		if (dst[i] < '0' || dst[i] > '9')
+			break;
+
+		tmp_buf[i] = dst[i] % 0x30;
+		i++;
+	}
+
+	if (i == 1)
+		*src = tmp_buf[0];
+	else if (i == 2)
+		*src = (tmp_buf[0] * 10) + tmp_buf[1];
+	else if (i == 3)
+		*src = (tmp_buf[0] * 100) + (tmp_buf[1] * 10) + tmp_buf[3];
+
+	return i;
+}
+
+static void get_driver_version(struct data_t *data, struct net_device *dev)
+{
+	u8 ver[16] = {0,};
+	u8 drv_ver[4] = {0,};
+	int i = 0;
+	int j = 0;
+	unsigned long ret;
+
+	memcpy(ver, DRIVER_VERSION, sizeof(DRIVER_VERSION));
+
+	while (i < sizeof(DRIVER_VERSION)) {
+		if (ver[i] != '.') {
+			i += get_ver(&drv_ver[j], &ver[i]);
+			j++;
+		} else {
+			i++;
+		}
+
+		if (j == 4)
+			break;
+	}
+
+	ret = copy_to_user(data->buf, drv_ver, sizeof(drv_ver));
+	if (ret)
+		printk(KERN_INFO "glte: state - failed to copy\n");
+}
+
+static void get_dev_endian(struct data_t *data, struct net_device *dev)
+{
+	struct nic *nic = netdev_priv(dev);
+	unsigned long ret;
+	
+	ret = copy_to_user(data->buf, gdm_dev_endian(nic), sizeof(struct dev_endian_t));
+	if (ret)
+		printk(KERN_INFO "glte: state - failed to copy\n");
+}
+
+static int gdm_lte_ioctl_get_data(struct wm_req_t *req, struct net_device *dev)
+{
+	u16 id = req->data_id;
+
+	switch (id) {
+	case GET_NETWORK_STATICS:
+		get_network_statics(&req->data, dev);
+		break;
+	case GET_DRV_VER:
+		get_driver_version(&req->data, dev);
+		break;
+	case GET_ENDIAN_INFO:
+		get_dev_endian(&req->data, dev);
+		break;
+	default:
+		printk(KERN_ERR "glte: ioctl - unknown type %d\n", id);
+		break;
+	}
+	return 0;
+}
+
+static int gdm_lte_ioctl_set_data(struct wm_req_t *req, struct net_device *dev)
+{
+	u16 id = req->data_id;
+
+	switch (id) {
+	case LINK_ON:
+		netif_carrier_on(dev);
+		break;
+	case LINK_OFF:
+		netif_carrier_off(dev);
+		break;
+	}
+
+	return 0;
+}
+
+static int gdm_lte_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	struct wm_req_t *req = (struct wm_req_t *)ifr;
+
+	if (cmd != SIOCLTEIOCTL)
+		return -EOPNOTSUPP;
+
+	switch (req->cmd) {
+	case SIOCG_DATA:
+	case SIOCS_DATA:
+		if (req->data_id >= 100)
+			return -EOPNOTSUPP;
+		if (req->cmd == SIOCG_DATA)
+			gdm_lte_ioctl_get_data(req, dev);
+		else if (req->cmd == SIOCS_DATA)
+			gdm_lte_ioctl_set_data(req, dev);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int gdm_lte_event_send(struct net_device *dev, char *buf, int len)
+{
+	struct nic *nic = netdev_priv(dev);
+	struct hci_packet *hci = (struct hci_packet *)buf;
+	int idx;
+
+#ifdef DEBUG
+	printk(KERN_DEBUG "glte: D=>H: 0x%04x(%d) len %d\n",
+	       D2H(gdm_dev_endian(nic), hci->cmd_evt),
+	       D2H(gdm_dev_endian(nic), hci->len),
+	       len);
+#endif
+
+	sscanf(dev->name, "lte%d", &idx);
+
+	return netlink_send(lte_event.sock, idx, 0, buf,
+			    D2H(gdm_dev_endian(nic), hci->len) + HCI_HEADER_SIZE);
+}
+
+static void gdm_lte_event_rcv(struct net_device *dev, u16 type, void *msg, int len)
+{
+	struct nic *nic = netdev_priv(dev);
+
+#ifdef DEBUG
+	struct hci_packet *hci = (struct hci_packet *)msg;
+	printk(KERN_DEBUG, "glte: H=>D: 0x%04x(%d) len %d\n",
+	       D2H(gdm_dev_endian(nic), hci->cmd_evt),
+	       D2H(gdm_dev_endian(nic), hci->len),
+	       len);
+#endif
+
+	gdm_lte_hci_send(nic, msg, len);
+}
+
+int gdm_lte_event_init(void)
+{
+	if (lte_event.ref_cnt == 0)
+		lte_event.sock = netlink_init(NETLINK_LTE, gdm_lte_event_rcv);
+
+	if (lte_event.sock) {
+		lte_event.ref_cnt++;
+		return 0;
+	}
+
+	printk(KERN_ERR "glte: event init failed\n");
+	return -1;
+}
+
+void gdm_lte_event_exit(void)
+{
+	if (lte_event.sock && --lte_event.ref_cnt == 0) {
+		netlink_exit(lte_event.sock);
+		lte_event.sock = NULL;
+	}
+}
+
+static int find_dev_index(u32 nic_type)
+{
+	int index;
+
+	index = nic_type & 0x0000000f;
+	if (index > MAX_NIC_TYPE || index < 0)
+		index = 0;
+
+	return index;
+}
+
+static void gdm_lte_netif_rx(struct net_device *dev, char *buf, int len, int flagged_nic_type)
+{
+	u32 nic_type;
+	struct nic *nic;
+	struct sk_buff *skb;
+	struct ethhdr eth;
+	struct vlan_ethhdr vlan_eth;
+	void *mac_header_data;
+	u32 mac_header_len;
+	char ip_version = 0;
+
+	nic_type = flagged_nic_type & NIC_TYPE_MASK;
+	nic = netdev_priv(dev);
+	if (nic == NULL) {
+		printk(KERN_ERR "glte: rx, invalid nic\n");
+		return;
+	}
+	if (flagged_nic_type & NIC_TYPE_F_DHCP) {
+		/* Change the destination mac address with the one requested the IP */
+		if (flagged_nic_type & NIC_TYPE_F_IPV4) {
+			struct dhcp_packet {
+				u8 op;      /* BOOTREQUEST or BOOTREPLY */
+				u8 htype;   /* hardware address type. 1 = 10mb ethernet */
+				u8 hlen;    /* hardware address length */
+				u8 hops;    /* used by relay agents only */
+				u32 xid;    /* unique id */
+				u16 secs;   /* elapsed since client began acquisition/renewal */
+				u16 flags;  /* only one flag so far: */
+				#define BROADCAST_FLAG 0x8000 /* "I need broadcast replies" */
+				u32 ciaddr; /* client IP (if client is in BOUND, RENEW or REBINDING state) */
+				u32 yiaddr; /* 'your' (client) IP address */
+				/* IP address of next server to use in bootstrap, returned in DHCPOFFER, DHCPACK by server */
+				u32 siaddr_nip;
+				u32 gateway_nip; /* relay agent IP address */
+				u8 chaddr[16];   /* link-layer client hardware address (MAC) */
+				u8 sname[64];    /* server host name (ASCIZ) */
+				u8 file[128];    /* boot file name (ASCIZ) */
+				u32 cookie;      /* fixed first four option bytes (99,130,83,99 dec) */
+			} __packed;
+
+			#define DHCP_V4_HW_ADDR_OFFSET	(\
+				sizeof(struct iphdr) + \
+				sizeof(struct udphdr) + \
+				offsetof(struct dhcp_packet, chaddr))
+			#define DHCP_V4_IP_ADDR_OFFSET (\
+				sizeof(struct iphdr) + \
+				sizeof(struct udphdr) + \
+				offsetof(struct dhcp_packet, yiaddr))
+
+			memcpy(nic->dest_mac_addr, buf + DHCP_V4_HW_ADDR_OFFSET, 6);
+		} else if (flagged_nic_type & NIC_TYPE_F_IPV6) {
+			printk(KERN_INFO "glte: DHCPv6 not supported yet\n");
+		}
+	}
+
+	if (nic->vlan_id > 0) {
+		mac_header_data = (void *)&vlan_eth;
+		mac_header_len = VLAN_ETH_HLEN;
+	} else {
+		mac_header_data = (void *)&eth;
+		mac_header_len = ETH_HLEN;
+	}
+
+	/* Format the data so that it can be put to skb */
+	memcpy(mac_header_data, nic->dest_mac_addr, ETH_ALEN);
+	memcpy(mac_header_data + ETH_ALEN, nic->src_mac_addr, ETH_ALEN);
+
+	vlan_eth.h_vlan_TCI = htons(nic->vlan_id);
+	vlan_eth.h_vlan_proto = htons(ETH_P_8021Q);
+
+	if (nic_type == NIC_TYPE_ARP) {
+		/* Should be response: Only happens because there was a request from the host */
+		eth.h_proto = htons(ETH_P_ARP);
+		vlan_eth.h_vlan_encapsulated_proto = htons(ETH_P_ARP);
+	} else {
+		ip_version = buf[0] >> 4;
+		if (ip_version == IP_VERSION_4) {
+			eth.h_proto = htons(ETH_P_IP);
+			vlan_eth.h_vlan_encapsulated_proto = htons(ETH_P_IP);
+		} else if (ip_version == IP_VERSION_6) {
+			eth.h_proto = htons(ETH_P_IPV6);
+			vlan_eth.h_vlan_encapsulated_proto = htons(ETH_P_IPV6);
+		} else {
+			printk(KERN_ERR "glte: Unknown IP version %d\n", ip_version);
+			return;
+		}
+	}
+
+	/* Alloc skb and reserve align */
+	skb = dev_alloc_skb(len + mac_header_len + NET_IP_ALIGN);
+	if (!skb)
+		return;
+	skb_reserve(skb, NET_IP_ALIGN);
+
+	memcpy(skb_put(skb, mac_header_len), mac_header_data, mac_header_len);
+	memcpy(skb_put(skb, len), buf, len);
+
+	skb->protocol = ((struct ethhdr *)mac_header_data)->h_proto;
+	skb->dev = dev;
+	skb_reset_mac_header(skb);
+	skb_pull(skb, ETH_HLEN);
+
+	gdm_lte_rx(skb, nic, nic_type);
+}
+
+static void gdm_lte_multi_sdu_pkt(struct phy_dev *phy_dev, char *buf, int len)
+{
+	struct net_device *dev;
+	struct multi_sdu *multi_sdu = (struct multi_sdu *)buf;
+	struct sdu *sdu = NULL;
+	u8 *data = (u8 *)multi_sdu->data;
+	u16 i = 0;
+	u16 num_packet;
+	u16 hci_len;
+	u16 cmd_evt;
+	u32 nic_type;
+	int index;
+
+	hci_len = D2H(phy_dev->get_endian(phy_dev->priv_dev), multi_sdu->len);
+	num_packet = D2H(phy_dev->get_endian(phy_dev->priv_dev), multi_sdu->num_packet);
+
+#ifdef DEBUG
+	printk(KERN_DEBUG "glte: rx sdu len %d, num_packet %d\n",
+	       multi_sdu->len, multi_sdu->num_packet);
+#endif
+
+	for (i = 0; i < num_packet; i++) {
+		sdu = (struct sdu *)data;
+
+		cmd_evt = D2H(phy_dev->get_endian(phy_dev->priv_dev), sdu->cmd_evt);
+		hci_len = D2H(phy_dev->get_endian(phy_dev->priv_dev), sdu->len);
+		nic_type = D4H(phy_dev->get_endian(phy_dev->priv_dev), sdu->nic_type);
+
+		if (cmd_evt != LTE_RX_SDU) {
+			printk(KERN_ERR "glte: rx sdu wrong hci %04x\n", cmd_evt);
+			return;
+		}
+		if (hci_len < 12) {
+			printk(KERN_ERR "glte: rx sdu invalid len %d\n", hci_len);
+			return;
+		}
+
+		index = find_dev_index(nic_type);
+		if (index >= 0 && index < MAX_NIC_TYPE) {
+			dev = phy_dev->dev[index];
+			gdm_lte_netif_rx(dev, (char *)sdu->data, (int)(hci_len-12), nic_type);
+		} else {
+			printk(KERN_ERR "glte: rx sdu invalid nic_type : %x\n", nic_type);
+		}
+
+		data += ((hci_len+3) & 0xfffc) + HCI_HEADER_SIZE;
+	}
+}
+
+static void gdm_lte_pdn_table(struct net_device *dev, char *buf, int len)
+{
+	struct nic *nic = netdev_priv(dev);
+	struct hci_pdn_table_ind *pdn_table = (struct hci_pdn_table_ind *)buf;
+
+	if (pdn_table->activate) {
+		nic->pdn_table.activate = pdn_table->activate;
+		nic->pdn_table.dft_eps_id = D4H(gdm_dev_endian(nic), pdn_table->dft_eps_id);
+		nic->pdn_table.nic_type = D4H(gdm_dev_endian(nic), pdn_table->nic_type);
+
+		printk(KERN_INFO "glte: pdn %s activated, nic_type=0x%x\n",
+		       dev->name, nic->pdn_table.nic_type);
+	} else {
+		memset(&nic->pdn_table, 0x00, sizeof(struct pdn_table));
+		printk(KERN_INFO "glte: pdn %s deactivated\n",
+		       dev->name);
+	}
+}
+
+static int gdm_lte_receive_pkt(struct phy_dev *phy_dev, char *buf, int len)
+{
+	struct hci_packet *hci = (struct hci_packet *)buf;
+	struct hci_pdn_table_ind *pdn_table = (struct hci_pdn_table_ind *)buf;
+	struct sdu *sdu;
+	struct net_device *dev;
+	int ret = 0;
+	u16 cmd_evt;
+	u32 nic_type;
+	int index;
+
+	if (!len)
+		return ret;
+
+	cmd_evt = D2H(phy_dev->get_endian(phy_dev->priv_dev), hci->cmd_evt);
+
+	dev = phy_dev->dev[0];
+	if (dev == NULL)
+		return 0;
+
+	switch (cmd_evt) {
+	case LTE_RX_SDU:
+		sdu = (struct sdu *)hci->data;
+		nic_type = D4H(phy_dev->get_endian(phy_dev->priv_dev), sdu->nic_type);
+		index = find_dev_index(nic_type);
+		if (index >= 0) {
+			dev = phy_dev->dev[index];
+			gdm_lte_netif_rx(dev, hci->data, len, nic_type);
+		}
+		break;
+	case LTE_RX_MULTI_SDU:
+		gdm_lte_multi_sdu_pkt(phy_dev, buf, len);
+		break;
+	case LTE_LINK_ON_OFF_INDICATION:
+		{
+			struct hci_connect_ind *connect_ind = (struct hci_connect_ind *)buf;
+			printk(KERN_INFO "glte: link %s\n",
+			       connect_ind->connect ? "on" : "off");
+		}
+		break;
+	case LTE_PDN_TABLE_IND:
+		pdn_table = (struct hci_pdn_table_ind *)buf;
+		nic_type = D4H(phy_dev->get_endian(phy_dev->priv_dev), pdn_table->nic_type);
+		index = find_dev_index(nic_type);
+		if (index >= 0) {
+			dev = phy_dev->dev[index];
+			gdm_lte_pdn_table(dev, buf, len);
+		}
+		/* Fall through */
+	default:
+		ret = gdm_lte_event_send(dev, buf, len);
+		break;
+	}
+
+	return ret;
+}
+
+static int rx_complete(void *arg, void *data, int len, int context)
+{
+	struct phy_dev *phy_dev = (struct phy_dev *)arg;
+
+	return gdm_lte_receive_pkt(phy_dev, (char *)data, len);
+}
+
+void start_rx_proc(struct phy_dev *phy_dev)
+{
+	int i;
+
+	for (i = 0; i < MAX_RX_SUBMIT_COUNT; i++)
+		gdm_lte_rcv_with_cb(phy_dev, rx_complete, phy_dev, USB_COMPLETE);
+}
+
+static struct net_device_ops gdm_netdev_ops = {
+	.ndo_open			= gdm_lte_open,
+	.ndo_stop			= gdm_lte_close,
+	.ndo_set_config			= gdm_lte_set_config,
+	.ndo_start_xmit			= gdm_lte_tx,
+	.ndo_get_stats			= gdm_lte_stats,
+	.ndo_do_ioctl			= gdm_lte_ioctl,
+};
+
+static u8 gdm_lte_macaddr[6] = {0x00, 0x0a, 0x3b, 0x00, 0x00, 0x00};
+
+static void form_mac_address(u8 *dev_addr, u8 *nic_src, u8 *nic_dest, u8 *mac_address, u8 index)
+{
+	/* Form the dev_addr */
+	if (!mac_address)
+		memcpy(dev_addr, gdm_lte_macaddr, 6);
+	else
+		memcpy(dev_addr, mac_address, 6);
+
+	/* The last byte of the mac address should be less than or equal to 0xFC */
+	dev_addr[5] = (u8) (dev_addr[5] + index);
+
+	/* Create random nic src and copy the first 3 bytes to be the same as dev_addr */
+	random_ether_addr(nic_src);
+	memcpy(nic_src, dev_addr, 3);
+
+	/* Copy the nic_dest from dev_addr*/
+	memcpy(nic_dest,  dev_addr, 6);
+}
+
+static void mac_validation(u8 *mac_address)
+{
+	u8 invalid_mac = 0;
+
+	/* the mac address is not 00-00-00-00-00-00 */
+	if (
+		(mac_address[0] == 0x00) &&
+		(mac_address[1] == 0x00) &&
+		(mac_address[2] == 0x00) &&
+		(mac_address[3] == 0x00) &&
+		(mac_address[4] == 0x00) &&
+		(mac_address[5] == 0x00))
+		invalid_mac = 1;
+	/* check for multicast bit */
+	else if ((mac_address[0] & 0x01) == 0x01)
+		invalid_mac = 1;
+
+	if (invalid_mac) {
+		/* Restore the default value */
+		printk(KERN_ERR "glte: MAC invalid, restoring default\n");
+		memcpy(mac_address, gdm_lte_macaddr, 6);
+	} else {
+		printk(KERN_INFO "glte: MAC validated\n");
+	}
+}
+
+int register_lte_device(struct phy_dev *phy_dev, struct device *dev, u8 *mac_address)
+{
+	struct nic *nic;
+	struct net_device *net;
+	char pdn_dev_name[16];
+	int ret = 0;
+	u8 index;
+
+	mac_validation(mac_address);
+
+	for (index = 0; index < MAX_NIC_TYPE; index++) {
+		/* Create device name lteXpdnX */
+		sprintf(pdn_dev_name, "lte%%dpdn%d", index);
+
+		/* Allocate netdev */
+		net =  alloc_netdev(sizeof(struct nic), pdn_dev_name, ether_setup);
+		if (net == NULL) {
+			printk(KERN_ERR "glte: alloc_netdev failed\n");
+			ret = -1;
+			break;
+		}
+
+		/* Configure device */
+
+		net->netdev_ops = &gdm_netdev_ops;
+		net->flags &= ~IFF_MULTICAST;
+		net->mtu = DEFAULT_MTU_SIZE;
+
+		/* Configure nic */
+		nic = netdev_priv(net);
+		memset(nic, 0, sizeof(struct nic));
+		nic->netdev = net;
+		nic->phy_dev = phy_dev;
+		nic->nic_id = index;
+
+		form_mac_address(
+				net->dev_addr,
+				nic->src_mac_addr,
+				nic->dest_mac_addr,
+				mac_address,
+				index);
+
+		SET_NETDEV_DEV(net, dev);
+		SET_NETDEV_DEVTYPE(net, &wwan_type);
+
+		ret = register_netdev(net);
+		if (ret) {
+			printk(KERN_ERR "glte: register %s failed\n", net->name);
+			free_netdev(net);
+			break;
+		}
+
+		netif_carrier_on(net);
+
+		phy_dev->dev[index] = net;
+
+		printk(KERN_INFO "glte: register %s\n", net->name);
+	}
+
+	return 0;
+}
+
+void unregister_lte_device(struct phy_dev *phy_dev)
+{
+	struct net_device *net;
+	int index;
+
+	for (index = MAX_NIC_TYPE-1; index >= 0; index--) {
+		net = phy_dev->dev[index];
+		if (net == NULL)
+			continue;
+
+		printk(KERN_INFO "glte: unregister %s\n", net->name);
+
+		unregister_netdev(net);
+		free_netdev(net);
+	}
+}
diff --git a/drivers/staging/gdm724x/gdm_lte.h b/drivers/staging/gdm724x/gdm_lte.h
new file mode 100644
index 0000000..61f62d6
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_lte.h
@@ -0,0 +1,93 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _GDM_LTE_H_
+#define _GDM_LTE_H_
+
+#include <linux/netdevice.h>
+#include <linux/version.h>
+#include <linux/types.h>
+
+#include "gdm_endian.h"
+
+#ifndef __packed
+#define __packed __attribute__((packed))
+#endif
+
+#define SPBC_PATH		"GCT_LTE_MBL.bin"
+#define SIMG_PATH		"signed_app.bin"
+
+#define MAX_NIC_TYPE		4
+#define MAX_RX_SUBMIT_COUNT	3
+#define MAX_FILE_PATH		260
+#define DRIVER_VERSION		"3.7.17.0"
+
+#define H2L(x)		__cpu_to_le16(x)
+#define L2H(x)		__le16_to_cpu(x)
+#define H4L(x)		__cpu_to_le32(x)
+#define L4H(x)		__le32_to_cpu(x)
+
+enum TX_ERROR_CODE {
+	TX_NO_ERROR = 0,
+	TX_NO_DEV,
+	TX_NO_SPC,
+	TX_NO_BUFFER,
+};
+
+enum CALLBACK_CONTEXT {
+	KERNEL_THREAD = 0,
+	USB_COMPLETE,
+};
+
+struct pdn_table {
+	u8 activate;
+	u32 dft_eps_id;
+	u32 nic_type;
+} __packed;
+
+struct nic;
+
+struct phy_dev {
+	void	*priv_dev;
+	struct net_device *dev[MAX_NIC_TYPE];
+	int	(*send_hci_func)(void *priv_dev, void *data, int len,
+			void (*cb)(void *cb_data), void *cb_data);
+	int	(*send_sdu_func)(void *priv_dev, void *data, int len,
+			unsigned int dftEpsId, unsigned int epsId,
+			void (*cb)(void *cb_data), void *cb_data,
+			int dev_idx, int nic_type);
+	int	(*rcv_func)(void *priv_dev,
+			int (*cb)(void *cb_data, void *data, int len, int context),
+			void *cb_data, int context);
+	struct gdm_endian *(*get_endian)(void *priv_dev);
+};
+
+struct nic {
+	struct net_device *netdev;
+	struct phy_dev *phy_dev;
+	struct net_device_stats stats;
+	struct pdn_table pdn_table;
+	u8 dest_mac_addr[6];
+	u8 src_mac_addr[6];
+	u32 nic_id;
+	u16 vlan_id;
+};
+
+int gdm_lte_event_init(void);
+void gdm_lte_event_exit(void);
+
+void start_rx_proc(struct phy_dev *phy_dev);
+int register_lte_device(struct phy_dev *phy_dev, struct device *dev, u8 *mac_address);
+void unregister_lte_device(struct phy_dev *phy_dev);
+
+#endif /* _GDM_LTE_H_ */
diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
new file mode 100644
index 0000000..7908fb7
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_mux.c
@@ -0,0 +1,789 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/usb.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/slab.h>
+#include <linux/usb/cdc.h>
+
+#include "gdm_mux.h"
+#include "gdm_tty.h"
+
+#ifdef LTE_USB_PM
+#define PM_NORMAL 0
+#define PM_SUSPEND 1
+#endif /* LTE_USB_PM */
+
+#define USB_RT_ACM          (USB_TYPE_CLASS | USB_RECIP_INTERFACE)
+
+#define START_FLAG 0xA512485A
+#define MUX_HEADER_SIZE 14
+#define MUX_RX_MAX_SIZE (1024*30)
+#define AT_PKT_TYPE 0xF011
+#define DM_PKT_TYPE 0xF010
+
+#define RETRY_TIMER 30 /* msec */
+
+struct workqueue_struct *mux_rx_wq;
+
+
+static u16 PACKET_TYPE[TTY_MAX_COUNT] = {0xF011, 0xF010};
+
+#define USB_DEVICE_CDC_DATA(vid, pid) \
+	.match_flags = \
+		USB_DEVICE_ID_MATCH_DEVICE |\
+		USB_DEVICE_ID_MATCH_INT_CLASS |\
+		USB_DEVICE_ID_MATCH_INT_SUBCLASS,\
+	.idVendor = vid,\
+	.idProduct = pid,\
+	.bInterfaceClass = USB_CLASS_COMM,\
+	.bInterfaceSubClass = USB_CDC_SUBCLASS_ACM
+
+static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE_CDC_DATA(0x1076, 0x8000) }, /* GCT GDM7240 */
+	{ USB_DEVICE_CDC_DATA(0x1076, 0x8f00) }, /* GCT GDM7243 */
+	{ USB_DEVICE_CDC_DATA(0x1076, 0x9000) }, /* GCT GDM7243 */
+	{ USB_DEVICE_CDC_DATA(0x1d74, 0x2300) }, /* LGIT Phoenix */
+	{}
+};
+
+
+MODULE_DEVICE_TABLE(usb, id_table);
+
+int PacketTypeToIndex(u16 packetType)
+{
+	int i;
+
+	for (i = 0; i < TTY_MAX_COUNT; i++) {
+		if (PACKET_TYPE[i] == packetType)
+			return i;
+	}
+
+	printk(KERN_ERR "glte: invalid packet type:%d\n", packetType);
+
+	return -1;
+}
+
+static struct mux_tx *alloc_mux_tx(int len)
+{
+	struct mux_tx *t = NULL;
+	int ret = 0;
+
+
+	t = kmalloc(sizeof(struct mux_tx), GFP_ATOMIC);
+	if (!t) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memset(t, 0, sizeof(struct mux_tx));
+
+	t->urb = usb_alloc_urb(0, GFP_ATOMIC);
+	t->buf = kmalloc(1024*10, GFP_ATOMIC);
+	if (!t->urb || !t->buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+out:
+
+	if (ret < 0) {
+		if (t) {
+			usb_free_urb(t->urb);
+			kfree(t->buf);
+			kfree(t);
+		}
+
+		return NULL;
+	}
+
+	return t;
+}
+
+static void free_mux_tx(struct mux_tx *t)
+{
+	if (t) {
+		usb_free_urb(t->urb);
+		kfree(t->buf);
+		kfree(t);
+	}
+}
+
+static struct mux_rx *alloc_mux_rx(void)
+{
+	struct mux_rx *r = NULL;
+	int ret = 0;
+
+
+	r = kmalloc(sizeof(struct mux_rx), GFP_ATOMIC);
+	if (!r) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	r->urb = usb_alloc_urb(0, GFP_ATOMIC);
+	r->buf = kmalloc(MUX_RX_MAX_SIZE, GFP_ATOMIC);
+	if (!r->urb || !r->buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+out:
+
+	if (ret < 0) {
+		if (r) {
+			usb_free_urb(r->urb);
+			kfree(r->buf);
+			kfree(r);
+		}
+
+		return NULL;
+	}
+
+	return r;
+}
+
+static void free_mux_rx(struct mux_rx *r)
+{
+	if (r) {
+		usb_free_urb(r->urb);
+		kfree(r->buf);
+		kfree(r);
+	}
+}
+
+static struct mux_rx *get_rx_struct(struct rx_cxt *rx)
+{
+	struct mux_rx *r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rx->free_list_lock, flags);
+
+	if (list_empty(&rx->rx_free_list)) {
+		spin_unlock_irqrestore(&rx->free_list_lock, flags);
+		return NULL;
+	}
+
+	r = list_entry(rx->rx_free_list.prev, struct mux_rx, free_list);
+	list_del(&r->free_list);
+
+	spin_unlock_irqrestore(&rx->free_list_lock, flags);
+
+	return r;
+}
+
+static void put_rx_struct(struct rx_cxt *rx, struct mux_rx *r)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rx->free_list_lock, flags);
+	list_add_tail(&r->free_list, &rx->rx_free_list);
+	spin_unlock_irqrestore(&rx->free_list_lock, flags);
+}
+
+
+static int up_to_host(struct mux_rx *r)
+{
+	struct mux_dev *mux_dev = (struct mux_dev *)r->mux_dev;
+	struct mux_pkt_header *mux_header = NULL;
+	unsigned int start_flag;
+	unsigned int payload_size;
+	unsigned short packet_type;
+	int remain;
+	int dummy_cnt;
+	u32 packet_size_sum = r->offset;
+	u8 *buf;
+	int index;
+	int ret = 0;
+	int len = r->len;
+
+	while (1) {
+		mux_header =
+			(struct mux_pkt_header *)(r->buf + packet_size_sum);
+		start_flag = L4H(mux_header->start_flag);
+		payload_size = L4H(mux_header->payload_size);
+		packet_type = L2H(mux_header->packet_type);
+
+		if (start_flag != START_FLAG) {
+			printk(KERN_ERR "glte: invalid START_FLAG %x\n",
+				start_flag);
+			break;
+		}
+
+		remain = (MUX_HEADER_SIZE + payload_size) % 4;
+		dummy_cnt = remain ? (4-remain) : 0;
+
+		if (len - packet_size_sum <
+			MUX_HEADER_SIZE + payload_size + dummy_cnt) {
+			printk(KERN_ERR "glte: invalid payload : %d %d %04x\n",
+			       payload_size, len,
+			       packet_type
+			       );
+			break;
+		}
+
+		index = PacketTypeToIndex(packet_type);
+		if (index < 0) {
+			printk(KERN_ERR "glte: invalid index %d\n", index);
+			break;
+		}
+
+		buf = (u8 *)(mux_header);
+		ret = r->callback((void *)&buf[MUX_HEADER_SIZE],
+				payload_size,
+				index,
+				mux_dev->minor[index],
+				RECV_PACKET_PROCESS_CONTINUE
+				);
+		if (ret == TO_HOST_BUFFER_REQUEST_FAIL) {
+			r->offset += packet_size_sum;
+			break;
+		}
+
+		packet_size_sum += MUX_HEADER_SIZE + payload_size + dummy_cnt;
+
+		if (len - packet_size_sum <= MUX_HEADER_SIZE + 2) {
+			ret = r->callback((void *)NULL,
+					0,
+					index,
+					mux_dev->minor[index],
+					RECV_PACKET_PROCESS_COMPLETE
+					);
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static void do_rx(struct work_struct *work)
+{
+	struct mux_dev *mux_dev =
+		container_of(work, struct mux_dev , work_rx.work);
+	struct mux_rx *r;
+	struct rx_cxt *rx = (struct rx_cxt *)&mux_dev->rx;
+	unsigned long flags;
+	int ret = 0;
+
+	while (1) {
+		spin_lock_irqsave(&rx->to_host_lock, flags);
+		if (list_empty(&rx->to_host_list)) {
+			spin_unlock_irqrestore(&rx->to_host_lock, flags);
+			break;
+		}
+		r = list_entry(rx->to_host_list.next, struct mux_rx, to_host_list);
+		list_del(&r->to_host_list);
+		spin_unlock_irqrestore(&rx->to_host_lock, flags);
+
+		ret = up_to_host(r);
+		if (ret == TO_HOST_BUFFER_REQUEST_FAIL)
+			printk(KERN_ERR "glte: failed to send mux data to host\n");
+		else
+			put_rx_struct(rx, r);
+	}
+}
+
+static void remove_rx_submit_list(struct mux_rx *r, struct rx_cxt *rx)
+{
+	unsigned long flags;
+	struct mux_rx	*r_remove, *r_remove_next;
+
+	spin_lock_irqsave(&rx->submit_list_lock, flags);
+	list_for_each_entry_safe(r_remove, r_remove_next, &rx->rx_submit_list, rx_submit_list)
+	{
+		if (r == r_remove)
+			list_del(&r->rx_submit_list);
+	}
+	spin_unlock_irqrestore(&rx->submit_list_lock, flags);
+}
+
+static void gdm_mux_rcv_complete(struct urb *urb)
+{
+	struct mux_rx *r = urb->context;
+	struct mux_dev *mux_dev = (struct mux_dev *)r->mux_dev;
+	struct rx_cxt *rx = &mux_dev->rx;
+	unsigned long flags;
+
+	remove_rx_submit_list(r, rx);
+
+	if (urb->status) {
+#ifdef LTE_USB_PM
+		if (mux_dev->usb_state == PM_NORMAL)
+			printk(KERN_ERR "glte: gdm_mux_rcv_complete urb status error %d\n", urb->status);
+#else
+		printk(KERN_ERR "glte: gdm_mux_rcv_complete urb status error %d\n", urb->status);
+#endif /* LTE_USB_PM */
+
+		put_rx_struct(rx, r);
+	} else {
+		r->len = r->urb->actual_length;
+
+		spin_lock_irqsave(&rx->to_host_lock, flags);
+		list_add_tail(&r->to_host_list, &rx->to_host_list);
+		queue_work(mux_rx_wq, &mux_dev->work_rx.work);
+		spin_unlock_irqrestore(&rx->to_host_lock, flags);
+	}
+}
+
+static int gdm_mux_recv(void *priv_dev,
+			int (*cb)(void *data, int len, int tty_index, int minor, int complete)
+			)
+{
+	struct mux_dev *mux_dev = priv_dev;
+	struct usb_device *usbdev = mux_dev->usbdev;
+	struct mux_rx *r;
+	struct rx_cxt *rx = &mux_dev->rx;
+	unsigned long flags;
+	int ret;
+
+	if (!usbdev) {
+		printk(KERN_ERR "glte: Device is Disconnect\n");
+		return -ENODEV;
+	}
+
+	r = get_rx_struct(rx);
+	if (!r) {
+		printk(KERN_ERR "glte: alloc_rx_struct fail\n");
+		return -ENOMEM;
+	}
+
+	r->offset = 0;
+	r->mux_dev = (void *)mux_dev;
+	r->callback = cb;
+#ifdef LTE_USB_PM
+	mux_dev->rx_cb = cb;
+#endif /* LTE_USB_PM */
+
+	usb_fill_bulk_urb(r->urb,
+			  usbdev,
+			  usb_rcvbulkpipe(usbdev, 0x86),
+			  r->buf,
+			  MUX_RX_MAX_SIZE,
+			  gdm_mux_rcv_complete,
+			  r);
+
+	spin_lock_irqsave(&rx->submit_list_lock, flags);
+	list_add_tail(&r->rx_submit_list, &rx->rx_submit_list);
+	spin_unlock_irqrestore(&rx->submit_list_lock, flags);
+
+	ret = usb_submit_urb(r->urb, GFP_KERNEL);
+
+	if (ret) {
+		spin_lock_irqsave(&rx->submit_list_lock, flags);
+		list_del(&r->rx_submit_list);
+		spin_unlock_irqrestore(&rx->submit_list_lock, flags);
+
+		put_rx_struct(rx, r);
+
+		printk(KERN_ERR "glte: usb_submit_urb ret=%d\n", ret);
+	}
+
+#ifdef LTE_USB_PM
+	usb_mark_last_busy(usbdev);
+#endif /* LTE_USB_PM */
+
+	return ret;
+}
+
+static void gdm_mux_send_complete(struct urb *urb)
+{
+	struct mux_tx *t = urb->context;
+
+	if (urb->status == -ECONNRESET) {
+		printk(KERN_INFO "glte: CONNRESET\n");
+		free_mux_tx(t);
+		return;
+	}
+
+	if (t->callback)
+		t->callback(t->cb_data);
+
+	free_mux_tx(t);
+}
+
+static int gdm_mux_send(void *priv_dev, void *data, int len, int tty_index,
+			void (*cb)(void *data), void *cb_data)
+{
+	struct mux_dev *mux_dev = priv_dev;
+	struct usb_device *usbdev = mux_dev->usbdev;
+	struct mux_pkt_header *mux_header;
+	struct mux_tx *t = NULL;
+	static u32 seq_num = 1;
+	int remain;
+	int dummy_cnt;
+	int total_len;
+	int ret;
+	unsigned long flags;
+
+#ifdef LTE_USB_PM
+	if (mux_dev->usb_state == PM_SUSPEND) {
+		ret = usb_autopm_get_interface(mux_dev->intf);
+		if (!ret)
+			usb_autopm_put_interface(mux_dev->intf);
+	}
+#endif /* LTE_USB_PM */
+
+	spin_lock_irqsave(&mux_dev->write_lock, flags);
+
+	remain = (MUX_HEADER_SIZE + len) % 4;
+	dummy_cnt = remain ? (4 - remain) : 0;
+
+	total_len = len + MUX_HEADER_SIZE + dummy_cnt;
+
+	t = alloc_mux_tx(total_len);
+	if (!t) {
+		printk(KERN_ERR "glte: alloc_mux_tx fail\n");
+		spin_unlock_irqrestore(&mux_dev->write_lock, flags);
+		return -ENOMEM;
+	}
+
+	mux_header = (struct mux_pkt_header *)t->buf;
+	mux_header->start_flag = H4L(START_FLAG);
+	mux_header->seq_num = H4L(seq_num++);
+	mux_header->payload_size = H4L((u32)len);
+	mux_header->packet_type = H2L(PACKET_TYPE[tty_index]);
+
+	memcpy(t->buf+MUX_HEADER_SIZE, data, len);
+	memset(t->buf+MUX_HEADER_SIZE+len, 0, dummy_cnt);
+
+	t->len = total_len;
+	t->callback = cb;
+	t->cb_data = cb_data;
+
+	usb_fill_bulk_urb(t->urb,
+			  usbdev,
+			  usb_sndbulkpipe(usbdev, 5),
+			  t->buf,
+			  total_len,
+			  gdm_mux_send_complete,
+			  t);
+
+	ret = usb_submit_urb(t->urb, GFP_KERNEL);
+
+	spin_unlock_irqrestore(&mux_dev->write_lock, flags);
+
+	if (ret)
+		printk(KERN_ERR "glte: usb_submit_urb Error : %d\n", ret);
+
+#ifdef LTE_USB_PM
+	usb_mark_last_busy(usbdev);
+#endif /* LTE_USB_PM */
+
+	return ret;
+}
+
+static int gdm_mux_send_control(void *priv_dev, int request, int value, void *buf, int len)
+{
+	struct mux_dev *mux_dev = priv_dev;
+	struct usb_device *usbdev = mux_dev->usbdev;
+	int ret;
+
+	ret = usb_control_msg(usbdev,
+			      usb_sndctrlpipe(usbdev, 0),
+			      request,
+			      USB_RT_ACM,
+			      value,
+			      2,
+			      buf,
+			      len,
+			      5000
+			     );
+
+	if (ret < 0)
+		printk(KERN_ERR "glte: usb_control_msg error : %d\n", ret);
+
+	return ret < 0 ? ret : 0;
+}
+
+static void release_usb(struct mux_dev *mux_dev)
+{
+	struct rx_cxt		*rx = &mux_dev->rx;
+	struct mux_rx		*r, *r_next;
+	unsigned long		flags;
+
+	cancel_delayed_work(&mux_dev->work_rx);
+
+	spin_lock_irqsave(&rx->submit_list_lock, flags);
+	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list, rx_submit_list)
+	{
+		spin_unlock_irqrestore(&rx->submit_list_lock, flags);
+		usb_kill_urb(r->urb);
+		spin_lock_irqsave(&rx->submit_list_lock, flags);
+	}
+	spin_unlock_irqrestore(&rx->submit_list_lock, flags);
+
+	spin_lock_irqsave(&rx->free_list_lock, flags);
+	list_for_each_entry_safe(r, r_next, &rx->rx_free_list, free_list)
+	{
+		list_del(&r->free_list);
+		free_mux_rx(r);
+	}
+	spin_unlock_irqrestore(&rx->free_list_lock, flags);
+
+	spin_lock_irqsave(&rx->to_host_lock, flags);
+	list_for_each_entry_safe(r, r_next, &rx->to_host_list, to_host_list)
+	{
+		if (r->mux_dev == (void *)mux_dev) {
+			list_del(&r->to_host_list);
+			free_mux_rx(r);
+		}
+	}
+	spin_unlock_irqrestore(&rx->to_host_lock, flags);
+}
+
+
+static int init_usb(struct mux_dev *mux_dev)
+{
+	struct mux_rx *r;
+	struct rx_cxt *rx = &mux_dev->rx;
+	int ret = 0;
+	int i;
+	unsigned long flags;
+
+	spin_lock_init(&mux_dev->write_lock);
+	INIT_LIST_HEAD(&rx->to_host_list);
+	INIT_LIST_HEAD(&rx->rx_submit_list);
+	INIT_LIST_HEAD(&rx->rx_free_list);
+	spin_lock_init(&rx->to_host_lock);
+	spin_lock_init(&rx->submit_list_lock);
+	spin_lock_init(&rx->free_list_lock);
+
+	for (i = 0; i < MAX_ISSUE_NUM*2; i++) {
+		r = alloc_mux_rx();
+		if (r == NULL) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		spin_lock_irqsave(&rx->free_list_lock, flags);
+		list_add(&r->free_list, &rx->rx_free_list);
+		spin_unlock_irqrestore(&rx->free_list_lock, flags);
+	}
+
+	INIT_DELAYED_WORK(&mux_dev->work_rx, do_rx);
+
+	return ret;
+}
+
+static int gdm_mux_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	struct mux_dev *mux_dev = NULL;
+	struct tty_dev *tty_dev = NULL;
+	u16 idVendor, idProduct;
+	int bInterfaceNumber;
+	int ret = 0;
+	int i;
+	struct usb_device *usbdev = interface_to_usbdev(intf);
+	bInterfaceNumber = intf->cur_altsetting->desc.bInterfaceNumber;
+
+	idVendor = L2H(usbdev->descriptor.idVendor);
+	idProduct = L2H(usbdev->descriptor.idProduct);
+
+	printk(KERN_INFO "glte: mux vid = 0x%04x pid = 0x%04x\n",
+	       idVendor, idProduct);
+
+	if (bInterfaceNumber != 2) {
+		ret = -1;
+		goto out;
+	}
+
+	mux_dev = kmalloc(sizeof(struct mux_dev), GFP_KERNEL);
+	if (!mux_dev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	tty_dev = kmalloc(sizeof(struct tty_dev), GFP_KERNEL);
+	if (!tty_dev) {
+		kfree(mux_dev);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memset(mux_dev, 0, sizeof(struct mux_dev));
+	memset(tty_dev, 0, sizeof(struct tty_dev));
+
+	mux_dev->usbdev = usbdev;
+	mux_dev->control_intf = intf;
+
+	ret = init_usb(mux_dev);
+	if (ret < 0)
+		goto out;
+
+	tty_dev->priv_dev = (void *)mux_dev;
+	tty_dev->send_func = gdm_mux_send;
+	tty_dev->recv_func = gdm_mux_recv;
+	tty_dev->send_control = gdm_mux_send_control;
+
+	if (register_lte_tty_device(tty_dev, &intf->dev) < 0) {
+		unregister_lte_tty_device(tty_dev);
+		mux_dev = tty_dev->priv_dev;
+
+		ret = -1;
+		goto out;
+	}
+	for (i = 0; i < TTY_MAX_COUNT; i++)
+		mux_dev->minor[i] = tty_dev->minor[i];
+
+out:
+
+	if (ret >= 0) {
+#ifdef LTE_USB_PM
+		mux_dev->intf = intf;
+		mux_dev->usb_state = PM_NORMAL;
+#endif /* LTE_USB_PM */
+	} else {
+		kfree(tty_dev);
+
+		if (mux_dev) {
+			release_usb(mux_dev);
+			kfree(mux_dev);
+		}
+	}
+
+	usb_get_dev(usbdev);
+	usb_set_intfdata(intf, tty_dev);
+
+	return ret;
+}
+
+static void gdm_mux_disconnect(struct usb_interface *intf)
+{
+	struct tty_dev *tty_dev;
+	struct mux_dev *mux_dev;
+	struct usb_device *usbdev = interface_to_usbdev(intf);
+
+	tty_dev = usb_get_intfdata(intf);
+
+	mux_dev = tty_dev->priv_dev;
+
+	release_usb(mux_dev);
+	unregister_lte_tty_device(tty_dev);
+
+	kfree(mux_dev);
+	mux_dev = NULL;
+
+	kfree(tty_dev);
+	tty_dev = NULL;
+
+	usb_put_dev(usbdev);
+}
+
+#ifdef LTE_USB_PM
+static int gdm_mux_suspend(struct usb_interface *intf, pm_message_t pm_msg)
+{
+	struct tty_dev *tty_dev;
+	struct mux_dev *mux_dev;
+	struct rx_cxt *rx;
+	struct mux_rx *r, *r_next;
+	unsigned long flags;
+
+	/* printk(KERN_INFO "gdm_mux_suspend\n"); */
+
+	tty_dev = usb_get_intfdata(intf);
+	mux_dev = tty_dev->priv_dev;
+	rx = &mux_dev->rx;
+
+	if (mux_dev->usb_state != PM_NORMAL) {
+		printk(KERN_ERR "glte: usb suspend - invalid state\n");
+		return -1;
+	}
+
+	mux_dev->usb_state = PM_SUSPEND;
+
+
+	spin_lock_irqsave(&rx->submit_list_lock, flags);
+	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list, rx_submit_list) {
+		spin_unlock_irqrestore(&rx->submit_list_lock, flags);
+		usb_kill_urb(r->urb);
+		spin_lock_irqsave(&rx->submit_list_lock, flags);
+	}
+	spin_unlock_irqrestore(&rx->submit_list_lock, flags);
+
+	return 0;
+}
+
+static int gdm_mux_resume(struct usb_interface *intf)
+{
+	struct tty_dev *tty_dev;
+	struct mux_dev *mux_dev;
+	u8 i;
+
+	/* printk(KERN_INFO "gdm_mux_resume\n"); */
+
+	tty_dev = usb_get_intfdata(intf);
+	mux_dev = tty_dev->priv_dev;
+
+	if (mux_dev->usb_state != PM_SUSPEND) {
+		printk(KERN_ERR "glte: usb resume - invalid state\n");
+		return -1;
+	}
+
+	mux_dev->usb_state = PM_NORMAL;
+
+	for (i = 0;  i < MAX_ISSUE_NUM; i++)
+		gdm_mux_recv((void *)mux_dev, mux_dev->rx_cb);
+
+	return 0;
+}
+#endif /* LTE_USB_PM */
+
+static struct usb_driver gdm_mux_driver = {
+	.name = "gdm_mux",
+	.probe = gdm_mux_probe,
+	.disconnect = gdm_mux_disconnect,
+	.id_table = id_table,
+#ifdef LTE_USB_PM
+	.supports_autosuspend = 1,
+	.suspend = gdm_mux_suspend,
+	.resume = gdm_mux_resume,
+	.reset_resume = gdm_mux_resume,
+#endif /* LTE_USB_PM */
+};
+
+static int __init gdm_usb_mux_init(void)
+{
+
+	mux_rx_wq = create_workqueue("mux_rx_wq");
+	if (mux_rx_wq == NULL) {
+		printk(KERN_ERR "glte: work queue create fail");
+		return -1;
+	}
+
+	register_lte_tty_driver();
+
+	return usb_register(&gdm_mux_driver);
+}
+
+static void __exit gdm_usb_mux_exit(void)
+{
+	unregister_lte_tty_driver();
+
+	if (mux_rx_wq) {
+		flush_workqueue(mux_rx_wq);
+		destroy_workqueue(mux_rx_wq);
+	}
+
+	usb_deregister(&gdm_mux_driver);
+}
+
+module_init(gdm_usb_mux_init);
+module_exit(gdm_usb_mux_exit);
+
+MODULE_DESCRIPTION("GCT LTE TTY Device Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/gdm724x/gdm_mux.h b/drivers/staging/gdm724x/gdm_mux.h
new file mode 100644
index 0000000..8b5ebee
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_mux.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _GDM_MUX_H_
+#define _GDM_MUX_H_
+
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/list.h>
+
+#define H2L(x)		__cpu_to_le16(x)
+#define L2H(x)		__le16_to_cpu(x)
+#define H4L(x)		__cpu_to_le32(x)
+#define L4H(x)		__le32_to_cpu(x)
+
+struct mux_pkt_header {
+	unsigned int start_flag;
+	unsigned int seq_num;
+	unsigned int payload_size;
+	unsigned short packet_type;
+};
+
+struct mux_tx {
+	struct urb *urb;
+	u8 *buf;
+	int  len;
+	void (*callback)(void *cb_data);
+	void *cb_data;
+};
+
+struct mux_rx {
+	struct list_head free_list;
+	struct list_head rx_submit_list;
+	struct list_head to_host_list;
+	struct urb *urb;
+	u8 *buf;
+	void *mux_dev;
+	u32 offset;
+	u32 len;
+	int (*callback)(void *data, int len, int tty_index, int minor, int complete);
+};
+
+struct rx_cxt {
+	struct list_head to_host_list;
+	struct list_head rx_submit_list;
+	struct list_head rx_free_list;
+	spinlock_t to_host_lock;
+	spinlock_t submit_list_lock;
+	spinlock_t free_list_lock;
+};
+
+struct mux_dev {
+	struct usb_device *usbdev;
+	struct usb_interface *control_intf;
+	struct usb_interface *data_intf;
+	struct rx_cxt	rx;
+	struct delayed_work work_rx;
+#ifdef LTE_USB_PM
+	struct usb_interface *intf;
+	int usb_state;
+	int (*rx_cb)(void *data, int len, int tty_index, int minor, int complete);
+#endif /* LTE_USB_PM */
+	spinlock_t write_lock;
+	u8 minor[2];
+};
+
+#endif /* _GDM_MUX_H_ */
diff --git a/drivers/staging/gdm724x/gdm_tty.c b/drivers/staging/gdm724x/gdm_tty.c
new file mode 100644
index 0000000..130fce7
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -0,0 +1,382 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/usb/cdc.h>
+#include <linux/serial.h>
+#include "gdm_tty.h"
+
+#define GDM_TTY_MAJOR 0
+#define GDM_TTY_MINOR 32
+
+#define ACM_CTRL_DTR 0x01
+#define ACM_CTRL_RTS 0x02
+#define ACM_CTRL_DSR 0x02
+#define ACM_CTRL_RI  0x08
+#define ACM_CTRL_DCD 0x01
+
+#define WRITE_SIZE 2048
+
+#define MUX_TX_MAX_SIZE 2048
+
+#define gdm_tty_send(n, d, l, i, c, b) (\
+	n->tty_dev->send_func(n->tty_dev->priv_dev, d, l, i, c, b))
+#define gdm_tty_recv(n, c) (\
+	n->tty_dev->recv_func(n->tty_dev->priv_dev, c))
+#define gdm_tty_send_control(n, r, v, d, l) (\
+	n->tty_dev->send_control(n->tty_dev->priv_dev, r, v, d, l))
+
+#define acm_set_comm_feature(n, v)	\
+	gdm_tty_send_control(n, 0x02, v, NULL, 0)
+
+#define GDM_TTY_READY(tty_str) (tty_str && tty_str->tty_dev && tty_str->port.count)
+
+struct tty_driver *g_tty_drv[TTY_MAX_COUNT] = {NULL, };
+struct tty_str *g_tty_str[TTY_MAX_COUNT][GDM_TTY_MINOR] = {{NULL, }, };
+
+static char *DRIVER_STRING[TTY_MAX_COUNT] = {"GCTATC", "GCTDM"};
+static char *DEVICE_STRING[TTY_MAX_COUNT] = {"GCT-ATC", "GCT-DM"};
+
+static DEFINE_MUTEX(open_mutex);
+
+static struct tty_port_operations gdm_tty_port_ops = {
+};
+
+static int gdm_tty_open(struct tty_struct *tty, struct file *filp)
+{
+	struct tty_str *tty_str = NULL;
+	int i;
+	int ret = 0;
+
+	mutex_lock(&open_mutex);
+
+	for (i = 0; i < TTY_MAX_COUNT; i++) {
+		if (!strcmp(tty->driver->driver_name, DRIVER_STRING[i])) {
+			tty_str = g_tty_str[i][tty->index];
+			break;
+		}
+	}
+
+	if (!tty_str) {
+		printk(KERN_INFO "glte: no tty device\n");
+		mutex_unlock(&open_mutex);
+		return -ENODEV;
+	}
+
+	set_bit(TTY_NO_WRITE_SPLIT, &tty->flags);
+
+	tty->driver_data = tty_str;
+	tty_port_tty_set(&tty_str->port, tty);
+	tty_str->port.count++;
+	set_bit(ASYNCB_INITIALIZED, &tty_str->port.flags);
+	ret = tty_port_block_til_ready(&tty_str->port, tty, filp);
+
+	mutex_unlock(&open_mutex);
+
+	return ret;
+}
+
+static void gdm_tty_close(struct tty_struct *tty, struct file *filp)
+{
+	struct tty_str *tty_str = tty->driver_data;
+	int i;
+
+	if (!tty_str) {
+		printk(KERN_INFO "glte: tty device already close\n");
+		return;
+	}
+
+	if (tty_str->port.count != 0) {
+		tty_port_close_start(&tty_str->port, tty, filp);
+		tty_port_close_end(&tty_str->port, tty);
+
+		if (tty_str->port.count == 0)
+			tty_port_tty_set(&tty_str->port, NULL);
+			tty_str->port.tty = NULL;
+	}
+
+	if (!tty_str->tty_dev) {
+		for (i = 0; i < TTY_MAX_COUNT; i++) {
+			if (!strcmp(tty->driver->driver_name, DRIVER_STRING[i]))
+				break;
+		}
+
+		if (i < TTY_MAX_COUNT) {
+			tty_unregister_device(g_tty_drv[i], tty->index);
+			g_tty_str[i][tty->index] = NULL;
+			tty_port_tty_set(&tty_str->port, NULL);
+			kfree(tty_str);
+			printk(KERN_INFO "glte: unregister %s\n", DEVICE_STRING[i]);
+		}
+	}
+
+	tty->driver_data = NULL;
+}
+
+static int gdm_tty_recv_complete(void *data, int len, int index, int minor, int complete)
+{
+	struct tty_str *tty_str = g_tty_str[index][minor];
+	struct tty_struct *tty;
+
+	if (!GDM_TTY_READY(tty_str)) {
+		if (complete == RECV_PACKET_PROCESS_COMPLETE)
+			gdm_tty_recv(tty_str, gdm_tty_recv_complete);
+		return TO_HOST_PORT_CLOSE;
+	}
+
+	if (!data || !len)
+		goto complete_routine;
+
+	tty = tty_port_tty_get(&tty_str->port);
+
+	if (tty_buffer_request_room(tty, len) == len) {
+		tty_insert_flip_string(tty, data, len);
+		tty_flip_buffer_push(tty);
+	} else {
+		tty_kref_put(tty);
+		return TO_HOST_BUFFER_REQUEST_FAIL;
+	}
+
+	tty_kref_put(tty);
+complete_routine:
+	if (complete == RECV_PACKET_PROCESS_COMPLETE)
+		gdm_tty_recv(tty_str, gdm_tty_recv_complete);
+
+	return TO_HOST_SUCCESS;
+}
+
+static void gdm_tty_send_complete(void *arg)
+{
+	struct tty_str *tty_str = (struct tty_str *)arg;
+	struct tty_struct *tty;
+
+	return;
+
+	if (!GDM_TTY_READY(tty_str))
+		return;
+
+	tty = tty_port_tty_get(&tty_str->port);
+	tty_wakeup(tty);
+	tty_kref_put(tty);
+}
+
+static int gdm_tty_write(struct tty_struct *tty, const unsigned char *buf, int len)
+{
+	struct tty_str *tty_str = tty->driver_data;
+	int remain = len;
+	int sent_len = 0;
+	int sending_len = 0;
+
+	if (!GDM_TTY_READY(tty_str))
+		return -ENODEV;
+
+	if (!len)
+		return 0;
+
+	while (1) {
+		sending_len = remain > MUX_TX_MAX_SIZE ? MUX_TX_MAX_SIZE : remain;
+		gdm_tty_send(tty_str,
+			     (void *)(buf+sent_len),
+			     sending_len,
+			     tty_str->tty_drv_index,
+			     gdm_tty_send_complete,
+			     tty_str
+			    );
+		sent_len += sending_len;
+		remain -= sending_len;
+		if (remain <= 0)
+			break;
+	}
+
+	return len;
+}
+
+static int gdm_tty_write_room(struct tty_struct *tty)
+{
+	struct tty_str *tty_str = tty->driver_data;
+
+	if (!GDM_TTY_READY(tty_str))
+		return -ENODEV;
+
+	return WRITE_SIZE;
+}
+
+static int gdm_tty_tiocmget(struct tty_struct *tty)
+{
+	struct tty_str *tty_str = tty->driver_data;
+
+	if (!GDM_TTY_READY(tty_str))
+		return -ENODEV;
+
+	return (0 & ACM_CTRL_DTR ? TIOCM_DTR : 0) |
+	       (0 & ACM_CTRL_RTS ? TIOCM_RTS : 0) |
+	       (0 & ACM_CTRL_DSR ? TIOCM_DSR : 0) |
+	       (0 & ACM_CTRL_RI  ? TIOCM_RI  : 0) |
+	       (0 & ACM_CTRL_DCD ? TIOCM_CD  : 0) |
+	       TIOCM_CTS;
+}
+
+static int gdm_tty_tiocmset(struct tty_struct *tty, unsigned int set, unsigned int clear)
+{
+	struct tty_str *tty_str = tty->driver_data;
+
+	if (!GDM_TTY_READY(tty_str))
+		return -ENODEV;
+
+	return 1;
+}
+
+int register_lte_tty_device(struct tty_dev *tty_dev, struct device *dev)
+{
+	struct tty_str *tty_str;
+	u8 i, j;
+
+	for (i = 0; i < TTY_MAX_COUNT; i++) {
+		for (j = 0; j < GDM_TTY_MINOR; j++) {
+			if (!g_tty_str[i][j])
+				break;
+		}
+
+		if (j == GDM_TTY_MINOR) {
+			tty_dev->minor[i] = j;
+			return -1;
+		}
+
+		tty_str = kmalloc(sizeof(struct tty_str), GFP_KERNEL);
+		if (!tty_str)
+			return -ENOMEM;
+
+		g_tty_str[i][j] = tty_str;
+
+		tty_str->tty_dev = tty_dev;
+		tty_str->tty_drv_index = i;
+		tty_dev->minor[i] = j;
+		tty_port_init(&tty_str->port);
+		tty_str->port.ops = &gdm_tty_port_ops;
+
+		if (strcmp(DEVICE_STRING[i], "GCT-ATC") != 0)
+			dev = NULL;
+		tty_register_device(g_tty_drv[i], j, dev);
+
+		printk(KERN_INFO "glte: register %s\n", DEVICE_STRING[i]);
+	}
+
+	acm_set_comm_feature(tty_str, 1);
+
+	for (i = 0; i < MAX_ISSUE_NUM; i++)
+		gdm_tty_recv(tty_str, gdm_tty_recv_complete);
+
+	return 0;
+}
+
+void unregister_lte_tty_device(struct tty_dev *tty_dev)
+{
+	struct tty_str *tty_str;
+	struct tty_struct *tty;
+	int i;
+
+	for (i = 0; i < TTY_MAX_COUNT; i++) {
+		if (tty_dev->minor[i] >= GDM_TTY_MINOR)
+			continue;
+
+		tty_str = g_tty_str[i][tty_dev->minor[i]];
+		if (!tty_str)
+			continue;
+
+		tty_str->tty_dev = NULL;
+
+		if (!tty_str->port.count) {
+			tty_unregister_device(g_tty_drv[i], tty_dev->minor[i]);
+			tty_port_tty_set(&tty_str->port, NULL);
+			kfree(tty_str);
+			g_tty_str[i][tty_dev->minor[i]] = NULL;
+			printk(KERN_INFO "glte: unregister %s\n", DEVICE_STRING[i]);
+		} else {
+			tty = tty_port_tty_get(&tty_str->port);
+			if (tty) {
+				tty_hangup(tty);
+				tty_kref_put(tty);
+			}
+		}
+	}
+}
+
+static void gdm_tty_set_termios(struct tty_struct *tty, struct ktermios *termios_old)
+{
+	return;
+}
+
+static const struct tty_operations gdm_tty_ops = {
+	.open = gdm_tty_open,
+	.close = gdm_tty_close,
+	.write = gdm_tty_write,
+	.write_room = gdm_tty_write_room,
+	.tiocmget = gdm_tty_tiocmget,
+	.tiocmset = gdm_tty_tiocmset,
+	.set_termios = gdm_tty_set_termios,
+};
+
+int register_lte_tty_driver(void)
+{
+	struct tty_driver *tty_driver = NULL;
+	int i;
+	int ret;
+
+	for (i = 0; i < TTY_MAX_COUNT; i++) {
+		tty_driver = alloc_tty_driver(GDM_TTY_MINOR);
+		if (!tty_driver) {
+			printk(KERN_ERR "glte: alloc_tty_driver fail\n");
+			return -ENOMEM;
+		}
+
+		tty_driver->owner = THIS_MODULE;
+		tty_driver->driver_name = DRIVER_STRING[i];
+		tty_driver->name = DEVICE_STRING[i];
+		tty_driver->major = GDM_TTY_MAJOR;
+		tty_driver->type = TTY_DRIVER_TYPE_SERIAL;
+		tty_driver->subtype = SERIAL_TYPE_NORMAL;
+		tty_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+		tty_driver->init_termios = tty_std_termios;
+		tty_driver->init_termios.c_cflag = B9600 | CS8 | HUPCL | CLOCAL;
+		tty_driver->init_termios.c_lflag = ISIG | ICANON | IEXTEN;
+		tty_set_operations(tty_driver, &gdm_tty_ops);
+
+		ret = tty_register_driver(tty_driver);
+
+		g_tty_drv[i] = tty_driver;
+	}
+
+	return ret;
+}
+
+void unregister_lte_tty_driver(void)
+{
+	struct tty_driver *tty_driver;
+	int i;
+
+	for (i = 0; i < TTY_MAX_COUNT; i++) {
+		tty_driver = g_tty_drv[i];
+		if (tty_driver) {
+			tty_unregister_driver(tty_driver);
+			put_tty_driver(tty_driver);
+		}
+	}
+}
diff --git a/drivers/staging/gdm724x/gdm_tty.h b/drivers/staging/gdm724x/gdm_tty.h
new file mode 100644
index 0000000..0277175
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_tty.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _GDM_TTY_H_
+#define _GDM_TTY_H_
+
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/tty.h>
+
+#define ttydev_priv(tty)	((tty)->driver_data)
+#define TTY_MAX_COUNT		2
+
+#define H2L(x)		__cpu_to_le16(x)
+#define L2H(x)		__le16_to_cpu(x)
+#define H4L(x)		__cpu_to_le32(x)
+#define L4H(x)		__le32_to_cpu(x)
+
+#define MAX_ISSUE_NUM 3
+
+enum TO_HOST_RESULT {
+	TO_HOST_SUCCESS = 0,
+	TO_HOST_BUFFER_REQUEST_FAIL = 1,
+	TO_HOST_PORT_CLOSE = 2,
+};
+
+enum RECV_PACKET_PROCESS {
+	RECV_PACKET_PROCESS_COMPLETE = 0,
+	RECV_PACKET_PROCESS_CONTINUE = 1,
+};
+
+struct tty_dev {
+	void *priv_dev;
+	int (*send_func)(void *priv_dev, void *data, int len, int tty_index,
+			void (*cb)(void *cb_data), void *cb_data);
+	int (*recv_func)(void *priv_dev, int (*cb)(void *data, int len, int tty_index, int minor, int complete));
+	int (*send_control)(void *priv_dev, int request, int value, void *data, int len);
+	u8 minor[2];
+};
+
+struct tty_str {
+	struct tty_dev *tty_dev;
+	int tty_drv_index;
+	struct tty_port port;
+};
+
+int register_lte_tty_driver(void);
+void unregister_lte_tty_driver(void);
+int register_lte_tty_device(struct tty_dev *tty_dev, struct device *dev);
+void unregister_lte_tty_device(struct tty_dev *tty_dev);
+
+#endif /* _GDM_USB_H_ */
+
diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
new file mode 100644
index 0000000..4e8d519
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -0,0 +1,1105 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/usb.h>
+#include <linux/sched.h>
+#include <linux/kthread.h>
+#include <linux/usb/cdc.h>
+#include <linux/wait.h>
+#include <linux/if_ether.h>
+#include <linux/pm_runtime.h>
+
+#include "gdm_usb.h"
+#include "gdm_lte.h"
+#include "hci.h"
+#include "hci_packet.h"
+#include "gdm_endian.h"
+
+#ifdef LTE_USB_PM
+#define PM_NORMAL 0
+#define PM_SUSPEND 1
+#define AUTO_SUSPEND_TIMER 5000 /* ms */
+#endif /* LTE_USB_PM */
+
+#define RX_BUF_SIZE		(1024*32)
+#define TX_BUF_SIZE		(1024*32)
+#define SDU_BUF_SIZE	2048
+#define MAX_SDU_SIZE	(1024*30)
+
+
+#define VID_GCT			0x1076
+#define PID_GDM7240		0x8000
+#define PID_GDM7243		0x9000
+
+#define NETWORK_INTERFACE 1
+#define USB_SC_SCSI 0x06
+#define USB_PR_BULK 0x50
+
+#define USB_DEVICE_CDC_DATA(vid, pid) \
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_CLASS | USB_DEVICE_ID_MATCH_INT_SUBCLASS,\
+	.idVendor = vid,\
+	.idProduct = pid,\
+	.bInterfaceClass = USB_CLASS_COMM,\
+	.bInterfaceSubClass = USB_CDC_SUBCLASS_ETHERNET
+
+#define USB_DEVICE_MASS_DATA(vid, pid) \
+	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | USB_DEVICE_ID_MATCH_INT_INFO,\
+	.idVendor = vid,\
+	.idProduct = pid,\
+	.bInterfaceSubClass = USB_SC_SCSI, \
+	.bInterfaceClass = USB_CLASS_MASS_STORAGE,\
+	.bInterfaceProtocol = USB_PR_BULK
+
+static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE_CDC_DATA(VID_GCT, PID_GDM7240) }, /* GCT GDM7240 */
+	{ USB_DEVICE_CDC_DATA(VID_GCT, PID_GDM7243) }, /* GCT GDM7243 */
+	{ }
+};
+
+MODULE_DEVICE_TABLE(usb, id_table);
+
+static struct workqueue_struct *usb_tx_wq;
+static struct workqueue_struct *usb_rx_wq;
+
+static void do_tx(struct work_struct *work);
+static void do_rx(struct work_struct *work);
+
+static int gdm_usb_recv(void *priv_dev,
+			int (*cb)(void *cb_data, void *data, int len, int context),
+			void *cb_data,
+			int context);
+
+static int request_mac_address(struct lte_udev *udev)
+{
+	u8 buf[16] = {0,};
+	struct hci_packet *hci = (struct hci_packet *)buf;
+	struct usb_device *usbdev = udev->usbdev;
+	int actual;
+	int ret = -1;
+
+	hci->cmd_evt = H2D(&udev->gdm_ed, LTE_GET_INFORMATION);
+	hci->len = H2D(&udev->gdm_ed, 1);
+	hci->data[0] = MAC_ADDRESS;
+
+	ret = usb_bulk_msg(usbdev, usb_sndbulkpipe(usbdev, 2), buf, 5,
+		     &actual, 1000);
+
+	udev->request_mac_addr = 1;
+
+	return ret;
+}
+
+static struct usb_tx *alloc_tx_struct(int len)
+{
+	struct usb_tx *t = NULL;
+	int ret = 0;
+
+	t = kmalloc(sizeof(struct usb_tx), GFP_ATOMIC);
+	if (!t) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memset(t, 0, sizeof(struct usb_tx));
+
+	t->urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!(len % 512))
+		len++;
+
+	t->buf = kmalloc(len, GFP_ATOMIC);
+	if (!t->urb || !t->buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+out:
+	if (ret < 0) {
+		if (t) {
+			usb_free_urb(t->urb);
+			kfree(t->buf);
+			kfree(t);
+		}
+		return NULL;
+	}
+
+	return t;
+}
+
+static struct usb_tx_sdu *alloc_tx_sdu_struct(void)
+{
+	struct usb_tx_sdu *t_sdu = NULL;
+	int ret = 0;
+
+
+	t_sdu = kmalloc(sizeof(struct usb_tx_sdu), GFP_ATOMIC);
+	if (!t_sdu) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memset(t_sdu, 0, sizeof(struct usb_tx_sdu));
+
+	t_sdu->buf = kmalloc(SDU_BUF_SIZE, GFP_ATOMIC);
+	if (!t_sdu->buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+out:
+
+	if (ret < 0) {
+		if (t_sdu) {
+			kfree(t_sdu->buf);
+			kfree(t_sdu);
+		}
+		return NULL;
+	}
+
+	return t_sdu;
+}
+
+static void free_tx_struct(struct usb_tx *t)
+{
+	if (t) {
+		usb_free_urb(t->urb);
+		kfree(t->buf);
+		kfree(t);
+	}
+}
+
+static void free_tx_sdu_struct(struct usb_tx_sdu *t_sdu)
+{
+	if (t_sdu) {
+		kfree(t_sdu->buf);
+		kfree(t_sdu);
+	}
+}
+
+static struct usb_tx_sdu *get_tx_sdu_struct(struct tx_cxt *tx, int *no_spc)
+{
+	struct usb_tx_sdu *t_sdu;
+
+	if (list_empty(&tx->free_list))
+		return NULL;
+
+	t_sdu = list_entry(tx->free_list.next, struct usb_tx_sdu, list);
+	list_del(&t_sdu->list);
+
+	tx->avail_count--;
+
+	*no_spc = list_empty(&tx->free_list) ? 1 : 0;
+
+	return t_sdu;
+}
+
+static void put_tx_struct(struct tx_cxt *tx, struct usb_tx_sdu *t_sdu)
+{
+	list_add_tail(&t_sdu->list, &tx->free_list);
+	tx->avail_count++;
+}
+
+static struct usb_rx *alloc_rx_struct(void)
+{
+	struct usb_rx *r = NULL;
+	int ret = 0;
+
+	r = kmalloc(sizeof(struct usb_rx), GFP_ATOMIC);
+	if (!r) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	r->urb = usb_alloc_urb(0, GFP_ATOMIC);
+	r->buf = kmalloc(RX_BUF_SIZE, GFP_ATOMIC);
+	if (!r->urb || !r->buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+out:
+
+	if (ret < 0) {
+		if (r) {
+			usb_free_urb(r->urb);
+			kfree(r->buf);
+			kfree(r);
+		}
+		return NULL;
+	}
+
+	return r;
+}
+
+static void free_rx_struct(struct usb_rx *r)
+{
+	if (r) {
+		usb_free_urb(r->urb);
+		kfree(r->buf);
+		kfree(r);
+	}
+}
+
+static struct usb_rx *get_rx_struct(struct rx_cxt *rx, int *no_spc)
+{
+	struct usb_rx *r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rx->rx_lock, flags);
+
+	if (list_empty(&rx->free_list)) {
+		spin_unlock_irqrestore(&rx->rx_lock, flags);
+		return NULL;
+	}
+
+	r = list_entry(rx->free_list.next, struct usb_rx, free_list);
+	list_del(&r->free_list);
+
+	rx->avail_count--;
+
+	*no_spc = list_empty(&rx->free_list) ? 1 : 0;
+
+	spin_unlock_irqrestore(&rx->rx_lock, flags);
+
+	return r;
+}
+
+static void put_rx_struct(struct rx_cxt *rx, struct usb_rx *r)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rx->rx_lock, flags);
+
+	list_add_tail(&r->free_list, &rx->free_list);
+	rx->avail_count++;
+
+	spin_unlock_irqrestore(&rx->rx_lock, flags);
+}
+
+static void release_usb(struct lte_udev *udev)
+{
+	struct rx_cxt	*rx = &udev->rx;
+	struct tx_cxt	*tx = &udev->tx;
+	struct usb_tx	*t, *t_next;
+	struct usb_rx	*r, *r_next;
+	struct usb_tx_sdu	*t_sdu, *t_sdu_next;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	list_for_each_entry_safe(t_sdu, t_sdu_next, &tx->sdu_list, list)
+	{
+		list_del(&t_sdu->list);
+		free_tx_sdu_struct(t_sdu);
+	}
+
+	list_for_each_entry_safe(t, t_next, &tx->hci_list, list)
+	{
+		list_del(&t->list);
+		free_tx_struct(t);
+	}
+
+	list_for_each_entry_safe(t_sdu, t_sdu_next, &tx->free_list, list)
+	{
+		list_del(&t_sdu->list);
+		free_tx_sdu_struct(t_sdu);
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	spin_lock_irqsave(&rx->submit_lock, flags);
+	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list, rx_submit_list)
+	{
+		spin_unlock_irqrestore(&rx->submit_lock, flags);
+		usb_kill_urb(r->urb);
+		spin_lock_irqsave(&rx->submit_lock, flags);
+	}
+	spin_unlock_irqrestore(&rx->submit_lock, flags);
+
+	spin_lock_irqsave(&rx->rx_lock, flags);
+	list_for_each_entry_safe(r, r_next, &rx->free_list, free_list)
+	{
+		list_del(&r->free_list);
+		free_rx_struct(r);
+	}
+	spin_unlock_irqrestore(&rx->rx_lock, flags);
+
+	spin_lock_irqsave(&rx->to_host_lock, flags);
+	list_for_each_entry_safe(r, r_next, &rx->to_host_list, to_host_list)
+	{
+		if (r->index == (void *)udev) {
+			list_del(&r->to_host_list);
+			free_rx_struct(r);
+		}
+	}
+	spin_unlock_irqrestore(&rx->to_host_lock, flags);
+}
+
+static int init_usb(struct lte_udev *udev)
+{
+#define MAX_NUM_SDU_BUF	64
+	int ret = 0;
+	int i;
+	struct tx_cxt *tx = &udev->tx;
+	struct rx_cxt *rx = &udev->rx;
+	struct usb_tx_sdu *t_sdu = NULL;
+	struct usb_rx *r = NULL;
+	unsigned long flags;
+
+	udev->send_complete = 1;
+	udev->tx_stop = 0;
+	udev->request_mac_addr = 0;
+
+#ifdef LTE_USB_PM
+	udev->usb_state = PM_NORMAL;
+#endif /* LTE_USB_PM */
+
+
+	INIT_LIST_HEAD(&tx->sdu_list);
+	INIT_LIST_HEAD(&tx->hci_list);
+	INIT_LIST_HEAD(&tx->free_list);
+	INIT_LIST_HEAD(&rx->rx_submit_list);
+	INIT_LIST_HEAD(&rx->free_list);
+	INIT_LIST_HEAD(&rx->to_host_list);
+	spin_lock_init(&tx->lock);
+	spin_lock_init(&rx->rx_lock);
+	spin_lock_init(&rx->submit_lock);
+	spin_lock_init(&rx->to_host_lock);
+
+	tx->avail_count = 0;
+	rx->avail_count = 0;
+
+#ifdef LTE_USB_PM
+	udev->rx_cb = NULL;
+#endif /* LTE_USB_PM */
+
+	for (i = 0; i < MAX_NUM_SDU_BUF; i++) {
+		t_sdu = alloc_tx_sdu_struct();
+		if (t_sdu == NULL) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+
+		spin_lock_irqsave(&tx->lock, flags);
+		list_add(&t_sdu->list, &tx->free_list);
+		tx->avail_count++;
+		spin_unlock_irqrestore(&tx->lock, flags);
+	}
+
+	for (i = 0; i < MAX_RX_SUBMIT_COUNT*2; i++) {
+		r = alloc_rx_struct();
+		if (r == NULL) {
+			ret = -ENOMEM;
+			goto fail;
+		}
+
+		spin_lock_irqsave(&rx->rx_lock, flags);
+		list_add(&r->free_list, &rx->free_list);
+		rx->avail_count++;
+		spin_unlock_irqrestore(&rx->rx_lock, flags);
+	}
+	INIT_DELAYED_WORK(&udev->work_tx, do_tx);
+	INIT_DELAYED_WORK(&udev->work_rx, do_rx);
+	return 0;
+fail:
+	return ret;
+}
+
+static int set_mac_address(u8 *data, void *arg)
+{
+	struct phy_dev *phy_dev = (struct phy_dev *)arg;
+	struct lte_udev *udev = phy_dev->priv_dev;
+	struct tlv *tlv = (struct tlv *)data;
+	u8 mac_address[6] = {0, };
+
+	if (tlv->type == MAC_ADDRESS && udev->request_mac_addr) {
+		memcpy(mac_address, tlv->data, tlv->len);
+
+		if (register_lte_device(phy_dev, &udev->intf->dev, mac_address) < 0)
+			printk(KERN_ERR "glte: register lte device failed\n");
+
+		udev->request_mac_addr = 0;
+
+		return 1;
+	}
+
+	return 0;
+}
+
+static void do_rx(struct work_struct *work)
+{
+	struct lte_udev *udev = container_of(work, struct lte_udev, work_rx.work);
+	struct rx_cxt *rx = &udev->rx;
+	struct usb_rx *r;
+	struct hci_packet *hci;
+	struct phy_dev *phy_dev;
+	u16 cmd_evt;
+	int ret;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&rx->to_host_lock, flags);
+		if (list_empty(&rx->to_host_list)) {
+			spin_unlock_irqrestore(&rx->to_host_lock, flags);
+			break;
+		}
+		r = list_entry(rx->to_host_list.next, struct usb_rx, to_host_list);
+		list_del(&r->to_host_list);
+		spin_unlock_irqrestore(&rx->to_host_lock, flags);
+
+		phy_dev = (struct phy_dev *)r->cb_data;
+		udev = (struct lte_udev *)phy_dev->priv_dev;
+		hci = (struct hci_packet *)r->buf;
+		cmd_evt = D2H(&udev->gdm_ed, hci->cmd_evt);
+
+		switch (cmd_evt) {
+		case LTE_GET_INFORMATION_RESULT:
+			if (set_mac_address(hci->data, r->cb_data) == 0) {
+				ret = r->callback(r->cb_data,
+						  r->buf,
+						  r->urb->actual_length,
+						  KERNEL_THREAD);
+			}
+			break;
+
+		default:
+			if (r->callback) {
+				ret = r->callback(r->cb_data,
+						  r->buf,
+						  r->urb->actual_length,
+						  KERNEL_THREAD);
+
+				if (ret == -EAGAIN)
+					printk(KERN_ERR "glte: failed to send received data\n");
+			}
+			break;
+		}
+
+		put_rx_struct(rx, r);
+
+		gdm_usb_recv(udev,
+			     r->callback,
+			     r->cb_data,
+			     USB_COMPLETE);
+	}
+}
+
+static void remove_rx_submit_list(struct usb_rx *r, struct rx_cxt *rx)
+{
+	unsigned long flags;
+	struct usb_rx	*r_remove, *r_remove_next;
+
+	spin_lock_irqsave(&rx->submit_lock, flags);
+	list_for_each_entry_safe(r_remove, r_remove_next, &rx->rx_submit_list, rx_submit_list)
+	{
+		if (r == r_remove) {
+			list_del(&r->rx_submit_list);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&rx->submit_lock, flags);
+}
+
+static void gdm_usb_rcv_complete(struct urb *urb)
+{
+	struct usb_rx *r = urb->context;
+	struct rx_cxt *rx = r->rx;
+	unsigned long flags;
+	struct lte_udev *udev = container_of(r->rx, struct lte_udev, rx);
+#ifdef LTE_USB_PM
+	struct usb_device *usbdev = udev->usbdev;
+#endif /* LTE_USB_PM */
+
+	remove_rx_submit_list(r, rx);
+
+	if (!urb->status && r->callback) {
+		spin_lock_irqsave(&rx->to_host_lock, flags);
+		list_add_tail(&r->to_host_list, &rx->to_host_list);
+		queue_work(usb_rx_wq, &udev->work_rx.work);
+		spin_unlock_irqrestore(&rx->to_host_lock, flags);
+	} else {
+#ifdef LTE_USB_PM
+		if (urb->status && udev->usb_state == PM_NORMAL)
+#else
+		if (urb->status)
+#endif /* LTE_USB_PM */
+			printk(KERN_ERR "glte: gdm_usb_rcv_complete urb status error %d\n", urb->status);
+
+		put_rx_struct(rx, r);
+	}
+
+#ifdef LTE_USB_PM
+	usb_mark_last_busy(usbdev);
+#endif /* LTE_USB_PM */
+
+}
+
+static int gdm_usb_recv(void *priv_dev,
+			int (*cb)(void *cb_data, void *data, int len, int context),
+			void *cb_data,
+			int context)
+{
+	struct lte_udev *udev = priv_dev;
+	struct usb_device *usbdev = udev->usbdev;
+	struct rx_cxt *rx = &udev->rx;
+	struct usb_rx *r;
+	int no_spc;
+	int ret;
+	unsigned long flags;
+
+	if (!udev->usbdev) {
+		printk(KERN_ERR "glte: invalid device\n");
+		return -ENODEV;
+	}
+
+	r = get_rx_struct(rx, &no_spc);
+	if (!r) {
+		printk(KERN_ERR "glte: Out of Memory\n");
+		return -ENOMEM;
+	}
+
+#ifdef LTE_USB_PM
+	udev->rx_cb = cb;
+#endif /* LTE_USB_PM */
+	r->callback = cb;
+	r->cb_data = cb_data;
+	r->index = (void *)udev;
+	r->rx = rx;
+
+	usb_fill_bulk_urb(r->urb,
+			  usbdev,
+			  usb_rcvbulkpipe(usbdev, 0x83),
+			  r->buf,
+			  RX_BUF_SIZE,
+			  gdm_usb_rcv_complete,
+			  r);
+
+	spin_lock_irqsave(&rx->submit_lock, flags);
+	list_add_tail(&r->rx_submit_list, &rx->rx_submit_list);
+	spin_unlock_irqrestore(&rx->submit_lock, flags);
+
+	if (context == KERNEL_THREAD)
+		ret = usb_submit_urb(r->urb, GFP_KERNEL);
+	else
+		ret = usb_submit_urb(r->urb, GFP_ATOMIC);
+
+	if (ret) {
+		spin_lock_irqsave(&rx->submit_lock, flags);
+		list_del(&r->rx_submit_list);
+		spin_unlock_irqrestore(&rx->submit_lock, flags);
+
+		printk(KERN_ERR "glte: usb_submit_urb fail (%p)\n", r);
+		put_rx_struct(rx, r);
+	}
+
+	return ret;
+}
+
+static void gdm_usb_send_complete(struct urb *urb)
+{
+	struct usb_tx *t = urb->context;
+	struct tx_cxt *tx = t->tx;
+	struct lte_udev *udev = container_of(tx, struct lte_udev, tx);
+	unsigned long flags;
+
+	if (urb->status == -ECONNRESET) {
+		printk(KERN_INFO "glte: CONNRESET\n");
+		return;
+	}
+
+	if (t->callback)
+		t->callback(t->cb_data);
+
+	free_tx_struct(t);
+
+	spin_lock_irqsave(&tx->lock, flags);
+	udev->send_complete = 1;
+	queue_work(usb_tx_wq, &udev->work_tx.work);
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static int send_tx_packet(struct usb_device *usbdev, struct usb_tx *t, u32 len)
+{
+	int ret = 0;
+
+	if (!(len%512))
+		len++;
+
+	usb_fill_bulk_urb(t->urb,
+			  usbdev,
+			  usb_sndbulkpipe(usbdev, 2),
+			  t->buf,
+			  len,
+			  gdm_usb_send_complete,
+			  t);
+
+	ret = usb_submit_urb(t->urb, GFP_ATOMIC);
+
+	if (ret)
+		printk(KERN_ERR "glte: usb_submit_urb fail %d\n", ret);
+
+#ifdef LTE_USB_PM
+	usb_mark_last_busy(usbdev);
+#endif /* LTE_USB_PM */
+
+	return ret;
+}
+
+static u32 packet_aggregation(struct lte_udev *udev, u8 *send_buf)
+{
+	struct tx_cxt *tx = &udev->tx;
+	struct usb_tx_sdu *t_sdu = NULL;
+	struct multi_sdu *multi_sdu = (struct multi_sdu *)send_buf;
+	u16 send_len = 0;
+	u16 num_packet = 0;
+	unsigned long flags;
+
+	multi_sdu->cmd_evt = H2D(&udev->gdm_ed, LTE_TX_MULTI_SDU);
+
+	while (1) {
+		spin_lock_irqsave(&tx->lock, flags);
+		if (list_empty(&tx->sdu_list)) {
+			spin_unlock_irqrestore(&tx->lock, flags);
+			break;
+		}
+		t_sdu = list_entry(tx->sdu_list.next, struct usb_tx_sdu, list);	
+		if (send_len + t_sdu->len > MAX_SDU_SIZE) {
+			spin_unlock_irqrestore(&tx->lock, flags);
+			break;
+		}
+
+		list_del(&t_sdu->list);
+		spin_unlock_irqrestore(&tx->lock, flags);
+
+		memcpy(multi_sdu->data + send_len, t_sdu->buf, t_sdu->len);
+
+		send_len += (t_sdu->len + 3) & 0xfffc;
+		num_packet++;
+
+		if (tx->avail_count > 10)
+			t_sdu->callback(t_sdu->cb_data);
+
+		spin_lock_irqsave(&tx->lock, flags);
+		put_tx_struct(tx, t_sdu);
+		spin_unlock_irqrestore(&tx->lock, flags);
+
+		if (num_packet >= 256)
+			break;
+	}
+
+	multi_sdu->len = H2D(&udev->gdm_ed, send_len);
+	multi_sdu->num_packet = H2D(&udev->gdm_ed, num_packet);
+
+	return send_len + offsetof(struct multi_sdu, data);
+}
+
+static void do_tx(struct work_struct *work)
+{
+	struct lte_udev *udev = container_of(work, struct lte_udev, work_tx.work);
+	struct usb_device *usbdev = udev->usbdev;
+	struct tx_cxt *tx = &udev->tx;
+	struct usb_tx *t = NULL;
+	int is_send = 0;
+	u32 len = 0;
+	unsigned long flags;
+#ifdef LTE_USB_PM
+	if (!usb_autopm_get_interface(udev->intf))
+		usb_autopm_put_interface(udev->intf);
+
+	if (udev->usb_state == PM_SUSPEND)
+		return;
+#endif /* LTE_USB_PM */
+
+	spin_lock_irqsave(&tx->lock, flags);
+	if (!udev->send_complete) {
+		spin_unlock_irqrestore(&tx->lock, flags);
+		return;
+	} else {
+		udev->send_complete = 0;
+	}
+
+	if (!list_empty(&tx->hci_list)) {
+		t = list_entry(tx->hci_list.next, struct usb_tx, list);
+		list_del(&t->list);
+		len = t->len;
+		t->is_sdu = 0;
+		is_send = 1;
+	} else if (!list_empty(&tx->sdu_list)) {
+		if (udev->tx_stop) {
+			udev->send_complete = 1;
+			spin_unlock_irqrestore(&tx->lock, flags);
+			return;
+		}
+
+		t = alloc_tx_struct(TX_BUF_SIZE);
+		t->callback = NULL;
+		t->tx = tx;
+		t->is_sdu = 1;
+		is_send = 1;
+	}
+
+	if (!is_send) {
+		udev->send_complete = 1;
+		spin_unlock_irqrestore(&tx->lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	if (t->is_sdu)
+		len = packet_aggregation(udev, t->buf);
+
+	if (send_tx_packet(usbdev, t, len)) {
+		printk(KERN_ERR "glte: send_tx_packet fail\n");
+		t->callback = NULL;
+		gdm_usb_send_complete(t->urb);
+	}
+}
+
+#define SDU_PARAM_LEN 12
+static int gdm_usb_sdu_send(void *priv_dev, void *data, int len,
+				unsigned int dftEpsId, unsigned int epsId,
+				void (*cb)(void *data), void *cb_data,
+			    int dev_idx, int nic_type)
+{
+	struct lte_udev *udev = priv_dev;
+	struct tx_cxt *tx = &udev->tx;
+	struct usb_tx_sdu *t_sdu;
+	struct sdu *sdu = NULL;
+	unsigned long flags;
+	int no_spc = 0;
+	u16 send_len;
+
+	if (!udev->usbdev) {
+		printk(KERN_ERR "glte: sdu send - invalid device\n");
+		return TX_NO_DEV;
+	}
+
+	spin_lock_irqsave(&tx->lock, flags);
+	t_sdu = get_tx_sdu_struct(tx, &no_spc);
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	if (t_sdu == NULL) {
+		printk(KERN_ERR "glte: sdu send - free list empty\n");
+		return TX_NO_SPC;
+	}
+
+	sdu = (struct sdu *)t_sdu->buf;
+	sdu->cmd_evt = H2D(&udev->gdm_ed, LTE_TX_SDU);
+	if (nic_type == NIC_TYPE_ARP) {
+		send_len = len + SDU_PARAM_LEN;
+	    memcpy(sdu->data, data, len);
+	} else {
+	    send_len = len - ETH_HLEN;
+	    send_len += SDU_PARAM_LEN;
+	    memcpy(sdu->data, data+ETH_HLEN, len-ETH_HLEN);
+	}
+
+	sdu->len = H2D(&udev->gdm_ed, send_len);
+	sdu->dftEpsId = H4D(&udev->gdm_ed, dftEpsId);
+	sdu->bearer_ID = H4D(&udev->gdm_ed, epsId);
+	sdu->nic_type = H4D(&udev->gdm_ed, nic_type);
+
+	t_sdu->len = send_len + HCI_HEADER_SIZE;
+	t_sdu->callback = cb;
+	t_sdu->cb_data = cb_data;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	list_add_tail(&t_sdu->list, &tx->sdu_list);
+	queue_work(usb_tx_wq, &udev->work_tx.work);
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	if (no_spc)
+		return TX_NO_BUFFER;
+
+	return 0;
+}
+
+static int gdm_usb_hci_send(void *priv_dev, void *data, int len,
+			void (*cb)(void *data), void *cb_data)
+{
+	struct lte_udev *udev = priv_dev;
+	struct tx_cxt *tx = &udev->tx;
+	struct usb_tx *t;
+	unsigned long flags;
+
+	if (!udev->usbdev) {
+		printk(KERN_ERR "glte: hci send - invalid device\n");
+		return -ENODEV;
+	}
+
+	t = alloc_tx_struct(len);
+	if (t == NULL) {
+		printk(KERN_ERR "glte: hci_send - out of memory\n");
+		return -ENOMEM;
+	}
+
+	memcpy(t->buf, data, len);
+	t->callback = cb;
+	t->cb_data = cb_data;
+	t->len = len;
+	t->tx = tx;
+	t->is_sdu = 0;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	list_add_tail(&t->list, &tx->hci_list);
+	queue_work(usb_tx_wq, &udev->work_tx.work);
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	return 0;
+}
+
+static struct gdm_endian *gdm_usb_get_endian(void *priv_dev)
+{
+	struct lte_udev *udev = priv_dev;
+
+	return &udev->gdm_ed;
+}
+
+static int gdm_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
+{
+	int ret = 0;
+	struct phy_dev *phy_dev = NULL;
+	struct lte_udev *udev = NULL;
+	u16 idVendor, idProduct;
+	int bInterfaceNumber;
+	struct usb_device *usbdev = interface_to_usbdev(intf);
+
+	bInterfaceNumber = intf->cur_altsetting->desc.bInterfaceNumber;
+	idVendor = L2H(usbdev->descriptor.idVendor);
+	idProduct = L2H(usbdev->descriptor.idProduct);
+
+	printk(KERN_INFO "glte: net vid = 0x%04x pid = 0x%04x\n", idVendor, idProduct);
+
+	if (bInterfaceNumber > NETWORK_INTERFACE) {
+		printk(KERN_INFO "glte: not a network device");
+		return -1;
+	}
+
+	phy_dev = kmalloc(sizeof(struct phy_dev), GFP_ATOMIC);
+	if (!phy_dev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	udev = kmalloc(sizeof(struct lte_udev), GFP_ATOMIC);
+	if (!udev) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memset(phy_dev, 0, sizeof(struct phy_dev));
+	memset(udev, 0, sizeof(struct lte_udev));
+
+	phy_dev->priv_dev = (void *)udev;
+	phy_dev->send_hci_func = gdm_usb_hci_send;
+	phy_dev->send_sdu_func = gdm_usb_sdu_send;
+	phy_dev->rcv_func = gdm_usb_recv;
+	phy_dev->get_endian = gdm_usb_get_endian;
+
+	udev->usbdev = usbdev;
+	ret = init_usb(udev);
+	if (ret < 0) {
+		printk(KERN_ERR "glte: init_usb func fail\n");
+		goto out;
+	}
+	udev->intf = intf;
+
+#ifdef LTE_USB_PM
+	intf->needs_remote_wakeup = 1;
+	usb_enable_autosuspend(usbdev);
+	pm_runtime_set_autosuspend_delay(&usbdev->dev, AUTO_SUSPEND_TIMER);
+#endif /* LTE_USB_PM */
+
+	/* List up hosts with big endians, otherwise, defaults to little endian */
+	if (idProduct == PID_GDM7243)
+		set_endian(&udev->gdm_ed, ENDIANNESS_BIG);
+	else
+		set_endian(&udev->gdm_ed, ENDIANNESS_LITTLE);
+
+	ret = request_mac_address(udev);
+	if (ret < 0) {
+		printk(KERN_ERR "glte: request Mac address failed\n");
+		goto out;
+	}
+
+	start_rx_proc(phy_dev);
+out:
+
+	if (ret < 0) {
+		kfree(phy_dev);
+		if (udev) {
+			release_usb(udev);
+			kfree(udev);
+		}
+	}
+
+	usb_get_dev(usbdev);
+	usb_set_intfdata(intf, phy_dev);
+
+	return ret;
+}
+
+static void gdm_usb_disconnect(struct usb_interface *intf)
+{
+	struct phy_dev *phy_dev;
+	struct lte_udev *udev;
+	u16 idVendor, idProduct;
+	struct usb_device *usbdev;
+	usbdev = interface_to_usbdev(intf);
+
+	idVendor = L2H(usbdev->descriptor.idVendor);
+	idProduct = L2H(usbdev->descriptor.idProduct);
+
+	phy_dev = usb_get_intfdata(intf);
+
+	udev = phy_dev->priv_dev;
+	unregister_lte_device(phy_dev);
+
+	release_usb(udev);
+
+	kfree(udev);
+	udev = NULL;
+
+	kfree(phy_dev);
+	phy_dev = NULL;
+
+	usb_put_dev(usbdev);
+}
+
+#ifdef LTE_USB_PM
+static int gdm_usb_suspend(struct usb_interface *intf, pm_message_t pm_msg)
+{
+	struct phy_dev *phy_dev;
+	struct lte_udev *udev;
+	struct rx_cxt *rx;
+	struct usb_rx *r;
+	struct usb_rx *r_next;
+	unsigned long flags;
+
+	printk(KERN_INFO "gdm_usb_suspend\n");
+
+	phy_dev = usb_get_intfdata(intf);
+	udev = phy_dev->priv_dev;
+	rx = &udev->rx;
+	if (udev->usb_state != PM_NORMAL) {
+		printk(KERN_ERR "glte: usb suspend - invalid state");
+		return -1;
+	}
+
+	udev->usb_state = PM_SUSPEND;
+
+	spin_lock_irqsave(&rx->submit_lock, flags);
+	list_for_each_entry_safe(r, r_next, &rx->rx_submit_list, rx_submit_list)
+	{
+		spin_unlock_irqrestore(&rx->submit_lock, flags);
+		usb_kill_urb(r->urb);
+		spin_lock_irqsave(&rx->submit_lock, flags);
+	}
+	spin_unlock_irqrestore(&rx->submit_lock, flags);
+
+	return 0;
+}
+
+static int gdm_usb_resume(struct usb_interface *intf)
+{
+	struct phy_dev *phy_dev;
+	struct lte_udev *udev;
+	struct tx_cxt *tx;
+	struct rx_cxt *rx;
+	unsigned long flags;
+	int issue_count;
+	int i;
+
+	printk(KERN_INFO "gdm_usb_resume\n");
+
+	phy_dev = usb_get_intfdata(intf);
+	udev = phy_dev->priv_dev;
+	rx = &udev->rx;
+
+	if (udev->usb_state != PM_SUSPEND) {
+		printk(KERN_ERR "glte: usb resume - invalid state");
+		return -1;
+	}
+	udev->usb_state = PM_NORMAL;
+
+	spin_lock_irqsave(&rx->rx_lock, flags);
+	issue_count = rx->avail_count - MAX_RX_SUBMIT_COUNT;
+	spin_unlock_irqrestore(&rx->rx_lock, flags);
+
+	if (issue_count >= 0) {
+		for (i = 0; i < issue_count; i++)
+			gdm_usb_recv(phy_dev->priv_dev,
+				     udev->rx_cb,
+				     phy_dev,
+				     USB_COMPLETE);
+	}
+
+	tx = &udev->tx;
+	spin_lock_irqsave(&tx->lock, flags);
+	queue_work(usb_tx_wq, &udev->work_tx.work);
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	return 0;
+}
+#endif /* LTE_USB_PM */
+
+static struct usb_driver gdm_usb_lte_driver = {
+	.name = "gdm_lte",
+	.probe = gdm_usb_probe,
+	.disconnect = gdm_usb_disconnect,
+	.id_table = id_table,
+#ifdef LTE_USB_PM
+	.supports_autosuspend = 1,
+	.suspend = gdm_usb_suspend,
+	.resume = gdm_usb_resume,
+	.reset_resume = gdm_usb_resume,
+#endif /* LTE_USB_PM */
+};
+
+static int __init gdm_usb_lte_init(void)
+{
+	if (gdm_lte_event_init() < 0) {
+		printk(KERN_ERR "glte: error creating event\n");
+		return -1;
+	}
+
+	usb_tx_wq = create_workqueue("usb_tx_wq");
+	if (usb_tx_wq == NULL)
+		return -1;
+
+	usb_rx_wq = create_workqueue("usb_rx_wq");
+	if (usb_rx_wq == NULL)
+		return -1;
+
+	return usb_register(&gdm_usb_lte_driver);
+}
+
+static void __exit gdm_usb_lte_exit(void)
+{
+	gdm_lte_event_exit();
+
+	usb_deregister(&gdm_usb_lte_driver);
+
+	if (usb_tx_wq) {
+		flush_workqueue(usb_tx_wq);
+		destroy_workqueue(usb_tx_wq);
+	}
+
+	if (usb_rx_wq) {
+		flush_workqueue(usb_rx_wq);
+		destroy_workqueue(usb_rx_wq);
+	}
+}
+
+module_init(gdm_usb_lte_init);
+module_exit(gdm_usb_lte_exit);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_DESCRIPTION("GCT LTE USB Device Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/gdm724x/gdm_usb.h b/drivers/staging/gdm724x/gdm_usb.h
new file mode 100644
index 0000000..c6118fc
--- /dev/null
+++ b/drivers/staging/gdm724x/gdm_usb.h
@@ -0,0 +1,92 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _GDM_USB_H_
+#define _GDM_USB_H_
+
+#include <linux/version.h>
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <linux/list.h>
+#include <linux/time.h>
+
+#include "gdm_endian.h"
+#include "hci_packet.h"
+
+struct usb_tx {
+	struct list_head list;
+	struct urb *urb;
+	u8 *buf;
+	u32 len;
+	void (*callback)(void *cb_data);
+	void *cb_data;
+	struct tx_cxt *tx;
+	u8 is_sdu;
+};
+
+struct usb_tx_sdu {
+	struct list_head list;
+	u8 *buf;
+	u32 len;
+	void (*callback)(void *cb_data);
+	void *cb_data;
+};
+
+struct usb_rx {
+	struct list_head to_host_list;
+	struct list_head free_list;
+	struct list_head rx_submit_list;
+	struct rx_cxt	*rx;
+	struct urb *urb;
+	u8 *buf;
+	int (*callback)(void *cb_data, void *data, int len, int context);
+	void *cb_data;
+	void *index;
+};
+
+struct tx_cxt {
+	struct list_head sdu_list;
+	struct list_head hci_list;
+	struct list_head free_list;
+	u32 avail_count;
+	spinlock_t lock;
+};
+
+struct rx_cxt {
+	struct list_head to_host_list;
+	struct list_head rx_submit_list;
+	struct list_head free_list;
+	u32	avail_count;
+	spinlock_t to_host_lock;
+	spinlock_t rx_lock;
+	spinlock_t submit_lock;
+};
+
+struct lte_udev {
+	struct usb_device *usbdev;
+	struct gdm_endian gdm_ed;
+	struct tx_cxt tx;
+	struct rx_cxt rx;
+	struct delayed_work work_tx;
+	struct delayed_work work_rx;
+	u8 send_complete;
+	u8 tx_stop;
+	struct usb_interface *intf;
+#ifdef LTE_USB_PM
+	int (*rx_cb)(void *cb_data, void *data, int len, int context);
+	int usb_state;
+#endif /* LTE_USB_PM */
+	u8 request_mac_addr;
+};
+
+#endif /* _GDM_USB_H_ */
diff --git a/drivers/staging/gdm724x/hci.h b/drivers/staging/gdm724x/hci.h
new file mode 100644
index 0000000..9a591b0
--- /dev/null
+++ b/drivers/staging/gdm724x/hci.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _HCI_H_
+#define _HCI_H_
+
+#define LTE_GET_INFORMATION		0x3002
+#define LTE_GET_INFORMATION_RESULT	0xB003
+	#define MAC_ADDRESS		0xA2
+
+#define LTE_LINK_ON_OFF_INDICATION	0xB133
+#define LTE_PDN_TABLE_IND		0xB143
+
+#define LTE_TX_SDU			0x3200
+#define LTE_RX_SDU			0xB201
+#define LTE_TX_MULTI_SDU		0x3202
+#define LTE_RX_MULTI_SDU		0xB203
+
+#define LTE_DL_SDU_FLOW_CONTROL		0x3305
+#define LTE_UL_SDU_FLOW_CONTROL		0xB306
+
+#define LTE_AT_CMD_TO_DEVICE		0x3307
+#define LTE_AT_CMD_FROM_DEVICE		0xB308
+
+#define LTE_SDIO_DM_SEND_PKT		0x3312
+#define LTE_SDIO_DM_RECV_PKT		0xB313
+
+#define LTE_NV_RESTORE_REQUEST		0xB30C
+#define LTE_NV_RESTORE_RESPONSE		0x330D
+#define LTE_NV_SAVE_REQUEST		0xB30E
+	#define NV_TYPE_LTE_INFO	0x00
+	#define NV_TYPE_BOARD_CONFIG	0x01
+	#define NV_TYPE_RF_CAL		0x02
+	#define NV_TYPE_TEMP		0x03
+	#define NV_TYPE_NET_INFO	0x04
+	#define NV_TYPE_SAFETY_INFO	0x05
+	#define NV_TYPE_CDMA_CAL	0x06
+	#define NV_TYPE_VENDOR		0x07
+	#define NV_TYPE_ALL		0xff
+#define LTE_NV_SAVE_RESPONSE		0x330F
+
+#define LTE_AT_CMD_TO_DEVICE_EXT	0x3323
+#define LTE_AT_CMD_FROM_DEVICE_EXT	0xB324
+
+#endif /* _HCI_H_ */
diff --git a/drivers/staging/gdm724x/hci_packet.h b/drivers/staging/gdm724x/hci_packet.h
new file mode 100644
index 0000000..cef381f
--- /dev/null
+++ b/drivers/staging/gdm724x/hci_packet.h
@@ -0,0 +1,97 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _HCI_PACKET_H_
+#define _HCI_PACKET_H_
+
+#define HCI_HEADER_SIZE 4
+
+/*
+ * The NIC type definition:
+ * For backward compatibility, lower 16 bits used as they were.
+ * Lower 16 bit: NIC_TYPE values
+ * Uppoer 16 bit: NIC_TYPE Flags
+ */
+#define NIC_TYPE_NIC0		0x00000010
+#define NIC_TYPE_NIC1		0x00000011
+#define NIC_TYPE_NIC2		0x00000012
+#define NIC_TYPE_NIC3		0x00000013
+#define NIC_TYPE_ARP		0x00000100
+#define NIC_TYPE_ICMPV6		0x00000200
+#define NIC_TYPE_MASK		0x0000FFFF
+#define NIC_TYPE_F_IPV4		0x00010000
+#define NIC_TYPE_F_IPV6		0x00020000
+#define NIC_TYPE_F_DHCP		0x00040000
+#define NIC_TYPE_F_NDP		0x00080000
+#define NIC_TYPE_F_VLAN		0x00100000
+
+#ifndef __packed
+#define __packed __attribute__((packed))
+#endif
+
+struct hci_packet {
+	u16 cmd_evt;
+	u16 len;
+	u8 data[0];
+} __packed;
+
+struct tlv {
+	u8 type;
+	u8 len;
+	u8 *data[1];
+} __packed;
+
+struct sdu_header {
+	u16 cmd_evt;
+	u16 len;
+	u32 dftEpsId;
+	u32 bearer_ID;
+	u32 nic_type;
+} __packed;
+
+struct sdu {
+	u16 cmd_evt;
+	u16 len;
+	u32 dftEpsId;
+	u32 bearer_ID;
+	u32 nic_type;
+	u8 data[0];
+} __packed;
+
+struct multi_sdu {
+	u16 cmd_evt;
+	u16 len;
+	u16 num_packet;
+	u16 reserved;
+	u8 data[0];
+} __packed;
+
+struct hci_pdn_table_ind {
+	u16 cmd_evt;
+	u16 len;
+	u8 activate;
+	u32 dft_eps_id;
+	u32 nic_type;
+	u8 pdn_type;
+	u8 ipv4_addr[4];
+	u8 ipv6_intf_id[8];
+} __packed;
+
+struct hci_connect_ind {
+	u16 cmd_evt;
+	u16 len;
+	u32 connect;
+} __packed;
+
+
+#endif /* _HCI_PACKET_H_ */
diff --git a/drivers/staging/gdm724x/lte_ioctl.h b/drivers/staging/gdm724x/lte_ioctl.h
new file mode 100644
index 0000000..8941ebf7
--- /dev/null
+++ b/drivers/staging/gdm724x/lte_ioctl.h
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _LTE_IOCTL_H_
+#define _LTE_IOCTL_H_
+
+#define SIOCLTEIOCTL	SIOCDEVPRIVATE
+#define SIOCG_DATA	0x8D10
+#define SIOCS_DATA	0x8D11
+
+#ifndef __packed
+#define __packed __attribute__((packed))
+#endif
+
+enum {
+	LINK_ON,
+	LINK_OFF,
+	GET_NETWORK_STATICS,
+	RX_STOP,
+	RX_RESUME,
+	GET_DRV_VER,
+	GET_SDIO_DEVICE_STATUS,
+	GET_ENDIAN_INFO,
+};
+
+struct dev_endian_t {
+	unsigned char dev_endian;
+	unsigned char host_endian;
+} __packed;
+
+struct net_stat_t {
+	unsigned long tx_packets;
+	unsigned long rx_packets;
+	unsigned long tx_bytes;
+	unsigned long rx_bytes;
+	unsigned long tx_dropped;
+	unsigned long rx_dropped;
+} __packed;
+
+struct net_info_t {
+	unsigned int nic_index;
+	struct net_stat_t stats;
+} __packed;
+
+struct data_t {
+	long len;
+	void *buf;
+} __packed;
+
+struct wm_req_t {
+	union {
+		char ifrn_name[IFNAMSIZ];
+	} ifr_ifrn;
+	unsigned short cmd;
+	unsigned short data_id;
+	struct data_t data;
+} __packed;
+
+#ifndef ifr_name
+#define ifr_name	(ifr_ifrn.ifrm_name)
+#endif
+
+#endif /* _LTE_IOCTL_H_ */
diff --git a/drivers/staging/gdm724x/netlink_k.c b/drivers/staging/gdm724x/netlink_k.c
new file mode 100644
index 0000000..d5170f6
--- /dev/null
+++ b/drivers/staging/gdm724x/netlink_k.c
@@ -0,0 +1,161 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/version.h>
+#include <linux/export.h>
+#include <linux/etherdevice.h>
+#include <linux/netlink.h>
+#include <asm/byteorder.h>
+#include <net/sock.h>
+
+#include "netlink_k.h"
+
+#if defined(DEFINE_MUTEX)
+static DEFINE_MUTEX(netlink_mutex);
+#else
+static struct semaphore netlink_mutex;
+#define mutex_lock(x)		down(x)
+#define mutex_unlock(x)		up(x)
+#endif
+
+#define ND_MAX_GROUP		30
+#define ND_IFINDEX_LEN		sizeof(int)
+#define ND_NLMSG_SPACE(len)	(NLMSG_SPACE(len) + ND_IFINDEX_LEN)
+#define ND_NLMSG_DATA(nlh)	((void *)((char *)NLMSG_DATA(nlh) + ND_IFINDEX_LEN))
+#define ND_NLMSG_S_LEN(len)	(len+ND_IFINDEX_LEN)
+#define ND_NLMSG_R_LEN(nlh)	(nlh->nlmsg_len-ND_IFINDEX_LEN)
+#define ND_NLMSG_IFIDX(nlh)	NLMSG_DATA(nlh)
+#define ND_MAX_MSG_LEN		(1024 * 32)
+
+static void (*rcv_cb)(struct net_device *dev, u16 type, void *msg, int len);
+
+static void netlink_rcv_cb(struct sk_buff *skb)
+{
+	struct nlmsghdr	*nlh;
+	struct net_device *dev;
+	u32 mlen;
+	void *msg;
+	int ifindex;
+
+	if (!rcv_cb) {
+		printk(KERN_ERR "glte: nl cb - unregistered\n");
+		return;
+	}
+
+	if (skb->len < NLMSG_SPACE(0)) {
+		printk(KERN_ERR "glte: nl cb - invalid skb length\n");
+		return;
+	}
+
+	nlh = (struct nlmsghdr *)skb->data;
+
+	if (skb->len < nlh->nlmsg_len || nlh->nlmsg_len > ND_MAX_MSG_LEN) {
+		printk(KERN_ERR "glte: nl cb - invalid length (%d,%d)\n",
+		       skb->len, nlh->nlmsg_len);
+		return;
+	}
+
+	memcpy(&ifindex, ND_NLMSG_IFIDX(nlh), ND_IFINDEX_LEN);
+	msg = ND_NLMSG_DATA(nlh);
+	mlen = ND_NLMSG_R_LEN(nlh);
+
+	dev = dev_get_by_index(&init_net, ifindex);
+	if (dev) {
+		rcv_cb(dev, nlh->nlmsg_type, msg, mlen);
+		dev_put(dev);
+	} else {
+		printk(KERN_ERR "glte: nl cb - dev (%d) not found\n", ifindex);
+	}
+
+}
+
+static void netlink_rcv(struct sk_buff *skb)
+{
+	mutex_lock(&netlink_mutex);
+	netlink_rcv_cb(skb);
+	mutex_unlock(&netlink_mutex);
+}
+
+struct sock *netlink_init(int unit,
+	void (*cb)(struct net_device *dev, u16 type, void *msg, int len))
+{
+	struct sock *sock;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 6, 0)
+	struct netlink_kernel_cfg cfg = {
+		.input  = netlink_rcv,
+	};
+#endif
+
+#if !defined(DEFINE_MUTEX)
+	init_MUTEX(&netlink_mutex);
+#endif
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 6, 0)
+	sock = netlink_kernel_create(&init_net, unit, 0, netlink_rcv, NULL,
+		THIS_MODULE);
+#elif LINUX_VERSION_CODE < KERNEL_VERSION(3, 7, 0)
+	sock = netlink_kernel_create(&init_net, unit, THIS_MODULE, &cfg);
+#else
+	sock = netlink_kernel_create(&init_net, unit, &cfg);
+#endif
+
+	if (sock)
+		rcv_cb = cb;
+	return sock;
+}
+
+void netlink_exit(struct sock *sock)
+{
+	sock_release(sock->sk_socket);
+}
+
+int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len)
+{
+	static u32 seq;
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh;
+	int ret = 0;
+
+	if (group > ND_MAX_GROUP)
+		return -EINVAL;
+
+	if (!netlink_has_listeners(sock, group+1))
+		return -ESRCH;
+
+	skb = alloc_skb(NLMSG_SPACE(len), GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	seq++;
+
+	nlh = nlmsg_put(skb, 0, seq, type, len, 0);
+	memcpy(NLMSG_DATA(nlh), msg, len);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 7, 0)
+	NETLINK_CB(skb).pid = 0;
+#else
+	NETLINK_CB(skb).portid = 0;
+#endif
+	NETLINK_CB(skb).dst_group = 0;
+
+	ret = netlink_broadcast(sock, skb, 0, group+1, GFP_ATOMIC);
+	if (!ret)
+		return len;
+
+	if (ret != -ESRCH)
+		printk(KERN_ERR "glte: nl broadcast g=%d, t=%d, l=%d, r=%d\n",
+		       group, type, len, ret);
+	else if (netlink_has_listeners(sock, group+1))
+		return -EAGAIN;
+
+	return ret;
+}
diff --git a/drivers/staging/gdm724x/netlink_k.h b/drivers/staging/gdm724x/netlink_k.h
new file mode 100644
index 0000000..589486d
--- /dev/null
+++ b/drivers/staging/gdm724x/netlink_k.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2012 GCT Semiconductor, Inc. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _NETLINK_K_H
+#define _NETLINK_K_H
+
+#include <linux/netdevice.h>
+#include <net/sock.h>
+
+struct sock *netlink_init(int unit,
+	void (*cb)(struct net_device *dev, u16 type, void *msg, int len));
+void netlink_exit(struct sock *sock);
+int netlink_send(struct sock *sock, int group, u16 type, void *msg, int len);
+
+#endif /* _NETLINK_K_H_ */
-- 
1.7.10.4

