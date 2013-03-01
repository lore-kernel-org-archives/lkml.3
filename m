Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3CAIsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:48:11 -0500
Received: from mx.mcc-med.de ([213.148.153.242]:58845 "EHLO mx.mcc-med.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3CAIsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:48:09 -0500
X-Greylist: delayed 1090 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Mar 2013 03:48:09 EST
From: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
To: "'Brian Norris'" <computersforpeace@gmail.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 1 Mar 2013 09:29:29 +0100
Subject: AW: Bug in mtd_get_device_size()?
Thread-Topic: Bug in mtd_get_device_size()?
Thread-Index: Ac4V2InYbPiv5O5GQHudGio4zQ5D/AAd+KBQ
Message-ID: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com>
 <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
In-Reply-To: <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
Accept-Language: de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalRecipient: RPFD:computersforpeace@gmail.com
X-OriginalRecipient: RPFD:richard.genoud@gmail.com
X-OriginalRecipient: RPFD:artem.bityutskiy@linux.intel.com
X-OriginalRecipient: RPFD:linux-mtd@lists.infradead.org
X-OriginalId: qfr218TUd6017995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

Thanks for your answer. Ok, I have nothing against that my interpretation of mtd_get_device_size() purpose is wrong. But what you mean under: "Because your BEB_LIMIT=100, you are reserving 100*size/1024 (that is 9.8% of your total size, or 400 blocks) in *every* partition." Looks for me a little bit strange. Why? Because I expected that UBI reserves the place for bad block handling pool depending on the size of MTD partition (on that it running) and not on the size of the whole chip. Actually I have 2 partitions with UBI (for rootfs and for data) and without my patch UBI tries to reserve nearly 400 blocks on each (see down). 

Why I set CONFIG_MTD_UBI_BEB_LIMIT to such high limit? Well, you are right: our NAND from production could contain up to 40 bad blocks. That is 1% of whole chip size. But our medical device should work in worst case each night for 10 years. I expect that in whole device life more blocks will be defect. Of course 10% for rootfs MTD is overkill since it will be updated very very seldom, but for data partititon 10% is probably even too low.  

>That would reserve only 80 blocks on your system, and you would not see these warnings/errors, since you already have 115 blocks reserved.
You mean *not on my system* but on each MTD running with UBI? :) Well I was thinking to divide my UBI volumes on UBI1 in small sub MTDs. Since I had 2 times cases, when I couldn't mount my ubi1:ubivol_data (I don't know why it happened, probably because of bugs in pretty new NAND driver from Atmel) and I should ubiformat/ubimkvolume for my MTD with loosing of extreme important data on ubi1:ubivol_device. If I really make new small MTDs for ubi1:ubivol_device/ ubi1:ubivol_config with the actual kernel state they will be completely used with poll for reserved bad blocks. No room for my data :) 

Best regards,
Sergey


/ # cd /sys/class/ubi/ubi0
/sys/devices/virtual/ubi/ubi0 # cat reserved_for_bad 
384
/sys/devices/virtual/ubi/ubi0 # cd ../ubi1/
/sys/devices/virtual/ubi/ubi1 # cat reserved_for_bad 
396
/sys/devices/virtual/ubi/ubi1 # df -h
Filesystem                Size      Used Available Use% Mounted on
ubi0:root-volume         27.2M     27.2M         0 100% /
devtmpfs                 29.3M         0     29.3M   0% /dev
tmpfs                    29.5M     64.0K     29.4M   0% /tmp
ubi1:ubivol_device        2.0M     24.0K      1.8M   1% /mnt/device
ubi1:ubivol_config        2.0M     36.0K      1.8M   2% /mnt/config
ubi1:ubivol_data        214.8M   1008.0K    209.1M   0% /mnt/data
/dev/mtdblock10          51.9M         0     51.9M   0% /mnt/masstorage
tmpfs                    29.5M     80.0K     29.4M   0% /run



-----Ursprüngliche Nachricht-----
Von: Brian Norris [mailto:computersforpeace@gmail.com] 
Gesendet: Donnerstag, 28. Februar 2013 18:25
An: Velykokhatko, Sergey
Cc: linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org; artem.bityutskiy@linux.intel.com; Richard Genoud
Betreff: Re: Bug in mtd_get_device_size()?

+ Richard

On Thu, Feb 28, 2013 at 4:30 AM, Velykokhatko, Sergey <Sergey.Velykokhatko@mcc-med.de> wrote:
> I got today such case:
>
>       * Kernel 3.8
>
>       * We are using M29F2G16 NAND chip with 4096 blocks, each has 
> 128k
>
>       * Configured with CONFIG_MTD_UBI_BEB_LIMIT=100

This is your problem. See below for more comments.

>       * Our rootfs partition contains 640 EBs
>
>       * At system start comes following error message:
>
> Feb 28 09:23:09 (none) kern.notice kernel: [    0.375000] Creating 6 MTD
> partitions on "atmel_nand":
>
> Feb 28 09:23:09 (none) kern.notice kernel: [    0.375000]
> 0x000000000000-0x000000020000 : "obsolete_bootstrap"
>
> Feb 28 09:23:09 (none) kern.notice kernel: [    0.381000]
> 0x000000020000-0x000000320000 : "kernel_a"
>
> Feb 28 09:23:09 (none) kern.notice kernel: [    0.386000]
> 0x000000320000-0x000000620000 : "kernel_b"
>
> Feb 28 09:23:09 (none) kern.notice kernel: [    0.392000]
> 0x000000620000-0x000005620000 : "rootfs_a"
>
> Feb 28 09:23:09 (none) kern.notice kernel: [    0.399000]
> 0x000005620000-0x00000a620000 : "rootfs_b"
>
> Feb 28 09:23:09 (none) kern.notice kernel: [    0.406000]
> 0x00000a620000-0x000020000000 : "config_data"
>
> ...
>
>
>
> Feb 28 09:23:10 (none) kern.info kernel: [    0.546000] NET: Registered
> protocol family 17
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.557000] UBI: attaching
> mtd3 to ubi0
>
> Feb 28 09:23:10 (none) kern.info kernel: [    0.748000] usb 1-2: new
> high-speed USB device number 2 using atmel-ehci
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.810000] UBI: scanning is
> finished
>
> Feb 28 09:23:10 (none) kern.warn kernel: [    0.821000] UBI warning:
> print_rsvd_warning: cannot reserve enough PEBs for bad PEB handling, 
> reserved 115, need 400
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: attached mtd3
> (name "rootfs_a", size 80 MiB) to ubi0
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: PEB size:
> 131072 bytes (128 KiB), LEB size: 129024 bytes
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: min./max. I/O
> unit sizes: 2048/2048, sub-page size 512
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: VID header
> offset: 512 (aligned 512), data offset: 2048
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: good PEBs:
> 640, bad PEBs: 0, corrupted PEBs: 0
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: user volume:
> 1, internal volumes: 1, max. volumes count: 128
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: max/mean
> erase counter: 399/202, WL threshold: 4096, image sequence number: 
> 548304255
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.826000] UBI: available
> PEBs: 0, total reserved PEBs: 640, PEBs reserved for bad PEB handling: 
> 115
>
> Feb 28 09:23:10 (none) kern.notice kernel: [    0.827000] UBI: background
> thread "ubi_bgt0d" started, PID 288
>
> UBI wanted to reserve 400 blocks on MTD with 640. Hm... During 
> debugging I found that mtd_get_device_size() gives the size of whole 
> flash memory back
> (4096 blocks * 128kB). I guess that I found small error. With micro 
> patch the problem seems to be corrected for my case

Your patch is wrong, actually. mtd_get_device_size() should get "the size of the entire flash chip", so if mtd is a partition, you *want* to return the size of its 'master'.

In fact, everything is behaving as expected (by the designers; not by you). Because your BEB_LIMIT=100, you are reserving 100*size/1024 (that is 9.8% of your total size, or 400 blocks) in *every* partition.
I don't see why you need that high of a limit, though. Check your NAND data sheet, but the limit defaults reasonably to 20 (or, about 2%).
That would reserve only 80 blocks on your system, and you would not see these warnings/errors, since you already have 115 blocks reserved.

You might want to read the comments in this commit:

commit ba4087e956d336488c6df9dfca65d1e70cf480f1
Author: Richard Genoud <richard.genoud@gmail.com>
Date:   Tue Jul 10 18:23:41 2012 +0200

    UBI: use the whole MTD device size to get bad_peb_limit

It might be worth revisiting the conclusions of those arguments; it essentially limits your partitions to a certain minimum size. But as far as I can tell, the code works as documented.

Brian
