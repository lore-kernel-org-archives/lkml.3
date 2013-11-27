Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3K0BMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:12:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735Ab3K0A7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.12 106/116] usb: musb: cancel work on removal
Date: Tue, 26 Nov 2013 16:57:59 -0800
Message-Id: <20131127005744.225528832@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit c5340bd14336b902604ab95212a8877de109d9ae upstream.

So I captured this:

|WARNING: CPU: 0 PID: 2078 at /home/bigeasy/work/new/TI/linux/lib/debugobjects.c:260 debug_print_object+0x94/0xc4()
|ODEBUG: free active (active state 0) object type: work_struct hint: musb_irq_work+0x0/0x38 [musb_hdrc]
|CPU: 0 PID: 2078 Comm: rmmod Not tainted 3.12.0-rc4+ #338
|[<c0014d38>] (unwind_backtrace+0x0/0xf4) from [<c001249c>] (show_stack+0x14/0x1c)
|[<c001249c>] (show_stack+0x14/0x1c) from [<c0037720>] (warn_slowpath_common+0x64/0x84)
|[<c0037720>] (warn_slowpath_common+0x64/0x84) from [<c00377d4>] (warn_slowpath_fmt+0x30/0x40)
|[<c00377d4>] (warn_slowpath_fmt+0x30/0x40) from [<c022ae90>] (debug_print_object+0x94/0xc4)
|[<c022ae90>] (debug_print_object+0x94/0xc4) from [<c022b7e0>] (debug_check_no_obj_freed+0x1c0/0x228)
|[<c022b7e0>] (debug_check_no_obj_freed+0x1c0/0x228) from [<c00f1f38>] (kfree+0xf8/0x228)
|[<c00f1f38>] (kfree+0xf8/0x228) from [<c02921c4>] (release_nodes+0x1a8/0x248)
|[<c02921c4>] (release_nodes+0x1a8/0x248) from [<c028f70c>] (__device_release_driver+0x98/0xf0)
|[<c028f70c>] (__device_release_driver+0x98/0xf0) from [<c028f840>] (device_release_driver+0x24/0x34)
|[<c028f840>] (device_release_driver+0x24/0x34) from [<c028ebe8>] (bus_remove_device+0x148/0x15c)
|[<c028ebe8>] (bus_remove_device+0x148/0x15c) from [<c028d120>] (device_del+0x104/0x1c0)
|[<c028d120>] (device_del+0x104/0x1c0) from [<c02911e4>] (platform_device_del+0x18/0xac)
|[<c02911e4>] (platform_device_del+0x18/0xac) from [<c029179c>] (platform_device_unregister+0xc/0x18)
|[<c029179c>] (platform_device_unregister+0xc/0x18) from [<bf1902fc>] (dsps_remove+0x20/0x4c [musb_dsps])
|[<bf1902fc>] (dsps_remove+0x20/0x4c [musb_dsps]) from [<c0290d7c>] (platform_drv_remove+0x1c/0x24)
|[<c0290d7c>] (platform_drv_remove+0x1c/0x24) from [<c028f704>] (__device_release_driver+0x90/0xf0)
|[<c028f704>] (__device_release_driver+0x90/0xf0) from [<c028f818>] (driver_detach+0xb4/0xb8)
|[<c028f818>] (driver_detach+0xb4/0xb8) from [<c028e6e8>] (bus_remove_driver+0x98/0xec)
|[<c028e6e8>] (bus_remove_driver+0x98/0xec) from [<c008fc70>] (SyS_delete_module+0x1e0/0x24c)
|[<c008fc70>] (SyS_delete_module+0x1e0/0x24c) from [<c000e680>] (ret_fast_syscall+0x0/0x48)
|---[ end trace d79045419a3e51ec ]---

The workqueue is only scheduled from the ep0 and never canceled in case
the musb is removed before the work has a chance to run.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1809,6 +1809,7 @@ static void musb_free(struct musb *musb)
 			disable_irq_wake(musb->nIrq);
 		free_irq(musb->nIrq, musb);
 	}
+	cancel_work_sync(&musb->irq_work);
 	if (musb->dma_controller)
 		dma_controller_destroy(musb->dma_controller);
 


