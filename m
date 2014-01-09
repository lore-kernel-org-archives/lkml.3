Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaAIROP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:14:15 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:54743 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaAIROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:14:08 -0500
MIME-Version: 1.0
In-Reply-To: <9DF5D0F7-F5A7-4705-8ACB-286B49D668C1@matuschek.net>
References: <alpine.DEB.2.02.1401082231260.4025@parallels-Parallels-Virtual-Platform>
	<20140109142745.GB6110@opensource.wolfsonmicro.com>
	<9DF5D0F7-F5A7-4705-8ACB-286B49D668C1@matuschek.net>
Date: Thu, 9 Jan 2014 09:14:07 -0800
Message-ID: <CA+7tXijibZKUoeqeqpvOhgJg17OgpYR2Kv5S17TFdAKvaCjt3g@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8804: Allow fine-grained control of
 the PLL generation
From: Trent Piepho <tpiepho@gmail.com>
To: Daniel Matuschek <daniel@matuschek.net>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Dimitris.Papastamos@wolfsonmicro.com, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        patches@opensource.wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 7:29 AM, Daniel Matuschek <daniel@matuschek.net> wrote:
> On 09.01.2014, at 15:27, Charles Keepax <ckeepax@opensource.wolfsonmicro.com> wrote:
>
>> On Wed, Jan 08, 2014 at 10:36:53PM +0100, Daniel Matuschek wrote:
>>> Signed-off-by: Daniel Matuschek <daniel@matuschek.net>
>>>
>>
>> <snip>
>>
>>>                      pll_div->freqmode = post_table[i].freqmode;
>>> -                    pll_div->mclkdiv = post_table[i].mclkdiv;
>>> -                    target *= post_table[i].div;
>>> -                    break;
>>> +                    if ((mclk_div == WM8804_MCLKDIV_DONTCARE) ||
>>> +                        ((post_table[i].mclkdiv == 1) &&
>>> +                            (mclk_div == WM8804_MCLKDIV_1)) ||
>>> +                        ((post_table[i].mclkdiv == 0) &&
>>> +                            (mclk_div == WM8804_MCLKDIV_0))) {
>>
>> Would probably be nicer to update the post_table to use the new
>> defines and directly compare.

How about giving the defines better names?  Like WM8804_MCLKDIV_256x
for 0.  Assuming that's the value for 256x, I can't actually tell.
Which is why the define name could be better.

>> This does feel like a slight abuse of pll_id, it feels to me that
>> using the set_clkdiv callback would be a little more natural from
>> a user perspective.
>
> Good idea, I will move it to set_clkdiv.

Why does it need to be an option?  If 256x is better, then why not
always use it?  Maybe the code to select the divisor should be better?

If we look at the post_table:
static struct {
        unsigned int div;
        unsigned int freqmode;
        unsigned int mclkdiv;
} post_table[] = {
        {  2,  0, 0 },
        {  4,  0, 1 },
        {  4,  1, 0 },
        {  8,  1, 1 },
        {  8,  2, 0 },
        { 16,  2, 1 },
        { 12,  3, 0 },
        { 24,  3, 1 }
};

The code loops through that in order to find the first div that when
multiplied by the target rate gives 90-100 MHz.  So if the first div=4
in the table doesn't work, why would the second 4 work?  It looks like
it's just doing unnecessary tries to re-reject the same divisor
reached by different freqmode & mclkdiv combinations.

Since it stops at the first divisor that works, won't it always use
mclkdiv=1?  If mclkdiv=0 is better, why not just list those first/only
in the table so they get used?

BTW,
        if ((K % 10) >= 5)
                K += 5;
        K /= 10;

Worst Division With Rounding Ever.  And don't even get me started on
the base 10 fixed point on a binary computer.
