Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3APSpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:45:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48410 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3APSpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:45:22 -0500
Message-ID: <1358361912.4593.162.camel@falcor1>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Date: Wed, 16 Jan 2013 13:45:12 -0500
In-Reply-To: <20130116182146.GE29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <871udloiku.fsf@xmission.com> <1358312159.4593.37.camel@falcor1>
	 <87wqvdli1o.fsf@xmission.com> <1358344859.4593.66.camel@falcor1>
	 <20130116144836.GB29845@redhat.com> <1358350391.4593.112.camel@falcor1>
	 <20130116155406.GC29845@redhat.com> <1358357079.4593.135.camel@falcor1>
	 <20130116182146.GE29845@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011618-7182-0000-0000-0000047CC975
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 13:21 -0500, Vivek Goyal wrote:
> On Wed, Jan 16, 2013 at 12:24:39PM -0500, Mimi Zohar wrote:
> > On Wed, 2013-01-16 at 10:54 -0500, Vivek Goyal wrote:
> > > On Wed, Jan 16, 2013 at 10:33:11AM -0500, Mimi Zohar wrote:
> > > 
> > > [..]
> > > > > - Also I really could not figure out where does the private signing key
> > > > >   lives. I got the impression that we need to trust installer and
> > > > >   signing somehow happens at installation time. And we wanted signing
> > > > >   to happen at build server and could not trust installer for that.
> > > > 
> > > > Dmitry's ima-evm-utils package signs files.  Depending on the options,
> > > > both the EVM and IMA extended attributes are created.
> > > 
> > > I was going through following presentation.
> > > 
> > > http://selinuxproject.org/~jmorris/lss2011_slides/IMA_EVM_Digital_Signature_Support.pdf
> > > 
> > > On slide 8, it mentons signing.
> > > 
> > > 	evmctl sign --imahash /path/to/file
> > > 	evmctl sign --imasig /path/to/file
> > > 
> > > Can't figure out where does the key for signing come from? Is it already
> > > loaded in any of kernel keyrings.
> > > 
> > > If yes, I think this is non-starter. One can not distribute the private
> > > key.
> > 
> > No, the default key location is /etc/keys/privkey_evm.pem, but can be
> > specified.  Prior to Dmitry's updating the package yesterday, the last
> > parameter was the key pathname.  After the update, you can specify the
> > key location with the new --key option.
> > 
> > > Also I am assuming that this is done at installation time? If yes, then
> > > again it does not work as installer does not have private key.
> > 
> > Not necessarily.  The original use case scenario was creating an image
> > with both EVM and IMA digital signatures and then flashing the image.
> 
> But distributions don't ship pre-setup root file system. It is created
> and labeled at installation time. So if we want to use IMA, we need to
> sign files at installation time. That means private keys need to be
> accessible to installer (using --key option). And that does not work for
> this use case.

No, packages contain file data and the associated file metadata,
including extended attributes.  Files would be signed as part of the
build process and written out as extended attributes.

> > 
> > > On slide 11, it talks about importing public keys in kernel keyring from
> > > initramfs. As we discussed this will need modification as these keys
> > > need to be signed and signing public key should already be part of 
> > > kernel keyring.
> > 
> > It's been a long process upstreaming all the different pieces involved.
> > The initial design/step was to load the public key on a keyring.  Since
> > then we've added support for multiple keyrings(eg. EVM, IMA, etc).  The
> > next step is to tie this in with secure boot.
> > 
> > > So looking at the signing process, it really does not look like that
> > > I can sign the executable at build server. It looks it needs to be
> > > signed by installer at install time and private key needs to be available
> > > to installer?
> > 
> > No, the build server can sign the files, so the private key is not
> > required on the target.  These signatures need to be included in the
> > package.  Elena Reshetova gave a talk at the last LSS
> > (http://lwn.net/Articles/518265/), describing changes to RPM to write
> > the security extended attributes.
> 
> Following is from article.
> 
> "The other hooks that Reshetova proposed are associated with the individual
> files in a package. Those would allow things like security labeling or
> calculating hashes on the file contents (for integrity purposes)."
> 
> IIUC, these hooks will execute on the target. So hash and all signatures
> should still be generated on target and not build server?

No, the package, including the extended attributes containing the
signature, are installed on the target system.  The associated public
key needs to also be installed on the target, not the private key.

> Given the fact that signatures are stored in extended attributes, to me
> the only way to sign executables in current IMA framework would to be
> prepare file system image at build server and ship that image. And
> then installer simply mounts that image (after making sure that proper
> verification keys have been loaded in kernel).

That is one scenario.  Another scenario is to update packages to include
extended attributes and to write those extended attributes on
installation.  This is currently supported for some, but not all
security extended attributes.  Elena's talk discussed doing this in a
generic manner for all security extended attributes.

> And this image will pretty much be static. As you don't have private key
> you can't install more packages and sign these.

No! You're missing the point.  We don't need the private key to install
a package.  There, however, does need to be a safe and trusted mechanism
to install the public key.

thanks,

Mimi

