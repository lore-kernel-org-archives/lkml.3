Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762933AbbA2Csr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:48:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762294AbbA2Ci1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:27 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 089/139] ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery
Date: Wed, 28 Jan 2015 14:20:32 -0800
Message-Id: <1422483682-15393-90-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 66139a48cee1530c91f37c145384b4ee7043f0b7 upstream.

In snd_usbmidi_error_timer(), the driver tries to resubmit MIDI input
URBs to reactivate the MIDI stream, but this causes the error when
some of URBs are still pending like:

 WARNING: CPU: 0 PID: 0 at ../drivers/usb/core/urb.c:339 usb_submit_urb+0x5f/0x70()
 URB ef705c40 submitted while active
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.6-2-desktop #1
 Hardware name: FOXCONN TPS01/TPS01, BIOS 080015  03/23/2010
  c0984bfa f4009ed4 c078deaf f4009ee4 c024c884 c09a135c f4009f00 00000000
  c0984bfa 00000153 c061ac4f c061ac4f 00000009 00000001 ef705c40 e854d1c0
  f4009eec c024c8d3 00000009 f4009ee4 c09a135c f4009f00 f4009f04 c061ac4f
 Call Trace:
  [<c0205df6>] try_stack_unwind+0x156/0x170
  [<c020482a>] dump_trace+0x5a/0x1b0
  [<c0205e56>] show_trace_log_lvl+0x46/0x50
  [<c02049d1>] show_stack_log_lvl+0x51/0xe0
  [<c0205eb7>] show_stack+0x27/0x50
  [<c078deaf>] dump_stack+0x45/0x65
  [<c024c884>] warn_slowpath_common+0x84/0xa0
  [<c024c8d3>] warn_slowpath_fmt+0x33/0x40
  [<c061ac4f>] usb_submit_urb+0x5f/0x70
  [<f7974104>] snd_usbmidi_submit_urb+0x14/0x60 [snd_usbmidi_lib]
  [<f797483a>] snd_usbmidi_error_timer+0x6a/0xa0 [snd_usbmidi_lib]
  [<c02570c0>] call_timer_fn+0x30/0x130
  [<c0257442>] run_timer_softirq+0x1c2/0x260
  [<c0251493>] __do_softirq+0xc3/0x270
  [<c0204732>] do_softirq_own_stack+0x22/0x30
  [<c025186d>] irq_exit+0x8d/0xa0
  [<c0795228>] smp_apic_timer_interrupt+0x38/0x50
  [<c0794a3c>] apic_timer_interrupt+0x34/0x3c
  [<c0673d9e>] cpuidle_enter_state+0x3e/0xd0
  [<c028bb8d>] cpu_idle_loop+0x29d/0x3e0
  [<c028bd23>] cpu_startup_entry+0x53/0x60
  [<c0bfac1e>] start_kernel+0x415/0x41a

For avoiding these errors, check the pending URBs and skip
resubmitting such ones.

Reported-and-tested-by: Stefan Seyfried <stefan.seyfried@googlemail.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/midi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index b901f46..c7aa71e 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -364,6 +364,8 @@ static void snd_usbmidi_error_timer(unsigned long data)
 		if (in && in->error_resubmit) {
 			in->error_resubmit = 0;
 			for (j = 0; j < INPUT_URBS; ++j) {
+				if (atomic_read(&in->urbs[j]->use_count))
+					continue;
 				in->urbs[j]->dev = umidi->dev;
 				snd_usbmidi_submit_urb(in->urbs[j], GFP_ATOMIC);
 			}
-- 
1.9.1

