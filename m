Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3DWXPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:15:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35161 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab3DWXPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:15:44 -0400
Message-ID: <51771610.5040303@zytor.com>
Date: Tue, 23 Apr 2013 16:15:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Rusty Russell <rusty@rustcorp.com.au>
CC: andy.shevchenko@gmail.com, arjan@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: memcmp in modules
References: <CAHp75VdDwh0wgCWrVDcPps1C2qfdDZra15y9BQvzfWHzSMqbWA@mail.gmail.com> <CAHp75Vfh6Bpk4j3crVEAo3UtJEqpyucbQw+AzJvO85uRJ6gVgg@mail.gmail.com> <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
In-Reply-To: <201304222326.IJB21395.FOtVJFHFQMOOSL@I-love.SAKURA.ne.jp>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 07:26 AM, Tetsuo Handa wrote:
> Andy Shevchenko wrote:
>> What did I miss?
> 
> Well, as of linux-next-20130422, memcmp() is not correctly exported to modules.
> Since linux-3.9-rc8 correctly exports memcmp(), this problem seems to be introduced
> in linux-next tree. Also, this problem seems to involve CONFIG_MODVERSIONS=y.
> 
>   [root@localhost linux-next]# modprobe ipv6
>   FATAL: Error inserting ipv6 (/lib/modules/3.9.0-rc8-next-20130422/kernel/net/ipv6/ipv6.ko): Invalid argument
>   [root@localhost linux-next]# dmesg
>   ipv6: no symbol version for memcmp
>   ipv6: Unknown symbol memcmp (err -22)
> 
> Since arch/x86/include/asm/string_64.h uses
> 
>   int memcmp(const void *cs, const void *ct, size_t count);
> 
> while arch/x86/include/asm/string_32.h uses
> 
>   #define memcmp __builtin_memcmp
> 
> changing to what you have tried
> 
>   #define memcmp(a, b, n) __builtin_memcmp(a, b, n)
> 
> or changing to what x86_64 does
> 
>   int memcmp(const void *cs, const void *ct, size_t count);
> 
> might solve this problem. But I don't know which one is correct solution...
> 

Rusty, this seems like a problem with your changes to the prefix
handling.  Somehow memcmp being a macro gets picked up by some, but not
all, of the module-metadata generation tools.

Changing memcmp to a macro with arguments (see above) seems to paper
over the problem for this one, but there seems to be something much more
sinister going on and I would really like a good explanation as I fear
this can crop up in other places.

	-hpa

