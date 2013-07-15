Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3GOVBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:01:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3GOVBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:01:36 -0400
Date: Mon, 15 Jul 2013 14:01:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RESEND] The initmpfs patches.
Message-Id: <20130715140135.0f896a584fec9f7861049b64@linux-foundation.org>
In-Reply-To: <1373421999.27613.37@driftwood>
References: <1373421999.27613.37@driftwood>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Jul 2013 21:06:39 -0500 Rob Landley <rob@landley.net> wrote:

> Attached, so you don't have to fish them out of:
> 
>    http://lkml.indiana.edu/hypermail/linux/kernel/1306.3/04204.html

Too hard.  Especially when I want to reply to a patch.  Please resend
as a patch series in the time-honoured fashion?

> --- a/fs/ramfs/inode.c
> +++ b/fs/ramfs/inode.c
> @@ -247,7 +247,14 @@ struct dentry *ramfs_mount(struct file_system_type *fs_type,
>  static struct dentry *rootfs_mount(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data)
>  {
> -	return mount_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super);
> +	static int once;
> +
> +	if (once)
> +		return ERR_PTR(-ENODEV);
> +	else
> +		once++;
> +
> +	return mount_nodev(fs_type, flags, data, ramfs_fill_super);
>  }

The patches do this in a couple of places.  The treatment of `once' is
obviously racy.  Probably it is unlikely to matter in these contexts,
but it does set a poor example.  And it's so trivially fixed with, for
example, test_and_set_bit() that I do think it's worth that change.


