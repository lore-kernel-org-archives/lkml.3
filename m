Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaLPQ1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:27:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47780 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaLPQ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:27:21 -0500
Date: Tue, 16 Dec 2014 16:27:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [BUG, linux-next] spawn PID 1 without CLONE_FS, wireless inop
Message-ID: <20141216162716.GE22149@ZenIV.linux.org.uk>
References: <20141216115537.GA1259@hudson.localdomain>
 <20141216125615.GZ22149@ZenIV.linux.org.uk>
 <20141216132821.GA22149@ZenIV.linux.org.uk>
 <20141216140952.GA1224@hudson.localdomain>
 <20141216142542.GC22149@ZenIV.linux.org.uk>
 <20141216144610.GA1219@hudson.localdomain>
 <20141216150518.GD22149@ZenIV.linux.org.uk>
 <20141216152626.GA1228@hudson.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216152626.GA1228@hudson.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 07:26:26AM -0800, Jeremiah Mahler wrote:

> > No such errors happen on the normal boot, presumably?
> > 
> > > [    2.392117] EXT4-fs (sda5): mounting ext2 file system using the ext4 subsystem
> > > [    2.393920] EXT4-fs (sda5): mounted filesystem without journal. Opts: (null)
> > 
> > Wait a minute. So that happens _before_ /dev/sda5 mount?  Could you post dmesg
> > from the normal boot (e.g. just prior to the buggy commit)?
> > 
> > I really don't get it - there's nothing for init_fs.root to point to other
> > than initramfs by that point, CLONE_FS or no CLONE_FS.  We simply don't
> > have anything else mounted yet.  Do you get another failing bunch of
> > request_firmware later?  And what does dmesg look like on the working
> > kernel - either you have that firmware on initramfs image (in which case
> > it ought to have been picked by both kernels), or you do not, in which case
> > neither kernel would've managed to load it until after mounting the real
> > root...
> 
> I compiled this kernel with the commit just before the bug was introduced
> (93fe74b2e2b5d266d630f0c3f8287efcbe6ecd10).  Wireless comes up without
> any issue.  Here is the dmesg output.

OK, so the root is on sda6, it's been mounted before those attempts to
load firmware and init has been chrooted into it, while init_fs got left
behind.  And that "chrooted into" has happened without pivot_root(2) (or
it would've been caught by chroot_fs_refs() in sys_pivot_root()) and
not from the "no /init on initramfs" codepath (you do have it there).

OK, it's probably unsalvagable, then.  Pity, since it means that PID 1 and
kernel threads _must_ share ->fs, for the sake of usable ->fs->root, which
is asking for trouble.  And it means that we still need a sane solution for
nfsd folks...

Anyway, dropped that stuff from for-next (and for-linus, obviously), with
apologies all around.
