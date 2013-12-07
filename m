Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab3LGC2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 21:28:42 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:59625 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab3LGC2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 21:28:41 -0500
Message-ID: <52A287D6.3020809@gmail.com>
Date: Fri, 06 Dec 2013 21:28:38 -0500
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, zwu.kernel@gmail.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 2/2] tun: update file current position
References: <1386320930-11285-1-git-send-email-zwu.kernel@gmail.com>	<1386320930-11285-2-git-send-email-zwu.kernel@gmail.com> <20131206.124500.1976272290413710707.davem@davemloft.net>
In-Reply-To: <20131206.124500.1976272290413710707.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 12:45 PM, David Miller wrote:
> From: Zhi Yong Wu <zwu.kernel@gmail.com>
> Date: Fri,  6 Dec 2013 17:08:50 +0800
> 
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Also applied and queued up for -stable, thanks.
> 
> I noticed in these two cases that that min_t() adjustment of 'ret'
> seems strange.  I can't understand why it's needed.
> 
> If, for example, tun_do_read() really did read more than 'len'
> bytes:
> 
> 1) That would write past the end of the buffer.
> 
> 2) Writing a different value to the ->ki_pos would mean
>    that ->ki_pos is now inaccurate.
> 
> Unless someone can explain why the min_t() is needed, we should remove
> it.

So, back when that code was added, it was actually possible for the
tun_do_read to return a value larger then user specified length, but
the copy would only be done the length bytes.  This was used to signal
MSG_TRUNC.

Specifically we had the following code in tun_put_user()
      len = min_t(int, skb->len, len);

      skb_copy_datagram_const_iovec(skb, 0, iv, total, len);
      total += skb->len;

This has since changed to:
      len = min_t(int, skb->len, len);
      ...
      skb_copy_datagram_const_iovec(skb, vlan_offset, iv, total, len);
      total += len;

So, no it seems impossible to return a value larger then user specified
length, so MSG_TRUNC will never be set.  It probably makes sense to
signal message truncation, but that seems broken right now.

-vlad

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

