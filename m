Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbaHGQtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:49:42 -0400
Received: from smtp.citrix.com ([66.165.176.89]:62960 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbaHGQtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:49:41 -0400
X-IronPort-AV: E=Sophos;i="5.01,819,1400025600"; 
   d="scan'208";a="159737494"
Message-ID: <53E3AE21.50109@citrix.com>
Date: Thu, 7 Aug 2014 17:49:37 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <wei.liu2@citrix.com>, <Ian.Campbell@citrix.com>,
        <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next 0/2] xen-netback: Changes around carrier handling
References: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com> <20140805.160748.1185917042908283028.davem@davemloft.net>
In-Reply-To: <20140805.160748.1185917042908283028.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/14 00:07, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Mon, 4 Aug 2014 16:20:56 +0100
>
>> This series starts using carrier off as a way to purge packets when the guest is
>> not able (or willing) to receive them. It is a much faster way to get rid of
>> packets waiting for an overwhelmed guest.
>> The first patch changes current netback code where it relies currently on
>> netif_carrier_ok.
>> The second turns off the carrier if the guest times out on a queue, and only
>> turn it on again if that queue (or queues) resurrects.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>
> Applied, but I have some reservations:
>
> 1) This is starting to bleed what is normally qdisc type policy into the
>     driver.
>
> 2) There are other drivers that could run into this kind of situation and
>     have similar concerns, therefore we should make sure we have a consistent
>     approach that such entities use to handle this problem.
>
> Part of the problem is that netif_carrier_off() only partially mimicks
> the situation.  It expresses the "transmitter is down so packets
> aren't going onto the wire" part, which keeps the watchdog from
> spitting out log messages ever time it fires.  But it doesn't deal
> with packet freeing policy meanwhile, which I guess is the part that
> this patch series is largely trying to address.

David Vrabel pointed out an important question in a reply to the 
previous version of this series: this patch deschedule NAPI if the 
carrier goes down. The backend doesn't receive packets from the guest. 
DavidVr and others said we shouldn't do this, the guest should be able 
to transmit even if it's not able/willing to receive. Other drivers 
doesn't deschedule NAPI at carrier off as well, however the "carrier 
off" information comes from the hardware, not from an untrusted guest 
who is not posting buffers on the receive ring.
I don't have any good argument why I did it the current way, other than 
a hunch that it feels more natural.
David, do you have an opinion on that?

Zoli
