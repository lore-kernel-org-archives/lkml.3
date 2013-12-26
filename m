Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab3LZWvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 17:51:48 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51808 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3LZWvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 17:51:46 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1388066937.git.liwang@ubuntukylin.com>
References: <cover.1388066937.git.liwang@ubuntukylin.com>
Date: Thu, 26 Dec 2013 17:51:44 -0500
Message-ID: <CANP1eJFMZrT+GbHhg3gWqsy=whSozEiWmZj-L08EyhD8LcqzeQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Ceph fscache: Fix kernel panic due to a race
From: Milosz Tanski <milosz@adfin.com>
To: Li Wang <liwang@ubuntukylin.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>, Sage Weil <sage@inktank.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li,

I looked at the patchset am I correct that this only happens when we
enable caching in the write path?

- Milosz

On Thu, Dec 26, 2013 at 9:29 AM, Li Wang <liwang@ubuntukylin.com> wrote:
> From: Yunchuan Wen <yunchuanwen@ubuntukylin.com>
>
> The following scripts could easily panic the kernel,
>
> #!/bin/bash
> mount -t ceph -o fsc MONADDR:/ cephfs
> rm -rf cephfs/foo
> dd if=/dev/zero of=cephfs/foo bs=8 count=512
> echo 3 > /proc/sys/vm/drop_caches
> dd if=cephfs/foo of=/dev/null bs=8 count=1024
>
> This is due to when writing a page into fscache, the code will
> assert that the write position does not exceed the
> object->store_limit_l, which is supposed to be equal to inode->i_size.
> However, for current implementation, after file writing, the
> object->store_limit_l is not synchronized with new
> inode->i_size immediately, which introduces a race that if writing
> a new page into fscache, will reach the ASSERT that write position
> has exceeded the object->store_limit_l, and cause kernel panic.
> This patch fixes it.
>
> Yunchuan Wen (3):
>   Ceph fscache: Add an interface to synchronize object store limit
>   Ceph fscache: Update object store limit after writing
>   Ceph fscache: Wait for completion of object initialization
>
>  fs/ceph/cache.c |    1 +
>  fs/ceph/cache.h |   10 ++++++++++
>  fs/ceph/file.c  |    3 +++
>  3 files changed, 14 insertions(+)
>
> --
> 1.7.9.5
>



-- 
Milosz Tanski
CTO
10 East 53rd Street, 37th floor
New York, NY 10022

p: 646-253-9055
e: milosz@adfin.com
