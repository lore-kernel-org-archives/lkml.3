Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaKJXxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:53:38 -0500
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:48664 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751422AbaKJXxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:53:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2376:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:6235:6261:7557:7903:7904:8599:8603:8985:9025:10004:10400:10450:10455:10848:10967:11232:11658:11914:12043:12296:12517:12519:12555:12663:12682:12740:13161:13229:13848:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plane22_592cb32adb411
X-Filterd-Recvd-Size: 3273
Message-ID: <1415663611.8868.25.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Add --strict preference for #defines using
 BIT(foo)
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jiri@resnulli.us,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 10 Nov 2014 15:53:31 -0800
In-Reply-To: <20141110153647.f98f7d60fa24bf3bf7cbc215@linux-foundation.org>
References: <1415265610-9338-1-git-send-email-jiri@resnulli.us>
	 <1415265610-9338-10-git-send-email-jiri@resnulli.us>
	 <20141107.151607.480474516800359791.davem@davemloft.net>
	 <1415394939.23530.20.camel@perches.com>
	 <20141110153647.f98f7d60fa24bf3bf7cbc215@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 15:36 -0800, Andrew Morton wrote:
> On Fri, 07 Nov 2014 13:15:39 -0800 Joe Perches <joe@perches.com> wrote:
> 
> > Using BIT(foo) and BIT_ULL(bar) is more common now.
> > Suggest using these macros over #defines with 1<<value.
> 
> urgh.  I'm counting eightish implementations of BIT(), an unknown
> number of which are actually being used.  Many use 1<<n, some use
> 1UL<<N, another uses 1ULL<<n.  I'm a bit reluctant to recommend that
> anyone should use BIT() until it has has some vigorous scrubbing :(
>
> Is it actually an improvement?  If I see
> 
> #define X	(1U << 7)
> 
> then I know exactly what it does.  Whereas when I see
> 
> #define X	BIT(7)
> 
> I know neither the size or the signedness of X so I have to go look it
> up.

I'm not sure the signedness or type of X matters much
as the non-64bit comparisons are done by promotion to
at least int or unsigned int anyway.

The BIT macro makes sure a single bit is set.

The 'good' one is in bitops.h.  It also has #define BIT_ULL

include/linux/bitops.h:#define BIT(nr)                  (1UL << (nr))
include/linux/bitops.h-#define BIT_ULL(nr)              (1ULL << (nr))

The ones in tools/ are independent and should not be changed.
Excluding tools/, the others should probably be removed

$ git grep -E "define\s+BIT\b" 
arch/arm/mach-davinci/sleep.S:#define BIT(nr)                   (1 << (nr))
drivers/staging/rtl8188eu/include/rtl8188e_spec.h:#define BIT(x)                (1 << (x))
drivers/staging/rtl8188eu/include/wifi.h:#define BIT(x) (1 << (x))
drivers/staging/rtl8192e/rtl8192e/rtl_core.h:#define BIT(_i)                            (1<<(_i))
drivers/staging/rtl8712/osdep_service.h:        #define BIT(x)  (1 << (x))
drivers/staging/rtl8712/wifi.h:#define BIT(x)   (1 << (x))

> I have no strong feelings either way, but I'm wondering what might have
> inspired this change?

David Miller commented on a netdev patch where 1<<foo was
being used in a #define and suggested using BIT.

http://article.gmane.org/gmane.linux.network/337535/match=bit

Using BIT _is_ more common in recent patches too.


