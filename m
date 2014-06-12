Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317AbaFLQ4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:56:41 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:65070 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaFLQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:56:39 -0400
Message-ID: <5399DBC2.6070004@redhat.com>
Date: Thu, 12 Jun 2014 18:56:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
CC: netdev@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] vhost-scsi: don't open-code kvfree
References: <1402588896-25446-1-git-send-email-mst@redhat.com>
In-Reply-To: <1402588896-25446-1-git-send-email-mst@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/06/2014 18:02, Michael S. Tsirkin ha scritto:
> Now that we have kvfree, use it in vhost-scsi instead of
> the open-coded version.
>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> I have this queued for -rc2.
> Nicholas could you review ack pls?
>
>  drivers/vhost/scsi.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 83b834b..b08863e 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1396,14 +1396,6 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
>  	return 0;
>  }
>
> -static void vhost_scsi_free(struct vhost_scsi *vs)
> -{
> -	if (is_vmalloc_addr(vs))
> -		vfree(vs);
> -	else
> -		kfree(vs);
> -}
> -
>  static int vhost_scsi_open(struct inode *inode, struct file *f)
>  {
>  	struct vhost_scsi *vs;
> @@ -1443,7 +1435,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>  	return 0;
>
>  err_vqs:
> -	vhost_scsi_free(vs);
> +	kvfree(vs);
>  err_vs:
>  	return r;
>  }
> @@ -1462,7 +1454,7 @@ static int vhost_scsi_release(struct inode *inode, struct file *f)
>  	/* Jobs can re-queue themselves in evt kick handler. Do extra flush. */
>  	vhost_scsi_flush(vs);
>  	kfree(vs->dev.vqs);
> -	vhost_scsi_free(vs);
> +	kvfree(vs);
>  	return 0;
>  }
>
>

You didn't CC Nicholas. :)  Anyway,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
