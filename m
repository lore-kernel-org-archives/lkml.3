Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3LQRTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:19:34 -0500
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:34264 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753129Ab3LQRTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:19:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3872:3873:3874:4321:5007:7576:7652:8660:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13148:13230:13255:13311:13357:13868,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cars36_6fb370baffd16
X-Filterd-Recvd-Size: 1788
Message-ID: <1387300767.18217.67.camel@joe-AO722>
Subject: Re: [PATCH 3/3] printk: Remove separate printk_sched buffers and
 use printk buf instead
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>
Date: Tue, 17 Dec 2013 09:19:27 -0800
In-Reply-To: <1387291691-2224-4-git-send-email-jack@suse.cz>
References: <1387291691-2224-1-git-send-email-jack@suse.cz>
	 <1387291691-2224-4-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-17 at 15:48 +0100, Jan Kara wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
[]
> the
> logbuf_lock must not be held while doing anything that may call into the
> scheduler functions, which includes wake ups. Unfortunately, printk()
> also has a console_sem that it uses, and on release, the
> up(&console_sem) may do a wake up of any pending waiters. This must be
> avoided while holding the logbuf_lock.
[]
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
[]
> @@ -1479,14 +1482,19 @@ asmlinkage int vprintk_emit(int facility, int level,
[]
> +	if (level == -2) {
> +		level = -1;
> +		in_sched = true;
> +	}
[]
>  int printk_sched(const char *fmt, ...)
>  {
[]
> +	r = vprintk_emit(0, -2, NULL, 0, fmt, args);

Can you please use a #define instead of the magic number -2?


