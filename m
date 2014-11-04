Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaKDPbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:31:37 -0500
Received: from mail-oi0-f43.google.com ([209.85.218.43]:45738 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaKDPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:31:35 -0500
MIME-Version: 1.0
In-Reply-To: <545895B2.2000101@nvidia.com>
References: <54584260.8030602@nvidia.com>
	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>
	<545895B2.2000101@nvidia.com>
Date: Tue, 4 Nov 2014 07:31:34 -0800
Message-ID: <CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>
Subject: Re: Possible regression with commit 52221610d
From: Tim Kryger <tim.kryger@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Sachin Kamat <spk.linux@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 1:00 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Hi Tim, thanks for your reply!
>
> On 11/04/2014 02:28 PM, Tim Kryger wrote:
>>
>> On Mon, Nov 3, 2014 at 7:05 PM, Alexandre Courbot <acourbot@nvidia.com>
>> wrote:
>>>
>>> Hi guys,
>>>
>>> On the NVIDIA shield (tegra114-roth) platform, I have noticed that MMC
>>> stopped working completely on recent kernels. MMC devices will not show
>>> up
>>> and the message "mmc1: Controller never released inhibit bit(s)." shows
>>> up
>>> repeatedly in the console.
>>>
>>> After bisecting I tracked commit 52221610dd84dc3e9196554f0292ca9e8ab3541d
>>> ("mmc: sdhci: Improve external VDD regulator support") as the one that
>>> introduced this issue, which seems somehow surprising to me since it has
>>> been around for a while and nobody else complained about this AFAICT.
>>
>>
>> I'm not too familiar with the Nvidia Shield so can you please confirm
>> the following?
>>
>> The controller in the Tegra114 is SDHCI compliant and as such
>> sdhci_tegra_probe calls sdhci_add_host.  External regulators are
>> sought in sdhci_add_host with a call to mmc_regulator_get_supply.
>
>
> This is correct.
>
>> Since no external regulators are specified in tegra114.dtsi or
>> tegra114-roth.dts, mmc->supply.vmmc and mmc->supply.vqmmc are set to
>> -ENODEV.
>
>
> Actually 2 of the MMC nodes in tegra114-roth.dts (for SD card and eMMC) have
> a vmmc-supply property, so for two of them at least mmc->supply.vmmc is a
> valid pointer.
>

I must have been looking at an old version of the file.  Thanks for
clearing this up.

> As explained above, vmmc is a valid pointer for 2 instances of the MMC
> controller. Interestingly, if I just remove the "return" line in the
> IS_ERR() block (without moving it around), the issue also seems to be fixed.
>
>>
>> Can you provide the relevant parts of the log before the problem occurs?
>
>
> There is not much unfortunately ; the only relevant log I have is this:
>
> [   12.246022] mmc2: Timeout waiting for hardware interrupt.
> [   12.264990] mmc2: Controller never released inhibit bit(s).
>
> Some hardware interrupt timed out. I don't know much about the MMC
> subsystem. but could it be because initially the controller is not in a
> powered-on state, and that return statement causes the function to leave it
> unpowered?

In a nutshell, the issue here is that the SDHCI spec demands that VMMC
be supplied by the controller itself with the specific voltage
configured using the SDHCI_POWER_CONTROL register but almost nobody
does this.  Many SoCs omit this capability from their controllers and
instead rely upon external regulators.  In such cases there isn't
normally any need to update the voltage bits of the power control
register.  It sounds like you are saying this isn't true for the
Tegra114.
