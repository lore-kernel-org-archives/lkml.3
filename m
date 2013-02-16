Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab3BPHVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 02:21:00 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:42295 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3BPHU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 02:20:59 -0500
MIME-Version: 1.0
In-Reply-To: <20130216022006.GB4503@ZenIV.linux.org.uk>
References: <20130214053656.GS4503@ZenIV.linux.org.uk> <CA+55aFz1JjGSCdqXpVz3oH-PWFDE3Qdxt3EVxqC2i=nfLqf0Jw@mail.gmail.com>
 <20130215215946.GX4503@ZenIV.linux.org.uk> <CAGDaZ_pMLScoO811es3AZxzAnSiS5ixku-DeuEi4FwX8mNv3cQ@mail.gmail.com>
 <20130216000435.GY4503@ZenIV.linux.org.uk> <CAGDaZ_rqKR7Ea6SZ9JXmeVOvEBEk3gHaQEa1LAkzWxRHfJsHWw@mail.gmail.com>
 <CAGDaZ_p8Dm+Tco_famKmEzGpV6G+zo1xHLkA7LQCkzQJD_pxMA@mail.gmail.com>
 <20130216015024.GA4503@ZenIV.linux.org.uk> <20130216022006.GB4503@ZenIV.linux.org.uk>
From: Raymond Jennings <shentino@gmail.com>
Date: Fri, 15 Feb 2013 23:20:18 -0800
Message-ID: <CAGDaZ_oSzQOLsoeWQFNQ8R5-NBKPAUygvjvzvef9q40WBu1sWw@mail.gmail.com>
Subject: Re: [RFC] SIGKILL vs. SIGSEGV on late execve() failures
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 6:20 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Arrgh...  OK, I'm a blind idiot.  These places in binfmt_elf.c currently use
> force_sig(), not send_sig_info().  Currently == since 2006 when somebody
> noticed the problem.  Their counterparts in binfmt_elf_fdpic.c were *not*
> noticed.  Anyway, that definitely means we want to do it in a single commit;
> the only remaining question is whether we have any problems with somebody
> ptracing such execve() and then poking the sucker with ptrace();

Personally if I was ptracing another process, I'd be flummoxed if I
saw it get nailed with a fatal segfault that I somehow wasn't allowed
to intercept.

An even bigger question might be why an execve is allowed to get into
an unrecoverable state to begin with.  Assuming that one builds the
new mm_struct and whatnot BEFORE discarding old state, why would
execve be in a position for a fatal error in the first place?

> that _can_
> happen with the current mainline for ELF binaries, so this is not something
> new.  I'm low on coffee and about to crash, so I might be missing some
> horrible problem with it, but in this case I'm fairly sure that such a problem
> would be present in current mainline.
