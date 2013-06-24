Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275Ab3FXM2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:28:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54881 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab3FXM2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:28:05 -0400
Date: Mon, 24 Jun 2013 14:28:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marcus Overhagen <marcus.overhagen@gmail.com>
Cc: Mark Lord <mlord@pobox.com>, kernel list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
Message-ID: <20130624122801.GA21124@amd.pavel.ucw.cz>
References: <20130623101940.GA4448@amd.pavel.ucw.cz>
 <20130623112133.GA4837@amd.pavel.ucw.cz>
 <CAJBHPoj5hgp97=JH8UKX+Ty8TF9_ySQUYU6AnqcRjuLy5A-PcQ@mail.gmail.com>
 <20130623190003.GA6714@amd.pavel.ucw.cz>
 <51C76858.4060906@pobox.com>
 <20130623215100.GA7414@amd.pavel.ucw.cz>
 <51C77840.2060800@pobox.com>
 <CAJBHPojcNeCu1MPd8uM19KPdtaypALDRLaWUt+oRUOeJ9erYPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJBHPojcNeCu1MPd8uM19KPdtaypALDRLaWUt+oRUOeJ9erYPA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > root@amd:~# dd if=/dev/sda4 of=/dev/zero bs=1 skip=8958947328
> > > > dd: reading `/dev/sda4': Input/output error
> > > > 0+0 records in
> > > > 0+0 records out
> > > > 0 bytes (0 B) copied, 5.05805 s, 0.0 kB/s
> > >
> > > I once noticed a similar problem. The trouble is that the kernel
> > > always seems to be doing a larger read access that failes for this
> > > sector, and the write is never executed.
> >
> > And returns success writing? That's pretty antisocial :-(.
> 
> On a second look i see that you have if and of reversed in the dd command.

Well, I was doing two dd commands, one to overwrite with zeros, one to
read...

> However, what I was referring to was that writing a single sector with dd
> will fail with a io error because the kernel first seems to do a
> larger read.

I see. But it seems that I'm not hitting this one.

> > ...but it does not do the trick :-(. It behaves strangely as if it was
> > still cached somewhere. Do I need to turn off the write back cache?
> 
> I used hdparm --write-sector successfully to fix a single sector where
> dd would fail, but I really don't know what going on with your disk. I
> guess your harddisk is having some more issues than this single
> sector. If you haven't done it yet, make a complete backup!

It looks like I went from ~10 bad sectors to ~2. But the last 2 seem
to be very persistent :-(.

> So assuming(!) that sector 961237184of sda  is logical block 17498759
> from sda4, you may need to write all sectors 961237184 to 961237193.
> 
> However, regarding the smart data, the drive still thinks that it's
> pretty healthy, only 3 reallocated sectors, and no pending.

Well, after remapping experiments, I'm up to 6 sectors reallocated,
and drive no longer thinks it is so healthy (see 187), but... still refuses.

  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       6
  7 Seek_Error_Rate         0x000f   084   060   030    Pre-fail  Always       -       294493007
  9 Power_On_Hours          0x0032   068   068   000    Old_age  Always       -       28275
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   099   037   020    Old_age  Always       -       1024
184 End-to-End_Error        0x0032   100   100   099    Old_age  Always       -       0
187 Reported_Uncorrect      0x0032   001   001   000    Old_age  Always       -       162

> Perhaps writing the whole disk with dd and a larger blocksize would
> ill work? something like
> 
> dd if=/dev/zero of=/dev/sda bs=1M
> 
> You shouldn't have any partiton monted when doing so. All data ist
> lost after that is finished. then you can look into the smart data to
> see how many sectors were reallocated, and decide if you want to trash
> the disk.

Well, the disk is 500GB, in notebook, and it is my primary
machine. I'm running backups now, but "full backup" is not exactly
easy, and doing complete erase would be few days of work :-(.

Fortunately, affected area is in small, ~15G partition, I don't really
_need_.

But I'd really like to understand what is going on there. New hdd for
the notebook is not out of question, but... AFAICT I can expect cca
4MB per second from the disk (it would be USB->SATA copy), and that
would be 34 hours...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
