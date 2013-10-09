Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3JIWg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 18:36:56 -0400
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:56454 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755689Ab3JIWgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 18:36:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3868:3870:3871:3872:3873:3874:4321:4397:4434:4605:5007:6691:7652:10004:10400:10450:10455:10848:11026:11232:11658:11914:12050:12296:12517:12519:12740:13019:13069:13161:13229:13311:13357:
X-HE-Tag: fifth55_4bae148e403e
X-Filterd-Recvd-Size: 2723
Message-ID: <1381358030.2050.36.camel@joe-AO722>
Subject: Re: [PATCH v3] vsprintf: Check real user/group id for %pK
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, eldad@fogrefinery.com,
        Jiri Kosina <jkosina@suse.cz>, jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 09 Oct 2013 15:33:50 -0700
In-Reply-To: <5255D7D4.8050204@gmail.com>
References: <5255D023.2030907@gmail.com>
	 <1381356014.2050.28.camel@joe-AO722> <5255D2FD.6050705@gmail.com>
	 <1381356861.2050.33.camel@joe-AO722> <5255D7D4.8050204@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 09:25 +1100, Ryan Mallon wrote:

> 	if (kptr_restrict && (in_irq() || in_serving_softirq() ||
> 			      in_nmi())) {
> 
> Is making sure that you don't have kernel code doing something like this:
> 
> 	irqreturn_t some_irq_handler(int irq, void *data)
> 	{
> 		struct seq_file *seq = to_seq(data);
> 
> 		seq_printf(seq, "value = %pK\n");
> 		return IRQ_HANDLED;
> 	}
> 
> Because that obviously won't work when kptr_restrict=1 (because the
> CAP_SYSLOG check is meaningless). However, the code is broken regardless
> of the kptr_restrict value.

The only brokenness I see here is that the code doesn't pass
a pointer along with %pK

		seq_printf(seq, "value of seq: %pK\n", seq);

>  Since the default value of kptr_restrict is
> 0, this kind of bug can go over-looked because the seq file will print
> the pointer value correctly when kptr_restrict=0, and it will correctly
> print 0's when kptr_restrict=2, but it will print 'pK-error' when
> kptr_restrict=1. Doing the check in all cases makes it more likely that
> bugs like this get found. In fact, doing something like:
> 
> 	if (WARN_ON(in_irq() || in_serving_softirq() || in_nmi())) {
> 
> Might be better, since that will print a stack-trace showing where the
> offending vsprintf is.

WARN_ON would be potentially _very_ noisy.
Maybe a long period (once a day?) ratelimited dump_stack();



