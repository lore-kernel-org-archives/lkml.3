Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaJPGAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 02:00:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:57006 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaJPGAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 02:00:35 -0400
Message-ID: <543F5EFA.7050209@hitachi.com>
Date: Thu, 16 Oct 2014 15:00:26 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Gioh Kim <gioh.kim@lge.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: How can I check creator of probe point?
References: <543C8787.7010003@lge.com>
In-Reply-To: <543C8787.7010003@lge.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gioh,

If you can use ftrace and perftool, you can also put probes on
caller site. perf-probe will give you source-code level probes.
Or, just trace kmalloc event with ftrace stacktrace option, which
gives you caller information so that you can filter your driver
by postprocessing.

Thank you,

(2014/10/14 11:16), Gioh Kim wrote:
> 
> Hi,
> 
> I am trying to find a way to make statistics for memory allocation of my device driver.
> I want to know how much memory it allocates and how many times it calls kmalloc().
> 
> So I am considering to use kprobe but I think it doesn't provide a way to identify who makes the probe point.
> Can I distinguish kmalloc() calling only from my driver?
> 
> For example I think it could be like this:
> 
> diff --git a/samples/kprobes/kretprobe_example.c b/samples/kprobes/kretprobe_example.c
> index 1041b67..5322e0a 100644
> --- a/samples/kprobes/kretprobe_example.c
> +++ b/samples/kprobes/kretprobe_example.c
> @@ -32,6 +32,7 @@ MODULE_PARM_DESC(func, "Function to kretprobe; this module will report the"
> 
>  /* per-instance private data */
>  struct my_data {
> +       unsigned long signature;
>         ktime_t entry_stamp;
>  };
> 
> @@ -43,8 +44,10 @@ static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
>         if (!current->mm)
>                 return 1;       /* Skip kernel threads */
> 
> -       data = (struct my_data *)ri->data;
> -       data->entry_stamp = ktime_get();
> +       if (signature == 0xabcdabcd) {
> +               data = (struct my_data *)ri->data;
> +               data->entry_stamp = ktime_get();
> +       }
>         return 0;
>  }
> 
> @@ -60,10 +63,12 @@ static int ret_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
>         s64 delta;
>         ktime_t now;
> 
> -       now = ktime_get();
> -       delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
> -       printk(KERN_INFO "%s returned %d and took %lld ns to execute\n",
> -                       func_name, retval, (long long)delta);
> +       if (signature == 0xabcdabcd) {
> +               now = ktime_get();
> +               delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
> +               printk(KERN_INFO "%s returned %d and took %lld ns to execute\n",
> +                      func_name, retval, (long long)delta);
> +       }
>         return 0;
>  }
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


