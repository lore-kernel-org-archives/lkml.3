Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab3FWTAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 15:00:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34720 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3FWTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 15:00:06 -0400
Date: Sun, 23 Jun 2013 21:00:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcus Overhagen <marcus.overhagen@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org, mlord@pobox.com
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130623190003.GA6714@amd.pavel.ucw.cz>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
 <20130623112133.GA4837@amd.pavel.ucw.cz>
 <CAJBHPoj5hgp97=JH8UKX+Ty8TF9_ySQUYU6AnqcRjuLy5A-PcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJBHPoj5hgp97=JH8UKX+Ty8TF9_ySQUYU6AnqcRjuLy5A-PcQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...Ok, lets try with dd.
> >
> > root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=1 skip=8958947328
> > dd: reading `/dev/sda4': Input/output error
> > 0+0 records in
> > 0+0 records out
> > 0 bytes (0 B) copied, 5.05805 s, 0.0 kB/s
> 
> I once noticed a similar problem. The trouble is that the kernel
> always seems to be doing a larger read access that failes for this
> sector, and the write is never executed.

And returns success writing? That's pretty antisocial :-(.

> You can try: hdparam --write-sector 961237188 /dev/sda

Thanks for the hint. (Insert rant about hdparm documentation
explaining that it is bad idea, but not telling me _why_ is it bad
idea. Can I expect cache consistency issues after that, or is it just
simple "you are writing to the disk without any checks"? Plus, I guess
documentation should mention what sector number is. I guess sectors
are 512bytes for the old drives, but is it 512 or 4096 for new
drives?)

...but it does not do the trick :-(. It behaves strangely as if it was
still cached somewhere. Do I need to turn off the write back cache?

root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
  read-sector: bad/missing sector value
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
  961237188 /dev/sda

/dev/sda:
reading sector 961237188: FAILED: Input/output error
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --write-sector
961237188 /dev/sda

/dev/sda:
re-writing sector 961237188: succeeded
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
961237188 /dev/sda | uniq

/dev/sda:
reading sector 961237188: succeeded
0000 0000 0000 0000 0000 0000 0000 0000
root@amd:~# sleep 10
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
961237188 /dev/sda | uniq

/dev/sda:
reading sector 961237188: succeeded
0000 0000 0000 0000 0000 0000 0000 0000
root@amd:~# sync
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
417792 bytes (418 kB) copied, 5.36697 s, 77.8 kB/s
root@amd:~# hdparm --yes-i-know-what-i-am-doing  --read-sector
961237188 /dev/sda | uniq

/dev/sda:
FAILED: Input/output error
reading sector 961237188: 
root@amd:~# 

Thanks,
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
