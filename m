Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136AbaD1Ovs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:51:48 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:51178 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaD1Ovq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:51:46 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140415113223.11860.66322.stgit@dhcp-10-30-30-94.sw.ru>
References: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
	<20140415113223.11860.66322.stgit@dhcp-10-30-30-94.sw.ru>
Date: Mon, 28 Apr 2014 16:51:45 +0200
Message-ID: <CAJfpeguUjm3N3AZYW-iPKeCfyW4766N9LagfkWjf3Y+7qNdT7A@mail.gmail.com>
Subject: Re: [PATCH 7/7] fuse: flush ctime in FUSE_FORGET requests
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim,

Thanks for the patches.

On Tue, Apr 15, 2014 at 1:33 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
> Some inode operations (e.g., rename) operate directly on inodes and dentries
> without opened files involved. This means that even though fuse set
> inode->i_ctime and FUSE_I_CTIME_DIRTY properly, a corresponding flush operation
> will never happen (i.e. no fsync or close to call fuse_flush_cmtime()).
>
> The patch solves the problem by passing local ctime to the userspace server
> inside forget requests.

Hmm, I really don't like this.

1) What has forget to do with ctime?  It feels like being forced into
the interface
2) Forget may not be called for a long time after the modification and
it may not be called *at all*, which would result in the loss of the
ctime change after umount.

How about wiring up fuse_flush_cmtime() to be called from
s_op->write_inode() instead?

Updated patchset pushed to

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

Survives some basic testing, but it would be great if you could also
take a look.

Thanks,
Miklos
