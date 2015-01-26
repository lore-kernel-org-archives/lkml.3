Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbbAZOhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:37:08 -0500
Received: from smtprelay0239.hostedemail.com ([216.40.44.239]:38113 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752588AbbAZOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:37:05 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:5007:6119:6120:6261:7875:7903:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12438:12517:12519:12555:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boys72_35d9a09f4c54
X-Filterd-Recvd-Size: 2831
Date: Mon, 26 Jan 2015 09:37:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Message-ID: <20150126093701.699763dc@gandalf.local.home>
In-Reply-To: <1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
	<1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 13:54:53 +0100
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> gcc supports an s390 specific function attribute called "hotpatch".
> It can be used to specify the number of halfwords that shall be added before
> and after a function that shall be filled with nops for runtime patching.
> 
> s390 will use the hotpatch attribute for function tracing, therefore
> introduce a nohotpatch define, depending on CC_USING_HOTPATCH, and add it
> to the existing notrace define.

Are the two mutually exclusive? That is, can you have -pg and hotpatch
together? Reason why I ask is, if you have either -pg or hotpatch, then
we only need "no_instrument_function" or "hotpatch" in the notrace
define, not both. But I could be wrong.

-- Steve

> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  include/linux/compiler.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index b4fd7013c9f4..b4ab98e0e10b 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -54,7 +54,13 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>  #include <linux/compiler-gcc.h>
>  #endif
>  
> -#define notrace __attribute__((no_instrument_function))
> +#ifdef CC_USING_HOTPATCH
> +#define nohotpatch __attribute__((hotpatch(0,0)))
> +#else
> +#define nohotpatch
> +#endif
> +
> +#define notrace __attribute__((no_instrument_function)) nohotpatch
>  
>  /* Intel compiler defines __GNUC__. So we will overwrite implementations
>   * coming from above header files here

