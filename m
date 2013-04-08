Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934915Ab3DHG1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 02:27:38 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:38009 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3DHG1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 02:27:37 -0400
Message-ID: <51626355.8060000@gmail.com>
Date: Mon, 08 Apr 2013 08:27:33 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: add helper to set flags for clk-provider
References: <1365139332-17775-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130408035958.14359.85310@quantum>
In-Reply-To: <20130408035958.14359.85310@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 05:59 AM, Mike Turquette wrote:
> Quoting Sebastian Hesselbarth (2013-04-04 22:22:12)
>> Clock providers are not allowed to mess with struct clk internals directly
>> but using helpers provided by clk-provider.h. This patch adds a helper to
>> allow to set flags of a clock after registration. This is useful, if clock
>> flags change during runtime, e.g. ability to set parent clock after mux
>> switch.
>
> Hi Sebastian,
>
> I do not like this change.  There are a few reasons why.  Firstly the
> clk flags have never been advertised as changing at runtime.  On that
> note, can you expand your example of "ability to set parent clock after
> mux switch"?  I do not follow what you mean.

Mike,

I knew you wouldn't like it. I just wanted to raise this discussion.

Consider a clock mux like in si5351 where each output clock can be muxed
to either it's own pll clock divider, the pll clock divider of clk0,
xtal, or clkin. And consider you want to allow to configure the mux at
runtime (si5351 driver doesn't, but just think about it).

Now, for it's own pll clock divider you want CLK_SET_PARENT_RATE while
for clk0's pll clock divider you want ~CLK_SET_PARENT_RATE because it
will break clk0's output rate. How can you have two sets of flags in the
current API?

> Secondly, it is possible to need flags during __clk_init.  This exists
> today for root clocks that use the CLK_IS_ROOT flag.  So setting that
> flag after registration is too late.

Sure, but some others work just fine if you change them during runtime.

> Finally, how can we make sure that this api is not abused?  I'm
> concerned about drivers which use __clk_set_flags in a hacky way, when
> in fact the flags are supposed to be permanent properties of that clock.

How can you ever make sure, the API is not abused? For the si5351 patch
at least, you pointed out not to use clk-private.h and now rejected v5
again.

I am asking, if those clock flags are really permanent properties? Not
that any current driver uses this, but especially clk muxes are meant
to switch to another clock that may have/require different flags.

> Do you truly need the ability to change clock flags at runtime, or do
> you instead need a way to express flags in DT?  I'm sure the clock
> bindings are not the first binding to run up against flags or properties
> that do not strictly match the hardware description.  Maybe solving that
> problem is the right way?

Of course, I can parse the flags prior registration and store them in
some struct. I was just re-working v4 of si5351 patch and wanted this
discussion first.

Sebastian
