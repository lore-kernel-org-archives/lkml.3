Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3FDRpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:45:45 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50121 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3FDRpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:45:43 -0400
MIME-Version: 1.0
In-Reply-To: <51AE1FBB.1070806@codeaurora.org>
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org>
	<1370281990-15090-4-git-send-email-mturquette@linaro.org>
	<51AE1FBB.1070806@codeaurora.org>
Date: Tue, 4 Jun 2013 12:39:53 -0500
Message-ID: <CAHCPf3tZAbdVZPuKOjxJbCOAE76Pa6wMVHjnBRPhSpj0aMBMHg@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] clk: dt: binding for basic divider clock
From: Matt Sealey <neko@bakuhatsu.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 12:11 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 06/03/13 10:53, Mike Turquette wrote:
>> +Required properties:
>> +- compatible : shall be "divider-clock".
>> +- #clock-cells : from common clock binding; shall be set to 0.
>> +- clocks : link to phandle of parent clock
>> +- reg : base address for register controlling adjustable divider
>> +- mask : arbitrary bitmask for programming the adjustable divider
>> +
>> +Optional properties:
>> +- clock-output-names : From common clock binding.
>> +- table : array of integer pairs defining divisors & bitfield values
>> +- shift : number of bits to shift the mask, defaults to 0 if not present
>> +- index_one : valid divisor programming starts at 1, not zero
>> +- index_power_of_two : valid divisor programming must be a power of two
>> +- allow_zero : implies index_one, and programming zero results in
>> +  divide-by-one
>
> It's preferred that property names have dashes instead of underscores.

I think I have a suggestion or two here..

I mailed one to Mike earlier, I have had some mailing list problems
which I think are solved now..

If you provide a mask for programming the divider, surely the "shift"
property is therefore redundant. Unless some device has a completely
strange way of doing things and uses two seperated bitfields for
programming in the same register, the shift value is simply a function
of ffs() on the mask, isn't it? It is nice to put the information
specifically in the device tree, but where a shift is not specified
it'd probably be a good idea to go about deriving that value that way
anyway, right, and if we're doing that.. why specify it?

Also it may be much simpler to simply define the default clock setup
as being an integer divider that follows the form 2^n - I am not sure
I can think off the top of my head of any clock dividers doing the
rounds that have divide-by-non-power-of-two and if they exist out
there (please correct me) they would be the rare ones. I think
properties that modify behavior should err on the side of being rarely
used and to define unusual behavior, not confirm the status quo.

Just to be sure, though, someone would need to go visit a bunch of
current clock handlers already implemented or read a lot of docs to
see how they're expecting their dividers. Maybe some of the Samsung,
Qualcomm, TI, Freescale guys can comment on what is the most common
case inside their SoCs.

In any case, once you figure out that, rather than specifying a full
table of <0 1>, <1 2>, <2, 4> and creating a big list, you could just
give the lower and upper limits and let the driver figure out what is
in between with two values. If there were gaps, a full table would be
necessary. The allow zero property might be better served by the very
same range property.

I would also say.. bit-mask rather than mask, divider-table rather
than table, divider-range (modifying the idea above). While we're
inside a particular namespace in the binding I think naming properties
with their intent (i.e. what table is it?) is good behavior.

--
Matt Sealey <matt@genesi-usa.com>
