Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbbA2JFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:05:12 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44833 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759579AbbA2JFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 030/176] ALSA: hda - using uninitialized data
Date: Wed, 28 Jan 2015 15:27:40 +0100
Message-Id: <d97bff5a0563b701a9b07b7dd5af5a69d91104b0.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 69eba10e606a80665f8573221fec589430d9d1cb upstream.

In olden times the snd_hda_param_read() function always set "*start_id"
but in 2007 we introduced a new return and it causes uninitialized data
bugs in a couple of the callers: print_codec_info() and
hdmi_parse_codec().

Fixes: e8a7f136f5ed ('[ALSA] hda-intel - Improve HD-audio codec probing robustness')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/hda_codec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index e938a68625ea..fed93cb2ee2f 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -329,8 +329,10 @@ int snd_hda_get_sub_nodes(struct hda_codec *codec, hda_nid_t nid,
 	unsigned int parm;
 
 	parm = snd_hda_param_read(codec, nid, AC_PAR_NODE_COUNT);
-	if (parm == -1)
+	if (parm == -1) {
+		*start_id = 0;
 		return 0;
+	}
 	*start_id = (parm >> 16) & 0x7fff;
 	return (int)(parm & 0x7fff);
 }
-- 
2.2.2

