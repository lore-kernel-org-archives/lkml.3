Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3JJCfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:35:07 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:24860 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3JJCfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:35:04 -0400
Message-ID: <52561232.2060505@huawei.com>
Date: Thu, 10 Oct 2013 10:34:26 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: kdump: kdump can't boot in this case
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I write a module, and find kdump can't boot in this case.
kernel version is 3.12, Intel(R) Xeon(R) CPU	E5620

struct timer_list g_timer;

void tmrhnd_invtssfault(unsigned long data)
{
	long __res;
	printk(KERN_EMERG "invalid TSS fault in interrupt context.\n");
	__asm__ volatile("int $0x0A" : "=a"(__res):);
}

{
	...
	init_timer(&g_timer);
	g_timer.expires = jiffies + 10;
	g_timer.data = 0;
	g_timer.function = tmrhnd_invtssfault;
	add_timer(&g_timer);
	...
}

If access NULL pointer instead of "__asm__ volatile("int $0x0A" : "=a"(__res):);" 
in tmrhnd_invtssfault(), kdump can boot.
And if not use timer, just do "__asm__ volatile("int $0x0A" : "=a"(__res):);" only
once in module, kdump can boot too.

