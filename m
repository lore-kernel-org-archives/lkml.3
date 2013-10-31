Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3JaDGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 23:06:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:8674 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab3JaDGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 23:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="427426863"
From: "Du, ChangbinX" <changbinx.du@intel.com>
To: Bj?rn Mork <bjorn@mork.no>
CC: "oliver@neukum.org" <oliver@neukum.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net/cdc_ncm: fix null pointer panic at
 usbnet_link_change
Thread-Topic: [PATCH] net/cdc_ncm: fix null pointer panic at
 usbnet_link_change
Thread-Index: AQHO1IKwctCJq7r9bkiYR3yryMpVVZoOIQVQ
Date: Thu, 31 Oct 2013 03:06:03 +0000
Message-ID: <0C18FE92A7765D4EB9EE5D38D86A563A019F6384@SHSMSX103.ccr.corp.intel.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A019F450F@SHSMSX103.ccr.corp.intel.com>
 <87wqkwii4p.fsf@nemi.mork.no>
In-Reply-To: <87wqkwii4p.fsf@nemi.mork.no>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9V36N7h024267

> From: Bj√∏rn Mork [mailto:bjorn@mork.no]
> Sent: Tuesday, October 29, 2013 4:41 PM
> To: Du, ChangbinX
> Cc: oliver@neukum.org; linux-usb@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] net/cdc_ncm: fix null pointer panic at usbnet_link_change
> 
> "Du, ChangbinX" <changbinx.du@intel.com> writes:
> 
> > From: "Du, Changbin" <changbinx.du@intel.com>
> >
> > In cdc_ncm_bind() function, it call cdc_ncm_bind_common() to setup usb.
> > But cdc_ncm_bind_common() may meet error and cause usbnet_disconnect()
> > be called which calls free_netdev(net).
> 
> I am sure you are right, but I really don't see how that can happen.
> 
> AFAICS, we ensure that the intfdata is set to NULL before calling
> usb_driver_release_interface() in the error cleanup in
> cdc_ncm_bind_common():
> 
> 
> error2:
> 	usb_set_intfdata(ctx->control, NULL);
> 	usb_set_intfdata(ctx->data, NULL);
> 	if (ctx->data != ctx->control)
> 		usb_driver_release_interface(driver, ctx->data);
> error:
> 	cdc_ncm_free((struct cdc_ncm_ctx *)dev->data[0]);
> 	dev->data[0] = 0;
> 	dev_info(&dev->udev->dev, "bind() failure\n");
> 	return -ENODEV;
> 
> 
> Thus we hit the test in disconnect, and usbnet_disconnect() is never
> called:
> 
> static void cdc_ncm_disconnect(struct usb_interface *intf)
> {
> 	struct usbnet *dev = usb_get_intfdata(intf);
> 
> 	if (dev == NULL)
> 		return;		/* already disconnected */
> 
> 	usbnet_disconnect(intf);
> }
> 
> So we should really be OK, but we are not????  I would appreciate it if
> anyone took the time to feed me why, with a very small spoon...
> 

Yes, you are right. It should not happen if cdc_ncm_disconnect is not called. But this really happened.
It produced on kernel 3.10. Here is the full panic message for you to refer. I will get a method try to 
reproduce it.

[   15.635727] BUG: Bad page state in process khubd  pfn:31994
[   15.641989] page:f3ad9280 count:0 mapcount:0 mapping:00000020 index:0x0
[   15.649384] page flags: 0x40000000()
[   15.670096] BUG: unable to handle kernel NULL pointer dereference at 00000078
[   15.678078] IP: [<c24b7f5e>] usbnet_link_change+0x1e/0x80
[   15.684120] *pde = 00000000 
[   15.687339] Oops: 0000 [#1] SMP 
[   15.690953] Modules linked in: atmel_mxt_ts vxd392 videobuf_vmalloc videobuf_core bcm_bt_lpm bcm432)
[   15.702658] CPU: 0 PID: 573 Comm: khubd Tainted: G    B   W  O 3.10.1+ #1
[   15.710241] task: f27e8f30 ti: f2084000 task.ti: f2084000
[   15.716270] EIP: 0060:[<c24b7f5e>] EFLAGS: 00010246 CPU: 0
[   15.722396] EIP is at usbnet_link_change+0x1e/0x80
[   15.727747] EAX: f18524c0 EBX: 00000000 ECX: f18524c0 EDX: 00000000
[   15.734746] ESI: f18524c0 EDI: 00000000 EBP: f2085b7c ESP: f2085b70
[   15.741746] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   15.747775] CR0: 8005003b CR2: 00000078 CR3: 02c3b000 CR4: 001007d0
[   15.754774] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   15.761774] DR6: ffff0ff0 DR7: 00000400
[   15.766054] Stack:
[   15.768295]  00000000 f18524c0 c2a03818 f2085b8c c24bc69a f1852000 f1f52e00 f2085be0
[   15.776991]  c24b8d32 00000000 00000001 00000000 c2167f2c f2085bb4 c2821253 f2085bec
[   15.785687]  00000246 00000246 f18d8088 f1f52e1c f1fce464 f1fce400 f18524c0 c28a06e0
[   15.794376] Call Trace:
[   15.797109]  [<c24bc69a>] cdc_ncm_bind+0x3a/0x50
[   15.802267]  [<c24b8d32>] usbnet_probe+0x282/0x7d0
[   15.807621]  [<c2167f2c>] ? sysfs_new_dirent+0x6c/0x100
[   15.813460]  [<c2821253>] ? mutex_lock+0x13/0x40
[   15.818618]  [<c24bb278>] cdc_ncm_probe+0x8/0x10
[   15.823777]  [<c24e0ef7>] usb_probe_interface+0x187/0x2c0
[   15.829811]  [<c23caa8a>] ? driver_sysfs_add+0x6a/0x90
[   15.835550]  [<c23cb290>] ? __driver_attach+0x90/0x90
[   15.841192]  [<c23caf14>] driver_probe_device+0x74/0x360
[   15.847127]  [<c24e07b1>] ? usb_match_id+0x41/0x60
[   15.852479]  [<c24e081e>] ? usb_device_match+0x4e/0x90
[   15.858219]  [<c23cb290>] ? __driver_attach+0x90/0x90
[   15.863861]  [<c23cb2c9>] __device_attach+0x39/0x50
[   15.869311]  [<c23c93f4>] bus_for_each_drv+0x34/0x70
[   15.874856]  [<c23cae2b>] device_attach+0x7b/0x90
[   15.880109]  [<c23cb290>] ? __driver_attach+0x90/0x90
[   15.885752]  [<c23ca38f>] bus_probe_device+0x6f/0x90
[   15.891298]  [<c23c8a08>] device_add+0x558/0x630
[   15.896457]  [<c24e4821>] ? usb_create_ep_devs+0x71/0xd0
[   15.902391]  [<c24dd0db>] ? create_intf_ep_devs+0x4b/0x70
[   15.908422]  [<c24df2bf>] usb_set_configuration+0x4bf/0x800
[   15.914648]  [<c23cb290>] ? __driver_attach+0x90/0x90
[   15.920292]  [<c24e809b>] generic_probe+0x2b/0x90
[   15.925546]  [<c24e105c>] usb_probe_device+0x2c/0x70
[   15.931091]  [<c23caf14>] driver_probe_device+0x74/0x360
[   15.943345]  [<c2272102>] ? kobject_uevent_env+0x182/0x620
[   15.949473]  [<c2272102>] ? kobject_uevent_env+0x182/0x620
[   15.955601]  [<c23cb290>] ? __driver_attach+0x90/0x90
[   15.961242]  [<c23cb2c9>] __device_attach+0x39/0x50
[   15.966692]  [<c23c93f4>] bus_for_each_drv+0x34/0x70
[   15.972238]  [<c23cae2b>] device_attach+0x7b/0x90
[   15.977492]  [<c23cb290>] ? __driver_attach+0x90/0x90
[   15.983135]  [<c23ca38f>] bus_probe_device+0x6f/0x90
[   15.988682]  [<c23c8a08>] device_add+0x558/0x630
[   15.993841]  [<c2320b10>] ? add_device_randomness+0x60/0x70
[   16.000069]  [<c24d642f>] usb_new_device+0x1df/0x360
[   16.005616]  [<c24e81f6>] ? usb_detect_quirks+0x16/0x70
[   16.011454]  [<c24d7a9f>] hub_thread+0xd2f/0x1540
[   16.016710]  [<c20573a0>] ? finish_wait+0x60/0x60
[   16.021965]  [<c24d6d70>] ? hub_port_debounce+0x130/0x130
[   16.027996]  [<c2056f1f>] kthread+0x8f/0xa0
[   16.032669]  [<c282a237>] ret_from_kernel_thread+0x1b/0x28
[   16.038798]  [<c2056e90>] ? kthread_create_on_node+0xc0/0xc0
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
