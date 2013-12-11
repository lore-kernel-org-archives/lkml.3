Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3LKD3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 22:29:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab3LKD3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 22:29:46 -0500
Message-ID: <52A7DC12.80408@redhat.com>
Date: Wed, 11 Dec 2013 11:29:22 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH net V2 2/2] macvtap: signal truncated packets
References: <1386654586-18151-1-git-send-email-jasowang@redhat.com> <1386654586-18151-2-git-send-email-jasowang@redhat.com> <20131210152951.GE25293@redhat.com>
In-Reply-To: <20131210152951.GE25293@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 11:29 PM, Michael S. Tsirkin wrote:
> On Tue, Dec 10, 2013 at 01:49:46PM +0800, Jason Wang wrote:
>> > macvtap_put_user() never return a value grater than iov length, this in fact
>> > bypasses the truncated checking in macvtap_recvmsg(). Fix this by always
>> > returning the size of packet plus the possible vlan header to let the trunca
>> > checking work.
>> > 
>> > Cc: Vlad Yasevich <vyasevich@gmail.com>
>> > Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> > Cc: Michael S. Tsirkin <mst@redhat.com>
>> > Signed-off-by: Jason Wang <jasowang@redhat.com>
>> > ---
>> > Changes from v1:
>> > - increase total unconditionally
>> > - do not move the structure veth out of the vlan handling block
>> > ---
>> >  drivers/net/macvtap.c | 19 ++++++++++---------
>> >  1 file changed, 10 insertions(+), 9 deletions(-)
>> > 
>> > diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>> > index 957cc5c..ded4b2c 100644
>> > --- a/drivers/net/macvtap.c
>> > +++ b/drivers/net/macvtap.c
>> > @@ -770,7 +770,7 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
>> >  	int ret;
>> >  	int vnet_hdr_len = 0;
>> >  	int vlan_offset = 0;
>> > -	int copied;
>> > +	int copied, offset;
>> >  
>> >  	if (q->flags & IFF_VNET_HDR) {
>> >  		struct virtio_net_hdr vnet_hdr;
>> > @@ -785,7 +785,8 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
>> >  		if (memcpy_toiovecend(iv, (void *)&vnet_hdr, 0, sizeof(vnet_hdr)))
>> >  			return -EFAULT;
>> >  	}
>> > -	copied = vnet_hdr_len;
>> > +	offset = copied = vnet_hdr_len;
>> > +	copied += skb->len;
>> >  
>> >  	if (!vlan_tx_tag_present(skb))
>> >  		len = min_t(int, skb->len, len);
>> > @@ -800,24 +801,24 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
>> >  
>> >  		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
>> >  		len = min_t(int, skb->len + VLAN_HLEN, len);
>> > +		copied += VLAN_HLEN;
>> >  
>> >  		copy = min_t(int, vlan_offset, len);
>> > -		ret = skb_copy_datagram_const_iovec(skb, 0, iv, copied, copy);
>> > +		ret = skb_copy_datagram_const_iovec(skb, 0, iv, offset, copy);
>> >  		len -= copy;
>> > -		copied += copy;
>> > +		offset += copy;
>> >  		if (ret || !len)
>> >  			goto done;
>> >  
>> >  		copy = min_t(int, sizeof(veth), len);
>> > -		ret = memcpy_toiovecend(iv, (void *)&veth, copied, copy);
>> > +		ret = memcpy_toiovecend(iv, (void *)&veth, offset, copy);
>> >  		len -= copy;
>> > -		copied += copy;
>> > +		offset += copy;
>> >  		if (ret || !len)
>> >  			goto done;
>> >  	}
>> >  
>> > -	ret = skb_copy_datagram_const_iovec(skb, vlan_offset, iv, copied, len);
>> > -	copied += len;
>> > +	ret = skb_copy_datagram_const_iovec(skb, vlan_offset, iv, offset, len);
>> >  
>> >  done:
>> >  	return ret ? ret : copied;
> I commented on this already. copied is how much we copied,
> so its value is correct.
> You want to name the new one total_len or something along
> these lines and return it.
>

Ok, to be same with tun, I will use "total" in V3.

Thanks
