Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbaKMGqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 01:46:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaKMGqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 01:46:07 -0500
Message-ID: <546453A2.8050304@redhat.com>
Date: Thu, 13 Nov 2014 14:45:54 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com, linux-kernel@vger.kernel.org
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio-net: fix buggy features advertised by host
References: <1415857974-23326-1-git-send-email-jasowang@redhat.com> <1415857974-23326-2-git-send-email-jasowang@redhat.com> <54644A4E.7000902@cn.fujitsu.com>
In-Reply-To: <54644A4E.7000902@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2014 02:06 PM, Wanlong Gao wrote:
> On 11/13/2014 01:52 PM, Jason Wang wrote:
>> This patch tries to detect the possible buggy features advertised by host
>> and fix them. One example is booting virtio-net with only ctrl_vq disabled,
>> qemu may still advertise many features which depends on it. This will
>> trigger several BUG()s in virtnet_send_command().
>>
>> This patch utilizes the fix_features() method, and disables all features that
>> depends on ctrl_vq if it was not advertised.
>>
>> This fixes the crash when booting with ctrl_vq=off.
>>
>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>> Changes from V1:
>> - fix the cut-and-paste error
>> ---
>>  drivers/net/virtio_net.c | 35 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index ec2a8b4..6ce125e 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1948,6 +1948,40 @@ static int virtnet_restore(struct virtio_device *vdev)
>>  }
>>  #endif
>>  
>> +static void virtnet_fix_features(struct virtio_device *dev)
>> +{
>> +	if (!virtio_has_feature(dev, VIRTIO_NET_F_CTRL_VQ)) {
>> +		if (virtio_has_feature(dev, VIRTIO_NET_F_CTRL_RX)) {
>> +			pr_warning("Disable VIRTIO_NET_F_CTRL_RX since host "
>> +				   "does not advertise VIRTIO_NET_F_CTRL_VQ");
>> +			virtio_disable_feature(dev, VIRTIO_NET_F_CTRL_RX);
>> +		}
>> +		if (virtio_has_feature(dev, VIRTIO_NET_F_CTRL_VLAN)) {
>> +			pr_warning("Disable VIRTIO_NET_F_CTRL_VLAN since host "
>> +				   "does not advertise VIRTIO_NET_F_CTRL_VQ");
>> +			virtio_disable_feature(dev, VIRTIO_NET_F_CTRL_VLAN);
>> +		}
>> +		if (virtio_has_feature(dev, VIRTIO_NET_F_GUEST_ANNOUNCE)) {
>> +			pr_warning("Disable VIRTIO_NET_F_GUEST_ANNOUNCE since "
>> +				   "host does not advertise "
>> +				   "VIRTIO_NET_F_CTRL_VQ");
>> +			virtio_disable_feature(dev,
>> +					       VIRTIO_NET_F_GUEST_ANNOUNCE);
>> +		}
>> +		if (virtio_has_feature(dev, VIRTIO_NET_F_MQ)) {
>> +			pr_warning("Disable VIRTIO_NET_F_MQ since host "
>> +				   "does not advertise VIRTIO_NET_F_CTRL_VQ");
>> +			virtio_disable_feature(dev, VIRTIO_NET_F_MQ);
>> +		}
>> +		if (virtio_has_feature(dev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
>> +			pr_warning("Disable VIRTIO_NET_F_CTRL_MAC_ADDR since "
>> +				   "host does not advertise "
>> +				   "VIRTIO_NET_F_CTRL_VQ");
>> +			virtio_disable_feature(dev, VIRTIO_NET_F_CTRL_MAC_ADDR);
>> +		}
>
> Can we use a feature array and check with one loop?  The current check looks so dup?
>
>
> Thanks,
> Wanlong Gao
>

Yes for sure. I will wait a little bit for the maintainers comment and
do it in next version.

Thanks
