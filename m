Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaAMAUQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 19:20:16 -0500
Received: from smtp.citrix.com ([66.165.176.89]:28510 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaAMAUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:20:14 -0500
X-IronPort-AV: E=Sophos;i="4.95,649,1384300800"; 
   d="scan'208";a="92166428"
Message-ID: <52D33138.4090903@citrix.com>
Date: Mon, 13 Jan 2014 00:20:08 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paul Durrant <Paul.Durrant@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Davies <Jonathan.Davies@citrix.com>
Subject: Re: [PATCH net-next v3 8/9] xen-netback: Timeout packets in RX path
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com> <1389139818-24458-9-git-send-email-zoltan.kiss@citrix.com> <52CDC45D.3050509@citrix.com> <9AAE0902D5BC7E449B7C8E4E778ABCD0200C2A@AMSPEX01CL01.citrite.net>
In-Reply-To: <9AAE0902D5BC7E449B7C8E4E778ABCD0200C2A@AMSPEX01CL01.citrite.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.14.27]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/14 09:20, Paul Durrant wrote:
>> We are adding the skb to vif->rx_queue even when
>> xenvif_rx_ring_slots_available(vif, min_slots_needed) said there is no
>> space for that. Or am I missing something? Paul?
>>
> That's correct. Part of the flow control improvement was to get rid of needless packet drops. For your purposes, you basically need to avoid using the queuing discipline and take packets into netback's vif->rx_queue regardless of the state of the shared ring so that you can drop them if they get beyond a certain age. So, perhaps you should never stop the netif queue, place an upper limit on vif->rx_queue (either packet or byte count) and drop when that is exceeded (i.e. mimicking pfifo or bfifo internally).
>
How about this:
- when the timer fires first we wake up the thread an tell it to drop 
all the packets in rx_queue
- start_xmit then can drain the qdisc queue into the device queue
- additionally, the RX thread should stop that timer when it was able to 
do some work

Regards,

Zoli
