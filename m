Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaIIUiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:38:21 -0400
Received: from smtprelay0241.hostedemail.com ([216.40.44.241]:58465 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752364AbaIIUiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:38:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3870:3871:3872:3874:4605:5007:6119:6742:7652:9040:9121:9149:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12438:12517:12519:12555:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rice58_ddbd40298239
X-Filterd-Recvd-Size: 4098
Message-ID: <1410295093.12560.60.camel@joe-AO725>
Subject: [PATCH] checkpatch: Warn on macros with flow control statements
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Drokin, Oleg" <oleg.drokin@intel.com>
Date: Tue, 09 Sep 2014 13:38:13 -0700
In-Reply-To: <20140909125410.GJ6549@mwanda>
References: <1410106715-9573-6-git-send-email-Julia.Lawall@lip6.fr>
	 <20140909125410.GJ6549@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros with flow control statements (goto and return) are
not very nice to read as any flow movement is unexpected.

Try to highlight them and emit a warning on their definition.

Avoid warning on macros that use argument concatenation as
those macros commonly create another function where the
concatenation is used in the function name definition like:
	#define FOO_FUNC(name, rtn_type)	\
	rtn_type func##name(arg1, ...)		\
	{					\
		rtn_type rtn;			\
		[code...]			\
		return rtn;			\
	}

Signed-off-by: Joe Perches <joe@perches.com>
---
>    460  #define OBD_CHECK_DT_OP(obd, op, err)                      \
>    461  do {                                                        \
>    462          if (!OBT(obd) || !OBP((obd), op)) {                  \
>    463                  if (err)                                        \
>    464                          CERROR("obd_" #op ": dev %d no operation\n",    \
>    465                                 obd->obd_minor);          \
>    466                  return err;                                 \
>    467          }                                                      \
>    468  } while (0)
> 
> Wow!  What a terrible macro!  None of the '\' are in a line.  There is
> a hidden return statement in it which is a terrible thing and flow
> control statements are not allowed inside macros.

 scripts/checkpatch.pl | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index da7b2d4..dc5434a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4071,12 +4071,17 @@ sub process {
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);
 			my $ctx = '';
+			my $has_flow_statement = 0;
+			my $has_arg_concat = 0;
 			($dstat, $dcond, $ln, $cnt, $off) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$ctx = $dstat;
 			#print "dstat<$dstat> dcond<$dcond> cnt<$cnt> off<$off>\n";
 			#print "LINE<$lines[$ln-1]> len<" . length($lines[$ln-1]) . "\n";
 
+			$has_flow_statement = 1 if ($ctx =~ /\b(goto|return)\b/);
+			$has_arg_concat = 1 if ($ctx =~ /\#\#/);
+
 			$dstat =~ s/^.\s*\#\s*define\s+$Ident(?:\([^\)]*\))?\s*//;
 			$dstat =~ s/$;//g;
 			$dstat =~ s/\\\n.//g;
@@ -4141,6 +4146,19 @@ sub process {
 				}
 			}
 
+# check for macros with flow control, but without ## concatenation
+# ## concatenation is commonly a macro that defines a function so ignore those
+			if ($has_flow_statement && !$has_arg_concat) {
+				my $herectx = $here . "\n";
+				my $cnt = statement_rawlines($ctx);
+
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
+				WARN("MACRO_WITH_FLOW_CONTROL",
+				     "Macros with flow control statements should be avoided\n" . "$herectx");
+			}
+
 # check for line continuations outside of #defines, preprocessor #, and asm
 
 		} else {


