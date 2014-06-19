Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaFSMeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:34:14 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47477 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaFSMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:34:13 -0400
MIME-Version: 1.0
Date: Thu, 19 Jun 2014 20:34:12 +0800
Message-ID: <CAK=oMXftjqjoM2gCrgyc+YkznCOz-V=McEx74xPbxZ2O-UFmFQ@mail.gmail.com>
Subject: [Question] is it a race condition in acking PMIC sub-interrupt?
From: Yi Zhang <yizhang.mrvl@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Yi Zhang <yizhang@marvell.com>,
        zhangwm@marvell.com, shayp@marvell.com, zhouqiao@marvell.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark:

Sorry to trouble you, I met a question related the interrupt ack
sequence in regmap framework; could you please share your advice on
this? thank you very much;

1) the following is the connection related to PMIC on my development board:

     PMIC ---> GPIO --> GIC

     the GPIO is edge triggered interrupt controller, while GIC is
level triggered;
2)  there are several interrupt ack registers in PMIC; in
regmap_irq_thread(), we acked them one by one; but if before we finish
acking all the registers, another interrupt on the "has-been-acked
register" is triggered, the interrupt line will be pulled up or down,
in the 1) case, because GPIO is edge triggered, it cannot "see" this
interrupt, then GIC cannot know either; while in regmap_irq_thread(),
the software thinks it has acked all the interrupt, then goes on; but
actually the interrupt is missed and cannot be resumed in the 1)
scenario;

Please point out what I'm wrong; thanks;

So if this is true, what about using the following methods to fix it?
a) disable all the interrupts just before ack, then enable them after
ack finished; the cons are a) the interrupt is ignored in the process;
b) we need to manipulate the registers more frequently, after all, I2C
is a slow bus;
b) polling until the interrupts are acked; but I think it's hard to
guarantee that because the interrupt is asynchronous;

and one more question:
Seems we shouldn't connect an interrupt controller as PMIC with an
edge triggered interrupt controller? Could you please share your
opinion? we can modify the hardware connection accordingly;

thank you very much; :)
