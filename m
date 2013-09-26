Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3IZOoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:44:20 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50047 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab3IZOoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:44:17 -0400
Message-ID: <1380206654.18835.56.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jiri Kosina <jiri.kosina@suse.com>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Matt Fleming <matt.fleming@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Date: Thu, 26 Sep 2013 07:44:14 -0700
In-Reply-To: <alpine.LNX.2.00.1309260819490.18703@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	  <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>
	  <20130926002730.GA26857@amd.pavel.ucw.cz>
	 <1380162771.18835.47.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1309260819490.18703@pobox.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 08:24 +0200, Jiri Kosina wrote:
> On Wed, 25 Sep 2013, James Bottomley wrote:
> 
> > > I don't get this. Why is it important that current kernel can't
> > > recreate the signature?
> > 
> > The thread model is an attack on the saved information (i.e. the suspend
> > image) between it being saved by the old kernel and used by the new one.
> > The important point isn't that the new kernel doesn't have access to
> > K_{N-1} it's that no-one does: the key is destroyed as soon as the old
> > kernel terminates however the verification public part P_{N-1} survives.
> 
> James,
> 
> could you please describe the exact scenario you think that the symmetric 
> keys aproach doesn't protect against, while the assymetric key aproach 
> does?
> 
> The crucial points, which I believe make the symmetric key aproach work 
> (and I feel quite embarassed by the fact that I haven't realized this 
> initially when coming up with the assymetric keys aproach) are:
> 
> - the kernel that is performing the actual resumption is trusted in the 
>   secure boot model, i.e. you trust it to perform proper verification
> 
> - potentially malicious userspace (which is what we are protecting against 
>   -- malicious root creating fake hibernation image and issuing reboot) 
>   doesn't have access to the symmetric key

OK, so the scheme is to keep a symmetric key in BS that is passed into
the kernel each time (effectively a secret key) for signing and
validation?

The only two problems I see are

     1. The key isn't generational (any compromise obtains it).  This
        can be fixed by using a set of keys generated on each boot and
        passing in both K_{N-1} and K_N
     2. No external agency other than the next kernel can do the
        validation since the validating key has to be secret

The importance of 2 is just tripwire like detection ... perhaps it
doesn't really matter in a personal computer situation.  It would matter
in an enterprise where images are stored and re-used but until servers
have UEFI secure boot, that's not going to be an issue.

James



