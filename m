Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3JFAND (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 20:13:03 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43802 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3JFAM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 20:12:59 -0400
Date: Sat, 05 Oct 2013 19:12:55 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CA+55aFy-5UhwZukWj2uemaCy3pczpA0nGxxzZGnPCU0=Bv7bHg@mail.gmail.com>
	(from torvalds@linux-foundation.org on Sat Oct  5 18:17:55 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381018375.1974.164@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 06:17:55 PM, Linus Torvalds wrote:
> On Sat, Oct 5, 2013 at 4:07 PM, Rob Landley <rob@landley.net> wrote:
> >
> > A todo item I've had _forever_ is fixing chroot() to not be broken  
> so that
> > you can trivially break out of a chroot via:
> 
> What drugs are you on?

Enough caffeine to count as a plural.

> Your example is moronic, and against all _documented_ uses of chroot.

Yes. That's why it's an exploit.

My example allows someone who can chroot again to break out of a  
previous chroot, which is the reason that lxc doesn't use chroot.

> >   chdir("/");
> >   mkdir("sub");
> >   chroot("sub");
> >   chdir("./../../../../../../../..");
> 
> After you do a chroot(), you need to chdir *into* the root. The reason
> chroot() itself doesn't do that is simple: you may still be doing
> various setup stuff.

Yes, I asked you about this years ago before I implemented chroot and  
switch_root for busybox and toybox, I know how to use it _right_. What  
I'm saying is it doesn't prevent something running in the chroot from  
doing it _wrong_, which is why lxc can't use chroot to implement  
containers and instead uses pivot_root, which is a HORRIBLE system call  
I'd like to move away from.

I want to implement a lightweight container command for toybox, but  
when I dug into lxc and tried to swap their pivot_root for a simple  
chroot, I got corrected.

> But your example is just stupid. Yes, chroot'ed environments can
> generally be escaped, but your example escape is simply because you
> didn't use chroot() correctly.

The above is code you run _in_ the chroot. After the first user used  
chroot incorrectly.

The problem is that there's only one "/" symlink. If you move it down  
under your current "." then nothing stops you from following .. all the  
way up the tree. The fact you can do this after the fact, from within  
an existing chroot, is the problem.

> So learn this pattern: every time you use chroot, add a simple
> 
>   chdir("/");
> 
> immediately after the chroot call.

I do. But I can't stop other people from NOT doing that afterwards.

Rob