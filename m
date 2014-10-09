Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbaJIQOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:14:09 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59813 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaJIQOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:14:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, opw-kernel@googlegroups.com
Subject: Re: [PATCH] scsi: ips.c: use 64-bit time types
Date: Thu, 09 Oct 2014 18:13:51 +0200
Message-ID: <8784556.BJJ4i5hv9b@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412867594.13107.28.camel@jarvis.lan>
References: <1412799248-17181-1-git-send-email-ebru.akagunduz@gmail.com> <2518561.k9qJZyWstd@wuerfel> <1412867594.13107.28.camel@jarvis.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tZ6AW6iwOUTcleE1Yv7yWybp23FZQNoPShiKCN7xC29
 VzCL1gmGg3ERErucpV9FWpmnwzRDYfitCcGiupdngbt2o+/3Up
 pmsJj6oqiZp22HkdhyFABpgtRXCwATQb8y7bG3Jsm5ksSH9qR6
 FB4OE6q0nQQ0u89T7hVOYtMi4avYcRJaxuW/z+sGVAgjN7wNbP
 Ev712MDkJtMZAqGu6OsVJOiEo8GoZ4jbOO6GUxCvXTWFiduFXm
 CtVADiQxi3YGot8l1gZbtTqaNlFqvJR9x8kNwTc+s6gaeZoAFC
 DeSpYxqqf1/HRcokoAZox4ps4CIs6qiIjmHQKEWoysEbcmUYfv
 QVuMbN3krcN4fmU+hlS4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2014 08:13:14 James Bottomley wrote:
> On Thu, 2014-10-09 at 16:29 +0200, Arnd Bergmann wrote:
> > On Thursday 09 October 2014 06:40:26 James Bottomley wrote:
> > > On Wed, 2014-10-08 at 22:58 +0200, Arnd Bergmann wrote:
> > > > On Wednesday 08 October 2014 13:44:55 James Bottomley wrote:
> > > > > > diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
> > > > > > index 45b9566..ff2a0b3 100644
> > > > > > --- a/drivers/scsi/ips.h
> > > > > > +++ b/drivers/scsi/ips.h
> > > > > > @@ -1054,7 +1054,7 @@ typedef struct ips_ha {
> > > > > >     uint8_t            active;
> > > > > >     int                ioctl_reset;        /* IOCTL Requested Reset Flag */
> > > > > >     uint16_t           reset_count;        /* number of resets           */
> > > > > > -   time_t             last_ffdc;          /* last time we sent ffdc info*/
> > > > > > +   time64_t             last_ffdc;          /* last time we sent ffdc info*/
> > > > > >     uint8_t            slot_num;           /* PCI Slot Number            */
> > > > > >     int                ioctl_len;          /* size of ioctl buffer       */
> > > > > >     dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
> > > > > 
> > > > > This is completely pointless, isn't it?  All the ips driver cares about
> > > > > is that we send a FFDC time update every eight hours or so, so we can
> > > > > happily truncate the number of seconds to 32 bits for that calculation
> > > > > just keep the variable at 32 bits and do a time_after thing for the
> > > > > comparison.
> > > > 
> > > > Good point. The same has come up in a few other places, so I wonder if we
> > > > should introduce a proper way to do it that doesn't involve time_t.
> > > 
> > > We have, it's jiffies ... that's why I'm slightly non-plussed that this
> > > driver is using gettimeofday for something like this ... it was clearly
> > > a review failure when we put it in.
> > 
> > Actually there is more to it, as I just found upon reading the code
> > again (I had noticed it before when I first looked at the driver but
> > then forgotten about it):
> > 
> > ips_fix_ffdc_time() needs the correct current wall-clock time, no overflow
> > allowed, to stick the year/month/day/hour/minute/second value into
> > the ffdc command.
> 
> true, but we could call do_gettimeofday() in the routine when we know
> we're sending it.  And it only does this once every 8 hours.  My
> complaint is the do_gettimeofday() sitting in the fast path to see if
> the eight hours since the last time we sent the ffdc timestamp have
> elapsed.

Ok, fair enough.

> Actually, isn't there a version of the syscall that does return what
> this firmware is looking for (the year, month, day, hour, seconds
> values)?

Maybe rtc_ktime_to_tm()?

We would need a time64_t version of that anyway.


> > It's still slightly more expensive to do the function call and use a 64-bit
> > number on a 32-bit CPU, but it's not on the scale of doing a system call
> > here. You can probably judge best if it's worth the increase in complexity
> > to use jiffies for determining whether to send the update and then
> > use get_seconds64 (or similar) to read the wall-clock time, or whether
> > always using get_seconds64 would be good enough.
> 
> heh, well we need to correct ips_fix_ffdc_time() somehow.  I think
> converting the trigger mechanism to jiffies makes sense because the
> interval is so small and we already have the jiffies code overflow safe.

Ok. Ebru, can you have a look at doing this? I guess we have two separate
issues now, you can do one of them first:

a) replacing the use of do_gettimeofday() from ips_next() with jiffies
   comparison

b) fixing ips_fix_ffdc_time() to use 64-bit time, possibly using
   rtc_ktime_to_tm(ktime_get_real()) in the process to simplify the
   code.

	Arnd
