Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKKNZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:25:18 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47281 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaKKNZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:25:16 -0500
Message-ID: <54620E4E.9090907@gmail.com>
Date: Tue, 11 Nov 2014 14:25:34 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RESEND][PATCH][v5] therm_windtunnel does not work properly on PowerMac
 G4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am resending these emails for submission. The patch is still
applicable to the kernel v3.18....
The previous submission was in Agoust...

------------
Hi All,

On a PowerMac G4 I noticed that between the kernel v3.2 and v3.14 I lost
the fan management.

I found on internet other references to this kind of problem [2]


**How reproduce:
- booting with the kernel 3.2, the fan is "quite" silent.
The module therm_windtunnel is loaded and in the log there are  
lines like:

	[ 1342.614956] CPU-temp: 58.7 C, Case: 33.7 C,  Fan: 5 (tuned +0)
	[ 1390.637793] CPU-temp: 58.6 C, Case: 33.6 C,  Fan: 5

I had also access to the temperature via the sysfs files:
/sys/devices/temperature/case_temperature  
/sys/devices/temperature/cpu_temperature


- booting with the kernel 3.14, the fan is very loud. The module 
therm_windtunnel is not loaded. In the log there aren't any message
related to the temperature. The sysfs entries don't exist.


** Analysis 
In these Apple machines the module i2c-powermac requires the
i2c drivers provided by the module therm_windtunnel.

Between the kernel v3.2 and v3.14 [1] some patches changed the 
driver name requested by the i2c-powermac module, 
so the therm_windtunnel modules is not instantiated anymore.


** Proposed solution
In the following emails I sent you 5 patches to solve this 
problem (tested on my PowerMac G4). Only the first two are strictly
related to the problem, the others three may be skipped.

1) change the driver name
	therm_ds1775 -> MAC,ds1775
        therm_adm1030 -> MAC,adm1030
so the i2c driver are instantiated by i2c-powermac

2) remove the (unused) method do_attach from the i2c-driver

3) add a parameter to the therm_windtunnel module 
to control the kernel log message 

4) export the fan speed via sysfs

5) export the temperature via the hwmon subsistem

The patch 1) solve the problem. The patch 2) is a small cleanup.
The patch 3) allow a better control of the log in dmesg.
The patch 4) is copyied from the Bryan Christianson's patch (see
debian bug #741663)
The patch 5) export the temperatures via hwmon, a more standard 
interface. I also added the internal sensor of the adm1030, which 
I called "Case2", because it measure the same temperature /+/- 1C) 
of the "Case" sensor.

I have to highlight that I tried to export also the fan speed,
but I was unable to get it, without affecting the fan speed:
when I set the bit 2 (TACH 1 En) of the register 0x1 
(Configuration 2), it seemed that the speed every 4/5s dropped,
then it raised quickly....
I didn't perform other test to avoid damages.

Could you be so kindly to apply these patches ?

PS:
I am not LKML subscriber, so please put me in CC in case of reply.

BR
G.Baroncelli

Changelog:
v1: 2014/07/30
	- first issue
v2: 2014/08/01
	- protect with a mutex the check before starting the fan 
	  daemon (to protect from parallel drivers instantation)
	- reduce the number of module parameters to 1 as suggested by 
          Jean Delvare
	- export the fan speed via sysfs
v3: 2014/08/06
	- export the temperatures via hwmon
	- export the internal temperature sensor of the adm1030
	- little cleanup due to the suggestion of checkpatch.pl (
	  and Jean Delvare)
	- removed the "(tune +0)" in the log.
v4: 2014/08/07
	- accepted some small cleanup suggestions from Jean Delvare
	- replaced SENSOR_DEVICE_ATTR with DEVICE_ATTR, and
	  added ATTRIBUTE_GROUPS() use
v5: 2014/08/09
	- hanlde the return error of 
	  hwmon_device_register_with_groups() with IS_ERR() "macro"
	- better explanation about the source of patch #4

[1] I think that the guilty commit is 
commit 81e5d8646ff6bf323dddcf172aa3cef84468fa12
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Wed Apr 18 22:16:42 2012 +0000
    i2c/powermac: Register i2c devices from device-tree

    This causes i2c-powermac to register i2c devices exposed in the
    device-tree, enabling new-style probing of devices.

    Note that we prefix the IDs with "MAC," in order to prevent the
    generic drivers from matching. This is done on purpose as we only
    want drivers specifically tested/designed to operate on powermacs
    to match.

    This removes the special case we had for the AMS driver, and updates
    the driver's match table instead.

    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[2] There is the debian bug #741663 which highlight the same problem. In
the bug discussion there is a patch like the my ones.

See also
https://lists.ozlabs.org/pipermail/linuxppc-dev/2012-July/099561.html

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D 17B2 0EDA 9B37 8B82 E0B5 


