Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbaEEUw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:52:27 -0400
Received: from smtprelay0102.hostedemail.com ([216.40.44.102]:57825 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755358AbaEEUwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:52:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:7652:7903:7904:8531:8985:9025:9388:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13161:13229:13311:13357:13437:13548:14094,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,N
X-HE-Tag: hall07_141d1e57cb019
X-Filterd-Recvd-Size: 3155
Message-ID: <1399323136.26330.22.camel@joe-AO725>
Subject: Re: [PATCH] plist: replace pr_debug with printk in plist_test()
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Date: Mon, 05 May 2014 13:52:16 -0700
In-Reply-To: <20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
References: <CALZtONB-wT16fPX7GjBVFO_5Bof3=zxviG22p6_9ymbnzA9QAA@mail.gmail.com>
	 <1399300985-11137-1-git-send-email-ddstreet@ieee.org>
	 <20140505133517.71b7dc7cf327cb304e8a9edc@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 13:35 -0700, Andrew Morton wrote:
> On Mon,  5 May 2014 10:43:05 -0400 Dan Streetman <ddstreet@ieee.org> wrote:
> 
> > Replace pr_debug() in lib/plist.c test function plist_test() with
> > printk(KERN_DEBUG ...).
> > 
> > Without DEBUG defined, pr_debug() is complied out, but the entire
> > plist_test() function is already inside CONFIG_DEBUG_PI_LIST, so
> > printk should just be used directly.
> >
> > --- a/lib/plist.c
> > +++ b/lib/plist.c
> > @@ -175,7 +175,7 @@ static int  __init plist_test(void)
> >  	int nr_expect = 0, i, loop;
> >  	unsigned int r = local_clock();
> >  
> > -	pr_debug("start plist test\n");
> > +	printk(KERN_DEBUG "start plist test\n");
> 
> Now someone will come along and helpfully switch it back to pr_debug()
> again :(
> 
> What about adding a #define DEBUG?

That can be unfortunate when there are other

#if DEBUG
	some noisy or unnecessary code...
#endif

blocks in the same compilation unit.

> This aspect of pr_debug() is rather surprising and unfortunate and I
> guess we screwed it up.

meh.

It's been this way for quite awhile.

I have over long periods suggested adding
variants like pr_vdbg and pr_dbg_always.

https://lkml.org/lkml/2009/10/13/634
http://patchwork.ozlabs.org/patch/63513/

Never had much success or visibility.

> pr_debug() should unconditionally do the
> printk, just like pr_warn, pr_emerg, etc.

I think that would not be good.

That would set an expectation for dev_dbg which
has never been enabled unconditionally.

> And there should be a
> separate pr_debug_cond() which honours the DEBUG setting.

I think that's suboptimal.

> akpm3:/usr/src/linux-3.15-rc4> grep -r pr_debug . | wc -l
> 10286
> 
> Boy, that's going to be a big patch ;)

$ git grep -E "\bprintk\s*\(s*KERN_DEBUG\b" | wc -l
4412

Not to mention all the macros that use those and are
then themselves used hundreds or thousands of times...


