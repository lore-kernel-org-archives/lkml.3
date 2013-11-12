Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3KLQO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:14:29 -0500
Received: from skyrme.org ([193.175.80.135]:48693 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab3KLQOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:14:22 -0500
Date: 12 Nov 2013 16:14:17 +0000
Message-Id: <1384272857-24473-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Jaroslav Kysela" <perex@perex.cz>
Cc: linux-kernel@vger.kernel.org, "Takashi Iwai" <tiwai@suse.de>,
        alsa-devel@alsa-project.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH] ALSA: pcm: retrieve true appl_ptr where stream was unlocked
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculated for data transfer, the local variable appl_ptr is reused,
changed and written back later, though the lock was not held during
the transfer earlier. Admitted, destiny of the lock is not obvious
at all, but this looks much like a race condition candidate, so make
sure to have some original appl_ptr value to work on.

Two occurences.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 sound/core/pcm_lib.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_lib.c b/sound/core/pcm_lib.c
index 6e03b46..47e836a 100644
--- a/sound/core/pcm_lib.c
+++ b/sound/core/pcm_lib.c
@@ -2051,6 +2051,7 @@ static snd_pcm_sframes_t snd_pcm_lib_write1(struct snd_pcm_substream *substream,
 		default:
 			break;
 		}
+		appl_ptr = runtime->control->appl_ptr;
 		appl_ptr += frames;
 		if (appl_ptr >= runtime->boundary)
 			appl_ptr -= runtime->boundary;
@@ -2283,6 +2284,7 @@ static snd_pcm_sframes_t snd_pcm_lib_read1(struct snd_pcm_substream *substream,
 		default:
 			break;
 		}
+		appl_ptr = runtime->control->appl_ptr;
 		appl_ptr += frames;
 		if (appl_ptr >= runtime->boundary)
 			appl_ptr -= runtime->boundary;
-- 
1.7.9.5

