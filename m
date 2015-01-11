Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbbAKVyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 16:54:13 -0500
Received: from smtprelay0124.hostedemail.com ([216.40.44.124]:33180 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750787AbbAKVyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 16:54:11 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::,RULES_HIT:41:355:379:421:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3165:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:5007:6119:6261:7464:7514:7875:7901:7903:10004:10400:10848:10967:11026:11232:11658:11914:12043:12050:12295:12296:12517:12519:12663:12740:13069:13095:13311:13357:14096:14097:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sun65_239190132de35
X-Filterd-Recvd-Size: 2356
Date: Sun, 11 Jan 2015 16:54:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: nick <xerofoify@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        peterz@infradead.org, jiang.liu@linux.intel.com, oleg@redhat.com,
        luto@amacapital.net, bp@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Linker Issues with built-in.o on my machine for x86
Message-ID: <20150111165403.1069bc66@gandalf.local.home>
In-Reply-To: <54B2DF76.8020200@gmail.com>
References: <54B2DF76.8020200@gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jan 2015 15:39:18 -0500
nick <xerofoify@gmail.com> wrote:

> Greetings x86 Maintainers.
> I am getting a linker error as of today on a up to date git tree of linus's on my x86 machine.
> Below this message is the linker message I am getting.
> WARNING: arch/x86/kernel/built-in.o(.text.unlikely+0x1204): Section mismatch in reference from the function cpumask_empty.constprop.3() to the variable .init.data:nmi_ipi_mask
> The function cpumask_empty.constprop.3() references
> the variable __initdata nmi_ipi_mask.
> This is often because cpumask_empty.constprop.3 lacks a __initdata 

Hmm, I bet it had something to do with some sort of gcc optimization,
and is mostly harmless.

> annotation or the annotation of nmi_ipi_mask is wrong.

What gcc are you using and can you send your .config.

remote_ipi() (which is annotated as __init), calls cpumask_empty()
(a static inlined function) with to_cpumask(nmi_ipi_mask). There's
nothing wrong here. I don't see anyway that cpumask_empty() could use
nmi_ipi_mask after boot up.

Seeing that it's not cpumask_empty(), but cpumask_empty.constprop.3
tells me that gcc probably created some function from the static inline
function of cpumask_empty() and that causes the section mismatch test
to give a false error.

If anything should be fixed here, it is to find a way to fix the section
mismatch test from reporting bogus errors like this.

-- Steve

