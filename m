Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbaG2W0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:26:01 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:50132 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaG2WZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:25:59 -0400
Date: Tue, 29 Jul 2014 18:25:57 -0400 (EDT)
From: Abhijith Das <adas@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Message-ID: <584806381.15003446.1406672757956.JavaMail.zimbra@redhat.com>
In-Reply-To: <20140729145808.79bec165@lwn.net>
References: <1406309888-10749-1-git-send-email-adas@redhat.com> <1406309888-10749-6-git-send-email-adas@redhat.com> <20140729145808.79bec165@lwn.net>
Subject: Re: [RFC PATCH 5/5] gfs2: Add xreaddir file operation and
 supporting functions
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - GC36 (Linux)/8.0.6_GA_5922)
Thread-Topic: gfs2: Add xreaddir file operation and supporting functions
Thread-Index: PtVJMDfmQX/ndhLpw1i4Jh40m0Uy1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Jonathan Corbet" <corbet@lwn.net>
> To: "Abhi Das" <adas@redhat.com>
> Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com
> Sent: Tuesday, July 29, 2014 1:58:08 PM
> Subject: Re: [RFC PATCH 5/5] gfs2: Add xreaddir file operation and supporting functions
> 
> On Fri, 25 Jul 2014 12:38:08 -0500
> Abhi Das <adas@redhat.com> wrote:
> 
> > This patch adds support in GFS2 for the xgetdents syscall by
> > implementing the xreaddir file operation.
> 
> So I was trying to make sense of this, and ran into one little thing that
> jumped out at me:
> 
> > +static int gfs2_xrdir_to_user_vars(struct gfs2_xrdir_ctx *xc,
> > +				   struct gfs2_xdirent *x,
> > +				   struct gfs2_xdirent *x_vb_p,
> > +				   struct linux_xdirent __user *lxd,
> > +				   size_t count, size_t *bytes)
> 
> Now, I'll readily admit that I could be overly confused by this function.
> When the variables are named "x", "xx", "xc", "x_vb_p", "xblob", and "lxd",
> it all starts to run together.  But still...
> 

As I went along writing this patch, I ended up needing more structs and names and this is
the ugly result :(. I guess some of these structs/names can be reviewed and changed as
needed. This is just a proof of concept patch to illustrate how such a syscall can be
implemented.

> > +	if ((xc->xc_xattr_mask & XSTAT_XATTR_ALL) &&
> > +		lxd->xd_blob.xb_xattr_count) {
> 
> How can that be right?  lxd is __user, it doesn't seem right to be
> dereferencing it directly...?

Wouldn't the call to access_ok() at the start of the syscall take care of this? All the
__user pointers point to areas within the user supplied buffer buf and overflow past the
end of the buffer for the last lxd is checked for.

The 2/5 patch in this series adds the following in fs/readdir.c:

+SYSCALL_DEFINE5(xgetdents, unsigned int, fd, unsigned, flags, unsigned int, mask, 
+               void __user *, buf, unsigned int, count)
...
...
...
+       if (!access_ok(VERIFY_WRITE, buf, count))
+               return -EFAULT;

> 
> Thanks,
> 
> jon
> 

Cheers!
--Abhi
