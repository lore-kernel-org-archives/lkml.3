Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaHXO4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 10:56:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaHXO4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 10:56:45 -0400
Date: Sun, 24 Aug 2014 07:56:31 -0700
From: tip-bot for Henrique de Moraes Holschuh <tipbot@zytor.com>
Message-ID: <tip-ebc14ddcc9454c02439b67f6536628289faaa26e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hmh@hmh.eng.br, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, hmh@hmh.eng.br,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, microcode, intel:
  Fix total_size computation
Git-Commit-ID: ebc14ddcc9454c02439b67f6536628289faaa26e
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

Commit-ID:  ebc14ddcc9454c02439b67f6536628289faaa26e
Gitweb:     http://git.kernel.org/tip/ebc14ddcc9454c02439b67f6536628289faaa26e
Author:     Henrique de Moraes Holschuh <hmh@hmh.eng.br>
AuthorDate: Wed, 23 Jul 2014 17:10:49 -0300
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Mon, 28 Jul 2014 16:08:02 +0200

x86, microcode, intel: Fix total_size computation

According to the Intel SDM vol 3A (order code 253668-051US, June 2014),
on section 9.11.1, page 9-28:

"For microcode updates with a data size field equal to 00000000H, the
size of the microcode update is 2048 bytes. The first 48 bytes contain
the microcode update header. The remaining 2000 bytes contain encrypted
data."

"For microcode updates with a data size not equal to 00000000H, the total
size field specifies the size of the microcode update."

Up to 2002/2003, Intel used an "old format" for the microcode update
containers that was always 2048 bytes in size. That old format did not
have Data Size and Total Size fields, the quadwords at those positions
in the microcode container header were "reserved". The microcode header
of the "old format" microcode container has a hrdver of 0x01. You can
hunt down an old copy of the Intel SDM to validate this through its
order number (#243192). I found one from 1999 through a Google search.

Sometime in 2002/2003 (AFAICT, for the Prescott processors), Intel
documented a new format for the microcode containers and contributed in
2003 some code to the Linux kernel microcode driver implementing support
for the new format. This new format has Data Size and Total Size fields,
as well as the optional extended signature table. However, it reuses the
same hrdver as the old format (0x01), and it can only be told apart from
the old format by a non-zero Data Size field.

In fact, the only reason we can even trust a Data Size of zero to mean
that the microcode container is in the old format, is because Intel
reatroatively promised that the old format would always have a zero
there when they wrote the documentation for the _new_ format.

This is a very old bug, dating back to 2003. It has been dormant
ever since, as Intel seems to set all reserved fields to zero on the
microcode updates they distribute: I could not find a public microcode
update that would trigger this bug.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Link: http://lkml.kernel.org/r/1406146251-8540-1-git-send-email-hmh@hmh.eng.br
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/microcode_intel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 9067166..bbe296e 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -43,7 +43,7 @@ struct extended_sigtable {
 #define DWSIZE			(sizeof(u32))
 
 #define get_totalsize(mc) \
-	(((struct microcode_intel *)mc)->hdr.totalsize ? \
+	(((struct microcode_intel *)mc)->hdr.datasize ? \
 	 ((struct microcode_intel *)mc)->hdr.totalsize : \
 	 DEFAULT_UCODE_TOTALSIZE)
 
