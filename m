Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaKCIZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:25:41 -0500
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:48482 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751016AbaKCIZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:25:40 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:5007:6119:6261:6691:7903:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pear36_14162b0440026
X-Filterd-Recvd-Size: 2255
Message-ID: <1415003136.17743.9.camel@perches.com>
Subject: Re: [PATCH 04/13] autofs4 - change printks AUTOFS defined prints
From: Joe Perches <joe@perches.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 03 Nov 2014 00:25:36 -0800
In-Reply-To: <20141103081234.6215.82821.stgit@perseus.themaw.net>
References: <20141103081218.6215.85903.stgit@perseus.themaw.net>
	 <20141103081234.6215.82821.stgit@perseus.themaw.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 16:12 +0800, Ian Kent wrote:
> Use the AUTOFS_*() print defines instead of raw printks.

Please check the output of these conversions.

For instance:

> diff --git a/fs/autofs4/waitq.c b/fs/autofs4/waitq.c
[]
> @@ -162,7 +162,7 @@ static void autofs4_notify_daemon(struct autofs_sb_info *sbi,
>  		break;
>  	}
>  	default:
> -		printk("autofs4_notify_daemon: bad type %d!\n", type);
> +		AUTOFS_WARN("autofs4_notify_daemon: bad type %d!", type);
>  		mutex_unlock(&sbi->wq_mutex);
>  		return;
>  	}

The current #define is:

#define AUTOFS_WARN(fmt, ...)                          \
	pr_warn("pid %d: %s: " fmt "\n",        \
		current->pid, __func__, ##__VA_ARGS__)
 
So this duplicates the function name in the output.

It's probably better to simply use
	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
or
	#define pr_fmt(fmt) KBUILD_MODNAME ":%d:%s" fmt, current->pid, __func__
if you _really_ want pid/func in the output

and just use pr_<level> instead of AUTOFS_<LEVEL> macros.

And it's better to use a consistent style for
these logging functions ideally with terminating
newlines so there isn't a mix of code with
and without those newlines.  That inconsistency
leads to unintended defects.


