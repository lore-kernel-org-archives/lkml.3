Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764AbaD1X5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:57:08 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:59314 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554AbaD1X5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:57:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140428161120.4cad719dc321e3c837db3fd6@linux-foundation.org>
References: <535EA976.1080402@linux.vnet.ibm.com>
	<CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com>
	<CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com>
	<1398724754.25549.35.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFz0jrk-O9gq9VQrFBeWTpLt_5zPt9RsJO9htrqh+nKTfA@mail.gmail.com>
	<20140428161120.4cad719dc321e3c837db3fd6@linux-foundation.org>
Date: Mon, 28 Apr 2014 16:57:04 -0700
X-Google-Sender-Auth: i8PfMwlRtdBIAhtTTpWLVqSmMqU
Message-ID: <CA+55aFwLSW3V76Y_O37Y8r_yaKQ+y0VMk=6SEEBpeFfGzsJUKA@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at mm/vmacache.c:85!
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 4:11 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> unuse_mm() leaves current->mm at NULL so we'd hear about it pretty
> quickly if a user task was running use_mm/unuse_mm.

Yes.

> I think so.  Maybe it's time to cook up a debug patch for Srivatsa to
> use?  Dump the vma cache when the bug hits, or wire up some trace
> points.  Or perhaps plain old printks - it seems to be happening pretty
> early in boot.

Well, I think Srivatsa has only seen it once, and wasn't able to
reproduce it, so we'd have to make it happen more first.

> Are there additional sanity checks we can perform at cache addition
> time?

I wouldn't really expect it to happen at cache addition time, since
that's really quite simple. There's only one caller of
vmacache_update(), namely find_vma(). And vmacache_update() does the
same sanity check that vmacache lookup does (ie check that the
passed-on mm is the current thread mm, and that we're not a kernel
thread).

I'd be more inclined to think it's a missing invalidate, but I can
only think of two reasons to invalidate:

 - the vma itself went away from the mm, got free'd/reused, and so
vm_mm changes..

   But then we'd have to remove it from the rb-tree, and both callers
of vma_rb_erase() do a vmacache_invalidate()

 - the mm of a thread changed

   This is exec, use_mm(), and fork() (and fork really only just
because we copy the vmacache).

   exec and fork do that "vmacache_flush(tsk)", which is why I was
looking at use_mm().

So it all looks sane. Which only means that I must obviously be
missing some case. Which case am I missing?

                  Linus
