Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab3CDT1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 14:27:55 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:63203 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758828Ab3CDT1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 14:27:52 -0500
Date: Mon, 04 Mar 2013 13:27:47 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: For review: pid_namespaces(7) man page
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <876217olp0.fsf@xmission.com> (from ebiederm@xmission.com on
	Sun Mar  3 22:03:55 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1362425267.7276.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2013 10:03:55 PM, Eric W. Biederman wrote:
> Rob Landley <rob@landley.net> writes:
> 
> > On 03/01/2013 03:57:40 AM, Michael Kerrisk (man-pages) wrote:
> >> > And yet the glibc guys insist on #define
> >> GNU_GNU_GNU_ALL_HAIL_STALLMAN in
> >> > order to access this Linux-specific feature which has nothing
> >> whatsoever to
> >> > do with the FSF.
> >>
> >> This is a misunderstanding. _GNU_SOURCE is the standard way to  
> expose
> >> Linux-specific functionality from POSIX header files.
> >
> > What standard? The Linux kernel is not, and never was, part of the  
> GNU
> > project.
> 
> Is the argument that there should be a _LINUX_SOURCE directive in  
> glibc
> for this?

If you don't #define any feature test macros at all, you get a bunch of  
macros (_BSD_SOURCE, _SVID_SOURCE, _POSIX_SOURCE,  
_POSIX_C_SOURCE=200809L, and so on) defined by default in features.h.  
If you start defining macros, several of the default ones _go_away_,  
and you start missing things that are defined by posix-2008. Yes,  
defining feature test macros makes definitions _vanish_ out of the  
headers, which means feature test macros can actually reduce code  
portability.

The _GNU_SOURCE is glibc's way of saying "switch on everything glibc  
offers". (Except it isn't _quite_, but that seems to be what they  
intended.) So there are various things that test _specifically_ for  
that macro, but the macro also switches on (from features.h):

/* If _GNU_SOURCE was defined by the user, turn on all the other  
features.  */
#ifdef _GNU_SOURCE
# undef  _ISOC95_SOURCE
# define _ISOC95_SOURCE 1
# undef  _ISOC99_SOURCE
# define _ISOC99_SOURCE 1
# undef  _POSIX_SOURCE
# define _POSIX_SOURCE  1
# undef  _POSIX_C_SOURCE
# define _POSIX_C_SOURCE        200809L
# undef  _XOPEN_SOURCE
# define _XOPEN_SOURCE  700
# undef  _XOPEN_SOURCE_EXTENDED
# define _XOPEN_SOURCE_EXTENDED 1
# undef  _LARGEFILE64_SOURCE
# define _LARGEFILE64_SOURCE    1
# undef  _BSD_SOURCE
# define _BSD_SOURCE    1
# undef  _SVID_SOURCE
# define _SVID_SOURCE   1
# undef  _ATFILE_SOURCE
# define _ATFILE_SOURCE 1
#endif

This is not fine-grained control of what libc exports. This is "if you  
want to use unshare() then everything we ever implemented gets  
simultaneously exported into your namespace". (Which it _mostly_ is if  
you never use any feature test macros, but not the Linux-specific  
system calls.)

The new musl-libc.org did an _ALL_SOURCE macro that just enables every  
feature test macro they implemented. (That's its definition, it's the  
feature test macro that says feature test macros area bad idea.)

> Although come to think of it I can't imagine how <sched.h> is a POSIX
> header.  Last I looked it only had linux specific bits in it.  Which
> makes needing any kind of #define strange.

My objection is that Linux system calls are not part of the GNU  
project. Requiring that macro to get Linux system calls out of bionic,  
uClibc, klibc, musl, olibc, dietlibc, or newlib is _silly_. It's the  
"GNU/Linux" prefix imposed on the source level, and it's a fairly  
recent development (I've only noticed it since 2008 or so).

Rob