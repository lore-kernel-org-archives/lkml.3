Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3APRYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:24:50 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41639 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab3APRYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:24:48 -0500
Message-ID: <1358357079.4593.135.camel@falcor1>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Date: Wed, 16 Jan 2013 12:24:39 -0500
In-Reply-To: <20130116155406.GC29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <871udloiku.fsf@xmission.com> <1358312159.4593.37.camel@falcor1>
	 <87wqvdli1o.fsf@xmission.com> <1358344859.4593.66.camel@falcor1>
	 <20130116144836.GB29845@redhat.com> <1358350391.4593.112.camel@falcor1>
	 <20130116155406.GC29845@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011617-7182-0000-0000-0000047C0A7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 10:54 -0500, Vivek Goyal wrote:
> On Wed, Jan 16, 2013 at 10:33:11AM -0500, Mimi Zohar wrote:
> 
> [..]
> > > - Also I really could not figure out where does the private signing key
> > >   lives. I got the impression that we need to trust installer and
> > >   signing somehow happens at installation time. And we wanted signing
> > >   to happen at build server and could not trust installer for that.
> > 
> > Dmitry's ima-evm-utils package signs files.  Depending on the options,
> > both the EVM and IMA extended attributes are created.
> 
> I was going through following presentation.
> 
> http://selinuxproject.org/~jmorris/lss2011_slides/IMA_EVM_Digital_Signature_Support.pdf
> 
> On slide 8, it mentons signing.
> 
> 	evmctl sign --imahash /path/to/file
> 	evmctl sign --imasig /path/to/file
> 
> Can't figure out where does the key for signing come from? Is it already
> loaded in any of kernel keyrings.
> 
> If yes, I think this is non-starter. One can not distribute the private
> key.

No, the default key location is /etc/keys/privkey_evm.pem, but can be
specified.  Prior to Dmitry's updating the package yesterday, the last
parameter was the key pathname.  After the update, you can specify the
key location with the new --key option.

> Also I am assuming that this is done at installation time? If yes, then
> again it does not work as installer does not have private key.

Not necessarily.  The original use case scenario was creating an image
with both EVM and IMA digital signatures and then flashing the image.

> On slide 11, it talks about importing public keys in kernel keyring from
> initramfs. As we discussed this will need modification as these keys
> need to be signed and signing public key should already be part of 
> kernel keyring.

It's been a long process upstreaming all the different pieces involved.
The initial design/step was to load the public key on a keyring.  Since
then we've added support for multiple keyrings(eg. EVM, IMA, etc).  The
next step is to tie this in with secure boot.

> So looking at the signing process, it really does not look like that
> I can sign the executable at build server. It looks it needs to be
> signed by installer at install time and private key needs to be available
> to installer?

No, the build server can sign the files, so the private key is not
required on the target.  These signatures need to be included in the
package.  Elena Reshetova gave a talk at the last LSS
(http://lwn.net/Articles/518265/), describing changes to RPM to write
the security extended attributes.

> > 
> > >   My understanding of IMA could be wrong. So it would help if you
> > >   could list the exact steps about how to achieve the same goal using
> > >   IMA.
> > 
> > http://linux-ima.sourceforge.net/  needs to be updated, but it describes
> > the integrity subsystem and includes a link to Dave Safford's original
> > whitepaper "An Overview of the Linux Integrity subsystem".
> 
> I have gone through the paper in the past and still the quetions remain
> unanswered. So it will really help, if you could take a very simple
> example of hello-world executable and list the steps needed to be
> performed to sign and verify executable.

Ok, will post this separately.

thanks,

Mimi

