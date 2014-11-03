Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaKCKfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:35:38 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:54198 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaKCKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:35:30 -0500
MIME-Version: 1.0
In-Reply-To: <54563DCB.2010103@users.sourceforge.net>
References: <5307CAA2.8060406@users.sourceforge.net>
	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
	<530A086E.8010901@users.sourceforge.net>
	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
	<530A72AA.3000601@users.sourceforge.net>
	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
	<530B5FB6.6010207@users.sourceforge.net>
	<alpine.DEB.2.10.1402241710370.2074@hadrien>
	<530C5E18.1020800@users.sourceforge.net>
	<alpine.DEB.2.10.1402251014170.2080@hadrien>
	<530CD2C4.4050903@users.sourceforge.net>
	<alpine.DEB.2.10.1402251840450.7035@hadrien>
	<530CF8FF.8080600@users.sourceforge.net>
	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
	<530DD06F.4090703@users.sourceforge.net>
	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
	<5317A59D.4@users.sourceforge.net>
	<54563DCB.2010103@users.sourceforge.net>
Date: Mon, 3 Nov 2014 14:35:28 +0400
Message-ID: <CALFYKtAJG5W9-BAHrqEcC-FfqdJERCqkBADo4yTUyjzb+wCHnQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] ceph: Deletion of unnecessary checks before two
 function calls
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Sage Weil <sage@inktank.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>, "Yan, Zheng" <zyan@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2014 at 5:20 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> The functions ceph_put_snap_context() and iput() test whether their argument
> is NULL and then return immediately. Thus the test around the call
> is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/ceph/caps.c       | 3 +--
>  fs/ceph/mds_client.c | 6 ++----
>  fs/ceph/snap.c       | 9 +++------
>  3 files changed, 6 insertions(+), 12 deletions(-)

[CC'ed Zheng]

Applied, but see below.

>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 6d1cd45..7d99fc8 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3136,8 +3136,7 @@ flush_cap_releases:
>  done:
>         mutex_unlock(&session->s_mutex);
>  done_unlocked:
> -       if (inode)
> -               iput(inode);
> +       iput(inode);
>         return;
>
>  bad:
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index bad07c0..3b0ab05 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -523,8 +523,7 @@ void ceph_mdsc_release_request(struct kref *kref)
>         }
>         if (req->r_locked_dir)
>                 ceph_put_cap_refs(ceph_inode(req->r_locked_dir), CEPH_CAP_PIN);
> -       if (req->r_target_inode)
> -               iput(req->r_target_inode);
> +       iput(req->r_target_inode);
>         if (req->r_dentry)
>                 dput(req->r_dentry);

dput() also checks for NULL argument, but the check is wrapped into
unlikely(), which is why I presume it wasn't picked up.  It would be
great if you could improve your coccinelle script to handle
{un,}likely() as well.

>         if (req->r_old_dentry)
> @@ -995,8 +994,7 @@ out:
>         session->s_cap_iterator = NULL;
>         spin_unlock(&session->s_cap_lock);
>
> -       if (last_inode)
> -               iput(last_inode);
> +       iput(last_inode);
>         if (old_cap)
>                 ceph_put_cap(session->s_mdsc, old_cap);
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index f01645a..c1cc993 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -365,8 +365,7 @@ static int build_snap_context(struct ceph_snap_realm *realm)
>              realm->ino, realm, snapc, snapc->seq,
>              (unsigned int) snapc->num_snaps);
>
> -       if (realm->cached_context)
> -               ceph_put_snap_context(realm->cached_context);
> +       ceph_put_snap_context(realm->cached_context);
>         realm->cached_context = snapc;
>         return 0;
>
> @@ -590,15 +589,13 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm
> *realm)

The patch was corrupted, that should have been a single line.  I fixed
it up but you may want to look into your email client settings.

Thanks,

                Ilya
