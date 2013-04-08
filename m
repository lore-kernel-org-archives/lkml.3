Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935996Ab3DHXHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:07:06 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33039 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab3DHXHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:07:02 -0400
Date: Tue, 9 Apr 2013 00:06:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Nathan Zimmer <nzimmer@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: hangs on boot in 9984d7394618df9
Message-ID: <20130408230658.GY4068@ZenIV.linux.org.uk>
References: <20130405173623.GE4068@ZenIV.linux.org.uk>
 <515F3A71.9080008@sgi.com>
 <20130405210042.GH4068@ZenIV.linux.org.uk>
 <5162E36F.5020305@sgi.com>
 <20130408155847.GS4068@ZenIV.linux.org.uk>
 <51632DF8.2080402@sgi.com>
 <20130408212327.GU4068@ZenIV.linux.org.uk>
 <20130408214834.GV4068@ZenIV.linux.org.uk>
 <516341ED.5060803@wwwdotorg.org>
 <CAD=FV=WodJER2g45u5pEw0edf+K4uYJjyt0w4ZfX9q=o1a7pYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WodJER2g45u5pEw0edf+K4uYJjyt0w4ZfX9q=o1a7pYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 03:45:31PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Mon, Apr 8, 2013 at 3:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >> Anyway, I've just pushed a splitup of that commit (carved in 3 pieces)
> >> into vfs.git#pipe-splitup; could you check which part triggers that
> >> hang?  Should propagate in a few...
> >
> > It looks like "pipe: unify ->release() and ->open()" introduces the
> > problem. Note that I had to add a prototype for fifo_open() before the
> > structs that reference it for that commit to compile.
> 
> It sounds like Stephen has provided you the info you needed so not
> doing any extra testing now, but I figured I'd chime in that I hit
> problems this morning with linux-next and it appears to be the same
> thing.  I did a revert of 9984d7394618df9 and (plus a revert of a
> handful of patches to the same file) and problems are resolved.  The
> failure case is really weird in that everything works well booting to
> a simple /bin/bash but fails when you do more complex tasks.
> 
> Anyway: If you need some extra testing feel free to CC me.

Folks, see if vfs.git#experimental works for you; the PITA had apparently
been caused by change of open() semantics for /proc/<pid>/fd/<some_pipe> -
it started to behave like a FIFO, i.e. wait for peer to show up.  Normally
that's not a problem, but if you have closed e.g. the write end of a pipe
and try to open /proc/<pid>/fd/<read_end_of_pipe>, you'll get open() waiting
for writers to appear.  Which isn't what we used to do here (open succeeded
immediately) and apparently that was enough to trip drakut.

Branch head should be at 574179469f7370aadb9cbac1ceca7c3723c17bee.
