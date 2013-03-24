Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3CXL4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 07:56:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3CXL4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 07:56:43 -0400
Message-ID: <514EE9EE.9030208@canonical.com>
Date: Sun, 24 Mar 2013 12:56:30 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau: fix NULL ptr dereference from nv50_disp_intr()
References: <1363705988.3413.17.camel@thor.lan> <1364039260.3440.5.camel@thor.lan>
In-Reply-To: <1364039260.3440.5.camel@thor.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 23-03-13 12:47, Peter Hurley schreef:
> On Tue, 2013-03-19 at 11:13 -0400, Peter Hurley wrote:
>> On vanilla 3.9.0-rc3, I get this 100% repeatable oops after login when
>> the user X session is coming up:
> Perhaps I wasn't clear that this happens on every boot and is a
> regression from 3.8
>
> I'd be happy to help resolve this but time is of the essence; it would
> be a shame to have to revert all of this for 3.9

Well it broke on my system too, so it was easy to fix.

I didn't even need gdm to trigger it!

>8----
This fixes regression caused by 1d7c71a3e2f7 (drm/nouveau/disp: port vblank handling to event interface),

which causes a oops in the following way:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
IP: [<0000000000000001>] 0x0
PGD 0 
Oops: 0010 [#1] PREEMPT SMP 
Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ...<snip>...
CPU 3 
Pid: 0, comm: swapper/3 Not tainted 3.9.0-rc3-xeon #rc3 Dell Inc. Precision WorkStation T5400  /0RW203
RIP: 0010:[<0000000000000001>]  [<0000000000000001>] 0x0
RSP: 0018:ffff8802afcc3d80  EFLAGS: 00010087
RAX: ffff88029f6e5808 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000096 RSI: 0000000000000001 RDI: ffff88029f6e5808
RBP: ffff8802afcc3dc8 R08: 0000000000000000 R09: 0000000000000004
R10: 000000000000002c R11: ffff88029e559a98 R12: ffff8802a376cb78
R13: ffff88029f6e57e0 R14: ffff88029f6e57f8 R15: ffff88029f6e5808
FS:  0000000000000000(0000) GS:ffff8802afcc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000001 CR3: 000000029fa67000 CR4: 00000000000007e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/3 (pid: 0, threadinfo ffff8802a355e000, task ffff8802a3535c40)
Stack:
 ffffffffa0159d8a 0000000000000082 ffff88029f6e5820 0000000000000001
 ffff88029f71aa00 0000000000000000 0000000000000000 0000000004000000
 0000000004000000 ffff8802afcc3e38 ffffffffa01843b5 ffff8802afcc3df8
Call Trace:
 <IRQ> 
 [<ffffffffa0159d8a>] ? nouveau_event_trigger+0xaa/0xe0 [nouveau]
 [<ffffffffa01843b5>] nv50_disp_intr+0xc5/0x200 [nouveau]
 [<ffffffff816fbacc>] ? _raw_spin_unlock_irqrestore+0x2c/0x50
 [<ffffffff816ff98d>] ? notifier_call_chain+0x4d/0x70
 [<ffffffffa017a105>] nouveau_mc_intr+0xb5/0x110 [nouveau]
 [<ffffffffa01d45ff>] nouveau_irq_handler+0x6f/0x80 [nouveau]
 [<ffffffff810eec95>] handle_irq_event_percpu+0x75/0x260
 [<ffffffff810eeec8>] handle_irq_event+0x48/0x70
 [<ffffffff810f205a>] handle_fasteoi_irq+0x5a/0x100
 [<ffffffff810182f2>] handle_irq+0x22/0x40
 [<ffffffff8170561a>] do_IRQ+0x5a/0xd0
 [<ffffffff816fc2ad>] common_interrupt+0x6d/0x6d
 <EOI> 
 [<ffffffff810449b6>] ? native_safe_halt+0x6/0x10
 [<ffffffff8101ea1d>] default_idle+0x3d/0x170
 [<ffffffff8101f736>] cpu_idle+0x116/0x130
 [<ffffffff816e2a06>] start_secondary+0x251/0x258
Code:  Bad RIP value.
RIP  [<0000000000000001>] 0x0
 RSP <ffff8802afcc3d80>
CR2: 0000000000000001
---[ end trace 907323cb8ce6f301 ]---

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index d109936..c95decf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -72,11 +72,25 @@ module_param_named(modeset, nouveau_modeset, int, 0400);
 static struct drm_driver driver;
 
 static int
+nouveau_drm_vblank_handler(struct nouveau_eventh *event, int head)
+{
+	struct nouveau_drm *drm =
+		container_of(event, struct nouveau_drm, vblank[head]);
+	drm_handle_vblank(drm->dev, head);
+	return NVKM_EVENT_KEEP;
+}
+
+static int
 nouveau_drm_vblank_enable(struct drm_device *dev, int head)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_disp *pdisp = nouveau_disp(drm->device);
-	nouveau_event_get(pdisp->vblank, head, &drm->vblank);
+
+	if (WARN_ON_ONCE(head > ARRAY_SIZE(drm->vblank)))
+		return -EIO;
+	WARN_ON_ONCE(drm->vblank[head].func);
+	drm->vblank[head].func = nouveau_drm_vblank_handler;
+	nouveau_event_get(pdisp->vblank, head, &drm->vblank[head]);
 	return 0;
 }
 
@@ -85,16 +99,11 @@ nouveau_drm_vblank_disable(struct drm_device *dev, int head)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_disp *pdisp = nouveau_disp(drm->device);
-	nouveau_event_put(pdisp->vblank, head, &drm->vblank);
-}
-
-static int
-nouveau_drm_vblank_handler(struct nouveau_eventh *event, int head)
-{
-	struct nouveau_drm *drm =
-		container_of(event, struct nouveau_drm, vblank);
-	drm_handle_vblank(drm->dev, head);
-	return NVKM_EVENT_KEEP;
+	if (drm->vblank[head].func)
+		nouveau_event_put(pdisp->vblank, head, &drm->vblank[head]);
+	else
+		WARN_ON_ONCE(1);
+	drm->vblank[head].func = NULL;
 }
 
 static u64
@@ -292,7 +301,6 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 
 	dev->dev_private = drm;
 	drm->dev = dev;
-	drm->vblank.func = nouveau_drm_vblank_handler;
 
 	INIT_LIST_HEAD(&drm->clients);
 	spin_lock_init(&drm->tile.lock);
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.h b/drivers/gpu/drm/nouveau/nouveau_drm.h
index b25df37..9c85601 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.h
@@ -113,7 +113,7 @@ struct nouveau_drm {
 	struct nvbios vbios;
 	struct nouveau_display *display;
 	struct backlight_device *backlight;
-	struct nouveau_eventh vblank;
+	struct nouveau_eventh vblank[16];
 
 	/* power management */
 	struct nouveau_pm *pm;


