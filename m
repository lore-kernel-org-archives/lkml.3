Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaKFRoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:44:06 -0500
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:46043 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751133AbaKFRoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:44:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:305:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:6261:7903:8660:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12679:12740:13095:13148:13163:13229:13230:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act14_79f8c3f633108
X-Filterd-Recvd-Size: 3535
Message-ID: <1415295835.6634.56.camel@perches.com>
Subject: Re: [RESEND PATCH 3.18-rc3] kdb: Avoid printing KERN_ levels to
 consoles
From: Joe Perches <joe@perches.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 06 Nov 2014 09:43:55 -0800
In-Reply-To: <545BAE67.1060602@linaro.org>
References: <1411555097-16924-1-git-send-email-daniel.thompson@linaro.org>
	 <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
	 <1415290399.6634.52.camel@perches.com> <545BAE67.1060602@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 17:22 +0000, Daniel Thompson wrote:
> On 06/11/14 16:13, Joe Perches wrote:
> > On Thu, 2014-11-06 at 15:27 +0000, Daniel Thompson wrote:
> >> Currently when kdb traps printk messages then the raw log level prefix
> >> (consisting of '\001' followed by a numeral) does not get stripped off
> >> before the message is issued to the various I/O handlers supported by
> >> kdb. This causes annoying visual noise as well as causing problems
> >> grepping for ^. It is also a change of behaviour compared to normal usage
> >> of printk() usage. For example <SysRq>-h ends up with different to that of
> >> kdb's "sr h".
> >>
> >> This patch addresses the problem by stripping log levels from messages
> >> before they are issued to the I/O handlers.
> > 
> > Perhaps instead of stripping the logging level,
> > maybe a KERN_SOH_ASCII 'char' sequence should be
> > emitted as '<' 'char' '>' (see: printk:print_prefix)
> > 
> > Maybe this should be added to stable from v3.6
> > when KERN_SOH_ASCII was first added.
> 
> You mean call the problem a regression and try to restore the original
> 3.5 behaviour?

Yes.

I added KERN_SOH_ASCII so to me it's a regression.

> However I have to confess that I don't really like the old behaviour.
> I'd view it as contradicting the normal behaviours of consoles
> (including the kgdbcon console). Why should printk() inside kdb show
> different text to printk() outside kdb? For me, having <5> and <c>
> scribbled all over the output of an "sr" command (which I think is
> probably the heaviest user of printk() inside kdb) never struck me as
> adding much value.
> 
> Is the above paragraph convincing?

I don't use it so I have a useful opinion.

I don't recall that anyone has reported it in the 
2+ years since so it doesn't seem widely used.

But then again, this is a resend and I don't recall
seeing it the first time either.

> On the other hand if you really mean "perhaps and maybe" then I'd prefer
> to leave it as it it.

Your choice.

btw: in the patch I suggest using printk_skip_level
instead of the direct test here:

+       cp = kdb_buffer;
+       if (cp[0] == KERN_SOH_ASCII && cp[1] != '\0')
+               cp += 2;

so this could be

	cp = printk_skip_level(kdb_buffer);


