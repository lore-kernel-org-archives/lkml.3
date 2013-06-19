Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab3FSG6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:58:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33502 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933863Ab3FSG6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
References: <20130619153225.9ff68f0984bfa54333c4df10@canb.auug.org.au>
Date: Wed, 19 Jun 2013 14:58:39 +0800
Message-ID: <CACVXFVMhVs7Wy1A=TfczYzHLFwyRPhEGW9Yo9hTERekaxSnpdQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 driver-core.current tree
From: Ming Lei <ming.lei@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 1:32 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Greg,
>
> Today's linux-next merge of the driver-core tree got a conflict in
> drivers/base/firmware_class.c between commit 875979368eb4 ("firmware
> loader: fix use-after-free by double abort") from the driver-core.current
> tree and commit fe304143b0c3 ("firmware: Avoid deadlock of usermodehelper
> lock at shutdown") from the driver-core tree.
>
> I fixed it up (more may be required - see below) and can carry the fix as
> necessary (no action is required).
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/base/firmware_class.c
> index 01e2103,6ede229..0000000
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@@ -446,22 -452,11 +452,18 @@@ static struct firmware_priv *to_firmwar
>         return container_of(dev, struct firmware_priv, dev);
>   }
>
> - static void fw_load_abort(struct firmware_priv *fw_priv)
> + static void fw_load_abort(struct firmware_buf *buf)
>   {
> -       struct firmware_buf *buf = fw_priv->buf;
> -
>  +      /*
>  +       * There is a small window in which user can write to 'loading'
>  +       * between loading done and disappearance of 'loading'
>  +       */
>  +      if (test_bit(FW_STATUS_DONE, &buf->status))
>  +              return;
>  +
> +       list_del_init(&buf->pending_list);
>         set_bit(FW_STATUS_ABORT, &buf->status);
>         complete_all(&buf->completion);
> -
> -       /* avoid user action after loading abort */
> -       fw_priv->buf = NULL;

Hmm, maybe the most important part in the commit 875979368eb4
("firmware loader: fix use-after-free by double abort") has been removed, :-)

In fact, the commit 87597936 is for linus tree only because it is a fix,
so the conflict is caused by merging it with other firmware loader patches
in -next tree.

Greg, I can figure out one patch for -next easily, but it depends you
push it on 3.10-rc or 3.11-rc.


Thanks,
--
Ming Lei
