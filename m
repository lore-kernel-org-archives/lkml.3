Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaHSSDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 14:03:14 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62315 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaHSSDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 14:03:12 -0400
MIME-Version: 1.0
In-Reply-To: <1408453293-17917-1-git-send-email-stefan.bader@canonical.com>
References: <1408453293-17917-1-git-send-email-stefan.bader@canonical.com>
Date: Tue, 19 Aug 2014 11:03:11 -0700
Message-ID: <CACHGV4J8pQM7pt+0NXJL60OJHxMUQu2S9U_DnKFh0BW0=1XpuA@mail.gmail.com>
Subject: Re: [PATCH] bcache: prevent crash on changing writeback_running
From: Slava Pestov <sp@datera.io>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, this is now in our development branch.

On Tue, Aug 19, 2014 at 6:01 AM, Stefan Bader
<stefan.bader@canonical.com> wrote:
> commit a664d0f05a2ec02c8f042db536d84d15d6e19e81
>     bcache: fix crash on shutdown in passthrough mode
>
> added a safeguard in the shutdown case. At least while not being
> attached it is also possible to trigger a kernel bug by writing into
> writeback_running. This change  adds the same check before trying to
> wake up the thread for that case.
>
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  drivers/md/bcache/writeback.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 0a9dab1..073a042 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -63,7 +63,8 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
>
>  static inline void bch_writeback_queue(struct cached_dev *dc)
>  {
> -       wake_up_process(dc->writeback_thread);
> +       if (!IS_ERR_OR_NULL(dc->writeback_thread))
> +               wake_up_process(dc->writeback_thread);
>  }
>
>  static inline void bch_writeback_add(struct cached_dev *dc)
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
