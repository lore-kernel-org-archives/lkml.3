Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaJSUy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 16:54:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34985 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaJSUyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 16:54:24 -0400
Message-ID: <544424E6.1060002@zytor.com>
Date: Sun, 19 Oct 2014 13:53:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>
CC: David Drysdale <drysdale@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
References: <1401975635-6162-1-git-send-email-drysdale@google.com> <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com> <20141019202034.GH7996@ZenIV.linux.org.uk>
In-Reply-To: <20141019202034.GH7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2014 01:20 PM, Al Viro wrote:
> On Fri, Oct 17, 2014 at 02:45:03PM -0700, Andy Lutomirski wrote:
> 
>> For example, I want to be able to reliably do something like nsenter
>> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
>> it is more or less fully functional, so this should Just Work (tm),
>> except that the toybox binary might not exist in the namespace being
>> entered.  If execveat were available, I could rig nsenter or a similar
>> tool to open it with O_CLOEXEC, enter the namespace, and then call
>> execveat.
> 
> The question I hadn't seen really answered through all of that was how to
> deal with #!...  "Just use d_path()" isn't particulary appealing - if that
> file has a pathname reachable for you, you could bloody well use _that_
> from the very beginning.
> 
> Frankly, I wonder if it would make sense to provide something like
> dupfs.  We can't mount it by default on /dev/fd (more's the pity), but
> it might be a good thing to have.
> 
> What it is, for those who are not familiar with Plan 9: a filesystem with
> one directory and a bunch of files in it.  Directory contents depends on
> who's looking; for each opened descriptor in your descriptor table, you'll
> see two files there.  One series is 0, 1, ... - opening one of those gives
> dup().  IOW, it's *not* giving you a new struct file; it gives you a new
> reference to existing one, complete with sharing IO position, etc.  Another
> is 0ctl, 1ctl, ... - those are read-only and reading from them gives pretty
> much a combination of our /proc/self/fdinfo/n with readlink of /proc/self/fd/n.
> 
> It's actually a better match for what one would expect at /dev/fd than what
> we do.  Example:
> 

Yes, it is really unfortunate that /proc/self/fd/* had the wrong
semantics for the start, due to then-existing implementation issues.

	-hpa


