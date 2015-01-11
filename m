Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbbAKXhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:37:08 -0500
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:56553 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750955AbbAKXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:37:05 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3165:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:5007:6261:6742:7875:7974:8603:10011:10400:10450:10455:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13255:13311:13357:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: start81_3d58bab56454c
X-Filterd-Recvd-Size: 3245
Date: Sun, 11 Jan 2015 18:37:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 3.19-rc2 v13 4/5] ARM: Add support for on-demand
 backtrace of other CPUs
Message-ID: <20150111183700.55ea2434@gandalf.local.home>
In-Reply-To: <20150109164801.GW12302@n2100.arm.linux.org.uk>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
	<1420469699-25350-1-git-send-email-daniel.thompson@linaro.org>
	<1420469699-25350-5-git-send-email-daniel.thompson@linaro.org>
	<20150105101925.64e8ecec@gandalf.local.home>
	<20150109164801.GW12302@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015 16:48:01 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Mon, Jan 05, 2015 at 10:19:25AM -0500, Steven Rostedt wrote:
> > On Mon,  5 Jan 2015 14:54:58 +0000
> > Daniel Thompson <daniel.thompson@linaro.org> wrote:
> > > +/* For reliability, we're prepared to waste bits here. */
> > > +static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
> > > +static  cpumask_t printtrace_mask;
> > > +
> > > +#define NMI_BUF_SIZE		4096
> > > +
> > > +struct nmi_seq_buf {
> > > +	unsigned char		buffer[NMI_BUF_SIZE];
> > > +	struct seq_buf		seq;
> > > +};
> 
> Am I missing something or does this limit us to 4096 characters of
> backtrace output per CPU?
> 
> > This is the same code as in x86. I wonder if we should move the
> > duplicate code into kernel/printk/ and have it compiled if the arch
> > requests it (CONFIG_ARCH_WANT_NMI_PRINTK or something). That way we
> > don't have 20 copies of the same nmi_vprintk() and later find that we
> > need to change it, and have to change it in 20 different archs.
> 
> Agreed, though I wonder about the buffer size.
> 

Have we had kernel back traces bigger than that? Since the stack size
is limited to page size, it would seem dangerous if backtraces filled
up a page size itself, as most function frames are bigger than the
typical 60 bytes of data per line.

We could change that hard coded 4096 to PAGE_SIZE, for those archs with
bigger pages.

Also, if the backtrace were to fill up that much. Most the pertinent
data from a back trace is at the beginning of the trace. Seldom do we
care about the top most callers (bottom of the output).

-- Steve
