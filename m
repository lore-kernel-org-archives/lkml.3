Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaERXgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 19:36:24 -0400
Received: from ozlabs.org ([103.22.144.67]:49008 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaERXgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 19:36:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        akong@redhat.com, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 1/2] virtio-rng: fix boot with virtio-rng device
In-Reply-To: <1400160104-1888-1-git-send-email-sasha.levin@oracle.com>
References: <1400160104-1888-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 16 May 2014 11:39:35 +0930
Message-ID: <8738galbj4.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:
> Commit "virtio-rng: support multiple virtio-rng devices" has broken
> boot with a virtio-rng device because the 'init' callback of the
> virtio-rng device was left unitialized to garbage, and got called
> by the hwrng infrastructure, killing the guest on boot.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>
> Also, do we really need multiple virtio-rng devices? I know it's
> nice to have, but if there isn't a solid use-case behind it we're
> just adding bugs to working code without any benefit.

Hmm, thanks for this.  It's my fault, I should have gone through this
with a fine-tooth comb once I saw the const change in hwrng.

As Amos pointed out in the commit message, qemu support multiple entropy
sources.  It's a line ball: since you've done the work, I'll apply it
(if you'd just submitted a bug report I'd probably revert the commit).

AFAICT Amos owes you a beer :)

Cheers,
Rusty.
PS: Added Fixes: line.

>  drivers/char/hw_random/virtio-rng.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index 12e242b..5b25daa 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -95,7 +95,7 @@ static int probe_common(struct virtio_device *vdev)
>  	int err, i;
>  	struct virtrng_info *vi = NULL;
>  
> -	vi = kmalloc(sizeof(struct virtrng_info), GFP_KERNEL);
> +	vi = kzalloc(sizeof(struct virtrng_info), GFP_KERNEL);
>  	vi->hwrng.name = kmalloc(40, GFP_KERNEL);
>  	init_completion(&vi->have_data);
>  
> -- 
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
