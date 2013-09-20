Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab3ITC71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 22:59:27 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:7861 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3ITC7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 22:59:25 -0400
Message-ID: <523BB9FE.2030003@hp.com>
Date: Thu, 19 Sep 2013 22:59:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Will Deacon <will.deacon@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lockref: use cmpxchg64 explicitly for lockless updates
References: <1379614006-3844-1-git-send-email-will.deacon@arm.com> <CA+55aFxuc3yD5pH2w5uEr_VDsEANvEiGCWA6tu1cSFrAiaU4Ow@mail.gmail.com>
In-Reply-To: <CA+55aFxuc3yD5pH2w5uEr_VDsEANvEiGCWA6tu1cSFrAiaU4Ow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 02:11 PM, Linus Torvalds wrote:
> On Thu, Sep 19, 2013 at 1:06 PM, Will Deacon<will.deacon@arm.com>  wrote:
>> The cmpxchg() function tends not to support 64-bit arguments on 32-bit
>> architectures. This could be either due to use of unsigned long arguments
>> (like on ARM) or lack of instruction support (cmpxchgq on x86). However,
>> these architectures may implement a specific cmpxchg64() function to
>> provide 64-bit cmpxchg support instead
> I'm certainly ok with this, but I wonder how much point there is to
> use the cmpxchg alternatives for 32-bit architectures at all...
>
>  From a performance standpoint, lockref really is expected to mainly
> help with big machines. Only insane people would do big machines with
> 32-bit kernels these days.
> Of course, it may be that cmpxchg is actually faster on some
> architectures, but at least on x86-32, cmpxchg8b is traditionally
> quite slow.
>
> In other words, I'd actually like to see some numbers if there are
> loads where this actually helps and matters...
>
>                     Linus

I agreed that 32-bit machines are not likely to be big enough to get 
benefit from this feature. However, I do see a minor problem with the 
current code. If a user tries to turn on CMPXCHG_LOCKREF on a 32-bit 
build, he/she will get a compilation error because a 64-bit data type is 
not supported in 32-bit mode's cmpxchg(). Because of this, my original 
patch also uses cmpxchg64() which is equivalent to cmpxchg() in 64-bit 
machine for 64-bit data type.

I would suggest either change to use cmpxchg64() or add the dependence 
line "depends on 64BIT" to CMPXCHG_LOCKREF.

-Longman
