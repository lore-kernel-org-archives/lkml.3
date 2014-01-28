Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaA1UDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:03:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaA1UDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:03:03 -0500
Date: Tue, 28 Jan 2014 12:03:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: readahead: fix do_readahead for no readpage(s)
Message-Id: <20140128120301.581c90caeb1c49e346b6aa66@linux-foundation.org>
In-Reply-To: <1390907659-11675-1-git-send-email-mark.rutland@arm.com>
References: <1390907659-11675-1-git-send-email-mark.rutland@arm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014 11:14:19 +0000 Mark Rutland <mark.rutland@arm.com> wrote:

> Commit 63d0f0a3c7e1 (mm/readahead.c:do_readhead(): don't check for
> ->readpage) unintentionally made do_readahead return 0 for all valid
> files regardless of whether readahead was supported, rather than the
> expected -EINVAL. This gets forwarded on to userspace, and results in
> sys_readahead appearing to succeed in cases that don't make sense (e.g.
> when called on pipes or sockets). This issue is detected by the LTP
> readahead01 testcase.

How can this be?

: static ssize_t
: do_readahead(struct address_space *mapping, struct file *filp,
: 	     pgoff_t index, unsigned long nr)
: {
: 	if (!mapping || !mapping->a_ops)
: 		return -EINVAL;
: 
: 	return force_page_cache_readahead(mapping, filp, index, nr);
: }

and

: int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
: 		pgoff_t offset, unsigned long nr_to_read)
: {
: 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
: 		return -EINVAL;

Clearly, do_readahead() will return -EINVAL if neither ->readpage or
->readpages are implemented.

I can see that the behaviour would change if the address_space
implements only one of ->readpage and ->readpages, but that doesn't
appear to match your description and the new behaviour is correct - we
can now perform readahead for address_spaces which implement
->readpages and not ->readpage (which would be odd and might not work
for other reasons..).
