Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3B0TBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 14:01:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42347 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3B0TA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 14:00:58 -0500
Date: Wed, 27 Feb 2013 19:00:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ima: prevent dead lock when a file is opened for direct
 io
Message-ID: <20130227190046.GP4503@ZenIV.linux.org.uk>
References: <1361395671.29360.26.camel@falcor1>
 <20130226162024.GI4503@ZenIV.linux.org.uk>
 <1361907128.2908.180.camel@falcor1.watson.ibm.com>
 <20130226203408.GJ4503@ZenIV.linux.org.uk>
 <1361920934.2908.228.camel@falcor1.watson.ibm.com>
 <CALLzPKbStdUdATJYPfMDxnPB9hgz=-iv1aYpSCTKgL9UUmSmmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKbStdUdATJYPfMDxnPB9hgz=-iv1aYpSCTKgL9UUmSmmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:21:15AM +0200, Kasatkin, Dmitry wrote:
> On Wed, Feb 27, 2013 at 1:22 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Tue, 2013-02-26 at 20:34 +0000, Al Viro wrote:
> >> On Tue, Feb 26, 2013 at 02:32:08PM -0500, Mimi Zohar wrote:
> >> > Before anything gets access to the file, the file needs to be measured,
> >> > appraised, and/or audited, based on policy.  If IMA-appraisal is enabled
> >> > and the file is in policy, we enforce local file integrity and return
> >> > -EINVAL on failure, similar to LSMs.
> >> >
> >> > Appraising the file is a two step process.  Before appraising the file
> >> > data's integrity, we verify the integrity of the file metadata. Included
> >> > in the 'security.evm' calculation is the ino, generation, uid, gid,
> >> > mode, uuid, and the security xattrs.  'security.ima' contains the file
> >> > data hash or a signature based on the hash.
> >> >
> >> > The i_mutex is held when making file metadata changes (eg. xattrs,
> >> > chmod, ...).  We hold the i_mutex through the entire verification,
> >> > preventing the file data/metadata from changing.
> >>
> >> ->i_mutex is *not* guaranteed to prevent file data changes.  It does
> >> cover metadata, but that's it.  ->write() is not required to take it.
> >> Note, BTW, that as soon as you've dropped ->i_mutex, the metadata can
> >> be changed by somebody else.
> >
> > Any time file metadata included in the HMAC is updated, 'security.evm'
> > is updated to reflect the change.  But before 'security.evm' is updated,
> > evm_verify_current_integrity() verifies the existing value.
> >
> >> What do you achieve by holding it over the vfs_read() call?
> >
> > - Before calculating the file hash, verifying it against the digest in
> > 'security.ima' and storing the verification status in the iint, we check
> > the iint to see whether it was previously verified.  By taking the
> > i_mutex and keeping it, we prevent the file from being hashed multiple
> > times.
> >
> > - Prior to IMA-appraisal, on file close only the iint was updated,
> > reflecting the fact that the file would need to be re-measured and added
> > to the measurement list the next time it was opened.  With
> > IMA-appraisal, on file close, not only do we need to reflect this change
> > in the iint, but we also need to update the 'security.ima' xattr to
> > reflect the new hash value.  Having the iint specific lock caused a
> > lockdep.  In one case, we took the i_mutex followed by the iint lock,
> > while in the other case, the iint lock was taken before the i_mutex.
> >
> >> > I guess I wasn't clear here.  IMA always takes the i_mutex, regardless
> >> > of the O_DIRECT flag.  When a file is opened for read,
> >> > process_measurement() takes the i_mutex and then, if the file was opened
> >> > with the O_DIRECT flag, do_blockdev_direct_IO() attempts to take the
> >> > i_mutex again, causing the lockdep.
> >>
> >> *sigh*
> >> Do you actually disagree with my description of the locking rules you
> >> implicitly rely upon?
> >
> > Obsolutely not!  I misunderstood what you were saying.  The word
> > 'unless' was confusing.
> >
> >>  Suppose wankfs_file_read() happens to grab
> >> ->i_mutex for some reason; without IMA it used to be perfectly legitimate.
> >> With IMA it will deadlock as soon as IMA decides that such file is worth
> >> its attention.  So these days the rule has (silently) become
> >>       * ->read() on a regular file is not allowed to touch ->i_mutex
> >> and with your proposed change it becomes (still undocumented)
> >>       * ->read() on a regular file is not allowed to touch ->i_mutex unless
> >> O_DIRECT is present in file flags at the moment of ->read()
> >> Correct?
> >
> > yes, unfortunately.  What would you suggest?
> >
> 
> The main purpose of taking i_mutex is to ensure that measured content
> of the file (vfs_read) is in sync with extended attribute values.
> 
> If in overall taking a i_mutex before calling vsf_read is
> fundamentally wrong, then one of the solutions is to introduce back
> the usage of IMA specific mutex.
> iint->mutex was removed because it caused dead locking due different
> locking order in different cases.

BTW, speaking of races in there: what's to stop ima_file_mmap() from
racing with rename()?  You have
int ima_file_mmap(struct file *file, unsigned long prot)
{
        if (file && (prot & PROT_EXEC))
                return process_measurement(file, file->f_dentry->d_name.name,
                                           MAY_EXEC, MMAP_CHECK);
        return 0;
}
in there; just what is that ->d_name.name good for?  By the time you get
through calculating hash (which, by definition, may include a considerable
amount of IO), the pointer you have passed might be pointing to anything.

If the name is short, it's kept within dentry and updated by d_move() (not
that I'd seen any exclusion with that in there, while we are at it).  If
the name is too long to fit into struct dentry, it's allocated separately.
See fs/dcache.c:switch_names() for what's being ultimately done on rename();
dname_external() is a predicate telling if we store the name separately.
The normal sequence of events if you rename(something/very_long_file_name,
something_else) is this:
	* we get dentries of both source and target; dentry of source has
->d_name pointing to separately allocated name
	* filesystem is asked to move the sucker; suppose it succeeds
	* we do d_move(source, target)
		* target is unhashed
		* source and target names and pointers to parents are
		  exchanged - now source is where we wanted it to be placed
		  and its old ->d_name is not lost - target->d_name points
		  to it now.  Not for long, though, since...
	* ... we drop references to source and target we had acquired.  And
	  since target had been unhashed, down the drain it goes.  Which
	  frees its separately allocated ->d_name (i.e. what used to be
	  old name of source) and drops the reference to its parent (i.e.
	  what used to be the old parent of source).
Now think what happens if you have found source->d_name.name before rename(2)
and dereferenced it after.

The real question is, what are you using that name for?  Or ima_d_path()
result that normally gets used instead of it, for that matter.  Sure,
in case of ima_d_path() you will have a safe copy of what used to be
the pathname.  What is it good for, though, when the file might've been
moved just as ima_d_path() returns its copy of pathname to caller?
