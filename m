Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935695AbaH0SjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:39:18 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:60618 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935622AbaH0SjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:39:16 -0400
MIME-Version: 1.0
In-Reply-To: <CAGo_u6rVNsmeuuaTre87eThh3_uo_1aWBgsW+ixiRtif=tnjLA@mail.gmail.com>
References: <1408715373-25791-1-git-send-email-nm@ti.com>
	<1408715373-25791-5-git-send-email-nm@ti.com>
	<7h1ts1eqjp.fsf@paris.lan>
	<CAGo_u6rVNsmeuuaTre87eThh3_uo_1aWBgsW+ixiRtif=tnjLA@mail.gmail.com>
Date: Wed, 27 Aug 2014 11:39:15 -0700
Message-ID: <CAMAWPa94ZesenozT4zLQ7ihCUVE6BwKpPQxz-6ao9iSM2t9BDA@mail.gmail.com>
Subject: Re: [PATCH 4/7] ARM: OMAP2+: powerdomain: introduce logic for finding
 valid power domain
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nishanth Menon <nm@ti.com>
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

On Wed, Aug 27, 2014 at 11:35 AM, Nishanth Menon <nm@ti.com> wrote:
> On Wed, Aug 27, 2014 at 1:27 PM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>> Nishanth Menon <nm@ti.com> writes:
>>
>>> powerdomain configuration in OMAP is done using PWRSTCTRL register for
>>> each power domain. However, PRCM lets us write any value we'd like to
>>> the logic and power domain target states, however the SoC integration
>>> tends to actually function only at a few discrete states. These valid
>>> states are already in our powerdomains_xxx_data.c file.
>>>
>>> So, provide a function to easily query valid low power state that the
>>> power domain is allowed to go to.
>>>
>>> Based on work originally done by Jean Pihet <j-pihet@ti.com>
>>> https://patchwork.kernel.org/patch/1325091/ . There is no attempt to
>>> create a new powerdomain solution here, except fixing issues seen
>>> attempting invalid programming attempts. Future consolidation to the
>>> generic powerdomain framework should consider this requirement as
>>> well.
>>>
>>> Similar solutions have been done in product kernels in the past such
>>> as:
>>> https://android.googlesource.com/kernel/omap.git/+blame/android-omap-panda-3.0/arch/arm/mach-omap2/pm44xx.c
>>>
>>> Signed-off-by: Nishanth Menon <nm@ti.com>
>>> ---
>>
>> nit: this is part of a fixes series, but it's more of a new feature.
>>
>> That being said, the feature is needed and looks OK, except for...
>>
>>> +up_search:
>>> +     /* OK, no deeper ones, can we get a higher match? */
>>> +     new_pwrst = req_state + 1;
>>> +     while (!(pwrdm_states & BIT(new_pwrst))) {
>>> +             /* BUG if we have messed up database */
>>> +             BUG_ON(new_pwrst > PWRDM_POWER_ON);
>>
>> I don't think this is BUG() worthy, and should have a saner way to recover.
>
> it is not even a legal value to have a power state higher than ON. I
> mean, yeah, we can do
> if (new_pwrst > PWRDM_POWER_ON) {
>          pr_debug("powerdomain: %s: fix my powerdomain max to ON\n",
> pwrdm->name);
>          return PWRDM_POWER_ON;
> }
>
> if that is your suggestion here, personally, I would use a WARN at least here..

WARN, pr_warn() as you like.

The point is that BUG* calls panic() and locks up the system tight.
As what your'e adding is not fatal to the entire system, you should
not be using bug.  From asm-generic/bug.h:

*
 * Don't use BUG() or BUG_ON() unless there's really no way out; one
 * example might be detecting data structure corruption in the middle
 * of an operation that can't be backed out of.  If the (sub)system
 * can somehow continue operating, perhaps with reduced functionality,
 * it's probably not BUG-worthy.
 *
 * If you're tempted to BUG(), think again:  is completely giving up
 * really the *only* solution?  There are usually better options, where
 * users don't need to reboot ASAP and can mostly shut down cleanly.
 */
