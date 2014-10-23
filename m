Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaJWMo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:44:29 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:52544 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbaJWMo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:44:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=UhdHHYqaF=Nprr2Lz2b4w7guuBquBdBrB82BmYhGC0=Q@mail.gmail.com>
References: <1413304389-6580-1-git-send-email-dianders@chromium.org>
 <CAGOxZ507j5QjnT_hW2y0KPZsw6WDJWRPLdesTBm4+C8D2EznWw@mail.gmail.com>
 <CAD=FV=X+q2ymbB0EZkjj_tip9_PLdFV+Tfee+MkeUDSfD3E-ig@mail.gmail.com>
 <CAGOxZ51x8cd9XmNg49aaUdZQkw-hhEA-mC=34ZSjLf0XF8Zbvw@mail.gmail.com>
 <54448023.1050008@samsung.com> <CAD=FV=UhdHHYqaF=Nprr2Lz2b4w7guuBquBdBrB82BmYhGC0=Q@mail.gmail.com>
From: Alim Akhtar <alim.akhtar@gmail.com>
Date: Thu, 23 Oct 2014 18:13:45 +0530
Message-ID: <CAGOxZ53QH+XhUJcAk7oDK4cEMp4sOWcsTbJzrvggOC55LBaz2A@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: Remove old card detect infrastructure
To: Doug Anderson <dianders@chromium.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Wed, Oct 22, 2014 at 10:06 PM, Doug Anderson <dianders@chromium.org> wrote:
> Hi,
>
> On Sun, Oct 19, 2014 at 8:23 PM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi.
>>
>> On 10/17/2014 09:44 PM, Alim Akhtar wrote:
>>> Hi Doug,
>>>
>>> On Thu, Oct 16, 2014 at 9:40 PM, Doug Anderson <dianders@chromium.org> wrote:
>>>> Alim,
>>>>
>>>> On Thu, Oct 16, 2014 at 5:57 AM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>>>>> Hi Doug,
>>>>>
>>>>> On Tue, Oct 14, 2014 at 10:03 PM, Doug Anderson <dianders@chromium.org> wrote:
>>>>>> The dw_mmc driver had a bunch of code that ran whenever a card was
>>>>>> ejected and inserted.  However, this code was old and crufty and
>>>>>> should be removed.  Some evidence that it's really not needed:
>>>>>>
>>>>>> 1. Is is supposed to be legal to use 'cd-gpio' on dw_mmc instead of
>>>>>>    using the built-in card detect mechanism.  The 'cd-gpio' code
>>>>>>    doesn't run any of the crufty old code but yet still works.
>>>>>>
>>>>>> 2. While looking at this, I realized that my old change (369ac86 mmc:
>>>>>>    dw_mmc: don't queue up a card detect at slot startup) actually
>>>>>>    castrated the old code a little bit already and nobody noticed.
>>>>>>    Specifically "last_detect_state" was left as 0 at bootup.  That
>>>>>>    means that on the first card removal none of the crufty code ran.
>>>>>>
>>>>> Yes, right most of these codes are _almost_ never call. But I see
>>>>> dw_mci_reset() being called on card removal (after first
>>>>> insert/removal).
>>>>
>>>> Right.  The old crufty code was called on the 2nd removal, not the
>>>> 1st.  That meant that the two were accidentally different.  My point
>>>> was that if the old code was really required that someone would have
>>>> noticed crashes on the 1st removal after each boot.  Since nobody is
>>>> reporting crashes with that then it means it can't be too terrible.
>>>>
>>>> One thing to note: I remember in the last Chromebook project you were
>>>> trying to track down crashes associated with constant eject / insert
>>>> of SD Cards.  I wonder if my patch will fix these crashes?
>>>>
>>> Ah, yes, reproducing that and checking with this patch will be really
>>> interesting.
>>>
>>>>
>>>>> I tested this on exynos5800 and this looks working fine. We need to
>>>>> test once cross suspend/resume as well.
>>>>
>>>> Good idea.  Can you test that?  I know that there's been lots of flux
>>>> with suspend/resume on exynos and I'm not sure I have all the latest
>>>> patches, but I'll search for them if you are unable to test easily.
>>>>
>>> Sure, I will do that..but probably sometime next week, as I will out
>>> of office for few days.
>>>>
>>>>> And as Jaehoon pointed out,probably lets look in TRM if there are some
>>>>> recommended  steps for cd-detect.
>>>>> Otherwise this looks good to me.
>>>>
>>>> If you see some other requirement than the one I addressed in my email
>>>> to Jaehoon, please let me know.
>>
>> I know there is no other requirement for detecting card.
>> So this patch can be applied after testing the above case(suspend/resume).
>
> I put a kernel based upon 3.17 on an exynos5250-snow (specifically
> git://git.collabora.co.uk/git/user/javier/linux.git branch
> max77802-op-modes-v3, git hash 98cf5a0).  Snow uses the builtin card
> detect on dw_mmc.  Resume wasn't terribly reliable to start with even
> without my patch (it often woke up right after suspend), but it worked
> well enough for testing.  I tested the following scenarios:
>
> 1. Leave card in and mounted.  Suspend/resume.  Card is still usable
> after resume
>
> 2. Suspend and insert card.  Resume.  Card is detected upon resume.
>
> 3. Suspend and remove card.  Resume.  Card is removed upon resume.
>
> How does that sound?
>
Sounds good to me.
I tested this on Peach-Pi with v3.17 based kernel across suspend
resume and cards works fine.
Even I back-ported this to chromium 3.8 and tested on peach-pi, no
issue over a hundred s2r cycles.

Tested-by: alim.akhtar <alim.akhtar@samsung.com>
> -Doug



-- 
Regards,
Alim
