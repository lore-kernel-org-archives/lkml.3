Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaCaUOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:14:41 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55085 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaCaUOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:14:38 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Thoughts on credential switching
From: Trond Myklebust <trond.myklebust@primarydata.com>
In-Reply-To: <CALCETrX5ta875ij08_SNmzrN+KLRNuYiM2psNyFn8JdLOd=8DQ@mail.gmail.com>
Date: Mon, 31 Mar 2014 16:14:33 -0400
Cc: Layton Jeff <jlayton@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dr Fields James Bruce <bfields@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <3E5CB7F4-0CB6-4D50-85DC-D19FC47FCBD8@primarydata.com>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com> <20140326194847.0e994d0b@ipyr.poochiereds.net> <CALCETrUVDQmeNwRTjk2XVsHV3TnmwwC6NcbtBBWRg_K6-W8L3g@mail.gmail.com> <20140326202535.7d9b6f78@ipyr.poochiereds.net> <20140327070802.124fb34c@ipyr.poochiereds.net> <20140330130328.GB7172@thunk.org> <20140331075145.4bd76872@tlielax.poochiereds.net> <58D59025-ADA1-44CB-88E4-36BCEE763B64@primarydata.com> <CALCETrX5ta875ij08_SNmzrN+KLRNuYiM2psNyFn8JdLOd=8DQ@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 31, 2014, at 15:26, Andy Lutomirski <luto@amacapital.net> wrote:

> On Mon, Mar 31, 2014 at 11:06 AM, Trond Myklebust
> <trond.myklebust@primarydata.com> wrote:
>> 
>> On Mar 31, 2014, at 7:51, Jeff Layton <jlayton@redhat.com> wrote:
>> 
>>> On Sun, 30 Mar 2014 09:03:29 -0400
>>> "Theodore Ts'o" <tytso@mit.edu> wrote:
>>> 
>>>> On Thu, Mar 27, 2014 at 07:08:02AM -0700, Jeff Layton wrote:
>>>>> I had some time to think about this last night...
>>>>> 
>>>>> While using a fd to pass around credentials is convenient, the danger
>>>>> is that it's pretty opaque. You have a fd that you know has creds
>>>>> attached to it, but it's hard to be certain what is going to change.
>>>> 
>>>> I don't think that's a particularly tough problem.  In general, the fd
>>>> isn't something that you would want to pass around, and so the process
>>>> which generated it will know exactly what it contained.
>>>> 
>>> 
>>> I think there's a bit more of a use-case for passing around such an fd
>>> via socket...
>>> 
>>> Part of the problem is that the traditional uid/gid switching glibc
>>> wrappers are per-process. If we're proposing doing something like:
>>> 
>>> seteuid()
>>> setegid()
>>> setgroups()
>>> fd = open()
>>> (...and then revert the creds using same syscalls)
>>> 
>>> ...during the time that you're doing all of that, you can't really
>>> allow any thread in the process to be doing something that requires
>>> _other_ creds until you've completed the above.
>> 
>> Umm... open() isn't the only operation that you want to be able to do with an assumed user identity. You want mknod(), mkdir(), link(), unlink(), ... Pretty much any interaction with the underlying filesystem needs to use the right identity.
>> 
>>> So, I could envision a program like ganesha firing up a separate
>>> process to handle the credential switching and fd creation and then
>>> handing those back to the main process via a unix domain socket.
>> 
>> How about using the keyrings interface to atomically cache and retrieve these user identities? We already have support for different types of keys that store/retrieve different types of structured information. How is this so different?
> 
> This sounds considerably more complicated than just using fds.  What's
> the advantage?

The advantage is that it’s considerably _less_ complicated because it uses interfaces that were designed to carry security related information, and to share them across threads.

> I guess using keys for local fs credentials fits in with using keys to
> access things like AFS, but I'm still not sure I see why this helps
> here.

All you want to do is atomically store and retrieve a user identity (in practice a credential) and share it between members of a thread. As I said, that kind of storage/retrieval of structured data is what keyrings do. As far as I know, there are already LSM interfaces in place (see security_key_alloc/permission/free), and the generic keyring/keyctl interface exists with appropriate process sharing/inheritance rules via the kernel keyring interface.

So basically, the recipe is:

- You set up a kernel key type that takes a reference to the current process credential on instantiation (no upcalls, etc needed). Ganesha can then use standard libkeyutils methods to create the key and store it in its user, process or thread keyring.
- You add a new keyctl (KEYCTL_APPLY?) that enables any thread/process that has access to the key, via the keyring in which it is stored, to apply the stored process credential to itself (and perhaps cache it’s old credential in a new key?).


_________________________________
Trond Myklebust
Linux NFS client maintainer, PrimaryData
trond.myklebust@primarydata.com

