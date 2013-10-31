Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3JaUpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 16:45:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42165 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3JaUpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 16:45:14 -0400
Message-ID: <5272C156.30007@wwwdotorg.org>
Date: Thu, 31 Oct 2013 14:45:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing [CPU hotplug
 clockevents issue]
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1381869563-16083-5-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1381869563-16083-5-git-send-email-grant.likely@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 02:39 PM, Grant Likely wrote:
> All the users of of_irq_parse_raw pass in a raw interrupt specifier from
> the device tree and expect it to be returned (possibly modified) in an
> of_phandle_args structure. However, the primary function of
> of_irq_parse_raw() is to check for translations due to the presence of
> one or more interrupt-map properties. The actual placing of the data
> into an of_phandle_args structure is trivial. If it is refactored to
> accept an of_phandle_args structure directly, then it becomes possible
> to consume of_phandle_args from other sources. This is important for an
> upcoming patch that allows a device to be connected to more than one
> interrupt parent. It also simplifies the code a bit.
> 
> The biggest complication with this patch is that the old version works
> on the interrupt specifiers in __be32 form, but the of_phandle_args
> structure is intended to carry it in the cpu-native version. A bit of
> churn was required to make this work. In the end it results in tighter
> code, so the churn is worth it.

This commit appears to cause kernel error spew while performing CPU
hotplug operations on Tegra114. For example, see the log at the end of
this message.

I guess this boot-time message is the clue:

[    0.000000] arch_timer: No interrupt available, giving up

which corresponds to this diff in /proc/interrupts:

> - 27:       2929       2216       2027       1922       GIC  27  arch_timer

The relevant DT node is probably:

>         timer {
>                 compatible = "arm,armv7-timer";
>                 interrupts =
>                         <GIC_PPI 13
>                                 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
>                         <GIC_PPI 14
>                                 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
>                         <GIC_PPI 11
>                                 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
>                         <GIC_PPI 10
>                                 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
>         };

I guess this is a similar problem to that which Olof reported; there's
no reg property in that node, yet #size-cells=<0> since the timer node
is a direct child of the root node.

Hotplug error spew:

> root@localhost:~# ./cpuonline.py 
> echo 0 > /sys/devices/system/cpu/cpu2/online
> [   46.753347] CPU2: shutdown
> echo 0 > /sys/devices/system/cpu/cpu1/online
> [   48.848007] CPU1: shutdown
> echo 0 > /sys/devices/system/cpu/cpu3/online
> [   50.897720] CPU3: shutdown
> echo 1 > /sys/devices/system/cpu/cpu1/online
> [   52.949980] CPU1: Booted secondary processor
> [   52.961188] Clockevents: could not switch to one-shot mode: dummy_timer is not functional.
> [   52.969566] Could not switch to high resolution mode on CPU 1
> echo 1 > /sys/devices/system/cpu/cpu2/online
> [   54.999852] CPU2: Booted secondary processor
> [   55.011164] Clockevents: could not switch to one-shot mode: dummy_timer is not functional.
> [   55.019543] Could not switch to high resolution mode on CPU 2
> echo 0 > /sys/devices/system/cpu/cpu1/online
> [   57.048730] CPU1: shutdown
> echo 1 > /sys/devices/system/cpu/cpu3/online
> [   59.088927] CPU3: Booted secondary processor
> [   59.101149] Clockevents: could not switch to one-shot mode: dummy_timer is not functional.
> [   59.109517] Could not switch to high resolution mode on CPU 3
> echo 1 > /sys/devices/system/cpu/cpu1/online
> [   61.129737] CPU1: Booted secondary processor
> [   61.141161] Clockevents: could not switch to one-shot mode: dummy_timer is not functional.
> [   61.149540] Could not switch to high resolution mode on CPU 1

