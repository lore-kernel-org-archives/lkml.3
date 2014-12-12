Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965610AbaLLG3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:29:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52011 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759352AbaLLGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Pierre-Louis Bossart" <pierre-louis.bossart@linux.intel.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.455845034@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 088/164] ALSA: pcm: Zero-clear reserved fields of PCM
 status ioctl in compat mode
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 317168d0c766defd14b3d0e9c2c4a9a258b803ee upstream.

In compat mode, we copy each field of snd_pcm_status struct but don't
touch the reserved fields, and this leaves uninitialized values
there.  Meanwhile the native ioctl does zero-clear the whole
structure, so we should follow the same rule in compat mode, too.

Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/pcm_compat.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -204,6 +204,8 @@ static int snd_pcm_status_user_compat(st
 	if (err < 0)
 		return err;
 
+	if (clear_user(src, sizeof(*src)))
+		return -EFAULT;
 	if (put_user(status.state, &src->state) ||
 	    put_user(status.trigger_tstamp.tv_sec, &src->trigger_tstamp.tv_sec) ||
 	    put_user(status.trigger_tstamp.tv_nsec, &src->trigger_tstamp.tv_nsec) ||

