Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaBBUUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 15:20:30 -0500
Received: from mout.gmx.net ([212.227.15.18]:64576 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415AbaBBUU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 15:20:28 -0500
Date: Sun, 2 Feb 2014 21:20:24 +0100
From: Helge Deller <deller@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: Re: [GIT PULL] parisc updates for v3.14 (new pull request)
Message-ID: <20140202202024.GA7924@p100.box>
References: <20140201202320.GA1313@p100.box>
 <CAFLxGvy7vbKmQzyNvTbk35DX5cFGS99CE=nYE_Q0c=LVuD1x9A@mail.gmail.com>
 <20140202111552.GA2221@ls3530.box>
 <CA+55aFyoR0DHsbJ8qaE5mEmveZwnxDpxapXZdxHZ-BJnE0CDLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyoR0DHsbJ8qaE5mEmveZwnxDpxapXZdxHZ-BJnE0CDLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V03:K0:Ly9Wvgbh/wZLGSHmIsv9/WwaUC9GRFVGMFNCGiA7KjAO3TZUb66
 mPxopUJ/xYQIAOtCY9f6m3NL6XRKJ5dt7V/bXfTBioGufwS5attOAsjYsn6jTqXfv0Kji6f
 U2VLsjHtrGP3O6OreDqr0hx4ZrwSBQOFHRGIFKmNIiEt1V1NGCvcxoHgaADQ1PaMaJ2+PDX
 QWJAXJQcyp1de24tfMtRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

* Linus Torvalds <torvalds@linux-foundation.org>:
> On Sun, Feb 2, 2014 at 3:15 AM, Helge Deller <deller@gmx.de> wrote:
> >
> > Anyway, the suggested & untested patch below should fix the metag arch
> > to cope which my changes to fs/exec.c
> > ...
> > -#define STACK_RND_MASK (0)
> > +#define STACK_RND_MASK (-1)
> 
> I don't think that works. That completely breaks randomize_stack_top().
> So I'm not going to pull the parisc tree, this needs to be resolved sanely.
> In fact, I think that change to fs/exec.c is just completely broken:
> +       /* add some more stack size for stack randomization */
> +       stack_base += STACK_RND_MASK + 1;
> and that "+1" just doesn't make sense, and fundamentally breaks STACK_RND_MASK.
> It also seems to be entirely pointless, since the PAGE_ALIGN() that
> comes right afterwards will effectively do it anyway.
> 
> So NAK on that whole fs/exec.c change. Afaik it's just wrong, and it's stupid.

You are completely right - I have no idea what I was thinking.
I have removed completely the changes to fs/exec.c, built up a new
tree for you to pull and boot-tested it with 32- and 64bit parisc kernels.

Can you please consider pulling this new tree?
The full request follows here:
-------

Hi Linus,

please pull the latest updates for the parisc architecture from:

  git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-3.14

The three major changes in this patchset is a implementation for
flexible userspace memory maps, cache-flushing fixes (again), and a
long-discussed ABI change to make EWOULDBLOCK the same value as EAGAIN.

parisc has been the only platform where we had EWOULDBLOCK != EAGAIN to
keep HP-UX compatibility.  Since we will probably never implement full
HP-UX support, we prefer to drop this compatibility to make it easier
for us with Linux userspace programs which mostly never checked for both
values.  We don't expect major fall-outs because of this change, and if
we face some, we will simply rebuild the necessary applications in the
debian archives.

Thanks,
Helge

----------------------------------------------------------------
Guy Martin (1):
      parisc: Make EWOULDBLOCK be equal to EAGAIN on parisc

Helge Deller (5):
      parisc/sti_console: prefer Linux fonts over built-in ROM fonts
      parisc: fix cache-flushing
      parisc: wire up sched_setattr and sched_getattr
      parisc: convert uapi/asm/stat.h to use native types only
      parisc: add flexible mmap memory layout support

 arch/parisc/include/asm/cacheflush.h  |   2 -
 arch/parisc/include/asm/elf.h         |   4 +
 arch/parisc/include/asm/page.h        |   3 +-
 arch/parisc/include/asm/pgtable.h     |   1 +
 arch/parisc/include/asm/processor.h   |   2 +
 arch/parisc/include/asm/thread_info.h |  10 ++
 arch/parisc/include/uapi/asm/errno.h  |   2 +-
 arch/parisc/include/uapi/asm/stat.h   |  40 +++---
 arch/parisc/include/uapi/asm/unistd.h |   4 +-
 arch/parisc/kernel/cache.c            |  14 ++
 arch/parisc/kernel/process.c          |  21 ++-
 arch/parisc/kernel/sys_parisc.c       | 238 ++++++++++++++++++++++++++++------
 arch/parisc/kernel/syscall_table.S    |   2 +
 drivers/video/console/sticore.c       |   2 +-
 lib/fonts/Kconfig                     |   6 +-
 15 files changed, 278 insertions(+), 73 deletions(-)
