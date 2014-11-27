Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaK0PjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:39:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:64886 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaK0PjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:39:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,470,1413270000"; 
   d="scan'208";a="644601318"
Message-ID: <1417102739.5858.112.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/6] UBI: Fastmap: Ensure that all fastmap work is done
 upon WL shutdown
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 17:38:59 +0200
In-Reply-To: <1416835236-25185-4-git-send-email-richard@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
	 <1416835236-25185-4-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 14:20 +0100, Richard Weinberger wrote:
> ...otherwise the deferred work might run after datastructures
> got freed and corrupt memory.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/wl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 7f135df..cb2e571 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -2041,6 +2041,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>  void ubi_wl_close(struct ubi_device *ubi)
>  {
>  	dbg_wl("close the WL sub-system");
> +#ifdef CONFIG_MTD_UBI_FASTMAP
> +	flush_work(&ubi->fm_work);
> +#endif

If you are using the work infrastructure implemented in wl.c, then
fastmap work should be no different to any other work. And we do flush
all works in 'shutdown_work()'. The fastmap work should be flushed there
too.

I think we discussed this already - there should be one single queue of
works, managed by the same set of functions, all flushed in the same
place, one-by-one...

Obviously, there is some misunderstanding. This looks like lack of
separation and misuse of layering. I am missing explanations why I am
wrong...

