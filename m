Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbaIZRHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:07:49 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:60395 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbaIZRHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:07:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140926165913.GX5182@n2100.arm.linux.org.uk>
References: <1411067949-10913-1-git-send-email-keescook@chromium.org>
	<1411067949-10913-8-git-send-email-keescook@chromium.org>
	<20140926114239.GM5182@n2100.arm.linux.org.uk>
	<CAGXu5jL+ksQ4nq4pxOk7gM0POmwtTQ7DgmugpVK45arpMLGzvg@mail.gmail.com>
	<20140926165913.GX5182@n2100.arm.linux.org.uk>
Date: Fri, 26 Sep 2014 10:07:46 -0700
X-Google-Sender-Auth: DTfXYQtR_sWE36ujW8L71e2gfNU
Message-ID: <CAGXu5jLbhBMf0eMcuRGTCc6bMAuGbRoq5fqq=4r-NNT_OJ3evQ@mail.gmail.com>
Subject: Re: [PATCH v6 7/8] ARM: mm: allow non-text sections to be non-executable
From: Kees Cook <keescook@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
        Rabin Vincent <rabin@rab.in>, Laura Abbott <lauraa@codeaurora.org>,
        Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 9:59 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Sep 26, 2014 at 09:43:12AM -0700, Kees Cook wrote:
>> On Fri, Sep 26, 2014 at 4:42 AM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Thu, Sep 18, 2014 at 12:19:08PM -0700, Kees Cook wrote:
>> >> @@ -1373,13 +1373,24 @@ static void __init map_lowmem(void)
>> >>               if (start >= end)
>> >>                       break;
>> >>
>> >> -             if (end < kernel_x_start || start >= kernel_x_end) {
>> >> +             if (end < kernel_x_start) {
>> >>                       map.pfn = __phys_to_pfn(start);
>> >>                       map.virtual = __phys_to_virt(start);
>> >>                       map.length = end - start;
>> >>                       map.type = MT_MEMORY_RWX;
>> >>
>> >>                       create_mapping(&map);
>> >> +             } else if (start >= kernel_x_end) {
>> >> +                     map.pfn = __phys_to_pfn(start);
>> >> +                     map.virtual = __phys_to_virt(start);
>> >> +                     map.length = end - start;
>> >> +#ifdef CONFIG_ARM_KERNMEM_PERMS
>> >> +                     map.type = MT_MEMORY_RW;
>> >> +#else
>> >> +                     map.type = MT_MEMORY_RWX;
>> >> +#endif
>> >> +
>> >> +                     create_mapping(&map);
>> >
>> >
>> > I'm looking at this, and wondering two things.  Firstly, why isn't it
>> > MT_MEMORY_RW in the first place.  Secondly, why do you need to make
>> > this depend on CONFIG_ARM_KERNMEM_PERMS at all?
>> >
>> > I think the first is an oversight by me (and is a case which never came
>> > up in my testing, because most of my platforms don't have segmented
>> > memory layouts.)
>> >
>> > The second I think is not necessary - the memory region being considered
>> > is not part of the kernel at all, and so should not be executable in any
>> > shape or form.
>>
>> I'm happy to change this. My original intent was to make layout for
>> builds without CONFIG_ARM_KERNMEM_PERMS identical to what was there
>> before, so I took this step to make sure.
>>
>> I will drop the #ifdef and respin. Does the rest look ok? Shall I send
>> a pull request?
>
> I think all you need to is change that MT_MEMORY_RWX to be MT_MEMORY_RW.

Okay, I'll make that change.

> However, I think I would also like to see the kernel text being read-only
> as soon as possible - so maybe we should also have MT_MEMORY_RX, and
> have map_lowmem() use this for the kernel text when we want this level
> of protection?

Well, even if that's done we still need all the fixmap stuff happening
too since so many things like to change the kernel memory. :)

I'd like to start with this series, and then we can improve on it
going forward. This one seems to work and has been tested by a lot of
folks so far, so I'd hate to scrap a major portion and start over. I'd
like to get this landed, and then tweak it as needed. Does that sound
workable?

-Kees

-- 
Kees Cook
Chrome OS Security
