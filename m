Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaBQWoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:44:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56906 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaBQWox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:44:53 -0500
Message-ID: <530290DF.1060008@infradead.org>
Date: Mon, 17 Feb 2014 14:44:47 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-bcache@vger.kernel.org
Subject: Re: New bcache compiler warning (was: Re: bcache: Minor fixes from
 kbuild robot)
References: <CAMuHMdUYZLv4X3VBEOgcf+Dr22Pi1xWx-6oMPX7usBk6HJHTMw@mail.gmail.com> <530279EC.5010605@infradead.org> <CAMuHMdUnCdEoyD+seYXJD+e4bED9=ceUCC7NYsoRa1_vc3g4Hw@mail.gmail.com> <20140217214553.GB11655@kmo>
In-Reply-To: <20140217214553.GB11655@kmo>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 01:45 PM, Kent Overstreet wrote:
> On Mon, Feb 17, 2014 at 10:11:51PM +0100, Geert Uytterhoeven wrote:
>> On Mon, Feb 17, 2014 at 10:06 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
>>> On 02/17/2014 01:00 PM, Geert Uytterhoeven wrote:
>>>> On Fri, Feb 14, 2014 at 8:04 PM, Linux Kernel Mailing List
>>>> <linux-kernel@vger.kernel.org> wrote:
>>>>>    bcache: Minor fixes from kbuild robot
>>>>
>>>>> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
>>>>> index 4f6b594..3f74b4b 100644
>>>>> --- a/drivers/md/bcache/bset.c
>>>>> +++ b/drivers/md/bcache/bset.c
>>>>> @@ -23,7 +23,7 @@ void bch_dump_bset(struct btree_keys *b, struct bset *i, unsigned set)
>>>>>         for (k = i->start; k < bset_bkey_last(i); k = next) {
>>>>>                 next = bkey_next(k);
>>>>>
>>>>> -               printk(KERN_ERR "block %u key %zi/%u: ", set,
>>>>> +               printk(KERN_ERR "block %u key %li/%u: ", set,
>>>>>                        (uint64_t *) k - i->d, i->keys);
>>>>>
>>>>>                 if (b->ops->key_dump)
>>>>
>>>> On 32-bit (m68k):
>>>> drivers/md/bcache/bset.c: In function ‘bch_dump_bset’:
>>>> drivers/md/bcache/bset.c:27: warning: format ‘%li’ expects type ‘long
>>>> int’, but argument 3 has type ‘int’
>>>>
>>>> What are you trying to print here? It looks a bit strange to me.
>>>> Technically, the difference between two pointers is of type ptrdiff_.
>>>> The kernel had
>>>>
>>>> typedef __kernel_ptrdiff_t      ptrdiff_t;
>>>>
>>>> and
>>>>
>>>> #if __BITS_PER_LONG != 64
>>>> typedef unsigned int    __kernel_size_t;
>>>> typedef int             __kernel_ssize_t;
>>>> typedef int             __kernel_ptrdiff_t;
>>>> #else
>>>> typedef __kernel_ulong_t __kernel_size_t;
>>>> typedef __kernel_long_t __kernel_ssize_t;
>>>> typedef __kernel_long_t __kernel_ptrdiff_t;
>>>> #endif
>>>>
>>>> So I'd expect "%zi" to be the right way, and a quick test compile on
>>>> 32-bit (m68k)
>>>> and 64-bit (amd64) comfirms that. What was wrong with it?
>>>
>>> The kernel supports 't' (%t) for ptrdiff_t (same as glibc),
>>> so %ti should work (or %tu).
>>
>> Yes, that compiles without warnings, too.
>>
>> And after more decyphering, "(uint64_t *) k - i->d" seems to be positive,
>> so "%tu" should be OK.
> 
> *swears* Actually, I'm just going to cast this to unsigned (that's definitely
> safe here):
> 
> 
> commit 70bc49d421c793f73a772ae1f50622a39c6136d9
> Author: Kent Overstreet <kmo@daterainc.com>
> Date:   Mon Feb 17 13:44:06 2014 -0800
> 
>     bcache: Fix another compiler warning on m68k
>     
>     Use a bigger hammer this time
>     
>     Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> 
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 3f74b4b074..5454164153 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -23,8 +23,8 @@ void bch_dump_bset(struct btree_keys *b, struct bset *i, unsigned set)
>  	for (k = i->start; k < bset_bkey_last(i); k = next) {
>  		next = bkey_next(k);
>  
> -		printk(KERN_ERR "block %u key %li/%u: ", set,
> -		       (uint64_t *) k - i->d, i->keys);
> +		printk(KERN_ERR "block %u key %u/%u: ", set,
> +		       (unsigned) ((u64 *) k - i->d), i->keys);
>  
>  		if (b->ops->key_dump)
>  			b->ops->key_dump(b, k);
> 

Could that cause a truncation?  unsigned means unsigned int.
Can unsigned int be smaller (fewer bits) than the k pointer?
If so, is that OK or a problem?

-- 
~Randy
