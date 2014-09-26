Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355AbaIZWId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 18:08:33 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:55700 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756311AbaIZWIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 18:08:32 -0400
Message-ID: <1411769309.15241.37.camel@x220>
Subject: [PATCH 1/1] [RFC] kconfig: warn if an unknown symbol is selected
From: Paul Bolle <pebolle@tiscali.nl>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 27 Sep 2014 00:08:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Sep 2014 22:08:29.0605 (UTC) FILETIME=[67483D50:01CFD9D6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A select of an unknown symbol is basically treated as a nop and is
silently skipped. This is annoying if the selected symbol contains a
typo. It can also hide the fact that a treewide symbol cleanup was only
done partially.

There are also a few cases were this might have been done on purpose.
But that anti-pattern should be discouraged. Almost all select
statements point to a known and reachable symbol. So people will likely
assume that any selected symbol is actually set. Violating that
assumption might lead to (subtle) bugs.

So let's warn when we notice a select of a symbol that is not known in
the configuration we're creating.

Rfced-by: Paul Bolle <pebolle@tiscali.nl>
---
 scripts/kconfig/conf.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index fef75fc756f4..de8406287531 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -446,6 +446,45 @@ static void check_conf(struct menu *menu)
 		check_conf(child);
 }
 
+static void check_selects(struct menu *menu)
+{
+	struct symbol *sym, *sel;
+	struct property *prop;
+
+	while (menu) {
+		sym = menu->sym;
+
+		if (sym && !sym_is_choice(sym) &&
+		    sym->type != S_UNKNOWN &&
+		    sym->flags & SYMBOL_WRITE) {
+			for_all_properties(sym, prop, P_SELECT) {
+				sel = prop->expr->left.sym;
+				if (sel->type == S_UNKNOWN &&
+				    expr_calc_value(prop->visible.expr) != no) {
+					fprintf(stderr, "%s:%d:warning: ",
+						prop->file->name,
+						prop->lineno);
+					fprintf(stderr,
+						"'%s' selects unknown symbol '%s'\n",
+						sym->name,
+						sel->name);
+				}
+			}
+		}
+
+		if (menu->list) {
+			menu = menu->list;
+		} else if (menu->next) {
+			menu = menu->next;
+		} else while ((menu = menu->parent)) {
+			if (menu->next) {
+				menu = menu->next;
+				break;
+			}
+		}
+	}
+}
+
 static struct option long_opts[] = {
 	{"oldaskconfig",    no_argument,       NULL, oldaskconfig},
 	{"oldconfig",       no_argument,       NULL, oldconfig},
@@ -681,6 +720,8 @@ int main(int ac, char **av)
 		break;
 	}
 
+	check_selects(rootmenu.list);
+
 	if (sync_kconfig) {
 		/* silentoldconfig is used during the build so we shall update autoconf.
 		 * All other commands are only used to generate a config.
-- 
1.9.3

