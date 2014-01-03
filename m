Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaACA5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:57:52 -0500
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:48249 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752993AbaACA5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:57:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2393:2553:2559:2562:2771:2828:2911:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:4321:4425:4552:5007:7514:7576:7652:9545:10004:10400:10848:10967:11026:11232:11658:11914:12043:12295:12438:12517:12519:12555:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: smash51_6131e5634160c
X-Filterd-Recvd-Size: 4562
Message-ID: <1388710666.2259.71.camel@joe-AO722>
Subject: Re: [PATCH] printk: flush conflicting continuation line
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>
Cc: Arun KS <arunks.linux@gmail.com>, linux-kernel@vger.kernel.org,
        tj@kernel.org, fweisbec@gmail.com, paul.gortmaker@windriver.com
Date: Thu, 02 Jan 2014 16:57:46 -0800
In-Reply-To: <20140102145548.f3fe2c3fd3ea706ed388685c@linux-foundation.org>
References: <CAKZGPAMmtDNYQfMnujG9pozkn=xd8=9hoB++8avqxgbYomvhTQ@mail.gmail.com>
	 <20140102145548.f3fe2c3fd3ea706ed388685c@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Kay to cc's)

Kay?  any opinion on correctness?

On Thu, 2014-01-02 at 14:55 -0800, Andrew Morton wrote:
> On Wed, 1 Jan 2014 17:44:06 +0530 Arun KS <arunks.linux@gmail.com> wrote:
> 
> > >From d751f9a0cb6329ae3171f6e1cb85e4a3aa792d73 Mon Sep 17 00:00:00 2001
> > From: Arun KS <arun.ks@broadcom.com>
> > Date: Wed, 1 Jan 2014 17:24:46 +0530
> > Subject: printk: flush conflicting continuation line
> > 
> > An earlier newline was missing and current print is from different task.
> > In this scenario flush the continuation line and store this line seperatly.
> > 
> > This patch fix the below scenario of timestamp interleaving,
> > <6>[   28.154370 ] read_word_reg : reg[0x 3], reg[0x 4]  data [0x 642]
> > <6>[   28.155428 ] uart disconnect
> > <6>[   31.947341 ] dvfs[cpufreq.c<275>]:plug-in cpu<1> done
> > <4>[   28.155445 ] UART detached : send switch state 201
> > <6>[   32.014112 ] read_reg : reg[0x 3] data[0x21]
> > 
> > ...
> >
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -1604,7 +1604,10 @@ asmlinkage int vprintk_emit(int facility, int level,
> >   if (!(lflags & LOG_PREFIX))
> >   stored = cont_add(facility, level, text, text_len);
> >   cont_flush(LOG_NEWLINE);
> > - }
> > + /* Flush conflicting buffer. An earlier newline was missing
> > + * and current print is from different task */
> > + } else if (cont.len && cont.owner != current)
> > + cont_flush(LOG_NEWLINE);
> > 
> >   if (!stored)
> >   log_store(facility, level, lflags, 0,
> 
> Your email client makes a horrid mess of the patches :(
> 
> I *think* it's right.  But the code can be significantly simplified and
> optimised.  Please review:
> 
> 	} else {
> 		bool stored = false;
> 
> 		/*
> 		 * If an earlier newline was missing and it was the same task,
> 		 * either merge it with the current buffer and flush, or if
> 		 * there was a race with interrupts (prefix == true) then just
> 		 * flush it out and store this line separately.
> 		 * If the preceding printk was from a different task and missed
> 		 * a newline, flush and append the newline.
> 		 */
> 		if (cont.len) {
> 			if (cont.owner == current && !(lflags & LOG_PREFIX))
> 				stored = cont_add(facility, level, text,
> 						  text_len);
> 			cont_flush(LOG_NEWLINE);
> 		}
> 
> 		if (!stored)
> 			log_store(facility, level, lflags, 0,
> 				  dict, dictlen, text, text_len);
> 	}
> 
> 
> 
> --- a/kernel/printk/printk.c~printk-flush-conflicting-continuation-line-fix
> +++ a/kernel/printk/printk.c
> @@ -1595,15 +1595,15 @@ asmlinkage int vprintk_emit(int facility
>  		 * either merge it with the current buffer and flush, or if
>  		 * there was a race with interrupts (prefix == true) then just
>  		 * flush it out and store this line separately.
> +		 * If the preceding printk was from a different task and missed
> +		 * a newline, flush and append the newline.
>  		 */
> -		if (cont.len && cont.owner == current) {
> -			if (!(lflags & LOG_PREFIX))
> -				stored = cont_add(facility, level, text, text_len);
> -			cont_flush(LOG_NEWLINE);
> -		/* Flush conflicting buffer. An earlier newline was missing
> -		* and current print is from different task */
> -		} else if (cont.len && cont.owner != current)
> +		if (cont.len) {
> +			if (cont.owner == current && !(lflags & LOG_PREFIX))
> +				stored = cont_add(facility, level, text,
> +						  text_len);
>  			cont_flush(LOG_NEWLINE);
> +		}
>  
>  		if (!stored)
>  			log_store(facility, level, lflags, 0,
> _


