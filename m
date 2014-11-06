Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaKFCQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 21:16:14 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6961 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaKFCQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:16:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 05 Nov 2014 18:16:56 -0800
Message-ID: <545AD9D9.1010105@nvidia.com>
Date: Thu, 6 Nov 2014 11:15:53 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>
CC: Sachin Kamat <spk.linux@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: Possible regression with commit 52221610d
References: <54584260.8030602@nvidia.com>	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>	<545895B2.2000101@nvidia.com>	<CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>	<5459DB82.9080100@nvidia.com> <CAD7vxxJrsp096TXorWArg9FfpjmzM7+GtfSmzG1hqTA5MrzF3w@mail.gmail.com>
In-Reply-To: <CAD7vxxJrsp096TXorWArg9FfpjmzM7+GtfSmzG1hqTA5MrzF3w@mail.gmail.com>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: DRBGMAIL103.nvidia.com (10.18.16.22) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 12:27 AM, Tim Kryger wrote:
> On Wed, Nov 5, 2014 at 12:10 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> On 11/05/2014 12:31 AM, Tim Kryger wrote:
>>>
>>> On Tue, Nov 4, 2014 at 1:00 AM, Alexandre Courbot <acourbot@nvidia.com>
>>> wrote:
>>>>
>>>> Hi Tim, thanks for your reply!
>>>>
>>>> On 11/04/2014 02:28 PM, Tim Kryger wrote:
>>>>>
>>>>>
>>>>> On Mon, Nov 3, 2014 at 7:05 PM, Alexandre Courbot <acourbot@nvidia.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> Hi guys,
>>>>>>
>>>>>> On the NVIDIA shield (tegra114-roth) platform, I have noticed that MMC
>>>>>> stopped working completely on recent kernels. MMC devices will not show
>>>>>> up
>>>>>> and the message "mmc1: Controller never released inhibit bit(s)." shows
>>>>>> up
>>>>>> repeatedly in the console.
>>>>>>
>>>>>> After bisecting I tracked commit
>>>>>> 52221610dd84dc3e9196554f0292ca9e8ab3541d
>>>>>> ("mmc: sdhci: Improve external VDD regulator support") as the one that
>>>>>> introduced this issue, which seems somehow surprising to me since it
>>>>>> has
>>>>>> been around for a while and nobody else complained about this AFAICT.
>>>>>
>>>>>
>>>>>
>>>>> I'm not too familiar with the Nvidia Shield so can you please confirm
>>>>> the following?
>>>>>
>>>>> The controller in the Tegra114 is SDHCI compliant and as such
>>>>> sdhci_tegra_probe calls sdhci_add_host.  External regulators are
>>>>> sought in sdhci_add_host with a call to mmc_regulator_get_supply.
>>>>
>>>>
>>>>
>>>> This is correct.
>>>>
>>>>> Since no external regulators are specified in tegra114.dtsi or
>>>>> tegra114-roth.dts, mmc->supply.vmmc and mmc->supply.vqmmc are set to
>>>>> -ENODEV.
>>>>
>>>>
>>>>
>>>> Actually 2 of the MMC nodes in tegra114-roth.dts (for SD card and eMMC)
>>>> have
>>>> a vmmc-supply property, so for two of them at least mmc->supply.vmmc is a
>>>> valid pointer.
>>>>
>>>
>>> I must have been looking at an old version of the file.  Thanks for
>>> clearing this up.
>>>
>>>> As explained above, vmmc is a valid pointer for 2 instances of the MMC
>>>> controller. Interestingly, if I just remove the "return" line in the
>>>> IS_ERR() block (without moving it around), the issue also seems to be
>>>> fixed.
>>>>
>>>>>
>>>>> Can you provide the relevant parts of the log before the problem occurs?
>>>>
>>>>
>>>>
>>>> There is not much unfortunately ; the only relevant log I have is this:
>>>>
>>>> [   12.246022] mmc2: Timeout waiting for hardware interrupt.
>>>> [   12.264990] mmc2: Controller never released inhibit bit(s).
>>>>
>>>> Some hardware interrupt timed out. I don't know much about the MMC
>>>> subsystem. but could it be because initially the controller is not in a
>>>> powered-on state, and that return statement causes the function to leave
>>>> it
>>>> unpowered?
>>>
>>>
>>> In a nutshell, the issue here is that the SDHCI spec demands that VMMC
>>> be supplied by the controller itself with the specific voltage
>>> configured using the SDHCI_POWER_CONTROL register but almost nobody
>>> does this.  Many SoCs omit this capability from their controllers and
>>> instead rely upon external regulators.  In such cases there isn't
>>> normally any need to update the voltage bits of the power control
>>> register.  It sounds like you are saying this isn't true for the
>>> Tegra114.
>>
>>
>> Thanks for your explanation, it makes sense now.
>>
>> Looking at other Tegra boards .dts I noticed that SHIELD is the only one
>> using a vmmc-supply. Maybe this is the part that is wrong? I wrote this DTS
>> and cannot exclude I misread the schematics. Maybe that regulator is used
>> for some other (still sdmmc-related) purpose but the actual power provider
>> is the controller itself.
>>
>> If you can confirm that the driver is performing as it should, I will look
>> in that direction and revise my DTS.
>
> I believe it is working as intended.  Is the schematic publicly available?

Sadly, no. But it is built similarly to other T114 boards, so I have to 
assume the error is mine here. I will come back to this thread if it 
turns out it is not.

Thanks for your help!
