Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3L0LDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 06:03:06 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:36540 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3L0LDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 06:03:01 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Ville Tervo <ville.tervo@nokia.com>, sre@ring0.de
Subject: [PATCH v2] Bluetooth: Add hci_h4p driver
Date: Fri, 27 Dec 2013 12:02:47 +0100
Message-ID: <1727897.LBX8128hIo@izba>
User-Agent: KMail/4.12 (Linux/3.11.0-15-generic; KDE/4.12.0; x86_64; ; )
In-Reply-To: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2035915.Fh6UZzF48y"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2035915.Fh6UZzF48y
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

I'm sending updated version of hci_h4p bluetooth driver. It is needed f=
or
Nokia N900 bluetooth hardware. This (v2) is older version of hci_h4p dr=
iver,
but I tested it with v3.13-rc3 kernel on Nokia N900 and working without=
 any
problems. Previous (v1) version had some problems. So for future develo=
pment
please use this (v2) version of hci_h4p driver.

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 11a6104..95155c3 100644
=2D-- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -242,4 +242,14 @@ config BT_WILINK
=20
 =09  Say Y here to compile support for Texas Instrument's WiLink7 driv=
er
 =09  into the kernel or say M to compile it as module.
+
+config BT_HCIH4P
+=09tristate "HCI driver with H4 Nokia extensions"
+=09depends on BT && ARCH_OMAP
+=09help
+=09  Bluetooth HCI driver with H4 extensions.  This driver provides
+=09  support for H4+ Bluetooth chip with vendor-specific H4 extensions=
.
+
+=09  Say Y here to compile support for h4 extended devices into the ke=
rnel
+=09  or say M to compile it as module (hci_h4p).
 endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index 9fe8a87..77b01b6 100644
=2D-- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -31,4 +31,6 @@ hci_uart-$(CONFIG_BT_HCIUART_ATH3K)=09+=3D hci_ath.o
 hci_uart-$(CONFIG_BT_HCIUART_3WIRE)=09+=3D hci_h5.o
 hci_uart-objs=09=09=09=09:=3D $(hci_uart-y)
=20
+obj-y=09=09=09=09+=3D hci_h4p/
+
 ccflags-y +=3D -D__CHECK_ENDIAN__
diff --git a/drivers/bluetooth/hci_h4p/Makefile b/drivers/bluetooth/hci=
_h4p/Makefile
new file mode 100644
index 0000000..f20bd9a
=2D-- /dev/null
+++ b/drivers/bluetooth/hci_h4p/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux Bluetooth HCI device drivers.
+#
+
+obj-$(CONFIG_BT_HCIH4P)=09=09+=3D hci_h4p.o
+
+hci_h4p-objs :=3D core.o fw.o uart.o fw-csr.o fw-bcm.o fw-ti1273.o
diff --git a/drivers/bluetooth/hci_h4p/core.c b/drivers/bluetooth/hci_h=
4p/core.c
new file mode 100644
index 0000000..e76e889
=2D-- /dev/null
+++ b/drivers/bluetooth/hci_h4p/core.c
@@ -0,0 +1,1357 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005-2008 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but=

+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/serial_reg.h>
+#include <linux/skbuff.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/gpio.h>
+#include <linux/timer.h>
+#include <linux/kthread.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/hci.h>
+
+#include <linux/bluetooth/hci_h4p.h>
+
+#include "hci_h4p.h"
+
+static struct task_struct *h4p_thread;
+
+/* This should be used in function that cannot release clocks */
+static void hci_h4p_set_clk(struct hci_h4p_info *info, int *clock, int=
 enable)
+{
+=09unsigned long flags;
+
+=09spin_lock_irqsave(&info->clocks_lock, flags);
+=09if (enable && !*clock) {
+=09=09NBT_DBG_POWER("Enabling %p\n", clock);
+=09=09clk_prepare_enable(info->uart_fclk);
+=09=09clk_prepare_enable(info->uart_iclk);
+=09=09if (atomic_read(&info->clk_users) =3D=3D 0)
+=09=09=09hci_h4p_restore_regs(info);
+=09=09atomic_inc(&info->clk_users);
+=09}
+
+=09if (!enable && *clock) {
+=09=09NBT_DBG_POWER("Disabling %p\n", clock);
+=09=09if (atomic_dec_and_test(&info->clk_users))
+=09=09=09hci_h4p_store_regs(info);
+=09=09clk_disable_unprepare(info->uart_fclk);
+=09=09clk_disable_unprepare(info->uart_iclk);
+=09}
+
+=09*clock =3D enable;
+=09spin_unlock_irqrestore(&info->clocks_lock, flags);
+}
+
+static void hci_h4p_lazy_clock_release(unsigned long data)
+{
+=09struct hci_h4p_info *info =3D (struct hci_h4p_info *)data;
+=09unsigned long flags;
+
+=09spin_lock_irqsave(&info->lock, flags);
+=09if (!info->tx_enabled)
+=09=09hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+=09spin_unlock_irqrestore(&info->lock, flags);
+}
+
+/* Power management functions */
+void hci_h4p_smart_idle(struct hci_h4p_info *info, bool enable)
+{
+=09u8 v;
+
+=09v =3D hci_h4p_inb(info, UART_OMAP_SYSC);
+=09v &=3D ~(UART_OMAP_SYSC_IDLEMASK);
+
+=09if (enable)
+=09=09v |=3D UART_OMAP_SYSC_SMART_IDLE;
+=09else
+=09=09v |=3D UART_OMAP_SYSC_NO_IDLE;
+
+=09hci_h4p_outb(info, UART_OMAP_SYSC, v);
+}
+
+static inline void h4p_schedule_pm(struct hci_h4p_info *info)
+{
+=09if (unlikely(!h4p_thread))
+=09=09return;
+
+=09set_bit(H4P_SCHED_TRANSFER_MODE, &info->pm_flags);
+
+=09if (unlikely(!test_bit(H4P_TRANSFER_MODE, &info->pm_flags)))
+=09=09wake_up_process(h4p_thread);
+}
+
+static void hci_h4p_disable_tx(struct hci_h4p_info *info)
+{
+=09NBT_DBG_POWER("\n");
+
+=09if (!info->pm_enabled)
+=09=09return;
+
+=09/* Re-enable smart-idle */
+=09hci_h4p_smart_idle(info, 1);
+
+=09gpio_set_value(info->bt_wakeup_gpio, 0);
+=09mod_timer(&info->lazy_release, jiffies + msecs_to_jiffies(100));
+=09info->tx_enabled =3D 0;
+}
+
+void hci_h4p_enable_tx(struct hci_h4p_info *info)
+{
+=09unsigned long flags;
+=09NBT_DBG_POWER("\n");
+
+=09if (!info->pm_enabled)
+=09=09return;
+
+=09h4p_schedule_pm(info);
+
+=09spin_lock_irqsave(&info->lock, flags);
+=09del_timer(&info->lazy_release);
+=09hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
+=09info->tx_enabled =3D 1;
+=09gpio_set_value(info->bt_wakeup_gpio, 1);
+=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09     UART_IER_THRI);
+=09/*
+=09 * Disable smart-idle as UART TX interrupts
+=09 * are not wake-up capable
+=09 */
+=09hci_h4p_smart_idle(info, 0);
+
+=09spin_unlock_irqrestore(&info->lock, flags);
+}
+
+static void hci_h4p_disable_rx(struct hci_h4p_info *info)
+{
+=09if (!info->pm_enabled)
+=09=09return;
+
+=09info->rx_enabled =3D 0;
+
+=09if (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR)
+=09=09return;
+
+=09if (!(hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT))
+=09=09return;
+
+=09__hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+=09info->autorts =3D 0;
+=09hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
+}
+
+static void hci_h4p_enable_rx(struct hci_h4p_info *info)
+{
+=09if (!info->pm_enabled)
+=09=09return;
+
+=09h4p_schedule_pm(info);
+
+=09hci_h4p_set_clk(info, &info->rx_clocks_en, 1);
+=09info->rx_enabled =3D 1;
+
+=09if (!(hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT))
+=09=09return;
+
+=09__hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+=09info->autorts =3D 1;
+}
+
+/* Negotiation functions */
+int hci_h4p_send_alive_packet(struct hci_h4p_info *info)
+{
+=09struct hci_h4p_alive_hdr *hdr;
+=09struct hci_h4p_alive_pkt *pkt;
+=09struct sk_buff *skb;
+=09unsigned long flags;
+=09int len;
+
+=09NBT_DBG("Sending alive packet\n");
+
+=09len =3D H4_TYPE_SIZE + sizeof(*hdr) + sizeof(*pkt);
+=09skb =3D bt_skb_alloc(len, GFP_KERNEL);
+=09if (!skb)
+=09=09return -ENOMEM;
+
+=09memset(skb->data, 0x00, len);
+=09*skb_put(skb, 1) =3D H4_ALIVE_PKT;
+=09hdr =3D (struct hci_h4p_alive_hdr *)skb_put(skb, sizeof(*hdr));
+=09hdr->dlen =3D sizeof(*pkt);
+=09pkt =3D (struct hci_h4p_alive_pkt *)skb_put(skb, sizeof(*pkt));
+=09pkt->mid =3D H4P_ALIVE_REQ;
+
+=09skb_queue_tail(&info->txq, skb);
+=09spin_lock_irqsave(&info->lock, flags);
+=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09     UART_IER_THRI);
+=09spin_unlock_irqrestore(&info->lock, flags);
+
+=09NBT_DBG("Alive packet sent\n");
+
+=09return 0;
+}
+
+static void hci_h4p_alive_packet(struct hci_h4p_info *info,
+=09=09=09=09 struct sk_buff *skb)
+{
+=09struct hci_h4p_alive_hdr *hdr;
+=09struct hci_h4p_alive_pkt *pkt;
+
+=09NBT_DBG("Received alive packet\n");
+=09hdr =3D (struct hci_h4p_alive_hdr *)skb->data;
+=09if (hdr->dlen !=3D sizeof(*pkt)) {
+=09=09dev_err(info->dev, "Corrupted alive message\n");
+=09=09info->init_error =3D -EIO;
+=09=09goto finish_alive;
+=09}
+
+=09pkt =3D (struct hci_h4p_alive_pkt *)skb_pull(skb, sizeof(*hdr));
+=09if (pkt->mid !=3D H4P_ALIVE_RESP) {
+=09=09dev_err(info->dev, "Could not negotiate hci_h4p settings\n");
+=09=09info->init_error =3D -EINVAL;
+=09}
+
+finish_alive:
+=09complete(&info->init_completion);
+=09kfree_skb(skb);
+}
+
+static int hci_h4p_send_negotiation(struct hci_h4p_info *info)
+{
+=09struct hci_h4p_neg_cmd *neg_cmd;
+=09struct hci_h4p_neg_hdr *neg_hdr;
+=09struct sk_buff *skb;
+=09unsigned long flags;
+=09int err, len;
+=09u16 sysclk;
+
+=09NBT_DBG("Sending negotiation..\n");
+
+=09switch (info->bt_sysclk) {
+=09case 1:
+=09=09sysclk =3D 12000;
+=09=09break;
+=09case 2:
+=09=09sysclk =3D 38400;
+=09=09break;
+=09default:
+=09=09return -EINVAL;
+=09}
+
+=09len =3D sizeof(*neg_cmd) + sizeof(*neg_hdr) + H4_TYPE_SIZE;
+=09skb =3D bt_skb_alloc(len, GFP_KERNEL);
+=09if (!skb)
+=09=09return -ENOMEM;
+
+=09memset(skb->data, 0x00, len);
+=09*skb_put(skb, 1) =3D H4_NEG_PKT;
+=09neg_hdr =3D (struct hci_h4p_neg_hdr *)skb_put(skb, sizeof(*neg_hdr)=
);
+=09neg_cmd =3D (struct hci_h4p_neg_cmd *)skb_put(skb, sizeof(*neg_cmd)=
);
+
+=09neg_hdr->dlen =3D sizeof(*neg_cmd);
+=09neg_cmd->ack =3D H4P_NEG_REQ;
+=09neg_cmd->baud =3D cpu_to_le16(BT_BAUDRATE_DIVIDER/MAX_BAUD_RATE);
+=09neg_cmd->proto =3D H4P_PROTO_BYTE;
+=09neg_cmd->sys_clk =3D cpu_to_le16(sysclk);
+
+=09hci_h4p_change_speed(info, INIT_SPEED);
+
+=09hci_h4p_set_rts(info, 1);
+=09info->init_error =3D 0;
+=09init_completion(&info->init_completion);
+=09skb_queue_tail(&info->txq, skb);
+=09spin_lock_irqsave(&info->lock, flags);
+=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09     UART_IER_THRI);
+=09spin_unlock_irqrestore(&info->lock, flags);
+
+=09if (!wait_for_completion_interruptible_timeout(&info->init_completi=
on,
+=09=09=09=09msecs_to_jiffies(1000)))
+=09=09return -ETIMEDOUT;
+
+=09if (info->init_error < 0)
+=09=09return info->init_error;
+
+=09/* Change to operational settings */
+=09hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+=09hci_h4p_set_rts(info, 0);
+=09hci_h4p_change_speed(info, MAX_BAUD_RATE);
+
+=09err =3D hci_h4p_wait_for_cts(info, 1, 100);
+=09if (err < 0)
+=09=09return err;
+
+=09hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+=09init_completion(&info->init_completion);
+=09err =3D hci_h4p_send_alive_packet(info);
+
+=09if (err < 0)
+=09=09return err;
+
+=09if (!wait_for_completion_interruptible_timeout(&info->init_completi=
on,
+=09=09=09=09msecs_to_jiffies(1000)))
+=09=09return -ETIMEDOUT;
+
+=09if (info->init_error < 0)
+=09=09return info->init_error;
+
+=09NBT_DBG("Negotiation succesful\n");
+=09return 0;
+}
+
+static void hci_h4p_negotiation_packet(struct hci_h4p_info *info,
+=09=09=09=09       struct sk_buff *skb)
+{
+=09struct hci_h4p_neg_hdr *hdr;
+=09struct hci_h4p_neg_evt *evt;
+
+=09hdr =3D (struct hci_h4p_neg_hdr *)skb->data;
+=09if (hdr->dlen !=3D sizeof(*evt)) {
+=09=09info->init_error =3D -EIO;
+=09=09goto finish_neg;
+=09}
+
+=09evt =3D (struct hci_h4p_neg_evt *)skb_pull(skb, sizeof(*hdr));
+
+=09if (evt->ack !=3D H4P_NEG_ACK) {
+=09=09dev_err(info->dev, "Could not negotiate hci_h4p settings\n");
+=09=09info->init_error =3D -EINVAL;
+=09}
+
+=09info->man_id =3D evt->man_id;
+=09info->ver_id =3D evt->ver_id;
+
+finish_neg:
+
+=09complete(&info->init_completion);
+=09kfree_skb(skb);
+}
+
+/* H4 packet handling functions */
+static int hci_h4p_get_hdr_len(struct hci_h4p_info *info, u8 pkt_type)=

+{
+=09long retval;
+
+=09switch (pkt_type) {
+=09case H4_EVT_PKT:
+=09=09retval =3D HCI_EVENT_HDR_SIZE;
+=09=09break;
+=09case H4_ACL_PKT:
+=09=09retval =3D HCI_ACL_HDR_SIZE;
+=09=09break;
+=09case H4_SCO_PKT:
+=09=09retval =3D HCI_SCO_HDR_SIZE;
+=09=09break;
+=09case H4_NEG_PKT:
+=09=09retval =3D H4P_NEG_HDR_SIZE;
+=09=09break;
+=09case H4_ALIVE_PKT:
+=09=09retval =3D H4P_ALIVE_HDR_SIZE;
+=09=09break;
+=09case H4_RADIO_PKT:
+=09=09retval =3D H4_RADIO_HDR_SIZE;
+=09=09break;
+=09default:
+=09=09dev_err(info->dev, "Unknown H4 packet type 0x%.2x\n", pkt_type);=

+=09=09retval =3D -1;
+=09=09break;
+=09}
+
+=09return retval;
+}
+
+static unsigned int hci_h4p_get_data_len(struct hci_h4p_info *info,
+=09=09=09=09=09 struct sk_buff *skb)
+{
+=09long retval =3D -1;
+=09struct hci_acl_hdr *acl_hdr;
+=09struct hci_sco_hdr *sco_hdr;
+=09struct hci_event_hdr *evt_hdr;
+=09struct hci_h4p_neg_hdr *neg_hdr;
+=09struct hci_h4p_alive_hdr *alive_hdr;
+=09struct hci_h4p_radio_hdr *radio_hdr;
+
+=09switch (bt_cb(skb)->pkt_type) {
+=09case H4_EVT_PKT:
+=09=09evt_hdr =3D (struct hci_event_hdr *)skb->data;
+=09=09retval =3D evt_hdr->plen;
+=09=09break;
+=09case H4_ACL_PKT:
+=09=09acl_hdr =3D (struct hci_acl_hdr *)skb->data;
+=09=09retval =3D le16_to_cpu(acl_hdr->dlen);
+=09=09break;
+=09case H4_SCO_PKT:
+=09=09sco_hdr =3D (struct hci_sco_hdr *)skb->data;
+=09=09retval =3D sco_hdr->dlen;
+=09=09break;
+=09case H4_RADIO_PKT:
+=09=09radio_hdr =3D (struct hci_h4p_radio_hdr *)skb->data;
+=09=09retval =3D radio_hdr->dlen;
+=09=09break;
+=09case H4_NEG_PKT:
+=09=09neg_hdr =3D (struct hci_h4p_neg_hdr *)skb->data;
+=09=09retval =3D neg_hdr->dlen;
+=09=09break;
+=09case H4_ALIVE_PKT:
+=09=09alive_hdr =3D (struct hci_h4p_alive_hdr *)skb->data;
+=09=09retval =3D alive_hdr->dlen;
+=09=09break;
+=09}
+
+=09return retval;
+}
+
+static inline void hci_h4p_recv_frame(struct hci_h4p_info *info,
+=09=09=09=09      struct sk_buff *skb)
+{
+=09if (unlikely(!test_bit(HCI_RUNNING, &info->hdev->flags))) {
+=09=09if (bt_cb(skb)->pkt_type =3D=3D H4_NEG_PKT) {
+=09=09=09hci_h4p_negotiation_packet(info, skb);
+=09=09=09info->rx_state =3D WAIT_FOR_PKT_TYPE;
+=09=09=09return;
+=09=09}
+=09=09if (bt_cb(skb)->pkt_type =3D=3D H4_ALIVE_PKT) {
+=09=09=09hci_h4p_alive_packet(info, skb);
+=09=09=09info->rx_state =3D WAIT_FOR_PKT_TYPE;
+=09=09=09return;
+=09=09}
+
+=09=09if (!test_bit(HCI_UP, &info->hdev->flags)) {
+=09=09=09NBT_DBG("fw_event\n");
+=09=09=09hci_h4p_parse_fw_event(info, skb);
+=09=09=09return;
+=09=09}
+=09}
+
+=09hci_recv_frame(info->hdev, skb);
+=09NBT_DBG("Frame sent to upper layer\n");
+}
+
+static inline void hci_h4p_handle_byte(struct hci_h4p_info *info, u8 b=
yte)
+{
+=09switch (info->rx_state) {
+=09case WAIT_FOR_PKT_TYPE:
+=09=09bt_cb(info->rx_skb)->pkt_type =3D byte;
+=09=09info->rx_count =3D hci_h4p_get_hdr_len(info, byte);
+=09=09if (info->rx_count < 0) {
+=09=09=09info->hdev->stat.err_rx++;
+=09=09=09kfree_skb(info->rx_skb);
+=09=09=09info->rx_skb =3D NULL;
+=09=09} else {
+=09=09=09info->rx_state =3D WAIT_FOR_HEADER;
+=09=09}
+=09=09break;
+=09case WAIT_FOR_HEADER:
+=09=09info->rx_count--;
+=09=09*skb_put(info->rx_skb, 1) =3D byte;
+=09=09if (info->rx_count =3D=3D 0) {
+=09=09=09info->rx_count =3D hci_h4p_get_data_len(info,
+=09=09=09=09=09=09=09      info->rx_skb);
+=09=09=09if (info->rx_count > skb_tailroom(info->rx_skb)) {
+=09=09=09=09dev_err(info->dev, "Too long frame.\n");
+=09=09=09=09info->garbage_bytes =3D info->rx_count -
+=09=09=09=09=09skb_tailroom(info->rx_skb);
+=09=09=09=09kfree_skb(info->rx_skb);
+=09=09=09=09info->rx_skb =3D NULL;
+=09=09=09=09break;
+=09=09=09}
+=09=09=09info->rx_state =3D WAIT_FOR_DATA;
+
+=09=09}
+=09=09break;
+=09case WAIT_FOR_DATA:
+=09=09info->rx_count--;
+=09=09*skb_put(info->rx_skb, 1) =3D byte;
+=09=09break;
+=09default:
+=09=09WARN_ON(1);
+=09=09break;
+=09}
+
+=09if (info->rx_count =3D=3D 0) {
+=09=09/* H4+ devices should allways send word aligned
+=09=09 * packets */
+=09=09if (!(info->rx_skb->len % 2))
+=09=09=09info->garbage_bytes++;
+=09=09hci_h4p_recv_frame(info, info->rx_skb);
+=09=09info->rx_skb =3D NULL;
+=09}
+}
+
+static void hci_h4p_rx_tasklet(unsigned long data)
+{
+=09u8 byte;
+=09struct hci_h4p_info *info =3D (struct hci_h4p_info *)data;
+
+=09NBT_DBG("tasklet woke up\n");
+=09NBT_DBG_TRANSFER("rx_tasklet woke up\ndata ");
+
+=09while (hci_h4p_inb(info, UART_LSR) & UART_LSR_DR) {
+=09=09byte =3D hci_h4p_inb(info, UART_RX);
+=09=09if (info->garbage_bytes) {
+=09=09=09info->garbage_bytes--;
+=09=09=09continue;
+=09=09}
+=09=09if (info->rx_skb =3D=3D NULL) {
+=09=09=09info->rx_skb =3D bt_skb_alloc(HCI_MAX_FRAME_SIZE,
+=09=09=09=09=09=09    GFP_ATOMIC | GFP_DMA);
+=09=09=09if (!info->rx_skb) {
+=09=09=09=09dev_err(info->dev,
+=09=09=09=09=09"No memory for new packet\n");
+=09=09=09=09goto finish_rx;
+=09=09=09}
+=09=09=09info->rx_state =3D WAIT_FOR_PKT_TYPE;
+=09=09}
+=09=09info->hdev->stat.byte_rx++;
+=09=09NBT_DBG_TRANSFER_NF("0x%.2x  ", byte);
+=09=09hci_h4p_handle_byte(info, byte);
+=09}
+
+=09if (!info->rx_enabled) {
+=09=09if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT &&
+=09=09=09=09=09=09  info->autorts) {
+=09=09=09__hci_h4p_set_auto_ctsrts(info, 0 , UART_EFR_RTS);
+=09=09=09info->autorts =3D 0;
+=09=09}
+=09=09/* Flush posted write to avoid spurious interrupts */
+=09=09hci_h4p_inb(info, UART_OMAP_SCR);
+=09=09hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
+=09}
+
+finish_rx:
+=09NBT_DBG_TRANSFER_NF("\n");
+=09NBT_DBG("rx_ended\n");
+}
+
+static void hci_h4p_tx_tasklet(unsigned long data)
+{
+=09unsigned int sent =3D 0;
+=09struct sk_buff *skb;
+=09struct hci_h4p_info *info =3D (struct hci_h4p_info *)data;
+
+=09NBT_DBG("tasklet woke up\n");
+=09NBT_DBG_TRANSFER("tx_tasklet woke up\n data ");
+
+=09if (info->autorts !=3D info->rx_enabled) {
+=09=09if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT) {
+=09=09=09if (info->autorts && !info->rx_enabled) {
+=09=09=09=09__hci_h4p_set_auto_ctsrts(info, 0,
+=09=09=09=09=09=09=09  UART_EFR_RTS);
+=09=09=09=09info->autorts =3D 0;
+=09=09=09}
+=09=09=09if (!info->autorts && info->rx_enabled) {
+=09=09=09=09__hci_h4p_set_auto_ctsrts(info, 1,
+=09=09=09=09=09=09=09  UART_EFR_RTS);
+=09=09=09=09info->autorts =3D 1;
+=09=09=09}
+=09=09} else {
+=09=09=09hci_h4p_outb(info, UART_OMAP_SCR,
+=09=09=09=09     hci_h4p_inb(info, UART_OMAP_SCR) |
+=09=09=09=09     UART_OMAP_SCR_EMPTY_THR);
+=09=09=09goto finish_tx;
+=09=09}
+=09}
+
+=09skb =3D skb_dequeue(&info->txq);
+=09if (!skb) {
+=09=09/* No data in buffer */
+=09=09NBT_DBG("skb ready\n");
+=09=09if (hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT) {
+=09=09=09hci_h4p_outb(info, UART_IER,
+=09=09=09=09     hci_h4p_inb(info, UART_IER) &
+=09=09=09=09     ~UART_IER_THRI);
+=09=09=09hci_h4p_inb(info, UART_OMAP_SCR);
+=09=09=09hci_h4p_disable_tx(info);
+=09=09=09return;
+=09=09} else
+=09=09=09hci_h4p_outb(info, UART_OMAP_SCR,
+=09=09=09=09     hci_h4p_inb(info, UART_OMAP_SCR) |
+=09=09=09=09     UART_OMAP_SCR_EMPTY_THR);
+=09=09goto finish_tx;
+=09}
+
+=09/* Copy data to tx fifo */
+=09while (!(hci_h4p_inb(info, UART_OMAP_SSR) & UART_OMAP_SSR_TXFULL) &=
&
+=09       (sent < skb->len)) {
+=09=09NBT_DBG_TRANSFER_NF("0x%.2x ", skb->data[sent]);
+=09=09hci_h4p_outb(info, UART_TX, skb->data[sent]);
+=09=09sent++;
+=09}
+
+=09info->hdev->stat.byte_tx +=3D sent;
+=09NBT_DBG_TRANSFER_NF("\n");
+=09if (skb->len =3D=3D sent) {
+=09=09kfree_skb(skb);
+=09} else {
+=09=09skb_pull(skb, sent);
+=09=09skb_queue_head(&info->txq, skb);
+=09}
+
+=09hci_h4p_outb(info, UART_OMAP_SCR, hci_h4p_inb(info, UART_OMAP_SCR) =
&
+=09=09=09=09=09=09     ~UART_OMAP_SCR_EMPTY_THR);
+=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09=09=09=09=09 UART_IER_THRI);
+
+finish_tx:
+=09/* Flush posted write to avoid spurious interrupts */
+=09hci_h4p_inb(info, UART_OMAP_SCR);
+
+}
+
+static irqreturn_t hci_h4p_interrupt(int irq, void *data)
+{
+=09struct hci_h4p_info *info =3D (struct hci_h4p_info *)data;
+=09u8 iir, msr;
+=09int ret;
+
+=09ret =3D IRQ_NONE;
+
+=09iir =3D hci_h4p_inb(info, UART_IIR);
+=09if (iir & UART_IIR_NO_INT)
+=09=09return IRQ_HANDLED;
+
+=09NBT_DBG("In interrupt handler iir 0x%.2x\n", iir);
+
+=09iir &=3D UART_IIR_ID;
+
+=09if (iir =3D=3D UART_IIR_MSI) {
+=09=09msr =3D hci_h4p_inb(info, UART_MSR);
+=09=09ret =3D IRQ_HANDLED;
+=09}
+=09if (iir =3D=3D UART_IIR_RLSI) {
+=09=09hci_h4p_inb(info, UART_RX);
+=09=09hci_h4p_inb(info, UART_LSR);
+=09=09ret =3D IRQ_HANDLED;
+=09}
+
+=09if (iir =3D=3D UART_IIR_RDI) {
+=09=09hci_h4p_rx_tasklet((unsigned long)data);
+=09=09ret =3D IRQ_HANDLED;
+=09}
+
+=09if (iir =3D=3D UART_IIR_THRI) {
+=09=09hci_h4p_tx_tasklet((unsigned long)data);
+=09=09ret =3D IRQ_HANDLED;
+=09}
+
+=09return ret;
+}
+
+static irqreturn_t hci_h4p_wakeup_interrupt(int irq, void *dev_inst)
+{
+=09struct hci_h4p_info *info =3D dev_inst;
+=09int should_wakeup;
+=09struct hci_dev *hdev;
+
+=09if (!info->hdev)
+=09=09return IRQ_HANDLED;
+
+=09should_wakeup =3D gpio_get_value(info->host_wakeup_gpio);
+=09hdev =3D info->hdev;
+
+=09if (!test_bit(HCI_RUNNING, &hdev->flags)) {
+=09=09if (should_wakeup =3D=3D 1)
+=09=09=09complete_all(&info->test_completion);
+
+=09=09return IRQ_HANDLED;
+=09}
+
+=09NBT_DBG_POWER("gpio interrupt %d\n", should_wakeup);
+
+=09/* Check if wee have missed some interrupts */
+=09if (info->rx_enabled =3D=3D should_wakeup)
+=09=09return IRQ_HANDLED;
+
+=09if (should_wakeup)
+=09=09hci_h4p_enable_rx(info);
+=09else
+=09=09hci_h4p_disable_rx(info);
+
+=09return IRQ_HANDLED;
+}
+
+static inline void hci_h4p_set_pm_limits(struct hci_h4p_info *info, bo=
ol set)
+{
+=09struct hci_h4p_platform_data *bt_plat_data =3D info->dev->platform_=
data;
+
+=09if (unlikely(!bt_plat_data || !bt_plat_data->set_pm_limits))
+=09=09return;
+
+=09if (set && !test_bit(H4P_ACTIVE_MODE, &info->pm_flags)) {
+=09=09bt_plat_data->set_pm_limits(info->dev, set);
+=09=09set_bit(H4P_ACTIVE_MODE, &info->pm_flags);
+=09=09BT_DBG("Change pm constraints to: %s", set ?
+=09=09=09=09"set" : "clear");
+=09=09return;
+=09}
+
+=09if (!set && test_bit(H4P_ACTIVE_MODE, &info->pm_flags)) {
+=09=09bt_plat_data->set_pm_limits(info->dev, set);
+=09=09clear_bit(H4P_ACTIVE_MODE, &info->pm_flags);
+=09=09BT_DBG("Change pm constraints to: %s",
+=09=09=09=09set ? "set" : "clear");
+=09=09return;
+=09}
+
+=09BT_DBG("pm constraints remains: %s",
+=09=09=09set ? "set" : "clear");
+}
+
+static int h4p_run(void *data)
+{
+#define TIMEOUT_MIN msecs_to_jiffies(100)
+#define TIMEOUT_MAX msecs_to_jiffies(2000)
+=09struct hci_h4p_info *info =3D data;
+=09unsigned long last_jiffies =3D jiffies;
+=09unsigned long timeout =3D TIMEOUT_MIN;
+=09unsigned long elapsed;
+=09BT_DBG("");
+=09set_user_nice(current, -10);
+
+=09while (!kthread_should_stop()) {
+=09=09set_current_state(TASK_INTERRUPTIBLE);
+=09=09if (!test_bit(H4P_SCHED_TRANSFER_MODE, &info->pm_flags)) {
+=09=09=09if (timeout !=3D TIMEOUT_MIN) {
+=09=09=09=09BT_DBG("Exit from active mode. Rest. constr.");
+=09=09=09=09hci_h4p_set_pm_limits(info, false);
+=09=09=09}
+
+=09=09=09BT_DBG("No pending events. Sleeping.");
+=09=09=09schedule();
+=09=09}
+
+=09=09set_bit(H4P_TRANSFER_MODE, &info->pm_flags);
+=09=09clear_bit(H4P_SCHED_TRANSFER_MODE, &info->pm_flags);
+
+=09=09elapsed =3D jiffies - last_jiffies;
+
+=09=09BT_DBG("Wake up. %u msec expired since last BT activity.",
+=09=09=09=09jiffies_to_msecs(elapsed));
+=09=09BT_DBG("Timeout before calculation =3D %u",
+=09=09=09=09jiffies_to_msecs(timeout));
+
+=09=09/* Empiric analyzer  :-) */
+=09=09if (elapsed < TIMEOUT_MIN) {
+=09=09=09timeout <<=3D 1;
+=09=09=09timeout =3D (timeout > TIMEOUT_MAX) ?
+=09=09=09=09TIMEOUT_MAX : timeout;
+=09=09} else {
+=09=09=09timeout =3D (elapsed > timeout - TIMEOUT_MIN) ?
+=09=09=09=09TIMEOUT_MIN : timeout - elapsed;
+=09=09}
+
+=09=09BT_DBG("Timeout after calculation =3D %u",
+=09=09=09=09jiffies_to_msecs(timeout));
+
+=09=09/* Sometimes we get couple of HCI command during (e)SCO
+=09=09   connection. Turn ON transfer mode _ONLY_ if there is
+=09=09   still BT activity after 100ms sleep */
+=09=09if (timeout =3D=3D TIMEOUT_MIN)
+=09=09=09BT_DBG("Do not enable transfer mode yet");
+=09=09else {
+=09=09=09hci_h4p_set_pm_limits(info, true);
+=09=09=09BT_DBG("Set active mode for %u msec.",
+=09=09=09=09=09jiffies_to_msecs(timeout));
+=09=09}
+
+=09=09set_current_state(TASK_INTERRUPTIBLE);
+=09=09schedule_timeout(timeout);
+
+=09=09last_jiffies =3D jiffies;
+=09=09clear_bit(H4P_TRANSFER_MODE, &info->pm_flags);
+=09}
+
+=09hci_h4p_set_pm_limits(info, false);
+
+=09return 0;
+}
+
+static int hci_h4p_reset(struct hci_h4p_info *info)
+{
+=09int err;
+
+=09err =3D hci_h4p_reset_uart(info);
+=09if (err < 0) {
+=09=09dev_err(info->dev, "Uart reset failed\n");
+=09=09return err;
+=09}
+=09hci_h4p_init_uart(info);
+=09hci_h4p_set_rts(info, 0);
+
+=09gpio_set_value(info->reset_gpio, 0);
+=09gpio_set_value(info->bt_wakeup_gpio, 1);
+=09msleep(10);
+
+=09if (gpio_get_value(info->host_wakeup_gpio) =3D=3D 1) {
+=09=09dev_err(info->dev, "host_wakeup_gpio not low\n");
+=09=09return -EPROTO;
+=09}
+
+=09reinit_completion(&info->test_completion);
+=09gpio_set_value(info->reset_gpio, 1);
+
+=09if (!wait_for_completion_interruptible_timeout(&info->test_completi=
on,
+=09=09=09=09=09=09       msecs_to_jiffies(100))) {
+=09=09dev_err(info->dev, "wakeup test timed out\n");
+=09=09complete_all(&info->test_completion);
+=09=09return -EPROTO;
+=09}
+
+=09err =3D hci_h4p_wait_for_cts(info, 1, 100);
+=09if (err < 0) {
+=09=09dev_err(info->dev, "No cts from bt chip\n");
+=09=09return err;
+=09}
+
+=09hci_h4p_set_rts(info, 1);
+
+=09return 0;
+}
+
+/* hci callback functions */
+static int hci_h4p_hci_flush(struct hci_dev *hdev)
+{
+=09struct hci_h4p_info *info;
+=09info =3D hci_get_drvdata(hdev);
+
+=09skb_queue_purge(&info->txq);
+
+=09return 0;
+}
+
+static int hci_h4p_bt_wakeup_test(struct hci_h4p_info *info)
+{
+=09/* Test Sequence:
+=09 * Host de-asserts the BT_WAKE_UP line.
+=09 * Host polls the UART_CTS line, waiting for it to be de-asserted.
+=09 * Host asserts the BT_WAKE_UP line.
+=09 * Host polls the UART_CTS line, waiting for it to be asserted.
+=09 * Host de-asserts the BT_WAKE_UP line (allow the Bluetooth device =
to
+=09 * sleep).
+=09 * Host polls the UART_CTS line, waiting for it to be de-asserted.
+=09 */
+=09int err;
+=09int ret =3D -ECOMM;
+
+=09if (!info)
+=09=09return -EINVAL;
+
+=09/* Disable wakeup interrupts */
+=09disable_irq(gpio_to_irq(info->host_wakeup_gpio));
+
+=09gpio_set_value(info->bt_wakeup_gpio, 0);
+=09err =3D hci_h4p_wait_for_cts(info, 0, 100);
+=09if (err) {
+=09=09dev_warn(info->dev, "bt_wakeup_test: fail: "
+=09=09=09 "CTS low timed out: %d\n", err);
+=09=09goto out;
+=09}
+
+=09gpio_set_value(info->bt_wakeup_gpio, 1);
+=09err =3D hci_h4p_wait_for_cts(info, 1, 100);
+=09if (err) {
+=09=09dev_warn(info->dev, "bt_wakeup_test: fail: "
+=09=09=09 "CTS high timed out: %d\n", err);
+=09=09goto out;
+=09}
+
+=09gpio_set_value(info->bt_wakeup_gpio, 0);
+=09err =3D hci_h4p_wait_for_cts(info, 0, 100);
+=09if (err) {
+=09=09dev_warn(info->dev, "bt_wakeup_test: fail: "
+=09=09=09 "CTS re-low timed out: %d\n", err);
+=09=09goto out;
+=09}
+
+=09ret =3D 0;
+
+out:
+
+=09/* Re-enable wakeup interrupts */
+=09enable_irq(gpio_to_irq(info->host_wakeup_gpio));
+
+=09return ret;
+}
+
+static int hci_h4p_hci_open(struct hci_dev *hdev)
+{
+=09struct hci_h4p_info *info;
+=09int err, retries =3D 0;
+=09struct sk_buff_head fw_queue;
+=09unsigned long flags;
+
+=09info =3D hci_get_drvdata(hdev);
+
+=09if (test_bit(HCI_RUNNING, &hdev->flags))
+=09=09return 0;
+
+=09/* TI1271 has HW bug and boot up might fail. Retry up to three time=
s */
+again:
+
+=09info->rx_enabled =3D 1;
+=09info->rx_state =3D WAIT_FOR_PKT_TYPE;
+=09info->rx_count =3D 0;
+=09info->garbage_bytes =3D 0;
+=09info->rx_skb =3D NULL;
+=09info->pm_enabled =3D 0;
+=09init_completion(&info->fw_completion);
+=09hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
+=09hci_h4p_set_clk(info, &info->rx_clocks_en, 1);
+=09skb_queue_head_init(&fw_queue);
+
+=09err =3D hci_h4p_reset(info);
+=09if (err < 0)
+=09=09goto err_clean;
+
+=09hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_CTS | UART_EFR_RTS);
+=09info->autorts =3D 1;
+
+=09err =3D hci_h4p_send_negotiation(info);
+
+=09err =3D hci_h4p_read_fw(info, &fw_queue);
+=09if (err < 0) {
+=09=09dev_err(info->dev, "Cannot read firmware\n");
+=09=09goto err_clean;
+=09}
+
+=09err =3D hci_h4p_send_fw(info, &fw_queue);
+=09if (err < 0) {
+=09=09dev_err(info->dev, "Sending firmware failed.\n");
+=09=09goto err_clean;
+=09}
+
+=09info->pm_enabled =3D 1;
+
+=09err =3D hci_h4p_bt_wakeup_test(info);
+=09if (err < 0) {
+=09=09dev_err(info->dev, "BT wakeup test failed.\n");
+=09=09goto err_clean;
+=09}
+
+=09spin_lock_irqsave(&info->lock, flags);
+=09info->rx_enabled =3D gpio_get_value(info->host_wakeup_gpio);
+=09hci_h4p_set_clk(info, &info->rx_clocks_en, info->rx_enabled);
+=09spin_unlock_irqrestore(&info->lock, flags);
+
+=09hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+
+=09kfree_skb(info->alive_cmd_skb);
+=09info->alive_cmd_skb =3D NULL;
+=09set_bit(HCI_RUNNING, &hdev->flags);
+
+=09NBT_DBG("hci up and running\n");
+=09return 0;
+
+err_clean:
+=09hci_h4p_hci_flush(hdev);
+=09hci_h4p_reset_uart(info);
+=09del_timer_sync(&info->lazy_release);
+=09hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+=09hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
+=09gpio_set_value(info->reset_gpio, 0);
+=09gpio_set_value(info->bt_wakeup_gpio, 0);
+=09skb_queue_purge(&fw_queue);
+=09kfree_skb(info->alive_cmd_skb);
+=09info->alive_cmd_skb =3D NULL;
+=09kfree_skb(info->rx_skb);
+=09info->rx_skb =3D NULL;
+
+=09if (retries++ < 3) {
+=09=09dev_err(info->dev, "FW loading try %d fail. Retry.\n", retries);=

+=09=09goto again;
+=09}
+
+=09return err;
+}
+
+static int hci_h4p_hci_close(struct hci_dev *hdev)
+{
+=09struct hci_h4p_info *info =3D hci_get_drvdata(hdev);
+
+=09if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
+=09=09return 0;
+
+=09/* Wake up h4p_thread which removes pm constraints */
+=09wake_up_process(h4p_thread);
+
+=09hci_h4p_hci_flush(hdev);
+=09hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
+=09hci_h4p_set_clk(info, &info->rx_clocks_en, 1);
+=09hci_h4p_reset_uart(info);
+=09del_timer_sync(&info->lazy_release);
+=09hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+=09hci_h4p_set_clk(info, &info->rx_clocks_en, 0);
+=09gpio_set_value(info->reset_gpio, 0);
+=09gpio_set_value(info->bt_wakeup_gpio, 0);
+=09kfree_skb(info->rx_skb);
+
+=09return 0;
+}
+
+static int hci_h4p_hci_send_frame(struct hci_dev *hdev, struct sk_buff=
 *skb)
+{
+=09struct hci_h4p_info *info;
+=09int err =3D 0;
+
+=09if (!hdev) {
+=09=09printk(KERN_WARNING "hci_h4p: Frame for unknown device\n");
+=09=09return -ENODEV;
+=09}
+
+=09NBT_DBG("dev %p, skb %p\n", hdev, skb);
+
+=09info =3D hci_get_drvdata(hdev);
+
+=09if (!test_bit(HCI_RUNNING, &hdev->flags)) {
+=09=09dev_warn(info->dev, "Frame for non-running device\n");
+=09=09return -EIO;
+=09}
+
+=09switch (bt_cb(skb)->pkt_type) {
+=09case HCI_COMMAND_PKT:
+=09=09hdev->stat.cmd_tx++;
+=09=09break;
+=09case HCI_ACLDATA_PKT:
+=09=09hdev->stat.acl_tx++;
+=09=09break;
+=09case HCI_SCODATA_PKT:
+=09=09hdev->stat.sco_tx++;
+=09=09break;
+=09}
+
+=09/* Push frame type to skb */
+=09*skb_push(skb, 1) =3D (bt_cb(skb)->pkt_type);
+=09/* We should allways send word aligned data to h4+ devices */
+=09if (skb->len % 2) {
+=09=09err =3D skb_pad(skb, 1);
+=09=09if (!err)
+=09=09=09*skb_put(skb, 1) =3D 0x00;
+=09}
+=09if (err)
+=09=09return err;
+
+=09skb_queue_tail(&info->txq, skb);
+=09hci_h4p_enable_tx(info);
+
+=09return 0;
+}
+
+static ssize_t hci_h4p_store_bdaddr(struct device *dev,
+=09=09=09=09    struct device_attribute *attr,
+=09=09=09=09    const char *buf, size_t count)
+{
+=09struct hci_h4p_info *info =3D dev_get_drvdata(dev);
+=09unsigned int bdaddr[6];
+=09int ret, i;
+
+=09ret =3D sscanf(buf, "%2x:%2x:%2x:%2x:%2x:%2x\n",
+=09=09=09&bdaddr[0], &bdaddr[1], &bdaddr[2],
+=09=09=09&bdaddr[3], &bdaddr[4], &bdaddr[5]);
+
+=09if (ret !=3D 6)
+=09=09return -EINVAL;
+
+=09for (i =3D 0; i < 6; i++)
+=09=09info->bd_addr[i] =3D bdaddr[i] & 0xff;
+
+=09return count;
+}
+
+static ssize_t hci_h4p_show_bdaddr(struct device *dev,
+=09=09=09=09   struct device_attribute *attr, char *buf)
+{
+=09struct hci_h4p_info *info =3D dev_get_drvdata(dev);
+
+=09return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
+=09=09       info->bd_addr[0], info->bd_addr[1], info->bd_addr[2],
+=09=09       info->bd_addr[3], info->bd_addr[4], info->bd_addr[5]);
+}
+
+static DEVICE_ATTR(bdaddr, S_IRUGO | S_IWUSR, hci_h4p_show_bdaddr,
+=09=09   hci_h4p_store_bdaddr);
+
+static int hci_h4p_sysfs_create_files(struct device *dev)
+{
+=09return device_create_file(dev, &dev_attr_bdaddr);
+}
+
+static void hci_h4p_sysfs_remove_files(struct device *dev)
+{
+=09device_remove_file(dev, &dev_attr_bdaddr);
+}
+
+static int hci_h4p_register_hdev(struct hci_h4p_info *info)
+{
+=09struct hci_dev *hdev;
+
+=09/* Initialize and register HCI device */
+
+=09hdev =3D hci_alloc_dev();
+=09if (!hdev) {
+=09=09dev_err(info->dev, "Can't allocate memory for device\n");
+=09=09return -ENOMEM;
+=09}
+=09info->hdev =3D hdev;
+
+=09hdev->bus =3D HCI_UART;
+=09hci_set_drvdata(hdev, info);
+
+=09hdev->open =3D hci_h4p_hci_open;
+=09hdev->close =3D hci_h4p_hci_close;
+=09hdev->flush =3D hci_h4p_hci_flush;
+=09hdev->send =3D hci_h4p_hci_send_frame;
+=09set_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
+
+=09SET_HCIDEV_DEV(hdev, info->dev);
+
+=09if (hci_h4p_sysfs_create_files(info->dev) < 0) {
+=09=09dev_err(info->dev, "failed to create sysfs files\n");
+=09=09return -ENODEV;
+=09}
+
+=09if (hci_register_dev(hdev) < 0) {
+=09=09dev_err(info->dev, "hci_register failed %s.\n", hdev->name);
+=09=09hci_h4p_sysfs_remove_files(info->dev);
+=09=09return -ENODEV;
+=09}
+
+=09return 0;
+}
+
+static int hci_h4p_probe(struct platform_device *pdev)
+{
+=09struct hci_h4p_platform_data *bt_plat_data;
+=09struct hci_h4p_info *info;
+=09int err;
+
+=09dev_info(&pdev->dev, "Registering HCI H4P device\n");
+=09info =3D kzalloc(sizeof(struct hci_h4p_info), GFP_KERNEL);
+=09if (!info)
+=09=09return -ENOMEM;
+
+=09info->dev =3D &pdev->dev;
+=09info->tx_enabled =3D 1;
+=09info->rx_enabled =3D 1;
+=09spin_lock_init(&info->lock);
+=09spin_lock_init(&info->clocks_lock);
+=09skb_queue_head_init(&info->txq);
+
+=09if (pdev->dev.platform_data =3D=3D NULL) {
+=09=09dev_err(&pdev->dev, "Could not get Bluetooth config data\n");
+=09=09kfree(info);
+=09=09return -ENODATA;
+=09}
+
+=09bt_plat_data =3D pdev->dev.platform_data;
+=09info->chip_type =3D bt_plat_data->chip_type;
+=09info->bt_wakeup_gpio =3D bt_plat_data->bt_wakeup_gpio;
+=09info->host_wakeup_gpio =3D bt_plat_data->host_wakeup_gpio;
+=09info->reset_gpio =3D bt_plat_data->reset_gpio;
+=09info->reset_gpio_shared =3D bt_plat_data->reset_gpio_shared;
+=09info->bt_sysclk =3D bt_plat_data->bt_sysclk;
+
+=09NBT_DBG("RESET gpio: %d\n", info->reset_gpio);
+=09NBT_DBG("BTWU gpio: %d\n", info->bt_wakeup_gpio);
+=09NBT_DBG("HOSTWU gpio: %d\n", info->host_wakeup_gpio);
+=09NBT_DBG("sysclk: %d\n", info->bt_sysclk);
+
+=09init_completion(&info->test_completion);
+=09complete_all(&info->test_completion);
+
+=09if (!info->reset_gpio_shared) {
+=09=09err =3D gpio_request(info->reset_gpio, "bt_reset");
+=09=09if (err < 0) {
+=09=09=09dev_err(&pdev->dev, "Cannot get GPIO line %d\n",
+=09=09=09=09info->reset_gpio);
+=09=09=09goto cleanup_setup;
+=09=09}
+=09}
+
+=09err =3D gpio_request(info->bt_wakeup_gpio, "bt_wakeup");
+=09if (err < 0) {
+=09=09dev_err(info->dev, "Cannot get GPIO line 0x%d",
+=09=09=09info->bt_wakeup_gpio);
+=09=09if (!info->reset_gpio_shared)
+=09=09=09gpio_free(info->reset_gpio);
+=09=09goto cleanup_setup;
+=09}
+
+=09err =3D gpio_request(info->host_wakeup_gpio, "host_wakeup");
+=09if (err < 0) {
+=09=09dev_err(info->dev, "Cannot get GPIO line %d",
+=09=09       info->host_wakeup_gpio);
+=09=09if (!info->reset_gpio_shared)
+=09=09=09gpio_free(info->reset_gpio);
+=09=09gpio_free(info->bt_wakeup_gpio);
+=09=09goto cleanup_setup;
+=09}
+
+=09gpio_direction_output(info->reset_gpio, 0);
+=09gpio_direction_output(info->bt_wakeup_gpio, 0);
+=09gpio_direction_input(info->host_wakeup_gpio);
+
+=09info->irq =3D bt_plat_data->uart_irq;
+=09info->uart_base =3D ioremap(bt_plat_data->uart_base, SZ_2K);
+=09info->uart_iclk =3D clk_get(NULL, bt_plat_data->uart_iclk);
+=09info->uart_fclk =3D clk_get(NULL, bt_plat_data->uart_fclk);
+
+=09err =3D request_irq(info->irq, hci_h4p_interrupt, IRQF_DISABLED, "h=
ci_h4p",
+=09=09=09  info);
+=09if (err < 0) {
+=09=09dev_err(info->dev, "hci_h4p: unable to get IRQ %d\n", info->irq)=
;
+=09=09goto cleanup;
+=09}
+
+=09err =3D request_irq(gpio_to_irq(info->host_wakeup_gpio),
+=09=09=09  hci_h4p_wakeup_interrupt,  IRQF_TRIGGER_FALLING |
+=09=09=09  IRQF_TRIGGER_RISING | IRQF_DISABLED,
+=09=09=09  "hci_h4p_wkup", info);
+=09if (err < 0) {
+=09=09dev_err(info->dev, "hci_h4p: unable to get wakeup IRQ %d\n",
+=09=09=09  gpio_to_irq(info->host_wakeup_gpio));
+=09=09free_irq(info->irq, info);
+=09=09goto cleanup;
+=09}
+
+=09err =3D irq_set_irq_wake(gpio_to_irq(info->host_wakeup_gpio), 1);
+=09if (err < 0) {
+=09=09dev_err(info->dev, "hci_h4p: unable to set wakeup for IRQ %d\n",=

+=09=09=09=09gpio_to_irq(info->host_wakeup_gpio));
+=09=09free_irq(info->irq, info);
+=09=09free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
+=09=09goto cleanup;
+=09}
+
+=09init_timer_deferrable(&info->lazy_release);
+=09info->lazy_release.function =3D hci_h4p_lazy_clock_release;
+=09info->lazy_release.data =3D (unsigned long)info;
+=09hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
+=09err =3D hci_h4p_reset_uart(info);
+=09if (err < 0)
+=09=09goto cleanup_irq;
+=09gpio_set_value(info->reset_gpio, 0);
+=09hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
+
+=09platform_set_drvdata(pdev, info);
+
+=09if (hci_h4p_register_hdev(info) < 0) {
+=09=09dev_err(info->dev, "failed to register hci_h4p hci device\n");
+=09=09goto cleanup_irq;
+=09}
+
+=09h4p_thread =3D kthread_run(h4p_run, info, "h4p_pm");
+=09if (IS_ERR(h4p_thread)) {
+=09=09err =3D PTR_ERR(h4p_thread);
+=09=09goto cleanup_irq;
+=09}
+
+=09return 0;
+
+cleanup_irq:
+=09free_irq(info->irq, (void *)info);
+=09free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
+cleanup:
+=09gpio_set_value(info->reset_gpio, 0);
+=09if (!info->reset_gpio_shared)
+=09=09gpio_free(info->reset_gpio);
+=09gpio_free(info->bt_wakeup_gpio);
+=09gpio_free(info->host_wakeup_gpio);
+
+cleanup_setup:
+
+=09kfree(info);
+=09return err;
+
+}
+
+static int hci_h4p_remove(struct platform_device *pdev)
+{
+=09struct hci_h4p_info *info;
+
+=09info =3D platform_get_drvdata(pdev);
+
+=09kthread_stop(h4p_thread);
+
+=09hci_h4p_sysfs_remove_files(info->dev);
+=09hci_h4p_hci_close(info->hdev);
+=09free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
+=09hci_unregister_dev(info->hdev);
+=09hci_free_dev(info->hdev);
+=09if (!info->reset_gpio_shared)
+=09=09gpio_free(info->reset_gpio);
+=09gpio_free(info->bt_wakeup_gpio);
+=09gpio_free(info->host_wakeup_gpio);
+=09free_irq(info->irq, (void *) info);
+=09kfree(info);
+
+=09return 0;
+}
+
+static struct platform_driver hci_h4p_driver =3D {
+=09.probe=09=09=3D hci_h4p_probe,
+=09.remove=09=09=3D hci_h4p_remove,
+=09.driver=09=09=3D {
+=09=09.name=09=3D "hci_h4p",
+=09},
+};
+
+static int __init hci_h4p_init(void)
+{
+=09int err =3D 0;
+
+=09/* Register the driver with LDM */
+=09err =3D platform_driver_register(&hci_h4p_driver);
+=09if (err < 0)
+=09=09printk(KERN_WARNING "failed to register hci_h4p driver\n");
+
+=09return err;
+}
+
+static void __exit hci_h4p_exit(void)
+{
+=09platform_driver_unregister(&hci_h4p_driver);
+}
+
+module_init(hci_h4p_init);
+module_exit(hci_h4p_exit);
+
+MODULE_ALIAS("platform:hci_h4p");
+MODULE_DESCRIPTION("Bluetooth h4 driver with nokia extensions");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ville Tervo");
+MODULE_FIRMWARE(FW_NAME_TI1271_PRELE);
+MODULE_FIRMWARE(FW_NAME_TI1271_LE);
+MODULE_FIRMWARE(FW_NAME_TI1271);
+MODULE_FIRMWARE(FW_NAME_BCM2048);
+MODULE_FIRMWARE(FW_NAME_CSR);
diff --git a/drivers/bluetooth/hci_h4p/fw-bcm.c b/drivers/bluetooth/hci=
_h4p/fw-bcm.c
new file mode 100644
index 0000000..390d021
=2D-- /dev/null
+++ b/drivers/bluetooth/hci_h4p/fw-bcm.c
@@ -0,0 +1,149 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005-2008 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but=

+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <linux/serial_reg.h>
+
+#include "hci_h4p.h"
+
+static int hci_h4p_bcm_set_bdaddr(struct hci_h4p_info *info, struct sk=
_buff *skb)
+{
+=09int i;
+=09static const u8 nokia_oui[3] =3D {0x00, 0x1f, 0xdf};
+=09int not_valid;
+
+=09not_valid =3D 1;
+=09for (i =3D 0; i < 6; i++) {
+=09=09if (info->bd_addr[i] !=3D 0x00) {
+=09=09=09not_valid =3D 0;
+=09=09=09break;
+=09=09}
+=09}
+
+=09if (not_valid) {
+=09=09dev_info(info->dev, "Valid bluetooth address not found, setting =
some random\n");
+=09=09/* When address is not valid, use some random but Nokia MAC */
+=09=09memcpy(info->bd_addr, nokia_oui, 3);
+=09=09get_random_bytes(info->bd_addr + 3, 3);
+=09}
+
+=09for (i =3D 0; i < 6; i++)
+=09=09skb->data[9 - i] =3D info->bd_addr[i];
+
+=09return 0;
+}
+
+void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info, struct sk_b=
uff *skb)
+{
+=09struct sk_buff *fw_skb;
+=09int err;
+=09unsigned long flags;
+
+=09if (skb->data[5] !=3D 0x00) {
+=09=09dev_err(info->dev, "Firmware sending command failed 0x%.2x\n",
+=09=09=09skb->data[5]);
+=09=09info->fw_error =3D -EPROTO;
+=09}
+
+=09kfree_skb(skb);
+
+=09fw_skb =3D skb_dequeue(info->fw_q);
+=09if (fw_skb =3D=3D NULL || info->fw_error) {
+=09=09complete(&info->fw_completion);
+=09=09return;
+=09}
+
+=09if (fw_skb->data[1] =3D=3D 0x01 && fw_skb->data[2] =3D=3D 0xfc && f=
w_skb->len >=3D 10) {
+=09=09NBT_DBG_FW("Setting bluetooth address\n");
+=09=09err =3D hci_h4p_bcm_set_bdaddr(info, fw_skb);
+=09=09if (err < 0) {
+=09=09=09kfree_skb(fw_skb);
+=09=09=09info->fw_error =3D err;
+=09=09=09complete(&info->fw_completion);
+=09=09=09return;
+=09=09}
+=09}
+
+=09skb_queue_tail(&info->txq, fw_skb);
+=09spin_lock_irqsave(&info->lock, flags);
+=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09=09UART_IER_THRI);
+=09spin_unlock_irqrestore(&info->lock, flags);
+}
+
+
+int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
+=09=09=09struct sk_buff_head *fw_queue)
+{
+=09struct sk_buff *skb;
+=09unsigned long flags, time;
+
+=09info->fw_error =3D 0;
+
+=09NBT_DBG_FW("Sending firmware\n");
+
+=09time =3D jiffies;
+
+=09info->fw_q =3D fw_queue;
+=09skb =3D skb_dequeue(fw_queue);
+=09if (!skb)
+=09=09return -ENODATA;
+
+=09NBT_DBG_FW("Sending commands\n");
+
+=09/*
+=09 * Disable smart-idle as UART TX interrupts
+=09 * are not wake-up capable
+=09 */
+=09hci_h4p_smart_idle(info, 0);
+
+=09/* Check if this is bd_address packet */
+=09init_completion(&info->fw_completion);
+=09skb_queue_tail(&info->txq, skb);
+=09spin_lock_irqsave(&info->lock, flags);
+=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09=09UART_IER_THRI);
+=09spin_unlock_irqrestore(&info->lock, flags);
+
+=09if (!wait_for_completion_timeout(&info->fw_completion,
+=09=09=09=09msecs_to_jiffies(2000))) {
+=09=09dev_err(info->dev, "No reply to fw command\n");
+=09=09return -ETIMEDOUT;
+=09}
+
+=09if (info->fw_error) {
+=09=09dev_err(info->dev, "FW error\n");
+=09=09return -EPROTO;
+=09}
+
+=09NBT_DBG_FW("Firmware sent in %d msecs\n",
+=09=09   jiffies_to_msecs(jiffies-time));
+
+=09hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+=09hci_h4p_set_rts(info, 0);
+=09hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
+=09hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+
+=09return 0;
+}
diff --git a/drivers/bluetooth/hci_h4p/fw-csr.c b/drivers/bluetooth/hci=
_h4p/fw-csr.c
new file mode 100644
index 0000000..020fa52
=2D-- /dev/null
+++ b/drivers/bluetooth/hci_h4p/fw-csr.c
@@ -0,0 +1,152 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005-2008 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but=

+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <linux/serial_reg.h>
+
+#include "hci_h4p.h"
+
+void hci_h4p_bc4_parse_fw_event(struct hci_h4p_info *info, struct sk_b=
uff *skb)
+{
+=09/* Check if this is fw packet */
+=09if (skb->data[0] !=3D 0xff) {
+=09=09hci_recv_frame(info->hdev, skb);
+=09=09return;
+=09}
+
+=09if (skb->data[11] || skb->data[12]) {
+=09=09dev_err(info->dev, "Firmware sending command failed\n");
+=09=09info->fw_error =3D -EPROTO;
+=09}
+
+=09kfree_skb(skb);
+=09complete(&info->fw_completion);
+}
+
+int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
+=09=09=09struct sk_buff_head *fw_queue)
+{
+=09static const u8 nokia_oui[3] =3D {0x00, 0x19, 0x4F};
+=09struct sk_buff *skb;
+=09unsigned int offset;
+=09int retries, count, i, not_valid;
+=09unsigned long flags;
+
+=09info->fw_error =3D 0;
+
+=09NBT_DBG_FW("Sending firmware\n");
+=09skb =3D skb_dequeue(fw_queue);
+
+=09if (!skb)
+=09=09return -ENOMSG;
+
+=09/* Check if this is bd_address packet */
+=09if (skb->data[15] =3D=3D 0x01 && skb->data[16] =3D=3D 0x00) {
+=09=09offset =3D 21;
+=09=09skb->data[offset + 1] =3D 0x00;
+=09=09skb->data[offset + 5] =3D 0x00;
+
+=09=09not_valid =3D 1;
+=09=09for (i =3D 0; i < 6; i++) {
+=09=09=09if (info->bd_addr[i] !=3D 0x00) {
+=09=09=09=09not_valid =3D 0;
+=09=09=09=09break;
+=09=09=09}
+=09=09}
+
+=09=09if (not_valid) {
+=09=09=09dev_info(info->dev, "Valid bluetooth address not found,"
+=09=09=09=09=09" setting some random\n");
+=09=09=09/* When address is not valid, use some random */
+=09=09=09memcpy(info->bd_addr, nokia_oui, 3);
+=09=09=09get_random_bytes(info->bd_addr + 3, 3);
+=09=09}
+
+=09=09skb->data[offset + 7] =3D info->bd_addr[0];
+=09=09skb->data[offset + 6] =3D info->bd_addr[1];
+=09=09skb->data[offset + 4] =3D info->bd_addr[2];
+=09=09skb->data[offset + 0] =3D info->bd_addr[3];
+=09=09skb->data[offset + 3] =3D info->bd_addr[4];
+=09=09skb->data[offset + 2] =3D info->bd_addr[5];
+=09}
+
+=09for (count =3D 1; ; count++) {
+=09=09NBT_DBG_FW("Sending firmware command %d\n", count);
+=09=09init_completion(&info->fw_completion);
+=09=09skb_queue_tail(&info->txq, skb);
+=09=09spin_lock_irqsave(&info->lock, flags);
+=09=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09=09=09=09=09=09 UART_IER_THRI);
+=09=09spin_unlock_irqrestore(&info->lock, flags);
+
+=09=09skb =3D skb_dequeue(fw_queue);
+=09=09if (!skb)
+=09=09=09break;
+
+=09=09if (!wait_for_completion_timeout(&info->fw_completion,
+=09=09=09=09=09=09 msecs_to_jiffies(1000))) {
+=09=09=09dev_err(info->dev, "No reply to fw command\n");
+=09=09=09return -ETIMEDOUT;
+=09=09}
+
+=09=09if (info->fw_error) {
+=09=09=09dev_err(info->dev, "FW error\n");
+=09=09=09return -EPROTO;
+=09=09}
+=09};
+
+=09/* Wait for chip warm reset */
+=09retries =3D 100;
+=09while ((!skb_queue_empty(&info->txq) ||
+=09       !(hci_h4p_inb(info, UART_LSR) & UART_LSR_TEMT)) &&
+=09       retries--) {
+=09=09msleep(10);
+=09}
+=09if (!retries) {
+=09=09dev_err(info->dev, "Transmitter not empty\n");
+=09=09return -ETIMEDOUT;
+=09}
+
+=09hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
+
+=09if (hci_h4p_wait_for_cts(info, 1, 100)) {
+=09=09dev_err(info->dev, "cts didn't deassert after final speed\n");
+=09=09return -ETIMEDOUT;
+=09}
+
+=09retries =3D 100;
+=09do {
+=09=09init_completion(&info->init_completion);
+=09=09hci_h4p_send_alive_packet(info);
+=09=09retries--;
+=09} while (!wait_for_completion_timeout(&info->init_completion, 100) =
&&
+=09=09 retries > 0);
+
+=09if (!retries) {
+=09=09dev_err(info->dev, "No alive reply after speed change\n");
+=09=09return -ETIMEDOUT;
+=09}
+
+=09return 0;
+}
diff --git a/drivers/bluetooth/hci_h4p/fw-ti1273.c b/drivers/bluetooth/=
hci_h4p/fw-ti1273.c
new file mode 100644
index 0000000..32e5fa0
=2D-- /dev/null
+++ b/drivers/bluetooth/hci_h4p/fw-ti1273.c
@@ -0,0 +1,112 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2009 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but=

+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/delay.h>
+#include <linux/serial_reg.h>
+
+#include "hci_h4p.h"
+
+static struct sk_buff_head *fw_q;
+
+void hci_h4p_ti1273_parse_fw_event(struct hci_h4p_info *info,
+=09=09=09struct sk_buff *skb)
+{
+=09struct sk_buff *fw_skb;
+=09unsigned long flags;
+
+=09if (skb->data[5] !=3D 0x00) {
+=09=09dev_err(info->dev, "Firmware sending command failed 0x%.2x\n",
+=09=09=09skb->data[5]);
+=09=09info->fw_error =3D -EPROTO;
+=09}
+
+=09kfree_skb(skb);
+
+=09fw_skb =3D skb_dequeue(fw_q);
+=09if (fw_skb =3D=3D NULL || info->fw_error) {
+=09=09complete(&info->fw_completion);
+=09=09return;
+=09}
+
+=09skb_queue_tail(&info->txq, fw_skb);
+=09spin_lock_irqsave(&info->lock, flags);
+=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09=09UART_IER_THRI);
+=09spin_unlock_irqrestore(&info->lock, flags);
+}
+
+
+int hci_h4p_ti1273_send_fw(struct hci_h4p_info *info,
+=09=09=09struct sk_buff_head *fw_queue)
+{
+=09struct sk_buff *skb;
+=09unsigned long flags, time;
+
+=09info->fw_error =3D 0;
+
+=09NBT_DBG_FW("Sending firmware\n");
+
+=09time =3D jiffies;
+
+=09fw_q =3D fw_queue;
+=09skb =3D skb_dequeue(fw_queue);
+=09if (!skb)
+=09=09return -ENODATA;
+
+=09NBT_DBG_FW("Sending commands\n");
+=09/* Check if this is bd_address packet */
+=09init_completion(&info->fw_completion);
+=09hci_h4p_smart_idle(info, 0);
+=09skb_queue_tail(&info->txq, skb);
+=09spin_lock_irqsave(&info->lock, flags);
+=09hci_h4p_outb(info, UART_IER, hci_h4p_inb(info, UART_IER) |
+=09=09=09UART_IER_THRI);
+=09spin_unlock_irqrestore(&info->lock, flags);
+
+=09if (!wait_for_completion_timeout(&info->fw_completion,
+=09=09=09=09msecs_to_jiffies(2000))) {
+=09=09dev_err(info->dev, "No reply to fw command\n");
+=09=09return -ETIMEDOUT;
+=09}
+
+=09if (info->fw_error) {
+=09=09dev_err(info->dev, "FW error\n");
+=09=09return -EPROTO;
+=09}
+
+=09NBT_DBG_FW("Firmware sent in %d msecs\n",
+=09=09   jiffies_to_msecs(jiffies-time));
+
+=09hci_h4p_set_auto_ctsrts(info, 0, UART_EFR_RTS);
+=09hci_h4p_set_rts(info, 0);
+=09hci_h4p_change_speed(info, BC4_MAX_BAUD_RATE);
+=09if (hci_h4p_wait_for_cts(info, 1, 100)) {
+=09=09dev_err(info->dev,
+=09=09=09"cts didn't go down after final speed change\n");
+=09=09return -ETIMEDOUT;
+=09}
+=09hci_h4p_set_auto_ctsrts(info, 1, UART_EFR_RTS);
+
+=09return 0;
+}
diff --git a/drivers/bluetooth/hci_h4p/fw.c b/drivers/bluetooth/hci_h4p=
/fw.c
new file mode 100644
index 0000000..b3d39f9
=2D-- /dev/null
+++ b/drivers/bluetooth/hci_h4p/fw.c
@@ -0,0 +1,195 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005, 2006 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but=

+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/skbuff.h>
+#include <linux/firmware.h>
+#include <linux/clk.h>
+
+#include <net/bluetooth/bluetooth.h>
+
+#include "hci_h4p.h"
+
+static int fw_pos;
+
+/* Firmware handling */
+static int hci_h4p_open_firmware(struct hci_h4p_info *info,
+=09=09=09=09 const struct firmware **fw_entry)
+{
+=09int err;
+
+=09fw_pos =3D 0;
+=09NBT_DBG_FW("Opening firmware man_id 0x%.2x ver_id 0x%.2x\n",
+=09=09=09info->man_id, info->ver_id);
+=09switch (info->man_id) {
+=09case H4P_ID_TI1271:
+=09=09switch (info->ver_id) {
+=09=09case 0xe1:
+=09=09=09err =3D request_firmware(fw_entry, FW_NAME_TI1271_PRELE,
+=09=09=09=09=09=09info->dev);
+=09=09=09break;
+=09=09case 0xd1:
+=09=09case 0xf1:
+=09=09=09err =3D request_firmware(fw_entry, FW_NAME_TI1271_LE,
+=09=09=09=09=09=09info->dev);
+=09=09=09break;
+=09=09default:
+=09=09=09err =3D request_firmware(fw_entry, FW_NAME_TI1271,
+=09=09=09=09=09=09info->dev);
+=09=09}
+=09=09break;
+=09case H4P_ID_CSR:
+=09=09err =3D request_firmware(fw_entry, FW_NAME_CSR, info->dev);
+=09=09break;
+=09case H4P_ID_BCM2048:
+=09=09err =3D request_firmware(fw_entry, FW_NAME_BCM2048, info->dev);
+=09=09break;
+=09default:
+=09=09dev_err(info->dev, "Invalid chip type\n");
+=09=09*fw_entry =3D NULL;
+=09=09err =3D -EINVAL;
+=09}
+
+=09return err;
+}
+
+static void hci_h4p_close_firmware(const struct firmware *fw_entry)
+{
+=09release_firmware(fw_entry);
+}
+
+/* Read fw. Return length of the command. If no more commands in
+ * fw 0 is returned. In error case return value is negative.
+ */
+static int hci_h4p_read_fw_cmd(struct hci_h4p_info *info, struct sk_bu=
ff **skb,
+=09=09=09       const struct firmware *fw_entry, gfp_t how)
+{
+=09unsigned int cmd_len;
+
+=09if (fw_pos >=3D fw_entry->size)
+=09=09return 0;
+
+=09if (fw_pos + 2 > fw_entry->size) {
+=09=09dev_err(info->dev, "Corrupted firmware image 1\n");
+=09=09return -EMSGSIZE;
+=09}
+
+=09cmd_len =3D fw_entry->data[fw_pos++];
+=09cmd_len +=3D fw_entry->data[fw_pos++] << 8;
+=09if (cmd_len =3D=3D 0)
+=09=09return 0;
+
+=09if (fw_pos + cmd_len > fw_entry->size) {
+=09=09dev_err(info->dev, "Corrupted firmware image 2\n");
+=09=09return -EMSGSIZE;
+=09}
+
+=09*skb =3D bt_skb_alloc(cmd_len, how);
+=09if (!*skb) {
+=09=09dev_err(info->dev, "Cannot reserve memory for buffer\n");
+=09=09return -ENOMEM;
+=09}
+=09memcpy(skb_put(*skb, cmd_len), &fw_entry->data[fw_pos], cmd_len);
+
+=09fw_pos +=3D cmd_len;
+
+=09return (*skb)->len;
+}
+
+int hci_h4p_read_fw(struct hci_h4p_info *info, struct sk_buff_head *fw=
_queue)
+{
+=09const struct firmware *fw_entry =3D NULL;
+=09struct sk_buff *skb =3D NULL;
+=09int err;
+
+=09err =3D hci_h4p_open_firmware(info, &fw_entry);
+=09if (err < 0 || !fw_entry)
+=09=09goto err_clean;
+
+=09while ((err =3D hci_h4p_read_fw_cmd(info, &skb, fw_entry, GFP_KERNE=
L))) {
+=09=09if (err < 0 || !skb)
+=09=09=09goto err_clean;
+
+=09=09skb_queue_tail(fw_queue, skb);
+=09}
+
+=09/* Chip detection code does neg and alive stuff
+=09 * discard two first skbs */
+=09skb =3D skb_dequeue(fw_queue);
+=09if (!skb) {
+=09=09err =3D -EMSGSIZE;
+=09=09goto err_clean;
+=09}
+=09kfree_skb(skb);
+=09skb =3D skb_dequeue(fw_queue);
+=09if (!skb) {
+=09=09err =3D -EMSGSIZE;
+=09=09goto err_clean;
+=09}
+=09kfree_skb(skb);
+
+err_clean:
+=09hci_h4p_close_firmware(fw_entry);
+=09return err;
+}
+
+int hci_h4p_send_fw(struct hci_h4p_info *info, struct sk_buff_head *fw=
_queue)
+{
+=09int err;
+
+=09switch (info->man_id) {
+=09case H4P_ID_CSR:
+=09=09err =3D hci_h4p_bc4_send_fw(info, fw_queue);
+=09=09break;
+=09case H4P_ID_TI1271:
+=09=09err =3D hci_h4p_ti1273_send_fw(info, fw_queue);
+=09=09break;
+=09case H4P_ID_BCM2048:
+=09=09err =3D hci_h4p_bcm_send_fw(info, fw_queue);
+=09=09break;
+=09default:
+=09=09dev_err(info->dev, "Don't know how to send firmware\n");
+=09=09err =3D -EINVAL;
+=09}
+
+=09return err;
+}
+
+void hci_h4p_parse_fw_event(struct hci_h4p_info *info, struct sk_buff =
*skb)
+{
+=09switch (info->man_id) {
+=09case H4P_ID_CSR:
+=09=09hci_h4p_bc4_parse_fw_event(info, skb);
+=09=09break;
+=09case H4P_ID_TI1271:
+=09=09hci_h4p_ti1273_parse_fw_event(info, skb);
+=09=09break;
+=09case H4P_ID_BCM2048:
+=09=09hci_h4p_bcm_parse_fw_event(info, skb);
+=09=09break;
+=09default:
+=09=09dev_err(info->dev, "Don't know how to parse fw event\n");
+=09=09info->fw_error =3D -EINVAL;
+=09}
+
+=09return;
+}
diff --git a/drivers/bluetooth/hci_h4p/hci_h4p.h b/drivers/bluetooth/hc=
i_h4p/hci_h4p.h
new file mode 100644
index 0000000..d1d313b
=2D-- /dev/null
+++ b/drivers/bluetooth/hci_h4p/hci_h4p.h
@@ -0,0 +1,248 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005-2008 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but=

+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/hci.h>
+
+#ifndef __DRIVERS_BLUETOOTH_HCI_H4P_H
+#define __DRIVERS_BLUETOOTH_HCI_H4P_H
+
+#define FW_NAME_TI1271_PRELE=09"ti1273_prele.bin"
+#define FW_NAME_TI1271_LE=09"ti1273_le.bin"
+#define FW_NAME_TI1271=09=09"ti1273.bin"
+#define FW_NAME_BCM2048=09=09"bcmfw.bin"
+#define FW_NAME_CSR=09=09"bc4fw.bin"
+
+#define UART_SYSC_OMAP_RESET=090x03
+#define UART_SYSS_RESETDONE=090x01
+#define UART_OMAP_SCR_EMPTY_THR=090x08
+#define UART_OMAP_SCR_WAKEUP=090x10
+#define UART_OMAP_SSR_WAKEUP=090x02
+#define UART_OMAP_SSR_TXFULL=090x01
+
+#define UART_OMAP_SYSC_IDLEMODE=09=090x03
+#define UART_OMAP_SYSC_IDLEMASK=09=09(3 << UART_OMAP_SYSC_IDLEMODE)
+
+#define UART_OMAP_SYSC_FORCE_IDLE=09(0 << UART_OMAP_SYSC_IDLEMODE)
+#define UART_OMAP_SYSC_NO_IDLE=09=09(1 << UART_OMAP_SYSC_IDLEMODE)
+#define UART_OMAP_SYSC_SMART_IDLE=09(2 << UART_OMAP_SYSC_IDLEMODE)
+
+#define NBT_DBG(fmt, arg...) \
+=09=09pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define NBT_DBG_FW(fmt, arg...) \
+=09=09pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define NBT_DBG_POWER(fmt, arg...) \
+=09=09pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define NBT_DBG_TRANSFER(fmt, arg...) \
+=09=09pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define NBT_DBG_TRANSFER_NF(fmt, arg...) \
+=09=09pr_debug(fmt "" , ## arg)
+
+#define NBT_DBG_DMA(fmt, arg...) \
+=09=09pr_debug("%s: " fmt "" , __func__ , ## arg)
+
+#define H4P_TRANSFER_MODE=09=091
+#define H4P_SCHED_TRANSFER_MODE=09=092
+#define H4P_ACTIVE_MODE=09=09=093
+
+struct hci_h4p_info {
+=09struct timer_list lazy_release;
+=09struct hci_dev *hdev;
+=09spinlock_t lock;
+
+=09void __iomem *uart_base;
+=09unsigned long uart_phys_base;
+=09int irq;
+=09struct device *dev;
+=09u8 chip_type;
+=09u8 bt_wakeup_gpio;
+=09u8 host_wakeup_gpio;
+=09u8 reset_gpio;
+=09u8 reset_gpio_shared;
+=09u8 bt_sysclk;
+=09u8 man_id;
+=09u8 ver_id;
+
+=09struct sk_buff_head fw_queue;
+=09struct sk_buff *alive_cmd_skb;
+=09struct completion init_completion;
+=09struct completion fw_completion;
+=09struct completion test_completion;
+=09int fw_error;
+=09int init_error;
+
+=09struct sk_buff_head txq;
+
+=09struct sk_buff *rx_skb;
+=09long rx_count;
+=09unsigned long rx_state;
+=09unsigned long garbage_bytes;
+
+=09u8 bd_addr[6];
+=09struct sk_buff_head *fw_q;
+
+=09int pm_enabled;
+=09int tx_enabled;
+=09int autorts;
+=09int rx_enabled;
+=09unsigned long pm_flags;
+
+=09int tx_clocks_en;
+=09int rx_clocks_en;
+=09spinlock_t clocks_lock;
+=09struct clk *uart_iclk;
+=09struct clk *uart_fclk;
+=09atomic_t clk_users;
+=09u16 dll;
+=09u16 dlh;
+=09u16 ier;
+=09u16 mdr1;
+=09u16 efr;
+};
+
+struct hci_h4p_radio_hdr {
+=09__u8 evt;
+=09__u8 dlen;
+} __attribute__ ((packed));
+
+struct hci_h4p_neg_hdr {
+=09__u8 dlen;
+} __attribute__ ((packed));
+#define H4P_NEG_HDR_SIZE 1
+
+#define H4P_NEG_REQ=090x00
+#define H4P_NEG_ACK=090x20
+#define H4P_NEG_NAK=090x40
+
+#define H4P_PROTO_PKT=090x44
+#define H4P_PROTO_BYTE=090x4c
+
+#define H4P_ID_CSR=090x02
+#define H4P_ID_BCM2048=090x04
+#define H4P_ID_TI1271=090x31
+
+struct hci_h4p_neg_cmd {
+=09__u8=09ack;
+=09__u16=09baud;
+=09__u16=09unused1;
+=09__u8=09proto;
+=09__u16=09sys_clk;
+=09__u16=09unused2;
+} __attribute__ ((packed));
+
+struct hci_h4p_neg_evt {
+=09__u8=09ack;
+=09__u16=09baud;
+=09__u16=09unused1;
+=09__u8=09proto;
+=09__u16=09sys_clk;
+=09__u16=09unused2;
+=09__u8=09man_id;
+=09__u8=09ver_id;
+} __attribute__ ((packed));
+
+#define H4P_ALIVE_REQ=090x55
+#define H4P_ALIVE_RESP=090xcc
+
+struct hci_h4p_alive_hdr {
+=09__u8=09dlen;
+} __attribute__ ((packed));
+#define H4P_ALIVE_HDR_SIZE 1
+
+struct hci_h4p_alive_pkt {
+=09__u8=09mid;
+=09__u8=09unused;
+} __attribute__ ((packed));
+
+#define MAX_BAUD_RATE=09=09921600
+#define BC4_MAX_BAUD_RATE=093692300
+#define UART_CLOCK=09=0948000000
+#define BT_INIT_DIVIDER=09=09320
+#define BT_BAUDRATE_DIVIDER=09384000000
+#define BT_SYSCLK_DIV=09=091000
+#define INIT_SPEED=09=09120000
+
+#define H4_TYPE_SIZE=09=091
+#define H4_RADIO_HDR_SIZE=092
+
+/* H4+ packet types */
+#define H4_CMD_PKT=09=090x01
+#define H4_ACL_PKT=09=090x02
+#define H4_SCO_PKT=09=090x03
+#define H4_EVT_PKT=09=090x04
+#define H4_NEG_PKT=09=090x06
+#define H4_ALIVE_PKT=09=090x07
+#define H4_RADIO_PKT=09=090x08
+
+/* TX states */
+#define WAIT_FOR_PKT_TYPE=091
+#define WAIT_FOR_HEADER=09=092
+#define WAIT_FOR_DATA=09=093
+
+struct hci_fw_event {
+=09struct hci_event_hdr hev;
+=09struct hci_ev_cmd_complete cmd;
+=09u8 status;
+} __attribute__ ((packed));
+
+int hci_h4p_send_alive_packet(struct hci_h4p_info *info);
+
+void hci_h4p_bcm_parse_fw_event(struct hci_h4p_info *info,
+=09=09=09=09struct sk_buff *skb);
+int hci_h4p_bcm_send_fw(struct hci_h4p_info *info,
+=09=09=09struct sk_buff_head *fw_queue);
+
+void hci_h4p_bc4_parse_fw_event(struct hci_h4p_info *info,
+=09=09=09=09struct sk_buff *skb);
+int hci_h4p_bc4_send_fw(struct hci_h4p_info *info,
+=09=09=09struct sk_buff_head *fw_queue);
+
+void hci_h4p_ti1273_parse_fw_event(struct hci_h4p_info *info,
+=09=09=09=09    struct sk_buff *skb);
+int hci_h4p_ti1273_send_fw(struct hci_h4p_info *info,
+=09=09=09    struct sk_buff_head *fw_queue);
+
+int hci_h4p_read_fw(struct hci_h4p_info *info, struct sk_buff_head *fw=
_queue);
+int hci_h4p_send_fw(struct hci_h4p_info *info, struct sk_buff_head *fw=
_queue);
+void hci_h4p_parse_fw_event(struct hci_h4p_info *info, struct sk_buff =
*skb);
+
+void hci_h4p_outb(struct hci_h4p_info *info, unsigned int offset, u8 v=
al);
+u8 hci_h4p_inb(struct hci_h4p_info *info, unsigned int offset);
+void hci_h4p_set_rts(struct hci_h4p_info *info, int active);
+int hci_h4p_wait_for_cts(struct hci_h4p_info *info, int active, int ti=
meout_ms);
+void __hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 w=
hich);
+void hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 whi=
ch);
+void hci_h4p_change_speed(struct hci_h4p_info *info, unsigned long spe=
ed);
+int hci_h4p_reset_uart(struct hci_h4p_info *info);
+void hci_h4p_init_uart(struct hci_h4p_info *info);
+void hci_h4p_enable_tx(struct hci_h4p_info *info);
+void hci_h4p_store_regs(struct hci_h4p_info *info);
+void hci_h4p_restore_regs(struct hci_h4p_info *info);
+void hci_h4p_smart_idle(struct hci_h4p_info *info, bool enable);
+
+#endif /* __DRIVERS_BLUETOOTH_HCI_H4P_H */
diff --git a/drivers/bluetooth/hci_h4p/uart.c b/drivers/bluetooth/hci_h=
4p/uart.c
new file mode 100644
index 0000000..7973c6c
=2D-- /dev/null
+++ b/drivers/bluetooth/hci_h4p/uart.c
@@ -0,0 +1,202 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2005, 2006 Nokia Corporation.
+ *
+ * Contact: Ville Tervo <ville.tervo@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but=

+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/serial_reg.h>
+#include <linux/delay.h>
+#include <linux/clk.h>
+
+#include <linux/io.h>
+
+#include "hci_h4p.h"
+
+inline void hci_h4p_outb(struct hci_h4p_info *info, unsigned int offse=
t, u8 val)
+{
+=09__raw_writeb(val, info->uart_base + (offset << 2));
+}
+
+inline u8 hci_h4p_inb(struct hci_h4p_info *info, unsigned int offset)
+{
+=09return __raw_readb(info->uart_base + (offset << 2));
+}
+
+void hci_h4p_set_rts(struct hci_h4p_info *info, int active)
+{
+=09u8 b;
+
+=09b =3D hci_h4p_inb(info, UART_MCR);
+=09if (active)
+=09=09b |=3D UART_MCR_RTS;
+=09else
+=09=09b &=3D ~UART_MCR_RTS;
+=09hci_h4p_outb(info, UART_MCR, b);
+}
+
+int hci_h4p_wait_for_cts(struct hci_h4p_info *info, int active,
+=09=09=09 int timeout_ms)
+{
+=09unsigned long timeout;
+=09int state;
+
+=09timeout =3D jiffies + msecs_to_jiffies(timeout_ms);
+=09for (;;) {
+=09=09state =3D hci_h4p_inb(info, UART_MSR) & UART_MSR_CTS;
+=09=09if (active) {
+=09=09=09if (state)
+=09=09=09=09return 0;
+=09=09} else {
+=09=09=09if (!state)
+=09=09=09=09return 0;
+=09=09}
+=09=09if (time_after(jiffies, timeout))
+=09=09=09return -ETIMEDOUT;
+=09=09msleep(1);
+=09}
+}
+
+void __hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 w=
hich)
+{
+=09u8 lcr, b;
+
+=09lcr =3D hci_h4p_inb(info, UART_LCR);
+=09hci_h4p_outb(info, UART_LCR, 0xbf);
+=09b =3D hci_h4p_inb(info, UART_EFR);
+=09if (on)
+=09=09b |=3D which;
+=09else
+=09=09b &=3D ~which;
+=09hci_h4p_outb(info, UART_EFR, b);
+=09hci_h4p_outb(info, UART_LCR, lcr);
+}
+
+void hci_h4p_set_auto_ctsrts(struct hci_h4p_info *info, int on, u8 whi=
ch)
+{
+=09unsigned long flags;
+
+=09spin_lock_irqsave(&info->lock, flags);
+=09__hci_h4p_set_auto_ctsrts(info, on, which);
+=09spin_unlock_irqrestore(&info->lock, flags);
+}
+
+void hci_h4p_change_speed(struct hci_h4p_info *info, unsigned long spe=
ed)
+{
+=09unsigned int divisor;
+=09u8 lcr, mdr1;
+
+=09NBT_DBG("Setting speed %lu\n", speed);
+
+=09if (speed >=3D 460800) {
+=09=09divisor =3D UART_CLOCK / 13 / speed;
+=09=09mdr1 =3D 3;
+=09} else {
+=09=09divisor =3D UART_CLOCK / 16 / speed;
+=09=09mdr1 =3D 0;
+=09}
+
+=09/* Make sure UART mode is disabled */
+=09hci_h4p_outb(info, UART_OMAP_MDR1, 7);
+
+=09lcr =3D hci_h4p_inb(info, UART_LCR);
+=09hci_h4p_outb(info, UART_LCR, UART_LCR_DLAB);     /* Set DLAB */
+=09hci_h4p_outb(info, UART_DLL, divisor & 0xff);    /* Set speed */
+=09hci_h4p_outb(info, UART_DLM, divisor >> 8);
+=09hci_h4p_outb(info, UART_LCR, lcr);
+
+=09/* Make sure UART mode is enabled */
+=09hci_h4p_outb(info, UART_OMAP_MDR1, mdr1);
+}
+
+int hci_h4p_reset_uart(struct hci_h4p_info *info)
+{
+=09int count =3D 0;
+
+=09/* Reset the  UART */
+=09hci_h4p_outb(info, UART_OMAP_SYSC, UART_SYSC_OMAP_RESET);
+=09while (!(hci_h4p_inb(info, UART_OMAP_SYSS) & UART_SYSS_RESETDONE)) =
{
+=09=09if (count++ > 100) {
+=09=09=09dev_err(info->dev, "hci_h4p: UART reset timeout\n");
+=09=09=09return -ENODEV;
+=09=09}
+=09=09udelay(1);
+=09}
+
+=09return 0;
+}
+
+
+void hci_h4p_store_regs(struct hci_h4p_info *info)
+{
+=09u16 lcr =3D 0;
+
+=09lcr =3D hci_h4p_inb(info, UART_LCR);
+=09hci_h4p_outb(info, UART_LCR, 0xBF);
+=09info->dll =3D hci_h4p_inb(info, UART_DLL);
+=09info->dlh =3D hci_h4p_inb(info, UART_DLM);
+=09info->efr =3D hci_h4p_inb(info, UART_EFR);
+=09hci_h4p_outb(info, UART_LCR, lcr);
+=09info->mdr1 =3D hci_h4p_inb(info, UART_OMAP_MDR1);
+=09info->ier =3D hci_h4p_inb(info, UART_IER);
+}
+
+void hci_h4p_restore_regs(struct hci_h4p_info *info)
+{
+=09u16 lcr =3D 0;
+
+=09hci_h4p_init_uart(info);
+
+=09hci_h4p_outb(info, UART_OMAP_MDR1, 7);
+=09lcr =3D hci_h4p_inb(info, UART_LCR);
+=09hci_h4p_outb(info, UART_LCR, 0xBF);
+=09hci_h4p_outb(info, UART_DLL, info->dll);    /* Set speed */
+=09hci_h4p_outb(info, UART_DLM, info->dlh);
+=09hci_h4p_outb(info, UART_EFR, info->efr);
+=09hci_h4p_outb(info, UART_LCR, lcr);
+=09hci_h4p_outb(info, UART_OMAP_MDR1, info->mdr1);
+=09hci_h4p_outb(info, UART_IER, info->ier);
+}
+
+void hci_h4p_init_uart(struct hci_h4p_info *info)
+{
+=09u8 mcr, efr;
+
+=09/* Enable and setup FIFO */
+=09hci_h4p_outb(info, UART_OMAP_MDR1, 0x00);
+
+=09hci_h4p_outb(info, UART_LCR, 0xbf);
+=09efr =3D hci_h4p_inb(info, UART_EFR);
+=09hci_h4p_outb(info, UART_EFR, UART_EFR_ECB);
+=09hci_h4p_outb(info, UART_LCR, UART_LCR_DLAB);
+=09mcr =3D hci_h4p_inb(info, UART_MCR);
+=09hci_h4p_outb(info, UART_MCR, UART_MCR_TCRTLR);
+=09hci_h4p_outb(info, UART_FCR, UART_FCR_ENABLE_FIFO |
+=09=09=09UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT |
+=09=09=09(3 << 6) | (0 << 4));
+=09hci_h4p_outb(info, UART_LCR, 0xbf);
+=09hci_h4p_outb(info, UART_TI752_TLR, 0xed);
+=09hci_h4p_outb(info, UART_TI752_TCR, 0xef);
+=09hci_h4p_outb(info, UART_EFR, efr);
+=09hci_h4p_outb(info, UART_LCR, UART_LCR_DLAB);
+=09hci_h4p_outb(info, UART_MCR, 0x00);
+=09hci_h4p_outb(info, UART_LCR, UART_LCR_WLEN8);
+=09hci_h4p_outb(info, UART_IER, UART_IER_RDI);
+=09hci_h4p_outb(info, UART_OMAP_SYSC, (1 << 0) | (1 << 2) | (2 << 3));=

+}
diff --git a/include/linux/bluetooth/hci_h4p.h b/include/linux/bluetoot=
h/hci_h4p.h
new file mode 100644
index 0000000..daf83fc
=2D-- /dev/null
+++ b/include/linux/bluetooth/hci_h4p.h
@@ -0,0 +1,40 @@
+/*
+ * This file is part of hci_h4p bluetooth driver
+ *
+ * Copyright (C) 2010 Nokia Corporation.
+ *
+ * Contact: Roger Quadros <roger.quadros@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but=

+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+
+/**
+ * struct hci_h4p_platform data - hci_h4p Platform data structure
+ */
+struct hci_h4p_platform_data {
+=09int chip_type;
+=09int bt_sysclk;
+=09unsigned int bt_wakeup_gpio;
+=09unsigned int host_wakeup_gpio;
+=09unsigned int reset_gpio;
+=09int reset_gpio_shared;
+=09unsigned int uart_irq;
+=09phys_addr_t uart_base;
+=09const char *uart_iclk;
+=09const char *uart_fclk;
+=09void (*set_pm_limits)(struct device *dev, bool set);
+};

--nextPart2035915.Fh6UZzF48y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlK9XlgACgkQi/DJPQPkQ1K1iQCgnr7XOIGORimz0qvfSgYAAlpH
pooAnjeW77mONqs1kd5QbJ6o9WX04Vua
=eafq
-----END PGP SIGNATURE-----

--nextPart2035915.Fh6UZzF48y--

