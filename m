Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab3IZBL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:11:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:36489 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751283Ab3IZBLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:11:54 -0400
Date: Wed, 25 Sep 2013 21:11:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: David Howells <dhowells@redhat.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>, <linux-efi@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <opensuse-kernel@opensuse.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>, <JKosina@suse.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
In-Reply-To: <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>
Message-ID: <Pine.LNX.4.44L0.1309252056090.30035-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013, James Bottomley wrote:

> > Why are asymmetric keys used for verifying the hibernation image?  It
> > seems that a symmetric key would work just as well.  And it would be a
> > lot quicker to generate, because it wouldn't need any high-precision
> > integer computations.
> 
> The reason is the desire to validate that the previous kernel created
> something which it passed on to the current kernel (in this case, the
> hibernation image) untampered with.  To do that, something must be
> passed to the prior kernel that can be validated but *not* recreated by
> the current kernel.

As Pavel pointed out, this seems like a futile approach.  If the 
current kernel is going to do the validating, then of course it can
create something that it will validate.

Or to put it another way, how come you don't trust the current kernel
not to modify the image but you do trust it to validate the image?

> The scheme for doing this is a public/private key pair generated for
> each boot incarnation N as a pair P_N (public key) and K_N (private
> key).  Then the Nth boot incarnation gets P_{N-1} and K_N (the boot

Where does it get them from?  Some place in the firmware, presumably.

> environment holds P_N in inaccessible BS variables for passing into the
> next kernel) so the Nth kernel can validate information from the N-1th
> kernel using P_{N-1} and create information for passing on in a
> validated fashion to the next kernel using K_N.

So kernel N gets P_{N-1} and an image that has been signed by K_{N-1}.  
What's to prevent kernel N from creating a bogus pair of keys (K',P')
and a bogus image, signing that image with K', and then pretending it
got P' from the firmware instead of P_{N-1}?

However...  Let's assume that you _do_ trust kernel N.  Then consider 
this alternative approach:

A symmetric key S_N is created for boot incarnation N.  Kernel N
receives S_{N-1} from the firmware and uses it to verify the signature
attached to the hibernation image.  When kernel N wants to create the
next hibernation image, it signs the image with S_N (also obtained 
from the firmware).

> This scheme doesn't work with symmetric keys unless you have a
> modification I haven't seen?

Obviously these two schemes are different.  Do these differences have
any security implications?

Alan Stern

