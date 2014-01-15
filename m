Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaAOLrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:47:08 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:59864 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaAOLrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:47:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,662,1384300800"; 
   d="scan'208";a="90925050"
Message-ID: <52D67536.4030106@citrix.com>
Date: Wed, 15 Jan 2014 11:47:02 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next] xen-netback: Rework rx_work_todo
References: <1389727719-21439-1-git-send-email-zoltan.kiss@citrix.com> <20140115103707.GI5698@zion.uk.xensource.com>
In-Reply-To: <20140115103707.GI5698@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/14 10:37, Wei Liu wrote:
> On Tue, Jan 14, 2014 at 07:28:39PM +0000, Zoltan Kiss wrote:
>> The recent patch to fix receive side flow control (11b57f) solved the spinning
>> thread problem, however caused an another one. The receive side can stall, if:
>> - xenvif_rx_action sets rx_queue_stopped to false
>> - interrupt happens, and sets rx_event to true
>> - then xenvif_kthread sets rx_event to false
>>
>
> If you mean "rx_work_todo" returns false.
>
> In this case
>
> (!skb_queue_empty(&vif->rx_queue) && !vif->rx_queue_stopped) || vif->rx_event;
>
> can still be true, can't it?
Sorry, I should wrote rx_queue_stopped to true

>
>> Also, through rx_event a malicious guest can force the RX thread to spin. This
>> patch ditch that two variable, and rework rx_work_todo. If the thread finds it
>
> This seems to be a bigger problem. Can you elaborate?
My mistake too. I forgot that rx_action set it to false, so it's not 
really a spinning. However the thread should still run xenvif_rx_action 
to figure out there is no space in the ring before it sets rx_event to 
false. In my patch we can quit earlier.

Zoli
