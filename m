Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3IQSOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:14:41 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:65372 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3IQSOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:14:40 -0400
Message-ID: <52389C0D.7070307@cogentembedded.com>
Date: Tue, 17 Sep 2013 22:14:37 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: linux-kernel@vger.kernel.org, Dan Aloni <alonid@stratoscale.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, nab@linux-iscsi.org,
        Asias He <asias@redhat.com>
Subject: Re: [PATCH] vhost/scsi: use vmalloc for order-10 allocation
References: <1379401998-5131-1-git-send-email-mst@redhat.com>
In-Reply-To: <1379401998-5131-1-git-send-email-mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/17/2013 11:21 AM, Michael S. Tsirkin wrote:

> As vhost scsi device struct is large, if the device is
> created on a busy system, kzalloc() might fail, so this patch does a
> fallback to vzalloc().

> As vmalloc() adds overhead on data-path, add __GFP_REPEAT
> to kzalloc() flags to do this fallback only when really needed.

> Reported-by: Dan Aloni <alonid@stratoscale.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

> I put this on my vhost fixes branch, intend to merge for 3.12.
> Dan, could you please confirm this works for you?

>   drivers/vhost/scsi.c | 41 +++++++++++++++++++++++++++--------------
>   1 file changed, 27 insertions(+), 14 deletions(-)

> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 4b79a1f..2c30bb0 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1373,21 +1373,30 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
>   	return 0;
>   }
>
> +static void vhost_scsi_free(struct vhost_scsi *vs)
> +{
> +        if (is_vmalloc_addr(vs))
> +                vfree(vs);
> +        else
> +                kfree(vs);

    Indent with the tabs ISO spaces, please.

> +}
> +
>   static int vhost_scsi_open(struct inode *inode, struct file *f)
>   {
>   	struct vhost_scsi *vs;
>   	struct vhost_virtqueue **vqs;
> -	int r, i;
> +	int r = -ENOMEM, i;
>
> -	vs = kzalloc(sizeof(*vs), GFP_KERNEL);
> -	if (!vs)
> -		return -ENOMEM;
> +        vs = kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_REPEAT);

    Indent here with a tab, please.

> +	if (!vs) {
> +		vs = vzalloc(sizeof(*vs));
> +		if (!vs)
> +			goto err_vs;
> +	}

WBR, Sergei

