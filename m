Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbaFYPNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:13:19 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:62420 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbaFYPNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:13:17 -0400
MIME-Version: 1.0
Date: Wed, 25 Jun 2014 11:13:16 -0400
X-Google-Sender-Auth: _oqRfFFgrLhTqyRCllM6NUGwrnk
Message-ID: <CAMwGMjwmdcePeeT5rbZNxCVD7f-bgYgrwBW21hzEV20tkKg9Yg@mail.gmail.com>
Subject: USB_MUSB_DA8XX with g_multi.ko
From: Jon Ringle <jon@ringle.org>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 787f5627bec80094db487bfcb401e9744f181aed
usb: musb: make davinci and da8xx glues depend on BROKEN

USB_MUSB_DA8XX was marked as BROKEN

A few months ago, we updated the linux kernel on our AM1808 SoC based
embedded board from Linux 2.6.33 to the latest long term 3.12.

I am interested in having the USB gadget support on my board, so I
removed BROKEN on USB_MUSB_DA8XX. I found that when I modprobe
g_ether, g_serial, and g_mass_storage (by themselves), they all appear
to work as expected, but if I try to use g_multi to have a composite
device supporting all three simultaneously, I run into failure during
initialization.

Here is the USB related config:
# zcat /proc/config.gz |grep "^CONFIG_USB"
CONFIG_USB_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_OTG=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_DUAL_ROLE=y
CONFIG_USB_MUSB_DA8XX=y
CONFIG_USB_STORAGE=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_PHY=y
CONFIG_USB_ULPI=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
CONFIG_USB_LIBCOMPOSITE=m
CONFIG_USB_F_ACM=m
CONFIG_USB_U_SERIAL=m
CONFIG_USB_U_ETHER=m
CONFIG_USB_U_RNDIS=m
CONFIG_USB_F_SERIAL=m
CONFIG_USB_F_OBEX=m
CONFIG_USB_F_ECM=m
CONFIG_USB_F_SUBSET=m
CONFIG_USB_F_RNDIS=m
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y

# modprobe g_multi file=/root/backing_file
modprobe: can't load module g_multi
(kernel/drivers/usb/gadget/g_multi.ko): Unknown error 524

I added a couple of debug message to identify where I was failing in:

diff --git a/drivers/usb/gadget/f_mass_storage.c
b/drivers/usb/gadget/f_mass_storage.c
index a01d7d3..3e7a22a 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2899,14 +2899,18 @@ static int fsg_bind(struct usb_configuration
*c, struct usb_function *f)

        /* Find all the endpoints we will use */
        ep = usb_ep_autoconfig(gadget, &fsg_fs_bulk_in_desc);
-       if (!ep)
+       if (!ep) {
+               ERROR(fsg, "usb_ep_autoconfig in failed\n");
                goto autoconf_fail;
+       }
        ep->driver_data = fsg->common;  /* claim the endpoint */
        fsg->bulk_in = ep;

        ep = usb_ep_autoconfig(gadget, &fsg_fs_bulk_out_desc);
-       if (!ep)
+       if (!ep) {
+               ERROR(fsg, "usb_ep_autoconfig out failed\n");
                goto autoconf_fail;
+       }
        ep->driver_data = fsg->common;  /* claim the endpoint */
        fsg->bulk_out = ep;

@@ -2929,8 +2933,10 @@ static int fsg_bind(struct usb_configuration
*c, struct usb_function *f)

        ret = usb_assign_descriptors(f, fsg_fs_function, fsg_hs_function,
                        fsg_ss_function);
-       if (ret)
+       if (ret) {
+               ERROR(fsg, "usb_assign_descriptors failed\n");
                goto autoconf_fail;
+       }

        return 0;

diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
index c258a97..5172b00 100644
--- a/drivers/usb/musb/Kconfig
+++ b/drivers/usb/musb/Kconfig
@@ -67,7 +67,6 @@ config USB_MUSB_DAVINCI
 config USB_MUSB_DA8XX
        tristate "DA8xx/OMAP-L1x"
        depends on ARCH_DAVINCI_DA8XX
-       depends on BROKEN

 config USB_MUSB_TUSB6010
        tristate "TUSB6010"

This is the kernel log I get from journalctl -f:

Jun 25 14:36:00 Ringle1 kernel: calling  multi_init+0x0/0xc [g_multi] @ 957
Jun 25 14:36:01 Ringle1 kernel: udc musb-hdrc.0.auto: registering UDC
driver [g_multi]
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: using random self
ethernet address
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: using random host
ethernet address
Jun 25 14:36:01 Ringle1 kernel: usb0: MAC 22:34:67:82:df:aa
Jun 25 14:36:01 Ringle1 kernel: usb0: HOST MAC 0e:a8:d1:26:29:37
Jun 25 14:36:01 Ringle1 kernel: calling  userial_init+0x0/0x180 [u_serial] @ 963
Jun 25 14:36:01 Ringle1 kernel: userial_init: registered 4 ttyGS* devices
Jun 25 14:36:01 Ringle1 kernel: initcall userial_init+0x0/0x180
[u_serial] returned 0 after 87 usecs
Jun 25 14:36:01 Ringle1 kernel: calling  acmmod_init+0x0/0xc [usb_f_acm] @ 963
Jun 25 14:36:01 Ringle1 kernel: initcall acmmod_init+0x0/0xc
[usb_f_acm] returned 0 after 10 usecs
Jun 25 14:36:01 Ringle1 kernel:  lun0: open backing file: /root/backing_file
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: Mass Storage Function,
version: 2009/09/11
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: Number of LUNs=1
Jun 25 14:36:01 Ringle1 kernel:  lun0: LUN: file: /root/backing_file
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: I/O thread pid: 969
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: adding config #1
'Multifunction with RNDIS'/bf034bbc
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: adding
'rndis'/c0ad9f20 to config 'Multifunction with RNDIS'/bf034bbc
Jun 25 14:36:01 Ringle1 kernel: rndis_register: configNr = 0
Jun 25 14:36:01 Ringle1 kernel: rndis_set_param_medium: 0 0
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: RNDIS: dual speed
IN/ep1in OUT/ep1out NOTIFY/ep2in
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: adding 'acm'/c3934080
to config 'Multifunction with RNDIS'/bf034bbc
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: acm ttyGS0: dual speed
IN/ep3 OUT/ep2out NOTIFY/ep4
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: adding 'Mass Storage
Function'/c29169a0 to config 'Multifunction with RNDIS'/bf034bbc
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: usb_ep_autoconfig in failed
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: unable to
autoconfigure all endpoints
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: adding 'Mass Storage
Function'/c29169a0 --> -524
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: acm ttyGS0 deactivated
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: unbind function 'rndis'/c0ad9f20
Jun 25 14:36:01 Ringle1 kernel: rndis_deregister:
Jun 25 14:36:01 Ringle1 kernel: g_multi gadget: added config
'Multifunction with RNDIS'/1 --> -524
Jun 25 14:36:01 Ringle1 kernel:  lun0: close backing file
Jun 25 14:36:01 Ringle1 kernel: g_multi musb-hdrc.0.auto: failed to
start g_multi: -524
Jun 25 14:36:01 Ringle1 kernel: initcall multi_init+0x0/0xc [g_multi]
returned -524 after 253364 usecs

>From this I can see that it's failing on the following call in fsg_bind():
ep = usb_ep_autoconfig(gadget, &fsg_fs_bulk_in_desc);

I appreciate any guidance on what I need to do to get g_multi working properly.

Thanks!

Jon
