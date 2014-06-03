Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaFCNWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:22:24 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61278 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaFCNWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:22:22 -0400
Date: Tue, 3 Jun 2014 15:21:53 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: David Howells <dhowells@redhat.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05g@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: Unionmount and overlayfs testsuite
Message-ID: <20140603132153.GA26512@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpegtobxoMs+RRrPYLFRPOVSfr_uqZs+HJFLRif3svHGyQwA@mail.gmail.com>
 <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
 <28592.1401382081@warthog.procyon.org.uk>
 <11446.1401420931@jrobl>
 <7184.1401439773@warthog.procyon.org.uk>
 <CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com>
 <15839.1401786056@warthog.procyon.org.uk>
 <CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com>
 <CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com>
 <10013.1401791634@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10013.1401791634@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 11:33:54AM +0100, David Howells wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Fix now pushed to overlayfs.v22/overlayfs.current.
> 
> I ran my testscript, which leaves a clean set up and mounted overlay fs
> behind.  I then ran:
> 
> 	for ((i=100; i<=129; i++)); do mv /mnt/a/foo$i /mnt/a/bar$i; done
> 	for ((i=100; i<=129; i++)); do mv /mnt/a/dir$i /mnt/a/dir2$i; done
> 
> leading to:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 3.15.0-rc6-fsdevel+ #382 Tainted: G        W    
> ---------------------------------------------
> mv/27935 is trying to acquire lock:
>  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffff8111e555>] vfs_rmdir+0x59/0xe8
> 
> but task is already holding lock:
>  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffff811e12a9>] ovl_clear_empty+0x175/0x1eb

And this one is a missing annotation in overlayfs.  Tested patch pushed to the
usual branches.

Thanks,
Miklos

---
 fs/overlayfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -253,7 +253,7 @@ static struct dentry *ovl_clear_empty(st
 
 	unlock_rename(workdir, upperdir);
 	ovl_cleanup_whiteouts(upper, list);
-	mutex_lock(&wdir->i_mutex);
+	mutex_lock_nested(&wdir->i_mutex, I_MUTEX_PARENT);
 	ovl_cleanup(wdir, upper);
 	mutex_unlock(&wdir->i_mutex);
 
