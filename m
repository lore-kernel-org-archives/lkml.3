Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbaDVUDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:03:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:56063 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbaDVUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:02:27 -0400
Date: Tue, 22 Apr 2014 20:26:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@redhat.com, jolsa@redhat.com, namhyung@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com, andi@firstfloor.org,
        wcohen@redhat.com, penberg@kernel.org
Subject: Re: mapping instructions to dynamic languages like java, python, ruby
Message-ID: <20140422182627.GU26782@laptop.programming.kicks-ass.net>
References: <20140422180305.GK8488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422180305.GK8488@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 02:03:05PM -0400, Don Zickus wrote:
> Hi,
> 
> I was discussing recently with Will Cohen about how to get perf to
> understand dynamic languages (java, python, ruby) better.  Currently, perf
> samples and address, stores it in a mmap region (from the kernel side),
> the mmap region is read (from user side async) and stored in a file.
> 
> During 'perf report' those instruction addresses are looked up in the
> dwarf table?? of the binary they were mapped to, to resolve their symbols.
> 
> This works great for statically compiled binaries (like C), where the
> addresses stay the same during each run of the binary.
> 
> However, for dynamic languages like java, python, ruby not only do those
> addresses change each run of the binary, those address can change
> _during_ the execution of the binary.  As a result the normal perf
> collection method fails.

So we have one JIT supported, I forgot the exact details, but it writes
it symbol table to /tmp/perf-* files. I think the JIT in question will
never over-write symbols in debug mode.

One way to do this would be having two JIT areas, and copy the active
symbols into the 'new' one, and recycle the 'old' one.

Pekka used it for his JIT, so he might have some 'sample' code.

> Oprofile has a mechanism to work around this, by creating a debug library
> for java that records class information.  This library is linked?? during
> the initial execution of the java program and all its symbol info is
> recorded in a temp file.  During post-processing this temp file is read
> back in and symbol info is obtained.
> 
> However, this approach is java specific and only works for programs that
> initially start with it (can not attach to running programs).

Right, we're in the same position.

> Thoughts have come up about using a SIGPROF from the kernel to signal the
> userspace interpreters to dump information to a temp file that can be used
> later during post-processing.
> 
> Does anyone have any thoughts or experience on this?

I know Stephane worked with some JIT languages, I'll let him tell.
