Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3JCR62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:58:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43341 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3JCR6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:58:25 -0400
Date: Thu, 3 Oct 2013 18:58:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH] fs: make sure we do not read beyond allocation
Message-ID: <20131003175824.GH13318@ZenIV.linux.org.uk>
References: <20131003163411.GA17101@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003163411.GA17101@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 09:34:11AM -0700, Kees Cook wrote:
> In dentry_string_cmp (via__d_lookup_rcu), when CONFIG_DCACHE_WORD_ACCESS
> is set, word-width memory reads are performed. However, the string
> allocation size may not be a multiple of the word size. To avoid reading
> past the end of such an allocation, we must allocate in multiples of
> the word size.

grep ^kmalloc /proc/slabinfo.  Observe the suffix after "kmalloc-"...

IOW, kmalloc() does round its argument up.  Seeing that we allocate an
external name only when allocation has to be longer than 32 bytes, the
sucker is guaranteed to be at least a multiple of 32 by the time we
pick the fitting cache (the worst case is when length is between 65
and 96; then we use kmalloc-96).

When you start a port to a 512-bit architecture, you'll have much nastier
problems than this one...
