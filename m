Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964793AbaGBU02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:26:28 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38220 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaGBU00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <1404332484.596.98.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>
	<2ca2519809a1c99c061ebdb960f83614b72b0c59.1404245510.git.d.kasatkin@samsung.com>
	<1404332484.596.98.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Wed, 2 Jul 2014 23:26:24 +0300
Message-ID: <CACE9dm8aoKiVqxoom=VC+tyz9b-TO0Uzpsc-mouAU1STQVwkGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ima: introduce multi-page collect buffers
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 July 2014 23:21, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Tue, 2014-07-01 at 23:12 +0300, Dmitry Kasatkin wrote:
>> Use of multiple-page collect buffers reduces:
>> 1) the number of block IO requests
>> 2) the number of asynchronous hash update requests
>>
>> Second is important for HW accelerated hashing, because significant
>> amount of time is spent for preparation of hash update operation,
>> which includes configuring acceleration HW, DMA engine, etc...
>> Thus, HW accelerators are more efficient when working on large
>> chunks of data.
>>
>> This patch introduces usage of multi-page collect buffers. Buffer size
>> can be specified by providing additional option to the 'ima_ahash='
>> kernel parameter. 'ima_ahash=2048,16384' specifies that minimal file
>> size to use ahash is 2048 byes and buffer size is 16384 bytes.
>> Default buffer size is 4096 bytes.
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  Documentation/kernel-parameters.txt |  3 +-
>>  security/integrity/ima/ima_crypto.c | 85 ++++++++++++++++++++++++++++++++++---
>>  2 files changed, 81 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>> index b406f5c..529ba58 100644
>> --- a/Documentation/kernel-parameters.txt
>> +++ b/Documentation/kernel-parameters.txt
>> @@ -1292,9 +1292,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>>                       Set number of hash buckets for inode cache.
>>
>>       ima_ahash=      [IMA] Asynchronous hash usage parameters
>> -                     Format: <min_file_size>
>> +                     Format: <min_file_size>[,<bufsize>]
>>                       Set the minimal file size when use asynchronous hash.
>>                       If ima_ahash is not provided, ahash usage is disabled.
>> +                     bufsize - hashing buffer size. 4k if not specified.
>>
>>       ima_appraise=   [IMA] appraise integrity measurements
>>                       Format: { "off" | "enforce" | "fix" }
>> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
>> index 5eb19b4..41f2695 100644
>> --- a/security/integrity/ima/ima_crypto.c
>> +++ b/security/integrity/ima/ima_crypto.c
>> @@ -25,7 +25,6 @@
>>  #include <crypto/hash_info.h>
>>  #include "ima.h"
>>
>> -
>>  struct ahash_completion {
>>       struct completion completion;
>>       int err;
>> @@ -36,14 +35,24 @@ static struct crypto_ahash *ima_ahash_tfm;
>>
>>  /* minimal file size for ahash use */
>>  static loff_t ima_ahash_size;
>> +/* default is 0 - 1 page. */
>> +static int ima_max_order;
>>
>>  static int __init ima_ahash_setup(char *str)
>>  {
>> -     int rc;
>> +     int ints[3] = { 0, };
>> +
>> +     str = get_options(str, ARRAY_SIZE(ints), ints);
>> +     if (!ints[0])
>> +             return 0;
>> +
>> +     ima_ahash_size = ints[1];
>> +     ima_max_order = get_order(ints[2]);
>
> get_options() returns the number of options processed in ints[0].
> Before assigning ima_max_order, we normally check to see if it exists.
> I guess in this case it doesn't matter since it would return 0 anyway.
>
> Should there be any value checking here?  Should the values be some
> multiple of 1024?
>

It is a goo question. I was looking how get_options is used. Here as
ints initialized to 0, get_order returns the same value for anyhing
which is rounded up to PAGE_SIZE. So it works in all cases.

But if we now go to module param or sysctl, then this can be discarded?

Thanks for reviewing.


>>
>> -     rc = kstrtoll(str, 10, &ima_ahash_size);
>> +     pr_info("ima_ahash: minsize=%lld, bufsize=%lu\n",
>> +             ima_ahash_size, (PAGE_SIZE << ima_max_order));
>>
>> -     return !rc;
>> +     return 1;
>>  }
>>  __setup("ima_ahash=", ima_ahash_setup);
>>
>> @@ -166,6 +175,65 @@ static int ahash_wait(int err, struct ahash_completion *res)
>>       return err;
>>  }
>>
>> +/**
>> + * ima_alloc_pages() - Allocated contiguous pages.
>> + * @max_size:       Maximum amount of memory to allocate.
>> + * @allocated_size: Returned size of actual allocation.
>> + * @last_warn:      Should the min_size allocation warn or not.
>> + *
>> + * Tries to do opportunistic allocation for memory first trying to allocate
>> + * max_size amount of memory and then splitting that until zero order is
>> + * reached. Allocation is tried without generating allocation warnings unless
>> + * last_warn is set. Last_warn set affects only last allocation of zero order.
>> + *
>> + * Return pointer to allocated memory, or NULL on failure.
>> + */
>> +static void *ima_alloc_pages(loff_t max_size, size_t *allocated_size,
>> +                          int last_warn)
>> +{
>> +     void *ptr;
>> +     unsigned int order;
>> +     gfp_t gfp_mask = __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY;
>> +
>> +     order = min(get_order(max_size), ima_max_order);
>> +
>> +     for (; order; order--) {
>> +             ptr = (void *)__get_free_pages(gfp_mask, order);
>> +             if (ptr) {
>> +                     *allocated_size = PAGE_SIZE << order;
>> +                     return ptr;
>> +             }
>> +     }
>> +
>> +     /* order is zero - one page */
>> +
>> +     gfp_mask = GFP_KERNEL;
>> +
>> +     if (!last_warn)
>> +             gfp_mask |= __GFP_NOWARN;
>> +
>> +     ptr = (void *)__get_free_pages(gfp_mask, 0);
>> +     if (ptr) {
>> +             *allocated_size = PAGE_SIZE;
>> +             return ptr;
>> +     }
>> +
>> +     *allocated_size = 0;
>> +     return NULL;
>> +}
>> +
>> +/**
>> + * ima_free_pages() - Free pages allocated by ima_alloc_pages().
>> + * @ptr:  Pointer to allocated pages.
>> + * @size: Size of allocated buffer.
>> + */
>> +static void ima_free_pages(void *ptr, size_t size)
>> +{
>> +     if (!ptr)
>> +             return;
>> +     free_pages((unsigned long)ptr, get_order(size));
>> +}
>> +
>>  static int ima_calc_file_hash_atfm(struct file *file,
>>                                  struct ima_digest_data *hash,
>>                                  struct crypto_ahash *tfm)
>> @@ -176,6 +244,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
>>       struct ahash_request *req;
>>       struct scatterlist sg[1];
>>       struct ahash_completion res;
>> +     size_t rbuf_size;
>>
>>       hash->length = crypto_ahash_digestsize(tfm);
>>
>> @@ -197,7 +266,11 @@ static int ima_calc_file_hash_atfm(struct file *file,
>>       if (i_size == 0)
>>               goto out2;
>>
>> -     rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
>> +     /*
>> +      * Try to allocate maximum size of memory, fail if not even single
>> +      * page cannot be allocated.
>> +      */
>
> The comment is nice explanation, but might be unnecessary if there was a
> function comment.
>
> Mimi
>
>> +     rbuf = ima_alloc_pages(i_size, &rbuf_size, 1);
>>       if (!rbuf) {
>>               rc = -ENOMEM;
>>               goto out1;
>> @@ -226,7 +299,7 @@ static int ima_calc_file_hash_atfm(struct file *file,
>>       }
>>       if (read)
>>               file->f_mode &= ~FMODE_READ;
>> -     kfree(rbuf);
>> +     ima_free_pages(rbuf, rbuf_size);
>>  out2:
>>       if (!rc) {
>>               ahash_request_set_crypt(req, NULL, hash->digest, 0);
>
>



-- 
Thanks,
Dmitry
