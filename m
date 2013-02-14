Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370Ab3BNQSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:18:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757979Ab3BNQSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:18:11 -0500
Date: Thu, 14 Feb 2013 11:17:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130214161719.GC16671@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
 <1360760195.3524.355.camel@falcor1.watson.ibm.com>
 <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
 <1360763044.3524.367.camel@falcor1.watson.ibm.com>
 <20130213165922.GD6750@redhat.com>
 <1360846636.3524.589.camel@falcor1.watson.ibm.com>
 <20130214152339.GB16671@redhat.com>
 <1360856159.3524.619.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360856159.3524.619.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 10:35:59AM -0500, Mimi Zohar wrote:
> On Thu, 2013-02-14 at 10:23 -0500, Vivek Goyal wrote:
> > On Thu, Feb 14, 2013 at 07:57:16AM -0500, Mimi Zohar wrote:
> > 
> > [..]
> > > > Ok, I will cleanup the code to do above. Just wanted to clear up one
> > > > point. 
> > > > 
> > > > Above option will not have any effect on evm behavior? This only impacts
> > > > IMA appraisal behavior. For example, if security.ima is not present it
> > > > is fine and file access is allowed. But if EVM is enabled and initialized
> > > > and EVM does not find security.evm label (INTEGRITY_NOLABEL) or returns
> > > > INTEGRITY_NOXATTRS, file access should still be denied?
> > > 
> > > Can't happen.  evm_verifyxattr() is called from
> > > ima_appraise_measurement(), only if 'security.ima' exists.
> > 
> > Actually what I meant is following.
> > 
> > Currently in process_measurement(), I will allow access if
> > ima_appraise_measurement() returns INTEGRITY_NOLABEL.
> 
> I think you're making this more complicated than it needs to be.  Allow
> the execution unless the file failed signature verification.  The
> additional capability is given only if the signature verification
> succeeds.

I am just trying to bring it inline with module signature verification.
There also module loading fails if signatures are present but kernel
can't verify it.

Following behavior is strange.

                rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
                                             xattr_value->digest, rc - 1,
                                             iint->ima_xattr.digest,
                                             IMA_DIGEST_SIZE);
                if (rc == -EOPNOTSUPP) {
                        status = INTEGRITY_UNKNOWN;
                } else if (rc) {
                        cause = "invalid-signature";
                        status = INTEGRITY_FAIL;
                } else {
                        status = INTEGRITY_PASS;
                }

signature verification can fail for so many reasons.

- EINVAL
- keyring is not present
- key is not present -ENOKEY
- ENOTSUPP
- ENOMEM
..
..

And in all these cases we return INTEGRITY_FAIL. But only in case of
-EOPNOTSUPP we return INTEGRITY_UNKNOWN. So why this discrepancy.

So to me it makes sense to return INTEGRITY_FAIL if rc == -EOPNOTSUPP.
This will bring it inline with other error codes.  And then in
process_measurement() I can allow access in every case except
INTEGRITY_FAIL.

Thanks
Vivek
