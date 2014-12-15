Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaLOTdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:33:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaLOTdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:33:51 -0500
Date: Mon, 15 Dec 2014 11:33:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Support a vmbus API for
 efficiently sending page arrays
Message-ID: <20141215193351.GC9842@kroah.com>
References: <1418675627-15213-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418675627-15213-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 12:33:47PM -0800, K. Y. Srinivasan wrote:
> Currently, the API for sending a multi-page buffer over VMBUS is limited to
> a maximum pfn array of MAX_MULTIPAGE_BUFFER_COUNT. This limitation is
> not imposed by the host and unnecessarily limits the maximum payload
> that can be sent. Implement an API that does not have this restriction.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/channel.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/hyperv.h |   31 +++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index c76ffbe..18c4f23 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -686,6 +686,50 @@ EXPORT_SYMBOL_GPL(vmbus_sendpacket_pagebuffer);
>  /*
>   * vmbus_sendpacket_multipagebuffer - Send a multi-page buffer packet
>   * using a GPADL Direct packet type.
> + * The buffer includes the vmbus descriptor.
> + */
> +int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
> +			      struct vmbus_packet_mpb_array *desc,
> +			      u32 desc_size,
> +			      void *buffer, u32 bufferlen, u64 requestid)
> +{
> +	int ret;
> +	u32 packetlen;
> +	u32 packetlen_aligned;
> +	struct kvec bufferlist[3];
> +	u64 aligned_data = 0;
> +	bool signal = false;
> +
> +	packetlen = desc_size + bufferlen;
> +	packetlen_aligned = ALIGN(packetlen, sizeof(u64));
> +
> +	/* Setup the descriptor */
> +	desc->type = VM_PKT_DATA_USING_GPA_DIRECT;
> +	desc->flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
> +	desc->dataoffset8 = desc_size >> 3; /* in 8-bytes grandularity */
> +	desc->length8 = (u16)(packetlen_aligned >> 3);
> +	desc->transactionid = requestid;
> +	desc->rangecount = 1;
> +
> +	bufferlist[0].iov_base = desc;
> +	bufferlist[0].iov_len = desc_size;
> +	bufferlist[1].iov_base = buffer;
> +	bufferlist[1].iov_len = bufferlen;
> +	bufferlist[2].iov_base = &aligned_data;
> +	bufferlist[2].iov_len = (packetlen_aligned - packetlen);
> +
> +	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3, &signal);
> +
> +	if (ret == 0 && signal)
> +		vmbus_setevent(channel);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vmbus_sendpacket_mpb_desc);
> +
> +/*
> + * vmbus_sendpacket_multipagebuffer - Send a multi-page buffer packet
> + * using a GPADL Direct packet type.
>   */
>  int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
>  				struct hv_multipage_buffer *multi_pagebuffer,
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 08cfaff..8615b0d 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -57,6 +57,18 @@ struct hv_multipage_buffer {
>  	u64 pfn_array[MAX_MULTIPAGE_BUFFER_COUNT];
>  };
>  
> +/*
> + * Multiple-page buffer array; the pfn array is variable size:
> + * The number of entries in the PFN array is determined by
> + * "len" and "offset".
> + */
> +struct hv_mpb_array {
> +	/* Length and Offset determines the # of pfns in the array */
> +	u32 len;
> +	u32 offset;
> +	u64 pfn_array[];
> +};

Does this cross the user/kernel boundry?  If so, they need to be __u32
and __u64 variables.

> +
>  /* 0x18 includes the proprietary packet header */
>  #define MAX_PAGE_BUFFER_PACKET		(0x18 +			\
>  					(sizeof(struct hv_page_buffer) * \
> @@ -812,6 +824,18 @@ struct vmbus_channel_packet_multipage_buffer {
>  	struct hv_multipage_buffer range;
>  } __packed;
>  
> +/* The format must be the same as struct vmdata_gpa_direct */
> +struct vmbus_packet_mpb_array {
> +	u16 type;
> +	u16 dataoffset8;
> +	u16 length8;
> +	u16 flags;
> +	u64 transactionid;
> +	u32 reserved;
> +	u32 rangecount;         /* Always 1 in this case */
> +	struct hv_mpb_array range;
> +} __packed;

Same here.

thanks,

greg k-h
