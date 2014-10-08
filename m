Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaJHU6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:58:42 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:55400 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaJHU6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:58:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
Subject: Re: [PATCH] scsi: ips.c: use 64-bit time types
Date: Wed, 08 Oct 2014 22:58:32 +0200
Message-ID: <9985506.Mg7cltjCP9@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412801095.32718.13.camel@jarvis>
References: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com> <1412801095.32718.13.camel@jarvis>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:JZmxlYFpLePcqAnufQrdsLkFSqLmQk8qP4rTciNC5A4
 HtWidR0+PIhS0oon2oS1Q+jWep/sZtPf4z6+bWuxVU0JqHrAr/
 LznDJ4JIKPzAdIQ2lFJTrhhCXFuCXcyCONQx/nuax+CuSK6Ihi
 bWRr3bkfckelFj6U8M8hxZlhZgTFVk/moxxyqHgjUQ/xAFsYsC
 51vdg1XuUsMTMvXoUrDXfK1FWaAc0CQfpM6NBGvDaIfH2ChBzL
 suLT8vR7WlxJ8aVec5E8aqD2XWyBaEa26oYyoZ8ifj/MrjThur
 YjEsh2GIZ5HMDskl4FihJ8nwweSV55zkODqmjfInyRtrMKmXmI
 vyIHrNFO4RRkwVh7qDwg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2014 13:44:55 James Bottomley wrote:
> > diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
> > index 45b9566..ff2a0b3 100644
> > --- a/drivers/scsi/ips.h
> > +++ b/drivers/scsi/ips.h
> > @@ -1054,7 +1054,7 @@ typedef struct ips_ha {
> >     uint8_t            active;
> >     int                ioctl_reset;        /* IOCTL Requested Reset Flag */
> >     uint16_t           reset_count;        /* number of resets           */
> > -   time_t             last_ffdc;          /* last time we sent ffdc info*/
> > +   time64_t             last_ffdc;          /* last time we sent ffdc info*/
> >     uint8_t            slot_num;           /* PCI Slot Number            */
> >     int                ioctl_len;          /* size of ioctl buffer       */
> >     dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
> 
> This is completely pointless, isn't it?  All the ips driver cares about
> is that we send a FFDC time update every eight hours or so, so we can
> happily truncate the number of seconds to 32 bits for that calculation
> just keep the variable at 32 bits and do a time_after thing for the
> comparison.

Good point. The same has come up in a few other places, so I wonder if we
should introduce a proper way to do it that doesn't involve time_t.

While the current code works, we will have to audit 2000 other locations
in which time_t/timespec/timeval are used in the kernel, so we are going
to need some form of annotation to make sure we don't get everyone to
look at the driver again just to come to the same conclusion after working
on a patch first.

> However, what the code *should* be doing is using jiffies and
> time_before/after since the interval is so tiny rather than a
> do_gettimeofday() call in the fast path.

Yes, this would probably be best for this particular driver, it also
means we end up with a monotonic clock source rather than a wall-clock.

Ebru, when I explained the various data types we have for timekeeping,
I failed to mention jiffies. That is one that is very fast to access
and has a resolution between 1 and 10 milliseconds but will overflow
within a few months, so it can only be used in places where overflow
is known to be handled safely, as time_before() does.

	Arnd
