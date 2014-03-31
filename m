Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaCaSNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbaCaSNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:13:10 -0400
Date: Mon, 31 Mar 2014 14:12:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andy Lutomirski <luto@amacapital.net>,
        Jim Lieb <jlieb@panasas.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dr Fields James Bruce <bfields@redhat.com>
Subject: Re: Thoughts on credential switching
Message-ID: <20140331141255.008e2b4a@tlielax.poochiereds.net>
In-Reply-To: <58D59025-ADA1-44CB-88E4-36BCEE763B64@primarydata.com>
References: <CALCETrVyNXYaMWOyWj4gKLWVdzPrSkvv7WTBi2Aa8mYs4NKH9g@mail.gmail.com>
	<20140326194847.0e994d0b@ipyr.poochiereds.net>
	<CALCETrUVDQmeNwRTjk2XVsHV3TnmwwC6NcbtBBWRg_K6-W8L3g@mail.gmail.com>
	<20140326202535.7d9b6f78@ipyr.poochiereds.net>
	<20140327070802.124fb34c@ipyr.poochiereds.net>
	<20140330130328.GB7172@thunk.org>
	<20140331075145.4bd76872@tlielax.poochiereds.net>
	<58D59025-ADA1-44CB-88E4-36BCEE763B64@primarydata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 14:06:01 -0400
Trond Myklebust <trond.myklebust@primarydata.com> wrote:

> 
> On Mar 31, 2014, at 7:51, Jeff Layton <jlayton@redhat.com> wrote:
> 
> > On Sun, 30 Mar 2014 09:03:29 -0400
> > "Theodore Ts'o" <tytso@mit.edu> wrote:
> > 
> >> On Thu, Mar 27, 2014 at 07:08:02AM -0700, Jeff Layton wrote:
> >>> I had some time to think about this last night...
> >>> 
> >>> While using a fd to pass around credentials is convenient, the danger
> >>> is that it's pretty opaque. You have a fd that you know has creds
> >>> attached to it, but it's hard to be certain what is going to change.
> >> 
> >> I don't think that's a particularly tough problem.  In general, the fd
> >> isn't something that you would want to pass around, and so the process
> >> which generated it will know exactly what it contained.
> >> 
> > 
> > I think there's a bit more of a use-case for passing around such an fd
> > via socket...
> > 
> > Part of the problem is that the traditional uid/gid switching glibc
> > wrappers are per-process. If we're proposing doing something like:
> > 
> > seteuid()
> > setegid()
> > setgroups()
> > fd = open()
> > (...and then revert the creds using same syscalls)
> > 
> > ...during the time that you're doing all of that, you can't really
> > allow any thread in the process to be doing something that requires
> > _other_ creds until you've completed the above.
> 
> Umm… open() isn’t the only operation that you want to be able to do with an assumed user identity. You want mknod(), mkdir(), link(), unlink(), … Pretty much any interaction with the underlying filesystem needs to use the right identity.
> 

The proposal that Al originally had was to have userland set up the
credentials that it wanted to use, and then open("/dev/null", ...) to
get a fd that has those creds attached.

Then, we'd add a syscall that takes such an fd and switches to the creds
attached to it. So the open() in the above example isn't to do an actual
operation but rather to create a fd to act as a credential "handle".

> > So, I could envision a program like ganesha firing up a separate
> > process to handle the credential switching and fd creation and then
> > handing those back to the main process via a unix domain socket.
> 
> How about using the keyrings interface to atomically cache and retrieve these user identities? We already have support for different types of keys that store/retrieve different types of structured information. How is this so different?
> 

That's an interesting idea. 
-- 
Jeff Layton <jlayton@redhat.com>
