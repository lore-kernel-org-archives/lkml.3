Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaA1VJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:09:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaA1VJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:09:12 -0500
Date: Tue, 28 Jan 2014 13:09:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: readahead: fix do_readahead for no readpage(s)
Message-Id: <20140128130910.925240fae4cd8b44238178e2@linux-foundation.org>
In-Reply-To: <20140128210126.GA27556@node.dhcp.inet.fi>
References: <1390907659-11675-1-git-send-email-mark.rutland@arm.com>
	<20140128120301.581c90caeb1c49e346b6aa66@linux-foundation.org>
	<20140128210126.GA27556@node.dhcp.inet.fi>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 23:01:26 +0200 "Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Tue, Jan 28, 2014 at 12:03:01PM -0800, Andrew Morton wrote:
> > On Tue, 28 Jan 2014 11:14:19 +0000 Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > > Commit 63d0f0a3c7e1 (mm/readahead.c:do_readhead(): don't check for
> > > ->readpage) unintentionally made do_readahead return 0 for all valid
> > > files regardless of whether readahead was supported, rather than the
> > > expected -EINVAL. This gets forwarded on to userspace, and results in
> > > sys_readahead appearing to succeed in cases that don't make sense (e.g.
> > > when called on pipes or sockets). This issue is detected by the LTP
> > > readahead01 testcase.
> > 
> > How can this be?
> > 
> > : static ssize_t
> > : do_readahead(struct address_space *mapping, struct file *filp,
> > : 	     pgoff_t index, unsigned long nr)
> > : {
> > : 	if (!mapping || !mapping->a_ops)
> > : 		return -EINVAL;
> > : 
> > : 	return force_page_cache_readahead(mapping, filp, index, nr);
> 
> It's not what we have in Linus' tree. force_page_cache_readahead() return
> code is unused:
> 
> 	force_page_cache_readahead(mapping, filp, index, nr);
> 	return 0;
> 

ah, oops, I was looking at the code with Mark's patch applied.

Yes, the force_page_cache_readahead() return value should be propagated.

And I guess the lobotomising of the force_page_cache_readahead() return
value is OK.  force_page_cache_readahead() presently returns an errno
even if it has performed some reads.  A read()-style function shouldn't
do that - it should return a short read in that case.

