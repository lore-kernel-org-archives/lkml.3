Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3IFLQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:16:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3IFLP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <5229B7BB.5020804@zytor.com>
References: <1378459933-367-1-git-send-email-teg@jklm.no>
	<CANq1E4Tco9K1zeL2d7MhBQ=UjHFOktrrR8GHp8cJm3V6CTqf0g@mail.gmail.com>
	<CAMuHMdUEjLSRoSHdQUACupxiJ_GxMXSzk-KsMA5ep55sxNT3kw@mail.gmail.com>
	<5229B7BB.5020804@zytor.com>
Date: Fri, 6 Sep 2013 13:15:58 +0200
X-Google-Sender-Auth: HEZg22u_G7w87OakRBh1r8UFUi8
Message-ID: <CAMuHMdX-MvnfDPVpFLZ=sT4OA8P=+G63ddXeEwTWHFb3AcdO8A@mail.gmail.com>
Subject: Re: [PATCH] x86: simplefb: avoid overflow
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, Tom Gundersen <teg@jklm.no>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 1:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/06/2013 03:59 AM, Geert Uytterhoeven wrote:
>> On Fri, Sep 6, 2013 at 11:55 AM, David Herrmann <dh.herrmann@gmail.com>
>> wrote:
>>> On Fri, Sep 6, 2013 at 11:32 AM, Tom Gundersen <teg@jklm.no> wrote:
>>>> lfb_size can easily be say 4M, which would make the bitshit overflow and
>>>> the test fail.
>>>>
>>>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>>>> Cc: David Herrmann <dh.herrmann@gmail.com>
>>>> Cc: H. Peter Anvin <hpa@zytor.com>
>>>> ---
>>>>   arch/x86/kernel/sysfb_simplefb.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kernel/sysfb_simplefb.c
>>>> b/arch/x86/kernel/sysfb_simplefb.c
>>>> index 22513e9..fff44a5 100644
>>>> --- a/arch/x86/kernel/sysfb_simplefb.c
>>>> +++ b/arch/x86/kernel/sysfb_simplefb.c
>>>> @@ -72,7 +72,7 @@ __init int create_simplefb(const struct screen_info
>>>> *si,
>>>>           * the part that is occupied by the framebuffer */
>>>>          len = mode->height * mode->stride;
>>>>          len = PAGE_ALIGN(len);
>>>> -       if (len > si->lfb_size << 16) {
>>>> +       if (len > ((unsigned long) si->lfb_size) << 16) {
>>
>>
>> On 32-bit, "unsigned long" is the same size as __u32, so this doesn't
>> make any difference.
>>
>>> Nice catch. vesafb uses "lfb_size * 65535" which causes an implicit
>>> cast. I thought <<16 looks nicer but that doesn't do any implicit
>>> cast..
>>
>>
>> "lfb_size * 65535" is the same. "lfb_size" is __u32, "65535" is int.
>> So there's no implicit cast. Or am I missing something?
>>
>
> << 16 is * 65536 not 65535...

Oops, you're right. So that overflows a little bit later.
Still, that doesn't change any reasoning w.r.t implicit casts and overflows.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
