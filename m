Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab3HSVYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:24:47 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:40603 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3HSVYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:24:44 -0400
X-ASG-Debug-ID: 1376947483-0421b502202a7830001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>, Al Viro <viro@zeniv.linux.org.uk>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
CC: Simon Kirby <sim@hostway.ca>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20130706000949.GD16853@hostway.ca>
 <CAOJsxLGA+Aha8JcPsWyNd3BLQ6L0g7iznN0o2fG5yL5Xw0s8Lg@mail.gmail.com>
 <20130819201717.GA23608@hostway.ca>
 <0000014098447577-0d3e3f6b-f97b-4c73-946d-d70b697ce194-000000@email.amazonses.com>
 <CA+55aFxiYzxLDUnr+9BGQ+fsfmb1T8_zW4fOOC=SQ4rVzwbv4A@mail.gmail.com>
Message-ID: <20130819212441.17880.16729@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
Date: Mon, 19 Aug 2013 17:24:41 -0400
X-ASG-Orig-Subj: Re: [3.10] Oopses in kmem_cache_allocate() via prepare_creds()
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1376947483
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.138850
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Linus Torvalds (2013-08-19 17:16:36)
> On Mon, Aug 19, 2013 at 1:29 PM, Christoph Lameter <cl@gentwo.org> wrote:
> > On Mon, 19 Aug 2013, Simon Kirby wrote:
> >
> >>    [... ]  The
> >> alloc/free traces are always the same -- always alloc_pipe_info and
> >> free_pipe_info. This is seen on 3.10 and (now) 3.11-rc4:
> >>
> >> Object ffff880090f19e78: 6b 6b 6b 6b 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkklkkkkkkkkkkk
> >
> > This looks like an increment after free in the second 32 bit value of the
> > structure. First 32 bit value's poison is unchanged.
> 
> Ugh. If that is "struct pipe_inode_info" and I read it right, that's
> the "wait_lock" spinlock that is part of the mutex.
> 
> Doing a "spin_lock()" could indeed cause an increment operation. But
> it still sounds like a very odd case. And even for some wild pointer
> I'd then expect the spin_unlock to also happen, and to then increment
> the next byte (or word) too. More importantly, for a mutex, I'd expect
> the *other* fields to be corrupted too (the "waiter" field etc). That
> is, unless we're still spinning waiting for the mutex, but with that
> value we shouldn't, as far as I can see.
> 

Simon, is this box doing btrfs send/receive?  If so, it's probably where
this pipe is coming from.

Linus' CONFIG_DEBUG_PAGE_ALLOC suggestions are going to be the fastest
way to find it, I can give you a patch if it'll help.

It would be nice if you could trigger this on plain 3.11-rcX instead of
btrfs-next.

-chris
