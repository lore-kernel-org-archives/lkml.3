Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3KIHGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:06:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33382 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab3KIGwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.11 50/94] ALSA: hda - Add missing initial vmaster hook at build_controls callback
Date: Fri,  8 Nov 2013 22:51:56 -0800
Message-Id: <20131109065207.824805144@linuxfoundation.org>
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

commit b63eae0a6c84839275a4638a7baa391be965cd0e upstream.

The generic parser has a support of vmaster hook, but this is
initialized only in the init callback with the check of the presence
of the corresponding kctl.  However, since kctl is NULL at the very
first init callback that is called before build_controls callback, the
vmaster hook sync is skipped there.  Eventually this leads to the
uninitialized state depending on the hook implementation.

This patch adds a simple workaround, just calling the sync function
explicitly at build_controls callback.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -4428,9 +4428,11 @@ int snd_hda_gen_build_controls(struct hd
 					    true, &spec->vmaster_mute.sw_kctl);
 		if (err < 0)
 			return err;
-		if (spec->vmaster_mute.hook)
+		if (spec->vmaster_mute.hook) {
 			snd_hda_add_vmaster_hook(codec, &spec->vmaster_mute,
 						 spec->vmaster_mute_enum);
+			snd_hda_sync_vmaster_hook(&spec->vmaster_mute);
+		}
 	}
 
 	free_kctls(spec); /* no longer needed */


