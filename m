Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3HOVSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:18:16 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38168 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3HOVRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:17:43 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/4] kconfig: silence warning when parsing auto.conf when a symbol has changed type
Date: Thu, 15 Aug 2013 23:17:32 +0200
Message-Id: <04b19b773a60d201bc1b187ba7a7c86dc237a27b.1376600922.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

When a symbol changes type from tristate to bool, and was previously set to
'm', a subsequent silentoldconfig would warn about inconsistency, such as:

    include/config/auto.conf:3014:warning: symbol value 'm' invalid for
    HOTPLUG_PCI_PCIE

Seen by Linus with the merge in aa8032b (sequence to reproduce by Michal):
    git checkout 1fe0135
    make mrproper
    make allmodconfig
    make silentoldconfig
    git checkout aa8032b
    make allmodconfig
    make silentoldconfig

Since HOTPLUG_PCI_PCIE changed from tristate to bool in aa8032b, it was
previously set to 'm' in auto.conf by the first allmodconfig+silentoldconfig,
but then was set to 'y' by the second allmodconfig. Then the second
silentoldconfig prints the warning.

The warning in this case is a spurious warning, which happens at the time
kconfig tries to detect symbols that have changed, to touch the empty
header files in include/config used for dependency-tracking by make.

Silence the warning when we read the old auto.conf file, since it is
perfectly legit that a symbol changed type since the previous call.

Thread in:
    http://marc.info/?l=linux-pci&m=137569198904000&w=2

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 scripts/kconfig/confdata.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index c55c227..87f7238 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -140,7 +140,9 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 			sym->flags |= def_flags;
 			break;
 		}
-		conf_warning("symbol value '%s' invalid for %s", p, sym->name);
+		if (def != S_DEF_AUTO)
+			conf_warning("symbol value '%s' invalid for %s",
+				     p, sym->name);
 		return 1;
 	case S_OTHER:
 		if (*p != '"') {
@@ -161,7 +163,8 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 			memmove(p2, p2 + 1, strlen(p2));
 		}
 		if (!p2) {
-			conf_warning("invalid string found");
+			if (def != S_DEF_AUTO)
+				conf_warning("invalid string found");
 			return 1;
 		}
 		/* fall through */
@@ -172,7 +175,9 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 			sym->def[def].val = strdup(p);
 			sym->flags |= def_flags;
 		} else {
-			conf_warning("symbol value '%s' invalid for %s", p, sym->name);
+			if (def != S_DEF_AUTO)
+				conf_warning("symbol value '%s' invalid for %s",
+					     p, sym->name);
 			return 1;
 		}
 		break;
-- 
1.8.1.2

