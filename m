Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab3ICRjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:39:17 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63110 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab3ICRjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:39:14 -0400
Message-ID: <52261EBE.5010007@gmail.com>
Date: Tue, 03 Sep 2013 21:39:10 +0400
From: Andrey Moiseev <o2g.org.ru@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-input@vger.kernel.org
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: input: i8042 possible bug
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an extract from drivers/input/serio/i8042.c:
> 
> static int i8042_flush(void)
> {
> 	unsigned long flags;
> 	unsigned char data, str;
> 	int i = 0;
> 
> 	spin_lock_irqsave(&i8042_lock, flags);
> 
> 	while (((str = i8042_read_status()) & I8042_STR_OBF) && (i < I8042_BUFFER_SIZE)) {
> 		udelay(50);
> 		data = i8042_read_data();
> 		i++;
> 		dbg("%02x <- i8042 (flush, %s)\n",
> 		    data, str & I8042_STR_AUXDATA ? "aux" : "kbd");
> 	}
> 
> 	spin_unlock_irqrestore(&i8042_lock, flags);
> 
> 	return i;
> }
> 
> static int i8042_controller_check(void)
> {
> 	if (i8042_flush() == I8042_BUFFER_SIZE) {
Doesn't it panic needlessly, while the buffer was initially full?
> 		pr_err("No controller found\n");
> 		return -ENODEV;
> 	}
> 
> 	return 0;
> }


