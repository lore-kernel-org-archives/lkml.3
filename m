Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaAYVop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 16:44:45 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43948 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaAYVoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 16:44:44 -0500
Message-ID: <52E43046.1030105@gmail.com>
Date: Sat, 25 Jan 2014 22:44:38 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
To: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] clk: mvebu: fix clk init order
References: <1390673950-4521-1-git-send-email-sebastian.hesselbarth@gmail.com> <52E42D6A.5050508@elopez.com.ar>
In-Reply-To: <52E42D6A.5050508@elopez.com.ar>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2014 10:32 PM, Emilio López wrote:
> El 25/01/14 15:19, Sebastian Hesselbarth escribió:
>> This patch set fixes clk init order that went upside-down with
>> v3.14. I haven't really investigated what caused this, but I assume
>> it is related with DT node reordering by addresses.
>
> The framework should be able to deal with unordered registration. I am
> not very familiar with the mvebu driver though, do you have a valid
> reason to require a specific order?

Emilio,

I rather think that everthing registered with CLK_OF_DECLARE cannot
deal with unordered registration. The callback passed to CLK_OF_DECLARE
has to have void as return value, so there is no way to pass errors,
e.g. -EPROBE_DEFER, back to of_clk_init.

The reason for this ordering is that the clock gates depend on core
clocks. It is always that way, so merging both init functions isn't
that odd.

>> Anyway, with v3.14 for MVEBU SoCs, the clock gating driver gets
>> registered before core clocks driver. Unfortunately, we cannot
>> return -EPROBE_DEFER in drivers initialized by clk_of_init.
>
> Why would you need to do so? After a quick inspection on the code, I see
> you may have problems on mvebu_clk_gating_setup() when getting the
> default parent clock name, but I believe you could solve it in an easier
> way by using of_clk_get_parent_name().

Ok, I'll look if using of_clk_get_parent_name will help here. But again,
I can see that clk-gating driver gets registered before core-clk driver.
There may be no code to give you the parent name at that time.

Sebastian

