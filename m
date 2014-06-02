Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaFBVRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 17:17:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaFBVQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 17:16:59 -0400
Date: Mon, 2 Jun 2014 14:16:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] replace PAGECACHE_TAG_* definition with enumeration
Message-Id: <20140602141657.68f831156b45251b0684b441@linux-foundation.org>
In-Reply-To: <538CA269.6010300@intel.com>
References: <20140521193336.5df90456.akpm@linux-foundation.org>
	<1401686699-9723-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1401686699-9723-2-git-send-email-n-horiguchi@ah.jp.nec.com>
	<538CA269.6010300@intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jun 2014 09:12:25 -0700 Dave Hansen <dave.hansen@intel.com> wrote:

> On 06/01/2014 10:24 PM, Naoya Horiguchi wrote:
> > -#define PAGECACHE_TAG_DIRTY	0
> > -#define PAGECACHE_TAG_WRITEBACK	1
> > -#define PAGECACHE_TAG_TOWRITE	2
> > +enum {
> > +	PAGECACHE_TAG_DIRTY,
> > +	PAGECACHE_TAG_WRITEBACK,
> > +	PAGECACHE_TAG_TOWRITE,
> > +	__NR_PAGECACHE_TAGS,
> > +};
> 
> Doesn't this end up exposing kernel-internal values out to a userspace
> interface?  Wouldn't that lock these values in to the ABI?

Yes, we should be careful here.  We should not do anything which
constrains future kernel code or which causes any form of
compatibility/migration issues.

I wonder if we can do something smart with the interface.  For example
when userspace calls sys_fincore() it must explicitly ask for
PAGECACHE_TAG_DIRTY and if some future kernel doesn't implement
PAGECACHE_TAG_DIRTY, it can return -EINVAL.

Or maybe it can succeed, but tells userspace "you didn't get
PAGECACHE_TAG_DIRTY".

<thinking out loud>

So userspace sends a mask of bits which select what fields it wants. 
The kernel returns a mask of bits which tell userspace what it actually
received.

Or something like that - you get the idea ;)

