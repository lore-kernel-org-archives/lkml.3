Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaLaWIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 17:08:15 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58546 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaLaWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 17:08:14 -0500
From: Paul Moore <paul@paul-moore.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-audit@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Audit fixes for 3.19 #2
Date: Wed, 31 Dec 2014 17:08:12 -0500
Message-ID: <3787508.5gHb8qD3XR@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CA+55aFzwqafHa6ARO-zkCDaHZozZDDvETBMmbnvNsnu1L9v2=w@mail.gmail.com>
References: <3159430.4MhUX0bhoZ@sifl> <CA+55aFzwqafHa6ARO-zkCDaHZozZDDvETBMmbnvNsnu1L9v2=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 31, 2014 01:23:14 PM Linus Torvalds wrote:
> On Wed, Dec 31, 2014 at 12:33 PM, Paul Moore <paul@paul-moore.com> wrote:
> > One audit patch to resolve a panic/oops when recording filenames in the
> > audit log, see the mail archive link below.  The fix isn't as nice as I
> > would like, as it involves an allocate/copy of the filename, but it
> > solves the problem and the overhead should only affect users who have
> > configured audit rules involving file names.
> 
> This fix looks wrong.
> 
> The kernel "getname()" function already has hacks explicitly for this
> audit usage. Why aren't those hacks working? See the whole
> "audit_getname()" and "audit_putname()" thing in fs/namei.c.
> 
> So why does audit now need to copy the name *again*, when the whole -
> and only - point of the current fs/namei.c audit hackery is exactly so
> that audit can control the lifetime of the pathnames?

The getname/putname hacks work in the normal file case, but it falls apart 
when you start talking about AF_UNIX socket files where the filename string 
doesn't go through the getname/putname refcount tricks.  In the past (no idea 
how far back this goes off the top of my head) this wasn't an issue since the 
code which recorded the filenames in the audit records was broken, but since 
we just "fixed" that problem, the AF_UNIX socket problem is now making an 
appearance.

At least that is how it looks to me right now, if I'm wrong about this and I'm 
missing an obvious fix I'm all ears/eyes/etc.

> Hmm? Alternatively, could we just remove the fs/namei.c hackery
> entirely, and rely on audit always copying the filenames for its own
> use?

I'm still coming up to speed on this mess of a subsystem, so I can't say I'm 
well versed in all the audit design decisions up to this point, but ... I'd 
hate to see us lose the getname/putname hacks if we can find a way to 
differentiate between normal files and things like AF_UNIX.  I've got some 
ideas but I wanted to get you a patch soonish since v3.19-rc2 pukes all over 
itself if you configure audit in a particular way (evidently the Gentoo 
default config triggers the problem).  If you're okay with waiting a bit 
longer I can work on this a bit more and try to find a more elegant solution; 
I'm already working this on anyway for v3.20 (or whatever it happens to be 
when the patch is ready).

-- 
paul moore
www.paul-moore.com

