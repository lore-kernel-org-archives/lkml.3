Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaC0TC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:02:26 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47284 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757009AbaC0TCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:02:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140327185648.GE2526@jeremy-laptop>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <53341D8E.80105@redhat.com> <20140327060225.4f4caa5a@ipyr.poochiereds.net>
 <53342258.8000304@redhat.com> <20140327070126.41ac75ac@ipyr.poochiereds.net>
 <20140327182617.GC2526@jeremy-laptop> <CALCETrU+D-W_CCHuiWorTXUwsSHWS7AF91Kj2G0MtK_J+ESFKQ@mail.gmail.com>
 <20140327185648.GE2526@jeremy-laptop>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Mar 2014 12:02:02 -0700
Message-ID: <CALCETrVfg9vEUzZena+NYQX9w+30MPbvm7Axw0nm4YrYG0sogw@mail.gmail.com>
Subject: Re: Thoughts on credential switching
To: Jeremy Allison <jra@samba.org>
Cc: Jeff Layton <jlayton@redhat.com>, Florian Weimer <fweimer@redhat.com>,
        Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 11:56 AM, Jeremy Allison <jra@samba.org> wrote:
> On Thu, Mar 27, 2014 at 11:46:39AM -0700, Andy Lutomirski wrote:
>> On Thu, Mar 27, 2014 at 11:26 AM, Jeremy Allison <jra@samba.org> wrote:
>> >
>> > Amen to that :-).
>> >
>> > However, after talking with Jeff and Jim at CollabSummit,
>> > I was 'encouraged' to make my opinions known on the list.
>> >
>> > To me, calling the creds handle a file descriptor just
>> > feels wrong. IT *isn't* an fd, you can't read/write/poll
>> > on it, and it's only done as a convenience to get the
>> > close-on-exec semantics and the fact that the creds are
>> > already hung off the fd's in kernel space.
>>
>> Windows calls these things "handles."  Linux has "file descriptors,"
>> and there's plenty of precedent for things that aren't files.
>
> Sure, but there's a set of expectations around
> fd's that these things don't satisfy - IO-ops.

eventfd, timerfd, and signalfd barely satisfy those.  namespace fds
don't satisfy those expectations at all.  And /proc/pid/fd is really
quite useful for debugging.

>
>> > That way we can also make it clear this thing only has
>> > meaning to a thread group, and SHOULD NOT (and indeed
>> > preferably CAN NOT) be passed between processes.
>> >
>>
>> If you want those semantics, then stick a struct pid * in there for
>> the tgid of the cretor and make sure that current's tgid matches when
>> you try to use it.
>>
>> I think they'd be more useful without that check, though.
>
> I'm more worried about leakage and unintended consequences
> here.
>
>> BTW, what do you want to have happen on fork?  I think they should keep working.
>
> Yeah, that's true. I want them to keep
> working across fork, but not across exec
> or any other method of fd-passing.
>

This seems like an unfortunate restriction to put in the kernel to
prevent userspace from shooting itself in the foot.

--Andy
