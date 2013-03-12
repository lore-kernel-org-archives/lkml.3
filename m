Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3CLWdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab3CLWdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 061/100] ALSA: vmaster: Fix slave change notification
Date: Tue, 12 Mar 2013 15:31:46 -0700
Message-Id: <20130312223129.547918191@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2069d483b39a603a5f3428a19d3b4ac89aa97f48 upstream.

When a value of a vmaster slave control is changed, the ctl change
notification is sometimes ignored.  This happens when the master
control overrides, e.g. when the corresponding master control is
muted.  The reason is that slave_put() returns the value of the actual
slave put callback, and it doesn't reflect the virtual slave value
change.

This patch fixes the function just to return 1 whenever a slave value
is changed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/vmaster.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/core/vmaster.c
+++ b/sound/core/vmaster.c
@@ -213,7 +213,10 @@ static int slave_put(struct snd_kcontrol
 	}
 	if (!changed)
 		return 0;
-	return slave_put_val(slave, ucontrol);
+	err = slave_put_val(slave, ucontrol);
+	if (err < 0)
+		return err;
+	return 1;
 }
 
 static int slave_tlv_cmd(struct snd_kcontrol *kcontrol,


