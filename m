Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3APPeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:34:23 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57794 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab3APPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:34:20 -0500
Message-ID: <1358350391.4593.112.camel@falcor1>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Date: Wed, 16 Jan 2013 10:33:11 -0500
In-Reply-To: <20130116144836.GB29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	 <871udloiku.fsf@xmission.com> <1358312159.4593.37.camel@falcor1>
	 <87wqvdli1o.fsf@xmission.com> <1358344859.4593.66.camel@falcor1>
	 <20130116144836.GB29845@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011615-9360-0000-0000-00000F46E2CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 09:48 -0500, Vivek Goyal wrote:
> On Wed, Jan 16, 2013 at 09:00:59AM -0500, Mimi Zohar wrote:
> > On Tue, 2013-01-15 at 23:10 -0800, Eric W. Biederman wrote:
> > > Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> > > 
> > > > Please remind me why you can't use IMA-appraisal, which was upstreamed
> > > > in Linux 3.7?  Why another method is needed?
> > > 
> > > Good question Vivek?  
> 
> - IMA did not have any method to lock down signed binary pages in memory.
>   So while contents on disk could be verified, one could still modify
>   process memory contents by modifying swap. And IMA does not seem to
>   have any mechanism to protect against that.

The kernel itself protects executables from being modified by calling
try_module_get().  The call to security_bprm_check() is immediately
before this call.

> - Also I really could not figure out where does the private signing key
>   lives. I got the impression that we need to trust installer and
>   signing somehow happens at installation time. And we wanted signing
>   to happen at build server and could not trust installer for that.

Dmitry's ima-evm-utils package signs files.  Depending on the options,
both the EVM and IMA extended attributes are created.

>   My understanding of IMA could be wrong. So it would help if you
>   could list the exact steps about how to achieve the same goal using
>   IMA.

http://linux-ima.sourceforge.net/  needs to be updated, but it describes
the integrity subsystem and includes a link to Dave Safford's original
whitepaper "An Overview of the Linux Integrity subsystem".

> > > 
> > > I remeber there was a slight mismatch in the desired attributes.  In
> > > particular we want signatures that are not generated on the local
> > > machine.
> > 
> > Right, IMA-appraisal supports different methods of verification.  The
> > initial methods are hash and digital signature stored in the extended
> > attribute.  With the queued patches, we can force signature verification
> > to be of a specific type. It defines a new IMA policy option called
> > 'appraise_type='.
> > 
> > > > With IMA-appraisal, there are a couple of issues that would still need
> > > > to be addressed:
> > > > - missing the ability to specify the validation method required.
> > > > - modify the ima_appraise_tcb policy policy to require elf executables
> > > > to be digitally signed.
> > > > - security_bprm_check() is called before the binary handler is known.
> > > >
> > > > The first issue is addressed by a set of patches queued to be upstreamed
> > > > in linux-integrity/next-ima-appraise-status.
> > > >
> > > > To address the last issue would either require moving the existing
> > > > bprm_check or defining a new hook after the binary handler is known.
> > > 
> > > Even if there is a small mismatch it certainly sounds like something to
> > > investigate.  There are a lot of pieces flying around with IMA so an
> > > appropriate model of what needs to happen isn't in my head.  As opposed
> > > to a signature in an ELF executable and a key in the kernel.
> > 
> > The original IMA was about measurement and attestation.  IMA-appraisal 
> > adds local integrity validation and enforcement of the measurement
> > against a "good" value stored as an extended attribute 'security.ima'.
> > The initial methods for validating 'security.ima' are hash and digital
> > signature based.
> > 
> > > Hooks aside in an IMA world where does the signing key live?  Where does
> > > the signature live?
> > 
> > Initially, the public key used to verify the signature is loaded onto an
> > IMA specific keyring.  We've discussed embedding public keys inside the
> > kernel, but haven't done so yet.
> 
> So where does the signing key (private key) live? And when does actual
> signing happens and who does it.

The signing process is currently not part of kbuild, but a separate
process, as mentioned above.

> > 
> > The next steps are to ensure the secure boot signature chain of trust
> > has not been broken.
> 
> Yes this one is important. This will also include making sure root can
> not load/install its own keys until and unless new key is signed with
> one of existing keys. Otherwise chain of trust is broken.

Right.

thanks,

Mimi

