Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaG3Upm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:45:42 -0400
Received: from outrelay06.libero.it ([212.52.84.110]:55653 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaG3Upi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:45:38 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0204.53D95967.00E3,ss=1,re=0.000,fgs=0
X-libjamoibt: 1823
Message-ID: <53D95AAF.6030309@inwind.it>
Date: Wed, 30 Jul 2014 22:50:55 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jean Delvare <jdelvare@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] therm_windtunnel doesn't work properly on PowerMac G4
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am writing to you Jean and Benjamin because it seem that both 
worked on these items.

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
In the following emails I sent you three patches to solve this 
problem (tested on my PowerMac G4)

1) change the driver name
	therm_ds1775 -> MAC,ds1775
        therm_adm1030 -> MAC,adm1030
so the i2c driver are instantiated by i2c-powermac

2) remove the (unused) method do_attach from the i2c-driver
3) add two parameters to the therm_windtunnel module 
to control the kernel log message 

The patch 1) solve the problem. The patch 2) is a small cleanup.
The patch 3) allow a better control of the log in dmesg.

Could you be so kindly to apply these patches ?

BR
G.Baroncelli



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
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
