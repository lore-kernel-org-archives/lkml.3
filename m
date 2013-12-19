Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3LSTTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:19:17 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63285 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3LSTTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:19:16 -0500
MIME-Version: 1.0
In-Reply-To: <20131219182920.GG30640@kvack.org>
References: <20131219040738.GA10316@redhat.com>
	<CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
	<20131219155313.GA25771@redhat.com>
	<CA+55aFyoXCDNfHb+r5b=CgKQLPA1wrU_Tmh4ROZNEt5TPjpODA@mail.gmail.com>
	<20131219181134.GC25385@kmo-pixel>
	<20131219182920.GG30640@kvack.org>
Date: Fri, 20 Dec 2013 04:19:15 +0900
X-Google-Sender-Auth: _t8mNB4zC0elqR92HxyQ9pBLi0g
Message-ID: <CA+55aFzCo_r7ZGHk+zqUjmCW2w7-7z9oxEJjhR66tZ4qZPxnvw@mail.gmail.com>
Subject: Re: bad page state in 3.13-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <kmo@daterainc.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 10:29 AM, Benjamin LaHaise <bcrl@kvack.org> wrote:
>
>> I don't understand this page migration stuff at all, and I actually
>> don't think I understand the refcounting w.r.t. the page cache either.
>> But looking at (say) the aio_free_ring() call at line 409 - we just did
>> one put_page() in aio_setup_ring(), and then _another_ put_page() in
>> aio_free_ring()... ok, one of those corresponds to the get
>> get_user_pages() did, but what's the other correspond to?
>
> The second put_page() should be dropping the page from the page cache.
> Perhaps it would be better to rely on a truncate of the file to remove the
> pages from the page cache.

Yeah, that looks horribly buggy, if that's the intent.

You can't just put_page() to remove something from the page cache. You
need to do the whole "remove from radix tree" rigamarole, see for
example delete_from_page_cache(). And you can't even do that blindly,
because if the page is under writeback or otherwise busy, just
removing it from the page cache and freeing it is wrong too.

                 Linus
