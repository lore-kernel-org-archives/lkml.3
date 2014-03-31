Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaCaT0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:26:30 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:48720 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaCaT01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:26:27 -0400
MIME-Version: 1.0
In-Reply-To: <58D59025-ADA1-44CB-88E4-36BCEE763B64@primarydata.com>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <20140326194847.0e994d0b@ipyr.poochiereds.net> <CALCETrUVDQmeNwRTjk2XVsHV3TnmwwC6NcbtBBWRg_K6-W8L3g@mail.gmail.com>
 <20140326202535.7d9b6f78@ipyr.poochiereds.net> <20140327070802.124fb34c@ipyr.poochiereds.net>
 <20140330130328.GB7172@thunk.org> <20140331075145.4bd76872@tlielax.poochiereds.net>
 <58D59025-ADA1-44CB-88E4-36BCEE763B64@primarydata.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 31 Mar 2014 12:26:06 -0700
Message-ID: <CALCETrX5ta875ij08_SNmzrN+KLRNuYiM2psNyFn8JdLOd=8DQ@mail.gmail.com>
Subject: Re: Thoughts on credential switching
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Layton Jeff <jlayton@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dr Fields James Bruce <bfields@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 11:06 AM, Trond Myklebust
<trond.myklebust@primarydata.com> wrote:
>
> On Mar 31, 2014, at 7:51, Jeff Layton <jlayton@redhat.com> wrote:
>
>> On Sun, 30 Mar 2014 09:03:29 -0400
>> "Theodore Ts'o" <tytso@mit.edu> wrote:
>>
>>> On Thu, Mar 27, 2014 at 07:08:02AM -0700, Jeff Layton wrote:
>>>> I had some time to think about this last night...
>>>>
>>>> While using a fd to pass around credentials is convenient, the danger
>>>> is that it's pretty opaque. You have a fd that you know has creds
>>>> attached to it, but it's hard to be certain what is going to change.
>>>
>>> I don't think that's a particularly tough problem.  In general, the fd
>>> isn't something that you would want to pass around, and so the process
>>> which generated it will know exactly what it contained.
>>>
>>
>> I think there's a bit more of a use-case for passing around such an fd
>> via socket...
>>
>> Part of the problem is that the traditional uid/gid switching glibc
>> wrappers are per-process. If we're proposing doing something like:
>>
>> seteuid()
>> setegid()
>> setgroups()
>> fd = open()
>> (...and then revert the creds using same syscalls)
>>
>> ...during the time that you're doing all of that, you can't really
>> allow any thread in the process to be doing something that requires
>> _other_ creds until you've completed the above.
>
> Umm... open() isn't the only operation that you want to be able to do with an assumed user identity. You want mknod(), mkdir(), link(), unlink(), ... Pretty much any interaction with the underlying filesystem needs to use the right identity.
>
>> So, I could envision a program like ganesha firing up a separate
>> process to handle the credential switching and fd creation and then
>> handing those back to the main process via a unix domain socket.
>
> How about using the keyrings interface to atomically cache and retrieve these user identities? We already have support for different types of keys that store/retrieve different types of structured information. How is this so different?

This sounds considerably more complicated than just using fds.  What's
the advantage?

I guess using keys for local fs credentials fits in with using keys to
access things like AFS, but I'm still not sure I see why this helps
here.

--Andy
