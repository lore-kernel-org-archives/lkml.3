Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab3AXXzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 18:55:53 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53089 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3AXXzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 18:55:45 -0500
Date: Thu, 24 Jan 2013 15:55:41 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Amit Kale <akale@stec-inc.com>
Cc: Jason Warr <jason@warr.net>, "thornber@redhat.com" <thornber@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software for
 Linux kernel
Message-ID: <20130124235541.GR26407@google.com>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
 <20130117132620.GA2438@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <50F844A3.9020300@warr.net>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 05:08:37PM +0800, Amit Kale wrote:
> > From: Jason Warr [mailto:jason@warr.net]
> > On 01/17/2013 11:53 AM, Amit Kale wrote:
> > >>> 9. Performance - Throughput is generally most important. Latency is
> > >> >   also one more performance comparison point. Performance under
> > >> >   different load classes can be measured.
> > >> >
> > >> >   I think latency is more important than throughput.  Spindles are
> > >> >   pretty good at throughput.  In fact the mq policy tries to spot
> > when
> > >> >   we're doing large linear ios and stops hit counting; best leave
> > this
> > >> >   stuff on the spindle.
> > > I disagree. Latency is taken care of automatically when the number of
> > application threads rises.
> > >
> > 
> > Can you explain what you mean by that in a little more detail?
> 
> Let's say latency of a block device is 10ms for 4kB requests. With single threaded IO, the throughput will be 4kB/10ms = 400kB/s. If the device is capable of more throughput, a multithreaded IO will generate more throughput. So with 2 threads the throughput will be roughly 800kB/s. We can keep increasing the number of threads resulting in an approximately linear throughput. It'll saturate at the maximum capacity the device has. So it could saturate at perhaps at 8MB/s. Increasing the number of threads beyond this will not increase throughput.
> 
> This is a simplistic computation. Throughput, latency and number of threads are related in a more complex relationship. Latency is still important, but throughput is more important.
> 
> The way all this matters for SSD caching is, caching will typically show a higher latency compared to the base SSD, even for a 100% hit ratio. It may be possible to reach the maximum throughput achievable with the base SSD using a high number of threads. Let's say an SSD shows 450MB/s with 4 threads. A cache may show 440MB/s with 8 threads.

Going through the cache should only (measurably) increase latency for
writes, not reads (assuming they're cache hits, not misses). It sounds
like you're talking about the overhead for keeping the index up to date,
which is only a factor for writes, but I'm not quite sure since you talk
about hit rate.

I don't know of any reason why throughput or latency should be noticably
worse than raw for reads from cache.

But for writes, yeah - as number of of concurrent IOs goes up, you can
amortize the metadata writes more and more so throughput compared to raw
goes up. I don't think latency would change much vs. raw, you're always
going to have an extra metadata write to wait on... though there are
tricks you can do so the metadata write and data write can go down in
parallel. Bcache doesn't do those yet.

_But_, you only have to pay the metadata write penalty when you see a
cache flush/FUA write. In the absense of cache flushes/FUA, for
metadata purposes you can basically treat a stream as sequential writes
as going down in parallel.
