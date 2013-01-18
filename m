Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3ARWhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:37:14 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:64022 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3ARWhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:37:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
References: <CA+55aFx5ZyFtd59ygn6ja5X-3ZyRvhfJLqtNKyF_mH3+-kSjKg@mail.gmail.com>
	<CAKocOOPr4wddCmDEWKmsKsKeTc3m779opuN_qRb4yiL63KVZ8A@mail.gmail.com>
Date: Fri, 18 Jan 2013 15:37:11 -0700
Message-ID: <CAKocOOPp1PA-n_=xdPuBSBKaKiREqhgeo02QqWpP-oX7vnN_YA@mail.gmail.com>
Subject: Re: Linux 3.8-rc4
From: Shuah Khan <shuahkhan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, alexander.deucher@amd.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:51 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Thu, Jan 17, 2013 at 8:51 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Hey, it's been another week already! In fact, it took me so much by
>> surprise that it's been an extra day. The whole "release in the middle
>> of the week" thing feels odd to me.
>>
>> [ That actually got me to wonder what the most common day was, and
>> statistically I definitely do most releases on Sunday. The "git tip of
>> the week" looks like this:
>>
>>     git log --no-walk --pretty="%ad" $(git tag -l)
>>
>>   which can then be piped into
>>
>>     cut -d' ' -f1 | sort | uniq -c | sort -n
>>
>>   to see the full git tagging statistics ]
>>
>> Anyway, with that digression, I can happily report that -rc4 is
>> smaller than -rc3 despite the extra day, although not by much. There's
>> not really a whole lot that stands out: apart from one new wireless
>> driver (the Atheros Wilocity driver) and some OMAP drm changes, the
>> diffstat looks pretty flat and spread out. Which just means lots of
>> small changes all over.
>>
>> The ShortLog is appended, but it's basically 85% drivers, with over
>> half the patch being to the aforementioned new wireless one and the
>> OMAP drm changes. There's some other stuff there too, but it's largely
>> in the noise - small ARM and s390 updates (and a smattering of SuperH
>> and x86), a few tiny filesystem fixes, things like that.
>>
>> Go forth and test. My gut feel is that things really are calming down.
>> And I'd hate to be proven wrong.
>>
>>             Linus
>>
>
> reboot/shutdown hang in 3.8-rc3 due to
> 71e3d1578c954cf29f1f4db1c8930d3574025eb0 went away in this rc. But I
> am still seeing
>
> [   22.890240] DMAR:[fault reason 06] PTE Read access is not set
> [   22.890268] dmar: DRHD: handling fault status reg 3
> [   22.890272] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
> addr 80004000
>
> on ATI radeon VGA. Running bisect and will update.
>
> -- Shuah

ok. I bisected the DMAR faults and it points to the following commit:

909d9eb67f1e4e39f2ea88e96bde03d560cde3eb

This commit as I recall, fixed the crash problem I was seeing back in
3.8-rc1. Reverting to see if crash problem reappears.

Here is the git bisect log:

git bisect start '--' 'drivers/gpu/drm/radeon'
# bad: [9931faca02c604c22335f5a935a501bb2ace6e20] Linux 3.8-rc3
git bisect bad 9931faca02c604c22335f5a935a501bb2ace6e20
# good: [d1c3ed669a2d452cacfb48c2d171a1f364dae2ed] Linux 3.8-rc2
git bisect good d1c3ed669a2d452cacfb48c2d171a1f364dae2ed
# bad: [71e3d1578c954cf29f1f4db1c8930d3574025eb0] drm/radeon: switch
to a finer grained reset for r6xx/7xx
git bisect bad 71e3d1578c954cf29f1f4db1c8930d3574025eb0
# bad: [eaaa6983ab2ccdf826c90838eb584211e0cadb76] drm/radeon: print
dma status reg on lockup (v2)
git bisect bad eaaa6983ab2ccdf826c90838eb584211e0cadb76
# bad: [909d9eb67f1e4e39f2ea88e96bde03d560cde3eb] drm/radeon/r6xx: fix
DMA engine for ttm bo transfers
git bisect bad 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb
# good: [cafa59b9011a7790be4ddd5979419259844a165d] drm/radeon: add
connector table for Mac G4 Silver
git bisect good cafa59b9011a7790be4ddd5979419259844a165d

bad commit:

909d9eb67f1e4e39f2ea88e96bde03d560cde3eb is the first bad commit
commit 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Wed Jan 2 18:30:21 2013 -0500

    drm/radeon/r6xx: fix DMA engine for ttm bo transfers

    count must be a multiple of 2. Fixes crashes on
    R6xx chips reported by a number of people.

    Cc: Borislav Petkov <bp@alien8.de>
    Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
    Reviewed-by: Jerome Glisse <jglisse@redhat.com>
    Tested-by: Jerome Glisse <jglisse@redhat.com>
    Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

:040000 040000 f641a4e6cb7ac7426a8a80f3a4cf51a6320f95d4
e974cd1737fafb82c6dc8f85dbcdf6cacfea893a M      drivers


-- Shuah
