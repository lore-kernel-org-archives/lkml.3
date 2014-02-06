Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbaBFA61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:58:27 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:60163 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbaBFA6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:58:25 -0500
Date: Thu, 6 Feb 2014 02:55:34 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ning Qu <quning@google.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140206005534.GA27848@node.dhcp.inet.fi>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 04:32:55PM -0800, Linus Torvalds wrote:
> On Sun, Jan 26, 2014 at 2:28 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Comments? This was obviously brought on by my frustration with the
> > currently nasty do_notify_resume() always returning to iret for the
> > task_work case, and PeterZ's patch that fixed that, but made the asm
> > mess even *worse*.
> 
> Actually, I should have taken a closer look.
> 
> Yes, do_notify_resume() is a real issue, and my stupid open/close
> test-case showed that part of the profile.
> 
> But the "iretq" that dominates on the kernel build is actually the
> page fault one.
> 
> I noticed this when I compared "-e cycles:pp" with "-e cycles:p". The
> single-p version shows largely the same profile for the kernel, except
> that instead of showing "iretq" as the big cost, it shows the first
> instruction in "page_fault".
> 
> In fact, even when *not* zoomed into the kernel DSO, "page_fault"
> actually takes 5% of CPU time according to pref report. That's really
> quite impressive.
> 
> I suspect the Haswell architecture has made everything else cheaper,
> and the exception overhead hasn't kept up. I'm wondering if there is
> anything we could do to speed this up - like doing gang lookup in the
> page cache and pre-populating the page tables opportunistically.

One thing that could help is THP for file-backed pages. And there's
prototype with basic infrasturure and support for ramfs and
shmem/tmpfs (by Ning Qu). Work in progress.

-- 
 Kirill A. Shutemov
