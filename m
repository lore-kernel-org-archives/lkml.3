Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3KDPGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:06:00 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:58715 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab3KDPF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:05:58 -0500
Message-ID: <1383577538.18301.28.camel@localhost.localdomain>
Subject: Re: [PATCH] events: add a flag to perf_event_open() to set O_CLOEXEC
From: Yann Droneaud <ydroneaud@opteya.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Mon, 04 Nov 2013 16:05:38 +0100
In-Reply-To: <20131031181202.GA19466@laptop.lan>
References: <cover.1383121137.git.ydroneaud@opteya.com>
	 <3b0bc009ff1410d04f8a1e71bfae0d27e1254b90.1383121137.git.ydroneaud@opteya.com>
	 <20131030202041.GS16117@laptop.programming.kicks-ass.net>
	 <94b641a81a06ba4943cf77e80bc271c8@meuh.org>
	 <1383168950-8933-1-git-send-email-ydroneaud@opteya.com>
	 <20131031181202.GA19466@laptop.lan>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le jeudi 31 octobre 2013 à 19:12 +0100, Peter Zijlstra a écrit :
> On Wed, Oct 30, 2013 at 10:35:50PM +0100, Yann Droneaud wrote:
> > This patch adds PERF_FLAG_FD_CLOEXEC flag for
> > perf_event_open() syscall.
> > 
> > perf_event_open() creates a new file descriptor,
> > but unlike open() syscall, it lack a flag to atomicaly
> > set close-on-exec (O_CLOEXEC).
> > 
> > Not using O_CLOEXEC by default and not letting userspace
> > provide the "open" flags should be avoided: in most case
> > O_CLOEXEC must be used to not leak file descriptor across
> > exec().
> > 
> > Using O_CLOEXEC when creating a file descriptor allows
> > userspace to set latter, using fcntl(), without any risk
> > of race, if the file descriptor is going to be inherited
> > or not across exec().
> > 
> > Link: http://lkml.kernel.org/r/94b641a81a06ba4943cf77e80bc271c8@meuh.org
> > Link: http://lkml.kernel.org/r/cover.1383121137.git.ydroneaud@opteya.com
> > Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> > ---
> > 
> > Hi Peter,
> > 
> > This patch should replaces
> > "[PATCH v4 6/7] events: use get_unused_fd_flags(0) instead of get_unused_fd()"
> > 
> > Please have a look.
> 
> I'm still terminally confused as to all of this... Why does it matter
> what the default is if you can change it with fcntl() ?

There's a possible race between open() and fcntl()in multi-threaded
program, that's why O_CLOEXEC was added to open(), and then added to
many other system calls.

>  Also, how can you tell nobody relies on the current behaviour and its therefore safe
> to change?
> 

If *you* cannot tell, then no one could tell, thus the default *must*
not be changed because no one could ever be sure that no application
rely on the current behavior.

But it's rather pointless to change the default, since the caller of
get_unused_fd(), eg. syscall perf_event_open(), has a flags argument
that can be used to ask for O_CLOEXEC. Just like other syscall extended
to support O_CLOEXEC.

You might want to read "Secure File Descriptor Handling" by 
Ulrich Drepper [1] who is responsible to adding O_CLOEXEC on open,
and probably other syscalls

[1] http://udrepper.livejournal.com/20407.html

Regards.

-- 
Yann Droneaud
OPTEYA


