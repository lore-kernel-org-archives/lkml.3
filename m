Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaAUAYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 19:24:40 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:33301 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaAUAYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 19:24:33 -0500
X-IronPort-AV: E=Sophos;i="4.95,693,1384300800"; 
   d="scan'208";a="92642001"
Message-ID: <52DDBE3D.4060406@citrix.com>
Date: Tue, 21 Jan 2014 00:24:29 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v5 8/9] xen-netback: Timeout packets in RX path
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com> <1390253069-25507-9-git-send-email-zoltan.kiss@citrix.com> <20140120220348.GA5058@zion.uk.xensource.com>
In-Reply-To: <20140120220348.GA5058@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.14.33]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/14 22:03, Wei Liu wrote:
> On Mon, Jan 20, 2014 at 09:24:28PM +0000, Zoltan Kiss wrote:
>> @@ -557,12 +577,25 @@ void xenvif_disconnect(struct xenvif *vif)
>>   void xenvif_free(struct xenvif *vif)
>>   {
>>   	int i, unmap_timeout = 0;
>> +	/* Here we want to avoid timeout messages if an skb can be legitimatly
>> +	 * stucked somewhere else. Realisticly this could be an another vif's
>> +	 * internal or QDisc queue. That another vif also has this
>> +	 * rx_drain_timeout_msecs timeout, but the timer only ditches the
>> +	 * internal queue. After that, the QDisc queue can put in worst case
>> +	 * XEN_NETIF_RX_RING_SIZE / MAX_SKB_FRAGS skbs into that another vif's
>> +	 * internal queue, so we need several rounds of such timeouts until we
>> +	 * can be sure that no another vif should have skb's from us. We are
>> +	 * not sending more skb's, so newly stucked packets are not interesting
>> +	 * for us here.
>> +	 */
> You beat me to this. Was about to reply to your other email. :-)
>
> It's also worth mentioning that DIV_ROUND_UP part is merely estimation,
> as you cannot possible know the maximum / miminum queue length of all
> other vifs (as they can be changed during runtime). In practice most
> users will stick with the default, but some advanced users might want to
> tune this value for individual vif (whether that's a good idea or not is
> another topic).
>
> So, in order to convince myself this is safe. I also did some analysis
> on the impact of having queue length other than default value.  If
> queue_len < XENVIF_QUEUE_LENGTH, that means you can queue less packets
> in qdisc than default and drain it faster than calculated, which is
> safe. On the other hand if queue_len > XENVIF_QUEUE_LENGTH, it means
> actually you need more time than calculated. I'm in two minded here. The
> default value seems sensible to me but I'm still a bit worried about the
> queue_len > XENVIF_QUEUE_LENGTH case.
>
> An idea is to book-keep maximum tx queue len among all vifs and use that
> to calculate worst scenario.
I don't think it should be that perfect. This is just a best effort 
estimation, if someone changes the vif queue length and see this message 
because of that, nothing very drastic will happen. It is just a rate 
limited warning message. Well, it is marked as error, because it is a 
serious condition.
And also, the odds of seeing this message unnecessarily are quite low. 
With default settings (256 slots, max 17 per skb, 32 queue length, 10 
secs queue drain timeout) this delay is 20 seconds. You can raise the 
queue length to 64 before getting warning (see netif_napi_add), so it 
would go up to 40 seconds, but anyway, if your vif is sitting on a 
packet more than 20 seconds, you deserve this message :)

Zoli
