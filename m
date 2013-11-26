Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3KZSoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:44:21 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52010 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3KZSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:44:17 -0500
MIME-Version: 1.0
In-Reply-To: <20131126182157.GA503@redhat.com>
References: <20131126182157.GA503@redhat.com>
Date: Tue, 26 Nov 2013 10:44:16 -0800
X-Google-Sender-Auth: MBVSHryKEC4zNKSB3mPDcVRBuKk
Message-ID: <CA+55aFzvc9g896HK2AVU2A37t50PiCL2+tjGzNyn3BJ-om+7fg@mail.gmail.com>
Subject: Re: odd userspace lockups.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:21 AM, Dave Jones <davej@redhat.com> wrote:
> I've been seeing this a few times on your current tree while fuzz testing.
>
> When it happens, the machine responds to ping, but ssh always times out.
> I can log in on a tty, but as soon as it tries to exec something, that tty hangs.
>
> I've been away for a week, but don't recall seeing it before I left, so it's
> likely caused by something merged in the last week.  I'll attempt a bisect
> if no-one has any ideas.  sysrq output below.
>
> At first I thought it was just being really slow, (especially after seeing
> all those congestion related symbols in the stack traces), but even after
> being left for hours, it doesn't seem to progress.

It *does* seem to be hung in some congestion thing. Possibly brought
on by being low on memory due to a memory leak.

I'm not seeing any suspicious locks: the sshd that holds the mmap_sem
locks for a fork() seems to be in congestion-wait for the disk due to
trying to allocate memory, exactly like all the trinity children are.

You don't have memory information in your dump, but to me it looks
like you're basically out of memory (there's a *lot* of
trinity-children trying to allocate pages), and the oom killer isn't
triggering for whatever reason.

Of course, it could easily be a kernel memory leak too (rather than
trinity), triggered by your odd workload.

                 Linus
