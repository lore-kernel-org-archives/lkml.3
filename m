Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3L2Ltu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 06:49:50 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:44087 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3L2Ltt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 06:49:49 -0500
MIME-Version: 1.0
In-Reply-To: <52BE2E74.1070107@huawei.com>
References: <1388137619-14741-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<52BE2E74.1070107@huawei.com>
Date: Sun, 29 Dec 2013 13:49:48 +0200
X-Google-Sender-Auth: nSD29P9lvik-ELqCOg_zy2m42ZA
Message-ID: <CAOJsxLFH5LGuF+vutPzB90EM9o376Jc99-rjY4qq18d1KQshhg@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: fix accumulate per cpu partial cache objects
From: Pekka Enberg <penberg@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 28, 2013 at 3:50 AM, Li Zefan <lizefan@huawei.com> wrote:
> On 2013/12/27 17:46, Wanpeng Li wrote:
>> SLUB per cpu partial cache is a list of slab caches to accelerate objects
>> allocation. However, current codes just accumulate the objects number of
>> the first slab cache of per cpu partial cache instead of traverse the whole
>> list.
>>
>> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
>> ---
>>  mm/slub.c |   32 +++++++++++++++++++++++---------
>>  1 files changed, 23 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 545a170..799bfdc 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -4280,7 +4280,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
>>                       struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab,
>>                                                              cpu);
>>                       int node;
>> -                     struct page *page;
>> +                     struct page *page, *p;
>>
>>                       page = ACCESS_ONCE(c->page);
>>                       if (!page)
>> @@ -4298,8 +4298,9 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
>>                       nodes[node] += x;
>>
>>                       page = ACCESS_ONCE(c->partial);
>> -                     if (page) {
>> -                             x = page->pobjects;
>> +                     while ((p = page)) {
>> +                             page = p->next;
>> +                             x = p->pobjects;
>>                               total += x;
>>                               nodes[node] += x;
>>                       }
>
> Can we apply this patch first? It was sent month ago, but Pekka was not responsive.

Applied. Wanpeng, care to resend your patch?
