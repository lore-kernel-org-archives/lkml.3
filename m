Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaBQUYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:24:10 -0500
Received: from mail-ve0-f169.google.com ([209.85.128.169]:36114 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaBQUYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:24:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140217194955.GA30908@node.dhcp.inet.fi>
References: <1392662333-25470-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CA+55aFwz+36NOk=uanDvii7zn46-s1kpMT1Lt=C0hhhn9v6w-Q@mail.gmail.com>
	<20140217194955.GA30908@node.dhcp.inet.fi>
Date: Mon, 17 Feb 2014 12:24:04 -0800
X-Google-Sender-Auth: _7PwvCjTPyh4RTgO0CE51UiJrWM
Message-ID: <CA+55aFwSDxzvR=zWn=OtNmg5cYKaj8DzFTm+16xiHLKKR0xhWQ@mail.gmail.com>
Subject: Re: [RFC, PATCHv2 0/2] mm: map few pages around fault address if they
 are in page cache
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 11:49 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
>
> But it could be safer to keep locking in place and reduce lookup cost by
> exposing something like ->fault_iter_init() and ->fault_iter_next(). It
> will still return one page a time, but it will keep radix-tree context
> around for cheaper next-page lookup.

I really would prefer for the loop to be much smaller than that, and
not contain indirect calls to helpers that pretty much guarantee that
you can't generate nice code.

Plus I'd rather not have the mm layer know too much about the radix
tree iterations anyway, and try to use the existing page array
functions we already have (ie "find_get_pages()").

So I'd really prefer if we can do this with tight loops over explicit
pages, rather than some loop over an iterator.

              Linus
