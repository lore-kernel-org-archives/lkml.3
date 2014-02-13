Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaBMC7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 21:59:48 -0500
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:60916 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751282AbaBMC7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 21:59:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:152:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3874:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12295:12517:12519:12740:13069:13071:13161:13229:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: van30_38003892f7e1e
X-Filterd-Recvd-Size: 2122
Message-ID: <1392260382.2214.18.camel@joe-AO722>
Subject: Re: [PATCH] ext4: address a benign compiler warning
From: Joe Perches <joe@perches.com>
To: Patrick Palka <patrick@parcs.ath.cx>
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Date: Wed, 12 Feb 2014 18:59:42 -0800
In-Reply-To: <1392257593-3736-1-git-send-email-patrick@parcs.ath.cx>
References: <1392257593-3736-1-git-send-email-patrick@parcs.ath.cx>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-12 at 21:13 -0500, Patrick Palka wrote:
> When !defined(CONFIG_EXT4_DEBUG), mb_debug() should be defined as an
> empty do-while statement so as to suppress the following compiler
> warning:

Hello Patrick.

> fs/ext4/mballoc.c: In function ‘ext4_mb_cleanup_pa’:
> fs/ext4/mballoc.c:2659:47: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
>    mb_debug(1, "mballoc: %u PAs left\n", count);
> ---
> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
[]
> @@ -48,7 +48,7 @@ extern ushort ext4_mballoc_debug;
>  		}							\
>  	} while (0)
>  #else
> -#define mb_debug(n, fmt, a...)
> +#define mb_debug(n, fmt, a...)		do { } while (0)

Ideally, this section should be something like below
so the !CONFIG_EXT4_DEBUG case still verifies that
the format and argument types match.

This can help avoid people adding debug statements but
not compiling with the proper CONFIG_<foo> variable set.

---

#ifdef CONFIG_EXT4_DEBUG
extern ushort ext4_mballoc_debug;

#define mb_debug(n, fmt, ...)					\
do {								\
	if ((n) <= ext4_mballoc_debug)				\
		pr_debug(fmt, ##__VA_ARGS__);			\
	}							\
} while (0)
#else
#define mb_debug(n, fmt, ...)					\
	no_printk(KERN_DEBUG fmt, ##__VA_ARGS__)
#endif


