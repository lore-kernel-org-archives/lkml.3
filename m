Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaBRWrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:47:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaBRWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 21/40] ALSA: hda - Improve loopback path lookups for AD1983
Date: Tue, 18 Feb 2014 14:47:22 -0800
Message-Id: <20140218224433.934255719@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 276ab336b4c6e483d12fd46cbf24f97f71867710 upstream.

AD1983 has flexible loopback routes and the generic parser would take
wrong path confusingly instead of taking individual paths via NID 0x0c
and 0x0d.  For avoiding it, limit the connections at these widgets so
that the parser can think more straightforwardly.  This fixes the
regression of the missing line-in loopback on Dell machine.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=70011
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -490,6 +490,8 @@ static int ad1983_add_spdif_mux_ctl(stru
 static int patch_ad1983(struct hda_codec *codec)
 {
 	struct ad198x_spec *spec;
+	static hda_nid_t conn_0c[] = { 0x08 };
+	static hda_nid_t conn_0d[] = { 0x09 };
 	int err;
 
 	err = alloc_ad_spec(codec);
@@ -500,6 +502,11 @@ static int patch_ad1983(struct hda_codec
 	spec->gen.mixer_nid = 0x0e;
 	spec->gen.beep_nid = 0x10;
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
+
+	/* limit the loopback routes not to confuse the parser */
+	snd_hda_override_conn_list(codec, 0x0c, ARRAY_SIZE(conn_0c), conn_0c);
+	snd_hda_override_conn_list(codec, 0x0d, ARRAY_SIZE(conn_0d), conn_0d);
+
 	err = ad198x_parse_auto_config(codec, false);
 	if (err < 0)
 		goto error;


