Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbaEOQh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:37:27 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:59752 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaEOQh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:37:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Thu, 15 May 2014 18:36:54 +0200
Message-ID: <9176609.NChAu49t7f@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400168823.7862.9.camel@dabdike>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <8468354.y2kUZdOz9e@wuerfel> <1400168823.7862.9.camel@dabdike>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:quxDgM7tDFJTnE7+weDLuDuJvwUeOgXSAhGFbMqh7kF
 4/ApXBag+WRxDPFmN4mPII5bjjKTA+REfNEOlq21MQAQXw4FgN
 3EqdCn28u7d/XJQNVQuzWt1Q2IjvLmOxV5FG/+4NB2EkNsgyqK
 JY5LVXTKN8PseBkyrKWrpKIxsUZUErQgm6Nfm+HebkFqEME5Eb
 NqTuTakftPnAScHcLeaSa4HBDPVfgPFfw6HstwQskxgnxrMpHj
 H/7Eab9BB6Aqz0tRg+S2FObkDA3bO46PcR2CI8ZhnfvvhHy5G/
 jEq1PsbeBkeah2/RMs3O4FQSVG6zw944FHVx2Pszac76qH6TZl
 eDJmigfaF7ECobViwO9w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 May 2014 11:47:03 James Bottomley wrote:
> On Wed, 2014-05-14 at 13:00 +0200, Arnd Bergmann wrote:
> > On Tuesday 13 May 2014 22:35:08 Geert Uytterhoeven wrote:
> > > 
> > > On Tue, May 13, 2014 at 9:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > > > I think we have three categories:
> > > 
> > > Thanks for the list!
> > > 
> > > > a) interfaces that uses relative time_t/timespec/timeval:
> > > > b) interfaces that don't make sense for times in the past:
> > > 
> > > > c) interfaces that require absolute times:
> > > >    - stat/lstat/fstatat/
> > > >    - utime/utimes/futimesat
> > > >
> > > > These absolutely have to use something better than time_t
> > > > both in user space and in the kernel so we can deal with
> > > > old files. A lot of file systems need to be fixed as well so
> > > > we can actually store the times, regardless of whether we
> > > > are running a 32 or 64 bit kernel.
> > > 
> > > So these are the ones we have to worry about.
> > > It looks like they all involve I/O? Apart from the case of using block data
> > > from the buffer cache, the 64-bit operations should disappear in the
> > > actual I/O noise, right?
> > 
> > Right. Also there have been proposals for a better 'stat' replacement
> > for years, which would solve half of the interface problem for the
> > file system interfaces.
> > 
> > However, we also need to find a solution for category b), I only put
> > them into a different category above because we can treat them
> > differently in the kernel. For instance, we could use ktime_t for
> > the kernel code in category b) and a new struct timespec64 for
> > the times in struct inode.
> > On the user interface side, using timespec64 would be a reasonable
> > choice for both categories, because we already have two implementations
> > of all those syscalls in order to handle 32-on-64 compat tasks,
> > and we could use the same set of syscall implementations for time64-on-32.
> 
> To step back a bit, is a 64 bit time_t actually a good solution on 32
> bits?  Paying a 64 bit penalty on every time operation does seem a bit
> overkill.  Most eventual uses are either monotonic counting or relative
> addition/subtraction.  If we added an additional 32 bit quantity called
> epoch, this would increase once every 68 years.  Within the kernel, we
> could do intelligent interpolation about what the epoch is, so in 2039
> if we get a low 32 bit time_t value, we assume epoch == 1, conversely if
> we see a high one, we assume epoch == 0.  We could add epoch on the end
> of the syscalls and detect if it's not present and fill in an
> interpolated value.  Interfaces which truly want 64 bit time_t would get
> it from epoch + 32 bit time_t.

The main advantage that I see with 64-bit time_t is that a lot of user
space already works with it, because NetBSD and OpenBSD use this, and
all 64-bit Linux systems already work with this without changing the ABI.
If we want a POSIX extension to cover a new ABI, this would be the most
likely candidate.

For Linux-only interfaces, the 64-bit nanosecond timestamps seem like
a good alternative, and they would also speed up the 64-bit architectures
because we can skip the normalization.

As mentioned earlier, between kernel and user space it's probably best
to avoid time_t and timeval completely and just use timespec64 or some
other safe type, but there has to be a way to port user space that relies
on time_t or timespec.

	Arnd
