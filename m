Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912Ab3BKT4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:56:38 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:40723 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799Ab3BKT4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:56:35 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2013 14:56:34 EST
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: Build: [Engines: 2.13.6.156201, Dats:
 245314, Stamp: 3], Multi: [Enabled], BW: [Enabled], RBL DNSBL:
 [Disabled], APM: [Enabled, Score: 500, Flags: NN_LEGIT_VALID_REPLY;
 NN_LEGIT_SUMM_400_WORDS; NN_NO_LINK_NMD; NN_LEGIT_S_SQARE_BRACKETS],
 SGN: [Enabled], URL: [Enabled], URI DNSBL: [Disabled], SQMD: [Enabled,
 Hits: none, MD5: cb3978686e8a24eee2cb8db4d52751dd.fuzzy.fzrbl.org],
 RTDA: [Enabled, Hit: No, Details: v1.4.7; Id:
 2m1g3t8.17ik0imkc.11vba7], total: 0(775)
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.1.0 on
 elfie.dsd.hq, sigver: 7.45378
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=gmail.com;
  b=HIpZbZ6TjzOw2hA7jaNJ8zo+dApuFWBvI/q3ChgaF/AtudPXUQ+3/kvlNe24e+PVt4Ir7LlDzqNbBfNhrVwKHO+qbiCk849QRy8cFgiDKT9Uj+TSVT3feJFj3UMpYQw0BGc2Ky9lhC2P5fq54uR6VAeOb+qEV0bUdaujq+Sn0Bc=  ;
Date: Mon, 11 Feb 2013 21:49:52 +0200
From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
To: boyd yang <boyd.yang@gmail.com>
Cc: eparis@redhat.com, xiyou.wangcong@gmail.com,
        Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fanotify: to differ file access event from different
 threads
Message-ID: <20130211214952.310289ae@mdontu-l.dsd.ro>
In-Reply-To: <CAE8kqZJO_YZ855g2P3803-3ptExDeKX108x-Q_2Rz7rgz1iUew@mail.gmail.com>
References: <CAE8kqZJO_YZ855g2P3803-3ptExDeKX108x-Q_2Rz7rgz1iUew@mail.gmail.com>
Organization: Home
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011 09:23:25 +0800 boyd yang wrote:
> fanotify: to differ file access event from different threads
> When fanotify is monitoring the whole mount point "/", and multiple
> threads iterate the same direcotry, some thread will hang.
> This patch let fanotify to differ access events from different
> threads, prevent fanotify from merging access events from different
> threads.
> It also hide overflow events to reach user space.
> Signed-off-by: Boyd Yang <boyd.yang@gmail.com>
> 
> diff -r -u linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c
> linux-3.1-rc4/fs/notify/fanotify/fanotify.c
> --- linux-3.1-rc4_orig/fs/notify/fanotify/fanotify.c	2011-08-29
> 12:16:01.000000000 +0800
> +++ linux-3.1-rc4/fs/notify/fanotify/fanotify.c	2011-10-14
> 14:17:53.055958000 +0800
> @@ -15,7 +15,8 @@
> 
>  	if (old->to_tell == new->to_tell &&
>  	    old->data_type == new->data_type &&
> -	    old->tgid == new->tgid) {
> +	    old->tgid == new->tgid &&
> +	    old->pid == new->pid) {
>  		switch (old->data_type) {
>  		case (FSNOTIFY_EVENT_PATH):
>  			if ((old->path.mnt == new->path.mnt) &&
> @@ -144,11 +145,16 @@
>  		return PTR_ERR(notify_event);
> 
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> -	if (event->mask & FAN_ALL_PERM_EVENTS) {
> -		/* if we merged we need to wait on the new event */
> -		if (notify_event)
> -			event = notify_event;
> -		ret = fanotify_get_response_from_access(group,
> event);
> +	/*if overflow, do not wait for response*/
> +	if (event->mask&FS_Q_OVERFLOW) {
> +		pr_debug("fanotify overflow!\n");
> +	}	else {
> +		if (event->mask & FAN_ALL_PERM_EVENTS) {
> +			/* if we merged we need to wait on the new
> event */
> +			if (notify_event)
> +				event = notify_event;
> +			ret =
> fanotify_get_response_from_access(group, event);
> +		}
>  	}
>  #endif
> 
> diff -r -u linux-3.1-rc4_orig/fs/notify/notification.c
> linux-3.1-rc4/fs/notify/notification.c
> --- linux-3.1-rc4_orig/fs/notify/notification.c	2011-08-29
> 12:16:01.000000000 +0800
> +++ linux-3.1-rc4/fs/notify/notification.c	2011-10-14
> 13:52:36.946608000 +0800 @@ -95,6 +95,7 @@
>  		BUG_ON(!list_empty(&event->private_data_list));
> 
>  		kfree(event->file_name);
> +		put_pid(event->pid);
>  		put_pid(event->tgid);
>  		kmem_cache_free(fsnotify_event_cachep, event);
>  	}
> @@ -374,6 +375,7 @@
>  			return NULL;
>  		}
>  	}
> +	event->pid = get_pid(old_event->pid);
>  	event->tgid = get_pid(old_event->tgid);
>  	if (event->data_type == FSNOTIFY_EVENT_PATH)
>  		path_get(&event->path);
> @@ -417,6 +419,7 @@
>  		event->name_len = strlen(event->file_name);
>  	}
> 
> +	event->pid = get_pid(task_pid(current));
>  	event->tgid = get_pid(task_tgid(current));
>  	event->sync_cookie = cookie;
>  	event->to_tell = to_tell;
> diff -r -u linux-3.1-rc4_orig/include/linux/fsnotify_backend.h
> linux-3.1-rc4/include/linux/fsnotify_backend.h
> --- linux-3.1-rc4_orig/include/linux/fsnotify_backend.h
> 2011-08-29 12:16:01.000000000 +0800
> +++ linux-3.1-rc4/include/linux/fsnotify_backend.h	2011-10-14
> 13:51:50.380168000 +0800
> @@ -238,6 +238,7 @@
>  	u32 sync_cookie;	/* used to corrolate events, namely
> inotify mv events */ const unsigned char *file_name;
>  	size_t name_len;
> +	struct pid *pid;
>  	struct pid *tgid;
> 
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> 

This patch triggers the following on my 3.7.6 kernel:

INFO: rcu_sched detected stalls on CPUs/tasks: { 1} (detected by 0,
t=15002 jiffies) sending NMI to all CPUs:
NMI backtrace for cpu 0
CPU 0
Modules linked in: ext2 ppdev parport_pc mac_hid psmouse serio_raw
i2c_piix4 lp parport 8139too floppy 8139cp

Pid: 0, comm: swapper/0 Not tainted 3.2.35 #12 Bochs Bochs
RIP: 0010:[<ffffffff81037bdf>]  [<ffffffff81037bdf>]
flat_send_IPI_all+0xaf/0xd0 RSP: 0018:ffff88003fc03d88  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 0000000000000046 RCX: 0000000000000050
RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000300
RBP: ffff88003fc03da8 R08: 000000000000000a R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000c00
R13: 0000000003000000 R14: 0000000000000001 R15: ffffffff81c32d00
FS:  0000000000000000(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fb5d3100000 CR3: 000000001ca06000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81c00000, task
ffffffff81c0d020) Stack:
 0000000000000000 0000000000002710 ffffffff81c31c00 ffffffff81c31d00
 ffff88003fc03dc8 ffffffff81033231 000000000000000a ffff88003fc0ec40
 ffff88003fc03e18 ffffffff810defbe ffff880000000001 ffffffff81c32d00
Call Trace:
 <IRQ>
 [<ffffffff81033231>] arch_trigger_all_cpu_backtrace+0x61/0xa0
 [<ffffffff810defbe>] __rcu_pending+0x3ae/0x420
 [<ffffffff810df329>] rcu_check_callbacks+0x79/0x1e0
 [<ffffffff81078068>] update_process_times+0x48/0x90
 [<ffffffff8109b4f4>] tick_sched_timer+0x64/0xc0
 [<ffffffff8108df56>] __run_hrtimer+0x76/0x1f0
 [<ffffffff8109b490>] ? tick_nohz_handler+0x100/0x100
 [<ffffffff8108e907>] hrtimer_interrupt+0xf7/0x230
 [<ffffffff81650409>] smp_apic_timer_interrupt+0x69/0x99
 [<ffffffff8164e2de>] apic_timer_interrupt+0x6e/0x80
 <EOI>
 [<ffffffff810904a5>] ? sched_clock_local+0x25/0x90
 [<ffffffff8103cedb>] ? native_safe_halt+0xb/0x10
 [<ffffffff8101c6b3>] default_idle+0x53/0x1d0
 [<ffffffff81013236>] cpu_idle+0xd6/0x120
 [<ffffffff816172ce>] rest_init+0x72/0x74
 [<ffffffff81cfcba5>] start_kernel+0x3b0/0x3bd
 [<ffffffff81cfc347>] x86_64_start_reservations+0x132/0x136
 [<ffffffff81cfc140>] ? early_idt_handlers+0x140/0x140
 [<ffffffff81cfc44d>] x86_64_start_kernel+0x102/0x111
[...]

It happens after my application runs for half an hour or so. However, I
don't see how this could possibly solve the problem I've observed: due
to a race, a kernel thread ends up doing wait_event() on an event which
soon after is merged by a different thread into a new one which becomes
the actual event to be "received" by the content introspection
application. It's easily reproducible with a simple script:

   $ while true; do cp -f /root/eicar.com /root/watched-dir; done

all the while the fanotify application does a re-open (RD -> RDWR) and
truncate(0), on multiple threads.

(I do a fanotify_init(O_RDONLY) because of surprise ETXTBSY)

Anyway, regardless of how I use the API the race needs to be
eliminated somehow. So my problem now is: how do I switch all
wait_event()-users to the new event created by fanotify_merge()?

-- 
Mihai Donțu
