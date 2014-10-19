Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaJSWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 18:16:27 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:43503 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaJSWQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 18:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <20141019212921.GI7996@ZenIV.linux.org.uk>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
 <20141019202034.GH7996@ZenIV.linux.org.uk> <CALCETrVZUW2iPtfFJtGnWd2RsYLwjGRGYuujrVqcOsO5oBB8Cg@mail.gmail.com>
 <20141019212921.GI7996@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Oct 2014 15:16:03 -0700
Message-ID: <CALCETrVTiO6YKRYAAe-eBgQvpUqrtE0=KrKJj2T_XJ9iSRDtmA@mail.gmail.com>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
To: Al Viro <viro@zeniv.linux.org.uk>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 2:29 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Oct 19, 2014 at 01:37:54PM -0700, Andy Lutomirski wrote:
>> > The question I hadn't seen really answered through all of that was how to
>> > deal with #!...  "Just use d_path()" isn't particulary appealing - if that
>> > file has a pathname reachable for you, you could bloody well use _that_
>> > from the very beginning.
>>
>> Does this matter for absolute paths after #! (or for absolute paths to
>> ELF interpreters)?  Does anyone use relative paths there?
>
> It's not about what's after #!; it's what we *append* to what's after #!
> that is interesting.  Recall how #! works - we turn execve() of something
> that starts with e.g. "#!/usr/bin/make -f\n" into execve of /usr/bin/make,
> with (/usr/bin/make, -f, name of that file, argv[1]..argv[argc]) as
> arguments list.  With make(1) doing opening and reading the file, as it
> would for any makefile.  Or /bin/sh opening and reading the script, etc.
>
> Pathname of interpreter is a non-issue (and ELF ones don't go anywhere
> near that path anyway).
>

Oh, you mean that #!/usr/bin/make -f would turn into /usr/bin/make
/dev/fd/3?  That could be interesting, although I can imagine it
breaking things, especially if /dev/fd/3 isn't set up like that, e.g.
early in boot.

Why does this use case need the dup-style semantics?  Merely opening
the same file should work, right?

[deleted my questions based on my misunderstanding of what you were
talking about]

>> I'm not convinced that these semantics are better than /proc/self/fd's
>> in many contexts.  I don't really like the idea that catting some file
>> can *change* the position of one of my open file descriptors.
>
> Er...  You do realize that if descriptor refers to the same file,
> cat <&<that descriptor> will change position of your other descriptor,
> right?  BTW, on *BSD /dev/stdin *does* have a dup()-style semantics.
> They do it at the price of very convoluted code in their VFS, but that's
> how it works there.  And in Plan 9, and (AFAIK) in Solaris...

But cat <&3 is shell magic; it isn't actually an invocation of
/bin/cat with some special argument that causes it to poke at some fd.
And bash already supports this kind of use case.

I still don't userstand why the BSD behavior is better here.  Also,
this isn't just file *position* -- anything that opens dupfs/N and
uses fcntl with F_SETFL seems likely to cause failures, crashes, or
outright corruption.  And there are file locks, which suddenly have
rather odd semantics.  (Even with the new OFD locks or with BSD locks,
I wonder how many little programs open argv[1], lock the file, do
something, and then exit.  Anything that does that is now leaking a
lock.)

Aside from the general scariness of allowing one process to actually
dup another process's fds, I feel like this is asking for trouble wrt
the various types of file locks.

--Andy
