Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031Ab3CONKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:10:30 -0400
Received: from mx02.infracom.it ([62.196.48.11]:37098 "EHLO mx02.infracom.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab3CONK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:10:28 -0400
Message-ID: <51431DC0.1090603@infracom.it>
Date: Fri, 15 Mar 2013 14:10:24 +0100
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot
 on HP 6730B - bisected
References: <513D8F3A.8030308@gmail.com> <51418863.8000902@infracom.it> <1453029.sQIX9a1hrM@vostro.rjw.lan> <5142ED1A.1040500@infracom.it>
In-Reply-To: <5142ED1A.1040500@infracom.it>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Il 15/03/2013 10:42, Roberto Oppedisano ha scritto:
> Il 14/03/2013 18:27, Rafael J. Wysocki ha scritto:
>> On Thursday, March 14, 2013 09:20:51 AM Roberto Oppedisano wrote:
>> As Toshi said, this particular commit doesn't make any functional 
>> changes. Can you please verify if the immediately preceding commit 
>> 6af9a803f4d2e4137d9f74a8fc9af4857fbda001 works for you? Rafael 
>
> I have checked out this commit and it is NOT working.
>
> BTW I did find the same commit in my bisection log, and probably
> it was a false negative (I tried a couple of boot for each working kernel
> during bisectrion, probably it was not not enough).
> I'm going to replay the bisection today; will report back ASAP, to see
> if it ends in something which makes sense to you. 

Here's the new suspect:

f95988de06ea62ef5bd861f06e9ef56cea405ed1 is the first bad commit
commit f95988de06ea62ef5bd861f06e9ef56cea405ed1
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Mon Jan 7 21:17:02 2013 +0100

     ACPI / scan: Treat power resources in a special way

     Commit 805d410 (ACPI: Separate adding ACPI device objects from
     probing ACPI drivers) introduced an ACPI power resources management
     regression, because it didn't ensure that the power resources
     driver bind to the struct acpi_device objects corresponding
     to power resources as soon as they were created.  As a result,
     ACPI power management routines may attempt to access power resource
     objects before they are ready to use.

     To fix this problem, tell the acpi_add_single_object() in
     acpi_bus_check_add() to probe the driver for objects of type
     ACPI_BUS_TYPE_POWER.  This fix has been verified to work on
     HP nx6325 where the problem was first observed.

     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
     Acked-by: Toshi Kani <toshi.kani@hp.com>

:040000 040000 08e5a8e11fcedcc29ce23883f8362c33d0ea8b3e 
fb5193b97b2000b40eea39cef794d81aac1367b8 M      drivers

Trying to revert this commit on current Linus master gave me an error.
For reference here's the bisection log.

git bisect start
# good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
git bisect good 19f949f52599ba7c3f67a5897ac6be14bfcb1200
# bad: [6dbe51c251a327e012439c4772097a13df43c5b8] Linux 3.9-rc1
git bisect bad 6dbe51c251a327e012439c4772097a13df43c5b8
# bad: [b274776c54c320763bc12eb035c0e244f76ccb43] Merge tag 'cleanup' of 
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect bad b274776c54c320763bc12eb035c0e244f76ccb43
# bad: [a0b1c42951dd06ec83cc1bc2c9788131d9fefcd8] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect bad a0b1c42951dd06ec83cc1bc2c9788131d9fefcd8
# good: [98d5fac2330779e6eea6431a90b44c7476260dcc] Merge branch 'master' 
of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next 
into for-davem
git bisect good 98d5fac2330779e6eea6431a90b44c7476260dcc
# good: [8a3a11f91def34424b1995cb54ccd658efde8568] Merge tag 
'pinctrl-for-v3.9' of 
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl
git bisect good 8a3a11f91def34424b1995cb54ccd658efde8568
# bad: [10baf04e95fbf7eb6089410220a547211dd2ffa7] Merge branch 'release' 
of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux
git bisect bad 10baf04e95fbf7eb6089410220a547211dd2ffa7
# bad: [3757b94802fb65d8f696597a74053cf21738da0b] ACPI / hotplug: Fix 
concurrency issues and memory leaks
git bisect bad 3757b94802fb65d8f696597a74053cf21738da0b
# bad: [64e94e7e0ffb20ee11a596aa04fcdeefb33e000d] Merge branch 
'acpi-scan' into acpi-cleanup
git bisect bad 64e94e7e0ffb20ee11a596aa04fcdeefb33e000d
# bad: [993cbe595dda731471a07f4f65575fadedc570dc] ACPI / PM: Take order 
attribute of wakeup power resources into account
git bisect bad 993cbe595dda731471a07f4f65575fadedc570dc
# good: [e0ebda2ee12c261fb2f2d7abf21489b93d9caa4e] ACPI: Remove unused 
struct acpi_pci_root.id member
git bisect good e0ebda2ee12c261fb2f2d7abf21489b93d9caa4e
# bad: [05404d8f7b5c831e1a2c24bb782f0fe8ea02354c] ACPI / scan: Add 
second pass to acpi_bus_trim()
git bisect bad 05404d8f7b5c831e1a2c24bb782f0fe8ea02354c
# bad: [6af9a803f4d2e4137d9f74a8fc9af4857fbda001] ACPI: Remove the ops 
field from struct acpi_device
git bisect bad 6af9a803f4d2e4137d9f74a8fc9af4857fbda001
# bad: [abe99210e0f624cea39f1dc375ba818b201c0d7f] ACPI / scan: Fix check 
of device_attach() return value.
git bisect bad abe99210e0f624cea39f1dc375ba818b201c0d7f
# bad: [f95988de06ea62ef5bd861f06e9ef56cea405ed1] ACPI / scan: Treat 
power resources in a special way
git bisect bad f95988de06ea62ef5bd861f06e9ef56cea405ed1

Hope it's useful.
R
