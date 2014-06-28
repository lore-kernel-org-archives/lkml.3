Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaF1RuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:50:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbaF1RuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 055/110] media: ivtv: Fix Oops when no firmware is loaded
Date: Sat, 28 Jun 2014 10:46:52 -0700
Message-Id: <20140628174548.906490138@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit deb29e90221a6d4417aa67be971613c353180331 upstream.

When ivtv PCM device is accessed at the state where no firmware is
loaded, it oopses like:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
  IP: [<ffffffffa049a881>] try_mailbox.isra.0+0x11/0x50 [ivtv]
  Call Trace:
    [<ffffffffa049aa20>] ivtv_api_call+0x160/0x6b0 [ivtv]
    [<ffffffffa049af86>] ivtv_api+0x16/0x40 [ivtv]
    [<ffffffffa049b10c>] ivtv_vapi+0xac/0xc0 [ivtv]
    [<ffffffffa049d40d>] ivtv_start_v4l2_encode_stream+0x19d/0x630 [ivtv]
    [<ffffffffa0530653>] snd_ivtv_pcm_capture_open+0x173/0x1c0 [ivtv_alsa]
    [<ffffffffa04526f1>] snd_pcm_open_substream+0x51/0x100 [snd_pcm]
    [<ffffffffa0452853>] snd_pcm_open+0xb3/0x260 [snd_pcm]
    [<ffffffffa0452a37>] snd_pcm_capture_open+0x37/0x50 [snd_pcm]
    [<ffffffffa033f557>] snd_open+0xa7/0x1e0 [snd]
    [<ffffffff8118a628>] chrdev_open+0x88/0x1d0
    [<ffffffff811840be>] do_dentry_open+0x1de/0x270
    [<ffffffff81193a73>] do_last+0x1c3/0xec0
    [<ffffffff81194826>] path_openat+0xb6/0x670
    [<ffffffff81195b65>] do_filp_open+0x35/0x80
    [<ffffffff81185449>] do_sys_open+0x129/0x210
    [<ffffffff815b782d>] system_call_fastpath+0x1a/0x1f

This patch adds the check of firmware at PCM open callback like other
open callbacks of this driver.

Bugzilla: https://apibugzilla.novell.com/show_bug.cgi?id=875440

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -159,6 +159,12 @@ static int snd_ivtv_pcm_capture_open(str
 
 	/* Instruct the CX2341[56] to start sending packets */
 	snd_ivtv_lock(itvsc);
+
+	if (ivtv_init_on_first_open(itv)) {
+		snd_ivtv_unlock(itvsc);
+		return -ENXIO;
+	}
+
 	s = &itv->streams[IVTV_ENC_STREAM_TYPE_PCM];
 
 	v4l2_fh_init(&item.fh, s->vdev);


