Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbaIZRKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:10:23 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:34281 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaIZRKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:10:22 -0400
MIME-Version: 1.0
In-Reply-To: <1411562649-28231-12-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com> <1411562649-28231-12-git-send-email-a.ryabinin@samsung.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Fri, 26 Sep 2014 10:10:01 -0700
Message-ID: <CACT4Y+aJ9htaruQ1Nn7+MSGwtNzRb_hfytQo98J1wq5N6oh1BA@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] kmemleak: disable kasan instrumentation for kmemleak
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

We can disable kasan instrumentation of this file as well.

On Wed, Sep 24, 2014 at 5:44 AM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> kmalloc internally round up allocation size, and kmemleak
> uses rounded up size as object's size. This makes kasan
> to complain while kmemleak scans memory or calculates of object's
> checksum. The simplest solution here is to disable kasan.
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  mm/kmemleak.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 3cda50c..9bda1b3 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -98,6 +98,7 @@
>  #include <asm/processor.h>
>  #include <linux/atomic.h>
>
> +#include <linux/kasan.h>
>  #include <linux/kmemcheck.h>
>  #include <linux/kmemleak.h>
>  #include <linux/memory_hotplug.h>
> @@ -1113,7 +1114,10 @@ static bool update_checksum(struct kmemleak_object *object)
>         if (!kmemcheck_is_obj_initialized(object->pointer, object->size))
>                 return false;
>
> +       kasan_disable_local();
>         object->checksum = crc32(0, (void *)object->pointer, object->size);
> +       kasan_enable_local();
> +
>         return object->checksum != old_csum;
>  }
>
> @@ -1164,7 +1168,9 @@ static void scan_block(void *_start, void *_end,
>                                                   BYTES_PER_POINTER))
>                         continue;
>
> +               kasan_disable_local();
>                 pointer = *ptr;
> +               kasan_enable_local();
>
>                 object = find_and_get_object(pointer, 1);
>                 if (!object)
> --
> 2.1.1
>
