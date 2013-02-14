Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030263Ab3BNUyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:54:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030245Ab3BNUyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:54:49 -0500
Date: Thu, 14 Feb 2013 15:54:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130214205445.GG16671@redhat.com>
References: <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
 <20130213165922.GD6750@redhat.com>
 <1360846636.3524.589.camel@falcor1.watson.ibm.com>
 <20130214152339.GB16671@redhat.com>
 <1360856159.3524.619.camel@falcor1.watson.ibm.com>
 <20130214161719.GC16671@redhat.com>
 <1360871356.3524.667.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360871356.3524.667.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 02:49:16PM -0500, Mimi Zohar wrote:

[..]
> > > I think you're making this more complicated than it needs to be.  Allow
> > > the execution unless the file failed signature verification.  The
> > > additional capability is given only if the signature verification
> > > succeeds.
> > 
> > I am just trying to bring it inline with module signature verification.
> > There also module loading fails if signatures are present but kernel
> > can't verify it.
> 
> A specific hook is defined for kernel module signature verification,
> which is enabled/disabled in Kconfig.  When enabled, only signed modules
> are loaded.  The kernel module hook does not verify the integrity of the
> userspace application (eg. insmod, modprobe), but of the kernel module
> being loaded.
> 
> Your original patches verified the integrity of the userspace
> application kexec, not the image being loaded.  ima_bprm_check()
> verifies the integrity of executables.  To permit both signed and
> unsigned files to execute, we defined the 'optional' IMA policy flag,
> with the intention of giving more capability to signed executables.
> 
> Unless we define a kexec specific hook for verifying kernel images, it's
> not the same.

I think we are talking of two different things here.

I am referring to kernel module signing where signatures are appended
to module (not IMA hook).

Also I am just referring to behavior about what happens if some error
happens while signature verification.

- If signature verification fails, it is clear what to do.
- If signature verification passes, it is clear what to do.
- Grey area is, what happens if some error is encountered during signature
  verification. Should the module loading be allowed/disallowed. Looking
  at the module loading code, once it is determined that module has
  signature appended to it, module loading fails if some error occurs
  during signature verification.

So I am just referring to that fact and trying to draw parallels between
error handling during module signature verification and error handling
when file appraisal happens in IMA. 

There can be two options.

- Disallow execution only if signature verification fails. If some error
  happens during verification, ignore it, let the executable continue.
  Just that it does not get extra capability.

- Disallow execution only if executable is not signed or it has valid
  signature. If executable is signed and some error happens during the
  process of verifying signature, execution is denied.

In V3 posting of my patches I have taken second appraoch right now. Though
it is up for detbate.


> 
> > Following behavior is strange.
> > 
> >                 rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> >                                              xattr_value->digest, rc - 1,
> >                                              iint->ima_xattr.digest,
> >                                              IMA_DIGEST_SIZE);
> >                 if (rc == -EOPNOTSUPP) {
> >                         status = INTEGRITY_UNKNOWN;
> >                 } else if (rc) {
> >                         cause = "invalid-signature";
> >                         status = INTEGRITY_FAIL;
> >                 } else {
> >                         status = INTEGRITY_PASS;
> >                 }
> > 
> > signature verification can fail for so many reasons.
> > 
> > - EINVAL
> > - keyring is not present
> > - key is not present -ENOKEY
> > - ENOTSUPP
> > - ENOMEM
> > ..
> > ..
> > 
> > And in all these cases we return INTEGRITY_FAIL. But only in case of
> > -EOPNOTSUPP we return INTEGRITY_UNKNOWN. So why this discrepancy.
> 
> This exception is for filesystems that don't support extended
> attributes, such as CPIO.  We assumed, correctly/incorrectly, that the
> initramfs would already be measured and appraised.

Who makes use of it. ima_appraise_measurement() will return
INTEGRITY_UNKNOWN if filesystem does not support xattr. And
process_measurement() will deny access for INTEGRITY_UNKNOWN.

        if ((rc && must_appraise) && (ima_appraise & IMA_APPRAISE_ENFORCE))
                return -EACCES;

So IIUC, if file system does not support xattr, appraisal will anyway
fail. So why to special case -EOPNOTSUPP with integrity_digsig_verify().


> 
> > So to me it makes sense to return INTEGRITY_FAIL if rc == -EOPNOTSUPP.
> 
> Perhaps, but unless the initramfs supports xattrs, we wouldn't be able
> to boot.

Am I reading the code wrong? Given above code snippet, if rc is non
zero, -EACCSS will be returned. So if initramfs does not support
xattr, appraisal will fail.

I suspect following default rule saves us there as it will avoid
appraisal on tmpfs.

action = DONT_APPRAISE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC

Thanks
Vivek
