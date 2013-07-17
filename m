Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3GQUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 16:14:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45995 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab3GQUO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 16:14:57 -0400
Date: Wed, 17 Jul 2013 14:14:53 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH RFC] lib: Make radix_tree_node_alloc() irq safe
Message-ID: <20130717201453.GH22392@kernel.dk>
References: <1373994390-5479-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373994390-5479-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16 2013, Jan Kara wrote:
> With users of radix_tree_preload() run from interrupt (CFQ is one such
> possible user), the following race can happen:
> 
> radix_tree_preload()
> ...
> radix_tree_insert()
>   radix_tree_node_alloc()
>     if (rtp->nr) {
>       ret = rtp->nodes[rtp->nr - 1];
> <interrupt>
> ...
> radix_tree_preload()
> ...
> radix_tree_insert()
>   radix_tree_node_alloc()
>     if (rtp->nr) {
>       ret = rtp->nodes[rtp->nr - 1];
> 
> And we give out one radix tree node twice. That clearly results in radix
> tree corruption with different results (usually OOPS) depending on which
> two users of radix tree race.
> 
> Fix the problem by disabling interrupts when working with rtp variable.
> In-interrupt user can still deplete our preloaded nodes but at least we
> won't corrupt radix trees.

Looks good to me, great catch Jan.

-- 
Jens Axboe

