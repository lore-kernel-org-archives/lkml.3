Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944AbaA3M0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:26:47 -0500
Received: from gloria.sntech.de ([95.129.55.99]:55831 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaA3M0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:26:45 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC] dtc: add ability to make nodes conditional on them being referenced
Date: Thu, 30 Jan 2014 13:25:56 +0100
Message-ID: <1578575.rVWgTPdq1W@phil>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@bqreaders.com>

On i.MX, which carries a lot of pin-groups of which most are unused on
individual boards, they noticed that this plehora of nodes also results
in the runtime-lookup-performance also degrading [0].

A i.MX-specific solution defining the pingroups in the board files but
using macros to reference the pingroup-data was not well received

This patch is trying to solve this issue in a more general way, by
adding the ability to mark nodes as needing to be referenced somewhere
in the tree.

To mark a node a needing to be referenced it must be prefixed with
/delete-unreferenced/. This makes dtc check the nodes reference-status
when creating the flattened tree, dropping it if unreferenced.

For example, the i.MX6SL pingroup

	/delete-uneferenced/ pinctrl_ecspi1_1: ecspi1grp-1 {
		fsl,pins = <
			MX6SL_PAD_ECSPI1_MISO__ECSPI1_MISO 0x100b1
			MX6SL_PAD_ECSPI1_MOSI__ECSPI1_MOSI 0x100b1
			MX6SL_PAD_ECSPI1_SCLK__ECSPI1_SCLK 0x100b1
		>;
	};

would only be included in the dtb if it got referenced somewhere
as pingroup via

	node {
		pinctrl-0 <&pinctrl_ecscpi1_1>;
	};

[0] http://thread.gmane.org/gmane.linux.ports.arm.kernel/275912/

Signed-off-by: Heiko Stuebner <heiko.stuebner@bqreaders.com>
---
This is just the idea I had in [1] explored a bit more. I'm definitely
not sure if this is a valid approach to the problem.
Also this is my first venture into dtc as well as flex and bison :-) .

[1] http://www.spinics.net/lists/arm-kernel/msg303731.html

 scripts/dtc/checks.c     |    2 ++
 scripts/dtc/dtc-lexer.l  |    7 +++++++
 scripts/dtc/dtc-parser.y |    5 +++++
 scripts/dtc/dtc.h        |    4 ++++
 scripts/dtc/flattree.c   |    3 +++
 scripts/dtc/livetree.c   |   14 ++++++++++++++
 6 files changed, 35 insertions(+)

diff --git a/scripts/dtc/checks.c b/scripts/dtc/checks.c
index ee96a25..747ada8 100644
--- a/scripts/dtc/checks.c
+++ b/scripts/dtc/checks.c
@@ -472,6 +472,8 @@ static void fixup_phandle_references(struct check *c, struct node *dt,
 
 		phandle = get_node_phandle(dt, refnode);
 		*((cell_t *)(prop->val.val + m->offset)) = cpu_to_fdt32(phandle);
+
+		reference_node(refnode);
 	}
 }
 ERROR(phandle_references, NULL, NULL, fixup_phandle_references, NULL,
diff --git a/scripts/dtc/dtc-lexer.l b/scripts/dtc/dtc-lexer.l
index 3b41bfc..3b18e97 100644
--- a/scripts/dtc/dtc-lexer.l
+++ b/scripts/dtc/dtc-lexer.l
@@ -138,6 +138,13 @@ static int pop_input_file(void);
 			return DT_DEL_NODE;
 		}
 
+<*>"/delete-unreferenced/"	{
+			DPRINT("Keyword: /delete-unreferenced/\n");
+			DPRINT("<PROPNODENAME>\n");
+			BEGIN(PROPNODENAME);
+			return DT_DEL_UNREFERENCED;
+		}
+
 <*>{LABEL}:	{
 			DPRINT("Label: %s\n", yytext);
 			yylval.labelref = xstrdup(yytext);
diff --git a/scripts/dtc/dtc-parser.y b/scripts/dtc/dtc-parser.y
index f412460..ae9108b 100644
--- a/scripts/dtc/dtc-parser.y
+++ b/scripts/dtc/dtc-parser.y
@@ -64,6 +64,7 @@ static unsigned char eval_char_literal(const char *s);
 %token DT_BITS
 %token DT_DEL_PROP
 %token DT_DEL_NODE
+%token DT_DEL_UNREFERENCED
 %token <propnodename> DT_PROPNODENAME
 %token <literal> DT_LITERAL
 %token <literal> DT_CHAR_LITERAL
@@ -461,6 +462,10 @@ subnode:
 		{
 			$$ = name_node(build_node_delete(), $2);
 		}
+	| DT_DEL_UNREFERENCED subnode
+		{
+			$$ = check_node_referenced($2);
+		}
 	| DT_LABEL subnode
 		{
 			add_label(&$2->labels, $1);
diff --git a/scripts/dtc/dtc.h b/scripts/dtc/dtc.h
index 3e42a07..c10c440 100644
--- a/scripts/dtc/dtc.h
+++ b/scripts/dtc/dtc.h
@@ -159,6 +159,8 @@ struct node {
 	int addr_cells, size_cells;
 
 	struct label *labels;
+
+	int needs_reference, is_referenced;
 };
 
 #define for_each_label_withdel(l0, l) \
@@ -193,6 +195,8 @@ struct property *reverse_properties(struct property *first);
 struct node *build_node(struct property *proplist, struct node *children);
 struct node *build_node_delete(void);
 struct node *name_node(struct node *node, char *name);
+struct node *check_node_referenced(struct node *node);
+struct node *reference_node(struct node *node);
 struct node *chain_node(struct node *first, struct node *list);
 struct node *merge_nodes(struct node *old_node, struct node *new_node);
 
diff --git a/scripts/dtc/flattree.c b/scripts/dtc/flattree.c
index 665dad7..a327592 100644
--- a/scripts/dtc/flattree.c
+++ b/scripts/dtc/flattree.c
@@ -266,6 +266,9 @@ static void flatten_tree(struct node *tree, struct emitter *emit,
 	if (tree->deleted)
 		return;
 
+	if (tree->needs_reference && !tree->is_referenced)
+		return;
+
 	emit->beginnode(etarget, tree->labels);
 
 	if (vi->flags & FTF_FULLPATH)
diff --git a/scripts/dtc/livetree.c b/scripts/dtc/livetree.c
index b61465f..98bb33d 100644
--- a/scripts/dtc/livetree.c
+++ b/scripts/dtc/livetree.c
@@ -134,6 +134,20 @@ struct node *name_node(struct node *node, char *name)
 	return node;
 }
 
+struct node *check_node_referenced(struct node *node)
+{
+	node->needs_reference = 1;
+
+	return node;
+}
+
+struct node *reference_node(struct node *node)
+{
+	node->is_referenced = 1;
+
+	return node;
+}
+
 struct node *merge_nodes(struct node *old_node, struct node *new_node)
 {
 	struct property *new_prop, *old_prop;
-- 
1.7.10.4


