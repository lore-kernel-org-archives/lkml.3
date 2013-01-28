Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3A1Eak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 23:30:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3A1Eai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 23:30:38 -0500
Date: Sun, 27 Jan 2013 20:29:56 -0800
From: tip-bot for David Woodhouse <David.Woodhouse@intel.com>
Message-ID: <tip-70a479cbe80296d3113e65cc2f713a5101061daf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        matt.fleming@intel.com, stable@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, David.Woodhouse@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        matt.fleming@intel.com, David.Woodhouse@intel.com
In-Reply-To: <1358513837.2397.247.camel@shinybook.infradead.org>
References: <1358513837.2397.247.camel@shinybook.infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Fix display detection in EFI boot stub
Git-Commit-ID: 70a479cbe80296d3113e65cc2f713a5101061daf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 27 Jan 2013 20:30:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70a479cbe80296d3113e65cc2f713a5101061daf
Gitweb:     http://git.kernel.org/tip/70a479cbe80296d3113e65cc2f713a5101061daf
Author:     David Woodhouse <David.Woodhouse@intel.com>
AuthorDate: Mon, 7 Jan 2013 21:52:16 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 27 Jan 2013 20:19:37 -0800

x86, efi: Fix display detection in EFI boot stub

When booting under OVMF we have precisely one GOP device, and it
implements the ConOut protocol.

We break out of the loop when we look at it... and then promptly abort
because 'first_gop' never gets set. We should set first_gop *before*
breaking out of the loop. Yes, it doesn't really mean "first" any more,
but that doesn't matter. It's only a flag to indicate that a suitable
GOP was found.

In fact, we'd do just as well to initialise 'width' to zero in this
function, then just check *that* instead of first_gop. But I'll do the
minimal fix for now (and for stable@).

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1358513837.2397.247.camel@shinybook.infradead.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 18e329c..448a86e 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -432,10 +432,9 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 			 * Once we've found a GOP supporting ConOut,
 			 * don't bother looking any further.
 			 */
+			first_gop = gop;
 			if (conout_found)
 				break;
-
-			first_gop = gop;
 		}
 	}
 
