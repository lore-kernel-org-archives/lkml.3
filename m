Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3KCDyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 23:54:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40254 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3KCDyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 23:54:20 -0400
Date: Sun, 3 Nov 2013 03:54:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthias Schniedermeyer <ms@citd.de>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [REVIEW][PATCH 1/4] vfs: Don't allow overwriting mounts in the
 current mount namespace
Message-ID: <20131103035406.GA8537@ZenIV.linux.org.uk>
References: <CALCETrWw=htmgxqq=RQztdJQ-a8c3860vmJh9Ni=Hhs0TkO3YA@mail.gmail.com>
 <20131008161135.GK14242@tucsk.piliscsaba.szeredi.hu>
 <87li23trll.fsf@tw-ebiederman.twitter.com>
 <CAJfpegv+h7xh_2e-X7is9dq1Fp06A0eKwsyWFMPX=azbbDCX5Q@mail.gmail.com>
 <87vc15mjuw.fsf@xmission.com>
 <CAJfpegvF89LzAvNB0h0otv7sKoS3rewZzQKAauQx3P+rCkCcSg@mail.gmail.com>
 <87iox38fkv.fsf@xmission.com>
 <87d2nb8dxy.fsf@xmission.com>
 <87iowyxpci.fsf_-_@xmission.com>
 <87d2n6xpan.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2n6xpan.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 01:16:48PM -0700, Eric W. Biederman wrote:

>  int vfs_rmdir(struct inode *dir, struct dentry *dentry)
>  {
>  	int error = may_delete(dir, dentry, 1);
> @@ -3622,6 +3636,9 @@ retry:
>  		error = -ENOENT;
>  		goto exit3;
>  	}
> +	error = -EBUSY;
> +	if (covered(nd.path.mnt, dentry))
> +		goto exit3;

Ugh...  And it's not racy because of...?  IOW, what's to keep the return
value of covered() from getting obsolete just as it's being calculated,
let alone returned?
