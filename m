Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaH0I4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbaH0I4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:56:04 -0400
Date: Wed, 27 Aug 2014 14:25:39 +0530
From: Amit Shah <amit.shah@redhat.com>
To: stable@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Amos Kong <akong@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [3.16 stable PATCH v2 1/2] virtio: rng: delay hwrng_register()
 till driver is ready
Message-ID: <20140827085539.GG13052@grmbl.mre>
References: <e85a877491a10650cd4b14de926707954a91f565.1407830026.git.amit.shah@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e85a877491a10650cd4b14de926707954a91f565.1407830026.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

Can you add these two patches to the 3.16 queue?

Thanks,

On (Tue) 12 Aug 2014 [13:23:45], Amit Shah wrote:
> Instead of calling hwrng_register() in the probe routing, call it in the
> scan routine.  This ensures that when hwrng_register() is successful,
> and it requests a few random bytes to seed the kernel's pool at init,
> we're ready to service that request.
> 
> This will also enable us to remove the workaround added previously to
> check whether probe was completed, and only then ask for data from the
> host.  The revert follows in the next commit.
> 
> There's a slight behaviour change here on unsuccessful hwrng_register().
> Previously, when hwrng_register() failed, the probe() routine would
> fail, and the vqs would be torn down, and driver would be marked not
> initialized.  Now, the vqs will remain initialized, driver would be
> marked initialized as well, but won't be available in the list of RNGs
> available to hwrng core.  To fix the failures, the procedure remains the
> same, i.e. unload and re-load the module, and hope things succeed the
> next time around.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> (cherry picked from commit 5c06273401f2eb7b290cadbae18ee00f8f65e893)
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  drivers/char/hw_random/virtio-rng.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index e9b15bc..f4e04f3 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -36,6 +36,7 @@ struct virtrng_info {
>  	bool busy;
>  	char name[25];
>  	int index;
> +	bool hwrng_register_done;
>  };
>  
>  static bool probe_done;
> @@ -137,15 +138,6 @@ static int probe_common(struct virtio_device *vdev)
>  		return err;
>  	}
>  
> -	err = hwrng_register(&vi->hwrng);
> -	if (err) {
> -		vdev->config->del_vqs(vdev);
> -		vi->vq = NULL;
> -		kfree(vi);
> -		ida_simple_remove(&rng_index_ida, index);
> -		return err;
> -	}
> -
>  	probe_done = true;
>  	return 0;
>  }
> @@ -153,9 +145,11 @@ static int probe_common(struct virtio_device *vdev)
>  static void remove_common(struct virtio_device *vdev)
>  {
>  	struct virtrng_info *vi = vdev->priv;
> +
>  	vdev->config->reset(vdev);
>  	vi->busy = false;
> -	hwrng_unregister(&vi->hwrng);
> +	if (vi->hwrng_register_done)
> +		hwrng_unregister(&vi->hwrng);
>  	vdev->config->del_vqs(vdev);
>  	ida_simple_remove(&rng_index_ida, vi->index);
>  	kfree(vi);
> @@ -171,6 +165,16 @@ static void virtrng_remove(struct virtio_device *vdev)
>  	remove_common(vdev);
>  }
>  
> +static void virtrng_scan(struct virtio_device *vdev)
> +{
> +	struct virtrng_info *vi = vdev->priv;
> +	int err;
> +
> +	err = hwrng_register(&vi->hwrng);
> +	if (!err)
> +		vi->hwrng_register_done = true;
> +}
> +
>  #ifdef CONFIG_PM_SLEEP
>  static int virtrng_freeze(struct virtio_device *vdev)
>  {
> @@ -195,6 +199,7 @@ static struct virtio_driver virtio_rng_driver = {
>  	.id_table =	id_table,
>  	.probe =	virtrng_probe,
>  	.remove =	virtrng_remove,
> +	.scan =		virtrng_scan,
>  #ifdef CONFIG_PM_SLEEP
>  	.freeze =	virtrng_freeze,
>  	.restore =	virtrng_restore,
> -- 
> 1.9.3
> 

		Amit
