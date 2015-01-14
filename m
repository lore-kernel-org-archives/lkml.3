Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbbANIDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:03:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbbANHe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:34:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 39/77] ALSA: hda - using uninitialized data
Date: Tue, 13 Jan 2015 23:23:19 -0800
Message-Id: <20150114072226.436920147@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 69eba10e606a80665f8573221fec589430d9d1cb upstream.

In olden times the snd_hda_param_read() function always set "*start_id"
but in 2007 we introduced a new return and it causes uninitialized data
bugs in a couple of the callers: print_codec_info() and
hdmi_parse_codec().

Fixes: e8a7f136f5ed ('[ALSA] hda-intel - Improve HD-audio codec probing robustness')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -338,8 +338,10 @@ int snd_hda_get_sub_nodes(struct hda_cod
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


