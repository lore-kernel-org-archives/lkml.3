Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbaDVUyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:54:47 -0400
Received: from one.firstfloor.org ([193.170.194.197]:55907 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561AbaDVUyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:54:41 -0400
Date: Tue, 22 Apr 2014 22:54:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org, acme@redhat.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org, eranian@google.com,
        andi@firstfloor.org, wcohen@redhat.com
Subject: Re: mapping instructions to dynamic languages like java, python,
 ruby
Message-ID: <20140422205439.GM22728@two.firstfloor.org>
References: <20140422180305.GK8488@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422180305.GK8488@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does anyone have any thoughts or experience on this?

perf has a JIT interface today, but it's extremely primitive
and only supports symbols. Clearly it could be done better.

Various JITs (e.g. Java) have special debug interfaces for this.

Various non perf profilers support it too. e.g. Vtune has a special
API for it:
https://software.intel.com/sites/default/files/jit_profiling_api_lin_0.pdf

Essentially you would need to write a JIT specific adapter 
that translates to perf format. Or emulate the Vtune interface
and reuse existing Vtune adaptations.

perf record needs some kind of side band interface where the JIT adapter
can report to it:
- symbols
- the assembler code (so it can be shown)
- source lines
- report any changes when JITed code changes

Then perf record could put that information into the perf.data.

In theory that information could be passed through the kernel,
but just using some user protocol (unix sockets or files) would be 
likely enough. The current interface uses files in /tmp.
I would likely change that, it's not clear even if it's secure.

It's likely a substantial project.

It would be even useful for the kernel, as the kernel does JITing 
itself these days.

-Andi
