Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936243Ab3DKOxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:53:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934726Ab3DKOw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:52:59 -0400
Date: Thu, 11 Apr 2013 10:52:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Josh Boyer <jwboyer@gmail.com>,
        "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130411145225.GC21260@redhat.com>
References: <20130205183436.GC12853@redhat.com>
 <CALLzPKavbsZgHoJrk5iQ0F1fO21SaeEHmCVCh1G1UKCKB3WZZQ@mail.gmail.com>
 <20130405135000.GB6299@redhat.com>
 <1365450229.3847.56.camel@falcor1.watson.ibm.com>
 <20130408200904.GI28292@redhat.com>
 <CA+5PVA43U_kDSV7p0zhQwmK9pwbVb8qAUePU8svQvoPbDA9iCQ@mail.gmail.com>
 <20130409143852.GH6320@redhat.com>
 <1365563230.3074.107.camel@falcor1.watson.ibm.com>
 <20130410194209.GF6602@redhat.com>
 <1365627922.2452.32.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365627922.2452.32.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 05:05:22PM -0400, Mimi Zohar wrote:
> On Wed, 2013-04-10 at 15:42 -0400, Vivek Goyal wrote:
> > On Tue, Apr 09, 2013 at 11:07:10PM -0400, Mimi Zohar wrote:
> > 
> > [..]
> > > The module keyring is a special case.  Loading these keys from the
> > > kernel and, presumably, locking the keyring is probably fine.  In the
> > > case of IMA, however, files will be signed by any number of package
> > > owners.  If the _ima keyring is locked by the kernel, how would you add
> > > these other keys?
> > 
> > Who are package owners here. IOW, in typical IMA setup, where are the keys
> > and when are these keys loaded in ima keyring?
> 
> Suppose I install third party packages not signed by the distro, but by
> the package owner (eg. google, rpmfusion, ...).  Not only does the
> package signature need to be verified on installation, but the files
> need to be installed with signatures.  For IMA to enforce file
> integrity, the package owner's public key needs to be added to the _ima
> keyring.

Ok, got it. 

> 
> > If we trust root and keys can be loaded any time later, then signed
> > initramfs will not solve the problem either.
> 
> Locking the keyring in the kernel will limit the set of permitted keys
> to only those specified in UEFI db or builtin.  Locking the keyring in
> the "early" initramfs, will allow the system owner, whose key is in the
> UEFI db, to specify additional keys, such as those for third party
> packages.  Not all public keys belong in the UEFI db.

Ok, so third party public key you don't want to add in UEFI db. Instead
platform owner (whose key is in UEFI db) will regenerate initrafs and
sign it.

So above use case is primarily for user space files and verifying its
integrity and IMA keyring is used for that. secureboot does not require
IMA keyring to be locked as none of that code runs at ring0.

This locking requirement of IMA keyring is coming in only because we are
trying to also verify the integrity of a process who will load code which
runs at ring0.

So how do you like the idea of using another keyring (say system keyring)
for this purpose and what keyring to use integrity of a file can be
encoded in file signature.

This is something similar to INTEGRITY_KEYRING_MODULE keyring for modules.
(Though I don't see this code fully hooked up yet).

Or, given the fact that module signature and here /sbin/kexec verification
will make use of similar keys, we can create a system keyring, make module
code make use of that keyring. And IMA code can make use of that keyring
too if a file's digital signature indicates so.

Thanks
Vivek
