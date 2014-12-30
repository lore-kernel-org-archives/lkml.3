Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaL3MKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:10:34 -0500
Received: from out11.biz.mail.alibaba.com ([205.204.114.131]:36457 "EHLO
	out11.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbaL3MKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:10:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R911e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g03021;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=4;RT=4;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Alexey Dobriyan'" <adobriyan@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Hillf Danton" <hillf.zj@alibaba-inc.com>
Subject: Re: 3.17.7: list corruption(?) near epoll
Date: Tue, 30 Dec 2014 20:10:00 +0800
Message-ID: <062c01d02429$894dc9e0$9be95da0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdAkKNYyv9aNM24XQnCpD/6PA6TV3g==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Caught while browsing with chromium shortly after boot.
> Haven't seen something like that before.
>
Maybe the POLLFREE race still in mainline, mind trying the untested diff?

--- linux-3.16.1-org/fs/eventpoll.c	Thu Aug 14 10:36:35 2014
+++ linux-3.16.1/fs/eventpoll.c	Tue Dec 30 19:59:06 2014
@@ -520,7 +520,7 @@ static void ep_remove_wait_queue(struct 
 	rcu_read_lock();
 	/* If it is cleared by POLLFREE, it should be rcu-safe */
 	whead = rcu_dereference(pwq->whead);
-	if (whead)
+	if (whead && !list_empty(&pwq->wait.task_list))
 		remove_wait_queue(whead, &pwq->wait);
 	rcu_read_unlock();
 }
--
 
> Several chromium tabs locked up, dmesg was full of
> similar messages. Box was more or less operational,
> then switched to text console with last panic message.
> 
> After reboot, that's all what was left:
> 
>  [<ffffffff8115155d>] ep_remove+0x1d/0xb0
>  [<ffffffff81152740>] SyS_epoll_ctl+0x400/0xae0
>  [<ffffffff8109780b>] ? local_clock+0x1b/0x30
>  [<ffffffff8104803b>] ? syscall_trace_enter+0x16b/0x180
>  [<ffffffff81485009>] tracesys+0xd0/0xd5
> ---[ end trace 3fc03b0916c7ab8d ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1384 at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
> list_del corruption, ffff8800d99a7858->next is LIST_POISON1 (dead000000100100)
> Modules linked in: usbhid uhci_hcd
> CPU: 0 PID: 1384 Comm: Chrome_IOThread Tainted: G        W      3.17.7 #51
> Hardware name: Hewlett-Packard HP Compaq dc7800 Convertible
> Minitower/0AACh, BIOS 786F1 v01.28 02/26/2009
>  0000000000000009 ffff8800c6387d70 ffffffff8147f3c3 ffff8800c6387db8
>  ffff8800c6387da8 ffffffff810761f3 ffff8800d99a7858 ffff8800d99a7840
>  0000000000000286 00000000000000fa fffffffffffffffe ffff8800c6387e08
> Call Trace:
>  [<ffffffff8147f3c3>] dump_stack+0x4d/0x6f
>  [<ffffffff810761f3>] warn_slowpath_common+0x73/0x90
>  [<ffffffff81076257>] warn_slowpath_fmt+0x47/0x50
>  [<ffffffff81076257>] ? warn_slowpath_fmt+0x47/0x50
>  [<ffffffff81205983>] __list_del_entry+0x63/0xd0
>  [<ffffffff812059fd>] list_del+0xd/0x30
>  [<ffffffff810a12e1>] remove_wait_queue+0x21/0x40
>  [<ffffffff8115150f>] ep_unregister_pollwait.isra.17+0x3f/0x70
>  [<ffffffff8115155d>] ep_remove+0x1d/0xb0
>  [<ffffffff81152740>] SyS_epoll_ctl+0x400/0xae0
>  [<ffffffff8109780b>] ? local_clock+0x1b/0x30
>  [<ffffffff8104803b>] ? syscall_trace_enter+0x16b/0x180
>  [<ffffffff81485009>] tracesys+0xd0/0xd5
> ---[ end trace 3fc03b0916c7ab8e ]---
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1384 at lib/list_debug.c:56 __list_del_entry+0xc3/0xd0()
> list_del corruption, ffff8800d99a7828->prev is LIST_POISON2 (dead000000200200)
> Modules linked in: usbhid uhci_hcd
> CPU: 0 PID: 1384 Comm: Chrome_IOThread Tainted: G        W      3.17.7 #51
> Hardware name: Hewlett-Packard HP Compaq dc7800 Convertible
> Minitower/0AACh, BIOS 786F1 v01.28 02/26/2009
>  0000000000000009 ffff8800c6387d98 ffffffff8147f3c3 ffff8800c6387de0
>  ffff8800c6387dd0 ffffffff810761f3 ffff8800d99a7828 ffff8800d8df8a00
>  ffff8800d8df8a40 00000000000000fa fffffffffffffffe ffff8800c6387e30
> Call Trace:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


