Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759863AbaLLGdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:33:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51884 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759292AbaLLGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.505771277@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 113/164] ALSA: usb-audio: Fix device_del() sysfs
 warnings at disconnect
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 0725dda207e95ff25f1aa01432250323e0ec49d6 upstream.

Some USB-audio devices show weird sysfs warnings at disconnecting the
devices, e.g.
 usb 1-3: USB disconnect, device number 3
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 973 at fs/sysfs/group.c:216 device_del+0x39/0x180()
 sysfs group ffffffff8183df40 not found for kobject 'midiC1D0'
 Call Trace:
  [<ffffffff814a3e38>] ? dump_stack+0x49/0x71
  [<ffffffff8103cb72>] ? warn_slowpath_common+0x82/0xb0
  [<ffffffff8103cc55>] ? warn_slowpath_fmt+0x45/0x50
  [<ffffffff813521e9>] ? device_del+0x39/0x180
  [<ffffffff81352339>] ? device_unregister+0x9/0x20
  [<ffffffff81352384>] ? device_destroy+0x34/0x40
  [<ffffffffa00ba29f>] ? snd_unregister_device+0x7f/0xd0 [snd]
  [<ffffffffa025124e>] ? snd_rawmidi_dev_disconnect+0xce/0x100 [snd_rawmidi]
  [<ffffffffa00c0192>] ? snd_device_disconnect+0x62/0x90 [snd]
  [<ffffffffa00c025c>] ? snd_device_disconnect_all+0x3c/0x60 [snd]
  [<ffffffffa00bb574>] ? snd_card_disconnect+0x124/0x1a0 [snd]
  [<ffffffffa02e54e8>] ? usb_audio_disconnect+0x88/0x1c0 [snd_usb_audio]
  [<ffffffffa015260e>] ? usb_unbind_interface+0x5e/0x1b0 [usbcore]
  [<ffffffff813553e9>] ? __device_release_driver+0x79/0xf0
  [<ffffffff81355485>] ? device_release_driver+0x25/0x40
  [<ffffffff81354e11>] ? bus_remove_device+0xf1/0x130
  [<ffffffff813522b9>] ? device_del+0x109/0x180
  [<ffffffffa01501d5>] ? usb_disable_device+0x95/0x1f0 [usbcore]
  [<ffffffffa014634f>] ? usb_disconnect+0x8f/0x190 [usbcore]
  [<ffffffffa0149179>] ? hub_thread+0x539/0x13a0 [usbcore]
  [<ffffffff810669f5>] ? sched_clock_local+0x15/0x80
  [<ffffffff81066c98>] ? sched_clock_cpu+0xb8/0xd0
  [<ffffffff81070730>] ? bit_waitqueue+0xb0/0xb0
  [<ffffffffa0148c40>] ? usb_port_resume+0x430/0x430 [usbcore]
  [<ffffffffa0148c40>] ? usb_port_resume+0x430/0x430 [usbcore]
  [<ffffffff8105973e>] ? kthread+0xce/0xf0
  [<ffffffff81059670>] ? kthread_create_on_node+0x1c0/0x1c0
  [<ffffffff814a8b7c>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff81059670>] ? kthread_create_on_node+0x1c0/0x1c0
 ---[ end trace 40b1928d1136b91e ]---

This comes from the fact that usb-audio driver may receive the
disconnect callback multiple times, per each usb interface.  When a
device has both audio and midi interfaces, it gets called twice, and
currently the driver tries to release resources at the last call.
At this point, the first parent interface has been already deleted,
thus deleting a child of the first parent hits such a warning.

For fixing this problem, we need to call snd_card_disconnect() and
cancel pending operations at the very first disconnect while the
release of the whole objects waits until the last disconnect call.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80931
Reported-and-tested-by: Tomas Gayoso <tgayoso@gmail.com>
Reported-and-tested-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/card.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -568,18 +568,19 @@ static void snd_usb_audio_disconnect(str
 {
 	struct snd_card *card;
 	struct list_head *p;
+	bool was_shutdown;
 
 	if (chip == (void *)-1L)
 		return;
 
 	card = chip->card;
 	down_write(&chip->shutdown_rwsem);
+	was_shutdown = chip->shutdown;
 	chip->shutdown = 1;
 	up_write(&chip->shutdown_rwsem);
 
 	mutex_lock(&register_mutex);
-	chip->num_interfaces--;
-	if (chip->num_interfaces <= 0) {
+	if (!was_shutdown) {
 		snd_card_disconnect(card);
 		/* release the pcm resources */
 		list_for_each(p, &chip->pcm_list) {
@@ -593,6 +594,10 @@ static void snd_usb_audio_disconnect(str
 		list_for_each(p, &chip->mixer_list) {
 			snd_usb_mixer_disconnect(p);
 		}
+	}
+
+	chip->num_interfaces--;
+	if (chip->num_interfaces <= 0) {
 		usb_chip[chip->index] = NULL;
 		mutex_unlock(&register_mutex);
 		snd_card_free_when_closed(card);

