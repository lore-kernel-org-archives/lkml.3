Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3IFL5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:57:45 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:59814 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3IFL5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:57:44 -0400
MIME-Version: 1.0
X-Originating-IP: [89.2.206.189]
In-Reply-To: <CANq1E4QueHY41Kz5xWnMC5Y8fQzsb4a7FxyrYg2XuGLOQ-wZfw@mail.gmail.com>
References: <1378459933-367-1-git-send-email-teg@jklm.no> <CANq1E4Tco9K1zeL2d7MhBQ=UjHFOktrrR8GHp8cJm3V6CTqf0g@mail.gmail.com>
 <CAMuHMdUEjLSRoSHdQUACupxiJ_GxMXSzk-KsMA5ep55sxNT3kw@mail.gmail.com> <CANq1E4QueHY41Kz5xWnMC5Y8fQzsb4a7FxyrYg2XuGLOQ-wZfw@mail.gmail.com>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 6 Sep 2013 13:57:22 +0200
Message-ID: <CAG-2HqXG0R_sEZGekVPX5kYxjrRdviG_kdqsLTWEgQ1r-Qc0OQ@mail.gmail.com>
Subject: Re: [PATCH] x86: simplefb: avoid overflow
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 1:24 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Fri, Sep 6, 2013 at 12:59 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Fri, Sep 6, 2013 at 11:55 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
>>> On Fri, Sep 6, 2013 at 11:32 AM, Tom Gundersen <teg@jklm.no> wrote:
>>>> lfb_size can easily be say 4M, which would make the bitshit overflow and
>>>> the test fail.
>>>>
>>>> Signed-off-by: Tom Gundersen <teg@jklm.no>
>>>> Cc: David Herrmann <dh.herrmann@gmail.com>
>>>> Cc: H. Peter Anvin <hpa@zytor.com>
>>>> ---
>>>>  arch/x86/kernel/sysfb_simplefb.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kernel/sysfb_simplefb.c b/arch/x86/kernel/sysfb_simplefb.c
>>>> index 22513e9..fff44a5 100644
>>>> --- a/arch/x86/kernel/sysfb_simplefb.c
>>>> +++ b/arch/x86/kernel/sysfb_simplefb.c
>>>> @@ -72,7 +72,7 @@ __init int create_simplefb(const struct screen_info *si,
>>>>          * the part that is occupied by the framebuffer */
>>>>         len = mode->height * mode->stride;
>>>>         len = PAGE_ALIGN(len);
>>>> -       if (len > si->lfb_size << 16) {
>>>> +       if (len > ((unsigned long) si->lfb_size) << 16) {
>>
>> On 32-bit, "unsigned long" is the same size as __u32, so this doesn't
>> make any difference.
>
> lfb_size cannot be 4M on 32bit machines. Well, if it is, the firmware
> passed bogus information as you cannot have a 262G-region on 32bit.
> But on 64bit it can pass 4M just fine.
> So we don't care for the 32bit case here, only 64bit. The (__u64) cast
> would be more obvious. Don't know.. It's just a sanity check, anyways,
> so I'm fine with it.

I used unsigned long simply to match the type of len...

>>> Nice catch. vesafb uses "lfb_size * 65535" which causes an implicit
>>> cast. I thought <<16 looks nicer but that doesn't do any implicit
>>> cast..
>>
>> "lfb_size * 65535" is the same. "lfb_size" is __u32, "65535" is int.
>> So there's no implicit cast. Or am I missing something?
>
> Yepp, indeed. My bad, so vesafb doesn't do any better here.
>
> I wonder, though, which firmware passes such values. It means the
> lfb_size area is reserved >4G. We do have huge VMEM these days..
> Tom, on what hardware did you hit that?

As always when weird things happen:

DMI: Apple Inc. MacBookAir5,1/Mac-66F35F19FE2A0D05, BIOS
MBA51.88Z.00EF.B01.1207271122 07/27/2012

Cheers,

Tom
