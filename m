Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab3BZABv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:01:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab3BZABt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:01:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87ppzo79in.fsf@mid.deneb.enyo.de>
References: <87ppzo79in.fsf@mid.deneb.enyo.de> <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: dhowells@redhat.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Date: Mon, 25 Feb 2013 23:51:05 +0000
Message-ID: <18738.1361836265@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Florian Weimer <fw@deneb.enyo.de> wrote:

> Seriously, folks, can we go back one step and discuss what problem you
> are trying to solve?  Is it about allowing third-party kernel modules
> in an environment which does not allow unsigned ring 0 code execution?

Let me try and lay things out:

 (1) Like it or not, the reality is that machines exist that have UEFI secure
     boot.  We want it to be possible for people to be able to install and run
     Linux on these.

 (2) Unless secure boot is completely disabled, the operating system boot
     loader must be signed by a key that's in the UEFI key database.

 (3) We don't want to stop people from being able to dual boot Windows (and
     other OS's - but Windows is the problematic one), therefore we will need
     to be able to operate with secure mode enabled.

 (4) Machines are shipped with a Microsoft root key.  They are not shipped
     with a Microsoft-independent root key from Red Hat or, say, the Linux
     Foundation.

 (5) Unless we get the administrator to add a key prior to Linux installation,
     Linux cannot be booted on a secure UEFI machine - unless the boot loader
     is signed by Microsoft's key.

 (6) To maintain secure boot mode, the kernel must be signed and the boot
     loader must check the signature on it.  The key must be either compiled
     into the bootloader (and thus validated by the bootloader signature) or
     must reside in the UEFI database.

     [*] Note: This step is simplified a bit.

 (7) To maintain secure boot mode, the kernel modules must be signed and the
     kernel must check the signature on them.  The key must be compiled into
     the kernel or the bootloader or must reside in the UEFI database.

At this point, you have the kernel booted in secure boot mode.  Now, there are
several issues we have to deal with going on from here if we want to *stay* in
secure boot mode:

 (A) Unsigned modules.  These may not be loaded in secure boot mode.  At all.

 (B) Systemtap.  We need to be able to debug live kernels.  Red Hat uses
     systemtap a lot for customer support.  However, the private side of the
     key that was used to sign the normal kernel modules gets discarded during
     the build - massively reducing the probability of the key being leaked -
     and so is not available for signing additional modules outside of the
     build.

 (C) Third party modules.  Despite Linus's graphic assertions to the contrary,
     Red Hat has no intention of signing third party modules.

     [*] Note: We realise that it is the right of people to load weird and
     	 terrific stuff into their kernels...  But we don't want to have to
     	 try and deal with the consequences when they do and the sources
     	 aren't easily available.

 (D) kexec.  To be able to replace one kernel with another under secure boot
     means that you have to be able to trust the replacement kernel.
     Therefore that kernel must also be signed by a trusted key known to the
     kernel.

 (E) /dev/mem and similar.  This is not permitted.  Programs should go through
     drivers rather than directly accessing memory mapped devices.

 (F) Direct hardware instruction and DMA.  This must be vetted thoroughly by
     the driver so that this doesn't permit a device to be used to modify a
     running kernel.

 (G) Suspend to disk.  This is not permitted if it's possible to then alter
     the image and resume it.

Now, E-G above are outside the scope of this discussion - however, dealing
with kexec and the loading of modules is pertinent (kexec's boot target can be
dealt with more or less the same as for a module).  So:

 (a) Red Hat will not sign third party modules.

 (b) I don't imagine Linus wants to take patches to make modules PE rather
     than ELF, so direct module signing by Microsoft is out of the question.

 (c) Thus, to load a module signed by a third party requires the third party's
     key be made available to the kernel first.

 (d) Red Hat will not compile third party keys into its kernels - unless those
     keys come via the upstream kernel.

 (e) If Linus patches the upstream kernel to include third party keys, so be
     it.  That's his decision - in that case we will have those keys
     available.  But given Linus's responses, I find that unlikely.

 (f) We must therefore require the administrator to manually add a key using
     the UEFI shell and/or permit keys to be loaded dynamically.  The latter
     option makes it much easier to use with systemtap without having to take
     a machine down (which may be unacceptable or there may be no guarantee of
     reproducing the behaviour after a reboot).

     [*] Note: since the signing keys are done using the in-kernel keyrings
     	 facility, there is a command that's obviously available for adding
     	 them ("keyctl add").

 (g) We cannot simply permit the dynamic addition of just any old key
     otherwise we may as well not bother with signed modules at all.  The
     public key has to be in a container that's signed by a key the kernel
     already possesses and trusts.  The latter key can be one that is compiled
     into the bootloader or the kernel or could be one previously added (if
     multiple chaining is acceptable) or one resident in the UEFI database.

     X.509 certificates are currently the only container that is supported
     upstream.  Red Hat has also used PGP as a container format in the past.

 (h) Red Hat will not sign third party keys.  This would involve us becoming a
     certificate authority, which we'd rather not do as there's a lot of work
     involved in checking that people who want keys are who they say they are.

 (i) Permitting an external key to be chained from the UEFI database means
     that third party keys do not have to chain from Red Hat's key.
     Theoretically, a third party key could then be signed by anyone who owns
     a key in the UEFI database - Microsoft for instance - and still work
     under Linux.

 (j) To the best of my knowledge, Microsoft will only sign PE binaries and
     will not sign X.509 certificates.

So all my patchset does is to permit us to load a key from a signed PE binary
whilst the kernel is running - assuming that PE binary is signed by a key we
have access to and trust.  We don't actually run the binary - we just parse
it.  Sadly the format is a bit weird and involves a PKCS#7 message embedded in
the PE and several steps of digestion, but it's not particularly hard to deal
with.

We also don't want to force people to go through the steps of manually adding
keys to their UEFI.  The steps vary by UEFI firmware implementation - thus
making documentation hard - and there's always the possibility of hitting a
bug and terminally mucking up their key database.

David

[*] Note also, Red Hat wants to support the revocation, blacklist and
    whitelist mechanisms supported by the UEFI database - but that's a side
    issue.
