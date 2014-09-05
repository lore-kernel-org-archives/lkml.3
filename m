Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaIEU5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:57:10 -0400
Received: from 36.223.133.77.rev.sfr.net ([77.133.223.36]:42584 "EHLO
	smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaIEU5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:57:07 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 16:57:06 EDT
From: arno@natisbad.org (Arnaud Ebalard)
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: klightspeed@killerwolves.net, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] ARM: MVEBU: Netgear RN102: Use Hardware BCH ECC
References: <1409898233-9273-1-git-send-email-klightspeed@killerwolves.net>
	<20140905154140.GA1377@arch.hh.imgtec.org>
X-PGP-Key-URL: http://natisbad.org/arno@natisbad.org.asc
X-Fingerprint: D3A5 B68A 839B 38A5 815A 781B B77C 0748 A7AE 341B
X-Hashcash: 1:20:140905:jason@lakedaemon.net::1gw1pFbNeiSzZ8xL:000000000000000000000000000000000000000000rcc
X-Hashcash: 1:20:140905:gregory.clement@free-electrons.com::4lQEFW7R80wKTGou:0000000000000000000000000000U9D
X-Hashcash: 1:20:140905:klightspeed@killerwolves.net::5YuYE6pWHHyywDP/:00000000000000000000000000000000017Xm
X-Hashcash: 1:20:140905:linux-mtd@lists.infradead.org::YgAkkWtXNjqyki22:000000000000000000000000000000001H9W
X-Hashcash: 1:20:140905:linux-arm-kernel@lists.infradead.org::QuaOyWrDpXNqEbhb:00000000000000000000000001oqM
X-Hashcash: 1:20:140905:thomas.petazzoni@free-electrons.com::Gj/wrgLtPDp3bwvU:0000000000000000000000000030tf
X-Hashcash: 1:20:140905:ezequiel.garcia@free-electrons.com::DxZYdRT8gySrKAXi:0000000000000000000000000002Hvj
X-Hashcash: 1:20:140905:computersforpeace@gmail.com::E2P5WKFpGjFaxjNb:000000000000000000000000000000000047hr
X-Hashcash: 1:20:140905:linux-kernel@vger.kernel.org::MBXymhzRSO1kduoA:0000000000000000000000000000000003+H4
X-Hashcash: 1:20:140905:devicetree@vger.kernel.org::vm3860qvzwDlaU7G:000000000000000000000000000000000005/NA
Date: Fri, 05 Sep 2014 22:49:58 +0200
Message-ID: <87ha0l23nt.fsf@natisbad.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ezequiel Garcia <ezequiel.garcia@free-electrons.com> writes:

> (Fixing Cc list: dropping devicetree guys, and adding Brian and MTD instead)
>
> On 05 Sep 04:23 PM, klightspeed@killerwolves.net wrote:
>> The bootloader on the Netgear ReadyNAS RN102 uses Hardware BCH ECC
>> (strength = 4), while the pxa3xx NAND driver by default uses 
>> Hamming ECC (strength = 1).
>> 
>
> Hm, I guess the device (Hynix H27U1G8F2BTR) does not support ONFI,
> and the kernel is just taking the legacy ECC. The flash specs makes no
> mention to ONFI, so probably no ONFI here.
>
>> This patch changes the ECC mode on these machines to match that
>> of the bootloader and of the stock firmware, so that for example
>> updating the kernel is possible without requiring a serial
>> connection.
>> 
>> This patch depends on commit 5b3e507 (mtd: nand: pxa3xx: Use ECC
>> strength and step size devicetree binding)
>> 
>> Signed-off-by: Ben Peddell <klightspeed@killerwolves.net>
>
> Looks good to me, since Arnaud reports this is the correct ECC scheme:
> http://natisbad.org/NAS2/index.html#hw-nand
>
> Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
>
> Thanks for the fix,

w/o the patch, you can write data to the flash using userland tools from
mtd-utils package (flash_erase and nandwrite); data can then be read
again using userland tools (say using dd). But - as reported by Ben - if
you nandwrite an uImage from userland, here is what you indeed get from
u-boot when you try and boot that image:

  root@humble:~# flash_erase /dev/mtd2 0 0
  Erasing 128 Kibyte @ 5e0000 -- 100 % complete 
  
  root@humble:~# nandwrite -p /dev/mtd2 /tmp/uImage-3.16.1.rn102
  Writing data to block 0 at offset 0x0
  Writing data to block 1 at offset 0x20000
  Writing data to block 2 at offset 0x40000
  Writing data to block 3 at offset 0x60000
  Writing data to block 4 at offset 0x80000
  
  ...
  
  reboot 
  
  ...
  
  Marvell>> nand read 0x1200000 0x200000 0x600000
  
  NAND read: device 0 offset 0x200000, size 0x600000
   6291456 bytes read: OK
  
  Marvell>> bootm 0x1200000
  ## Booting kernel from Legacy Image at 01200000 ...
     Image Name:   Linux-3.16.1.rn102
     Created:      2014-08-14  13:33:46 UTC
     Image Type:   ARM Linux Kernel Image (uncompressed)
     Data Size:    4423998 Bytes =  4.2 MB
     Load Address: 00008000
     Entry Point:  00008000
     Verifying Checksum ... Bad Data CRC
  ERROR: can't get kernel image!
  

Now, w/ the patch submitted by Ben, here is what you get:

  With the patch applied, this indeed works has 
  ## Booting kernel from Legacy Image at 01200000 ...
     Image Name:   Linux-3.16.1.rn102
     Created:      2014-09-05  20:25:34 UTC
     Image Type:   ARM Linux Kernel Image (uncompressed)
     Data Size:    4424067 Bytes =  4.2 MB
     Load Address: 00008000
     Entry Point:  00008000
     Verifying Checksum ... OK
     Loading Kernel Image ... OK
  OK
  
  Starting kernel ...

i.e. it works.  

So, thanks for reporting this, Ben. I must confess I got used to update
my kernels from u-boot and did not take enough attention to that
aspect when I updated the .dts to add access to NAND after Ezequiel
wrote the NAND driver. I will take a look at RN104 and RN2120 to check
if something similar is needed for those two.

FWIW, you can add my:

 Tested-by: Arnaud Ebalard <arno@natisbad.org>
 
Additionally, Ezequiel, would anything prevent pushing the patch to
stable team (nand entry in .dts was added in 3.14):

 Fixes: 92beaccd8b49 ("ARM: mvebu: Enable NAND controller in ReadyNAS 102 .dts file")

Cheers,

a+
