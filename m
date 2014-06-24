Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaFXBF6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 21:05:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaFXBF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 21:05:57 -0400
Date: Tue, 24 Jun 2014 03:05:54 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        hpa@linux.intel.com, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v8 4/4] printk: allow increasing the ring buffer
	depending on the number of CPUs
Message-ID: <20140624010554.GF27687@wotan.suse.de>
References: <1403124337-14886-1-git-send-email-mcgrof@do-not-panic.com> <1403124337-14886-4-git-send-email-mcgrof@do-not-panic.com> <20140623154134.43ac7ab63896cd9ebcba84b6@linux-foundation.org> <20140624002050.GC27687@wotan.suse.de> <20140623174533.88663e64.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623174533.88663e64.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 05:45:33PM -0700, Andrew Morton wrote:
> On Tue, 24 Jun 2014 02:20:50 +0200 "Luis R. Rodriguez" <mcgrof@suse.com> wrote:
> 
> > On Mon, Jun 23, 2014 at 03:41:34PM -0700, Andrew Morton wrote:
> > > On Wed, 18 Jun 2014 13:45:37 -0700 "Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:
> > > 
> > > > ...
> > > >
> > > > If an increase is required the ring buffer is increased to
> > > > +	  the next power of 2 that can fit both the minimum kernel ring buffer
> > > > +	  (LOG_BUF_SHIFT) plus the additional worst case CPU contributions.
> > > >
> > > > ...
> > > >
> > > > +	log_buf_len_update(cpu_extra + __LOG_BUF_LEN);
> > > > +}
> > > 
> > > I'd have expected
> > > 
> > >   total_cpu_space = minimum-per-cpu-len * nr_possible_cpus;
> > >   log_buf_len = max(__LOG_BUF_LEN, total_cpu_space)
> > > 
> > > but here you added __LOG_BUF_LEN to total_cpu_space and I cannot work
> > > out why.  
> > > .
> > 
> > Ah, because its cpu_extra, not total_cpu_space that is being
> > computed, the goal was to see how much extra junk on the
> > worst case a CPU might contribute. The __LOG_BUF_LEN is the
> > default size, so we combine both.
> 
> Well...  why?  Isn't it simpler and more direct to say "I want at least
> 32k per CPU"?

That's certainly another way to go about this, but the original motivation
was trying to figure out the additional *extra* junk a CPU might spewed out,
it set out with an assumption of a base start from the first CPU booting the
system and that first CPU using the default kernel ring buffer size. The
language in the patch describes the worst case extra CPU junk contributed,
rather than a specific full split of the kernel ring buffer as that's typically
how extra junk is spewered out to the ring bufer and the concern. In general
on idle each CPU only contributes about only 1 to max 2 lines. The focus then
is the worst case on contribution.

Another note --  since this option depends on SMP and !BASE_SMALL technically 
num_possible_cpus() won't ever return something smaller than or equal to 1
but because of the default values chosen the -1 on the compuation does affect
whether or not this will trigger on > 64 CPUs or >= 64 CPUs, keeping the
-1 means we require > 64 CPUs.

This all can be changed however we like but the language and explained logic
would just need to be changed.

  Luis
