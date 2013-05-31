Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3EaNo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 09:44:58 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54767 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab3EaNov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 09:44:51 -0400
Date: Fri, 31 May 2013 15:44:45 +0200
From: Robert Richter <rric@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] perf tools: Persistent events, changes for perf tool
 integration
Message-ID: <20130531134445.GD2132@rric.localhost>
References: <1369991785-10499-1-git-send-email-rric@kernel.org>
 <20130531120720.GA7885@gmail.com>
 <20130531122443.GB17843@nazgul.tnic>
 <20130531124805.GA8659@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531124805.GA8659@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Fri, May 31, 2013 at 02:07:20PM +0200, Ingo Molnar wrote:
> > > For that I'd like to create a persistent event that just keeps
> > > running, and to which I can occasionally attach to read-only to see
> > > what's going on and maybe attach to it read-write to drain the trace
> > > entries. I.e. basically a global trace buffer. How do I achieve that
> > > with this new tooling?

Actually every system-wide event that is opened with readonly buffers
could be shared between processes, which would be the same as
connecting to a persistent event. I didn't want to implement this in a
first step, but I think this could be implemented without too much
effort.

The main problem is that at least one file descriptor needs to be open
at any time. Otherwise the event would be removed. So there is no
concept (except enabling an in-kernel event) yet to keep the event
running without any process having an event file discriptor open. Even
harder will it be to release such an event, there is no distincition
beetween detaching the event from the process or permanently removing
the event.

So the easiest would be to just open a system-wide event and then put
the process into sleep until we want to remove the event. In between
other processes (maybe duplicate on fork?) could attach to the same
buffer. Only if no process is attached to the event enymore the event
will be removed. Would that fit your purpose?

-Robert
