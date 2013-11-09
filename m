Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3KIGuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:50:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758476Ab3KIGup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Mark Brown <broonie@linaro.org>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 40/74] ALSA: fix oops in snd_pcm_info() caused by ASoC DPCM
Date: Fri,  8 Nov 2013 22:51:45 -0800
Message-Id: <20131109065116.332644290@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit a4461f41b94cb52e0141af717dcf4ef6558c8e2e upstream.

Unable to handle kernel NULL pointer dereference at virtual address 00000008
pgd = d5300000
[00000008] *pgd=0d265831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT ARM
CPU: 0 PID: 2295 Comm: vlc Not tainted 3.11.0+ #755
task: dee74800 ti: e213c000 task.ti: e213c000
PC is at snd_pcm_info+0xc8/0xd8
LR is at 0x30232065
pc : [<c031b52c>]    lr : [<30232065>]    psr: a0070013
sp : e213dea8  ip : d81cb0d0  fp : c05f7678
r10: c05f7770  r9 : fffffdfd  r8 : 00000000
r7 : d8a968a8  r6 : d8a96800  r5 : d8a96200  r4 : d81cb000
r3 : 00000000  r2 : d81cb000  r1 : 00000001  r0 : d8a96200
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5387d  Table: 15300019  DAC: 00000015
Process vlc (pid: 2295, stack limit = 0xe213c248)
[<c031b52c>] (snd_pcm_info) from [<c031b570>] (snd_pcm_info_user+0x34/0x9c)
[<c031b570>] (snd_pcm_info_user) from [<c03164a4>] (snd_pcm_control_ioctl+0x274/0x280)
[<c03164a4>] (snd_pcm_control_ioctl) from [<c0311458>] (snd_ctl_ioctl+0xc0/0x55c)
[<c0311458>] (snd_ctl_ioctl) from [<c00eca84>] (do_vfs_ioctl+0x80/0x31c)
[<c00eca84>] (do_vfs_ioctl) from [<c00ecd5c>] (SyS_ioctl+0x3c/0x60)
[<c00ecd5c>] (SyS_ioctl) from [<c000e500>] (ret_fast_syscall+0x0/0x48)
Code: e1a00005 e59530dc e3a01001 e1a02004 (e5933008)
---[ end trace cb3d9bdb8dfefb3c ]---

This is provoked when the ASoC front end is open along with its backend,
(which causes the backend to have a runtime assigned to it) and then the
SNDRV_CTL_IOCTL_PCM_INFO is requested for the (visible) backend device.

Resolve this by ensuring that ASoC internal backend devices are not
visible to userspace, just as the commentry for snd_pcm_new_internal()
says it should be.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/pcm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/pcm.c
+++ b/sound/core/pcm.c
@@ -49,6 +49,8 @@ static struct snd_pcm *snd_pcm_get(struc
 	struct snd_pcm *pcm;
 
 	list_for_each_entry(pcm, &snd_pcm_devices, list) {
+		if (pcm->internal)
+			continue;
 		if (pcm->card == card && pcm->device == device)
 			return pcm;
 	}
@@ -60,6 +62,8 @@ static int snd_pcm_next(struct snd_card
 	struct snd_pcm *pcm;
 
 	list_for_each_entry(pcm, &snd_pcm_devices, list) {
+		if (pcm->internal)
+			continue;
 		if (pcm->card == card && pcm->device > device)
 			return pcm->device;
 		else if (pcm->card->number > card->number)


