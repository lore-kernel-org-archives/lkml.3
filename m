Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaEDVTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 17:19:10 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:48362 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaEDVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 17:19:09 -0400
MIME-Version: 1.0
In-Reply-To: <5366A63F.9030401@nod.at>
References: <alpine.LSU.2.11.1404161239320.6778@eggly.anvils>
	<1399160247-32093-1-git-send-email-richard@nod.at>
	<CA+55aFzbSUPGWyO42KM7geAy8WrP8e=q+KoqdOBY68zay0jrZA@mail.gmail.com>
	<5365FB8A.8080303@nod.at>
	<CA+55aFw9SLeE1fv1-nKMeB7o0YAFZ85mskYy_izCb7Nh3AiicQ@mail.gmail.com>
	<5366A63F.9030401@nod.at>
Date: Sun, 4 May 2014 14:19:08 -0700
X-Google-Sender-Auth: VkRVcmXRH9jxOVTfZNXxCcRCq0E
Message-ID: <CA+55aFwcKfyuyMNV37c_JT00039P_VgmOXU_u3gm_RnUR=LGdQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Fix force_flush behavior in zap_pte_range()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2014 at 1:42 PM, Richard Weinberger <richard@nod.at> wrote:
>
> I cannot tell why UML has it's own tlb gather logic, I suspect nobody
> cared so far to clean up the code.
> That said, I've converted it today to the generic gather logic and it works.
> Sadly I'm still facing the same issues (sigh!).

Ok, so it's not the gathering.

I'm guessing it's because the tlb flush patterns change (we now flush
partial areas for shared mappings with dirty pages - it used to be
that you'd only ever see full ranges before), and that shows some
issue with the whole "fix_range()" thing. So then the kill(9) results
in stopping the page table zapping in the middle, and then you end up
with that "Bad rss-counter" for the file mapping.

Can you try to debug it to see where that "ret" gets set in
fix_range_common() (well, likely deeper, I presume it comes from
update_pte_range() or whatever), to see exactly _what_ it is that
starts failing?

           Linus
