Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3EMIIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:08:38 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:54829 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3EMIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:08:36 -0400
MIME-Version: 1.0
In-Reply-To: <OFE7F9663A.1F3DE1BE-ON48257B60.00045684-48257B60.001360DF@zte.com.cn>
References: <CAFLxGvxfzHudUMRc7VkgWMO9RJAkyh1iuouRAV-0s-5eaLqfEQ@mail.gmail.com>
	<OFE7F9663A.1F3DE1BE-ON48257B60.00045684-48257B60.001360DF@zte.com.cn>
Date: Mon, 13 May 2013 10:08:35 +0200
Message-ID: <CAFLxGvzKw1_L3Nm4J5GM_wr0sFe6umN0yLzDnK=DM_AJ7GpaaQ@mail.gmail.com>
Subject: Re: Re: Re: [PATCH] UBI: fix memory leak when use fastmap
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: wang.bo116@zte.com.cn
Cc: artem.bityutskiy@linux.intel.com, cui.yunfeng@zte.com.cn,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        liu.dong3@zte.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 5:31 AM,  <wang.bo116@zte.com.cn> wrote:
> richard -rw- weinberger <richard.weinberger@gmail.com> write 2013-05-03
> 03:21:33:
>
>> On Thu, May 2, 2013 at 10:30 AM,  <wang.bo116@zte.com.cn> wrote:
>> >> Hi!
>> >>
>> >> On Tue, Apr 16, 2013 at 10:53 AM,  <wang.bo116@zte.com.cn> wrote:
>> >> > Hello,
>> >> >         Sorry, there is still something wrong with the previous
>> > patch's
>> >> > format, try to submit it again. When use ubi fastmap, there is a
>> > memory
>> >> > leak which will make destroy_ai() fail to free the slab alloced in
>> >> > scan_fast(). The following patch fix this problem by use a
> temporary
>> >> > "ubi_attach_info" variable in scan_fast().
>> >>
>> >> Thanks a lot for your patch!
>> >>
>> >> Did you test it well?
>> >> We need to make sure that it does the right thing for the following
>> > cases:
>> >> 1. fastmap disabled, attaching a non-fastmap volume
>> >> 1. fastmap disabled, attaching a fastmap volume
>> >> 3. fastmap enabled, attaching a non-fastmap volume
>> >> 4. fastmap enablled, attaching a fastmap volume
>> >>
>> >> --
>> >> Thanks,
>> >> //richard
>> >
>> >
>> > Thanks for your advice. I consider this problem like this:
>> > 1: if fastmap not config, ubi_attach() just call scan_all(ubi, ai, 0),
>> > there is nothing changed, so there is all right.
>> >
>> > 2: if fastmap config, and force_scan is 0, ubi_attach() will call
>> > scan_fast(), when scan_fast() return, temp ai used in scan_fast() has
> been
>> > free, and there will be two conditions:
>> > A: scan_fast() return UBI_NO_FASTMAP(may be flash is empty or
> attaching a
>> > non-fastmap volume), all ubi_attach() need is to call scan_all(ubi,
> ai, 0)
>> > to scan all blocks.
>> > B: scan_fast() return UBI_BAD_FASTMAP, ubi_attach() first free ai used
> in
>> > ubi_scan_fastmap(), then alloc a clean ai, at last call scan_all(ubi,
> ai,
>> > 0) to scan all blocks.
>> >
>> > 3: if fastmap config, and force_scan is 1, just call scan_all(ubi, ai,
> 0).
>> >
>> > This patch pass the following cases(include attach and detach):
>> > 1. fastmap config, flash is empty,fm_autoconvert is 1.
>> > 2. fastmap config, flash is empty,fm_autoconvert is 0.
>> > 3. fastmap config, attaching a fastmap volume
>> > 4. fastmap config, attaching a bad fastmap volume
>> > 5. fastmap config, attaching a non-fastmap volume
>> > 6. fastmap not config, attaching a fastmap volume
>> > 7. fastmap not config, attaching a non-fastmap volume
>> > 8. fastmap not config, flash is empty.
>>
>> Good. :)
>>
>> > By the way, the problem may cause ubi_attach() fail after ubi detach
> when
>> > CONFIG_DEBUG_VM config.
>> > The reason is that ubi_attach() will alloc a slab cache, but the
>> > kmem_cache_sanity_check() will find the slab cache is already
> exist(not
>> > been free after last detach), so slab cache alloc fail, and
> ubi_attach()
>> > fail, too.
>>
>> Doesn't your patch address this issue too?
>> If not, we should fix this.Th
>
> The patch had already fix the above problem mentioned.
> Now, all the slabs belong to the slab-cache named "ubi_aeb_slab_cache" can
> be rightly freed, so the slab-cache can be rightly freed when ubi_attach()
> return.
> When ubi attach again after detach, ubi can alloc a slab-cache named "
> ubi_aeb_slab_cache" again.

I tried to apply/test your patch.
It has lots of white spaces damages.
Can you please resend it using git send-email?
And also run checkpatch.pl before sending.

--
Thanks,
//richard
