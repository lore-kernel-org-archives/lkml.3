Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbbA0MR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35013 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447AbbA0MRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 039/126] ALSA: fireworks: fix an endianness bug for transaction length
Date: Tue, 27 Jan 2015 12:15:44 +0000
Message-Id: <1422361031-19364-40-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 92cb46584e104e2f4b14a44959109ffe13524a26 upstream.

Although the 't->length' is a big-endian value, it's used without any
conversion. This means that the driver always uses 'length' parameter.

Fixes: 555e8a8f7f14("ALSA: fireworks: Add command/response functionality into hwdep interface")
Reported-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/firewire/fireworks/fireworks_transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/fireworks/fireworks_transaction.c b/sound/firewire/fireworks/fireworks_transaction.c
index 255dabc6fc33..2a85e4209f0b 100644
--- a/sound/firewire/fireworks/fireworks_transaction.c
+++ b/sound/firewire/fireworks/fireworks_transaction.c
@@ -124,7 +124,7 @@ copy_resp_to_buf(struct snd_efw *efw, void *data, size_t length, int *rcode)
 	spin_lock_irq(&efw->lock);
 
 	t = (struct snd_efw_transaction *)data;
-	length = min_t(size_t, t->length * sizeof(t->length), length);
+	length = min_t(size_t, be32_to_cpu(t->length) * sizeof(u32), length);
 
 	if (efw->push_ptr < efw->pull_ptr)
 		capacity = (unsigned int)(efw->pull_ptr - efw->push_ptr);
-- 
2.1.4

