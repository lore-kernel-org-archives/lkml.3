Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaJUNRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:17:33 -0400
Received: from smtp02.myhostedservice.com ([66.129.85.153]:55579 "EHLO
	smtp02.myhostedservice.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932565AbaJUNR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:17:29 -0400
X-Halon-Cookie: 67b3a1c41fab59355df404e4c78c96f19f947420
Subject: Re: What happened with the Patch "New RAID library supporting up to
 six parities"
MIME-Version: 1.0
x-echoworx-emg-received: Tue, 21 Oct 2014 09:16:27.699 -0400
x-echoworx-msg-id: 2127bea3-009b-4fd8-953d-bf2e994a0166
x-echoworx-action: delivered
From: Ronny Egner <ronnyegner@ronnyegner-consulting.de>
To: NeilBrown <neilb@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andrea Mazzoleni" <amadvance@gmail.com>
Thread-Topic: What happened with the Patch "New RAID library supporting up
 to six parities"
Thread-Index: AQHP7Pj3nqIKo1MfYU6wgeskiPrm6pw6ageAgACDHAA=
Date: Tue, 21 Oct 2014 13:16:52 +0000
Message-ID: <D06C14D9.4018A%ronnyegner@ronnyegner-consulting.de>
References: <D06BCADE.40140%ronnyegner@ronnyegner-consulting.de>
 <20141021182725.016ec0e1@notabene.brown>
In-Reply-To: <20141021182725.016ec0e1@notabene.brown>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.4.4.140807
x-originating-ip: [172.27.21.39]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C51B4090DFA1A4181FEBB91A9E3982B@cloud.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9LDHhMB032242

Hi Neil,


i did a short test and it works so far. Here are my results. Let me know
if you need something more:

(TL;DR: Wonderful patch. Tested with PAR6 (= six parities) and was able to
recover from losing five disks at once.)



The patches apply against 3.14.22 and btrfs-progs 3.12 but not against the
recent 3.18-rc1 and btrfs-progs > 3.12.


	root@ubuntu-1204-build:~# btrfs --version
	Btrfs v3.12-dirty
	
	root@ubuntu-1204-build:~# uname -a
	Linux ubuntu-1204-build 3.14.22 #3 SMP Tue Oct 21 13:00:08 CEST 2014
x86_64 x86_64 x86_64 GNU/Linux


For the tests i used a VM with 4 GB memory, two cores and 15 disks with
150 GB each. Every disk looked like this:

	root@ubuntu-1204-build:~# fdisk /dev/sdi

	Command (m for help): p

	Disk /dev/sdi: 157.3 GB, 157286400000 bytes
	81 heads, 30 sectors/track, 126419 cylinders, total 307200000 sectors
	Units = sectors of 1 * 512 = 512 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x5b5d7269

	Device Boot      Start         End      Blocks   Id  System
	/dev/sdi1            2048   307199999   153598976   83  Linux


File system created:

	root@ubuntu-1204-build:~# mkfs.btrfs -dpar6 -L testpar6 /dev/sdh1
/dev/sdi1 /dev/sdj1 /dev/sdk1 \
		                  /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1
/dev/sdq1 /dev/sdr1 \
				  /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1


	Turning ON incompat feature 'extref': increased hardlink limit per file
to 65536
	Turning ON incompat feature 'par3456': raid support with up to six
parities
	adding device /dev/sdi1 id 2
	adding device /dev/sdj1 id 3
	adding device /dev/sdk1 id 4
	adding device /dev/sdl1 id 5
	adding device /dev/sdm1 id 6
	adding device /dev/sdn1 id 7
	adding device /dev/sdo1 id 8
	adding device /dev/sdp1 id 9
	adding device /dev/sdq1 id 10
	adding device /dev/sdr1 id 11
	adding device /dev/sds1 id 12
	adding device /dev/sdt1 id 13
	adding device /dev/sdu1 id 14
	adding device /dev/sdv1 id 15
	fs created label testpar6 on /dev/sdh1
	nodesize 16384 leafsize 16384 sectorsize 4096 size 2.15TiB
	Btrfs v3.12-dirty


Mount:


	root@ubuntu-1204-build:~# mount /dev/sdh1 /mnt

Stats:
	
	root@ubuntu-1204-build:~# df -h
	Filesystem                 Size  Used Avail Use% Mounted on
	/dev/mapper/vgroot-lvroot   26G   17G  8.4G  67% /
	none                       4.0K     0  4.0K   0% /sys/fs/cgroup
	udev                       1.6G  4.0K  1.6G   1% /dev
	tmpfs                      331M  1.1M  330M   1% /run
	none                       5.0M     0  5.0M   0% /run/lock
	none                       1.7G     0  1.7G   0% /run/shm
	none                       100M     0  100M   0% /run/user
	/dev/sdh1                  2.2T  2.8M  2.2T   1% /mnt


	Data, single: total=8.00MiB, used=0.00
	Data, PAR6: total=9.00GiB, used=995.16MiB
	System, RAID1: total=8.00MiB, used=16.00KiB
	System, single: total=4.00MiB, used=0.00
	Metadata, RAID1: total=1.00GiB, used=65.59MiB
	Metadata, single: total=8.00MiB, used=0.00

	root@ubuntu-1204-build:/mnt# btrfs fi show
	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
	Total devices 15 FS bytes used 1.04GiB
	devid    1 size 146.48GiB used 1.02GiB path /dev/sdh1
	devid    2 size 146.48GiB used 1.00GiB path /dev/sdi1
	devid    3 size 146.48GiB used 1.00GiB path /dev/sdj1
	devid    4 size 146.48GiB used 1.00GiB path /dev/sdk1
	devid    5 size 146.48GiB used 1.00GiB path /dev/sdl1
	devid    6 size 146.48GiB used 1.00GiB path /dev/sdm1
	devid    7 size 146.48GiB used 1.00GiB path /dev/sdn1
	devid    8 size 146.48GiB used 1.00GiB path /dev/sdo1
	devid    9 size 146.48GiB used 1.00GiB path /dev/sdp1
	devid    10 size 146.48GiB used 1.00GiB path /dev/sdq1
	devid    11 size 146.48GiB used 1.00GiB path /dev/sdr1
	devid    12 size 146.48GiB used 2.00GiB path /dev/sds1
	devid    13 size 146.48GiB used 2.00GiB path /dev/sdt1
	devid    14 size 146.48GiB used 1.01GiB path /dev/sdu1
	devid    15 size 146.48GiB used 1.01GiB path /dev/sdv1


Metadata and data still ‚Äösingle‚Äò? Bug? Nevermind - lets convert it:

	root@ubuntu-1204-build:/mnt# btrfs balance start -mconvert=raid1 /mnt
	Done, had to relocate 4 out of 6 chunks

	root@ubuntu-1204-build:/mnt# btrfs fi df /mnt
	Data, single: total=8.00MiB, used=0.00
	Data, PAR6: total=9.00GiB, used=1.02GiB
	System, RAID1: total=32.00MiB, used=16.00KiB
	Metadata, RAID1: total=1.00GiB, used=67.83MiB
	
	root@ubuntu-1204-build:/mnt# btrfs balance start -dconvert=par6 /mnt
	Done, had to relocate 2 out of 4 chunks

	root@ubuntu-1204-build:/mnt# btrfs fi df /mnt
	Data, PAR6: total=9.00GiB, used=1.02GiB
	System, RAID1: total=32.00MiB, used=16.00KiB
	Metadata, RAID1: total=1.00GiB, used=68.72MiB



OK now lets see what happens if we remove on device. Save a MD5SUM before:


	root@ubuntu-1204-build:/mnt# md5sum linux-3.14.22.tar
	80af37cdfb2fa2239f79597c914a8c73  linux-3.14.22.tar


(Removed one disk and replace it with a brand new, empty one)




	root@ubuntu-1204-build:~# mount /dev/sdh1 /mnt
	mount: wrong fs type, bad option, bad superblock on /dev/sdh1,
	missing codepage or helper program, or other error
	In some cases useful info is found in syslog - try
	dmesg | tail  or so

	root@ubuntu-1204-build:~# mount /dev/sdh1 /mnt -o degraded
	root@ubuntu-1204-build:~#

	root@ubuntu-1204-build:~# btrfs fi show
	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
	Total devices 15 FS bytes used 31.42GiB
	devid    1 size 146.48GiB used 4.00GiB path /dev/sdh1
	devid    2 size 146.48GiB used 5.00GiB path /dev/sdi1
	devid    3 size 146.48GiB used 4.00GiB path /dev/sdj1
	devid    4 size 146.48GiB used 4.00GiB path /dev/sdk1
	devid    5 size 146.48GiB used 4.00GiB path /dev/sdl1
	devid    6 size 146.48GiB used 5.00GiB path /dev/sdm1
	devid    7 size 146.48GiB used 4.03GiB path /dev/sdn1
	devid    8 size 146.48GiB used 4.00GiB path /dev/sdo1
	devid    9 size 146.48GiB used 4.00GiB path /dev/sdp1
	devid    10 size 146.48GiB used 4.00GiB path /dev/sdq1
	devid    11 size 146.48GiB used 4.00GiB path /dev/sdr1
	devid    12 size 146.48GiB used 4.03GiB path /dev/sds1
	devid    13 size 146.48GiB used 4.00GiB path /dev/sdt1
	devid    14 size 146.48GiB used 4.00GiB path /dev/sdu1
	devid    15 size 146.48GiB used 4.00GiB path


Lets replace the faulty disk:

	root@ubuntu-1204-build:~# btrfs device add /dev/sdv1 /mnt
	root@ubuntu-1204-build:~# btrfs device delete missing /mnt

	In /var/log/syslog:

	[  191.442050] BTRFS warning (device sdk1): devid 15 missing
	[  581.367659]  sdv: sdv1
	[  598.009968] BTRFS: device label testpar6 devid 16 transid 63 /dev/sdv1
	[  614.679654] BTRFS info (device sdk1): relocating block group
40865103872 flags 4097
	[  657.889822] BTRFS info (device sdk1): found 64 extents
	[  659.190497] BTRFS info (device sdk1): found 64 extents
	[  659.247765] BTRFS info (device sdk1): relocating block group
31201427456 flags 4097
	[  861.359599] BTRFS info (device sdk1): found 132 extents
	[  862.875521] BTRFS info (device sdk1): found 132 extents
	[  862.973499] BTRFS info (device sdk1): relocating block group
11874074624 flags 4097



After the ‚Äödelete missing‚Äò

	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
	Total devices 15 FS bytes used 31.42GiB
	devid    1 size 146.48GiB used 4.00GiB path /dev/sdh1
	. . .
	devid    14 size 146.48GiB used 4.00GiB path /dev/sdu1
	devid    16 size 146.48GiB used 4.00GiB path /dev/sdv1


The md5 checksum is still correct:

	root@ubuntu-1204-build:/mnt# md5sum linux-3.14.22.tar
	80af37cdfb2fa2239f79597c914a8c73  linux-3.14.22.tar









Hardcore test: PAR6 = 6 parities. Let¬¥s see what happens if i remove five
disks and replace with with empty ones.

Before i did that the metadata format was converted to PAR6 as well:

	
	root@ubuntu-1204-build:~# btrfs fi df /mnt/
	Data, PAR6: total=36.00GiB, used=31.32GiB
	System, PAR6: total=144.00MiB, used=16.00KiB
	Metadata, PAR6: total=1.12GiB, used=101.81MiB




	root@ubuntu-1204-build:~# mount /dev/sdn1 /mnt/ -o degraded
	

	root@ubuntu-1204-build:~# btrfs fi show
	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
	Total devices 15 FS bytes used 31.42GiB
	devid    1 size 146.48GiB used 4.00GiB path
	devid    2 size 146.48GiB used 5.00GiB path
	devid    3 size 146.48GiB used 4.00GiB path
	devid    4 size 146.48GiB used 4.00GiB path
	devid    5 size 146.48GiB used 4.00GiB path
	devid    6 size 146.48GiB used 5.00GiB path /dev/sdm1
	devid    7 size 146.48GiB used 4.03GiB path /dev/sdn1
	devid    8 size 146.48GiB used 4.00GiB path /dev/sdo1
	devid    9 size 146.48GiB used 4.00GiB path /dev/sdp1
	devid    10 size 146.48GiB used 4.00GiB path /dev/sdq1
	devid    11 size 146.48GiB used 4.00GiB path /dev/sdr1
	devid    12 size 146.48GiB used 4.03GiB path /dev/sds1
	devid    13 size 146.48GiB used 4.00GiB path /dev/sdt1
	devid    14 size 146.48GiB used 4.00GiB path /dev/sdu1
	devid    16 size 146.48GiB used 4.00GiB path /dev/sdv1


Now let¬¥s bring it back in shape and add five new, empty disks:

	btrfs device add /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /mnt
	btrfs delete missing
	<<wait>>
	root@ubuntu-1204-build:~# btrfs fi show
	Label: testpar6  uuid: 79d3c5e4-74ce-4464-a509-ef666dcd9073
	Total devices 15 FS bytes used 1.09GiB
	devid    6 size 146.48GiB used 2.14GiB path /dev/sdm1
	devid    7 size 146.48GiB used 2.14GiB path /dev/sdn1
	devid    8 size 146.48GiB used 2.14GiB path /dev/sdo1
	devid    9 size 146.48GiB used 2.14GiB path /dev/sdp1
	devid    10 size 146.48GiB used 2.14GiB path /dev/sdq1
	devid    11 size 146.48GiB used 2.14GiB path /dev/sdr1
	devid    12 size 146.48GiB used 2.14GiB path /dev/sds1
	devid    13 size 146.48GiB used 2.14GiB path /dev/sdt1
	devid    14 size 146.48GiB used 2.14GiB path /dev/sdu1
	devid    16 size 146.48GiB used 2.14GiB path /dev/sdv1
	devid    17 size 146.48GiB used 2.14GiB path /dev/sdh1
	devid    18 size 146.48GiB used 2.14GiB path /dev/sdi1
	devid    19 size 146.48GiB used 2.14GiB path /dev/sdj1
	devid    20 size 146.48GiB used 2.14GiB path /dev/sdk1
	devid    21 size 146.48GiB used 2.14GiB path /dev/sdl1





And now the checksum:

	root@ubuntu-1204-build:/mnt# md5sum linux-3.14.22.tar
	80af37cdfb2fa2239f79597c914a8c73  linux-3.14.22.tar

Checksum matches! 

So.. this looks *very* good to me.








Mit freundlichen Gr√º√üen
Ronny Egner
--
Ronny Egner
Oracle Certified Master 11g (OCM)
 
Mobile:   +49 170 8139903
EMail:      ronnyegner@ronnyegner-consulting.de
<mailto:roonnyegner@ronnyegner-consulting.de>




Am 21.10.14 09:27 schrieb "NeilBrown" unter <neilb@suse.de>:

>On Tue, 21 Oct 2014 06:33:47 +0000 Ronny Egner
><ronnyegner@ronnyegner-consulting.de> wrote:
>
>> Dear All,
>> 
>> i was wondering what happened with the patch posted by Andrea Mazzoleni
>> back in Februrary 2014 (this Thread:
>> http://thread.gmane.org/gmane.linux.kernel/1654735).
>> 
>> Why wash¬¥t it added to the code? Something missing/wrong?
>> 
>> In my opinion the posted patch is awesome and would enable a unique
>> feature that no other UNIX-like operating system currently has.
>> 
>
>Could you report your test results please.
>
>NeilBrown

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
