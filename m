Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3LKXbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:31:48 -0500
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:46255 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751000Ab3LKXbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:31:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2895:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:7652:7875:8603:10004:10400:10848:11232:11658:11914:12296:12517:12519:12555:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: owl61_6663c3d6f132f
X-Filterd-Recvd-Size: 3128
Message-ID: <1386804701.2479.2.camel@joe-AO722>
Subject: Re: [PATCH -next 1/3] seq: Add a seq_overflow test.
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Dec 2013 15:31:41 -0800
In-Reply-To: <52A8F4E0.5080402@gmail.com>
References: <cover.1386738050.git.joe@perches.com>
	 <f752df21274aef5c88da81d6c37d427bfe1859a2.1386738050.git.joe@perches.com>
	 <52A8F4E0.5080402@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-12 at 10:27 +1100, Ryan Mallon wrote:
> On 11/12/13 16:12, Joe Perches wrote:
> > seq_printf and seq_puts returns are often misused.
> > 
> > Instead of checking the seq_printf or seq_puts return,
> > add a new seq_overflow function to test if a seq_file has
> > overflowed the available buffer space.
> > 
> > This will eventually allow seq_printf and seq_puts to be
> > converted to have a void return instead of the int return
> > that is often assumed to have a size_t value instead of an
> > error/no-error value.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  fs/seq_file.c            | 15 ++++++++-------
> >  include/linux/seq_file.h |  2 ++
> >  2 files changed, 10 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/seq_file.c b/fs/seq_file.c
> > index 1d641bb..aab0736 100644
> > --- a/fs/seq_file.c
> > +++ b/fs/seq_file.c
> > @@ -14,16 +14,17 @@
> >  #include <asm/uaccess.h>
> >  #include <asm/page.h>
> >  
> > -
> > -/*
> > - * seq_files have a buffer which can may overflow. When this happens a larger
> > - * buffer is reallocated and all the data will be printed again.
> > - * The overflow state is true when m->count == m->size.
> > +/**
> > + * seq_overflow - test if a seq_file has overflowed the space available
> > + * @m: the seq_file handle
> > + *
> > + * Returns -1 when an overflow has occurred, 0 otherwise.
> >   */
> > -static bool seq_overflow(struct seq_file *m)
> > +int seq_overflow(struct seq_file *m)
> >  {
> > -	return m->count == m->size;
> > +	return m->count == m->size ? -1 : 0;
> >  }
> > +EXPORT_SYMBOL(seq_overflow);
> 
> What is the reasoning in making this return int instead of bool? Having
> it return int encourages people to do:
> 
> 	return seq_overflow(s);
> 
> When used in seq_file functions will return -EPERM (-1) to user-space,
> which is confusing. It should probably return bool and let the caller
> sort out the correct error to return.

It was intended to make the return from seq_printf the same.

Anyway, the patch series is out of date (see Al's comments).
I'll update it later unless you or someone else does it first.


