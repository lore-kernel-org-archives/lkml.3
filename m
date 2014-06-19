Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966271AbaFSV6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:58:34 -0400
Received: from mail.phunq.net ([184.71.0.62]:39088 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965284AbaFSV6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:58:32 -0400
From: Daniel Phillips <daniel@phunq.net>
To: =?utf-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Chinner <david@fromorbit.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Date: Thu, 19 Jun 2014 14:58:20 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
In-Reply-To: <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard> <537AA802.408@phunq.net>
 <20140520031802.GF18954@dastard> <20140613103216.GA4589@amd.pavel.ucw.cz>
 <02d3b094-808c-4b17-903d-1280d451704b@phunq.net>
 <20140613202039.GA23872@amd.pavel.ucw.cz>
 <b67e55e1-af54-4f34-802c-95749771aca4@phunq.net>
 <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 19, 2014 2:26:48 AM PDT, Lukáš Czerner wrote:
> On Thu, 19 Jun 2014, Pavel Machek wrote:
>
>> Date: Thu, 19 Jun 2014 10:21:29 +0200
>> From: Pavel Machek <pavel@ucw.cz>
>> To: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Cc: Daniel Phillips <daniel@phunq.net>, Dave Chinner 
>> <david@fromorbit.com>,
>> linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>  ...
>
> Flamed ? really ?

Yes, really. There were valid points and there were also unabashed flames. 
The latter are not helpful to anybody, even the flamer. But note that there 
were no counter flames. The boy scout rule applies: always leave your 
campsite cleaner than you found it.

> Dave pointed out some serious coding style problems.
> Those should be very easy to fix.

One needs to be careful about the definition of "fix" so that it does not 
turn into "throw the baby out with the bath water". Our kernel code 
necessarily has a few __KERNEL__ #ifdefs because the majority of it also 
runs in user space. This not a feature to disparage, far from it.

Among other benefits, running in user space supports automated unit testing 
at fine granularity. We run make tests as a habit to catch a wide spectrum 
of correctness regressions. A successful make tests usually indicates that 
the heavyweight kernel stress tests are going to pass. Obviously, there are 
occasional exceptions to this. For example user space does not catch SMP 
races. In practice, only a handful of those have slipped through and 
required kernel level bug chasing.

That said, we will will happily merge any concrete suggestion that reduces 
the frequency of __KERNEL__. But please be realistic. There are 32 
__KERNEL__ ifdefs in our 18K line code base. That hardly amounts to a 
"dog's breakfast".

> Let me remind you some more important problems Dave brought up,
> including page forking:
>
> "
>  The hacks around VFS and MM functionality need to have demonstrated
>  methods for being removed.

We already removed 450 lines of core kernel workarounds from Tux3 with an 
approach that was literally cut and pasted from one of Dave's emails. Then 
Dave changed his mind. Now the Tux3 team has been assigned a research 
project to improve core kernel writeback instead of simply adapting the 
approach that is already proven to work well enough. That is a rather 
blatant example of "perfect is the enemy of good enough". Please read the 
thread.

> We're not going to merge that page
>  forking stuff (like you were told at LSF 2013 more than a year ago:
>  http://lwn.net/Articles/548091/) without rigorous design review and
>  a demonstration of the solutions to all the hard corner cases it
>  has. The current code doesn't solve them (e.g. direct IO doesn't
>  work in tux3), and there's no clear patch set we can review that
>  demonstrates how it is all supposed to work. i.e. you need to
>  separate out all the page forking code into a separate patchset for
>  review, independent of the tux3 code and applies to the core mm/
>  code.
> "

Direct IO is a spurious issue. To recap: direct IO does not introduce any 
new page forking issues. All of the page forking issues already exist with 
normal buffered IO and mmap. We have little interest and scant available 
time for heading off on a tangent to implement direct IO at this point just 
as a precondition for merging.

On the other hand, page forking itself has a number of interesting issues. 
Hirofumi is currently preparing a set of core kernel patches for review. 
These patches explicitly do not attempt to package page forking up into a 
nice and easy API that other filesystems could patch in tomorrow. That 
would be an unreasonable research burden on our small development team. 
Instead, we show how it works in Tux3, and if other filesystems want to get 
those benefits, they can make similar changes. If we (the kernel community) 
are lucky enough to find a pattern in it such that substantial parts of the 
code can be abstracted into a library, then good. But requiring such a 
library to be developed as a precondition to merging Tux3 is unreasonable.

> "
>  Then there's all the writeback hacks. You've simply copy-n-pasted
>  most of fs-writeback.c, including duplicating structures like struct
>  wb_writeback_work and then hacked in crap (kallsyms lookups!) to be
>  able to access core structures from kernel module context
>  (tux3_setup_writeback(), I'm looking at you). This is completely
>  unacceptible for a merge. Again, you need to separate out all the
>  writeback changes you need into an independent patchset so that they
>  can be reviewed independently of the tux3 code that uses it.
> "

That was already fixed as noted above, and all the relevant changes were 
already posted as an independent patch set. After that, some developers 
weighed in with half formed ideas about how the same thing could be done 
better, but without concrete suggestions. There is nothing wrong with half 
formed ideas, except when they turn into a way of blocking forward 
progress. See "perfect is the enemy of good enough" above.

It is worth noting that we (the kernel community) have been thrashing away 
at the writeback problem for more than twenty years, and the current 
solution still leaves much to be desired. It is unfair to expect us, the 
Tux3 team, to fix that mess in a week or two, just to merge our filesystem. 
We prefer to adapt the existing infrastructure for now, as expressed in the 
currently proposed patch set. With that, we allow core to mark our inodes 
dirty just as it has always done, and we continue to use the usual inode 
writeback lists for writeback sheduling, which work just fine.

Regards,

Daniel

