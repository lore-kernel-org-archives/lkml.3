Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaA1BAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:00:01 -0500
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:59996 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753534AbaA1A77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:59:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2894:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:4321:5007:6119:7652:8603:10004:10400:10848:11026:11473:11658:11914:12517:12519:12555:12740:13069:13311:13357:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mark13_73f81be37fb45
X-Filterd-Recvd-Size: 2575
Message-ID: <1390870794.20150.75.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: ignore arguments to %n
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ryan Mallon <rmallon@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>
Date: Mon, 27 Jan 2014 16:59:54 -0800
In-Reply-To: <20140128003927.GA27319@www.outflux.net>
References: <20140128003927.GA27319@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 16:39 -0800, Kees Cook wrote:

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1735,14 +1735,10 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  		case FORMAT_TYPE_NRCHARS: {
>  			/*
>  			 * Since %n poses a greater security risk than
> -			 * utility, ignore %n and skip its argument.
> +			 * utility, it should not be implemented. Instead,
> +			 * when encountering %n, ignore the arguments.
>  			 */
> -			void *skip_arg;
> -
> -			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
> -					old_fmt);
> -
> -			skip_arg = va_arg(args, void *);
> +			WARN_ONCE(1, "Ignored %%n in '%s'\n", old_fmt);
>  			break;
>  		}

I don't think this is better either.

Why not tell people to fix the code?
checkpatch isn't run on quite a lot of patches.

anyway, here's a possible checkpatch test too.
---
 scripts/checkpatch.pl | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1dbd6d1..95c3264 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4069,6 +4069,15 @@ sub process {
 			}
 		}
 
+# check for unsupported uses of %n in what appear to be formats
+		if ($sline =~ /\b$logFunctions\s*\(.*"/) {
+			my $fmt = get_quoted_string($line, $rawline);
+			if ($fmt ne "" && $fmt =~ /[^\%]\%n/) {
+				WARN("PRINTF_CONTROL_N",
+				     "printf style use of \%n is not supported\n" . $herecurr);
+			}
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&


