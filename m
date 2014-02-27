Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaB0DTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:19:31 -0500
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:56818 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752868AbaB0DT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:19:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:334:355:368:369:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3865:3867:4250:4321:4605:5007:6119:6691:7652:7903:8603:10004:10026:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:13019:14093:14097,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: coach43_184fdeb2e510a
X-Filterd-Recvd-Size: 3435
Message-ID: <1393471165.24588.79.camel@joe-AO722>
Subject: [PATCH V3] sparse: Allow override of sizeof(bool) warning
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 26 Feb 2014 19:19:25 -0800
In-Reply-To: <20140227025845.GA25145@thin>
References: <530E6F76.1070605@zytor.com>
	 <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com>
	 <1393466619.24588.65.camel@joe-AO722> <20140227022857.GC23659@thin>
	 <1393469594.24588.71.camel@joe-AO722> <20140227025845.GA25145@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow an override to emit or not the sizeof(bool) warning.
Add a "-Wsizeof-bool" description to the manpage.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
v2: Add manpage
v3: gah.  Joe knows his alphabet (sometimes). (shadow _then_ sizeof)

 evaluate.c | 3 ++-
 lib.c      | 2 ++
 lib.h      | 1 +
 sparse.1   | 9 +++++++++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/evaluate.c b/evaluate.c
index 6655615..a45f59b 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -2057,7 +2057,8 @@ static struct symbol *evaluate_sizeof(struct expression *expr)
 	}
 
 	if (size == 1 && is_bool_type(type)) {
-		warning(expr->pos, "expression using sizeof bool");
+		if (Wsizeof_bool)
+			warning(expr->pos, "expression using sizeof bool");
 		size = bits_in_char;
 	}
 
diff --git a/lib.c b/lib.c
index bf3e91c..d6ac79d 100644
--- a/lib.c
+++ b/lib.c
@@ -226,6 +226,7 @@ int Wparen_string = 0;
 int Wptr_subtraction_blows = 0;
 int Wreturn_void = 0;
 int Wshadow = 0;
+int Wsizeof_bool = 1;
 int Wtransparent_union = 0;
 int Wtypesign = 0;
 int Wundef = 0;
@@ -438,6 +439,7 @@ static const struct warning {
 	{ "ptr-subtraction-blows", &Wptr_subtraction_blows },
 	{ "return-void", &Wreturn_void },
 	{ "shadow", &Wshadow },
+	{ "sizeof-bool", &Wsizeof_bool },
 	{ "transparent-union", &Wtransparent_union },
 	{ "typesign", &Wtypesign },
 	{ "undef", &Wundef },
diff --git a/lib.h b/lib.h
index f09b338..f6cd9b4 100644
--- a/lib.h
+++ b/lib.h
@@ -120,6 +120,7 @@ extern int Wparen_string;
 extern int Wptr_subtraction_blows;
 extern int Wreturn_void;
 extern int Wshadow;
+extern int Wsizeof_bool;
 extern int Wtransparent_union;
 extern int Wtypesign;
 extern int Wundef;
diff --git a/sparse.1 b/sparse.1
index cd6be26..b7a5b5c 100644
--- a/sparse.1
+++ b/sparse.1
@@ -297,6 +297,15 @@ Such declarations can lead to error-prone code.
 Sparse does not issue these warnings by default.
 .
 .TP
+.B \-Wsizeof-bool
+Warn when checking the sizeof a _Bool.
+
+C99 does not specify the sizeof a _Bool.  gcc uses 1.
+
+Sparse issues these warnings by default.  To turn them off, use
+\fB\-Wno\-sizeof\-bool\fR.
+.
+.TP
 .B \-Wtransparent\-union
 Warn about any declaration using the GCC extension
 \fB__attribute__((transparent_union))\fR.
-- 
1.8.1.2.459.gbcd45b4.dirty



