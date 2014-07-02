Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaGBSna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:43:30 -0400
Received: from smtp.citrix.com ([66.165.176.89]:42335 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104AbaGBSn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:43:29 -0400
X-IronPort-AV: E=Sophos;i="5.01,589,1400025600"; 
   d="scan'208";a="149370393"
Message-ID: <53B452CD.7020903@citrix.com>
Date: Wed, 2 Jul 2014 19:43:25 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next] xen-netback: Adding debugfs "io_ring_qX" files
References: <1404160411-23747-1-git-send-email-zoltan.kiss@citrix.com> <1404298567.5562.13.camel@kazak.uk.xensource.com>
In-Reply-To: <1404298567.5562.13.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/14 11:56, Ian Campbell wrote:
> On Mon, 2014-06-30 at 21:33 +0100, Zoltan Kiss wrote:
>> This patch adds debugfs capabilities to netback. There used to be a similar
>> patch floating around for classic kernel, but it used procfs. It is based on a
>> very similar blkback patch.
>> It creates xen-netback/[vifname]/io_ring_q[queueno] files, reading them output
>> various ring variables etc. Writing "kick" into it imitates an interrupt
>> happened, it can be useful to check whether the ring is just stalled due to a
>> missed interrupt.
>
> Shouldn't there be some CONFIG_XEN_DEBUG_FS ifdefs sprinkled around
> here?

Good question! I've checked where else is this used, it is in 
arch/x86/xen, particularly in spinlock.c and p2m.c. The goal there is, 
as far as I see, to make it configurable whether you want debugging in 
fast path. However here in netback it's not fast path.
It would be nice to have this netback debugfs stuff in production 
systems, but if it is tied to this same config option, that wouldn't be 
possible.
So either we don't put it behind a config option, or create a whole new 
one just for this. I don't see the benefit of the latter one, so I would 
prefer keep it like it is now.
>
>> 	if (tx_ring->sring) {
>> +		struct xen_netif_tx_sring *sring = tx_ring->sring;
>> +
>> +		err = snprintf(buf + rv, XEN_NETBACK_DBG_IORING_BUF_SIZE - rv,
>> +			       "TX queue %d: nr_ents %u\n", i,
>> +			       tx_ring->nr_ents);
>> +		if (err >= XEN_NETBACK_DBG_IORING_BUF_SIZE - rv)
>> +			return XEN_NETBACK_DBG_IORING_BUF_SIZE;
>> +		else
>> +			rv += err;
>
> Does debugfs not provide helpers which let this be done in some more
> palatable way?
>
> arch/x86/xen/p2m.c seems to use some useful seq_*/single_* helpers for
> something very similar and it looks much cleaner.
It took some time until I figured it out how to use them, but I've 
changed it for the next version.


>
>> +	if (vif->xenvif_dbg_root)
>
> No IS_ERR check?
>
> And in backend_disconnect/connect too.
Indeed, I fixed that
>
> Ian.
>

