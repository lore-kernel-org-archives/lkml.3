Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3KAWFW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:05:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3KAWFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:05:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 47/54] ALSA: us122l: Fix pcm_usb_stream mmapping regression
Date: Fri,  1 Nov 2013 15:04:15 -0700
Message-Id: <20131101220216.576348188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220211.311926234@linuxfoundation.org>
References: <20131101220211.311926234@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/usx2y/us122l.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -262,7 +262,9 @@ static int usb_stream_hwdep_mmap(struct
 	}
 
 	area->vm_ops = &usb_stream_hwdep_vm_ops;
-	area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	area->vm_flags |= VM_DONTDUMP;
+	if (!read)
+		area->vm_flags |= VM_DONTEXPAND;
 	area->vm_private_data = us122l;
 	atomic_inc(&us122l->mmap_count);
 out:


