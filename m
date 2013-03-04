Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab3CDQU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:20:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758165Ab3CDQUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:20:54 -0500
Date: Mon, 4 Mar 2013 11:20:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com
Subject: Re: [PATCH 2/6] ima: Return INTEGRITY_FAIL if digital signature
 can't be verified
Message-ID: <20130304162033.GB15199@redhat.com>
References: <1360871745-20616-1-git-send-email-vgoyal@redhat.com>
 <1360871745-20616-3-git-send-email-vgoyal@redhat.com>
 <1362404916.4392.25.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362404916.4392.25.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 08:48:36AM -0500, Mimi Zohar wrote:
> On Thu, 2013-02-14 at 14:55 -0500, Vivek Goyal wrote:
> > Digital signature verification happens using integrity_digsig_verify().
> > Curently we set integrity to FAIL for all error codes except -EOPNOTSUPP.
> > This sounds out of line.
> > 
> > - If appropriate kernel code is not compiled in to verify signature of
> >   a file, then prractically it is a failed signature.
> > 
> > - For so many other possible errors we are setting the status to fail.
> >   For example, -EINVAL, -ENOKEY, -ENOMEM, -EINVAL, -ENOTSUPP etc, it
> >   beats me that why -EOPNOTSUPP is special.
> > 
> > This patch should make the semantics more consistent. That is, if digital
> > signature is present in security.ima, then any error happened during
> > signature processing leads to status INTEGRITY_FAIL.
> > 
> > AFAICS, it should not have any user visible effect on existing
> > application. In some cases we will start returning INTEGRITY_FAIL
> > instead of INTEGRITY_UNKNOWN. And process_measurement() will deny access
> > to file both in case of INTEGRITY_UNKNOWN and INTEGRITY_FAIL.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> A number of patches in this patchset more finely differentiate return
> codes, which is good.  I agree with you totally that there is no good
> reason for -EOPNOTSUPP to be handled differently.  Unfortunately, the
> initramfs is CPIO, which doesn't support xattrs.  With the proposed
> change and 'ima_appraise_tcb' flag enabled, we wouldn't be able to boot.
> I really dislike hard coding policy in the kernel.

Hi Mimi,

If there are no xattr, then we will not even hit this code. We will
bail out early in vfs_getxattr_alloc().

I thought that one of the DON_APPRAISE rules will kick in for initramfs
and files in initramfs will not be appraised and boot will continue.

{.action = DONT_APPRAISE,.fsmagic = TMPFS_MAGIC,.flags = IMA_FSMAGIC},
{.action = DONT_APPRAISE,.fsmagic = RAMFS_MAGIC,.flags = IMA_FSMAGIC},

Is that not the case here?

Thanks
Vivek
