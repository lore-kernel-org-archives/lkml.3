Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab3HBGzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:55:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:10884 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754751Ab3HBGzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,799,1367996400"; 
   d="scan'208";a="340536976"
Message-ID: <51FB5826.80305@intel.com>
Date: Fri, 02 Aug 2013 14:56:38 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: fix reversed indexed BQC
References: <1375400042-989-1-git-send-email-felipe.contreras@gmail.com> <51FB137D.7070000@gmail.com> <CAMP44s1A+z4=DGJLK1qf5LPc1vbYvtJwjFiMt17vzyZFRU0qmg@mail.gmail.com> <51FB35CD.7040709@intel.com> <CAMP44s1honSdnoMnmpEcsXtdkJuPYgQgnLwcN+oxs5f=a+3Stg@mail.gmail.com> <51FB3C9C.6070002@intel.com> <CAMP44s1RkwTfxdoiARHgREy-fwLuRu2tKbM-4kB3+Xf3Sme5Uw@mail.gmail.com>
In-Reply-To: <CAMP44s1RkwTfxdoiARHgREy-fwLuRu2tKbM-4kB3+Xf3Sme5Uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 02:44 PM, Felipe Contreras wrote:
> On Thu, Aug 1, 2013 at 11:59 PM, Aaron Lu <aaron.lu@intel.com> wrote:
>> On 08/02/2013 12:50 PM, Felipe Contreras wrote:
>>> On Thu, Aug 1, 2013 at 11:30 PM, Aaron Lu <aaron.lu@intel.com> wrote:
> 
>>>> Please see acpi_video_bqc_quirk, we set _BQC_use_index by revert the
>>>> level on a reversed _BCL, so we will need to revert level here too.
>>>
>>> I cannot parse that sentence, but nothing needs to change there; to
>>> find out if _BQC is using an index, we need to see if the returned
>>> value is the index of the level we are looking for, and to find that
>>> out we need the original list of levels, which can be found by
>>> reverting the already reverted list. If this wasn't the case there
>>
>> Yes, but instead of reverting the already reverted list, we revert the
>> returned value to get the correct index in the reverted list. But your
>> patch removes the revert, is it correct?
> 
> It removes the revert in acpi_video_bqc_value_to_level(), not
> acpi_video_bqc_quirk(). If I remove both reverts it doesn't work on

Of course I mean you remove the revert in acpi_video_bqc_value_to_level
as is shown in your patch.

> this machine, however, I think it works by accident.
> 
> The initial _BCM commands don't work, so the level remains at 100%.
> Since the level is max_level, acpi_video_bqc_quirk() tries with the
> first level, which is 0, and 0 happens to be the index of 100.
> 
> So _BQC is returning 100, which is not the index of 0 (what we tested
> for), but actually 100.
> 
> I think the current code is correct, but acpi_video_bqc_quirk() should
> be testing br->levels[3], or anything other than 0/100 which can be
> easily confused.
> 
> If so, the code would find that _BQC doesn't work on this machine (in
> win8 mode)... at least initially. My guess is that it only starts to
> work after acpi_video_bus_start_devices() is called.
> 
> Forcing br->flags._BQC_use_index = 0 seems to work.

Seems ASUS machines tend to have this issue:
https://bugzilla.kernel.org/show_bug.cgi?id=52951
https://bugzilla.kernel.org/show_bug.cgi?id=56711

I have a patch to enhance the quirk some time ago:
https://github.com/aaronlu/linux/commit/0a3d2c5b59caf80ae5bb1ca1fda0f7bf448b38c9
But at that time we have decided to remove acpi video interface if this
is a win8 system(all of these affected systems are win8), so I didn't
submit it. Can you please give it a test? Perhaps I can send it now.

-Aaron
