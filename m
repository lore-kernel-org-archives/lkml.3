Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3LSEkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 23:40:10 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:41545 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab3LSEkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 23:40:08 -0500
MIME-Version: 1.0
In-Reply-To: <20131219040738.GA10316@redhat.com>
References: <20131219040738.GA10316@redhat.com>
Date: Wed, 18 Dec 2013 20:40:07 -0800
X-Google-Sender-Auth: o4_C_Y_jL7aEIHc8KT7DKpEmIes
Message-ID: <CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
Subject: Re: bad page state in 3.13-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Christoph Lameter <cl@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 8:07 PM, Dave Jones <davej@redhat.com> wrote:
> Just hit this while fuzzing with lots of child processes.
> (trinity -C128)

Ok, there's a BUG_ON() in the middle, the "bad page" part is just this:

> BUG: Bad page state in process trinity-c93  pfn:100499
> page:ffffea0004012640 count:0 mapcount:0 mapping:          (null) index:0x389
> page flags: 0x2000000000000c(referenced|uptodate)
> Call Trace:
>  [<ffffffff816db2f5>] dump_stack+0x4e/0x7a
>  [<ffffffff816d8b05>] bad_page.part.71+0xcf/0xe8
>  [<ffffffff8113a645>] free_pages_prepare+0x185/0x190
>  [<ffffffff8113b085>] free_hot_cold_page+0x35/0x180
>  [<ffffffff811403f3>] __put_single_page+0x23/0x30
>  [<ffffffff81140665>] put_page+0x35/0x50
>  [<ffffffff811e8705>] aio_free_ring+0x55/0xf0
>  [<ffffffff811e9c5a>] SyS_io_setup+0x59a/0xbe0
>  [<ffffffff816edb24>] tracesys+0xdd/0xe2

at free_pages() time, and I don't see anything bad in the printout wrt
the page counts of flags.

Which makes me wonder if this is mem_cgroup_bad_page_check()
triggering. Of course, if it's a race, it may be that by the time we
print out the counts they all look good, even if they weren't good at
the time we did that bad_page() *check*.

And the fact that we do have a concurrent BUG_ON() triggering with a
zero page count obviously does look suspicious. Looks like a possible
race with memory compaction happening at the same time aio_free_ring()
frees the page.

Somebody who knows the migration code needs to look at this. ChristophL?

                        Linus
