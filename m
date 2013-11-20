Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3KTSHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:07:00 -0500
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:56960 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998Ab3KTSG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:06:58 -0500
X-Greylist: delayed 697 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 13:06:58 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=UKm+Gfhny59ZZW7V6sk1nt3TG+K+SSq392izOhRJXBFgGBCO9VR0bufVC70+6fW1;
  h=Received:From:To:Cc:References:In-Reply-To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer:Thread-Index:Content-Language:X-ELNK-Trace:X-Originating-IP;
From: "Frank Filz" <ffilzlnx@mindspring.com>
To: "'Jeff Layton'" <jlayton@redhat.com>, <linux-fsdevel@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <nfs-ganesha-devel@lists.sourceforge.net>,
        <samba-technical@lists.samba.org>
References: <1384965906-27327-1-git-send-email-jlayton@redhat.com> <1384965906-27327-6-git-send-email-jlayton@redhat.com>
In-Reply-To: <1384965906-27327-6-git-send-email-jlayton@redhat.com>
Subject: RE: [RFC PATCH v2 5/5] locks: report l_pid as -1 for FL_FILP_PRIVATE locks
Date: Wed, 20 Nov 2013 09:55:18 -0800
Message-ID: <0d1101cee619$ad866500$08932f00$@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQHlugm2INdiPnZSZTPL4xrfW02UgAJKrwdFme5pBIA=
Content-Language: en-us
X-ELNK-Trace: 136157f01908a8929c7f779228e2f6aeda0071232e20db4d24e0f1495a6cee8c4f268a5e97554bfa350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 71.236.153.111
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FL_FILP_PRIVATE locks are no longer tied to a particular PID, and are
instead
> inheritable by child processes. Report a l_pid of '-1' for these sorts of
locks
> since the pid is somewhat meaningless for them.

Hmm, I suppose in the case of a process that acquires a private lock, forks
(passing the lock to the child process) and then exits, pid would be
meaningless, but I wonder how common that case is compared to a
multi-threaded process (especially a file server) that will hold many
private locks, and not pass them to child processes (and exit)?

I.e. as a future user of this feature, I wonder if I'm going to want to know
that THESE private locks are owned by Ganesha and THOSE are owned by Samba?

Frank

> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/locks.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index d5fb853..8a4d4e4 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1889,7 +1889,7 @@ EXPORT_SYMBOL_GPL(vfs_test_lock);
> 
>  static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
{
> -	flock->l_pid = fl->fl_pid;
> +	flock->l_pid = IS_FILP_PVT(fl) ? -1 : fl->fl_pid;
>  #if BITS_PER_LONG == 32
>  	/*
>  	 * Make sure we can represent the posix lock via @@ -1911,7 +1911,7
> @@ static int posix_lock_to_flock(struct flock *flock, struct file_lock
*fl)  #if
> BITS_PER_LONG == 32  static void posix_lock_to_flock64(struct flock64
> *flock, struct file_lock *fl)  {
> -	flock->l_pid = fl->fl_pid;
> +	flock->l_pid = IS_FILP_PVT(fl) ? -1 : fl->fl_pid;
>  	flock->l_start = fl->fl_start;
>  	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
>  		fl->fl_end - fl->fl_start + 1;
> --
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel"
in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

