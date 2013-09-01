Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3IANLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 09:11:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49720 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752887Ab3IANLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 09:11:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: mutex warning in cpufreq + RFC patch
Date: Sun, 01 Sep 2013 15:22:37 +0200
Message-ID: <3616582.NWckpAF80o@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAKohpon3p5rTvc+2Cowm=rFSv+QP=ns1L9_nci5piuB90eD3FA@mail.gmail.com>
References: <20130828025721.GA19754@codeaurora.org> <20130831003641.GE19754@codeaurora.org> <CAKohpon3p5rTvc+2Cowm=rFSv+QP=ns1L9_nci5piuB90eD3FA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 01, 2013 11:54:10 AM Viresh Kumar wrote:
> On 31 August 2013 06:06, Stephen Boyd <sboyd@codeaurora.org> wrote:
> > Yes that patch may reduce the chance of the race condition but I
> > don't believe it removes it entirely. I believe this bug still
> > exists in linux-next. Consider the scenario where CPU1 is going
> > down.
> >
> > __cpufreq_remove_dev()
> >  ret = __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> >   __cpufreq_governor()
> >    policy->governor->governor(policy, CPUFREQ_GOV_STOP);
> >     cpufreq_governor_dbs()
> >      case CPUFREQ_GOV_STOP:
> >       mutex_destroy(&cpu_cdbs->timer_mutex)
> >       cpu_cdbs->cur_policy = NULL;
> >   <PREEMPT>
> > store()
> >  __cpufreq_set_policy()
> >   ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
> >    __cpufreq_governor()
> >     policy->governor->governor(policy, CPUFREQ_GOV_LIMITS);
> >      case CPUFREQ_GOV_LIMITS:
> >       mutex_lock(&cpu_cdbs->timer_mutex); <-- Warning (destroyed mutex)
> >        if (policy->max < cpu_cdbs->cur_policy->cur) <- cur_policy == NULL
> 
> Some of the crashes you reported would be fixed by the patches I sent
> today morning.
> 
> Let me know if anything else is left for latest linux-next...
> 
> Btw, I am facing another crash which I am not sure how to fix.. It
> came with your script:

This isn't a crash, but a WARN_ON_ONCE() triggering.  The comment in kref_get()
explains when that occurs, so we seem to have a race between
store_scaling_min_freq() and CPU removal.

> [  190.850481] ------------[ cut here ]------------
> [  190.850489] WARNING: CPU: 3 PID: 14140 at
> /home/arm/work/kernel/mywork/linux.git/include/linux/kref.h:47
> kobject_get+0x42/0x50()
> [  190.850490] Modules linked in: nfsd nfs fscache lockd arc4 iwldvm
> mac80211 i915 iwlwifi drm_kms_helper nfs_acl auth_rpcgss cfg80211
> sunrpc drm joyd
> ev thinkpad_acpi snd_hda_codec_hdmi snd_seq_midi
> snd_hda_codec_conexant oid_registry btusb snd_rawmidi snd_hda_intel
> snd_hda_codec i2c_algo_bit rfcomm
>  snd_seq_midi_event bnep psmouse snd_seq snd_hwdep snd_pcm bluetooth
> snd_timer snd_seq_device parport_pc snd_page_alloc ppdev tpm_tis snd
> soundcore lp
> c_ich lp parport video serio_raw mac_hid wmi nvram binfmt_misc btrfs
> raid6_pq e1000e ptp pps_core xor sdhci_pci sdhci zlib_deflate
> libcrc32c
> [  190.850563] CPU: 3 PID: 14140 Comm: sh Not tainted 3.11.0-rc7-custom #39
> [  190.850567] Hardware name: LENOVO 4236G50/4236G50, BIOS 83ET70WW
> (1.40 ) 06/12/2012
> [  190.850571]  000000000000002f ffff8800c8bdfc38 ffffffff816746c3
> 0000000000000007
> [  190.850580]  0000000000000000 ffff8800c8bdfc78 ffffffff8104cf8c
> ffff88011e5f9b18
> [  190.850587]  ffff880118eaf000 0000000000000001 0000000000000202
> 0000000000000008
> [  190.850593] Call Trace:
> [  190.850607]  [<ffffffff816746c3>] dump_stack+0x46/0x58
> [  190.850615]  [<ffffffff8104cf8c>] warn_slowpath_common+0x8c/0xc0
> [  190.850622]  [<ffffffff8104cfda>] warn_slowpath_null+0x1a/0x20
> [  190.850629]  [<ffffffff81324e02>] kobject_get+0x42/0x50
> [  190.850638]  [<ffffffff81533ab0>] cpufreq_cpu_get+0x80/0xc0
> [  190.850647]  [<ffffffff81533c11>] cpufreq_get_policy+0x21/0x120
> [  190.850655]  [<ffffffff81533fdf>] store_scaling_min_freq+0x3f/0xa0
> [  190.850666]  [<ffffffff816785b6>] ? down_write+0x16/0x40
> [  190.850674]  [<ffffffff81533000>] store+0x70/0xb0
> [  190.850683]  [<ffffffff811f2582>] sysfs_write_file+0xe2/0x170
> [  190.850693]  [<ffffffff81181e8e>] vfs_write+0xce/0x200
> [  190.850700]  [<ffffffff81182392>] SyS_write+0x52/0xa0
> [  190.850707]  [<ffffffff81683882>] system_call_fastpath+0x16/0x1b
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
