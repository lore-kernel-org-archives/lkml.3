Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbaGOGJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 02:09:00 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39942 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaGOGI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 02:08:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140715061219.GK11317@js1304-P5Q-DELUXE>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-21-git-send-email-a.ryabinin@samsung.com> <20140715061219.GK11317@js1304-P5Q-DELUXE>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 15 Jul 2014 10:08:35 +0400
Message-ID: <CACT4Y+ZdVN_gUKQr9Gz+nKv4M3zJHL1F0C4Awc4rg9xi3bVyiw@mail.gmail.com>
Subject: Re: [RFC/PATCH RESEND -next 20/21] fs: dcache: manually unpoison
 dname after allocation to shut up kasan's reports
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:12 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> On Wed, Jul 09, 2014 at 03:30:14PM +0400, Andrey Ryabinin wrote:
>> We need to manually unpoison rounded up allocation size for dname
>> to avoid kasan's reports in __d_lookup_rcu.
>> __d_lookup_rcu may validly read a little beyound allocated size.
>
> If it read a little beyond allocated size, IMHO, it is better to
> allocate correct size.
>
> kmalloc(name->len + 1, GFP_KERNEL); -->
> kmalloc(roundup(name->len + 1, sizeof(unsigned long ), GFP_KERNEL);
>
> Isn't it?


I absolutely agree!


> Thanks.
>
>>
>> Reported-by: Dmitry Vyukov <dvyukov@google.com>
>> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
>> ---
>>  fs/dcache.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index b7e8b20..dff64f2 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c
>> @@ -38,6 +38,7 @@
>>  #include <linux/prefetch.h>
>>  #include <linux/ratelimit.h>
>>  #include <linux/list_lru.h>
>> +#include <linux/kasan.h>
>>  #include "internal.h"
>>  #include "mount.h"
>>
>> @@ -1412,6 +1413,8 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
>>                       kmem_cache_free(dentry_cache, dentry);
>>                       return NULL;
>>               }
>> +             unpoison_shadow(dname,
>> +                             roundup(name->len + 1, sizeof(unsigned long)));
>>       } else  {
>>               dname = dentry->d_iname;
>>       }
>> --
>> 1.8.5.5
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
