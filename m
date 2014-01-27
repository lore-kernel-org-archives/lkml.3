Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaA0SVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:21:45 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50725 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbaA0SVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:21:43 -0500
Message-ID: <52E6A3B2.6060301@gmail.com>
Date: Mon, 27 Jan 2014 19:21:38 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140127153908.4f6f46c2@skate>
In-Reply-To: <20140127153908.4f6f46c2@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/14 15:39, Thomas Petazzoni wrote:
> On Sat, 25 Jan 2014 19:19:06 +0100, Sebastian Hesselbarth wrote:
>> This patch set fixes clk init order that went upside-down with
>> v3.14. I haven't really investigated what caused this, but I assume
>> it is related with DT node reordering by addresses.
>>
>> Anyway, with v3.14 for MVEBU SoCs, the clock gating driver gets
>> registered before core clocks driver. Unfortunately, we cannot
>> return -EPROBE_DEFER in drivers initialized by clk_of_init. As the
>> init order for our drivers is always core clocks before clock gating,
>> we maintain init order ourselves by hooking CLK_OF_DECLARE to one
>> init function that will register core clocks before clock gating
>> driver.
>>
>> This patch is based on pre-v3.14-rc1 mainline and should go in as
>> fixes for it. As we now send MVEBU clk pull-requests to Mike directly,
>> I suggest Jason picks it up as a topic branch.
>
> I'm not sure I really like the solution you're proposing here. I'd very
> much prefer to keep one CLK_OF_DECLARE() per clock type, associated to
> one function registering only this clock type.

Have you ever had a look at e.g. clk-imx28.c? Not that I really like
the approach, but it is common practice to do so.

> Instead, shouldn't the clock framework be improved to *not* register a
> clock until its parent have been registered? If the DT you have the
> gatable clocks that depend on the core clocks, then the gatable clocks
> should not be registered if the core clocks have not yet been
> registered.
>
> Do you think this is possible? Am I missing something here?

As I said, clk_of_init does not care about return values from the
clock init functions. Without it, it cannot decide if a clock
driver failed horribly, failed because of missing dependencies, or
successfully installed all clocks. Also, it is early stuff and I guess
clk_of_init will have to build its own "defered_list" and loop over
until done.

BTW, this is a fix not an improvement. We should find an acceptable
solution soon. But I am still open for suggestions, too.

Sebastian

