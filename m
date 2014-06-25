Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaFYHsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:48:37 -0400
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:57062 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752416AbaFYHsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:48:36 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:4321:5007:6119:6120:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fog92_4aa9df326a950
X-Filterd-Recvd-Size: 3480
Message-ID: <1403682511.17451.21.camel@joe-AO725>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Mathias Krause <minipli@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 25 Jun 2014 00:48:31 -0700
In-Reply-To: <877g45qw53.fsf@rasmusvillemoes.dk>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	 <1403477762.18747.14.camel@joe-AO725>
	 <CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	 <1403505219.18747.37.camel@joe-AO725> <87egyeqt03.fsf@rasmusvillemoes.dk>
	 <CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	 <1403638620.29061.35.camel@joe-AO725>
	 <CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
	 <1403641843.29061.51.camel@joe-AO725>
	 <CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
	 <1403643440.29061.56.camel@joe-AO725>
	 <CA+rthh9gKVWix4E0ENPFBXgUMpjnb8_+aeNUi3iZpAnqzo8C1w@mail.gmail.com>
	 <1403646310.29061.61.camel@joe-AO725>
	 <CA+rthh8anKnxA7XuZb4BHB4a7w=Oo3LhUuD2UOwGfv2SGxLs0w@mail.gmail.com>
	 <877g45qw53.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 09:35 +0200, Rasmus Villemoes wrote:

> yes, the source would need
> to be annotated some way or other, or gcc would need to learn the
> semantics of certain kernel functions.
> 
> Speaking of dangling pointers: A similar disaster would happen if some
> code containing pi_* calls gets copy-pasted to some non-__init
> function.

This is my biggest issue with adding these new,
somewhat obscure macros.

> Could checkpatch learn to warn about calling these functions
> from the wrong context?

It's not possible.  checkpatch works on patch chunks.
Any patch chunk may not contain the function attributes.

> Mathias Krause <minipli@googlemail.com> writes:
> 
> > Merging strings across multiple compilation units does not happen,
> > anyway -- not now, not with the new macros.
> 
> Certainly string merging seems to happen, at least at -O1 and higher:
> 
> $ grep . *.c
> a.c:const char *a(void) { return "654321"; }
> b.c:const char *b(void) { return "4321"; }
> c.c:const char *c(void) { return "654321"; }
> main.c:#include <stdio.h>
> main.c:const char *a(void);
> main.c:const char *b(void);
> main.c:const char *c(void);
> main.c:int main(void)
> main.c:{
> main.c: printf("%p\n", a());
> main.c: printf("%p\n", b());
> main.c: printf("%p\n", c());
> main.c: return 0;
> main.c:}
> $ gcc -O1 -c a.c && gcc -O1 -c b.c && gcc -O1 -c c.c
> $ gcc -O1 main.c a.o b.o c.o
> $ ./a.out 
> 0x400630
> 0x400632
> 0x400630
> 
> So not only are identical strings merged; suffixes are also optimized.

Yup.  Nice example.


