Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbbAYNlD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:41:03 -0500
Received: from [198.137.202.9] ([198.137.202.9]:42624 "EHLO
	bombadil.infradead.org" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbbAYNlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:41:01 -0500
Date: Sun, 25 Jan 2015 05:40:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH v2 4/4] block: loop: support to submit I/O via kernel aio
 based
Message-ID: <20150125134038.GD19445@infradead.org>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
 <1421163888-21452-5-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421163888-21452-5-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +{
> +	unsigned int i = 0;
> +	struct iov_iter iter;
> +	struct bio_vec *bvec, bv;
> +	size_t nr_segs = 0;
> +	struct req_iterator r_iter;
> +
> +	rq_for_each_segment(bv, cmd->rq, r_iter)
> +		nr_segs++;
> +
> +	if (nr_segs > LOOP_CMD_BVEC_CNT) {
> +		cmd->alloc_bv = kmalloc(nr_segs * sizeof(*cmd->alloc_bv),
> +					GFP_NOIO);
> +		if (!cmd->alloc_bv)
> +			return -ENOMEM;
> +		bvec = cmd->alloc_bv;
> +	} else {
> +		bvec = cmd->bv;
> +		cmd->alloc_bv = NULL;
> +	}
> +
> +	rq_for_each_segment(bv, cmd->rq, r_iter)
> +		bvec[i++] = bv;

What prevents us from simplify using the bvecs in the request?  Sure
we'd need to disable merging for this case, but it would avoid the
copy, and the potentival memory allocation.
