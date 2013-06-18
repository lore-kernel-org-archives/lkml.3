Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab3FRWrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:47:35 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39170 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933747Ab3FRWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:33 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Matthieu CASTET <matthieu.castet@parrot.com>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 09/14] kconfig/conf: fix randconfig setting multiple symbols in a choice
Date: Wed, 19 Jun 2013 00:45:05 +0200
Message-Id: <e6abf12a77bc56dceeb4cba557b726268e71350e.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Currently, randconfig may set more than one symbol in a given choice.
Given this config file:
    config A
        bool "A"
    if A
    choice
        bool "B/C/D"
    config B
        bool "B"
    config C
        bool "C"
    config D
        bool "D"
    endchoice
    endif # A

Then randconfig generates such .config files (case where A is not set is not
shown below for brevity), and where only the right-most .config is valid:
  CONFIG_A=y                  CONFIG_A=y                  CONFIG_A=y
  CONFIG_B=y                  CONFIG_B=y                  CONFIG_B=y
  CONFIG_C=y                  # CONFIG_C is not set       # CONFIG_C is not set
  # CONFIG_D is not set       CONFIG_D=y                  # CONFIG_D is not set

That is, in a randomised choice, the first symbol is always selected,
and at most one other symbol may be selected.

This is due to symbol randomised in a choice not being properly flagged
as having a value.

Fix that by flagging those symbols adequately: have a user-defined value,
and be not valid (to force recalculation of the symbol).

Note: if the choice is not conditional, then the randomisation is properly
done.

Reported-by: Matthieu CASTET <matthieu.castet@parrot.com>
Signed-off-by: Matthieu CASTET <matthieu.castet@parrot.com>
[yann.morin.1998@free.fr: independently re-done the same patch as Matthieu,
                          as pointed out by Sedat]
Cc: Arnaud Lacombe <lacombar@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/confdata.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 35e0f16..d36bc1f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1077,6 +1077,9 @@ static void randomize_choice_values(struct symbol *csym)
 		else {
 			sym->def[S_DEF_USER].tri = no;
 		}
+		sym->flags |= SYMBOL_DEF_USER;
+		/* clear VALID to get value calculated */
+		sym->flags &= ~SYMBOL_VALID;
 	}
 	csym->flags |= SYMBOL_DEF_USER;
 	/* clear VALID to get value calculated */
-- 
1.8.1.2

