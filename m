Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaJPOMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:12:16 -0400
Received: from mail.efficios.com ([78.47.125.74]:37636 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbaJPOMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:12:14 -0400
Date: Thu, 16 Oct 2014 14:12:06 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <837939598.10389.1413468726146.JavaMail.zimbra@efficios.com>
In-Reply-To: <20141016135903.GA11522@wil.cx>
References: <1411677218-29146-1-git-send-email-matthew.r.wilcox@intel.com> <1411677218-29146-7-git-send-email-matthew.r.wilcox@intel.com> <20141016133355.GT19075@thinkos.etherlink> <20141016135903.GA11522@wil.cx>
Subject: Re: [PATCH v11 06/21] vfs: Add copy_to_iter(), copy_from_iter() and
 iov_iter_zero()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [62.156.150.204]
X-Mailer: Zimbra 8.0.7_GA_6021 (ZimbraWebClient - FF32 (Linux)/8.0.7_GA_6021)
Thread-Topic: Add copy_to_iter(), copy_from_iter() and iov_iter_zero()
Thread-Index: x2d4rjIdPrimtIAsjfRH+uURrx8Msw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Matthew Wilcox" <willy@linux.intel.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: "Matthew Wilcox" <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
> linux-kernel@vger.kernel.org, "Matthew Wilcox" <willy@linux.intel.com>
> Sent: Thursday, October 16, 2014 3:59:03 PM
> Subject: Re: [PATCH v11 06/21] vfs: Add copy_to_iter(), copy_from_iter() and iov_iter_zero()
> 
> On Thu, Oct 16, 2014 at 03:33:55PM +0200, Mathieu Desnoyers wrote:
> > > +static size_t copy_to_iter_iovec(void *from, size_t bytes, struct
> > > iov_iter *i)
> > > +{
> [...]
> > > +	left = __copy_to_user(buf, from, copy);
> > 
> > How comes this function uses __copy_to_user without any access_ok()
> > check ? This has security implications.
> 
> The access_ok() check is done higher up the call-chain if it's appropriate.
> These functions can be (intentionally) called to access kernel addresses,
> so it wouldn't be appropriate to do that here.

If the access_ok() are expected to be already done higher in the call-chain,
we might want to rename e.g. copy_to_iter_iovec to
__copy_to_iter_iovec(). It helps clarifying the check expectations for the
caller.

> 
> > > +static size_t copy_page_to_iter_bvec(struct page *page, size_t offset,
> > > +					size_t bytes, struct iov_iter *i)
> > > +{
> > > +	void *kaddr = kmap_atomic(page);
> > > +	size_t wanted = copy_to_iter_bvec(kaddr + offset, bytes, i);
> > 
> > missing newline.
> > 
> > > +	kunmap_atomic(kaddr);
> > > +	return wanted;
> > > +}
> 
> Are you seriously suggesting that:
> 
> static size_t copy_page_to_iter_bvec(struct page *page, size_t offset,
>                                         size_t bytes, struct iov_iter *i)
> {
>         void *kaddr = kmap_atomic(page);
>         size_t wanted = copy_to_iter_bvec(kaddr + offset, bytes, i);
> 
>         kunmap_atomic(kaddr);
>         return wanted;
> }
> 
> is more readable than without the newline?  I can see the point of the
> rule for functions with a lot of variables, or a lot of lines, but I
> don't see the point of it for such a small function.

I usually find it easier to read when variables and code are split,
but I don't feel strongly about this in this particular case.

> 
> In any case, this patch is now upstream, so I shan't be proposing any
> stylistic changes for it.

The leading __ prefix before the function names appears to be important
enough though, since it allows future changes of this code to take into
account the specific check expectations of those functions.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
