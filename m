Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaDLSr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 14:47:56 -0400
Received: from mout.gmx.net ([212.227.17.20]:61735 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaDLSrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 14:47:55 -0400
Message-ID: <53498A57.2080004@gmx.de>
Date: Sat, 12 Apr 2014 20:47:51 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fs/debugfs/inode.c: thoughts about "CID 101681 Dereference after
 null check"
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:m6KklzWNY8XBcSUrqv7GORqSkAlnHRc10J3AHFEhjkl94V3EwFC
 8f5hnZ7IXgygCr1lNJkhW4h6D2jUb+Q5/NuIHq9gPpSTKeY7c/EtDQAZkXo3Gr/BrAjTfpF
 ku7QTb/uCnfbMa0QH/p5vaRGSLipFrDXkdilrq+7t4o8cDL9NztINue7vIgyarMF1iJ4Kqr
 2nbZO3086tZEMnELA3xpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256


Just for fun (and to learn a little bit) I picked up an arbitrary entry from coverity [1] :

	CID 101681 Dereference after null check
	Either the check against null is unnecessary, or there may be a null pointer dereference.
	In debugfs_rename: Pointer is checked against null but then dereferenced anyway 

IMO it might be a real issue. At line 606 of fs/debugfs/inode.c we have:

		trap = lock_rename(new_dir, old_dir);
		/* Source or destination directories don't exist? */
		if (!old_dir->d_inode || !new_dir->d_inode)
			goto exit;

and later :
	exit:
		if (dentry && !IS_ERR(dentry))
			dput(dentry);
		unlock_rename(new_dir, old_dir);
		return NULL;

And in the file fs/namei.c starting with line 2481 we do have :

	void unlock_rename(struct dentry *p1, struct dentry *p2)
	{
		mutex_unlock(&p1->d_inode->i_mutex);
		if (p1 != p2) {
			mutex_unlock(&p2->d_inode->i_mutex);
			mutex_unlock(&p1->d_inode->i_sb->s_vfs_rename_mutex);
		}
	}


I'm wondering if the NULL check should be made before lock_rename()  and probably just returns NULL, eg.:

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 8c41b52..7ead0f6 100644
- --- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -603,10 +603,10 @@ struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
        struct dentry *dentry = NULL, *trap;
        const char *old_name;

- -       trap = lock_rename(new_dir, old_dir);
        /* Source or destination directories don't exist? */
        if (!old_dir->d_inode || !new_dir->d_inode)
- -               goto exit;
+               return NULL;
+       trap = lock_rename(new_dir, old_dir);
        /* Source does not exist, cyclic rename, or mountpoint? */
        if (!old_dentry->d_inode || old_dentry == trap ||
            d_mountpoint(old_dentry))



[1] https://scan5.coverity.com:8443/reports.htm#v32611/p10063/fileInstanceId=55651059&defectInstanceId=17130709&mergedDefectId=101681&eventId=17130709-7

- -- 
MfG/Sincerely
Toralf Förster
pgp finger print:1A37 6F99 4A9D 026F 13E2 4DCF C4EA CDDE 0076 E94E
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlNJilcACgkQxOrN3gB26U5Y6AD7BYgw4eNSRZQsQj2B8dx5rr+S
TWXKJbTdU/YbBYMRU0wA/Anqpr/i9HoSLN20L57F6U+1uJir4WTXWCIenjV/jpkY
=MuEz
-----END PGP SIGNATURE-----
