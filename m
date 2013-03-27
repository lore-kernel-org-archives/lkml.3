Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3C0Q0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:26:01 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:59925 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3C0QZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:25:59 -0400
Date: Wed, 27 Mar 2013 09:25:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/6] idr: introduce idr_alloc_cyclic
Message-ID: <20130327162553.GB7395@htj.dyndns.org>
References: <1364390288-30968-1-git-send-email-jlayton@redhat.com>
 <1364390288-30968-2-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364390288-30968-2-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jeff.

On Wed, Mar 27, 2013 at 09:18:03AM -0400, Jeff Layton wrote:
> + * Note that people using cyclic allocation to avoid premature reuse of an
> + * already-used ID may be in for a nasty surprise after idr->cur wraps. The
> + * IDR code is designed to avoid unnecessary allocations. If there is space
> + * in an existing layer that holds high IDs then it will return one of those
> + * instead of allocating a new layer at the bottom of the range.

Ooh, does it?  Where?

> +int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end,
> +			gfp_t gfp_mask)
> +{
> +	int id;
> +	int cur = idr->cur;
> +
> +	if (unlikely(start > cur))
> +		cur = start;
> +
> +	id = idr_alloc(idr, ptr, cur, end, gfp_mask);

Would max(id->cur, start) be easier to follow?

> +	if (id == -ENOSPC)
> +		id = idr_alloc(idr, ptr, start, end, gfp_mask);
> +
> +	if (likely(id >= 0))
> +		idr->cur = id + 1;

If @id is INT_MAX, idr->cur will be -1 which is okay as start > cur
test above will correct it on the next iteration but maybe we can do
idr->cur = max(id + 1, 0); for clarity?

Both my points are cosmetic and the patch looks good to me.

  Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
