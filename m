Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab3EOETD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:19:03 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:64804 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3EOETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:19:00 -0400
MIME-Version: 1.0
From: Sonny Rao <sonnyrao@chromium.org>
Date: Tue, 14 May 2013 21:18:39 -0700
X-Google-Sender-Auth: pFul46LKhGYiSUU6obI64Ssx4zY
Message-ID: <CAPz6YkWr_D504UdeqXB0FXxgqOt3GYnF09ctoMaZ8P-znbVMGQ@mail.gmail.com>
Subject: Fans at full speed after resume
To: linux-pm@vger.kernel.org
Cc: Sameer Nanda <snanda@chromium.org>,
        "Triplett, Josh" <josh.triplett@intel.com>, Olof <olofj@chromium.org>,
        len.brown@intel.com, Zhang Rui <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I've seen a regression in kernels since 3.7 on x86 devices where
the kernel turns the system fans on to max speed after resuming from
ram.  Other people have noticed it as well, for example see
https://bugzilla.redhat.com/show_bug.cgi?id=895276

For example on the Samsung 550 Chromebook, we have one thermal zone
and have 5 cooling_devices, 0-4, which correspond to 5 possible fan
speeds.  Under typical idle, only cooling_device4 and maybe
cooling_device3 are active, depending on temperature:

cat /sys/class/thermal/cooling_device[01234]/cur_state
/sys/class/thermal/thermal_zone0/temp
0
0
0
0
1
57000

however after a suspend/resume, we see that cooling_devices 0 and 1
become active:
cat /sys/class/thermal/cooling_device[01234]/cur_state
/sys/class/thermal/thermal_zone0/temp
1
1
0
0
1
54000

and it seems to stay that way, even though the temperature is low
enough that the fan shouldn't be running at that speed.  If I manually
disable cooling_devices 0 and 1 then fan control works normally again.

I started bisecting it and was able to do so up until this commit:
commit 29b19e250434c6193c8b8e4c34c9c6284dd4f101
Merge: 125c4c7 c072fed
Author:     Len Brown <len.brown@intel.com>
AuthorDate: Tue Oct 9 01:35:52 2012 -0400
Commit:     Len Brown <len.brown@intel.com>
CommitDate: Tue Oct 9 01:35:52 2012 -0400

    Merge branch 'release' of
git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux into
thermal

unfortunately, I'm not able to successfully do a suspend/resume on the
commits in that merge, so I wasn't able to bisect down to the exact
commit.

I did confirm that one parent of the merge is okay: commit
125c4c706b680c7831f0966ff873c1ad0354ec25 idr: rename MAX_LEVEL to
MAX_IDR_LEVEL

so I think it falls somewhere in this list of commits:
c072fed95c9855a920c114d7fa3351f0f54ea06e...e3f25e6e5836c4790fbe395ff42e241f372d859d

c072fed9 thermal: Exynos: Fix NULL pointer dereference in
exynos_unregister_thermal()
a4b6fec9 Thermal: Fix bug on cpu_cooling, cooling device's id conflict problem.
79e093c3 thermal: exynos: Use devm_* functions
17be868e ARM: exynos: add thermal sensor driver platform data support
7e0b55e6 thermal: exynos: register the tmu sensor with the kernel thermal layer
f22d9c03c thermal: exynos5: add exynos5250 thermal sensor driver support
c48cbba6 hwmon: exynos4: move thermal sensor driver to driver/thermal directory
02361418 thermal: add generic cpufreq cooling implementation
a7a3b8c8 Fix a build error.
204dd1d3 thermal: Fix potential NULL pointer accesses
1e426ffdd thermal: add Renesas R-Car thermal sensor support
79a49168 thermal: fix potential out-of-bounds memory access
f4a821ce6 Thermal: Introduce locking for cdev.thermal_instances list.
908b9fb79 Thermal: Unify the code for both active and passive cooling
ce119f832 Thermal: Introduce simple arbitrator for setting device cooling state
b5e4ae62 Thermal: List thermal_instance in thermal_cooling_device.
cddf31b3b Thermal: Rename thermal_instance.node to thermal_instance.tz_node.
2d374139 Thermal: Rename thermal_zone_device.cooling_devices
b81b6ba3 Thermal: rename structure thermal_cooling_device_instance to
thermal_instance
4ae46befb Thermal: Introduce thermal_zone_trip_update()
1b7ddb84 Thermal: Remove tc1/tc2 in generic thermal layer.
601f3d424 Thermal: Introduce .get_trend() callback.
9d99842f9 Thermal: set upper and lower limits
74051ba5 Thermal: Introduce cooling states range support

When I get time, I'll try to rebase those commits onto the IDR commit
and see if I can get a better bisect.  Any insights into the problem
would be appreciated, thanks.
