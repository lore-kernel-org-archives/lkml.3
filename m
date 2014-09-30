Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaI3SJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:09:48 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:57470 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347AbaI3SJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:09:46 -0400
Message-ID: <1412100583.21730.31.camel@x220>
Subject: [PATCH 1/1] kconfig: warn if an unknown symbol is selected
From: Paul Bolle <pebolle@tiscali.nl>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Sep 2014 20:09:44 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2014 18:09:44.0032 (UTC) FILETIME=[B63A4600:01CFDCD9]
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
assume that any selected symbol is actually set. Selects that violate
this assumption can only be spotted by checking multiple Kconfig files,
often across architectures. It is unlikely that people will do this
regularly.

So let's warn when we notice a select of a symbol that is not known in
the configuration we're creating.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Michal Marek <mmarek@suse.cz>
---
First sent as an RFC in https://lkml.org/lkml/2014/9/26/887 (and
https://lkml.org/lkml/2014/9/26/886 for the cover letter).

Small modification to the commit explanation in comparison to the RFC,
but identical patch. Minor edits to the cover-letter too.

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

