Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaKGQEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:04:38 -0500
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:49769 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751578AbaKGQEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:04:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:305:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2693:2828:3138:3139:3140:3141:3142:3315:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:6261:6691:7903:8957:10004:10400:10848:11026:11232:11473:11658:11914:12438:12517:12519:12663:12740:13095:13161:13229:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cry72_27e968541b753
X-Filterd-Recvd-Size: 3353
Message-ID: <1415376272.23530.10.camel@perches.com>
Subject: Re: [PATCH v2 3.18-rc3] kdb: Avoid printing KERN_ levels to consoles
From: Joe Perches <joe@perches.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org
Date: Fri, 07 Nov 2014 08:04:32 -0800
In-Reply-To: <1415361686-3797-1-git-send-email-daniel.thompson@linaro.org>
References: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
	 <1415361686-3797-1-git-send-email-daniel.thompson@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 12:01 +0000, Daniel Thompson wrote:
> Currently when kdb traps printk messages then the raw log level prefix
> (consisting of '\001' followed by a numeral) does not get stripped off
> before the message is issued to the various I/O handlers supported by
> kdb. This causes annoying visual noise as well as causing problems
> grepping for ^. It is also a change of behaviour compared to normal usage
> of printk() usage. For example <SysRq>-h ends up with different output to
> that of kdb's "sr h".
> 
> This patch addresses the problem by stripping log levels from messages
> before they are issued to the I/O handlers. printk() which can also
> act as an i/o handler in some cases is special cased; if the caller
> provided a log level then this will be preserved when sent to printk().
> 
> The addition of non-printable characters to the output of kdb commands is a
> regression, albeit and extremely elderly one, introduced by commit
> 04d2c8c83d0e ("printk: convert the format for KERN_<LEVEL> to a 2 byte
> pattern"). Note also that this patch does *not* restore the original
> behaviour from v3.5. Instead it makes printk() from within a kdb command
> display the message without any prefix (i.e. like printk() normally does).
[]
> diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
[]
> @@ -711,7 +712,10 @@ kdb_printit:
>  	if (logging) {
>  		saved_loglevel = console_loglevel;
>  		console_loglevel = CONSOLE_LOGLEVEL_SILENT;
> -		printk(KERN_INFO "%s", kdb_buffer);
> +		if (cp == kdb_buffer)
> +			printk(KERN_INFO "%s", kdb_buffer);
> +		else
> +			printk("%s", kdb_buffer);

The first part of the patch seem fine, but I'm
confused about this bit above.

Here, isn't the "if (cp == kdb_buffer)" unnecessary?

if "(cp != kdb_buffer)", the buffer does have
a prefix and it's emitted.

If (cp == kdb_buffer), the buffer does _not_ have
a prefix (meaning it's either a naked printk or
a continuation line. (KERN_CONT is "")

So why insert KERN_INFO?

I believe the code should be:

-		printk(KERN_INFO "%s", kdb_buffer);
+		printk("%s", kdb_buffer);


