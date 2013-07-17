Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489Ab3GQXQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:16:08 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42271 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462Ab3GQXQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:16:05 -0400
Message-ID: <51E725B2.7090003@gmail.com>
Date: Wed, 17 Jul 2013 16:16:02 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH RFC] lib: Make radix_tree_node_alloc() irq safe
References: <1373994390-5479-1-git-send-email-jack@suse.cz> <20130717161200.40a97074623be2685beb8156@linux-foundation.org>
In-Reply-To: <20130717161200.40a97074623be2685beb8156@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 04:12 PM, Andrew Morton wrote:
> On Tue, 16 Jul 2013 19:06:30 +0200 Jan Kara <jack@suse.cz> wrote:
>
>> With users of radix_tree_preload() run from interrupt (CFQ is one such
>> possible user), the following race can happen:
>>
>> radix_tree_preload()
>> ...
>> radix_tree_insert()
>>    radix_tree_node_alloc()
>>      if (rtp->nr) {
>>        ret = rtp->nodes[rtp->nr - 1];
>> <interrupt>
>> ...
>> radix_tree_preload()
>> ...
>> radix_tree_insert()
>>    radix_tree_node_alloc()
>>      if (rtp->nr) {
>>        ret = rtp->nodes[rtp->nr - 1];
>>
>> And we give out one radix tree node twice. That clearly results in radix
>> tree corruption with different results (usually OOPS) depending on which
>> two users of radix tree race.
>>
>> Fix the problem by disabling interrupts when working with rtp variable.
>> In-interrupt user can still deplete our preloaded nodes but at least we
>> won't corrupt radix trees.
>>
>> ...
>>
>>    There are some questions regarding this patch:
>> Do we really want to allow in-interrupt users of radix_tree_preload()?  CFQ
>> could certainly do this in older kernels but that particular call site where I
>> saw the bug hit isn't there anymore so I'm not sure this can really happen with
>> recent kernels.
>
> Well, it was never anticipated that interrupt-time code would run
> radix_tree_preload().  The whole point in the preloading was to be able
> to perform GFP_KERNEL allocations before entering the spinlocked region
> which needs to allocate memory.
>
> Doing all that from within an interrupt is daft, because the interrupt code
> can't use GFP_KERNEL anyway.
>
>> Also it is actually harmful to do preloading if you are in interrupt context
>> anyway. The disadvantage of disallowing radix_tree_preload() in interrupt is
>> that we would need to tweak radix_tree_node_alloc() to somehow recognize
>> whether the caller wants it to use preloaded nodes or not and that callers
>> would have to get it right (although maybe some magic in radix_tree_preload()
>> could handle that).
>>
>> Opinions?
>
> BUG_ON(in_interrupt()) :)

Is is really that severe?  How about...

WARN_ON() instead?

David Daney


