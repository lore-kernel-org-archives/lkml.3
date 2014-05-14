Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaENWhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:37:53 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:4806 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbaENWhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:37:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgxIAJ/vc1N5LL1sPGdsb2JhbABZgwaDPoUKpCUBAQEBAQEGmh0BgSgXAwEBAQE4NYIlAQEFJxMcIxAIAw4HAwklDwUlAwcaE4hA0VEXFoU+iHoHgyuBFQSZUJZdKw
Date: Thu, 15 May 2014 08:37:45 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mguzik@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140514223745.GF5421@dastard>
References: <1400018683-5565-1-git-send-email-mguzik@redhat.com>
 <1400018683-5565-2-git-send-email-mguzik@redhat.com>
 <20140514111449.GB5824@quack.suse.cz>
 <20140514112619.GA10637@mguzik.redhat.com>
 <20140514113945.GC5824@quack.suse.cz>
 <20140514220052.GD5421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514220052.GD5421@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 08:00:52AM +1000, Dave Chinner wrote:
> On Wed, May 14, 2014 at 01:39:45PM +0200, Jan Kara wrote:
> > On Wed 14-05-14 13:26:21, Mateusz Guzik wrote:
> > > On Wed, May 14, 2014 at 01:14:49PM +0200, Jan Kara wrote:
> > > > On Wed 14-05-14 00:04:43, Mateusz Guzik wrote:
> > > > > This helps hang troubleshooting efforts when only dmesg is available.
> > > > > 
> > > > > While here remove code duplication with MS_RDONLY case and fix a
> > > > > whitespace nit.
> > > >   I'm somewhat undecided here I have to say. On one hand I don't like
> > > > printing to kernel log when everything is fine and kernel is operating
> > > > normally. On the other hand I've seen quite a few cases where people have
> > > > shot themselves in the foot with filesystem freezing so having some trace
> > > > of this in the log doesn't seem like a completely bad thing either. What do
> > > > other people think?
> > > > 
> > > 
> > > I would like to note that the kernel already prints messages when e.g.
> > > filesystems get mounted.
> >   Yeah, that's a fair point.
> 
> But filesystems choose to output that info, not the VFS. When you do
> a remount,ro there is no output in syslog, because filesystems don't
> need to dump any output - the state change is reflected in
> /proc/self/mounts. IMO frozen should state should be communicated
> the same way so that it is silent when it just works, and the state
> can easily be determined when something goes wrong.

Say, like this:

$ grep /mnt/test /proc/mounts
/dev/vda /mnt/test xfs rw,relatime,attr2,inode64,noquota 0 0
$ sudo xfs_freeze -f /mnt/test
$ grep /mnt/test /proc/mounts
/dev/vda /mnt/test xfs rw,frozen,relatime,attr2,inode64,noquota 0 0
$ sudo xfs_freeze -u /mnt/test
$ grep /mnt/test /proc/mounts
/dev/vda /mnt/test xfs rw,relatime,attr2,inode64,noquota 0 0
$

Patch below does this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

fs: report frozen state in /proc/mounts

From: Dave Chinner <dchinner@redhat.com>

So people can tell if a filesystem is frozen easily, add the
freezing state to the /proc/mount output for the given superblock.
To help diagnose freezing hangs as opposed to frozen filesystems,
differentiate between the states of "freezing" and "frozen" in the
output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/proc_namespace.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 1a81373..0ec4b56 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -53,6 +53,20 @@ static int show_sb_opts(struct seq_file *m, struct super_block *sb)
 			seq_puts(m, fs_infop->str);
 	}
 
+	switch (sb->s_writers.frozen) {
+	case SB_FREEZE_WRITE:
+	case SB_FREEZE_PAGEFAULT:
+	case SB_FREEZE_FS:
+		seq_puts(m, ",freezing");
+		break;
+	case SB_FREEZE_COMPLETE:
+		seq_puts(m, ",frozen");
+		break;
+	case SB_UNFROZEN:
+	default:
+		break;
+	}
+
 	return security_sb_show_options(m, sb);
 }
 
