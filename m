Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3EDKwq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 06:52:46 -0400
Received: from stator.leun.net ([85.214.203.199]:46187 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117Ab3EDKwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 06:52:42 -0400
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 May 2013 06:52:42 EDT
Date: Sat, 4 May 2013 12:45:19 +0200
From: Michael Leun <lkml20130126@newton.leun.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        gregkh@linuxfoundation.org
Subject: [REGRESSION] bisected: 3.8 -> 3.9 cannot umount after using fuse
Message-ID: <20130504124519.032ac684@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mount some filesystem, below that mountpoint as user mount some fuse fs
(tried that with sshfs and fuseiso, both same error), fusermount -u the
fuse fs, try to unmount the filesystem -> busy.

ml@lara:~> id -u
500
ml@lara:~> grep test /etc/fstab
/dev/vg1/test /mnt2 ext4acl,user_xattr,user,noauto   0 0 
ml@lara:~> mount /mnt2
ml@lara:~> cd /mnt2
ml@lara:/mnt2> ls -l
insgesamt 24
drwx------ 2 root root  16384  4. Mai 11:24 lost+found
drwxr-xr-x 2 root root   4096  4. Mai 11:44 test
drwxr-xr-x 2 ml   users  4096  4. Mai 11:25 xenia
ml@lara:/mnt2> sshfs xenia: xenia
Password: 
ml@lara:/mnt2> ls xenia/bla
xenia/bla
ml@lara:/mnt2> fusermount -u xenia
ml@lara:/mnt2> cd
ml@lara:~> umount /mnt2
umount: /mnt2: target is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
ml@lara:~> fuser -m /mnt2
ml@lara:~>

It does'nt matter if the mounting and unmounting of the /mnt2
filesystem is done as user or as root, same result.

This works in 3.8(.x). Bisecting yields

57eccb830f1cc93d4b506ba306d8dfa685e0c88f is the first bad commit
commit 57eccb830f1cc93d4b506ba306d8dfa685e0c88f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Feb 22 22:49:10 2013 -0500

    mount: consolidate permission checks
    
    ... and ask for global CAP_SYS_ADMIN only for superblock-level remounts
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

:040000 040000 4e926c083f6ede645158f02714d73cdd3b233a05 584611744bad96544578259a6fa176577df0ebbd M      fs

After reverting 57eccb830f1cc93d4b506ba306d8dfa685e0c88f from 3.9 that
umount above works (not busy).

I've seen that this patch also was identified as problem in relation
with user ns and module loading, see lkml

CAGXu5jLciqXcuhzDVPKPqA+mwv8e28zGAMScatzov3U07BuBaQ@mail.gmail.com


After fixing this upstream the fix should be an stabile candidate.

-- 
MfG,

Michael Leun

