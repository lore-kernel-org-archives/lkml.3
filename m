Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab3DZCJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 22:09:50 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:50527 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab3DZCJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 22:09:48 -0400
Message-ID: <5179E1E1.4050304@chrisli.org>
Date: Thu, 25 Apr 2013 19:09:37 -0700
From: Christopher Li <sparse@chrisli.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        Jingoo Han <jg1.han@samsung.com>, kbuild-all@01.org,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] forced argument Was Re: sparse: incorrect type in argument
 1 (different address spaces)
References: <5171d93a.0NZAGYYKNj8hjsAs%fengguang.wu@intel.com> <20130422165629.bae79e6c5251bf148a3bae73@linux-foundation.org> <CANeU7QmDXRj-rNWvb0qhXCmzyJBFv=1URzzjEZN6ARaAf15-hw@mail.gmail.com> <20130423061600.GN6638@mwanda>
In-Reply-To: <20130423061600.GN6638@mwanda>
Content-Type: multipart/mixed;
 boundary="------------050208040901030504040708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050208040901030504040708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/22/2013 11:16 PM, Dan Carpenter wrote:
> That didn't work.  It's the the void * in the parameter list that's
> the problem.  We'd need to do something like the patch below:
> 
> Otherwise we could add "__ok_to_cast" thing to Sparse maybe?

Thanks for the insight. I make a small patch to test the __ok_to_cast
feature. The syntax is adding the force attribute to the argument
declaration.

it will look like this:
static inline long __must_check PTR_ERR( __force const void *ptr)

That means the "ptr" argument will perform a forced cast when receiving
the argument. It is OK to pass __iomem pointer to "ptr".

The example are in the patch. It need to patch both sparse and the
Linux tree.

What do you say?

Chris


--------------050208040901030504040708
Content-Type: text/x-patch;
 name="0001-Allow-forced-attribute-in-function-argument.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Allow-forced-attribute-in-function-argument.patch"

>From a0974ed0fc1e67c41608c780b748c205622956b8 Mon Sep 17 00:00:00 2001
From: Christopher Li <sparse@chrisli.org>
Date: Thu, 25 Apr 2013 18:09:43 -0700
Subject: [PATCH] Allow forced attribute in function argument

It will indicate this argument will skip the compatible check.
---
 evaluate.c             |  2 +-
 parse.c                |  1 +
 symbol.h               |  3 ++-
 validation/fored_arg.c | 18 ++++++++++++++++++
 4 files changed, 22 insertions(+), 2 deletions(-)
 create mode 100644 validation/fored_arg.c

diff --git a/evaluate.c b/evaluate.c
index 9f2c4ac..0dfa519 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -2137,7 +2137,7 @@ static int evaluate_arguments(struct symbol *f, struct symbol *fn, struct expres
 				else
 					degenerate(expr);
 			}
-		} else {
+		} else if (!target->forced_arg){
 			static char where[30];
 			examine_symbol_type(target);
 			sprintf(where, "argument %d", i);
diff --git a/parse.c b/parse.c
index 45ffc10..890e56b 100644
--- a/parse.c
+++ b/parse.c
@@ -1841,6 +1841,7 @@ static struct token *parameter_declaration(struct token *token, struct symbol *s
 	sym->ctype = ctx.ctype;
 	sym->ctype.modifiers |= storage_modifiers(&ctx);
 	sym->endpos = token->pos;
+	sym->forced_arg = ctx.storage_class == SForced;
 	return token;
 }
 
diff --git a/symbol.h b/symbol.h
index 1e74579..1c6ad66 100644
--- a/symbol.h
+++ b/symbol.h
@@ -157,7 +157,8 @@ struct symbol {
 					expanding:1,
 					evaluated:1,
 					string:1,
-					designated_init:1;
+					designated_init:1,
+					forced_arg:1;
 			struct expression *array_size;
 			struct ctype ctype;
 			struct symbol_list *arguments;
diff --git a/validation/fored_arg.c b/validation/fored_arg.c
new file mode 100644
index 0000000..4ab7141
--- /dev/null
+++ b/validation/fored_arg.c
@@ -0,0 +1,18 @@
+/*
+ * check-name: Forced function argument type.
+ */
+
+#define __iomem	__attribute__((noderef, address_space(2)))
+#define __force __attribute__((force))
+
+static void foo(__force void * addr)
+{
+}
+
+
+static void bar(void)
+{
+	void __iomem  *a;
+	foo(a);
+}
+
-- 
1.8.1.4


--------------050208040901030504040708--
