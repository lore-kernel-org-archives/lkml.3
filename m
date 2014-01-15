Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaAOLGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:06:44 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:43510 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751046AbaAOLGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:06:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:152:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12679:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mist22_916206c9e9e21
X-Filterd-Recvd-Size: 2007
Message-ID: <1389783998.14001.22.camel@joe-AO722>
Subject: Re: [PATCH -next 2/2] bcache: Use max_t() when comparing different
 types
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Neil Brown <neilb@suse.de>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Date: Wed, 15 Jan 2014 03:06:38 -0800
In-Reply-To: <1389776784-30825-2-git-send-email-geert@linux-m68k.org>
References: <1389776784-30825-1-git-send-email-geert@linux-m68k.org>
	 <1389776784-30825-2-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 10:06 +0100, Geert Uytterhoeven wrote:
> drivers/md/bcache/btree.c: In function ‘insert_u64s_remaining’:
> drivers/md/bcache/btree.c:1816: warning: comparison of distinct pointer types lacks a cast
[]
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
[]
> @@ -1813,7 +1813,7 @@ static size_t insert_u64s_remaining(struct btree *b)
>  	if (b->keys.ops->is_extents)
>  		ret -= KEY_MAX_U64S;
>  
> -	return max(ret, 0L);
> +	return max_t(ssize_t, ret, 0L);

why not
	return max(ret, 0);

I think it odd that:

drivers/md/bcache/bset.h:static inline size_t bch_btree_keys_u64s_remaining(struct btree_keys *b)

and:

static size_t insert_u64s_remaining(struct btree *b)
{
	ssize_t ret = bch_btree_keys_u64s_remaining(&b->keys);

	/*
	 * Might land in the middle of an existing extent and have to split it
	 */
	if (b->keys.ops->is_extents)
		ret -= KEY_MAX_U64S;

	return max(ret, 0L);
}

so the only use of that size_t inline is cast to ssize_t


