Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935604AbaH0Sfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:35:48 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45786 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbaH0Sfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:35:46 -0400
MIME-Version: 1.0
In-Reply-To: <7h1ts1eqjp.fsf@paris.lan>
References: <1408715373-25791-1-git-send-email-nm@ti.com>
	<1408715373-25791-5-git-send-email-nm@ti.com>
	<7h1ts1eqjp.fsf@paris.lan>
Date: Wed, 27 Aug 2014 13:35:46 -0500
X-Google-Sender-Auth: gAZ4qGLvENiQuH2TQUZ9Dw5-_GI
Message-ID: <CAGo_u6rVNsmeuuaTre87eThh3_uo_1aWBgsW+ixiRtif=tnjLA@mail.gmail.com>
Subject: Re: [PATCH 4/7] ARM: OMAP2+: powerdomain: introduce logic for finding
 valid power domain
From: Nishanth Menon <nm@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
        Keerthy <j-keerthy@ti.com>, lkml <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 1:27 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Nishanth Menon <nm@ti.com> writes:
>
>> powerdomain configuration in OMAP is done using PWRSTCTRL register for
>> each power domain. However, PRCM lets us write any value we'd like to
>> the logic and power domain target states, however the SoC integration
>> tends to actually function only at a few discrete states. These valid
>> states are already in our powerdomains_xxx_data.c file.
>>
>> So, provide a function to easily query valid low power state that the
>> power domain is allowed to go to.
>>
>> Based on work originally done by Jean Pihet <j-pihet@ti.com>
>> https://patchwork.kernel.org/patch/1325091/ . There is no attempt to
>> create a new powerdomain solution here, except fixing issues seen
>> attempting invalid programming attempts. Future consolidation to the
>> generic powerdomain framework should consider this requirement as
>> well.
>>
>> Similar solutions have been done in product kernels in the past such
>> as:
>> https://android.googlesource.com/kernel/omap.git/+blame/android-omap-panda-3.0/arch/arm/mach-omap2/pm44xx.c
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>
> nit: this is part of a fixes series, but it's more of a new feature.
>
> That being said, the feature is needed and looks OK, except for...
>
>> +up_search:
>> +     /* OK, no deeper ones, can we get a higher match? */
>> +     new_pwrst = req_state + 1;
>> +     while (!(pwrdm_states & BIT(new_pwrst))) {
>> +             /* BUG if we have messed up database */
>> +             BUG_ON(new_pwrst > PWRDM_POWER_ON);
>
> I don't think this is BUG() worthy, and should have a saner way to recover.

it is not even a legal value to have a power state higher than ON. I
mean, yeah, we can do
if (new_pwrst > PWRDM_POWER_ON) {
         pr_debug("powerdomain: %s: fix my powerdomain max to ON\n",
pwrdm->name);
         return PWRDM_POWER_ON;
}

if that is your suggestion here, personally, I would use a WARN at least here..

-- 
---
Regards,
Nishanth Menon
