Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3ISJkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:40:00 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:48199 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3ISJj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:39:58 -0400
Date: Thu, 19 Sep 2013 11:39:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/11] x86: Use asm goto to implement better
 modify_and_test() functions
Message-ID: <20130919093954.GD14112@gmail.com>
References: <20130917082838.218329307@infradead.org>
 <20130917091143.387880231@infradead.org>
 <CA+55aFyVZNb3ZrLfh5FkV4E_P5_LE4-LpDHBwFNp=W1H7CnSBg@mail.gmail.com>
 <4ec87843-c29a-401a-a54f-2cd4d61fba62@email.android.com>
 <20130919083102.GB11427@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130919083102.GB11427@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@linux.intel.com> wrote:

> On Wed, Sep 18, 2013 at 02:02:37PM -0500, H. Peter Anvin wrote:
>
> > Yes, a bit sad.  We allow bracketing with the get/put_user_try/catch 
> > blocks, but that is x86-specific. I don't think a generic option is 
> > possible without compiler support, but it might be possible to do 
> > better than we do know.
> 
> Letting the compiler do it is a bit risky, because it may open it up for 
> really large blocks, thus defeating the security advantages.

Yeah, the compiler could cover other pointer dereferences in the put_user 
block and that won't result in any visible breakage, so it's difficult to 
prevent the compiler doing it accidentally or even intentionally.

Then again the many repeated STAC/CLAC sequences are really not nice.

So maybe we could add some macro magic to generate better assembly here - 
if we coded up a __put_user_2field() primitive then we could already 
optimize the filldir() case:

before:

        if (__put_user(d_ino, &dirent->d_ino))
                goto efault;
        if (__put_user(reclen, &dirent->d_reclen))
                goto efault;
        if (copy_to_user(dirent->d_name, name, namlen))
                goto efault;
        if (__put_user(0, dirent->d_name + namlen))
                goto efault;
        if (__put_user(d_type, (char __user *) dirent + reclen - 1))
                goto efault;

after:

        if (__put_user_2field(d_ino, &dirent->d_ino, reclen, &dirent->d_reclen))
                goto efault;
        if (copy_to_user(dirent->d_name, name, namlen))
                goto efault;
        if (__put_user_2field(0, dirent->d_name + namlen, d_type, (char __user *) dirent + reclen - 1)))
                goto efault;

That cuts down the inlined STAC/CLAC pairs from 4 to 2.

__put_user_2field() would be some truly disgusting (but hidden from most 
people) macro and assembly magic.

We could also add __put_user_4field() and slightly reorder filldir():

        if (__put_user_4field(	d_ino,		&dirent->d_ino,
				reclen,		&dirent->d_reclen,
        			0,		dirent->d_name + namlen,
				d_type,		(char __user *) dirent + reclen - 1)))
                goto efault;

        if (copy_to_user(dirent->d_name, name, namlen))
                goto efault;

That would reduce the inlined STAC/CLAC pairs to a minimal 1 (only one of 
which would be visible in the filldir() disassembly).

In theory we could do something generic:

        if (__put_user_fields(	4,
				d_ino,		&dirent->d_ino,
				reclen,		&dirent->d_reclen,
        			0,		 dirent->d_name + namlen,
				d_type,		(char __user *)dirent + reclen-1 ))
                goto efault;

        if (copy_to_user(dirent->d_name, name, namlen))
                goto efault;

and implement it up to 4 or so. It will be some truly disgusting lowlevel 
code (especially due to the size variations which could make it explode 
combinatorically), with some generic header fallback that utilizes 
existing put_user primitives.

But it's solvable IMO, if we want to solve it. On the high level it's also 
more readable in a fashion and hence perhaps a bit less fragile than our 
usual __put_user() patterns.

Btw., while at it we could also maybe fix the assignment ordering and use 
copy_to_user() naming:

        if (__copy_to_user_fields(4,

			&dirent->d_ino,				d_ino,
			&dirent->d_reclen,			reclen,		
        		dirent->d_name + namlen,		0,
			(char __user *)dirent + reclen-1,	d_type	))

                goto efault;

        if (copy_to_user(dirent->d_name, name, namlen))
                goto efault;

That would make it even more readable.

(Thinking about the macro tricks needed for something like this gave me a 
bad headache though.)

Thanks,

	Ingo
