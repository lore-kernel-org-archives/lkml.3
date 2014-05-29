Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669AbaE2SAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:00:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932993AbaE2SAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:00:16 -0400
Message-ID: <538775AB.3000604@suse.de>
Date: Thu, 29 May 2014 20:00:11 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>
CC: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v11 0/3] Exynos 5410 support
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com> <7hr43f9mmn.fsf@paris.lan> <538737CA.4070709@suse.de> <53874862.5080809@samsung.com>
In-Reply-To: <53874862.5080809@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

[shortening the CC list a bit]

Am 29.05.2014 16:46, schrieb Tarek Dakhran:
> On 05/29/2014 05:36 PM, Andreas Färber wrote:
>> Am 27.05.2014 19:06, schrieb Kevin Hilman:
>>> Tarek Dakhran <t.dakhran@samsung.com> writes:
>>>
>>>> Has been tested on: 1) Exynos 5410 reference board (exynos_defconfig)
>>>>             2) Exynos 5410 reference board (multi_v7_defconfig)
>>>>             3) Odroid-XU board (exynos_defconfig)
>>>>             4) Odroid-XU board (multi_v7_defconfig)
>>> Tested-by: Kevin Hilman <khilman@linaro.org>
>>>
>>> FYI, I boot tested this on an odroid-xu (exynos_defconfig and
>>> multi_v7_defconfig.)
>> Could you clarify: Are you using exynos5410-smdk5410.dts with the
>> ODROID-XU or do you have some upcoming exynos5410-odroidxu.dts based on
>> exynos5410.dtsi?
> We use exynos5410-smdk5410.dts for booting ODROID-XU.

Thanks a lot for your work!

I've successfully booted for-next on ODROID-XU using that .dts and
exynos_defconfig plus some systemd and KVM options.

Once I got the following panic:

[    7.579120] Freeing unused kernel memory: 260K (c04f5000 - c0536000)
[    7.647496] Unhandled fault: asynchronous external abort (0x1211) at
0x00000000
[    7.659656] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x00000007
[    7.659656]
[    7.667345] CPU: 0 PID: 1 Comm: init Not tainted
3.15.0-rc4-00074-gca610da #1
[    7.674465] [<c00218b4>] (unwind_backtrace) from [<c001eaa4>]
(show_stack+0x10/0x14)
[    7.682174] [<c001eaa4>] (show_stack) from [<c03a316c>]
(dump_stack+0x80/0xc0)
[    7.689371] [<c03a316c>] (dump_stack) from [<c03a0618>]
(panic+0xa4/0x200)
[    7.696222] [<c03a0618>] (panic) from [<c002c79c>]
(complete_and_exit+0x0/0x1c)
[    7.703503] [<c002c79c>] (complete_and_exit) from [<00000001>] (0x1)
[    7.709844] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x00000007
[    7.709844]

And I reproducibly get failures for CPUs 1-3, resulting in only one CPU
in /proc/cpuinfo (compared to 4 on downstream 3.14):

[    0.045778] CPU: Testing write buffer coherency: ok
[    0.045968] /cpus/cpu@0 missing clock-frequency property
[    0.045993] /cpus/cpu@1 missing clock-frequency property
[    0.046016] /cpus/cpu@2 missing clock-frequency property
[    0.046040] /cpus/cpu@3 missing clock-frequency property
[    0.046059] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.046135] Setting up static identity map for 0x403a8920 - 0x403a8978
[    2.075052] CPU1: failed to come online
[    4.085095] CPU2: failed to come online
[    6.095142] CPU3: failed to come online
[    6.095237] Brought up 1 CPUs
[    6.095269] SMP: Total of 1 processors activated.
[    6.095303] CPU: All CPU(s) started in HYP mode.
[    6.095336] CPU: Virtualization extensions available.

I also notice another apparent device tree issue:

[    7.341814] of_get_named_gpiod_flags: can't parse gpios property of
node '/soc/mmc@12220000/slot@0[0]'
[    7.341850] of_get_named_gpiod_flags: can't parse gpios property of
node '/soc/mmc@12220000/slot@0[0]'

Are any of those known issues and being worked on?
(The CPU failures affected 5420 Arndale Octa as well iirc.)

Some of the low-hanging fruit like no heartbeat/SD LEDs, no RTC, no
usb3503 and thus no network I'm already looking into myself. For now I'm
putting everything into the SMDK .dts, but I guess we'll need to split
off -odroidxu.dts and -pinctrl.dtsi at some point.

What about graphics? The 5410 is an oddball in using PowerVR rather than
Mali GPU - should a framebuffer on HDMI or DisplayPort work if we add DT
nodes, or will the GPU require larger code changes?

Cheers,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
