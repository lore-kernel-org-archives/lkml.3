Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab3D2KMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 06:12:54 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54720 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3D2KMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 06:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp>
References: <201304242108.FDC35910.VJMHFFFSOLOOQt@I-love.SAKURA.ne.jp>
	<201304252120.GII21814.FMJFtHLOOVQFOS@I-love.SAKURA.ne.jp>
	<201304291140.IFJ95894.OFLSFFHQOOMVJt@I-love.SAKURA.ne.jp>
Date: Mon, 29 Apr 2013 13:12:51 +0300
X-Google-Sender-Auth: elI61Ja8RRN9hjnxyhJxrjH18sg
Message-ID: <CAOJsxLFYDC+EDdJrXVnc1qfEyd56bhFLeGE+6Mbhwiq73KQQLQ@mail.gmail.com>
Subject: Re: [linux-next-20130422] Bug in SLAB?
From: Pekka Enberg <penberg@kernel.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Glauber Costa <glommer@parallels.com>, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 5:40 AM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Tetsuo Handa wrote:
>> Also, kmalloc_index() in include/linux/slab.h can return 0 to 26.
>>
>> If (MAX_ORDER + PAGE_SHIFT - 1) > 25 is true and
>> kmalloc_index(64 * 1024 * 1024) is requested (I don't know whether such case
>> happens), kmalloc_caches[26] is beyond the array, for kmalloc_caches[26]
>> allows 0 to 25.
>>
>> If (MAX_ORDER + PAGE_SHIFT - 1) <= 25 is true and
>> kmalloc_index(64 * 1024 * 1024) is requested (I don't know whether such case
>> happens), kmalloc_caches[26] is beyond the array, for
>> kmalloc_caches[MAX_ORDER + PAGE_SHIFT] allows 0 to MAX_ORDER + PAGE_SHIFT - 1.
>>
>> Would you recheck that the array size is correct?
>>
>
> I confirmed (on x86_32) that
>
>   volatile unsigned int size = 8 * 1024 * 1024;
>   kmalloc(size, GFP_KERNEL);
>
> causes no warning at compile time and returns NULL at runtime. But
>
>   unsigned int size = 8 * 1024 * 1024;
>   kmalloc(size, GFP_KERNEL);
>
> causes compile time warning
>
>   include/linux/slab_def.h:136: warning: array subscript is above array bounds
>
> and runtime bug.
>
>   BUG: unable to handle kernel NULL pointer dereference at 00000058
>   IP: [<c10b9d76>] kmem_cache_alloc+0x26/0xb0
>
> I confirmed (on x86_32) that
>
>   kmalloc(64 * 1024 * 1024, GFP_KERNEL);
>
> causes compile time warning
>
>   include/linux/slab_def.h:136: warning: array subscript is above array bounds
>
> and runtime bug.
>
>   Kernel BUG at c10b9c5b [verbose debug info unavailable]
>   invalid opcode: 0000 [#1] SMP
>
> Also,
>
>   volatile unsigned int size = 64 * 1024 * 1024;
>   kmalloc(size, GFP_KERNEL);
>
> causes no warning at compile time but runtime bug.
>
>   Kernel BUG at c10b9c5b [verbose debug info unavailable]
>   invalid opcode: 0000 [#1] SMP
>
> There are kernel modules which expect kmalloc() to return NULL rather than
> oops when the requested size is too large.

Christoph, Glauber, it seems like commit e3366016 ("slab: Use common
kmalloc_index/kmalloc_size functions") is causing some problems here.
Can you please take a look?

                        Pekka
