Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaHVKGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:06:23 -0400
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:40400 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751974AbaHVKGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:06:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2197:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:7652:8660:9121:10004:10400:10848:11026:11232:11657:11658:11914:12043:12438:12517:12519:12555:12679:12740:13069:13148:13161:13229:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bat10_8e74b31a03e4a
X-Filterd-Recvd-Size: 2910
Message-ID: <1408701977.22832.53.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch.pl: New instances of ENOSYS are errors
From: Joe Perches <joe@perches.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Date: Fri, 22 Aug 2014 03:06:17 -0700
In-Reply-To: <973469ca58b32c73c7c8ca68065e22a18574e112.1408680621.git.luto@amacapital.net>
References: <973469ca58b32c73c7c8ca68065e22a18574e112.1408680621.git.luto@amacapital.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 23:13 -0500, Andy Lutomirski wrote:
> ENOSYS means that a nonexistent system call was called.  We have a
> bad habit of using it for things like invalid operations on
> otherwise valid syscalls.  We should avoid this in new code.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2372,6 +2372,15 @@ sub process {
>  			     "Using $1 is unnecessary\n" . $herecurr);
>  		}
>  
> +# ENOSYS means "bad syscall nr" and nothing else
> +# (note that this doesn't run on assembly files, so entry*.S is okay)
> +		if ($line =~ /ENOSYS/) {
> +			my $herevet = "$here\n" . cat_vet($line) . "\n";
> +			ERROR("ENOSYS",
> +			      "ENOSYS means 'invalid syscall nr' and nothing else\n" .
> +			      "       (ignore if this really is syscall entry code)\n" . $herevet);
> +		}
> +

It seems this would be noisy.

ENOSYS seems to be used for a lot of other purposes
than syscalls.

Maybe this comment should be changed to clarify:

include/uapi/asm-generic/errno.h:#define        ENOSYS          38      /* Function not implemented */

And this should probably be:

		if ($line =~ /\bENOSYS\b/) {

The $herevet should be $herecurr

And this should be moved after line 2902 so that
it doesn't emit on patch context lines like:

$ git diff drivers/acpi/apei/erst.c
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index ed65e9c..acccc07 100644--git a
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -771,6 +771,7 @@ static int __erst_write_to_nvram(const struct cper_record_header *record)
 static int __erst_read_to_erange_from_nvram(u64 record_id, u64 *offset)
 {
        pr_unimpl_nvram();
+
        return -ENOSYS;
 }
 
$ git diff drivers/acpi/apei/erst.c | ./scripts/checkpatch.pl -
ERROR: ENOSYS means 'invalid syscall nr' and nothing else
       (ignore if this really is syscall entry code)
#10: FILE: drivers/acpi/apei/erst.c:775:
 ^Ireturn -ENOSYS;$


