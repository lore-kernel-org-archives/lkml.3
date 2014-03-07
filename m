Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaCGLS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:18:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:36564 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaCGLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:18:54 -0500
Date: Fri, 7 Mar 2014 12:18:49 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
        Ben Skeggs <bskeggs@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: nouveau crash due to missing channel (WAS: Re: [ANNOUNCE]
 3.12.12-rt19)
Message-ID: <20140307111848.GA8637@linutronix.de>
References: <20140223184727.GA12442@linutronix.de>
 <53128DED.1000402@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53128DED.1000402@localhost>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Fernando Lopez-Lezcano | 2014-03-01 17:48:29 [-0800]:

>On 02/23/2014 10:47 AM, Sebastian Andrzej Siewior wrote:
>>Dear RT folks!
>>
>>I'm pleased to announce the v3.12.12-rt19 patch set.
>
>Just hit this Oops in my desktop at home:
>
>[22328.388996] BUG: unable to handle kernel NULL pointer dereference
>at 0000000000000008
>[22328.389013] IP: [<ffffffffa011a912>]
>nouveau_fence_wait_uevent.isra.2+0x22/0x440 [nouveau]

This is

| static int
| nouveau_fence_wait_uevent(struct nouveau_fence *fence, bool intr)
| 
| {
|         struct nouveau_channel *chan = fence->channel;
|         struct nouveau_fifo *pfifo = nouveau_fifo(chan->drm->device);

and chan is NULL. 

>[22328.389046] RAX: 0000000000000000 RBX: ffff8807a68f8fa8 RCX:
>0000000000000000
>[22328.389046] RDX: 0000000000000001 RSI: ffff8807a68f8fb0 RDI:
>ffff8807a68f8fa8
>[22328.389047] RBP: ffff8807c09bdca0 R08: 000000000000045e R09:
>000000000000e200
>[22328.389047] R10: ffffffffa0157d80 R11: ffff8807c09bdde0 R12:
>0000000000000001
>[22328.389047] R13: 0000000000000000 R14: ffff8807d8493a80 R15:
>ffff8807a68f8fb0
>[22328.389053] Call Trace:
>[22328.389069]  [<ffffffffa011af56>] nouveau_fence_wait+0x86/0x1a0 [nouveau]
>[22328.389081]  [<ffffffffa011ca35>] nouveau_bo_fence_wait+0x15/0x20
>[nouveau]
>[22328.389084]  [<ffffffffa00867c6>] ttm_bo_wait+0x96/0x1a0 [ttm]
>[22328.389095]  [<ffffffffa0121dac>]
>nouveau_gem_ioctl_cpu_prep+0x5c/0xf0 [nouveau]
>[22328.389101]  [<ffffffffa002cd42>] drm_ioctl+0x502/0x630 [drm]
>[22328.389114]  [<ffffffffa01180a1>] nouveau_drm_ioctl+0x51/0x90 [nouveau]

I can't find any kind of locking so my question is what ensures that chan is
not set to NULL between nouveau_fence_done() and
nouveau_fence_wait_uevent()? There are just a few opcodes in between but
nothing that pauses nouveau_fence_signal().

Fernando, can you please check the patch below and test if the warning
or the crash appears?

diff --git a/drivers/gpu/drm/nouveau/nouveau_fence.c b/drivers/gpu/drm/nouveau/nouveau_fence.c
--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -184,14 +184,20 @@ nouveau_fence_wait_uevent(struct nouveau_fence *fence, bool intr)
 
 {
 	struct nouveau_channel *chan = fence->channel;
-	struct nouveau_fifo *pfifo = nouveau_fifo(chan->drm->device);
-	struct nouveau_fence_priv *priv = chan->drm->fence;
+	struct nouveau_fifo *pfifo;
+	struct nouveau_fence_priv *priv;
 	struct nouveau_fence_uevent uevent = {
 		.handler.func = nouveau_fence_wait_uevent_handler,
-		.priv = priv,
 	};
 	int ret = 0;
 
+	if (WARN_ON_ONCE(!chan))
+		return 0;
+
+	pfifo = nouveau_fifo(chan->drm->device);
+	priv = chan->drm->fence;
+	uevent.priv = priv;
+
 	nouveau_event_get(pfifo->uevent, 0, &uevent.handler);
 
 	if (fence->timeout) {

>-- Fernando

Sebastian
