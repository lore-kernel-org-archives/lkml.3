Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbaCSNB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:01:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964969AbaCSNBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:01:05 -0400
Date: Wed, 19 Mar 2014 06:00:31 -0700
From: tip-bot for Neil Horman <tipbot@zytor.com>
Message-ID: <tip-cbceb6904f9d99d068711903fc769b84cf036689@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, nhorman@tuxdriver.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, nhorman@tuxdriver.com,
        tglx@linutronix.de
In-Reply-To: <1394649873-14913-1-git-send-email-nhorman@tuxdriver.com>
References: <1394649873-14913-1-git-send-email-nhorman@tuxdriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/iommu] x86:
  Adjust irq remapping quirk for older revisions of 5500/5520 chipsets
Git-Commit-ID: cbceb6904f9d99d068711903fc769b84cf036689
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbceb6904f9d99d068711903fc769b84cf036689
Gitweb:     http://git.kernel.org/tip/cbceb6904f9d99d068711903fc769b84cf036689
Author:     Neil Horman <nhorman@tuxdriver.com>
AuthorDate: Wed, 12 Mar 2014 14:44:33 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Mar 2014 13:57:57 +0100

x86: Adjust irq remapping quirk for older revisions of 5500/5520 chipsets

Commit 03bbcb2e7e2 (iommu/vt-d: add quirk for broken interrupt
remapping on 55XX chipsets) properly disables irq remapping on the
5500/5520 chipsets that don't correctly perform that feature.

However, when I wrote it, I followed the errata sheet linked in that
commit too closely, and explicitly tied the activation of the quirk to
revision 0x13 of the chip, under the assumption that earlier revisions
were not in the field.  Recently a system was reported to be suffering
from this remap bug and the quirk hadn't triggered, because the
revision id register read at a lower value that 0x13, so the quirk
test failed improperly.  Given this, it seems only prudent to adjust
this quirk so that any revision less than 0x13 has the quirk asserted.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1394649873-14913-1-git-send-email-nhorman@tuxdriver.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/early-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index bc4a088..2237b36 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -208,7 +208,7 @@ static void __init intel_remapping_check(int num, int slot, int func)
 	 * and should be flagged as broken.  Additionally revisions 0x12
 	 * and 0x22 of device id 0x3405 has this problem.
 	 */
-	if (revision == 0x13)
+	if (revision < 0x13)
 		set_irq_remapping_broken();
 	else if ((device == 0x3405) &&
 	    ((revision == 0x12) ||
