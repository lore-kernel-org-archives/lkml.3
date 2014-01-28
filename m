Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaA1VBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:01:33 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:33948 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043AbaA1VBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:01:32 -0500
Date: Tue, 28 Jan 2014 23:01:26 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: readahead: fix do_readahead for no readpage(s)
Message-ID: <20140128210126.GA27556@node.dhcp.inet.fi>
References: <1390907659-11675-1-git-send-email-mark.rutland@arm.com>
 <20140128120301.581c90caeb1c49e346b6aa66@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128120301.581c90caeb1c49e346b6aa66@linux-foundation.org>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:03:01PM -0800, Andrew Morton wrote:
> On Tue, 28 Jan 2014 11:14:19 +0000 Mark Rutland <mark.rutland@arm.com> wrote:
> 
> > Commit 63d0f0a3c7e1 (mm/readahead.c:do_readhead(): don't check for
> > ->readpage) unintentionally made do_readahead return 0 for all valid
> > files regardless of whether readahead was supported, rather than the
> > expected -EINVAL. This gets forwarded on to userspace, and results in
> > sys_readahead appearing to succeed in cases that don't make sense (e.g.
> > when called on pipes or sockets). This issue is detected by the LTP
> > readahead01 testcase.
> 
> How can this be?
> 
> : static ssize_t
> : do_readahead(struct address_space *mapping, struct file *filp,
> : 	     pgoff_t index, unsigned long nr)
> : {
> : 	if (!mapping || !mapping->a_ops)
> : 		return -EINVAL;
> : 
> : 	return force_page_cache_readahead(mapping, filp, index, nr);

It's not what we have in Linus' tree. force_page_cache_readahead() return
code is unused:

	force_page_cache_readahead(mapping, filp, index, nr);
	return 0;

> : }
> 
> and
> 
> : int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
> : 		pgoff_t offset, unsigned long nr_to_read)
> : {
> : 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
> : 		return -EINVAL;
> 
> Clearly, do_readahead() will return -EINVAL if neither ->readpage or
> ->readpages are implemented.
> 
> I can see that the behaviour would change if the address_space
> implements only one of ->readpage and ->readpages, but that doesn't
> appear to match your description and the new behaviour is correct - we
> can now perform readahead for address_spaces which implement
> ->readpages and not ->readpage (which would be odd and might not work
> for other reasons..).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
