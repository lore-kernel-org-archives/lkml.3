Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161614AbaKNRWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:22:21 -0500
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:55951 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161017AbaKNRWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:22:14 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2901:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:6261:6742:7903:8603:8660:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13148:13161:13229:13230:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grain80_6a2f15298540e
X-Filterd-Recvd-Size: 2735
Message-ID: <1415985728.5912.17.camel@perches.com>
Subject: Re: [PATCH v2 1/2] kernel: printk: specify alignment for struct
 printk_log
From: Joe Perches <joe@perches.com>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yury Gribov <y.gribov@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org
Date: Fri, 14 Nov 2014 09:22:08 -0800
In-Reply-To: <1415969446-26356-2-git-send-email-a.ryabinin@samsung.com>
References: <1415969446-26356-1-git-send-email-a.ryabinin@samsung.com>
	 <1415969446-26356-2-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 15:50 +0300, Andrey Ryabinin wrote:
> On architectures that have support for efficient unaligned access
> struct printk_log has 4-byte alignment.
> Specify alignment attribute in type declaration.
> 
> The whole point of this patch is to fix deadlock which happening
> when UBSan detects unaligned access in printk() thus UBSan recursively
> calls printk() with logbuf_lock held by top printk() call.
[]
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
[]
> @@ -223,7 +223,11 @@ struct printk_log {
>  	u8 facility;		/* syslog facility */
>  	u8 flags:5;		/* internal record flags */
>  	u8 level:3;		/* syslog level */
> -};
> +}
> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> +__packed __aligned(4)
> +#endif

Why is adding __packed useful or __aligned(4) useful?

The struct is naturally aligned on u64 and should be
the size of 2 u64s.

struct printk_log {
	u64 ts_nsec;		/* timestamp in nanoseconds */
	u16 len;		/* length of entire record */
	u16 text_len;		/* length of text buffer */
	u16 dict_len;		/* length of dictionary buffer */
	u8 facility;		/* syslog facility */
	u8 flags:5;		/* internal record flags */
	u8 level:3;		/* syslog level */
};

Is there any case when it's not sizeof(u64) * 2?


