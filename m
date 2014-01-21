Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbaAUFxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:53:51 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:37886 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaAUFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:53:46 -0500
Date: Mon, 20 Jan 2014 21:53:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xishi Qiu <qiuxishi@huawei.com>
cc: robin.yb@huawei.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] fs: don't write pages when receiving a pending SIGKILL
 in __get_user_pages()
In-Reply-To: <52D9D6F2.2030003@huawei.com>
Message-ID: <alpine.DEB.2.02.1401202151500.21729@chino.kir.corp.google.com>
References: <52D9D6F2.2030003@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-2044261302-1390283624=:21729"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-2044261302-1390283624=:21729
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Sat, 18 Jan 2014, Xishi Qiu wrote:

> In the process IO direction, dio_refill_pages will call get_user_pages_fast 
> to map the page from user space. If ret is less than 0 and IO is write, the 
> function will create a zero page to fill data. This may work for some file 
> system, but in some device operate we prefer whole write or fail, not half 
> data half zero, e.g. fs metadata, like inode, identy.

So you're attemping to define a behavior for all users of direct IO for a 
problem that is filesystem or backing device dependent?  Perhaps if you 
elaborated on the problem that you're seeing then we could address it.

> This happens often when kill a process which is doing direct IO. Consider 
> the following cases, the process A is doing IO process, may enter __get_user_pages 
> function, if other processes send process A SIG_KILL, A will enter the 
> following branches 
> 		/*
> 		 * If we have a pending SIGKILL, don't keep faulting
> 		 * pages and potentially allocating memory.
> 		 */
> 		if (unlikely(fatal_signal_pending(current)))
> 			return i ? i : -ERESTARTSYS;
> Return current pages. direct IO will write the pages, the subsequent pages 
> which can’t get will use zero page instead. 
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Signed-off-by: Bin Yang <robin.yb@huawei.com>
> ---
>  fs/direct-io.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 0e04142..b74d565 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -174,6 +174,9 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
>  		&dio->pages[0]);		/* Put results here */
>  
>  	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
> +		/* If task is killed, do not write anymore */
> +		if (ret == -ERESTARTSYS)
> +			goto out;
>  		struct page *page = ZERO_PAGE(0);
>  		/*
>  		 * A memory fault, but the filesystem has some outstanding

We don't mix declarations and text, please try to compile your patches 
before proposing them.
--531381512-2044261302-1390283624=:21729--
