Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaJSV33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:29:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53169 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaJSV31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:29:27 -0400
Date: Sun, 19 Oct 2014 22:29:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Drysdale <drysdale@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Message-ID: <20141019212921.GI7996@ZenIV.linux.org.uk>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
 <20141019202034.GH7996@ZenIV.linux.org.uk>
 <CALCETrVZUW2iPtfFJtGnWd2RsYLwjGRGYuujrVqcOsO5oBB8Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVZUW2iPtfFJtGnWd2RsYLwjGRGYuujrVqcOsO5oBB8Cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 01:37:54PM -0700, Andy Lutomirski wrote:
> > The question I hadn't seen really answered through all of that was how to
> > deal with #!...  "Just use d_path()" isn't particulary appealing - if that
> > file has a pathname reachable for you, you could bloody well use _that_
> > from the very beginning.
> 
> Does this matter for absolute paths after #! (or for absolute paths to
> ELF interpreters)?  Does anyone use relative paths there?

It's not about what's after #!; it's what we *append* to what's after #!
that is interesting.  Recall how #! works - we turn execve() of something
that starts with e.g. "#!/usr/bin/make -f\n" into execve of /usr/bin/make,
with (/usr/bin/make, -f, name of that file, argv[1]..argv[argc]) as
arguments list.  With make(1) doing opening and reading the file, as it
would for any makefile.  Or /bin/sh opening and reading the script, etc.

Pathname of interpreter is a non-issue (and ELF ones don't go anywhere
near that path anyway).

> Does execve("/proc/self/fd/N", ...) not work correctly now?

Yes, it does.  And if procfs is there, this syscall is completely pointless.
The main argument in favour of adding it to the kernel (rather than doing
in userland) has been "but what of the people who don't want procfs mounted
in there?".

> Presumably relative paths should be relative to the execed program, or
> maybe there should be a flag to execveat that disallows that behavior
> entirely, or maybe it should never work, even through /proc.  I don't
> really like the idea that an fd pointing at a *file* should allow
> access to its directory.

Huh?  What are you talking about?  And who the hell cares whether it's
absolute or relative?

> I'm not convinced that these semantics are better than /proc/self/fd's
> in many contexts.  I don't really like the idea that catting some file
> can *change* the position of one of my open file descriptors.

Er...  You do realize that if descriptor refers to the same file,
cat <&<that descriptor> will change position of your other descriptor,
right?  BTW, on *BSD /dev/stdin *does* have a dup()-style semantics.
They do it at the price of very convoluted code in their VFS, but that's
how it works there.  And in Plan 9, and (AFAIK) in Solaris...
