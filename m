Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaKTHNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:13:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbaKTHNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:13:35 -0500
Message-ID: <546D948C.7020105@redhat.com>
Date: Thu, 20 Nov 2014 15:13:16 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH net V3] virtio-net: validate features during probe
References: <1416463835-7364-1-git-send-email-jasowang@redhat.com> <20141120070244.GE30994@redhat.com>
In-Reply-To: <20141120070244.GE30994@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2014 03:02 PM, Michael S. Tsirkin wrote:
> On Thu, Nov 20, 2014 at 02:10:35PM +0800, Jason Wang wrote:
>> We currently trigger BUG when VIRTIO_NET_F_CTRL_VQ
>> is not set but one of features depending on it is.
>> That's not a friendly way to report errors to
>> hypervisors.
>> Let's check, and fail probe instead.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
>> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> Looks good, minor nits below:
>
>> ---
>> Changes from V2:
>> - only check the features for ctrl vq (this fix the real bug)
>> - better error message and simplify API
>> ---
>>  drivers/net/virtio_net.c | 37 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 37 insertions(+)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index ec2a8b4..a6bcfce 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1673,6 +1673,40 @@ static const struct attribute_group virtio_net_mrg_rx_group = {
>>  };
>>  #endif
>>  
>> +static bool virtnet_fail_on_feature(struct virtio_device *vdev,
>> +				    unsigned int fbit,
>> +				    const char *fname, const char *dname)
>> +{
>> +	if (!virtio_has_feature(vdev, fbit))
>> +		return false;
>> +
>> +	dev_err(&vdev->dev, "Hypervisor bug: advertise feature %s but not %s",
> Well we don't know it's a hypervisor. How about:
> Device bug: advertises feature %s but not %s.

Ok.
>> +		fname, dname);
>> +
>> +	return true;
>> +}
>> +
>> +#define VIRTNET_FAIL_ON(vdev, fbit, dbit)			\
>> +	virtnet_fail_on_feature(vdev, fbit, #fbit, #dbit)
> I would pass dbit directly, and supply a string from caller,
> instead if #dbit, this way it can be any string.

Right, this is better.
>> +
>> +static bool virtnet_validate_features(struct virtio_device *vdev)
>> +{
>> +	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ) &&
>> +	    (VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_RX,
>> +			     VIRTIO_NET_F_CTRL_VQ) ||
>> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_CTRL_VLAN,
>> +			     VIRTIO_NET_F_CTRL_VQ) ||
>> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_GUEST_ANNOUNCE,
>> +			     VIRTIO_NET_F_TRL_VQ) ||
> Typo: VIRTIO_NET_F_CTRL_VQ.
>
>

Wil fix this and post V4.

Thanks

