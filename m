Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbbASRZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 12:25:14 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43244 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbASRZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 12:25:12 -0500
Message-ID: <54BD3E3E.2040801@wwwdotorg.org>
Date: Mon, 19 Jan 2015 10:26:22 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra20: Store CPU "resettable" status in IRAM
References: <1421319545-23920-1-git-send-email-digetx@gmail.com> <1421319545-23920-2-git-send-email-digetx@gmail.com> <20150119141224.GF23778@ulmo.nvidia.com>
In-Reply-To: <20150119141224.GF23778@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2015 07:12 AM, Thierry Reding wrote:
> On Thu, Jan 15, 2015 at 01:58:57PM +0300, Dmitry Osipenko wrote:
>> Commit 7232398abc6a ("ARM: tegra: Convert PMC to a driver") changed tegra_resume()
>> location storing from late to early and, as a result, broke suspend on Tegra20.
>> PMC scratch register 41 is used by tegra LP1 resume code for retrieving stored
>> physical memory address of common resume function and in the same time used by
>> tegra20_cpu_shutdown() (shared by Tegra20 cpuidle driver and platform SMP code),
>> which is storing CPU1 "resettable" status. It implies strict order of scratch
>> register usage, otherwise resume function address is lost on Tegra20 after
>> disabling non-boot CPU's on suspend. Fix it by storing "resettable" status in
>> IRAM instead of PMC scratch register.
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
>> Fixes: 7232398abc6a (ARM: tegra: Convert PMC to a driver)
>> Cc: <stable@vger.kernel.org> # v3.17+
>> ---
>>   arch/arm/mach-tegra/cpuidle-tegra20.c |  5 ++---
>>   arch/arm/mach-tegra/reset-handler.S   | 10 +++++++---
>>   arch/arm/mach-tegra/reset.h           |  4 ++++
>>   arch/arm/mach-tegra/sleep-tegra20.S   | 37 ++++++++++++++++++++---------------
>>   arch/arm/mach-tegra/sleep.h           |  4 ++++
>>   5 files changed, 38 insertions(+), 22 deletions(-)
>
> I'm leaning towards applying this. Stephen, Alex, Peter: any objections?

Hopefully this works out. I suppose it's unlikely anyone will be running 
code on the AVP upstrem, so any potential conflict with AVP's usage of 
IRAM isn't likely to occur.

__tegra20_cpu1_resettable_status_offset has a lot of _ at the start. 
Should the symbol be named more normally? I guess at least it's 
consistent with the existing very "underscory" 
__tegra_cpu_reset_handler_start.
