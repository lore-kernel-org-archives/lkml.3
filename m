Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab3CREgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:36:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33693 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752266Ab3CREbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:10 -0400
Message-Id: <20130318042146.875801211@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:10 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>
Subject: [ 26/82] ALSA: vmaster: Fix slave change notification
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/vmaster.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/core/vmaster.c
+++ b/sound/core/vmaster.c
@@ -209,7 +209,10 @@ static int slave_put(struct snd_kcontrol
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


