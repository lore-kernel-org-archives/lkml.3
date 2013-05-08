Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab3EHS1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:27:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:53102 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3EHS1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:27:11 -0400
Message-ID: <518A98D9.4020906@infradead.org>
Date: Wed, 08 May 2013 11:26:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH -next] media/usb: fix kconfig dependencies (aka bool depending
 on tristate considered harmful)
References: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
In-Reply-To: <20130508140122.e4747b58be4333060b7a248a@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

(a.k.a. Kconfig bool depending on a tristate considered harmful)

Fix various build errors when CONFIG_USB=m and media USB drivers
are builtin.  In this case, CONFIG_USB_ZR364XX=y,
CONFIG_VIDEO_PVRUSB2=y, and CONFIG_VIDEO_STK1160=y.

This is caused by (from drivers/media/usb/Kconfig):

menuconfig MEDIA_USB_SUPPORT
	bool "Media USB Adapters"
	depends on USB && MEDIA_SUPPORT
	           =m     =y
so MEDIA_USB_SUPPORT=y and all following Kconfig 'source' lines
are included.  By adding an "if USB" guard around the 'source' lines,
the needed dependencies are enforced.


drivers/built-in.o: In function `zr364xx_start_readpipe':
zr364xx.c:(.text+0xc726a): undefined reference to `usb_alloc_urb'
zr364xx.c:(.text+0xc72bb): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `zr364xx_stop_readpipe':
zr364xx.c:(.text+0xc72fd): undefined reference to `usb_kill_urb'
zr364xx.c:(.text+0xc7309): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `read_pipe_completion':
zr364xx.c:(.text+0xc7acc): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `send_control_msg.constprop.12':
zr364xx.c:(.text+0xc7d2f): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `pvr2_ctl_timeout':
pvrusb2-hdw.c:(.text+0xcadb6): undefined reference to `usb_unlink_urb'
pvrusb2-hdw.c:(.text+0xcadcb): undefined reference to `usb_unlink_urb'
drivers/built-in.o: In function `pvr2_hdw_create':
(.text+0xcc42c): undefined reference to `usb_alloc_urb'
drivers/built-in.o: In function `pvr2_hdw_create':
(.text+0xcc448): undefined reference to `usb_alloc_urb'
drivers/built-in.o: In function `pvr2_hdw_create':
(.text+0xcc5f9): undefined reference to `usb_set_interface'
drivers/built-in.o: In function `pvr2_hdw_create':
(.text+0xcc65a): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `pvr2_hdw_create':
(.text+0xcc666): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `pvr2_send_request_ex.part.22':
pvrusb2-hdw.c:(.text+0xccbe3): undefined reference to `usb_submit_urb'
pvrusb2-hdw.c:(.text+0xccc83): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `pvr2_hdw_remove_usb_stuff.part.25':
pvrusb2-hdw.c:(.text+0xcd3f9): undefined reference to `usb_kill_urb'
pvrusb2-hdw.c:(.text+0xcd405): undefined reference to `usb_free_urb'
pvrusb2-hdw.c:(.text+0xcd421): undefined reference to `usb_kill_urb'
pvrusb2-hdw.c:(.text+0xcd42d): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `pvr2_hdw_device_reset':
(.text+0xcd658): undefined reference to `usb_lock_device_for_reset'
drivers/built-in.o: In function `pvr2_hdw_device_reset':
(.text+0xcd664): undefined reference to `usb_reset_device'
drivers/built-in.o: In function `pvr2_hdw_cpureset_assert':
(.text+0xcd6f9): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `pvr2_hdw_cpufw_set_enabled':
(.text+0xcd84e): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `pvr2_upload_firmware1':
pvrusb2-hdw.c:(.text+0xcda47): undefined reference to `usb_clear_halt'
pvrusb2-hdw.c:(.text+0xcdb04): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `pvr2_upload_firmware2':
(.text+0xce7dc): undefined reference to `usb_bulk_msg'
drivers/built-in.o: In function `pvr2_stream_buffer_count':
pvrusb2-io.c:(.text+0xd2e05): undefined reference to `usb_alloc_urb'
pvrusb2-io.c:(.text+0xd2e5b): undefined reference to `usb_kill_urb'
pvrusb2-io.c:(.text+0xd2e9f): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `pvr2_stream_internal_flush':
pvrusb2-io.c:(.text+0xd2f9b): undefined reference to `usb_kill_urb'
drivers/built-in.o: In function `pvr2_buffer_queue':
(.text+0xd3328): undefined reference to `usb_kill_urb'
drivers/built-in.o: In function `pvr2_buffer_queue':
(.text+0xd33ea): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `stk1160_read_reg':
(.text+0xd3efa): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `stk1160_write_reg':
(.text+0xd3f4f): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `stop_streaming':
stk1160-v4l.c:(.text+0xd4997): undefined reference to `usb_set_interface'
drivers/built-in.o: In function `start_streaming':
stk1160-v4l.c:(.text+0xd4a9f): undefined reference to `usb_set_interface'
stk1160-v4l.c:(.text+0xd4afa): undefined reference to `usb_submit_urb'
stk1160-v4l.c:(.text+0xd4ba3): undefined reference to `usb_set_interface'
drivers/built-in.o: In function `stk1160_isoc_irq':
stk1160-video.c:(.text+0xd509b): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `stk1160_cancel_isoc':
(.text+0xd50ef): undefined reference to `usb_kill_urb'
drivers/built-in.o: In function `stk1160_free_isoc':
(.text+0xd5155): undefined reference to `usb_free_coherent'
drivers/built-in.o: In function `stk1160_free_isoc':
(.text+0xd515d): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `stk1160_alloc_isoc':
(.text+0xd5278): undefined reference to `usb_alloc_urb'
drivers/built-in.o: In function `stk1160_alloc_isoc':
(.text+0xd52c2): undefined reference to `usb_alloc_coherent'
drivers/built-in.o: In function `stk1160_alloc_isoc':
(.text+0xd53c4): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `zr364xx_driver_init':
zr364xx.c:(.init.text+0x463e): undefined reference to `usb_register_driver'
drivers/built-in.o: In function `pvr_init':
pvrusb2-main.c:(.init.text+0x4662): undefined reference to `usb_register_driver'
drivers/built-in.o: In function `stk1160_usb_driver_init':
stk1160-core.c:(.init.text+0x467d): undefined reference to `usb_register_driver'
drivers/built-in.o: In function `zr364xx_driver_exit':
zr364xx.c:(.exit.text+0x1377): undefined reference to `usb_deregister'
drivers/built-in.o: In function `pvr_exit':
pvrusb2-main.c:(.exit.text+0x1389): undefined reference to `usb_deregister'
drivers/built-in.o: In function `stk1160_usb_driver_exit':
stk1160-core.c:(.exit.text+0x13a0): undefined reference to `usb_deregister'


Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/media/usb/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20130508.orig/drivers/media/usb/Kconfig
+++ linux-next-20130508/drivers/media/usb/Kconfig
@@ -5,6 +5,7 @@ menuconfig MEDIA_USB_SUPPORT
 	  Enable media drivers for USB bus.
 	  If you have such devices, say Y.
 
+if USB
 if MEDIA_USB_SUPPORT
 
 if MEDIA_CAMERA_SUPPORT
@@ -52,3 +53,4 @@ source "drivers/media/usb/em28xx/Kconfig
 endif
 
 endif #MEDIA_USB_SUPPORT
+endif #USB
