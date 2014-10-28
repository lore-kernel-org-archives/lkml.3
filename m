Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaJ1Su0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:50:26 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:56535 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbaJ1SuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:50:22 -0400
X-AuditID: cbfec373-b7f236d000000948-ce-544fe56c0e45
Date: Tue, 28 Oct 2014 16:50:15 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Tomas Melin <tomas.melin@iki.fi>
Cc: david@hardeman.nu, james.hogan@imgtec.com, a.seppala@gmail.com,
        bay@hackerdom.ru, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] [media] rc-core: fix protocol_change regression in
 ir_raw_event_register
Message-id: <20141028165015.6a8cb4e9.m.chehab@samsung.com>
In-reply-to: <1414521794-7776-1-git-send-email-tomas.melin@iki.fi>
References: <1414521794-7776-1-git-send-email-tomas.melin@iki.fi>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/hIN2cp/4hBqtXKVts/XaTzeL2PQGL
	i0fWsVu8m/eC2eLyrjlsFj0btrJazF1+ldGB3WPnrLvsHkd2z2X0OHG/i9nj8NeFLB49O88w
	enzeJBfAFsVlk5Kak1mWWqRvl8CVsaGtuGASf8X1D29YGhjX83QxcnBICJhI/FqX3sXICWSK
	SVy4t54NxBYSWMIoseSSbRcjF5DdwCRxcM8BFpAEi4CqxOfOZlYQm03ASOJVYwuYLSKgInH2
	6Fw2kAZmgYmMEjPXXmMESQgLJEn86roINpVXwEpiTs90dhCbU8BJYuP9qewQ2xwl/i/Yzgpx
	kLPE/M/ZEOWCEj8m3wPbyyygJbF5WxMrhC0vsXnNW+YJjAKzkJTNQlI2C0nZAkbmVYyipcXJ
	BcVJ6blGesWJucWleel6yfm5mxghgV68g/HFBqtDjAIcjEo8vBYv/EKEWBPLiitzDzFKcDAr
	ifDueeAfIsSbklhZlVqUH19UmpNafIiRiYNTqoGx6k+zSPt63oB305vP5nJe/WbtcrbAytHG
	vnQGb562CMvrecuvy7GsrNVnTkpV+H5Cd7b99VMxMgry/gs+7VvGVnZc2H7+ao0PhU8Y7895
	7HG7cO2JxPRP/NZf+p/9/rbvW3gIq79w1N4FR/PbN6s8zapLWx2zdsnqcA4OZ2XhPrupVRtL
	ttoqsRRnJBpqMRcVJwIAVw/FV1ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 28 Oct 2014 20:43:14 +0200
Tomas Melin <tomas.melin@iki.fi> escreveu:

> IR receiver using nuvoton-cir and lirc required additional configuration
> steps after upgrade from kernel 3.16 to 3.17-rcX.
> Bisected regression to commit da6e162d6a4607362f8478c715c797d84d449f8b
> ("[media] rc-core: simplify sysfs code").
> 
> The regression comes from adding function change_protocol in
> ir-raw.c. It changes behaviour so that only the protocol enabled by driver's
> map_name will be active after registration. This breaks user space behaviour,
> lirc does not get key press signals anymore.
> 
> Enable lirc protocol by default for ir raw decoders to restore original behaviour.

Yeah, this patch looks ok on my eyes.

Regards,
Mauro

> 
> Signed-off-by: Tomas Melin <tomas.melin@iki.fi>
> ---
>  drivers/media/rc/rc-ir-raw.c |    1 -
>  drivers/media/rc/rc-main.c   |    2 ++
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
> index e8fff2a..b732ac6 100644
> --- a/drivers/media/rc/rc-ir-raw.c
> +++ b/drivers/media/rc/rc-ir-raw.c
> @@ -262,7 +262,6 @@ int ir_raw_event_register(struct rc_dev *dev)
>  		return -ENOMEM;
>  
>  	dev->raw->dev = dev;
> -	dev->enabled_protocols = ~0;
>  	dev->change_protocol = change_protocol;
>  	rc = kfifo_alloc(&dev->raw->kfifo,
>  			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index a7991c7..8d3b74c 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1421,6 +1421,8 @@ int rc_register_device(struct rc_dev *dev)
>  
>  	if (dev->change_protocol) {
>  		u64 rc_type = (1 << rc_map->rc_type);
> +		if (dev->driver_type == RC_DRIVER_IR_RAW)
> +			rc_type |= RC_BIT_LIRC;
>  		rc = dev->change_protocol(dev, &rc_type);
>  		if (rc < 0)
>  			goto out_raw;
