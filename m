Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaBXPdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:33:37 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:35487 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaBXPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:33:36 -0500
Date: Mon, 24 Feb 2014 10:35:34 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Vince Weaver <vincent.weaver@maine.edu>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <530AD71E.50800@zytor.com>
Message-ID: <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu>
 <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Feb 2014, H. Peter Anvin wrote:

> So we do a write to the buffer rather immediately before this happens,
> and in particular that will update the head:
> 
> 	rb->user_page->data_head = head;
> 
> However, that doesn't explain what is going on and in particular the
> write to whatever address was in %rbp.  The rest pretty much seems to be
> the page fault logic.

It turns out you don't even have to over-write rb->user_page->data_head.
Just touching the mmap page with a write of a single byte (it doesn't 
matter where) is enough to trigger the bug.

This is a pain to track down, it would be easier if I could get a 
replayable syscall trace, but even though the segfault is very 
reproducible with my fuzzer, it's very sensitive to extra syscalls in the 
trace path and the fuzzer logger/replayer path has a different number of 
write syscalls and won't trigger the problem.

> Incidentally, I doubt that this is x32-related in any way; there seems
> to be absolutely no difference between x86-64 perf and x32 perf; more
> likely it just makes the error more reproducible because the address
> space is so much smaller.

quite possibly.  I only began chasing the problem because when compiled 
for x32 this bug apparently will reboot the machine now and then (not just 
segfault the program).  I never saw that failure mode with x86_64, but 
again maybe it's just easier to hit with the reduced address space as you 
say.

Vince
