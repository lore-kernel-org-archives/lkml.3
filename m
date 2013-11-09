Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125Ab3KIHFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:05:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab3KIGwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.11 51/94] ALSA: hda - Fix unbalanced runtime PM refcount after S3/S4
Date: Fri,  8 Nov 2013 22:51:57 -0800
Message-Id: <20131109065207.892152696@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e6bbe666673ab044a3d39ddb74e4d9a401cf1d6f upstream.

When a machine goes to S3/S4 after power-save is enabled, the runtime
PM refcount might be incorrectly decreased because the power-down
triggered soon after resume assumes that the controller was already
powered up, and issues the pm_notify down.

This patch fixes the incorrect pm_notify call simply by checking the
current value properly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4804,8 +4804,8 @@ static void hda_power_work(struct work_s
 	spin_unlock(&codec->power_lock);
 
 	state = hda_call_codec_suspend(codec, true);
-	codec->pm_down_notified = 0;
-	if (!bus->power_keep_link_on && (state & AC_PWRST_CLK_STOP_OK)) {
+	if (!codec->pm_down_notified &&
+	    !bus->power_keep_link_on && (state & AC_PWRST_CLK_STOP_OK)) {
 		codec->pm_down_notified = 1;
 		hda_call_pm_notify(bus, false);
 	}


