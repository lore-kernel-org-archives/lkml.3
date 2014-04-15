Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750931AbaDOWBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:01:24 -0400
Received: from imap.thunk.org ([74.207.234.97]:54778 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaDOWBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:01:22 -0400
Date: Tue, 15 Apr 2014 18:01:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][6/11][MANUX] Kernel compatibility : directory hardlinks
Message-ID: <20140415220119.GM4456@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Emmanuel Colbus <ecolbus@manux.info>, linux-kernel@vger.kernel.org
References: <534D3765.4090403@manux.info>
 <20140415200629.GI4456@thunk.org>
 <534D9C44.1050505@manux.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D9C44.1050505@manux.info>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:53:24PM +0200, Emmanuel Colbus wrote:
> Well, I can give you this information, but first, I would like to
> mention that, since Alan Cox has pointed out the fact that the best
> thing for me was to simply use a modified ELF header and route my own
> syscalls this way, this information has become completely irrelevant. I
> mean, since this value would only appear in my little personal ext2l
> partitions, and in my own little syscalls, there is no point for you to
> do anything anymore, not even reserve it. So, to make it clear, I fully
> retract my previous demand.

The ELF header works fine for your own programs.  The file system
format changes only matter if you care about interoperability or
future proofing with ext4.  If it's only for a toy operating system,
then it won't matter, of course.  But if you're going to depend on
e2fsprogs, or a version of e2fsprogs with your local changes, it's
going to be on you to make it work.

> This value is
> simply stored within the fragment address, as my ext2l partitions don't
> support fragmentation. As for the kernel, it uses these a little bit
> like automatic mountpoint that can't cross partition limits.

We currently using the fragment address for anything (yet), but that
could change in the future, as it's the last unallocated 32-bit field
in the inode.  (I suspect we'll end up using it to support per-block
metdadata, which would be needed to support data block checksums and
reflinks, among other things).

The fragment number is currently being used to support file systems
larger than 16TB (i_file_acl_high).

> The value means that the file is not a true directory, but a directory
> hardlink. Directory hardlinks, which only appear in my ro-compatible
> ext2l partitions, are special files that have no content, and simply
> point to a directory inode by using its inode number. 

I'm not sure what's the value of having a directory hard link given
the existence of symlinks.  I undersatnd what the difference is, but
what value does it give to an end user?  It's confusing, and if there
is a directory hard link to a directory, you won't be able to delete
the directory, lest you leave a dangling reference (and you can't just
remove the primary link to the directory, since then the ".." entry in
the directory will be pointing to the old parent directory).  That
makes hard links of files fundamentally different from a directory
hard link, which will be even more confusing to users.

But if I were going to do such an insane thing, instead of trying to
do it by repurposing an inode field and using an inode, I'd probably
do it by using a bit in the file_type field of the directory entry to
indicate that it's this special "directory hard link" thing.  This
doesn't solve the semantic questions of what happens if you want to
delete a directory that has one or more hard links to it, though.

Regards,

       	        	 	   	    	   - Ted
