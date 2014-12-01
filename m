Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaLAQwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:52:45 -0500
Received: from fencepost.gnu.org ([208.118.235.10]:37679 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaLAQwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:52:44 -0500
Subject: [PATCH] kconfig: fix warning in get_prompt_str()
From: Pavel Roskin <proski@gnu.org>
To: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kbuild@vger.kernel.org
Date: Mon, 01 Dec 2014 11:52:42 -0500
Message-ID: <20141201165242.28180.22924.stgit@IRBT5387>
User-Agent: StGit/0.17.1-2-g5036
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.9.1 cannot figure out that jump would be initialized if both head
and location are not null. Initialize jump with NULL and check that it's
not NULL before using.

jump is not NULL at menu.c:590 if and only if head and location are not
NULL. Once jump is assigned a non-NULL value, head and location cannot go
from NULL to non-NULL or vice versa. It means that (jump != NULL) is
equal to (head && location != 0).

Thus remove checks for head and location. The intent of the check is to
ensure that jump is initialized, so make the code match its intent and
easier to read.

There should be no behavior change in get_prompt_str() regardless of the
input.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 scripts/kconfig/menu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index a26cc5d..72c9dba 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -548,7 +548,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 {
 	int i, j;
 	struct menu *submenu[8], *menu, *location = NULL;
-	struct jump_key *jump;
+	struct jump_key *jump = NULL;
 
 	str_printf(r, _("Prompt: %s\n"), _(prop->text));
 	menu = prop->menu->parent;
@@ -586,7 +586,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 		str_printf(r, _("  Location:\n"));
 		for (j = 4; --i >= 0; j += 2) {
 			menu = submenu[i];
-			if (head && location && menu == location)
+			if (jump && menu == location)
 				jump->offset = strlen(r->s);
 			str_printf(r, "%*c-> %s", j, ' ',
 				   _(menu_get_prompt(menu)));

