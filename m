Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab3HGEe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 00:34:27 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34907 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3HGEeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 00:34:24 -0400
Message-ID: <5201CE7A.40804@gmail.com>
Date: Wed, 07 Aug 2013 12:35:06 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com> <51FDABFD.3070601@gmail.com> <CAMP44s0+VKH_vTRiXvhKz8gGUwAa+_Hgf_dN3UddYE1Z7DLPAA@mail.gmail.com> <1861338.WxIinvfTH6@vostro.rjw.lan> <CAMP44s0EwO11to-nfjhKkUidQKe6h=y0o-V7gYmF_mJeKhMRtQ@mail.gmail.com>
In-Reply-To: <CAMP44s0EwO11to-nfjhKkUidQKe6h=y0o-V7gYmF_mJeKhMRtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2013 10:19 PM, Felipe Contreras wrote:
> On Sun, Aug 4, 2013 at 9:19 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Sunday, August 04, 2013 01:42:49 AM Felipe Contreras wrote:
> 
>>> Personally I think there are better ways to fix the code for the
>>> synthetic case than what you patch does, which will also make _BQC
>>> work. That can be discussed later though, the one-liner is simple, and
>>> it works.
>>
>> So, let's assume that the one-liner goes into 3.11 and work further with that
>> assumption.
>>
>> How would you address the sythetic case (on top of the one-liner)?
> 
> I would write and read two values instead of one. The code is trying
> to check if _BQC is always returning the maximum, and if you try with

The code is introduced by commit a50188dae3089dcd15a6ae793528c157680891f1
where the broken system will always return a constant value for _BQC,
either 0 or 100. So the commit at that time tries to not test a maximum
value for the quirk.

Then we have the ASUS NV56Z problem and its problem is explained in:
https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
And due to its reverse order of _BCL, testing the minimum value is not
good either.

So if the two values test is going to be adopted, I would suggest avoid
testing edge values. But then I'm not sure if it is still worth to test
two values instead of one.

> two values you can be absolutely certain if that's happening or not;
> it doesn't even matter which values you choose. Even in the synthetic
> case that only has two values the check would work correctly and
> detect that _BQC works correctly (or not).
> 
> In my machine I think the issue is slightly different, I think _BCM is
> failing, at least until enabling the _DOS thing, but at the end of the
> day it's the same thing for the check; _BQC is always returning the
> same value, and the code above will find that out, regardless of which
> values are tested.

If you think _BCM fails before _DOS and that makes acpi_video_bqc_quirk
not correct, I think you can call acpi_video_bus_start_devices before the
acpi_video_bus_get_devices in acpi_video_bus_add to make _BCM work before
we do the quirk test and then add some debug prints in acpi_video_bqc_quirk
and add some test levels to check it out.

-Aaron

> 
> For my particular machine though, I think it's more interesting to
> find out why _BCM is failing before _DOS, and why efaa14c made it
> work. If that is actually the case.
