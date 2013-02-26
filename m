Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab3BZVJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 16:09:05 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:54036 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab3BZVJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 16:09:02 -0500
From: Florian Weimer <fw@deneb.enyo.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Kees Cook <keescook@chromium.org>, keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
References: <30665.1361461678@warthog.procyon.org.uk>
	<CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com>
	<20130221164244.GA19625@srcf.ucam.org>
	<87ppzo79in.fsf@mid.deneb.enyo.de>
	<20130225154549.GD13605@srcf.ucam.org>
Date: Tue, 26 Feb 2013 22:08:52 +0100
In-Reply-To: <20130225154549.GD13605@srcf.ucam.org> (Matthew Garrett's message
	of "Mon, 25 Feb 2013 15:45:49 +0000")
Message-ID: <87ehg2pyu3.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett:

> On Mon, Feb 25, 2013 at 03:28:32PM +0100, Florian Weimer wrote:
>
>> But what puzzles me most is why anyone would assume that the UEFI
>> application signing process somehow ensures that the embedded
>> certificate is non-malicious.  We cannot even track it back to the
>> submitter because the third-pary market place UEFI authority only
>> issues pseudonymous proxy certificates.  This utterly useless for any
>> purpose whatsoever, with the notable exception of avoding one
>> additional step when setting up a dual-boot machine (which will not
>> even work reliably until we switch to overwriting the Windows boot
>> loader, like in the pre-UEFI days).
>
> If your firmware trusts objects signed by Microsoft, you have to assume 
> that objects signed by Microsoft are trustworthy. There's no way to 
> build a security model otherwise. Are Microsoft trustworthy? We don't 
> know. If you don't trust Microsoft, remove their key from db.

"Trust" is such an overloaded concept.  I think there are several
aspects here.

The UEFI firmware performs cryptographic validation and only executes
code if successful.

Symantec performs identify verification (the $99 fee) and Microsoft
relies on that.  Microsoft also conducts some review before signing
UEFI drivers.  This actually catches some badness (unintentional
here):

| What Happened to KeyTool.efi?
|
| Originally this was going to be part of our signed release kit.
| However, during testing Microsoft discovered that because of a bug in
| one of the UEFI platforms, it could be used to remove the platform key
| programmatically, which would rather subvert the UEFI security system.
| Until we can resolve this (we’ve now got the particular vendor in the
| loop), they declined to sign KeyTool.efi although you can, of course,
| authorize it by hash in the MOK variables if you want to run it.
 
<http://blog.hansenpartnership.com/linux-foundation-secure-boot-system-released/>

But this review process loses its teeth if the binary just contains an
X.509 certificate which is used later to allow the execution of other
code (either directly, or as the result of a rather complex
interaction of various UEFI drivers, doesn't really matter).

Microsoft never sees the whole code that will be run, and it's totally
open what the driver will actually do when fed with the right data.
At this point, whether anybody trusts Microsoft is completely besides
the point.  They simply don't know.  Their UEFI driver signature is
about as meaningful as a signature from a timestamping service
(particularly since it is pseudonymous).  But they still have
revocation.

I think this is not a good position for them, for us, or for our
users.  All this cryptographic indirection is rather brittle, and it
is totally unclear who is accountable for what.

>> Seriously, folks, can we go back one step and discuss what problem you
>> are trying to solve?  Is it about allowing third-party kernel modules
>> in an environment which does not allow unsigned ring 0 code execution?
>
> The problem I'm trying to solve is "Don't permit Linux to be used as a 
> bootloader for backdoored versions of other operating systems".

If that's the goal, shouldn't we disable KVM support as well?
(Without hardware virtualization support, the user would hopefully
perceive the significant slowdown.)
