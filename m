Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab3BART0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:19:26 -0500
Received: from slan-550-85.anhosting.com ([174.127.110.175]:25325 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756373Ab3BARTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:19:24 -0500
X-Greylist: delayed 2665 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 12:19:24 EST
Date: Fri, 1 Feb 2013 17:34:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Feng Gao <gfree.wind@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 82/89] netfilter: xt_hashlimit: fix race that results in
 duplicated entries
Message-ID: <20130201163455.GB4908@localhost>
References: <20130201130207.444989281@linuxfoundation.org>
 <20130201130213.388508268@linuxfoundation.org>
 <CA+6hz4qjj3wGgo-m50=qRxAN+OGUXKfUfgRp7Pys7NixgwQ3vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+6hz4qjj3wGgo-m50=qRxAN+OGUXKfUfgRp7Pys7NixgwQ3vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - slan-550-85.anhosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 60rpm.tv
X-Get-Message-Sender-Via: slan-550-85.anhosting.com: authenticated_id: p@60rpm.tv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 11:04:36PM +0800, Feng Gao wrote:
>    Hi Greg,
>    I have a question.
>    There are two duplicated lines now.
>                           dh->expires = now +
>    msecs_to_jiffies(hinfo->cfg.expire);
>                           rateinfo_recalc(dh, now, hinfo->cfg.mode);
>    1# case: The dsthash_find return a valid dh;
>    2# case: There is a race. The race is true.
>    Why we could not adopt the method I sent before.
>        dh = dsthash_find(hinfo, &dst);
>        if (dh == NULL) {
>            dh = dsthash_alloc_init(hinfo, &dst, &new_node);
>            if (dh == NULL) {
>                rcu_read_unlock_bh();
>                goto hotdrop;
>            }
>        }
>        if (new_node) {
>            dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
>            rateinfo_init(dh, hinfo);
>        } else {
>            /* update expiration timeout */
>            dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
>            rateinfo_recalc(dh, now, hinfo->cfg.mode);
>        }
>    I think it could avoid the two duplicated lines.

That's a cleanup, send me a follow up patch for that if you want.

Greg, please, don't back down this patch, it's fixing a real problem.

Gao is proposing some code refactoring to save line a couple of lines
of code.
