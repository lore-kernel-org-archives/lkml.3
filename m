Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3EZJkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 05:40:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33639 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab3EZJj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 05:39:57 -0400
Date: Sun, 26 May 2013 11:39:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: P??draig Brady <P@draigBrady.com>, linux-kernel@vger.kernel.org,
        Eric Blake <eblake@redhat.com>
Subject: Re: RFC: allow empty symlink targets
Message-ID: <20130526093954.GB7225@amd.pavel.ucw.cz>
References: <1358427833-3847-1-git-send-email-P@draigBrady.com>
 <50F8252C.2060404@draigBrady.com>
 <519381D8.5080206@draigBrady.com>
 <20130515220335.GV25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130515220335.GV25399@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-05-15 23:03:35, Al Viro wrote:
> On Wed, May 15, 2013 at 01:38:48PM +0100, P??draig Brady wrote:
> > >> In today's Austin Group meeting, I was tasked to open a new bug that
> > >> would state specifically how the empty symlink is resolved; the intent
> > >> is to allow both Solaris behavior (current directory) and BSD behavior
> > >> (ENOENT).  Meanwhile, everyone was in agreement that the Linux kernel
> > >> has a bug for rejecting the creation of an empty symlink, but once that
> > >> bug is fixed, then Linux can choose either Solaris or BSD behavior for
> > >> how to resolve such a symlink.
> 
> Austin Group Is At It Again, Demands at 11...
> 
> Would you mind explaining who's "everyone" and why would we possibly
> want to honour that agreement of yours?  Functionality in question is
> utterly pointless, seeing that semantics of such symlinks is OS-dependent
> anyway *and* that blanket refusal to traverse such beasts is a legitimate
> option.  What's the point in allowing to create them in the first
> place?

BSD may have created them. Or evil sysadmin (me) might have created
them with hex editor.

AFAICT we seem to have the Solaris behavior (current directory):

pavel@amd:/mnt/foo$ ls -al link2/
total 3
drwxr-xr-x 2 pavel pavel 1024 May 26 11:34 .
drwxr-xr-x 4 pavel pavel 1024 May 26 11:29 ..
-rw-r--r-- 1 pavel pavel    5 May 26 11:29 file1
lrwxrwxrwx 1 pavel pavel    5 May 26 11:29 link1 -> file1
lrwxrwxrwx 1 pavel pavel   21 May 26 11:34 link2 -> 
lrwxrwxrwx 1 pavel pavel    5 May 26 11:29 this_will_be_null_link ->
file1
pavel@amd:/mnt/foo$ cd link2/
pavel@amd:/mnt/foo/link2$ ls -al
total 3
drwxr-xr-x 2 pavel pavel 1024 May 26 11:34 .
drwxr-xr-x 4 pavel pavel 1024 May 26 11:29 ..
-rw-r--r-- 1 pavel pavel    5 May 26 11:29 file1
lrwxrwxrwx 1 pavel pavel    5 May 26 11:29 link1 -> file1
lrwxrwxrwx 1 pavel pavel   21 May 26 11:34 link2 -> 
lrwxrwxrwx 1 pavel pavel    5 May 26 11:29 this_will_be_null_link ->
file1
pavel@amd:/mnt/foo/link2$ cd link2/
pavel@amd:/mnt/foo/link2/link2$ ls 
file1  link1  link2  this_will_be_null_link
pavel@amd:/mnt/foo/link2/link2$ cd ..

They are _not_ detected as broken during runtime (ext2 fs is not marked as
containing errors) but fsck seems to handle them correctly.

pavel@amd:~/misc$ /sbin/fsck.ext2 -f delme2.fs 
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Symlink /foo/link2 (inode #7717) is invalid.
Clear<y>? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

delme2.fs: ***** FILE SYSTEM WAS MODIFIED *****
delme2.fs: 15/25064 files (0.0% non-contiguous), 4724/100000 blocks
pavel@amd:~/misc$ 

I was looking for nice kernel crash but alas, nothing :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
