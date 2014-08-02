Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaHBWQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 18:16:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57670 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaHBWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 18:16:18 -0400
Message-ID: <53DD632D.6070308@gmail.com>
Date: Sun, 03 Aug 2014 00:16:13 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        Marek Szyprowski <m.szyprowski@samsung.com>, loeliger@gmail.com
Subject: Re: [PATCH v3 1/7] ARM: l2c: Refactor the driver to use commit-like
 interface
References: <1405615142-21426-1-git-send-email-t.figa@samsung.com> <1405615142-21426-2-git-send-email-t.figa@samsung.com> <20140802220940.GW3705@n2100.arm.linux.org.uk>
In-Reply-To: <20140802220940.GW3705@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.08.2014 00:09, Russell King - ARM Linux wrote:
> On Thu, Jul 17, 2014 at 06:38:56PM +0200, Tomasz Figa wrote:
>> Certain implementations of secure hypervisors (namely the one found on
>> Samsung Exynos-based boards) do not provide access to individual L2C
>> registers. This makes the .write_sec()-based interface insufficient and
>> provoking ugly hacks.
>>
>> This patch is first step to make the driver not rely on availability of
>> writes to individual registers. This is achieved by refactoring the
>> driver to use a commit-like operation scheme: all register values are
>> prepared first and stored in an instance of l2x0_regs struct and then a
>> single callback is responsible to flush those values to the hardware.
> 
> This isn't going to work very well...
> 
>> +static const struct l2c_init_data *l2x0_data;
> 
> So you keep a pointer to the init data...
> 
>> +static void l2c_resume(void)
>> +{
>> +	l2x0_data->enable(l2x0_base, l2x0_saved_regs.aux_ctrl,
>> +				l2x0_data->num_lock);
> 
> which you dereference at resume time...
> 
>>  static const struct l2c_init_data l2c210_data __initconst = {
> 
> but the structures which get assigned to the pointer are marked __initconst.

Good catch. The code was tested on Exynos which requires the cache to be
resumed from early assembly code and so I did not hit issues caused by this.

Proposed solution: kmemdup() in init, so that only used data remain in
memory and the structures can be kept __initconst.

Best regards,
Tomasz
