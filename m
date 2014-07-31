Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbaGaB1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 21:27:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:50105 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaGaB1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 21:27:22 -0400
Message-ID: <1406770020.4935.166.camel@pasglop>
Subject: Re: [PATCH 0/3] therm_windtunnel doesn't work properly on PowerMac
 G4
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: kreijack@inwind.it
Cc: Jean Delvare <jdelvare@suse.de>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 31 Jul 2014 11:27:00 +1000
In-Reply-To: <53D95AAF.6030309@inwind.it>
References: <53D95AAF.6030309@inwind.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 22:50 +0200, Goffredo Baroncelli wrote:
> Hi All,
> 
> I am writing to you Jean and Benjamin because it seem that both 
> worked on these items.
> 
> On a PowerMac G4 I noticed that between the kernel v3.2 and v3.14 I lost
> the fan management.
> 
> I found on internet other references to this kind of problem [2]

Patches look good, thanks. Jean do you want to apply them or should I ?

Cheers,
Ben.

> 
> **How reproduce:
> - booting with the kernel 3.2, the fan is "quite" silent.
> The module therm_windtunnel is loaded and in the log there are  
> lines like:
> 
> 	[ 1342.614956] CPU-temp: 58.7 C, Case: 33.7 C,  Fan: 5 (tuned +0)
> 	[ 1390.637793] CPU-temp: 58.6 C, Case: 33.6 C,  Fan: 5
> 
> I had also access to the temperature via the sysfs files:
> /sys/devices/temperature/case_temperature  
> /sys/devices/temperature/cpu_temperature
> 
> 
> - booting with the kernel 3.14, the fan is very loud. The module 
> therm_windtunnel is not loaded. In the log there aren't any message
> related to the temperature. The sysfs entries don't exist.
> 
> 
> ** Analysis 
> In these Apple machines the module i2c-powermac requires the
> i2c drivers provided by the module therm_windtunnel.
> 
> Between the kernel v3.2 and v3.14 [1] some patches changed the 
> driver name requested by the i2c-powermac module, 
> so the therm_windtunnel modules is not instantiated anymore.
> 
> 
> ** Proposed solution
> In the following emails I sent you three patches to solve this 
> problem (tested on my PowerMac G4)
> 
> 1) change the driver name
> 	therm_ds1775 -> MAC,ds1775
>         therm_adm1030 -> MAC,adm1030
> so the i2c driver are instantiated by i2c-powermac
> 
> 2) remove the (unused) method do_attach from the i2c-driver
> 3) add two parameters to the therm_windtunnel module 
> to control the kernel log message 
> 
> The patch 1) solve the problem. The patch 2) is a small cleanup.
> The patch 3) allow a better control of the log in dmesg.
> 
> Could you be so kindly to apply these patches ?
> 
> BR
> G.Baroncelli
> 
> 
> 
> [1] I think that the guilty commit is 
> 
> commit 81e5d8646ff6bf323dddcf172aa3cef84468fa12
> Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date:   Wed Apr 18 22:16:42 2012 +0000
> 
>     i2c/powermac: Register i2c devices from device-tree
>     
>     This causes i2c-powermac to register i2c devices exposed in the
>     device-tree, enabling new-style probing of devices.
>     
>     Note that we prefix the IDs with "MAC," in order to prevent the
>     generic drivers from matching. This is done on purpose as we only
>     want drivers specifically tested/designed to operate on powermacs
>     to match.
>     
>     This removes the special case we had for the AMS driver, and updates
>     the driver's match table instead.
>     
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> [2] There is the debian bug #741663 which highlight the same problem. In
> the bug discussion there is a patch like the my ones.
> 
> See also
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2012-July/099561.html
> 
> 
> 
> 


