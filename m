Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaC3S4c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 14:56:32 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:53571 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaC3S43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 14:56:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140330130328.GB7172@thunk.org>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
 <20140326194847.0e994d0b@ipyr.poochiereds.net> <CALCETrUVDQmeNwRTjk2XVsHV3TnmwwC6NcbtBBWRg_K6-W8L3g@mail.gmail.com>
 <20140326202535.7d9b6f78@ipyr.poochiereds.net> <20140327070802.124fb34c@ipyr.poochiereds.net>
 <20140330130328.GB7172@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 30 Mar 2014 11:56:08 -0700
Message-ID: <CALCETrXYFaAP70KYEKGb7Gbwe+km_aJcxmm2B59DncSc-XPtgw@mail.gmail.com>
Subject: Re: Thoughts on credential switching
To: "Theodore Ts'o" <tytso@mit.edu>, Jeff Layton <jlayton@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>, Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bfields@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 6:03 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Mar 27, 2014 at 07:08:02AM -0700, Jeff Layton wrote:
>> I had some time to think about this last night...
>>
>> While using a fd to pass around credentials is convenient, the danger
>> is that it's pretty opaque. You have a fd that you know has creds
>> attached to it, but it's hard to be certain what is going to change.
>
> I don't think that's a particularly tough problem.  In general, the fd
> isn't something that you would want to pass around, and so the process
> which generated it will know exactly what it contained.
>
>> Perhaps we can use the flags field for that. So, assuming we have a fd
>> with the creds attached, we could do something like:
>>
>>     err = switch_creds(fd, SC_FSUID|SC_FSGID|SC_GROUPS);
>>
>> ...then the switch_creds syscall could be set up to fail if the new
>> credentials had other fields that didn't match those in the current
>> task credentials. So if (for instance) the cred->euid were
>> different between the two, the above could fail with -EINVAL or
>> something.
>
> Huh?  The whole *point* is that the creds value will be different, of
> course they won't match!  I would think this would be over
> complicating the interface.
>
>
> A couple of other things.  What I would suggest is that we create a
> few new fd flags, to join FD_CLOEXEC:
>
> FD_NOPROCFS     disallow being able to open the inode via /proc/<pid>/fd
>                 (but in the case of a creds fd, for bonus points, the
>                 target of the pseudo-symlink could be something like:
>                 "uid: 15806 gid: 100: grps: 27, 50" to aid in debugging
>                 a userspace file server).  This also answers Jeff's concern
>                 if for some reason --- I don't know how --- a process
>                 doesn't know what the contents of the creds fd that
>                 it created itself.
>
> FD_NOPASSFD     disallow being able to pass the fd via a unix domain socket
>
> FD_LOCKFLAGS    if this bit is set, disallow any further changes of FD_CLOEXEC,
>                 FD_NOPROCFS, FD_NOPASSFD, and FD_LOCKFLAGS flags.
>
> Some of the functionality requested by the folks suggesting the "SEAL"
> API would also be covered by these fd flags.
>
> In order to solve some potential race concerns, a credsfd must be
> created with FD_CLOEXEC and FD_NOPROCFS enabled.

It might be nice to try to coordinate this with the Capsicum people,
who are doing something along these lines.  They even have tentative
Linux patches.

--Andy
