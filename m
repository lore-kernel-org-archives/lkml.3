Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaFFS0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:26:16 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:49323 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaFFS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:26:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140606174317.GA1741@redhat.com>
References: <20140606174317.GA1741@redhat.com>
Date: Fri, 6 Jun 2014 11:26:14 -0700
X-Google-Sender-Auth: C_I_jsTmgyUSt0FDTZ2P549AiQ4
Message-ID: <CA+55aFxiOsceOsm7zYyvFAxDF3=gxUXj=_61Nce3VkELfJr7cg@mail.gmail.com>
Subject: Re: 3.15-rc8 oops in copy_page_rep after page fault.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 10:43 AM, Dave Jones <davej@redhat.com> wrote:
>
> RIP: 0010:[<ffffffff8b3287b5>]  [<ffffffff8b3287b5>] copy_page_rep+0x5/0x10

Ok, it's the first iteration of "rep movsq" (%rcx is still 0x200) for
copying a page, and the pages are

  RSI: ffff880052766000
  RDI: ffff880014efe000

which both look like reasonable kernel addresses. So I'm assuming it's
DEBUG_PAGEALLOC that makes this trigger, and since the error code is
0, and the CR2 value matches RSI, it's the source page that seems to
have been freed.

And I see absolutely _zero_ reason for wht your 64k mmap_min_addr
should make any difference what-so-ever. That's just odd.

Anyway, can you try to figure out _which_ copy_user_highpage() it is
(by looking at what is around the call-site at
"handle_mm_fault+0x1e0". The fact that we have a stale
do_huge_pmd_wp_page() on the stack makes me suspect that we have hit
that VM_FAULT_FALLBACK case and this is related to splitting. Adding a
few more people explicitly to the cc in case anybody sees anything
(original email on lkml and linux-mm for context, guys).

            Linus
