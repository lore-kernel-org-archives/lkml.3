Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaENLAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:00:30 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54193 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbaENLA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:00:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Wed, 14 May 2014 13:00:21 +0200
Message-ID: <8468354.y2kUZdOz9e@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdW5HSVyXpz9HFcrDDYq=zOFrBr6d8jOd8i_FMkXsEpr2Q@mail.gmail.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <8399002.IIyBoyEHox@wuerfel> <CAMuHMdW5HSVyXpz9HFcrDDYq=zOFrBr6d8jOd8i_FMkXsEpr2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MrBl8n8ppPhyRmu4x6k6KTi2D3mYTQwniBQS3T0UxFu
 rhHse2Hc5iRTYQu/xhCrIzo/E8OCb1sN9H7luSNcHM3jDdHc4S
 8Ln1K9WYJzRGyv+XQgXAb/351Cl/9VZHcKts98ABM/9Rx7IDdM
 aoG2CVTz5fjGmy5yrt6Enat5LdzkvZH4t3/Hr9x1JG8L4aQx+V
 b7jY09eNLR18PpwCTL67E7ZI0lDDcMVJLRRSV1Pi63COvo/g/i
 Tq9IXXktpxUGqjlcrw3YC+8SoMUNamXvKE5uC87k/PzX4uFGCu
 wLFYiPh0WOjnu9Z8Ys5sDI3d/cOyD/lndX0EmobkVTSoiPjKWP
 tvIC3a9pUIhiGJEArz/U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 22:35:08 Geert Uytterhoeven wrote:
> 
> On Tue, May 13, 2014 at 9:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > I think we have three categories:
> 
> Thanks for the list!
> 
> > a) interfaces that uses relative time_t/timespec/timeval:
> > b) interfaces that don't make sense for times in the past:
> 
> > c) interfaces that require absolute times:
> >    - stat/lstat/fstatat/
> >    - utime/utimes/futimesat
> >
> > These absolutely have to use something better than time_t
> > both in user space and in the kernel so we can deal with
> > old files. A lot of file systems need to be fixed as well so
> > we can actually store the times, regardless of whether we
> > are running a 32 or 64 bit kernel.
> 
> So these are the ones we have to worry about.
> It looks like they all involve I/O? Apart from the case of using block data
> from the buffer cache, the 64-bit operations should disappear in the
> actual I/O noise, right?

Right. Also there have been proposals for a better 'stat' replacement
for years, which would solve half of the interface problem for the
file system interfaces.

However, we also need to find a solution for category b), I only put
them into a different category above because we can treat them
differently in the kernel. For instance, we could use ktime_t for
the kernel code in category b) and a new struct timespec64 for
the times in struct inode.
On the user interface side, using timespec64 would be a reasonable
choice for both categories, because we already have two implementations
of all those syscalls in order to handle 32-on-64 compat tasks,
and we could use the same set of syscall implementations for time64-on-32.

	Arnd
