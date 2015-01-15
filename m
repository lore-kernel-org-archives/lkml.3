Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbbAORM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:12:26 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62133 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbAORMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:12:25 -0500
Date: Thu, 15 Jan 2015 16:46:25 +0000
From: Petr Cermak <petrcermak@chromium.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Primiano Tucci <primiano@chromium.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 2/2] task_mmu: Add user-space support for resetting
 mm->hiwater_rss (peak RSS)
Message-ID: <20150115164625.GA11015@google.com>
References: <20150107172452.GA7922@node.dhcp.inet.fi>
 <20150114152225.GB31484@google.com>
 <20150114233954.GB14615@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114233954.GB14615@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 01:36:30AM +0200, Kirill A. Shutemov wrote:
> On Wed, Jan 14, 2015 at 03:22:25PM +0000, Petr Cermak wrote:
> > On Wed, Jan 07, 2015 at 07:24:52PM +0200, Kirill A. Shutemov wrote:
> > > And how it's not an ABI break?
> > I don't think this is an ABI break because the current behaviour is not
> > changed unless you write "5" to /proc/pid/clear_refs. If you do, you are
> > explicitly requesting the new functionality.
> 
> I'm not sure if it should be considered ABI break or not. Just asking.
> 
> I would like to hear opinion from other people.

We would like to get more feedback as well.

> > > We have never-lowering VmHWM for 9+ years. How can you know that nobody
> > > expects this behaviour?
> > This is why we sent an RFC [1] several weeks ago. We expect this to be
> > used mainly by performance-related tools (e.g. profilers) and from the
> > comments in the code [2] VmHWM seems to be a best-effort counter. If this
> > is strictly a no-go, I can only think of the following two alternatives:
> > 
> >   1. Add an extra resettable field to /proc/pid/status (e.g.
> >      resettable_hiwater_rss). While this doesn't violate the current
> >      definition of VmHWM, it adds an extra line to /proc/pid/status,
> >      which I think is a much bigger issue.
> 
> I don't think extra line is bigger issue. Sane applications would look for
> a key, not line number. We do add lines there. I've posted patch which
> adds one more just today ;)

In that case, should we add an extra field to /proc/pid/status?

> >   2. Introduce a new proc fs file to task_mmu (e.g.
> >      /proc/pid/profiler_stats), but this feels like overengineering.
> 
> BTW, we have memory.max_usage_in_byte in memory cgroup. And it's resetable.
> Wouldn't it be enough for your profiling use-case?

This is a very interesting point, but it doesn't cover all use cases.
Our specific use case is memory profiling of the Chromium browser, but I
think that the same considerations below apply to any other use case
which involves child sub-processes:

  1. The process must be added to the control group explicitly by root.
     Hence, the Chromium process cannot do this itself.
  2. All forked children are implicitly grouped in the same control
     group. This is a problem because we want to be able to measure
     memory usage of the child processes separately.

The advantage of using clear_refs instead is that Chomium would be able
to profile its memory usage without any external intervention (as it's
already the case with performance profiling).

> > > And why do you reset hiwater_rss, but not hiwater_vm?
> > This is a good point. Should we reset both using the same flag, or
> > introduce a new one ("6")?
> > 
> > [1] lkml.iu.edu/hypermail/linux/kernel/1412.1/01877.html
> > [2] task_mmu.c:32: "... such snapshots can always be inconsistent."

Petr
