Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbbAEPTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:19:30 -0500
Received: from smtprelay0184.hostedemail.com ([216.40.44.184]:32771 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753500AbbAEPT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:19:28 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:3138:3139:3140:3141:3142:3165:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:5007:6261:6742:7875:8660:10004:10400:10450:10455:10848:10967:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13148:13230:13255:13311:13357:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knee86_182eae6ef9d12
X-Filterd-Recvd-Size: 3347
Date: Mon, 5 Jan 2015 10:19:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 3.19-rc2 v13 4/5] ARM: Add support for on-demand
 backtrace of other CPUs
Message-ID: <20150105101925.64e8ecec@gandalf.local.home>
In-Reply-To: <1420469699-25350-5-git-send-email-daniel.thompson@linaro.org>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org>
	<1420469699-25350-1-git-send-email-daniel.thompson@linaro.org>
	<1420469699-25350-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Jan 2015 14:54:58 +0000
Daniel Thompson <daniel.thompson@linaro.org> wrote:

> +
> +/* For reliability, we're prepared to waste bits here. */
> +static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
> +static  cpumask_t printtrace_mask;
> +
> +#define NMI_BUF_SIZE		4096
> +
> +struct nmi_seq_buf {
> +	unsigned char		buffer[NMI_BUF_SIZE];
> +	struct seq_buf		seq;
> +};
> +
> +/* Safe printing in NMI context */
> +static DEFINE_PER_CPU(struct nmi_seq_buf, nmi_print_seq);
> +
> +/* "in progress" flag of arch_trigger_all_cpu_backtrace */
> +static unsigned long backtrace_flag;
> +
> +/*
> + * It is not safe to call printk() directly from NMI handlers.
> + * It may be fine if the NMI detected a lock up and we have no choice
> + * but to do so, but doing a NMI on all other CPUs to get a back trace
> + * can be done with a sysrq-l. We don't want that to lock up, which
> + * can happen if the NMI interrupts a printk in progress.
> + *
> + * Instead, we redirect the vprintk() to this nmi_vprintk() that writes
> + * the content into a per cpu seq_buf buffer. Then when the NMIs are
> + * all done, we can safely dump the contents of the seq_buf to a printk()
> + * from a non NMI context.
> + */
> +static int nmi_vprintk(const char *fmt, va_list args)
> +{
> +	struct nmi_seq_buf *s = this_cpu_ptr(&nmi_print_seq);
> +	unsigned int len = seq_buf_used(&s->seq);
> +
> +	seq_buf_vprintf(&s->seq, fmt, args);
> +	return seq_buf_used(&s->seq) - len;
> +}
> +

This is the same code as in x86. I wonder if we should move the
duplicate code into kernel/printk/ and have it compiled if the arch
requests it (CONFIG_ARCH_WANT_NMI_PRINTK or something). That way we
don't have 20 copies of the same nmi_vprintk() and later find that we
need to change it, and have to change it in 20 different archs.

-- Steve

