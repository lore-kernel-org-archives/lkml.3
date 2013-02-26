Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab3BZVa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:30:59 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:42512 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759658Ab3BZVa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:30:58 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <18738.1361836265@warthog.procyon.org.uk>
	<20130226005955.GA19686@kroah.com>
	<20130226023332.GA29282@srcf.ucam.org>
	<20130226030249.GB23834@kroah.com>
	<20130226031338.GA29784@srcf.ucam.org>
	<20130226032508.GA12906@thunk.org>
	<20130226032839.GA30164@srcf.ucam.org>
	<CA+55aFyVShz4T65VJ-1=V=OGwNNriyYf-aaomhDSMHOU7ZZqbA@mail.gmail.com>
	<20130226034250.GB30285@srcf.ucam.org>
	<CA+55aFzn4KGKtn6cXN-jh9jgF+U1zJUnCmk6tRxmW8BZP7_Jnw@mail.gmail.com>
	<20130226034842.GD30285@srcf.ucam.org>
	<CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
Date: Tue, 26 Feb 2013 22:30:46 +0100
In-Reply-To: <CA+55aFyAfgqmxGnh+WpZjgR5qKd+CLr1S7gKnXihqJXB346DqQ@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 25 Feb 2013 20:31:08 -0800")
Message-ID: <87bob6pxtl.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds:

> So here's what I would suggest, and it is based on REAL SECURITY and
> on PUTTING THE USER FIRST instead of your continual "let's please
> microsoft by doing idiotic crap" approach.

I think the real question is this one: Is there *any* device out there
which comes with Microsoft Secure Boot enabled, but doesn't have a
copy of Windows 8 on it?

I guess there isn't.  So Secure Boot support is only required for
supporting dual-booting Windows 8, while still retaining the automated
recovery capabilities (which might well remove the Linux installation
on the same box).

Without dual-booting, there is currently no reason whatsoever to
enable UEFI Secure Boot (or the Microsoft variant).  Not providing a
signed boot loader forces the user to configure the device in a way
that ensures long-term supportability and feature stability (i.e.,
they don't suffer when someone decides to introduce further
restrictions under CAP_COMPROMISE_KERNEL).

Unfortuantely, almost all people I talked to *want* secure boot,
presumably because security is good.  Many of them hate the Microsoft
key (but wouldn't want to own the key, either), but the proposed
alternatives, such as distro-specific keys, are impractical.  Do we
really want systems on which you cannot install Fedora once you have
installed Debian?

> So instead of pleasing microsoft, try to see how we can add real security:
>
>  - a distro should sign its own modules AND NOTHING ELSE by default.

I strongly agree with that (but obviously not the wording, *ahem*).
Actually, we already sign our own kernel modules (and all the software
we ship) in one way or the other.  Some of us even sign a lot of
third-party software which we haven't built from source.

>  - before loading any third-party module, you'd better make sure you
> ask the user for permission. On the console. Not using keys. Nothing
> like that. Keys will be compromised. Try to limit the damage, but more
> importantly, let the user be in control.

This needs a trusted input/output path to the user.  Currently, this
seems difficult to provide once arbitrary userspace code has run as
root.  Hence the round-trip through the UEFI pre-boot environment.

One thing that would be neat is an assurance that if you boot some
image over PXE, it doesn't do any harm to your system.  This isn't
something Microsoft Secure Boot promises at the moment because a
signed boot loader can easily lead to an initrd which wipes your hard
disk.  It's really hard to get there, but at least it would be
something useful.  Similarly, server firmware in a datacenter could
validate the recovery image before executing.  (Actually, I view boot
path validation mainly as a server technology—for clients, you just
save $1 for the known-good, read-only recovery medium.)
