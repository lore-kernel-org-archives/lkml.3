Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3JNS0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:26:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab3JNS0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:26:43 -0400
Date: Mon, 14 Oct 2013 11:26:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Matt Fleming <matt.fleming@intel.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Karel Zak <kzak@redhat.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH 2/2 for 3.12-rc6] Revert
 "partitions/efi: account for pmbr size in lba"
Message-Id: <20131014112642.8efe63022ea05b07ced7fad8@linux-foundation.org>
In-Reply-To: <1381750909-20082-2-git-send-email-dedekind1@gmail.com>
References: <1381750909-20082-1-git-send-email-dedekind1@gmail.com>
	<1381750909-20082-2-git-send-email-dedekind1@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Oct 2013 14:41:49 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:

> This reverts commit 27a7c642174eaec627f6a3a254035bf8abd02c5e.
> 
> This patch breaks existing systems, for example, Tizen IVI images do not boot
> the way they have always been booted because of this patch.

Does Doug's patch fix this?


From: Doug Anderson <dianders@chromium.org>
Subject: block/partitions/efi.c: treat size mismatch as a warning, not an error

In 27a7c64 ("partitions/efi: account for pmbr size in lba") we started
treating bad sizes in lba field of the partition that has the 0xEE (GPT
protective) as errors.  However, we may run into these "bad sizes" in the
real world if someone uses dd to copy an image from a smaller disk to a
bigger disk.  Since this case used to work (even without using force_gpt),
keep it working and treat the size mismatch as a warning instead of an
error.

Reported-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Sean Paul <seanpaul@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN block/partitions/efi.c~block-partitions-efic-treat-size-mismatch-as-a-warning-not-an-error block/partitions/efi.c
--- a/block/partitions/efi.c~block-partitions-efic-treat-size-mismatch-as-a-warning-not-an-error
+++ a/block/partitions/efi.c
@@ -222,11 +222,16 @@ check_hybrid:
 	 * the disk size.
 	 *
 	 * Hybrid MBRs do not necessarily comply with this.
+	 *
+	 * Consider a bad value here to be a warning to support dd'ing
+	 * an image from a smaller disk to a larger disk.
 	 */
 	if (ret == GPT_MBR_PROTECTIVE) {
 		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
 		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
-			ret = 0;
+			pr_debug("GPT: mbr size in lba (%u) different than whole disk (%u).\n",
+				 sz, min_t(uint32_t,
+					   total_sectors - 1, 0xFFFFFFFF));
 	}
 done:
 	return ret;
_

