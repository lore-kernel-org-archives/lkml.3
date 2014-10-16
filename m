Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaJPN7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:59:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:24975 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbaJPN7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,732,1406617200"; 
   d="scan'208";a="606440483"
Date: Thu, 16 Oct 2014 09:59:03 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v11 06/21] vfs: Add copy_to_iter(), copy_from_iter() and
 iov_iter_zero()
Message-ID: <20141016135903.GA11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com>
 <1411677218-29146-7-git-send-email-matthew.r.wilcox@intel.com>
 <20141016133355.GT19075@thinkos.etherlink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016133355.GT19075@thinkos.etherlink>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 03:33:55PM +0200, Mathieu Desnoyers wrote:
> > +static size_t copy_to_iter_iovec(void *from, size_t bytes, struct iov_iter *i)
> > +{
[...]
> > +	left = __copy_to_user(buf, from, copy);
> 
> How comes this function uses __copy_to_user without any access_ok()
> check ? This has security implications.

The access_ok() check is done higher up the call-chain if it's appropriate.
These functions can be (intentionally) called to access kernel addresses,
so it wouldn't be appropriate to do that here.

> > +static size_t copy_page_to_iter_bvec(struct page *page, size_t offset,
> > +					size_t bytes, struct iov_iter *i)
> > +{
> > +	void *kaddr = kmap_atomic(page);
> > +	size_t wanted = copy_to_iter_bvec(kaddr + offset, bytes, i);
> 
> missing newline.
> 
> > +	kunmap_atomic(kaddr);
> > +	return wanted;
> > +}

Are you seriously suggesting that:

static size_t copy_page_to_iter_bvec(struct page *page, size_t offset,
                                        size_t bytes, struct iov_iter *i)
{
        void *kaddr = kmap_atomic(page);
        size_t wanted = copy_to_iter_bvec(kaddr + offset, bytes, i);

        kunmap_atomic(kaddr);
        return wanted;
}

is more readable than without the newline?  I can see the point of the
rule for functions with a lot of variables, or a lot of lines, but I
don't see the point of it for such a small function.

In any case, this patch is now upstream, so I shan't be proposing any
stylistic changes for it.
