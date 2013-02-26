Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595Ab3BZXW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:22:27 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41095 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab3BZXWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:22:25 -0500
Message-ID: <1361920934.2908.228.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH] ima: prevent dead lock when a file is opened for direct
 io
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 26 Feb 2013 18:22:14 -0500
In-Reply-To: <20130226203408.GJ4503@ZenIV.linux.org.uk>
References: <1361395671.29360.26.camel@falcor1>
	 <20130226162024.GI4503@ZenIV.linux.org.uk>
	 <1361907128.2908.180.camel@falcor1.watson.ibm.com>
	 <20130226203408.GJ4503@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022623-5806-0000-0000-0000201BA40D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-26 at 20:34 +0000, Al Viro wrote:
> On Tue, Feb 26, 2013 at 02:32:08PM -0500, Mimi Zohar wrote:
> > Before anything gets access to the file, the file needs to be measured,
> > appraised, and/or audited, based on policy.  If IMA-appraisal is enabled
> > and the file is in policy, we enforce local file integrity and return
> > -EINVAL on failure, similar to LSMs.
> > 
> > Appraising the file is a two step process.  Before appraising the file
> > data's integrity, we verify the integrity of the file metadata. Included
> > in the 'security.evm' calculation is the ino, generation, uid, gid,
> > mode, uuid, and the security xattrs.  'security.ima' contains the file
> > data hash or a signature based on the hash.
> > 
> > The i_mutex is held when making file metadata changes (eg. xattrs,
> > chmod, ...).  We hold the i_mutex through the entire verification,
> > preventing the file data/metadata from changing.
> 
> ->i_mutex is *not* guaranteed to prevent file data changes.  It does
> cover metadata, but that's it.  ->write() is not required to take it.
> Note, BTW, that as soon as you've dropped ->i_mutex, the metadata can
> be changed by somebody else.

Any time file metadata included in the HMAC is updated, 'security.evm'
is updated to reflect the change.  But before 'security.evm' is updated,
evm_verify_current_integrity() verifies the existing value.

> What do you achieve by holding it over the vfs_read() call?

- Before calculating the file hash, verifying it against the digest in
'security.ima' and storing the verification status in the iint, we check
the iint to see whether it was previously verified.  By taking the
i_mutex and keeping it, we prevent the file from being hashed multiple
times.

- Prior to IMA-appraisal, on file close only the iint was updated,
reflecting the fact that the file would need to be re-measured and added
to the measurement list the next time it was opened.  With
IMA-appraisal, on file close, not only do we need to reflect this change
in the iint, but we also need to update the 'security.ima' xattr to
reflect the new hash value.  Having the iint specific lock caused a
lockdep.  In one case, we took the i_mutex followed by the iint lock,
while in the other case, the iint lock was taken before the i_mutex.

> > I guess I wasn't clear here.  IMA always takes the i_mutex, regardless
> > of the O_DIRECT flag.  When a file is opened for read,
> > process_measurement() takes the i_mutex and then, if the file was opened
> > with the O_DIRECT flag, do_blockdev_direct_IO() attempts to take the
> > i_mutex again, causing the lockdep.
> 
> *sigh*
> Do you actually disagree with my description of the locking rules you
> implicitly rely upon? 

Obsolutely not!  I misunderstood what you were saying.  The word
'unless' was confusing.

>  Suppose wankfs_file_read() happens to grab
> ->i_mutex for some reason; without IMA it used to be perfectly legitimate.
> With IMA it will deadlock as soon as IMA decides that such file is worth
> its attention.  So these days the rule has (silently) become
> 	* ->read() on a regular file is not allowed to touch ->i_mutex
> and with your proposed change it becomes (still undocumented)
> 	* ->read() on a regular file is not allowed to touch ->i_mutex unless
> O_DIRECT is present in file flags at the moment of ->read()
> Correct?

yes, unfortunately.  What would you suggest?

thanks, 

Mimi

