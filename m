Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbaE2N06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:26:58 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36075 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbaE2N0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:26:55 -0400
Message-ID: <5387359F.7080507@linaro.org>
Date: Thu, 29 May 2014 08:26:55 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, mporter@linaro.org,
        bcm@fixthebug.org, devicetree@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] clk: bcm281xx: add an initialized flag
References: <1400590362-11177-1-git-send-email-elder@linaro.org> <1400590362-11177-2-git-send-email-elder@linaro.org> <20140524003344.23136.68999@quantum>
In-Reply-To: <20140524003344.23136.68999@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 07:33 PM, Mike Turquette wrote:
> Quoting Alex Elder (2014-05-20 05:52:38)
>> Add a flag that tracks whether a clock has already been initialized.
>> This will be used by the next patch to avoid initializing a clock
>> more than once when it's listed as a prerequisite.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>  drivers/clk/bcm/clk-kona.c | 17 +++++++++++++++--
>>  drivers/clk/bcm/clk-kona.h |  7 +++++++
>>  2 files changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
>> index d603c4e..d8a7f38 100644
>> --- a/drivers/clk/bcm/clk-kona.c
>> +++ b/drivers/clk/bcm/clk-kona.c
>> @@ -27,6 +27,9 @@
>>  #define CCU_ACCESS_PASSWORD      0xA5A500
>>  #define CLK_GATE_DELAY_LOOP      2000
>>  
>> +#define clk_is_initialized(_clk)       FLAG_TEST((_clk), KONA, INITIALIZED)
>> +#define clk_set_initialized(_clk)      FLAG_SET((_clk), KONA, INITIALIZED)
>> +
>>  /* Bitfield operations */
>>  
>>  /* Produces a mask of set bits covering a range of a 32-bit value */
>> @@ -1194,13 +1197,23 @@ static bool __peri_clk_init(struct kona_clk *bcm_clk)
>>  
>>  static bool __kona_clk_init(struct kona_clk *bcm_clk)
>>  {
>> +       bool ret;
>> +
>> +       if (clk_is_initialized(bcm_clk))
>> +               return true;
>> +
>>         switch (bcm_clk->type) {
>>         case bcm_clk_peri:
>> -               return __peri_clk_init(bcm_clk);
>> +               ret = __peri_clk_init(bcm_clk);
> 
> Hi Alex,
> 
> Going through this code, it's a bit hard to keep up ;-)

Here's how the structures are organized:
- A Kona clock is either a peripheral or a bus clock,
  but a lot of things are handled generically at the
  Kona level of abstraction.
- A peripheral clock has a selector (mux), up to two
  dividers, and a gate.  All of these are optional.
- A bus clock has a gate, which is optional.  (There
  are a few other things but I'm just ignoring them
  for now.)
- Each of these sort of sub-components (gate, divider,
  etc.) are handled on their own.  In other words, there
  are gate routines that operate on a gate regardless
  of whether it's on bus or peripheral clock.
- These sub-components are grouped like this because
  there are some weird gating requirements.  (I've
  said before I wanted to try to split things off where
  possible to use the common framework code more, but
  that opportunity hasn't arisen yet.)

> Does the call to __peri_clk_init enable the prereq clocks? If so, is
> their clk->prepare_count and clk->enable_count properly incremented?

My use of the term "enable" is imprecise.

The purpose of these *_init() routines is to set the hardware
to a known initial state.  Right now, *defining* what that
state should be has not been sent out for review, but that's
the reason it's set up this way.  The model is basically, when
you want to make a change, you record what the new value should
be and the *_commit() it.  Special values, used at initialization
time, indicate we don't have a desired value but we don't know
what the hardware is currently is set to either.  When those
special values (like BAD_SCALED_DIV_VALUE) are seen, the current
value is read from the hardware rather than written.

Anyway, to (hopefully) answer your question...

All of the prerequisite activity occurs in __kona_clk_init(),
which is called for every Kona clock.  The first thing that
does is call __kona_prereq_init(), in order to set up and
initialize (using __kona_clk_init()) the prerequisite clock
if there is one.

*After* the prerequisite clock is set up, the rest of the
original clock initialization occurs, by calling (e.g.)
__peri_clk_init().

Sorry to be so verbose but I think it helps to understand
the design underlying this stuff.

I'm going to be submitting a new version of this series
today.  It will pull out the clk_lookup field and
some comments that you spotted that are just dead code.

					-Alex

> Thanks,
> Mike
> 
>> +               break;
>>         default:
>> +               ret = false;
>>                 BUG();
>>         }
>> -       return -EINVAL;
>> +       if (ret)
>> +               clk_set_initialized(bcm_clk);
>> +
>> +       return ret;
>>  }
>>  
>>  /* Set a CCU and all its clocks into their desired initial state */
>> diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
>> index 2537b30..10e238d 100644
>> --- a/drivers/clk/bcm/clk-kona.h
>> +++ b/drivers/clk/bcm/clk-kona.h
>> @@ -406,6 +406,7 @@ struct kona_clk {
>>         struct clk_init_data init_data; /* includes name of this clock */
>>         struct ccu_data *ccu;   /* ccu this clock is associated with */
>>         enum bcm_clk_type type;
>> +       u32 flags;              /* BCM_CLK_KONA_FLAGS_* below */
>>         union {
>>                 void *data;
>>                 struct peri_clk_data *peri;
>> @@ -414,6 +415,12 @@ struct kona_clk {
>>  #define to_kona_clk(_hw) \
>>         container_of(_hw, struct kona_clk, hw)
>>  
>> +/*
>> + * Kona clock flags:
>> + *   INITIALIZED       clock has been initialized already
>> + */
>> +#define BCM_CLK_KONA_FLAGS_INITIALIZED ((u32)1 << 0)   /* Clock initialized */
>> +
>>  /* Initialization macro for an entry in a CCU's kona_clks[] array. */
>>  #define KONA_CLK(_ccu_name, _clk_name, _type)                          \
>>         {                                                               \
>> -- 
>> 1.9.1
>>

