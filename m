Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab3CSXSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:18:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55842 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab3CSXR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:17:59 -0400
Date: Tue, 19 Mar 2013 23:17:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Message-ID: <20130319231756.GA21071@srcf.ucam.org>
References: <20130319014850.GA28934@srcf.ucam.org>
 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
 <20130319163531.GA10879@srcf.ucam.org>
 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
 <20130319172506.GA11969@srcf.ucam.org>
 <1363717411.2377.68.camel@dabdike.int.hansenpartnership.com>
 <20130319182810.GA13003@srcf.ucam.org>
 <1363718456.2377.71.camel@dabdike.int.hansenpartnership.com>
 <20130319185003.GA13301@srcf.ucam.org>
 <1363734031.2377.77.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363734031.2377.77.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 11:00:31PM +0000, James Bottomley wrote:
> On Tue, 2013-03-19 at 18:50 +0000, Matthew Garrett wrote:
> > Well, that somewhat complicates implementation - we'd be encrypting the 
> > entire contents of memory except for the key that we're using to encrypt 
> > memory. Keeping the public key away from userspace avoids having to care 
> > about that.
> 
> I don't quite understand what you're getting at: the principle of public
> key cryptography is that you can make the public key, well public.  You
> only need to guard the private key.

Ok, so let's just rephrase it as asymmetric cryptography. The aim is to 
ensure that there's never a situation where userspace can decrypt a 
hibernation file, modify it and reencrypt it. So, shim (or whatever) 
generates a keypair. The encryption key is passed to the kernel being 
booted. The decryption key is stashed in a variable in order to be 
passed to the resume kernel.

If the decryption key is available to userspace then the kernel needs to 
discard the encryption key during image write-out - otherwise the 
encryption key will be in the encrypted image. If the decryption key 
isn't available to userspace then this isn't a concern.

If the decryption key *is* available to userspace (as it would be in 
your case), there's a requirement to discard the encryption key during 
the hibernation process. This isn't impossible, but it does add a little 
to the complexity.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
