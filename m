Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab3B0N5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:57:17 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44308 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760008Ab3B0N5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:57:14 -0500
Message-ID: <1361973427.2908.270.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH] ima: prevent dead lock when a file is opened for direct
 io
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 27 Feb 2013 08:57:07 -0500
In-Reply-To: <CALLzPKYdQKQt=+3bSWeDKj18n9TPSBWAcp3YE852GqkarDrXKQ@mail.gmail.com>
References: <1361395671.29360.26.camel@falcor1>
	 <20130226162024.GI4503@ZenIV.linux.org.uk>
	 <1361907128.2908.180.camel@falcor1.watson.ibm.com>
	 <20130226203408.GJ4503@ZenIV.linux.org.uk>
	 <1361920934.2908.228.camel@falcor1.watson.ibm.com>
	 <CALLzPKbStdUdATJYPfMDxnPB9hgz=-iv1aYpSCTKgL9UUmSmmQ@mail.gmail.com>
	 <CALLzPKYdQKQt=+3bSWeDKj18n9TPSBWAcp3YE852GqkarDrXKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022713-7182-0000-0000-0000058CE214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 14:26 +0200, Kasatkin, Dmitry wrote:
> On Wed, Feb 27, 2013 at 11:21 AM, Kasatkin, Dmitry
> <dmitry.kasatkin@intel.com> wrote:
> > On Wed, Feb 27, 2013 at 1:22 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> >> On Tue, 2013-02-26 at 20:34 +0000, Al Viro wrote:
> >>> On Tue, Feb 26, 2013 at 02:32:08PM -0500, Mimi Zohar wrote:
> >>> > Before anything gets access to the file, the file needs to be measured,
> >>> > appraised, and/or audited, based on policy.  If IMA-appraisal is enabled
> >>> > and the file is in policy, we enforce local file integrity and return
> >>> > -EINVAL on failure, similar to LSMs.
> >>> >
> >>> > Appraising the file is a two step process.  Before appraising the file
> >>> > data's integrity, we verify the integrity of the file metadata. Included
> >>> > in the 'security.evm' calculation is the ino, generation, uid, gid,
> >>> > mode, uuid, and the security xattrs.  'security.ima' contains the file
> >>> > data hash or a signature based on the hash.
> >>> >
> >>> > The i_mutex is held when making file metadata changes (eg. xattrs,
> >>> > chmod, ...).  We hold the i_mutex through the entire verification,
> >>> > preventing the file data/metadata from changing.
> >>>
> >>> ->i_mutex is *not* guaranteed to prevent file data changes.  It does
> >>> cover metadata, but that's it.  ->write() is not required to take it.
> >>> Note, BTW, that as soon as you've dropped ->i_mutex, the metadata can
> >>> be changed by somebody else.
> >>
> >> Any time file metadata included in the HMAC is updated, 'security.evm'
> >> is updated to reflect the change.  But before 'security.evm' is updated,
> >> evm_verify_current_integrity() verifies the existing value.
> >>
> >>> What do you achieve by holding it over the vfs_read() call?
> >>
> >> - Before calculating the file hash, verifying it against the digest in
> >> 'security.ima' and storing the verification status in the iint, we check
> >> the iint to see whether it was previously verified.  By taking the
> >> i_mutex and keeping it, we prevent the file from being hashed multiple
> >> times.
> >>
> >> - Prior to IMA-appraisal, on file close only the iint was updated,
> >> reflecting the fact that the file would need to be re-measured and added
> >> to the measurement list the next time it was opened.  With
> >> IMA-appraisal, on file close, not only do we need to reflect this change
> >> in the iint, but we also need to update the 'security.ima' xattr to
> >> reflect the new hash value.  Having the iint specific lock caused a
> >> lockdep.  In one case, we took the i_mutex followed by the iint lock,
> >> while in the other case, the iint lock was taken before the i_mutex.
> >>
> >>> > I guess I wasn't clear here.  IMA always takes the i_mutex, regardless
> >>> > of the O_DIRECT flag.  When a file is opened for read,
> >>> > process_measurement() takes the i_mutex and then, if the file was opened
> >>> > with the O_DIRECT flag, do_blockdev_direct_IO() attempts to take the
> >>> > i_mutex again, causing the lockdep.
> >>>
> >>> *sigh*
> >>> Do you actually disagree with my description of the locking rules you
> >>> implicitly rely upon?
> >>
> >> Obsolutely not!  I misunderstood what you were saying.  The word
> >> 'unless' was confusing.
> >>
> >>>  Suppose wankfs_file_read() happens to grab
> >>> ->i_mutex for some reason; without IMA it used to be perfectly legitimate.
> >>> With IMA it will deadlock as soon as IMA decides that such file is worth
> >>> its attention.  So these days the rule has (silently) become
> >>>       * ->read() on a regular file is not allowed to touch ->i_mutex
> >>> and with your proposed change it becomes (still undocumented)
> >>>       * ->read() on a regular file is not allowed to touch ->i_mutex unless
> >>> O_DIRECT is present in file flags at the moment of ->read()
> >>> Correct?
> >>
> >> yes, unfortunately.  What would you suggest?
> >>
> >
> > The main purpose of taking i_mutex is to ensure that measured content
> > of the file (vfs_read) is in sync with extended attribute values.
> 
> Just to clarify... to lock i_mutex before collection (vfs_read),
> intead of just before ->setxattr.

Right, when writing 'security.ima' on __fput(), where it is now
permissible to take the i_mutex, we need to ensure that the measured
content of the file and writing the xattr are in sync.

Here, in process_measurement(), the purpose of taking the i_mutex before
calculating the file hash, as opposed to before reading xattrs, is to
tie together calculating the hash, reading the xattrs used in verifying
file integrity, and updating the iint status, so the hash calculation is
done only once.

> > If in overall taking a i_mutex before calling vsf_read is
> > fundamentally wrong, then one of the solutions is to introduce back
> > the usage of IMA specific mutex.
> > iint->mutex was removed because it caused dead locking due different
> > locking order in different cases.

Specifically, chmod took the i_mutex and then iint->mutex, while
ima_file_free() and process_measurement() took the locks in reverse
order.

thanks,

Mimi

