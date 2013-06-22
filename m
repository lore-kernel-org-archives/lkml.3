Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3FVRfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 13:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab3FVRfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 13:35:53 -0400
Date: Sat, 22 Jun 2013 19:31:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130622173129.GA29375@redhat.com>
References: <20130619164540.GB22483@redhat.com> <20130619175356.GA23673@redhat.com> <20130619181302.GE5146@linux.vnet.ibm.com> <20130620001212.GB12151@redhat.com> <20130620161652.GA4462@linux.vnet.ibm.com> <20130621151119.GA1596@redhat.com> <20130621195949.GA15519@redhat.com> <20130622013731.GA22918@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130622013731.GA22918@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Dave Jones wrote:
>
> On Fri, Jun 21, 2013 at 09:59:49PM +0200, Oleg Nesterov wrote:
>
>  > I am puzzled. And I do not really understand
>  >
>  > 	hardirqs last  enabled at (2380318): [<ffffffff816ed220>] restore_args+0x0/0x30
>  > 	hardirqs last disabled at (2380319): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
>  > 	softirqs last  enabled at (196990): [<ffffffff810542d4>] __do_softirq+0x194/0x440 [19886.471395]
>  > 	softirqs last disabled at (197479): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
>  >
>  > below. how can they differ that much...

And I misread the original trace. Now that I read it again I am even
more puzzled.

So it actually blames __do_softirq(), I didn't notice "RIP:" part.
And "softirqs last disabled" refers to irq_exit() because __do_softirq()
does __local_bh_disable(__builtin_return_address(0)). Just to add more
confusion I guess ;)

This explains "differ that much" above, __do_softirq() does cli/sti in
a loop without return return.

And how the poor 8aac6270 can trigger this ???

>  > Dave, any chance you can reproduce the hang with the debugging patch at
>  > the end? Just in case, the warnings themself do not mean a problem, just
>  > to have a bit more info.
>
> [ 7485.261299] WARNING: at include/linux/nsproxy.h:63 get_proc_task_net+0x1c8/0x1d0()
> [ 7485.262021] Modules linked in: 8021q garp stp tun fuse rfcomm bnep hidp snd_seq_dummy nfnetlink scsi_transport_iscsi can_bcm ipt_ULOG can_raw rds af_802154 nfc can rose caif_socket caif llc2 af_rxrpc phonet ipx p8023 p8022 pppoe pppox ppp_generic netrom slhc ax25 x25 af_key appletalk atm psnap llc irda crc_ccitt bluetooth rfkill coretemp hwmon kvm_intel snd_hda_codec_realtek kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device pcspkr snd_pcm snd_page_alloc e1000e snd_timer ptp snd pps_core soundcore xfs libcrc32c
> [ 7485.265434] CPU: 2 PID: 5623 Comm: trinity-child3 Not tainted 3.10.0-rc6+ #28 
> [ 7485.267158]  ffffffff81a1529c ffff8801c8eafd30 ffffffff816e432d ffff8801c8eafd68
> [ 7485.268045]  ffffffff8104a0c1 0000000000000000 ffff880225e9bd18 ffff8801bc6e4de0
> [ 7485.268932]  0000000000000000 00000000000000dd ffff8801c8eafd78 ffffffff8104a19a
> [ 7485.270463] Call Trace:
> [ 7485.271338]  [<ffffffff816e432d>] dump_stack+0x19/0x1b
> [ 7485.272207]  [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
> [ 7485.273092]  [<ffffffff8104a19a>] warn_slowpath_null+0x1a/0x20
> [ 7485.273942]  [<ffffffff81229f58>] get_proc_task_net+0x1c8/0x1d0
> [ 7485.274793]  [<ffffffff81229d95>] ? get_proc_task_net+0x5/0x1d0
> [ 7485.275659]  [<ffffffff8122a0bd>] proc_tgid_net_lookup+0x1d/0x80
> [ 7485.276531]  [<ffffffff811b778d>] lookup_real+0x1d/0x50
> [ 7485.277646]  [<ffffffff811b7d83>] __lookup_hash+0x33/0x40
> [ 7485.278477]  [<ffffffff811bb143>] kern_path_create+0xb3/0x190
> [ 7485.279345]  [<ffffffff811b93d5>] ? getname_flags+0xb5/0x190
> [ 7485.280292]  [<ffffffff811bb261>] user_path_create+0x41/0x60
> [ 7485.281233]  [<ffffffff811be6bb>] SyS_symlinkat+0x4b/0xd0
> [ 7485.282072]  [<ffffffff816f5a54>] tracesys+0xdd/0xe2
> [ 7485.282973] ---[ end trace 2204b7c65d6c5519 ]---

Hmm. The test case tries to create the symlink in /proc/*/net/ ?

>  > +		pr_info("YESTHISHAPPENS new=%p\n", new);
>
> This didn't trigger. (yet?)

This should only trigger if the test-case plays with the namespaces...
But once again, the warnings are fine. I hoped that they can provide
more info when/if you reproduce the lockup.

But it seems you can't ?


Dave, I am sorry but all I can do is to ask you to do more testing.
Could you please reproduce the lockup again on the clean Linus's
current ? (and _without_ reverting 8aac6270, of course).

If watchdog will blame __do_softirq() again I can try to make a
better debugging patch.

Perhaps it makes sense to decrease /proc/sys/kernel/watchdog_thresh
to detect the possible lockups earlier. 2 * 10 is probably too much.



And who knows, perhaps you pulled some fix (say 34376a50fb1 looks
promising) after you finished bisecting and then pulled Linus
current.

Thanks,

Oleg.

