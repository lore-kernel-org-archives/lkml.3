Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaAOOwr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:52:47 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:26929 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaAOOwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:52:45 -0500
X-IronPort-AV: E=Sophos;i="4.95,663,1384300800"; 
   d="scan'208";a="90982437"
Message-ID: <52D6A0B9.2030204@citrix.com>
Date: Wed, 15 Jan 2014 14:52:41 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next] xen-netback: Rework rx_work_todo
References: <1389727719-21439-1-git-send-email-zoltan.kiss@citrix.com> <20140115103707.GI5698@zion.uk.xensource.com> <52D67536.4030106@citrix.com> <20140115144519.GO5698@zion.uk.xensource.com>
In-Reply-To: <20140115144519.GO5698@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/14 14:45, Wei Liu wrote:
>>>> The recent patch to fix receive side flow control (11b57f) solved the spinning
>>>> > >>thread problem, however caused an another one. The receive side can stall, if:
>>>> > >>- xenvif_rx_action sets rx_queue_stopped to false
>>>> > >>- interrupt happens, and sets rx_event to true
>>>> > >>- then xenvif_kthread sets rx_event to false
>>>> > >>
>>> > >
>>> > >If you mean "rx_work_todo" returns false.
>>> > >
>>> > >In this case
>>> > >
>>> > >(!skb_queue_empty(&vif->rx_queue) && !vif->rx_queue_stopped) || vif->rx_event;
>>> > >
>>> > >can still be true, can't it?
>> >Sorry, I should wrote rx_queue_stopped to true
>> >
> In this case, if rx_queue_stopped is true, then we're expecting frontend
> to notify us, right?
>
> rx_queue_stopped is set to true if we cannot make any progress to queue
> packet into the ring. In that situation we can expect frontend will send
> notification to backend after it goes through the backlog in the ring.
> That means rx_event is set to true, and rx_work_todo is true again. So
> the ring is actually not stalled in this case as well. Did I miss
> something?
>

Yes, we expect the guest to notify us, and it does, and we set rx_event 
to true (see second point), but then the thread set it to false (see 
third point). Talking with Paul, another solution could be to set 
rx_event false before calling xenvif_rx_action. But using 
rx_last_skb_slots makes it quicker for the thread to see if it doesn't 
have to do anything.

Zoli
