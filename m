Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3DKLUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:20:55 -0400
Received: from relay.parallels.com ([195.214.232.42]:53960 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab3DKLUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:20:53 -0400
Message-ID: <51669CA6.7000007@parallels.com>
Date: Thu, 11 Apr 2013 15:21:10 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: "miklos@szeredi.hu" <miklos@szeredi.hu>
CC: <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [fuse-devel] [PATCH 0/5] fuse: close file synchronously
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
In-Reply-To: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

Any feedback would be highly appreciated.

Thanks,
Maxim

12/20/2012 04:30 PM, Maxim Patlasov пишет:
> Hi,
>
> There is a long-standing demand for syncronous behaviour of fuse_release:
>
> http://sourceforge.net/mailarchive/message.php?msg_id=19343889
> http://sourceforge.net/mailarchive/message.php?msg_id=29814693
>
> A few months ago Avati and me explained why such a feature would be useful:
>
> http://sourceforge.net/mailarchive/message.php?msg_id=29889055
> http://sourceforge.net/mailarchive/message.php?msg_id=29867423
>
> In short, the problem is that fuse_release (that's called on last user
> close(2)) sends FUSE_RELEASE to userspace and returns without waiting for
> ACK from userspace. Consequently, there is a gap when user regards the
> file released while userspace fuse is still working on it. An attempt to
> access the file from another node leads to complicated synchronization
> problems because the first node still "holds" the file.
>
> The patch-set resolves the problem by making fuse_release synchronous:
> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.
>
> To keep single-threaded userspace implementations happy the patch-set
> ensures that by the time fuse_release_common calls fuse_file_put, no
> more in-flight I/O exists. Asynchronous fuse callbacks (like
> fuse_readpages_end) cannot trigger FUSE_RELEASE anymore. Hence, we'll
> never block in contexts other than close().
>
> Thanks,
> Maxim
>
> ---
>
> Maxim Patlasov (5):
>        fuse: add close_wait flag to fuse_conn
>        fuse: cosmetic rework of fuse_send_readpages
>        fuse: wait for end of IO on release
>        fuse: enable close_wait feature
>        fuse: fix synchronous case of fuse_file_put()
>
>
>   fs/fuse/file.c            |   82 ++++++++++++++++++++++++++++++++++++++-------
>   fs/fuse/fuse_i.h          |    3 ++
>   fs/fuse/inode.c           |    5 ++-
>   include/uapi/linux/fuse.h |    7 +++-
>   4 files changed, 82 insertions(+), 15 deletions(-)
>

