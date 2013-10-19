Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750961Ab3JSQAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:00:22 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53518 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3JSQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:00:21 -0400
Message-ID: <5262AC92.3060606@hitachi.com>
Date: Sun, 20 Oct 2013 01:00:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Liuyongan <liuyongan@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Qianhuibin <qianhuibin@huawei.com>
Subject: Re: kprobe pre_handler change return IP
References: <E4ABEE53CC34664FA3F0BD8AEAF50A1941474DB1@szxeml511-mbs.china.huawei.com>
In-Reply-To: <E4ABEE53CC34664FA3F0BD8AEAF50A1941474DB1@szxeml511-mbs.china.huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/17 21:57), Liuyongan wrote:
> I use kprobe to probe a function suppose: 
>           int is_winter(int num) { ... }
>           int replace_is_winter(int num) { ...} 
> I want to replace is_winter() with replace_is_winter(), so when we call is_winter, replace_is_winter will be called.
>                                                                                                                   
> so:  
>    int my_pre_handler(struct kprobe *p, struct pt_regs *regs)
>    { 
>         regs->ip = (unsigned long)&replace_is_winter;
>         return 1;
>    } 
> 
> and echo 0 > /proc/sys/debug/kprobes-optimization so that jump instruction will not be used.
> 
> I got a exception in fault_handler, and trap number is 14.
> 
>    fault_handler: p->addr = 0xffffffffa08e201a, ip = ffffffff8021c59d, trap #14n
> 
> Anyone here can help me ?

If you want to replace something with kprobes, the pre_handler must clean current_kprobe up.
Actually the same thing has been done in setup_detour_execution(). So, what you need to do is

>    int my_pre_handler(struct kprobe *p, struct pt_regs *regs)
>    {
>         regs->ip = (unsigned long)&replace_is_winter;

          reset_current_kprobe();
          preempt_enable_no_resched();

>         return 1;
>    }

Happy hacking! ;)


Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


