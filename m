Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3GOXNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:13:20 -0400
Received: from plane.gmane.org ([80.91.229.3]:56505 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab3GOXNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:13:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [git pull] vfs.git part 2
Date: Mon, 15 Jul 2013 23:13:01 +0000
Organization: D03
Message-ID: <87wqore7sy.fsf@rasmusvillemoes.dk>
References: <20130703122918.GK4165@ZenIV.linux.org.uk>
	<CA+55aFyyxJL1LyXZeBsf2ypriraj5ut1XkNDsunRBqgVjZU_6Q@mail.gmail.com>
	<20130712054817.GY4165@ZenIV.linux.org.uk>
	<8738rk9eai.fsf@rasmusvillemoes.dk>
	<20130712154833.GA4165@ZenIV.linux.org.uk>
	<87wqovviyy.fsf@rasmusvillemoes.dk>
	<20130712191321.GB4165@ZenIV.linux.org.uk>
	<20130712193919.GC4165@ZenIV.linux.org.uk>
	<CA+55aFxA3qoM5wpMUya7gEA8SZyJep7kMBRjrPOsOm_OudD8aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 85-220-43-103.dsl.dynamic.simnet.is
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Cancel-Lock: sha1:U7ivkA9ZLt/EueIUaWolXc6FrQw=
Cc: linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Jul 12, 2013 at 12:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> [suggested by Rasmus Villemoes] make O_DIRECTORY | O_RDWR part of O_TMPFILE;
>> that will fail on old kernels in a lot more cases than what I came up with.
>
> So see earlier about why I'm not convinced about O_RDWR. But even if
> we really want that (and it might be better to start off too narrow
> than accept anything else) your patch tests those bits the wrong way
> (any O_RDWR test should be done using the O_ACCMODE mask, not using
> the O_RDWR value itself as a mask)

On further thought, I think I'll retract the suggestion to include
O_RDWR in O_TMPFILE: If that is done, I don't see how one can ever allow
O_WRONLY functionality without breaking the ABI (or introducing
O_TMPFILE_WRONLY). So I suggest O_TMPFILE == O_DIRECTORY|__O_TMPFILE,
and correct use is open(path, O_TMPFILE|O_RDWR, mode).

Also, O_TMPFILE without O_RDWR (or O_WRONLY) should then give -EINVAL. 

Pros:

The access mode is explicit
Easy to allow O_TMPFILE|O_WRONLY in the future (or now?)
Static code checkers complaining about the lack of
O_{RDONLY,RDWR,WRONLY} in open() (?)

Cons:

We catch one fewer case on older kernels, but not one which is likely to
occur in real programs: On old kernels, O_TMPFILE|O_RDONLY, or
equivalently O_TMPFILE, may give a valid file descriptor (in the case
where path does name a directory). However: Anyone writing a program
using O_TMPFILE probably at least tests on a kernel knowing about that,
and so would be given the -EINVAL error, and the documentation can just
spell out that O_TMPFILE is not compatible with O_RDONLY.

Rasmus

