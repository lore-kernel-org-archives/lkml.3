Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3FXHPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:15:23 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:33919 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3FXHPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:15:21 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: SATA hdd refuses to reallocate a sector?
Date: Mon, 24 Jun 2013 09:14:29 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Mark Lord <mlord@pobox.com>, Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
References: <20130623101940.GA4448@amd.pavel.ucw.cz> <51C76858.4060906@pobox.com> <20130623215100.GA7414@amd.pavel.ucw.cz>
In-Reply-To: <20130623215100.GA7414@amd.pavel.ucw.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201306240914.29502.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 June 2013, Pavel Machek wrote:
> On Sun 2013-06-23 17:27:52, Mark Lord wrote:
> > On 13-06-23 03:00 PM, Pavel Machek wrote:
> > > Thanks for the hint. (Insert rant about hdparm documentation
> > > explaining that it is bad idea, but not telling me _why_ is it bad
> > > idea. Can I expect cache consistency issues after that, or is it just
> > > simple "you are writing to the disk without any checks"? Plus, I guess
> > > documentation should mention what sector number is. I guess sectors
> > > are 512bytes for the old drives, but is it 512 or 4096 for new
> > > drives?)
> >
> > For ATA, use the "logical sector size".
> > For all existing drives out there, that's a 512 byte unit.
>
> I guessed so. (It would be good to actually document it, as well as
> documenting exactly why it is dangerous. Is it okay to send patches?)
>
> > > ...but it does not do the trick :-(. It behaves strangely as if it was
> > > still cached somewhere. Do I need to turn off the write back cache?
> >
> > No, it works just fine.  You probably have more than one bad sector.
> > After you see a read failure, run "smartctl -a" and look at the error
> > logs to see what sector the drive is choking on.
>
> Well, I definitely have more than one bad sector, but I did try to
> read exactly the same sector and it failed. See below.
>
> root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
>  961237188 /dev/sda | uniq
>
> /dev/sda:
> FAILED: Input/output error
> reading sector 961237188:
> root@amd:~# hdparm --yes-i-know-what-i-am-doing  --write-sector
> 961237188 /dev/sda
>
> /dev/sda:
> re-writing sector 961237188: succeeded
> root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
> 961237188 /dev/sda | uniq
>
> /dev/sda:
> FAILED: Input/output error
> reading sector 961237188:
> root@amd:~# hdparm --yes-i-know-what-i-am-doing  --write-sector
> 961237188 /dev/sda
>
> /dev/sda:
> re-writing sector 961237188: succeeded
> root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
> 961237188 /dev/sda | uniq
>
> /dev/sda:
> reading sector 961237188: succeeded
> 0000 0000 0000 0000 0000 0000 0000 0000
> root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=4096
> skip=$[8958947328/4096]
> dd: reading `/dev/sda4': Input/output error
> 102+0 records in
> 102+0 records out
> 417792 bytes (418 kB) copied, 6.12536 s, 68.2 kB/s
> root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
> 961237188 /dev/sda | uniq
>
> /dev/sda:
> reading sector 961237188: succeeded
> 0000 0000 0000 0000 0000 0000 0000 0000
> root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
> 961237188 /dev/sda | uniq
>
> /dev/sda:
> reading sector 961237188: succeeded
> 0000 0000 0000 0000 0000 0000 0000 0000
> root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
> 961237188 /dev/sda | uniq
>
> /dev/sda:
> FAILED: Input/output error
> reading sector 961237188:
> root@amd:~#
>
> > Or just low-level format it all with "hdparm --security-erase".
>
> I'd like to understand what is going on there. I can mark the blocks
> as bad at ext3 level, but I'd really like to understand what is going
> on there, and if it is hw issue, sata issue or block layer issue.
>
> (Plus, given that remapping does not work, I'd be afraid that it will
> kill the disk for good).
>
> The disk is
>
> root@amd:~# smartctl -a /dev/sda
> smartctl 5.40 2010-07-12 r3124 [i686-pc-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen,
> http://smartmontools.sourceforge.net
>
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Momentus 5400.6 series
> Device Model:     ST9500325AS
> Serial Number:    5VE41HDA
> Firmware Version: 0001SDM1
> User Capacity:    500,107,862,016 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   8
> ATA Standard is:  ATA-8-ACS revision 4
> Local Time is:    Sun Jun 23 23:49:15 2013 CEST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>
> Thanks for support,
> 									Pavel

Being tired of using hdparm manually, I created a simple hdd_realloc utility
that reads the disk in big blocks (1 MB). When there's a read error, it reads
the failed block sector-by-sector and tries to rewrite the sectors that fail
to read. It work fine for disks with just a couple of pending sectors.

#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#define BLOCK_SIZE	1048576
#define SECTOR_SIZE	512

int main(int argc, char *argv[]) {
	if (argc < 2) {
		fprintf(stderr, "Usage: %s <device> [pos]\n", argv[0]);
		return 1;
	}
	int dev = open(argv[1], O_RDWR | O_DIRECT | O_SYNC);
	if (dev < 1) {
		perror("Unable to open device");
		return 2;
	}

	posix_fadvise(dev, 0, 0, POSIX_FADV_RANDOM);

	off64_t startpos = 0, pos = 0;
	if (argc > 2) {
		sscanf(argv[2], "%lld", &startpos);
	}
	pos = startpos;
	char *buf = valloc(BLOCK_SIZE);
	char *zeros = valloc(SECTOR_SIZE);
	if (!buf || !zeros) {
		fprintf(stderr, "Memory allocation error\n");
		return 2;
	}
	memset(zeros, 0, SECTOR_SIZE);

	time_t starttime = time(NULL);

	while (1) {
		printf("\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b");
		printf("Position: %lld B (%lld MiB, %lld GiB, sector %lld), rate %lld MiB/s", pos, pos / 1024 / 1024,
			pos / 1024 / 1024 / 1024, pos / SECTOR_SIZE,
			(pos - startpos) / 1024 / 1024 / ((time(NULL) - starttime) ? (time(NULL) - starttime) : 1) );
		lseek64(dev, pos, SEEK_SET);
		int count = read(dev, buf, BLOCK_SIZE);
		if (count == 0)	{/* EOF */
			printf("End of disk\n");
			break;
		}
		if (count < 0) { /* read error */
			printf("\n");
			perror("Read error");
			printf("Examining %lld\n", pos);
			for (int i = 0; i < BLOCK_SIZE/SECTOR_SIZE; i++) {
				lseek64(dev, pos, SEEK_SET);
				if (read(dev, buf, SECTOR_SIZE) < SECTOR_SIZE) {
					printf("Unable to read at %lld, rewriting...", pos);
					lseek64(dev, pos, SEEK_SET);
					int result = write(dev, zeros, SECTOR_SIZE);
					if (result < 0) {
						printf("write error\n");
					} else {
						lseek64(dev, pos, SEEK_SET);
						if (read(dev, buf, SECTOR_SIZE) < SECTOR_SIZE)
							printf("read error after rewrite\n");
						else
							printf("OK\n");
					}
				}
				pos += SECTOR_SIZE;
			}
		} else /* no error */
			pos += count;
	}

	return 0;
}


-- 
Ondrej Zary
