Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaHXQ3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 12:29:04 -0400
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:43925 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753011AbaHXQ3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 12:29:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2553:2559:2562:2693:2740:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4385:5007:6117:6119:7652:7875:7903:10004:10394:10400:10848:11232:11658:11914:12517:12519:12740:13069:13153:13161:13228:13229:13311:13357:14040:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: back66_6ba4d122a705b
X-Filterd-Recvd-Size: 2940
Message-ID: <1408897738.20683.14.camel@joe-AO725>
Subject: Re: [PATCHv3 0/9] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 24 Aug 2014 09:28:58 -0700
In-Reply-To: <CA+rthh8bS9Rj-NmqV6o5CVVMLO3KfsZS9MSQk3uCAqx1TmyQGw@mail.gmail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
	 <20140821162554.GA884@ravnborg.org>
	 <CA+rthh8bS9Rj-NmqV6o5CVVMLO3KfsZS9MSQk3uCAqx1TmyQGw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-24 at 18:04 +0200, Mathias Krause wrote:
> On 21 August 2014 18:25, Sam Ravnborg <sam@ravnborg.org> wrote:
> > So is it really worth it?
> 
> I took the hacky script mentioned in the first email (now also
> attached, init_str.awk), let it ran over the whole kernel, fixed the
> fall-out and did an allmodconfig build. Beside the script being far
> from perfect (it catches a few false positives and, more important,
> only covers a fraction of the potential strings -- only the pr_*()
> macros) it already leads to 24 modules requiring a page less during
> run-time because of the afore mentioned page crossing. It includes
> popular modules like hid.ko and ipv6.ko, so almost anybody would
> benefit from it. But as the page crossing effect depends on the
> particular kernel configuration and toolchain setup, fell free to do
> your own tests. The script doing the measurement is attached, too
> (mod_info.sh)

I think it would be worth it.

I think the added complexity converting:
	printk/pr_<level>
to
	pi_<level>/pe_<level>
for init/exit sections is a lightweight, one-time cost and
continuing upstream maintainer involvement is next to nil.

This mechanism supports all existing compiler toolchains.

Updating toolchains and or using a gcc compiler plugin
means that extra work would also need to be done for llvm
and any other alternate compiler.

And, as Mathias mentioned, the string deduplication logic
may be somewhat complicated for each compiler.

The worst that happens if a printk is added that is not
written as pi_<level> is some unnecessary .text is consumed.

No doubt someone will every so often run Mathias' scripts
against the kernel tree and submit the odd patch to fix it
up.


