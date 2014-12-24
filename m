Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaLXGu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 01:50:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaLXGuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 01:50:23 -0500
Date: Wed, 24 Dec 2014 14:50:02 +0800
From: Fam Zheng <famz@redhat.com>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3.19-rc1] read_events => aio_read_events => WARNING: "do not
 call blocking ops when !TASK_RUNNING"
Message-ID: <20141224065002.GA15614@ad.nay.redhat.com>
References: <87oaqvhoir.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87oaqvhoir.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12/22 13:12, Bjørn Mork wrote:
> Hello,
> 
> I got this warning on v3.19-rc1:
> 
> [   16.325814] ------------[ cut here ]------------
> [   16.325832] WARNING: CPU: 0 PID: 3368 at kernel/sched/core.c:7303 __might_sleep+0x55/0x94()
> [   16.325839] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff81071360>] prepare_to_wait_event+0x8c/0xd8
> [   16.325843] Modules linked in: xt_multiport xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack bridge dm_thin_pool dm_persistent_data crc32c_generic libcrc32c dm_bio_prison dm_bufio dm_mod iptable_filter ip_tables bnep xt_hl nf_log_ipv6 nf_log_common xt_LOG binfmt_misc ip6table_filter ip6_tables x_tables nfsd nfs_acl nfs lockd grace fscache sunrpc 8021q garp mrp stp llc tun fuse loop iTCO_wdt iTCO_vendor_support snd_hda_codec_conexant snd_hda_codec_generic coretemp arc4 kvm_intel kvm ecb evdev psmouse serio_raw uvcvideo videobuf2_vmalloc videobuf2_memops cdc_mbim cdc_wdm cdc_ncm videobuf2_core v4l2_common usbnet mii cdc_acm videodev iwlmvm btusb mac80211 bluetooth iwlwifi snd_hda_intel i2c_i801 snd_hda_controller
> [   16.325980]  lpc_ich mfd_core cfg80211 snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_timer thinkpad_acpi wmi nvram snd soundcore rfkill ac i915 battery i2c_algo_bit drm_kms_helper video drm button acpi_cpufreq processor ext4 crc16 jbd2 mbcache nbd microcode sg sr_mod sd_mod cdrom ahci libahci libata scsi_mod e1000e ehci_pci uhci_hcd ehci_hcd ptp usbcore usb_common pps_core thermal thermal_sys
> [   16.326070] CPU: 0 PID: 3368 Comm: mysqld Not tainted 3.19.0-rc1 #270
> [   16.326074] Hardware name: LENOVO 2776LEG/2776LEG, BIOS 6EET55WW (3.15 ) 12/19/2011
> [   16.326077]  0000000000000009 ffff88022a66fc58 ffffffff813cf430 0000000000000000
> [   16.326087]  ffff88022a66fca8 ffff88022a66fc98 ffffffff8104117c 00000000000092e8
> [   16.326095]  ffffffff81060e84 ffffffff815a5241 000000000000026d 0000000000000000
> [   16.326104] Call Trace:
> [   16.326112]  [<ffffffff813cf430>] dump_stack+0x4c/0x65
> [   16.326119]  [<ffffffff8104117c>] warn_slowpath_common+0x9c/0xb6
> [   16.326126]  [<ffffffff81060e84>] ? __might_sleep+0x55/0x94
> [   16.326132]  [<ffffffff8104122a>] warn_slowpath_fmt+0x41/0x43
> [   16.326141]  [<ffffffff8100a3cd>] ? native_sched_clock+0x35/0x37
> [   16.326147]  [<ffffffff81071360>] ? prepare_to_wait_event+0x8c/0xd8
> [   16.326153]  [<ffffffff81071360>] ? prepare_to_wait_event+0x8c/0xd8
> [   16.326159]  [<ffffffff81060e84>] __might_sleep+0x55/0x94
> [   16.326166]  [<ffffffff813d3205>] mutex_lock_nested+0x2a/0x39e
> [   16.326173]  [<ffffffff81070db9>] ? spin_unlock_irqrestore+0x9/0xb
> [   16.326180]  [<ffffffff81067f61>] ? local_clock+0x19/0x22
> [   16.326187]  [<ffffffff81076446>] ? lock_release_holdtime.part.26+0x71/0x7f
> [   16.326194]  [<ffffffff813d514e>] ? _raw_spin_unlock_irqrestore+0x3a/0x48
> [   16.326201]  [<ffffffff8117691f>] aio_read_events+0x45/0x282
> [   16.326208]  [<ffffffff81176fe0>] read_events+0x1c0/0x23c
> [   16.326214]  [<ffffffff8107124d>] ? abort_exclusive_wait+0x95/0x95
> [   16.326221]  [<ffffffff81095193>] ? hrtimer_get_res+0x47/0x47
> [   16.326227]  [<ffffffff81095c9e>] ? hrtimer_start_range_ns+0xf/0x11
> [   16.326234]  [<ffffffff81178d62>] SyS_io_getevents+0x4c/0x76
> [   16.326241]  [<ffffffff813d5492>] system_call_fastpath+0x12/0x17
> [   16.326246] ---[ end trace aa79768e2e6ba68a ]---
> 
> 
> And the mysqld process just sits there burning CPU:
> 
> top - 13:01:23 up 33 min, 15 users,  load average: 10.07, 10.23, 9.28
> Tasks: 175 total,   2 running, 173 sleeping,   0 stopped,   0 zombie
> %Cpu(s):  4.0 us, 95.5 sy,  0.0 ni,  0.2 id,  0.1 wa,  0.0 hi,  0.2 si,  0.0 st
> KiB Mem:   8069208 total,  4414640 used,  3654568 free,   475752 buffers
> KiB Swap:  9525244 total,        0 used,  9525244 free.  2063192 cached Mem
> 
>   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND                                                                                                                             
>  3343 mysql     20   0  549944  47456  10492 S 171.9  0.6  60:21.11 mysqld                                                                                                                              
> 
> 
> Looking at it, it just loops over the io_getevents syscall:
> 
> 
> nemi:/tmp# strace -fp 3343
> Process 3343 attached with 17 threads
> [pid  3414] futex(0x7f08cbf43ba4, FUTEX_WAIT_PRIVATE, 95, NULL <unfinished ...>
> [pid  3410] rt_sigtimedwait([HUP QUIT ALRM TERM TSTP], NULL, NULL, 8 <unfinished ...>
> [pid  3396] futex(0x7f08cd669a0c, FUTEX_WAIT_PRIVATE, 1, NULL <unfinished ...>
> [pid  3395] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
> [pid  3393] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
> [pid  3375] io_getevents(139675742199808, 1, 256,  <unfinished ...>
> [pid  3394] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
> [pid  3343] restart_syscall(<... resuming interrupted call ...> <unfinished ...>
> [pid  3368] io_getevents(139675744239616, 1, 256,  <unfinished ...>
> [pid  3370] io_getevents(139675744198656, 1, 256,  <unfinished ...>
> [pid  3372] io_getevents(139675744157696, 1, 256,  <unfinished ...>
> [pid  3369] io_getevents(139675744219136, 1, 256,  <unfinished ...>
> [pid  3376] io_getevents(139675696115712, 1, 256,  <unfinished ...>
> [pid  3377] io_getevents(139675696095232, 1, 256,  <unfinished ...>
> [pid  3371] io_getevents(139675744178176, 1, 256,  <unfinished ...>
> [pid  3374] io_getevents(139675742220288, 1, 256,  <unfinished ...>
> [pid  3373] io_getevents(139675742240768, 1, 256,  <unfinished ...>
> [pid  3375] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3368] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3370] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3370] io_getevents(139675744198656, 1, 256,  <unfinished ...>
> [pid  3372] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3372] io_getevents(139675744157696, 1, 256,  <unfinished ...>
> [pid  3369] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3375] io_getevents(139675742199808, 1, 256,  <unfinished ...>
> [pid  3368] io_getevents(139675744239616, 1, 256,  <unfinished ...>
> [pid  3376] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3369] io_getevents(139675744219136, 1, 256,  <unfinished ...>
> [pid  3376] io_getevents(139675696115712, 1, 256,  <unfinished ...>
> [pid  3377] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3377] io_getevents(139675696095232, 1, 256,  <unfinished ...>
> [pid  3373] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3371] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3374] <... io_getevents resumed> {}{0, 500000000}) = 0
> [pid  3371] io_getevents(139675744178176, 1, 256,  <unfinished ...>
> [pid  3374] io_getevents(139675742220288, 1, 256,  <unfinished ...>
> 
> 
> 
> I have not tried to repeat this yet, so I don't know if it is
> reproducable.  FWIW, it never happened to me with v3.18.  I send this to
> you because it looks like you touched this code path between v3.18 and
> v3.19-rc1, so I hope you have a clue what's going on here...  Ref:

Could you trace down to the source code context of this io_getevents call in
mysqld?  The change merely made io_getevents return a lot more quickly than
before, so it seems like that a polling loop is spinning too fast as a result.

Fam


> 
> 
> 
> commit 5f785de588735306ec4d7c875caf9d28481c8b21
> Author: Fam Zheng <famz@redhat.com>
> Date:   Thu Nov 6 20:44:36 2014 +0800
> 
>     aio: Skip timer for io_getevents if timeout=0
>     
>     In this case, it is basically a polling. Let's not involve timer at all
>     because that would hurt performance for application event loops.
>     
>     In an arbitrary test I've done, io_getevents syscall elapsed time
>     reduces from 50000+ nanoseconds to a few hundereds.
>     
>     Signed-off-by: Fam Zheng <famz@redhat.com>
>     Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index bfab55607a4d..1b7893ecc296 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1253,8 +1253,12 @@ static long read_events(struct kioctx *ctx, long min_nr, long nr,
>          * the ringbuffer empty. So in practice we should be ok, but it's
>          * something to be aware of when touching this code.
>          */
> -       wait_event_interruptible_hrtimeout(ctx->wait,
> -                       aio_read_events(ctx, min_nr, nr, event, &ret), until);
> +       if (until.tv64 == 0)
> +               aio_read_events(ctx, min_nr, nr, event, &ret);
> +       else
> +               wait_event_interruptible_hrtimeout(ctx->wait,
> +                               aio_read_events(ctx, min_nr, nr, event, &ret),
> +                               until);
>  
>         if (!ret && signal_pending(current))
>                 ret = -EINTR;
> 
> 
> 
> 
> 
> Bjørn
