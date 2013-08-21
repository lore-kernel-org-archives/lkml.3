Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3HUJic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:38:32 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:63375 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3HUJi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130812024556.GB29956@sanechka.spb.ru>
References: <20130812024556.GB29956@sanechka.spb.ru>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 21 Aug 2013 10:38:08 +0100
X-Google-Sender-Auth: a3cVbjciwB60peiApRjZaLJGcJM
Message-ID: <CAHkRjk4y06puTL_Gq5RbpoV+kpEp+k32z5aq3HpEu9u3qsS_Aw@mail.gmail.com>
Subject: Re: kmemleak in apei_res_add
To: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 August 2013 03:45, Alexandra N. Kossovsky
<Alexandra.Kossovsky@oktetlabs.ru> wrote:
> When running 3.10.3 with kmemleak enabled, I see following warnings from
> kmemleak:
>
> unreferenced object 0xffff88024d2219a0 (size 32):
>   comm "swapper/0", pid 1, jiffies 4294894532 (age 26865.180s)
>   hex dump (first 32 bytes):
>     58 de 0c 73 02 88 ff ff 58 de 0c 73 02 88 ff ff  X..s....X..s....
>     18 50 fd 7d 00 00 00 00 3f 50 fd 7d 00 00 00 00  .P.}....?P.}....
>   backtrace:
>     [<ffffffff813ddf40>] kmemleak_alloc+0x21/0x3e
>     [<ffffffff8111cb99>] kmemleak_alloc_recursive.constprop.58+0x16/0x18
>     [<ffffffff8111efac>] kmem_cache_alloc_trace+0xe6/0x12f
>     [<ffffffff81278f0e>] apei_res_add+0xb9/0xe8
>     [<ffffffff81278faa>] collect_res_callback+0x6d/0x7c
>     [<ffffffff812788ed>] apei_exec_for_each_entry+0x78/0x93
>     [<ffffffff8127891d>] apei_exec_collect_resources+0x15/0x17
>     [<ffffffff81b010e5>] erst_init+0x278/0x2a3
>     [<ffffffff810020b5>] do_one_initcall+0x7b/0x116
>     [<ffffffff81ac9ee7>] kernel_init_freeable+0x13f/0x1cc
>     [<ffffffff813db19f>] kernel_init+0x9/0xd6
>     [<ffffffff813fe5bc>] ret_from_fork+0x7c/0xb0
>     [<ffffffffffffffff>] 0xffffffffffffffff

Are there any "APEI:" errors in the kernel log? It could be some
freeing missing on an error path.

apei_res_add() allocates struct apei_res objects and places them on
the erst_resources.{iomem,ioport} list heads as given by erst_init().
The erst_resources is just a local variable on the erst_init() stack,
hence kmemleak doesn't have any trace of the allocated objects.

It looks like erst_init() calls apei_resources_request() which should
merge the local erst_resources list heads with the global
apei_resources_all but for whatever reason, this or any of the
previous calls in erst_init() fail and we don't get the merging. Some
of the goto err_fini in this function should probably be err_release.
I cc'ed Huang as the driver author.

-- 
Catalin
