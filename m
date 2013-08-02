Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab3HBGoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:44:55 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49426 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3HBGox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <51FB3C9C.6070002@intel.com>
References: <1375400042-989-1-git-send-email-felipe.contreras@gmail.com>
	<51FB137D.7070000@gmail.com>
	<CAMP44s1A+z4=DGJLK1qf5LPc1vbYvtJwjFiMt17vzyZFRU0qmg@mail.gmail.com>
	<51FB35CD.7040709@intel.com>
	<CAMP44s1honSdnoMnmpEcsXtdkJuPYgQgnLwcN+oxs5f=a+3Stg@mail.gmail.com>
	<51FB3C9C.6070002@intel.com>
Date: Fri, 2 Aug 2013 01:44:51 -0500
Message-ID: <CAMP44s1RkwTfxdoiARHgREy-fwLuRu2tKbM-4kB3+Xf3Sme5Uw@mail.gmail.com>
Subject: Re: [PATCH] acpi: video: fix reversed indexed BQC
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 11:59 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> On 08/02/2013 12:50 PM, Felipe Contreras wrote:
>> On Thu, Aug 1, 2013 at 11:30 PM, Aaron Lu <aaron.lu@intel.com> wrote:

>>> Please see acpi_video_bqc_quirk, we set _BQC_use_index by revert the
>>> level on a reversed _BCL, so we will need to revert level here too.
>>
>> I cannot parse that sentence, but nothing needs to change there; to
>> find out if _BQC is using an index, we need to see if the returned
>> value is the index of the level we are looking for, and to find that
>> out we need the original list of levels, which can be found by
>> reverting the already reverted list. If this wasn't the case there
>
> Yes, but instead of reverting the already reverted list, we revert the
> returned value to get the correct index in the reverted list. But your
> patch removes the revert, is it correct?

It removes the revert in acpi_video_bqc_value_to_level(), not
acpi_video_bqc_quirk(). If I remove both reverts it doesn't work on
this machine, however, I think it works by accident.

The initial _BCM commands don't work, so the level remains at 100%.
Since the level is max_level, acpi_video_bqc_quirk() tries with the
first level, which is 0, and 0 happens to be the index of 100.

So _BQC is returning 100, which is not the index of 0 (what we tested
for), but actually 100.

I think the current code is correct, but acpi_video_bqc_quirk() should
be testing br->levels[3], or anything other than 0/100 which can be
easily confused.

If so, the code would find that _BQC doesn't work on this machine (in
win8 mode)... at least initially. My guess is that it only starts to
work after acpi_video_bus_start_devices() is called.

Forcing br->flags._BQC_use_index = 0 seems to work.

-- 
Felipe Contreras
