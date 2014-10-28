Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaJ1Thq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:37:46 -0400
Received: from vader.hardeman.nu ([95.142.160.32]:37730 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbaJ1Thp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:37:45 -0400
Date: Tue, 28 Oct 2014 20:37:43 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Tomas Melin <tomas.melin@iki.fi>
Cc: m.chehab@samsung.com, james.hogan@imgtec.com, a.seppala@gmail.com,
        bay@hackerdom.ru, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] [media] rc-core: fix protocol_change regression in
 ir_raw_event_register
Message-ID: <20141028193743.GC15486@hardeman.nu>
Mail-Followup-To: Tomas Melin <tomas.melin@iki.fi>, m.chehab@samsung.com,
	james.hogan@imgtec.com, a.seppala@gmail.com, bay@hackerdom.ru,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1414521794-7776-1-git-send-email-tomas.melin@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414521794-7776-1-git-send-email-tomas.melin@iki.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 08:43:14PM +0200, Tomas Melin wrote:
>IR receiver using nuvoton-cir and lirc required additional configuration
>steps after upgrade from kernel 3.16 to 3.17-rcX.
>Bisected regression to commit da6e162d6a4607362f8478c715c797d84d449f8b
>("[media] rc-core: simplify sysfs code").
>
>The regression comes from adding function change_protocol in
>ir-raw.c. It changes behaviour so that only the protocol enabled by driver's
>map_name will be active after registration. This breaks user space behaviour,
>lirc does not get key press signals anymore.
>
>Enable lirc protocol by default for ir raw decoders to restore original behaviour.
>
>Signed-off-by: Tomas Melin <tomas.melin@iki.fi>

Acked-by: David Härdeman <david@hardeman.nu>

>---
> drivers/media/rc/rc-ir-raw.c |    1 -
> drivers/media/rc/rc-main.c   |    2 ++
> 2 files changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
>index e8fff2a..b732ac6 100644
>--- a/drivers/media/rc/rc-ir-raw.c
>+++ b/drivers/media/rc/rc-ir-raw.c
>@@ -262,7 +262,6 @@ int ir_raw_event_register(struct rc_dev *dev)
> 		return -ENOMEM;
> 
> 	dev->raw->dev = dev;
>-	dev->enabled_protocols = ~0;
> 	dev->change_protocol = change_protocol;
> 	rc = kfifo_alloc(&dev->raw->kfifo,
> 			 sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE,
>diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>index a7991c7..8d3b74c 100644
>--- a/drivers/media/rc/rc-main.c
>+++ b/drivers/media/rc/rc-main.c
>@@ -1421,6 +1421,8 @@ int rc_register_device(struct rc_dev *dev)
> 
> 	if (dev->change_protocol) {
> 		u64 rc_type = (1 << rc_map->rc_type);
>+		if (dev->driver_type == RC_DRIVER_IR_RAW)
>+			rc_type |= RC_BIT_LIRC;
> 		rc = dev->change_protocol(dev, &rc_type);
> 		if (rc < 0)
> 			goto out_raw;
>-- 
>1.7.10.4
>

-- 
David Härdeman
