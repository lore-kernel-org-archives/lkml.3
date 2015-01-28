Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbbA2Boa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:44:30 -0500
Received: from mga01.intel.com ([192.55.52.88]:23520 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbbA2BoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:44:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,483,1418112000"; 
   d="scan'208";a="658308871"
Message-ID: <1422487208.6127.44.camel@picadillo>
Subject: Re: [PATCH 05/10] drivers/char: Support compiling out /dev/zero
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 17:20:08 -0600
In-Reply-To: <20150128215106.GA6338@cloud>
References: <cover.1422035184.git.tom.zanussi@linux.intel.com>
	 <79846ac644fe9103ef9b7cb0ab69e6f196f27853.1422035184.git.tom.zanussi@linux.intel.com>
	 <20150128210751.GA14006@amd> <20150128215106.GA6338@cloud>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 13:51 -0800, josh@joshtriplett.org wrote:
> On Wed, Jan 28, 2015 at 10:07:51PM +0100, Pavel Machek wrote:
> > On Fri 2015-01-23 12:37:11, Tom Zanussi wrote:
> > > Some embedded systems with tightly controlled userspace have no use
> > > for /dev/zero, and could benefit from the size savings gained by
> > > omitting it.  Add a new EMBEDDED config option to disable it.
> > > 
> > > bloat-o-meter (based on tinyconfig):
> > > 
> > > add/remove: 0/3 grow/shrink: 0/1 up/down: 0/-391 (-391)
> > > function                                     old     new   delta
> > > chr_dev_init                                 162     147     -15
> > > mmap_zero                                     16       -     -16
> > > zero_fops                                    116       -    -116
> > > zero_bdi                                     244       -    -244
> > > 
> > > Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
> > 
> > I'm not sure that 400 bytes are worth additional Kconfig noise. .. and
> > pretty much everyone needs /dev/zero...
> 
> Relatively few, actually, given MMAP_ANONYMOUS.  Memory isn't allocated
> via an mmap of /dev/zero.  It's useful for systems with shells that want
> to redirect from it or read from it, but less useful for environments
> with entirely compiled code.
> 
> /dev/null is much more commonly needed, though there are still systems
> that won't need it (and can just disable read/writes on an fd entirely
> rather than duping /dev/null to that fd).
> 

For testing, I was able to boot my dev system (Ubuntu) into a usable
shell with networking with only /dev/null and /dev/urandom.  A
restricted userspace could be made/verified to not touch /dev/null. 

> That said, I'd be entirely in favor of consolidating many of these
> "miscellaneous character device" options into a couple of Kconfig
> options.  It doesn't seem critical to *individually* control each of
> these files in /dev.
> 

I can easily create a small set of groupings instead - how about
something like:  DEVMEM_RANDOM(/dev/random, /dev/urandom, getrandom()),
DEVMEM_MEM (/dev/mem, /dev/kmem, /dev/port), DEVMEM_RW
(/dev/null, /dev/zero), and DEVMEM_MISC (/dev/full, /dev/kmsg)?

That cuts the number in half, from 8->4 (we still have a separate
DEVPORT and DEVKMEM regardless).

I can also get rid of DEVMEM_RANDOM entirely as mentioned in a previous
post, and not allow those to be disabled at all, which saves even more
on Kconfig noise.

If you have better ideas and/or naming, please let me know.

> Personally, I'm hoping that we eventually end up with a disableable
> CONFIG_CHAR similar to CONFIG_BLOCK.
> 

If we ditch DEVMEM_RANDOM i.e. make certain devices undisableable then
it seems CONFIG_CHAR wouldn't be possible either.

Tom

> - Josh Triplett


