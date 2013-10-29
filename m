Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3J2SIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59363 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3J2SIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 72/81] ALSA: us122l: Fix pcm_usb_stream mmapping regression
Date: Tue, 29 Oct 2013 11:04:33 -0700
Message-Id: <1383069882-11437-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ac536a848a1643e4b87e8fbd376a63091afc2ccc upstream.

The pcm_usb_stream plugin requires the mremap explicitly for the read
buffer, as it expands itself once after reading the required size.
But the commit [314e51b9: mm: kill vma flag VM_RESERVED and
mm->reserved_vm counter] converted blindly to a combination of
VM_DONTEXPAND | VM_DONTDUMP like other normal drivers, and this
resulted in the failure of mremap().

For fixing this regression, we need to remove VM_DONTEXPAND for the
read-buffer mmap.

Reported-and-tested-by: James Miller <jamesstewartmiller@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/usx2y/us122l.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index d0323a6..999550b 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -262,7 +262,9 @@ static int usb_stream_hwdep_mmap(struct snd_hwdep *hw,
 	}
 
 	area->vm_ops = &usb_stream_hwdep_vm_ops;
-	area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	area->vm_flags |= VM_DONTDUMP;
+	if (!read)
+		area->vm_flags |= VM_DONTEXPAND;
 	area->vm_private_data = us122l;
 	atomic_inc(&us122l->mmap_count);
 out:
-- 
1.8.1.2

