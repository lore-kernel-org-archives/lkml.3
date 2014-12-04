Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252AbaLDNgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:36:06 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:50350 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaLDNgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:36:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141204124139.GC8569@quack.suse.cz>
References: <CAA+hA=R2x5dUkZAh9=nHLsmaqA5YiAjEya-vQnjLx6i7fruV1w@mail.gmail.com>
	<20141204124139.GC8569@quack.suse.cz>
Date: Thu, 4 Dec 2014 14:36:03 +0100
Message-ID: <CAPDyKFphwNUUV-e8SuZDEutMCu_a-S9cEP08V0DwUJywa6PtOg@mail.gmail.com>
Subject: Re: WARNING: at fs/fs-writeback.c when plug out SD card after system suspend/resume
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jan Kara <jack@suse.cz>
Cc: Dong Aisheng <dongas86@gmail.com>, Tejun Heo <tj@kernel.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.or>,
        Dong Aisheng-B29396 <b29396@freescale.com>, r64343@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 December 2014 at 13:41, Jan Kara <jack@suse.cz> wrote:
> On Thu 04-12-14 11:43:17, Dong Aisheng wrote:
>> Hi ALL,
>>
>> We met an filesystem issue when do stable kernel upgrade from 3.10.31 to
>> 3.10.53. And we found it's caused by the following commit bf0972039 which
>> introduced in 3.10.53.
>> After applying this patch, after system suspend/resume, plug out a SD card
>> will cause the following WARNING if SD card has a filesystem mounted.
>> If revert it, no such WARNING shows.
>>
>> I also tried the latest linux-next tree, it also has such issue.
>>
>> Looks the patch is used to fixing a potential system crashing.
>> We're not sure whether this WARNING is as expected and reasonable
>> or a BUG because there's no such WARNING before this patch.
>>
>> Can someone explain about it?
>   The warning happens because bdi disappeared from under filesystem (likely
> it was even freed) but filesystem still has references to it. Previously,
> we were just silenly using freed memory, now we warn about it because we
> now clear the BDI_registered bit before freeing the bdi.
>
> So for now the best advice I can give you is: Don't remove device from
> under mounted filesystem (even when the system is suspended). I may easily
> crash your machine.

When you are dealing with removable devices, we can't protect us
against such scenarios.

Moreover, during system suspend phase the mmc block device are not
being removed (even if the physical mmc card gets removed). Instead
that will be handled first when a PM_POST_SUSPEND|HIBERNATION|RESTORE
notifier is received by the mmc subsystem.

Hope that adds some clarify to what goes on here.

Kind regards
Uffe
