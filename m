Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3KOU6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 15:58:16 -0500
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:45154 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753269Ab3KOU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 15:57:58 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:4321:5007:7652:10004:10400:10848:11232:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: slip24_b31da1a5a900
X-Filterd-Recvd-Size: 1960
Message-ID: <1384549079.18739.33.camel@joe-AO722>
Subject: Re: [REGRESSION] coredumps truncated after "new helper:
 dump_align()"
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Peter Wu <lekensteyn@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 15 Nov 2013 12:57:59 -0800
In-Reply-To: <20131115203838.GJ13318@ZenIV.linux.org.uk>
References: <11835033.kIc1RH0rS1@al>
	 <20131115203838.GJ13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-15 at 20:38 +0000, Al Viro wrote:
> On Fri, Nov 15, 2013 at 03:26:10PM +0100, Peter Wu wrote:
> > Somewhere in the merge window of 3.13, coredumps appear truncated.
> > Instead of 319488 bytes, I get 868 bytes (tested with x86_64 only).
> > 
> > The latest Linus' master (v3.12-9579-g049ffa8) is still affected.
> > Bisection leads to:
> > 
> > commit 22a8cb8248ba5d340307ba72432253b1dbdb5cf7

trivia:

> diff --git a/fs/coredump.c b/fs/coredump.c
[]
> @@ -733,7 +733,7 @@ int dump_align(struct coredump_params *cprm, int align)
>  {
>  	unsigned mod = cprm->written & (align - 1);
>  	if (align & (align - 1))
> -		return -EINVAL;
> -	return mod ? dump_skip(cprm, align - mod) : 0;
> +		return 0;
> +	return mod ? dump_skip(cprm, align - mod) : 1;
>  }
>  EXPORT_SYMBOL(dump_align);

extern int dump_skip(struct coredump_params *cprm, size_t nr);
extern int dump_emit(struct coredump_params *cprm, const void *addr, int nr);
extern int dump_align(struct coredump_params *cprm, int align);

Perhaps all of these should return bool not int.
Is there a reason these should be EXPORT_SYMBOL?


