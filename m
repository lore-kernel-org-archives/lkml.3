Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644Ab3DXWan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:30:43 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:55555 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537Ab3DXWa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:30:26 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 4/8] kconfig: fix randconfig tristate detection
Date: Thu, 25 Apr 2013 00:29:51 +0200
Message-Id: <61fa0e17f99b60b851d4480605b7d905d3172f0c.1366841993.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Because the modules' symbole (CONFIG_MODULES) may not yet be set when
we check a symbol's tristate capabilty, we'll always find that tristate
symbols are booleans, even if we randomly decided that to enable modules:
sym_get_type(sym) always return boolean for tristates when modules_sym
has not been previously set to 'y' *and* its value calculated *and* its
visibility calculated, both of which only occur after we randomly assign
values to symbols.

Fix that by looking at the raw type of symbols. Tristate set to 'm' will
be promoted to 'y' when their values will be later calculated.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/confdata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 13ddf11..306cbc1 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1125,7 +1125,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 				sym->def[S_DEF_USER].tri = no;
 				break;
 			case def_random:
-				cnt = sym_get_type(sym) == S_TRISTATE ? 3 : 2;
+				cnt = sym->type == S_TRISTATE ? 3 : 2;
 				sym->def[S_DEF_USER].tri = (tristate)(rand() % cnt);
 				break;
 			default:
-- 
1.7.10.4

