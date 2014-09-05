Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbaIEK4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:56:06 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:49775 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbaIEK4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:56:04 -0400
Message-ID: <540996B1.4010300@kapsi.fi>
Date: Fri, 05 Sep 2014 13:55:45 +0300
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu@tomeuvizoso.net>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 0/8] Tegra124 EMC (external memory controller) support
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <53FB7511.9090205@wwwdotorg.org> <53FC3A5D.8030708@nvidia.com> <CAAObsKABUa9xD+hntyv97ZQB7Bk05kN0h0-+H7Q9ks6RT0yV2Q@mail.gmail.com>
In-Reply-To: <CAAObsKABUa9xD+hntyv97ZQB7Bk05kN0h0-+H7Q9ks6RT0yV2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, the structure the EMC series currently takes (in my local branch) 
is as follows:
- clock implementation in CAR code. This just knows about allowed rates 
and which parents should have them and handles reparenting when required.
- memory/tegra124-emc: this contains the EMC rate change sequence and 
exports an API which the clock driver uses.
- memory/tegra124-mc: contains API to write registers in MC memory 
space, used by memory/tegra124-emc.

(I decided that this is cleaner than having a huge EMC driver that uses 
an API exported by CAR)

I'm not sure if adding the bandwidth management code to the clock or 
memory/emc driver would be best. But we can decide that later.

I need to clean up the series after the big refactorings; I'll submit a 
new version once that's done.

Mikko

(P.S. my internship ended so I'm using this address now)

On 09/05/2014 01:22 PM, Tomeu Vizoso wrote:
> On 26 August 2014 09:42, Mikko Perttunen <mperttunen@nvidia.com> wrote:
>> On 25/08/14 20:40, Stephen Warren wrote:
>>>
>>> On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
>>>>
>>>> Hi everyone,
>>>>
>>>> this series adds support for the EMC (external memory controller) clock
>>>> in the Tegra124 system-on-chip. The series has been tested on Jetson TK1.
>>>>
>>>> The first two patches remove the old "emc_mux" and "emc" clocks from the
>>>> clock tree and the device tree bindings. This is, of course, not
>>>> backwards
>>>> compatible, but as these clocks have never been useful for anything
>>>> (apart from maybe reading the boot rate of the EMC clock). If this is
>>>> still
>>>> not acceptable, the second patch can be dropped.
>>>
>>> ...
>>>
>>> Mikko, this series had some comments, especially on the DT binding
>>> (patch 5/8) and how the MC/EMC drivers interact. Is there an updated
>>> version of the series? Or, is the series replaced by Tomeu Vizoso's work?
>>
>>
>> Yes, I have a v2 with these comments addressed. One concern, though, is the
>> part writing to CLK_SOURCE_EMC. If some other driver also wants to read this
>> register (MC, likely), we might need to have an API for it in the CAR
>> driver. On the other hand, maybe not, since it's only one register. Thierry?
>>
>> Another point is that v2 adds a new API to the MC driver, which also doesn't
>> exist yet. The EMC driver can technically work without the MC driver (but
>> with a header for MC added), but I'm not sure the result would be very
>> useful.
>>
>> I believe the plan is that Tomeu's EMC code will be integrated into this EMC
>> driver once both are ready.
>
> That's mostly right. My clk constraints series just allow consumers to
> influence the effective rate of a clock, such as the EMC. And the
> pm_qos series will allow to track the total memory bandwidth needs in
> the system. I'm not sure yet where in the code this tracking will be
> done. It could be done in an EMC driver in drivers/memory, but it's
> probably too unrelated to be placed in the EMC clock driver.
>
> Regards,
>
> Tomeu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

