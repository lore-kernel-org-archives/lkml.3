Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3GGP66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 11:58:58 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:47057 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3GGP65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 11:58:57 -0400
Message-ID: <51D9903D.5090308@kernel.org>
Date: Sun, 07 Jul 2013 18:58:53 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, cl@linux.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
References: <201305071938.DAC81273.HOSJOFFOQLtMFV@I-love.SAKURA.ne.jp> <0000013e7f651028-9a57bc30-4148-4aba-a0e6-737b83bf2458-000000@email.amazonses.com> <20130701130903.61459f57f4ba31e282065001@linux-foundation.org> <201307020645.JGI86434.FFHOLOSFOtJVMQ@I-love.SAKURA.ne.jp> <20130701145356.f9c43875890d1aec90fe1ad9@linux-foundation.org> <201307022149.HEB90128.QFJFHOLMVtFSOO@I-love.SAKURA.ne.jp> <20130702121210.121c8e2df7745994174c53e1@linux-foundation.org>
In-Reply-To: <20130702121210.121c8e2df7745994174c53e1@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/13 10:12 PM, Andrew Morton wrote:
> On Tue, 2 Jul 2013 21:49:26 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
>
>> Some architectures (e.g. powerpc built with CONFIG_PPC_256K_PAGES=y
>> CONFIG_FORCE_MAX_ZONEORDER=11) get PAGE_SHIFT + MAX_ORDER > 26.
>>
>> In 3.10 kernels, CONFIG_LOCKDEP=y with PAGE_SHIFT + MAX_ORDER > 26 makes
>> init_lock_keys() dereference beyond kmalloc_caches[26].
>> This leads to an unbootable system (kernel panic at initializing SLAB)
>> if one of kmalloc_caches[26...PAGE_SHIFT+MAX_ORDER-1] is not NULL.
>>
>> Fix this by making sure that init_lock_keys() does not dereference beyond
>> kmalloc_caches[26] arrays.
>
> Nice, thanks.  Pekka, please grab.
>
>
> From: Christoph Lameter <cl@linux.com>
> Subject: slab: fix init_lock_keys
>
> Some architectures (e.g. powerpc built with CONFIG_PPC_256K_PAGES=y
> CONFIG_FORCE_MAX_ZONEORDER=11) get PAGE_SHIFT + MAX_ORDER > 26.
>
> In 3.10 kernels, CONFIG_LOCKDEP=y with PAGE_SHIFT + MAX_ORDER > 26 makes
> init_lock_keys() dereference beyond kmalloc_caches[26].
> This leads to an unbootable system (kernel panic at initializing SLAB)
> if one of kmalloc_caches[26...PAGE_SHIFT+MAX_ORDER-1] is not NULL.
>
> Fix this by making sure that init_lock_keys() does not dereference beyond
> kmalloc_caches[26] arrays.
>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> Reported-by: Tetsuo Handa <penguin-kernel@I-Love.SAKURA.ne.jp>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: <stable@vger.kernel.org>	[3.10.x]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>   mm/slab.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff -puN mm/slab.c~slab-fix-init_lock_keys mm/slab.c
> --- a/mm/slab.c~slab-fix-init_lock_keys
> +++ a/mm/slab.c
> @@ -565,7 +565,7 @@ static void init_node_lock_keys(int q)
>   	if (slab_state < UP)
>   		return;
>
> -	for (i = 1; i < PAGE_SHIFT + MAX_ORDER; i++) {
> +	for (i = 1; i <= KMALLOC_SHIFT_HIGH; i++) {
>   		struct kmem_cache_node *n;
>   		struct kmem_cache *cache = kmalloc_caches[i];
>
> _
>

Grabbed, thanks a lot Andrew!
