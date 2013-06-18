Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab3FRLqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:46:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699Ab3FRLph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonghwan Choi <jhbird.choi@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 93/93] snd_pcm_link(): fix a leak...
Date: Tue, 18 Jun 2013 12:43:41 +0100
Message-Id: <1371555821-12820-94-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit dd6c5cd8fedddc9605209098e2fa4e82c7af22aa upstream.

in case when snd_pcm_stream_linked(substream) is true, we end up leaking
group.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/pcm_native.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 7203c9a..ffb9153 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1633,6 +1633,7 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
 	}
 	if (!snd_pcm_stream_linked(substream)) {
 		substream->group = group;
+		group = NULL;
 		spin_lock_init(&substream->group->lock);
 		INIT_LIST_HEAD(&substream->group->substreams);
 		list_add_tail(&substream->link_list, &substream->group->substreams);
@@ -1647,8 +1648,7 @@ static int snd_pcm_link(struct snd_pcm_substream *substream, int fd)
  _nolock:
 	snd_card_unref(substream1->pcm->card);
 	fput(file);
-	if (res < 0)
-		kfree(group);
+	kfree(group);
 	return res;
 }
 
-- 
1.8.1.2

