Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3JEBmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 21:42:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50239 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3JEBmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 21:42:35 -0400
Date: Sat, 5 Oct 2013 02:42:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe/cred lockdep warning
Message-ID: <20131005014229.GT13318@ZenIV.linux.org.uk>
References: <20131001145755.GA22729@redhat.com>
 <20131003185630.GJ13318@ZenIV.linux.org.uk>
 <CA+55aFxEs=bdtw-SPRSnVz7bGE3Pyi+tM7wsEdwxu+GL5qq5_Q@mail.gmail.com>
 <20131005004612.GS13318@ZenIV.linux.org.uk>
 <CA+55aFzrJ4JpfXxGA6LTd_fe-dEjTHhPEY2bkWEJJ=AF-FfT4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzrJ4JpfXxGA6LTd_fe-dEjTHhPEY2bkWEJJ=AF-FfT4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 06:25:00PM -0700, Linus Torvalds wrote:

> Any splice user has better have a fallback to a read/write loop anyway, so
> I think the default of trying to splice was likely a bad decision.

Ummm...  Point.

> That said, you're right that it's a big change. And maybe we don't really
> care enough, and we should just make sure sysfs and proc get the EINVAL
> return. So it's not like I have a really strong preference.
> 
> But I *definitely* don't want something that just sets every f_op to use
> the default splice write. That's just equivalent to our current default to
> possibly bad behavior..

Well, I meant something like this: at 3.13-rc1 we add two exported
functions calling default_file_splice_write() - fallback_file_splice_write()
and this_fucker_will_be_gone_in_3_14_rc1_splice_write().  And do a single
commit slapping the latter in those file_operations.  After that NULL means
-EINVAL.  At which point maintainers are welcome to review the damn thing and
either remove the initializer if for this instance it makes no sense, or
switch it to something that will stay.  Maybe fallback_file_splice_write(),
maybe something else - up to them.  I wouldn't be surprised if in some cases
generic_file_splice_write() would turn out to be the right answer.  In any
case, in 3.14-rc1 the function gets treatment according to its name and
those who hadn't bothered to switch are left with obvious build errors.
Should be a sufficient incentive to get off their arses and deal with that by
the time 3.14 comes...

It would work and it would avoid incompatible changes, but I agree that
anything using splice in userland ought to have a fallback...  Dunno.
It's definitely not something to be done before .13-rc1, so we have time
to discuss that anyway.
