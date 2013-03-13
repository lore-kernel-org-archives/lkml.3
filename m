Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3CMEmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 00:42:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45008 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3CMEmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 00:42:31 -0400
Message-ID: <514003B6.8020904@wwwdotorg.org>
Date: Tue, 12 Mar 2013 22:42:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [RFC 1/1] clk: Add notifier support in clk_prepare_enable/clk_disable_unprepare
References: <1363091861-21534-1-git-send-email-bilhuang@nvidia.com>  <20130312134032.GU4977@n2100.arm.linux.org.uk> <1363139273.21694.11.camel@bilhuang-vm1>
In-Reply-To: <1363139273.21694.11.camel@bilhuang-vm1>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 07:47 PM, Bill Huang wrote:
> On Tue, 2013-03-12 at 21:40 +0800, Russell King - ARM Linux wrote:
>> On Tue, Mar 12, 2013 at 05:37:41AM -0700, Bill Huang wrote:
>>> Add the below four notifier events so drivers which are interested in
>>> knowing the clock status can act accordingly. This is extremely useful
>>> in some of the DVFS (Dynamic Voltage Frequency Scaling) design.
>>>
>>> PRE_CLK_ENABLE
>>> POST_CLK_ENABLE
>>> PRE_CLK_DISABLE
>>> POST_CLK_DISABLE
>>>
>>> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
>>
>> NAK.  *Sigh* NO, this is the wrong level to be doing stuff like this.
>>
>> The *ONLY* thing that clk_prepare_enable() and clk_prepare_disable() should
>> *EVER* be doing is calling clk_prepare(), clk_enable(), clk_disable() and
>> clk_unprepare().  Those two functions are *merely* helpers for drivers
>> who don't wish to make the individual calls.
>>
>> Drivers are still completely free to call the individual functions, at
>> which point your proposal breaks horribly - and they _do_ call the
>> individual functions.
>
> I'm proposing to give device driver a choice when it knows that some
> driver might be interested in knowing its clock's enabled/disabled state
> change at runtime, this is very important for centralized DVFS core
> driver. It is not meant to be covering all cases especially for drivers
> which is not part of the DVFS, so we don't care if it is calling
> clk_enable/disable directly or not.

I believe the point Russell is making is not that the idea behind this
patch is wrong, but simply that the function where you put the hooks is
wrong. The hooks should at least be in clk_enable/clk_disable and not
clk_prepare_enable/clk_disable_unprepare, since any driver is free to
call clk_prepare separately from clk_enable. The hooks should be
implemented in the lowest-level common function that all
driver-accessible paths call through.
