Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3AWJgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:36:22 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44102 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3AWJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:36:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=BHGukSQJJGUS=H++qzxME3aEEQZR8QiyHPU8LabHsSw@mail.gmail.com>
References: <1358758844-24711-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358758844-24711-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x==FoW5Sh5KFt9iO+_04dEbwsQHJX3rsTWNqFiZqTbPn6A@mail.gmail.com>
	<1358846546.12502.57.camel@smile>
	<CAKohpo=m-s4+q+4v2v+8nzC32FRzJAb58no2hZLV_5QqTj4wig@mail.gmail.com>
	<1358932355.12502.68.camel@smile>
	<CAKohpo=BHGukSQJJGUS=H++qzxME3aEEQZR8QiyHPU8LabHsSw@mail.gmail.com>
Date: Wed, 23 Jan 2013 11:36:18 +0200
Message-ID: <CAHp75VeNe1Z9CqYXVjV6am_vg=5XF=vx1i47h71xRdTvT6hSGA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dw_dmac: return proper residue value
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 11:22 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 23 January 2013 14:42, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:

>> Yesterday I spent in testing of different approaches. First of all, the
>> calculation of the sent amount is nicer when ctlhi/ctllo is used and it
>> works fine. But the approach, when we substract length of sent
>> descriptors, is losing data. Namely, we have no information how big is
>> the master descriptor (it has total length of the entire chain). So, I'm
>> thinking how to solve this one. Otherwise it seems simpler than mine
>> first idea.
>
> I was planning to give you another review comment which i thought i will
> give later :)
>
> It looks to be a bit wrong to have individual lengths in all descriptors leaving
> the first one :)
>
> This is the descriptor struct:
>
> struct dw_desc {
>         /* FIRST values the hardware uses */
>         struct dw_lli                   lli;
>
>         /* THEN values for driver housekeeping */
>         struct list_head                desc_node;
>         struct list_head                tx_list;
>         struct dma_async_tx_descriptor  txd;
>         size_t                          len;
> };
>
> Firstly i believe we can have a union of both list_heads as only one is used
> at any time. Can you patch it down?

Okay, separately and later to avoid additional testing. Will it work for you?

>
> Second to solve your problem, you can add another field here: total_len.
> I know it will consume 4 bytes per desc but i think that's the drawback we need
> to accept.

I found already better solution I guess.
I introduced two functions to get amount of sent bytes like

u32 calc_sent(u32 ctlhi, u32 ctllo)
{
 return f1(ctlhi) * f2(ctllo);
}

u32 get_sent(dwc)
{
 return calc_sent(read(CTL_HI), read(CTL_LO));
}

And usage like

/* initial residue */
desc->len - calc_sent(desc->lli.ctlhi, desc->lli.ctllo).

What do you think?

-- 
With Best Regards,
Andy Shevchenko
