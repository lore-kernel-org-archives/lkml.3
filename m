Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaBGBb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 20:31:57 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:39511 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBGBb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 20:31:56 -0500
MIME-Version: 1.0
In-Reply-To: <20140206222450.GA8823@node.dhcp.inet.fi>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
	<CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
	<20140206005534.GA27848@node.dhcp.inet.fi>
	<CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
	<CA+55aFwfGVCVouh5uap3UPy92vc4N9OrRRa-NpYT9ZMicU6w8w@mail.gmail.com>
	<CA+55aFyq31f=30YeRbZbqgBFp13Zdk=Gb-UiLRqeR48MOfVwag@mail.gmail.com>
	<20140206222450.GA8823@node.dhcp.inet.fi>
Date: Thu, 6 Feb 2014 17:31:55 -0800
X-Google-Sender-Auth: FoalGHP9c_-y2c-DbJQOjQQml3o
Message-ID: <CA+55aFysEbwfzJxVbZY6X+eEZ5KSgO5b8-S_a=-nrLj0sQfecA@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ning Qu <quning@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 6, 2014 at 2:24 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>
> If we want to reduce number of page fault with less overhead we probably
> should concentrate on minor page fault -- populate pte around fault
> address which already in page cache. It should cover scripting use-case
> pretty well.

That's what my patch largely does. Except I screwed up and didn't use
FAULT_FLAG_ALLOW_RETRY in fault_around().

Anyway, my patch kind of works, but I'm starting to hate it. I think I
want to try to extend the "->fault()" interface to allow
filemap_fault() to just fill in multiple pages.

We alread have that "vmf->page" thing, we could make it a small array
easily. That would allow proper gang lookup, and much more efficient
"fill in multiple entries in one go" in mm/memory.c.

> Heh! `man 3 mmap' actually suggests MAP_POPULATE | MAP_NONBLOCK.
> What's the story beyond MAP_NONBLOCK?

It does nothing, afaik.

                  Linus
