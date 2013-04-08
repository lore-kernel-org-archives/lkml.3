Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936288Ab3DHW5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:57:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33014 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763222Ab3DHW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:57:19 -0400
Date: Mon, 8 Apr 2013 23:57:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Nathan Zimmer <nzimmer@sgi.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: hangs on boot in 9984d7394618df9
Message-ID: <20130408225715.GX4068@ZenIV.linux.org.uk>
References: <20130405173623.GE4068@ZenIV.linux.org.uk>
 <515F3A71.9080008@sgi.com>
 <20130405210042.GH4068@ZenIV.linux.org.uk>
 <5162E36F.5020305@sgi.com>
 <20130408155847.GS4068@ZenIV.linux.org.uk>
 <51632DF8.2080402@sgi.com>
 <20130408212327.GU4068@ZenIV.linux.org.uk>
 <20130408214834.GV4068@ZenIV.linux.org.uk>
 <516341ED.5060803@wwwdotorg.org>
 <20130408224637.GW4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408224637.GW4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:46:37PM +0100, Al Viro wrote:

> Very interesting...  Just in case, could you try this on top of that
> branch and see if it triggers?
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 8ce279b..b6cd51b 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -1022,6 +1022,11 @@ static int fifo_open(struct inode *inode, struct file *filp)
>  	/* We can only do regular read/write on fifos */
>  	filp->f_mode &= (FMODE_READ | FMODE_WRITE);
>  
> +	if (inode->i_sb->s_magic == PIPEFS_MAGIC) {
> +		WARN_ON(filp->f_flags & O_NONBLOCK);
> +		filp->f_flags &= ~O_NONBLOCK;
> +	}

*d'oh*

OK, I'm an idiot.  I see what's going on now...  Give me a few and I'll push
a fix.
