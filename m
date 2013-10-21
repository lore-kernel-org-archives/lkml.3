Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3JUGQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 02:16:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:8585 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3JUGQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 02:16:03 -0400
From: Liuyongan <liuyongan@huawei.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Qianhuibin <qianhuibin@huawei.com>
Subject: RE: kprobe pre_handler change return IP
Thread-Topic: kprobe pre_handler change return IP
Thread-Index: Ac7LOCsFLnDCNv9iRNWFSiq5It69WABaRU4AAF49G/A=
Date: Mon, 21 Oct 2013 06:15:22 +0000
Message-ID: <E4ABEE53CC34664FA3F0BD8AEAF50A1941474EDB@szxeml511-mbs.china.huawei.com>
References: <E4ABEE53CC34664FA3F0BD8AEAF50A1941474DB1@szxeml511-mbs.china.huawei.com>
 <5262AC92.3060606@hitachi.com>
In-Reply-To: <5262AC92.3060606@hitachi.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.135.68.95]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9L6GCp0029301



> -----Original Message-----
> From: Masami Hiramatsu [mailto:masami.hiramatsu.pt@hitachi.com]
> Sent: Sunday, October 20, 2013 12:00 AM
> To: Liuyongan
> Cc: linux-kernel@vger.kernel.org; Qianhuibin
> Subject: Re: kprobe pre_handler change return IP
> 
> (2013/10/17 21:57), Liuyongan wrote:
> > I use kprobe to probe a function suppose:
> >           int is_winter(int num) { ... }
> >           int replace_is_winter(int num) { ...}
> > I want to replace is_winter() with replace_is_winter(), so when we call
> is_winter, replace_is_winter will be called.
> >
> > so:
> >    int my_pre_handler(struct kprobe *p, struct pt_regs *regs)
> >    {
> >         regs->ip = (unsigned long)&replace_is_winter;
> >         return 1;
> >    }
> >
> > and echo 0 > /proc/sys/debug/kprobes-optimization so that jump instruction
> will not be used.
> >
> > I got a exception in fault_handler, and trap number is 14.
> >
> >    fault_handler: p->addr = 0xffffffffa08e201a, ip = ffffffff8021c59d, trap
> #14n
> >
> > Anyone here can help me ?
> 
> If you want to replace something with kprobes, the pre_handler must clean
> current_kprobe up.
> Actually the same thing has been done in setup_detour_execution(). So, what
> you need to do is

Great! It works. 
As my_pre_handler() in another modules,  I should export current_kprobe using

EXPORT_PER_CPU_SYMBOL(current_kprobe);

in arch/x86/kernel/kprobes.c right after current_kprobe's definition.

> 
> >    int my_pre_handler(struct kprobe *p, struct pt_regs *regs)
> >    {
> >         regs->ip = (unsigned long)&replace_is_winter;
> 
>           reset_current_kprobe();
>           preempt_enable_no_resched();
> 
> >         return 1;
> >    }
> 
> Happy hacking! ;)
> 
> 
> Thank you,
> 
> --
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
