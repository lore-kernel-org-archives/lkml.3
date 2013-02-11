Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692Ab3BKXj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:39:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760128Ab3BKXj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:39:57 -0500
Date: Mon, 11 Feb 2013 15:39:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/6] idr: fix top layer handling
Message-Id: <20130211153955.0b6e1f1e.akpm@linux-foundation.org>
In-Reply-To: <20130208210050.GA26660@mtj.dyndns.org>
References: <20130208210050.GA26660@mtj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013 13:00:50 -0800
Tejun Heo <tj@kernel.org> wrote:

> Most functions in idr fail to deal with the high bits when the idr
> tree grows to the maximum height.
> 
> * idr_get_empty_slot() stops growing idr tree once the depth reaches
>   MAX_IDR_LEVEL - 1, which is one depth shallower than necessary to
>   cover the whole range.  The function doesn't even notice that it
>   didn't grow the tree enough and ends up allocating the wrong ID
>   given sufficiently high @starting_id.
> 
>   For example, on 64 bit, if the starting id is 0x7fffff01,
>   idr_get_empty_slot() will grow the tree 5 layer deep, which only
>   covers the 30 bits and then proceed to allocate as if the bit 30
>   wasn't specified.  It ends up allocating 0x3fffff01 without the bit
>   30 but still returns 0x7fffff01.
> 
> * __idr_remove_all() will not remove anything if the tree is fully
>   grown.
> 
> * idr_find() can't find anything if the tree is fully grown.
> 
> * idr_for_each() and idr_get_next() can't iterate anything if the tree
>   is fully grown.
> 
> Fix it by introducing idr_max() which returns the maximum possible ID
> given the depth of tree and replacing the id limit checks in all
> affected places.
> 
> As the idr_layer pointer array pa[] needs to be 1 larger than the
> maximum depth, enlarge pa[] arrays by one.
> 
> While this plugs the discovered issues, the whole code base is
> horrible and in desparate need of rewrite.  It's fragile like hell,
> difficult to read and maintain, and plain ugly.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org

This doesn't apply happily to 3.7, so Greg will be needing a redone
version when the time arrives.

But does it really need backporting?  Is anyone likely to hit this in
practice?

Also, I assume you have some sort of IDR test harness over there.  Is
it something we can get into the tree in some fashion to help with
ongoing maintenance?

