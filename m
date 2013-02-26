Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405Ab3BZXIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:08:00 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:55483
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757745Ab3BZXH6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:07:58 -0500
X-Forefront-Antispam-Report: CIP:157.56.238.53;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0712HT003.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: PS-5(zzbb2dI98dI9371Ic89bh936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h942hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1155h)
Message-ID: <512D4042.7060303@caviumnetworks.com>
Date: Tue, 26 Feb 2013 15:07:46 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: <eunb.song@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "david.daney@cavium.com" <david.daney@cavium.com>
Subject: Re: I2C: Fix i2c fail problem when a process is terminated by a signal
 on octeon in 3.8
References: <EC.72.13994.FE02D215@epcpsbgx4.samsung.com>
In-Reply-To: <EC.72.13994.FE02D215@epcpsbgx4.samsung.com>
Content-Type: text/plain; charset="EUC-KR"
X-Originating-IP: [64.2.3.195]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2013 12:54 PM, ¼ÛÀººÀ wrote:
> I've been debugging the abnormal operation of i2c on octeon.
> If a process is terminated by signal in the middle of i2c operation,
> next i2c read operation which is done by another process was failed.
> So i changed to ignore signal in the middle of i2c operation.
> After that the problem was not reproduced.
> 

This is a known issue.  However I don't think the solution you have is
correct...

> Signed-off-by: EunBong Song <eunb.song@samsung.com 
> <mailto:eunb.song@samsung.com>>
> 
> diff -up drivers/i2c/busses/i2c-octeon.c{.orig,}
> --- drivers/i2c/busses/i2c-octeon.c.orig 2013-02-21 08:09:03.168018843 -0800
> +++ drivers/i2c/busses/i2c-octeon.c 2013-02-21 08:09:38.344018898 -0800
> @@ -183,7 +183,7 @@ static irqreturn_t octeon_i2c_isr(int ir
>    struct octeon_i2c *i2c = dev_id;
> 
>    octeon_i2c_int_disable(i2c);
> - wake_up_interruptible(&i2c->queue);
> + wake_up(&i2c->queue);
> 
>    return IRQ_HANDLED;
>   }
> @@ -206,7 +206,7 @@ static int octeon_i2c_wait(struct octeon
> 
>    octeon_i2c_int_enable(i2c);
> 
> - result = wait_event_interruptible_timeout(i2c->queue,
> + result = wait_event_timeout(i2c->queue,

If the wait is not interruptible, I think you will not be able to 'kill
-9' a userspace process blocked here.

>           octeon_i2c_test_iflg(i2c),
>           i2c->adap.timeout);
> 

The real solution is to move processing of the I2C protocol to a kernel
thread and communicate between the this thread and userspace via a
command queue mechanism, much like the way it is done in the mmc/host
driver infrastructure.

David Daney



