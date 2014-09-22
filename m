Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaIVNqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:46:34 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61020 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753625AbaIVNqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:46:31 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Prarit Bhargava <prarit@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] cpufreq, release policy->rwsem on error
Date: Mon, 22 Sep 2014 16:06:17 +0200
Message-ID: <13071541.1DqE9E64rV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAKohpokOk5ef0MZhDA0ntj2NGaQtWpy-c9E_zm=F2tiucH2EtQ@mail.gmail.com>
References: <1410358328-27303-1-git-send-email-prarit@redhat.com> <CAKohpokOk5ef0MZhDA0ntj2NGaQtWpy-c9E_zm=F2tiucH2EtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 11, 2014 10:05:43 AM Viresh Kumar wrote:
> On 10 September 2014 19:42, Prarit Bhargava <prarit@redhat.com> wrote:
> > I have not been able to reliably reproduce the hardware failure that caused
> > the warning.  In order to reproduce this I resorted to (sorry for the
> > cut-and-paste)
> >
> >         diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
> >         index 728a2d8..c7724d2 100644
> >         --- a/drivers/cpufreq/pcc-cpufreq.c
> >         +++ b/drivers/cpufreq/pcc-cpufreq.c
> >         @@ -146,6 +146,8 @@ static unsigned int pcc_get_freq(unsigned int cpu)
> >                 u32 input_buffer;
> >                 u32 output_buffer;
> >
> >         +       return 0;
> >         +
> >                 spin_lock(&pcc_lock);
> >
> >                 pr_debug("get: get_freq for CPU %d\n", cpu);
> >
> > to simulate the cpufreq_driver->get() hardware failure.
> >
> > ---8<---
> >
> > While debugging a cpufreq-related hardware failure on a system I saw the
> > following lockdep warning:
> >
> >  =========================
> >  [ BUG: held lock freed! ] 3.17.0-rc4+ #1 Tainted: G            E
> >  -------------------------
> >  insmod/2247 is freeing memory ffff88006e1b1400-ffff88006e1b17ff, with a lock still held there!
> >   (&policy->rwsem){+.+...}, at: [<ffffffff8156d37d>] __cpufreq_add_dev.isra.21+0x47d/0xb80
> >  3 locks held by insmod/2247:
> >   #0:  (subsys mutex#5){+.+.+.}, at: [<ffffffff81485579>] subsys_interface_register+0x69/0x120
> >   #1:  (cpufreq_rwsem){.+.+.+}, at: [<ffffffff8156cf73>] __cpufreq_add_dev.isra.21+0x73/0xb80
> >   #2:  (&policy->rwsem){+.+...}, at: [<ffffffff8156d37d>] __cpufreq_add_dev.isra.21+0x47d/0xb80
> >
> >  stack backtrace:
> >  CPU: 0 PID: 2247 Comm: insmod Tainted: G            E  3.17.0-rc4+ #1
> >  Hardware name: HP ProLiant MicroServer Gen8, BIOS J06 08/24/2013
> >   0000000000000000 000000008f3063c4 ffff88006f87bb30 ffffffff8171b358
> >   ffff88006bcf3750 ffff88006f87bb68 ffffffff810e09e1 ffff88006e1b1400
> >   ffffea0001b86c00 ffffffff8156d327 ffff880073003500 0000000000000246
> >  Call Trace:
> >   [<ffffffff8171b358>] dump_stack+0x4d/0x66
> >   [<ffffffff810e09e1>] debug_check_no_locks_freed+0x171/0x180
> >   [<ffffffff8156d327>] ? __cpufreq_add_dev.isra.21+0x427/0xb80
> >   [<ffffffff8121412b>] kfree+0xab/0x2b0
> >   [<ffffffff8156d327>] __cpufreq_add_dev.isra.21+0x427/0xb80
> >   [<ffffffff81724cf7>] ? _raw_spin_unlock+0x27/0x40
> >   [<ffffffffa003517f>] ? pcc_cpufreq_do_osc+0x17f/0x17f [pcc_cpufreq]
> >   [<ffffffff8156da8e>] cpufreq_add_dev+0xe/0x10
> >   [<ffffffff814855d1>] subsys_interface_register+0xc1/0x120
> >   [<ffffffff8156bcf2>] cpufreq_register_driver+0x112/0x340
> >   [<ffffffff8121415a>] ? kfree+0xda/0x2b0
> >   [<ffffffffa003517f>] ? pcc_cpufreq_do_osc+0x17f/0x17f [pcc_cpufreq]
> >   [<ffffffffa003562e>] pcc_cpufreq_init+0x4af/0xe81 [pcc_cpufreq]
> >   [<ffffffffa003517f>] ? pcc_cpufreq_do_osc+0x17f/0x17f [pcc_cpufreq]
> >   [<ffffffff81002144>] do_one_initcall+0xd4/0x210
> >   [<ffffffff811f7472>] ? __vunmap+0xd2/0x120
> >   [<ffffffff81127155>] load_module+0x1315/0x1b70
> >   [<ffffffff811222a0>] ? store_uevent+0x70/0x70
> >   [<ffffffff811229d9>] ? copy_module_from_fd.isra.44+0x129/0x180
> >   [<ffffffff81127b86>] SyS_finit_module+0xa6/0xd0
> >   [<ffffffff81725b69>] system_call_fastpath+0x16/0x1b
> >  cpufreq: __cpufreq_add_dev: ->get() failed
> > insmod: ERROR: could not insert module pcc-cpufreq.ko: No such device
> >
> > The warning occurs in the __cpufreq_add_dev() code which does
> >
> >         down_write(&policy->rwsem);
> >         ...
> >         if (cpufreq_driver->get && !cpufreq_driver->setpolicy) {
> >                 policy->cur = cpufreq_driver->get(policy->cpu);
> >                 if (!policy->cur) {
> >                         pr_err("%s: ->get() failed\n", __func__);
> >                         goto err_get_freq;
> >                 }
> >
> > If cpufreq_driver->get(policy->cpu) returns an error we execute the
> > code at err_get_freq, which does not up the policy->rwsem.  This causes
> > the lockdep warning.
> >
> > Trivial patch to up the policy->rwsem in the error path.
> >
> > After the patch has been applied, and an error occurs in the
> > cpufreq_driver->get(policy->cpu) call we will now see
> >
> > cpufreq: __cpufreq_add_dev: ->get() failed
> > cpufreq: __cpufreq_add_dev: ->get() failed
> > modprobe: ERROR: could not insert 'pcc_cpufreq': No such device
> >
> > Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Cc: linux-pm@vger.kernel.org
> > ---
> >  drivers/cpufreq/cpufreq.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index d9fdedd..aadaed0 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -1289,6 +1289,8 @@ err_get_freq:
> >                 per_cpu(cpufreq_cpu_data, j) = NULL;
> >         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >
> > +       up_write(&policy->rwsem);
> > +
> >         if (cpufreq_driver->exit)
> >                 cpufreq_driver->exit(policy);
> >  err_set_policy_cpu:

Queued up for 3.17-rc7, thanks!

> Fixes: "4e97b63 cpufreq: Initialize governor for a new policy under
> policy->rwsem"
> Stable: 3.14+

And thanks for the info above.

> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
