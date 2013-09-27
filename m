Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3I0Cg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:36:26 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49505 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3I0CgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:36:23 -0400
Message-ID: <5244EF17.30905@oracle.com>
Date: Thu, 26 Sep 2013 21:36:07 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Sage Weil <sage@newdream.net>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        majianpeng <majianpeng@gmail.com>, Zach Brown <zab@zabbo.net>
Subject: Re: linux-next: build failure after merge of the ceph tree
References: <20130927113100.5c261c61856e26da4cf8f949@canb.auug.org.au>
In-Reply-To: <20130927113100.5c261c61856e26da4cf8f949@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 08:31 PM, Stephen Rothwell wrote:
> Hi Sage,
> 
> After merging the ceph tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> fs/ceph/file.c: In function 'ceph_sync_direct_write':
> fs/ceph/file.c:545:24: error: 'struct iov_iter' has no member named 'iov'
>    void __user *data = i.iov->iov_base + i.iov_offset;
>                         ^
> fs/ceph/file.c:546:14: error: 'struct iov_iter' has no member named 'iov'
>    u64 len = i.iov->iov_len - i.iov_offset;
>               ^
> 
> This also happened yesterday but was swamped by the other error (now fixed).
> 
> Caused by commit d4ce96db671b ("ceph: Implement writev/pwritev for sync
> operation") interacting with commit f6794d33a5ec ("iov_iter: hide iovec
> details behind ops function pointers") from the aio-direct tree.
> 
> I applied the following merge fix patch (but there may be a better
> solution):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 27 Sep 2013 11:28:05 +1000
> Subject: [PATCH] ceph: fix up for iov_iter changes
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/ceph/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 5cf034e..1216372 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -542,8 +542,8 @@ ceph_sync_direct_write(struct kiocb *iocb, const struct iovec *iov,
>  	iov_iter_init(&i, iov, nr_segs, count, 0);
>  
>  	while (iov_iter_count(&i) > 0) {
> -		void __user *data = i.iov->iov_base + i.iov_offset;
> -		u64 len = i.iov->iov_len - i.iov_offset;
> +		void __user *data = iov_iter_iovec(&i)->iov_base + i.iov_offset;
> +		u64 len = iov_iter_iovec(&i)->iov_len - i.iov_offset;
>  
>  		page_align = (unsigned long)data & ~PAGE_MASK;
>  

iov_iter_iovec(&i) will resolve to iov, so this is a little simpler

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 5cf034e..d9aa924 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -542,8 +542,8 @@ ceph_sync_direct_write(struct kiocb *iocb, const
struct iovec *iov,
 	iov_iter_init(&i, iov, nr_segs, count, 0);

 	while (iov_iter_count(&i) > 0) {
-		void __user *data = i.iov->iov_base + i.iov_offset;
-		u64 len = i.iov->iov_len - i.iov_offset;
+		void __user *data = iov->iov_base + i.iov_offset;
+		u64 len = iov->iov_len - i.iov_offset;

 		page_align = (unsigned long)data & ~PAGE_MASK;

