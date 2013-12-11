Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3LKRtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:49:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42221 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3LKRtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:49:11 -0500
Date: Wed, 11 Dec 2013 17:49:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Potentially unbounded allocations in seq_read?
Message-ID: <20131211174909.GW10323@ZenIV.linux.org.uk>
References: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386781481.6066.55.camel@tursulin-linux.isw.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 05:04:41PM +0000, Tvrtko Ursulin wrote:
> Hi all,
> 
> It seems that the buffer allocation in seq_read can double in size
> indefinitely, at least I've seen that in practice with /proc/<pid>/smaps
> (attempting to double m->size to 4M on a read of 1000 bytes). This
> produces an ugly WARN_ON_ONCE, which should perhaps be avoided? (given
> that it can be triggered by userspace at will)

An entry in /proc/<pid>/smaps that did not fit into 2Mb?  Seriously?
How in hell has that happened?  If you can trigger that at will, please
post the reproducer.

> >From the top comment in seq_file.c one would think that it is a
> fundamental limitation of the current code that everything which will be
> read (even if in chunks) needs to be in the kernel side buffer at the
> same time?
> 
> If that is true then only way to fix it would be to completely re-design
> the seq_file interface, just silencing the allocation failure with
> __GFP_NOWARN perhaps as a temporary measure.
> 
> As an alternative, since it does sound a bit pathological, perhaps users
> for seq_file who know can be printing out such huge amounts of text
> should just use a different (new?) facility?

If a seq_file user is attempting to spew a couple of megs of text in one
->show() call, there's definitely something misused.  Either they ought
to use a different iterator (might be feasible if that monster entry is
produced by some kind of loop) or just not use seq_file at all.

I'm very surprised that /proc/*/smaps has managed to step into that,
though - show_pid_smap() shouldn't be able to do so, AFAICS...
