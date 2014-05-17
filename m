Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaEQGQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 02:16:00 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:50776 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaEQGP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 02:15:58 -0400
Date: Sat, 17 May 2014 10:15:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
Message-ID: <20140517061555.GX28328@moon>
References: <20140515084558.GI28328@moon>
 <CALCETrWwWXEoNparvhx4yJB8YmiUBZCuR6yQxJOTjYKuA8AdqQ@mail.gmail.com>
 <20140515195320.GR28328@moon>
 <CALCETrWbf8XYvBh=zdyOBqVqRd7s8SVbbDX=O2X+zAZn83r-bw@mail.gmail.com>
 <20140515201914.GS28328@moon>
 <20140515213124.GT28328@moon>
 <CALCETrXe80dx+ODPF1o2iUMOEOO_JAdev4f9gOQ4SUj4JQv36Q@mail.gmail.com>
 <20140515215722.GU28328@moon>
 <CALCETrUTM7ZJrWvWa4bHi0RSFhzAZu7+z5XHbJuP+==Cd8GRqw@mail.gmail.com>
 <CALCETrU5-4sMyOW7t75PJ4RQ3WdUg=s2xhYG5uEstm_LEOV+mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrU5-4sMyOW7t75PJ4RQ3WdUg=s2xhYG5uEstm_LEOV+mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 03:40:48PM -0700, Andy Lutomirski wrote:
> >>
> >> There are other ways how to find where additional pages are laying but it
> >> would be great if there a straightforward interface for that (ie some mark
> >> in /proc/pid/maps output).
> >
> > I'll try to write a patch in time for 3.15.
> >
> 
> My current draft is here:
> 
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=vdso/cleanups
> 
> On 64-bit userspace, it results in:
> 
> 7fffa1dfd000-7fffa1dfe000 r-xp 00000000 00:00 0                          [vdso]
> 7fffa1dfe000-7fffa1e00000 r--p 00000000 00:00 0                          [vvar]
> ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0                  [vsyscall]
> 
> On 32-bit userspace, it results in:
> 
> f7748000-f7749000 r-xp 00000000 00:00 0                                  [vdso]
> f7749000-f774b000 r--p 00000000 00:00 0                                  [vvar]
> ffd94000-ffdb5000 rw-p 00000000 00:00 0                                  [stack]
> 
> Is this good for CRIU?  Another approach would be to name both of
> these things "vdso", since they are sort of both the vdso, but that
> might be a bit confusing -- [vvar] is not static text the way that
> [vdso] is.

Yeah, thanks a lot, Andy, this is more than enough.

> If I backport this for 3.15 (which might be nasty -- I would argue
> that the code change is actually a cleanup, but it's fairly
> intrusive), then [vvar] will be *before* [vdso], not after it.  I'd be
> very hesitant to name both of them "[vdso]" in that case, since there
> is probably code that assumes that the beginning of "[vdso]" is a DSO.
> 
> Note that it is *not* safe to blindly read from "[vvar]".  On some
> configurations you *will* get SIGBUS if you try to read from some of
> the vvar pages.  (That's what started this whole thread.)  Some pages
> in "[vvar]" may have strange caching modes, so SIGBUS might not be the
> only surprising thing about poking at it.

Ouch. Thanks for the note, I'll read new code with more attention and
report the effect it did over criu (prob. on next week).
