Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3FWVvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:51:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37909 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab3FWVvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:51:03 -0400
Date: Sun, 23 Jun 2013 23:51:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <mlord@pobox.com>
Cc: Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130623215100.GA7414@amd.pavel.ucw.cz>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
 <20130623112133.GA4837@amd.pavel.ucw.cz>
 <CAJBHPoj5hgp97=JH8UKX+Ty8TF9_ySQUYU6AnqcRjuLy5A-PcQ@mail.gmail.com>
 <20130623190003.GA6714@amd.pavel.ucw.cz>
 <51C76858.4060906@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C76858.4060906@pobox.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-06-23 17:27:52, Mark Lord wrote:
> On 13-06-23 03:00 PM, Pavel Machek wrote:
> >
> > Thanks for the hint. (Insert rant about hdparm documentation
> > explaining that it is bad idea, but not telling me _why_ is it bad
> > idea. Can I expect cache consistency issues after that, or is it just
> > simple "you are writing to the disk without any checks"? Plus, I guess
> > documentation should mention what sector number is. I guess sectors
> > are 512bytes for the old drives, but is it 512 or 4096 for new
> > drives?)
> 
> For ATA, use the "logical sector size".
> For all existing drives out there, that's a 512 byte unit.

I guessed so. (It would be good to actually document it, as well as
documenting exactly why it is dangerous. Is it okay to send patches?)

> > ...but it does not do the trick :-(. It behaves strangely as if it was
> > still cached somewhere. Do I need to turn off the write back cache?
> 
> No, it works just fine.  You probably have more than one bad sector.
> After you see a read failure, run "smartctl -a" and look at the error
> logs to see what sector the drive is choking on.

Well, I definitely have more than one bad sector, but I did try to
read exactly the same sector and it failed. See below.

root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
 961237188 /dev/sda | uniq

/dev/sda:
FAILED: Input/output error
reading sector 961237188: 
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --write-sector
961237188 /dev/sda

/dev/sda:
re-writing sector 961237188: succeeded
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
961237188 /dev/sda | uniq

/dev/sda:
FAILED: Input/output error
reading sector 961237188: 
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --write-sector
961237188 /dev/sda

/dev/sda:
re-writing sector 961237188: succeeded
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
961237188 /dev/sda | uniq

/dev/sda:
reading sector 961237188: succeeded
0000 0000 0000 0000 0000 0000 0000 0000
root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=4096
skip=$[8958947328/4096]
dd: reading `/dev/sda4': Input/output error
102+0 records in
102+0 records out
417792 bytes (418 kB) copied, 6.12536 s, 68.2 kB/s
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
961237188 /dev/sda | uniq

/dev/sda:
reading sector 961237188: succeeded
0000 0000 0000 0000 0000 0000 0000 0000
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
961237188 /dev/sda | uniq

/dev/sda:
reading sector 961237188: succeeded
0000 0000 0000 0000 0000 0000 0000 0000
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
961237188 /dev/sda | uniq

/dev/sda:
FAILED: Input/output error
reading sector 961237188: 
root@amd:~# 

> Or just low-level format it all with "hdparm --security-erase".

I'd like to understand what is going on there. I can mark the blocks
as bad at ext3 level, but I'd really like to understand what is going
on there, and if it is hw issue, sata issue or block layer issue.

(Plus, given that remapping does not work, I'd be afraid that it will
kill the disk for good).

The disk is

root@amd:~# smartctl -a /dev/sda
smartctl 5.40 2010-07-12 r3124 [i686-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen,
http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Momentus 5400.6 series
Device Model:     ST9500325AS
Serial Number:    5VE41HDA
Firmware Version: 0001SDM1
User Capacity:    500,107,862,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Jun 23 23:49:15 2013 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Thanks for support,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
