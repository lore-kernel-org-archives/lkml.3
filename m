Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbaDKJhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:37:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48134 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbaDKJhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:37:48 -0400
Date: Fri, 11 Apr 2014 11:37:15 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Xiao Jin <jin.xiao@intel.com>, jhovold@gmail.com,
        gnomes@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
Message-ID: <20140411093715.GA17522@localhost>
References: <53436770.9090008@intel.com>
 <53455FC6.7080009@intel.com>
 <1397116923.4802.10.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397116923.4802.10.camel@linux-fkkt.site>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +CC: Jiri and Peter ]

On Thu, Apr 10, 2014 at 10:02:03AM +0200, Oliver Neukum wrote:
> On Wed, 2014-04-09 at 22:57 +0800, Xiao Jin wrote:
> > Thanks all for the review. We meet with the problems when developing 
> > product. I would like to explain my understanding.
> > 
> > On 04/08/2014 11:05 AM, Xiao Jin wrote:
> > >
> > > We find two problems on acm tty write delayed mechanism.
> > > (1) When acm resume, the delayed wb will be started. But now
> > > only one write can be saved during acm suspend. More acm write
> > > may be abandoned.
> > 
> > The scenario usually happened when user space write series AT after acm 
> > suspend. If acm accept the first AT, what's the reason for acm to refuse 
> > the second AT? If write return 0, user space will try repeatedly until 
> > resume. It looks simpler that acm accept all the data and sent out urb 
> > when resume.
> 
> No. We cannot accept an arbitrary amount of data. It would let any
> user OOM the system. There will have to be an arbitrary limit.
> The simplest limit is 1 urb. And that is because we said that we
> are ready to accept data.

That doesn't make much sense. Either tty can handle write returning 0 or
it doesn't. Consider what happens when you get two consecutive writes
(both preceded by write_room). Why should buffering the first write
solve anything? In fact, it doesn't (at least not data being dropped).

If buffering is indeed needed, we must buffer at least as much data as
reported by write_room, which in this cause should amount to buffering
all write_urbs as Jin suggests.

And by the way, OOM is not an issue with Jin's patch as only ACM_NW (16)
urbs are allocated and can be queued (the buffer should probably have
been implemented using urb anchors, though).

> > > (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> > > close. If acm resume callback run after ASYNCB_INITIALIZED flag
> > > cleared, there will have no chance for delayed write to start.
> > > That lead to acm_wb.use can't be cleared. If user space open
> > > acm tty again and try to setd, tty will be blocked in
> > > tty_wait_until_sent for ever.
> > >
> > 
> > We see tty write and close concurrently after acm suspend in this case. 
> > It looks no method to avoid it from tty layer. acm_tty_write and
> 
> There is a delay user space can set.
> 
> > acm_resume call after acm_port_shutdown. It looks any action in 
> > acm_port_shutdown can't solve the problem. As acm has accepted the user 
> > space data, we can only find a way to send out urb. I feel anyway to 
> > discard the data looks like a lie to user space.

It's not a lie. Consider what happens if you write a large buffer to a
device using a 300 baud line? We have mechanisms (e.g. tcdrain() and
closing_wait) to let the user decide whether to wait for that data to
drain or not. Please also note that when using flow control, this could
take literally forever.

Jin, what is closing_wait set to in your application? The default is 30
seconds, which means there should have been plenty of the time for the
device to resume (and submit any buffered data).

> > In my understanding acm should accept data as much as possible, and send 
> > out urb as soon as possible. What do you think of?
> 
> There's certainly no problem with sending out the data. Yet
> simply resuming the device in shutdown() should do the job.

As soon as possible, yes, but again, we shouldn't be sending out urbs
at shutdown (that is were we stop transmissions). (Resuming the device at
close could be ok, but that would still be redundant as we have already
done the async autopm_get in write.)

If the data is precious, make sure to have a reasonable closing_wait, or
it may be dropped.

All that said, there are some serious bugs in the ACM driver: write is
dropping data and leaking write urbs, _and_ buffered urbs are never
reclaimed at shutdown.

If it is ok to not buffer anything in write even though write_room
returned >0, then I think we should simply rip out the buffering from
the ACM driver and rely on the tty buffers. Otherwise, we must make sure
that the buffer space matches what is returned by write_room and buffer
all 16 write-urbs if needed (preferably, using urb anchors).

When implementing the first option, I came across what appears to be a
line-discipline bug which needs to be addressed first, though. Please
have a look at the follow-up RFC.

Thanks,
Johan
