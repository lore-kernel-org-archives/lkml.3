Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3CTFVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:21:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64192 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3CTFVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:21:08 -0400
Message-ID: <1363756856.4626.6.camel@marge.simpson.net>
Subject: Re: cpu offline causes backtrace from cmci_rediscover
From: Mike Galbraith <bitbucket@online.de>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Date: Wed, 20 Mar 2013 06:20:56 +0100
In-Reply-To: <20130320031647.GA13311@gchen.bj.intel.com>
References: <20130319224408.GB18152@redhat.com>
	 <20130320031647.GA13311@gchen.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:MHDkyxi0KdkQi8qXevBRagdkJj/GaJdaDd1UnDI4xgV
 /QZ2+aX0bIe2AjQgHLcmC/VqF6EIc3pPJyxQ/i3MNmmh35QklW
 npw7CzZOhR/McwU7sJIGZWZ6fGoU17mXZ2PQRn0+io474q6uRF
 /2y087h1H7rOPRX1zlBuYRHnmuk0aSlQOFPPgYVTD10dOcC6dJ
 w3S8aXUD6iWbYQtG4BJ4SbdXtUUa9weQjilhTbf1wUF4xf61qS
 keP9yZVgLXZQgekz52Md+gk+tIDtfamDiPl4ojFM6JtXy5QPn/
 nUPrvaOOz2Cyq6kZ3u6OeMNysLnchkqT53uzTfuEIrlrMVBiIt
 mCR/uzgsIo9w+uvAK7Ki9dzZIm0J3EXTF+tUMTurgPHAArYX1n
 ozxuGULKy2omQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 23:16 -0400, Chen Gong wrote: 
> On Tue, Mar 19, 2013 at 06:44:08PM -0400, Dave Jones wrote:
> > Date:	Tue, 19 Mar 2013 18:44:08 -0400
> > From: Dave Jones <davej@redhat.com>
> > To: Linux Kernel <linux-kernel@vger.kernel.org>
> > Cc: x86@kernel.org
> > Subject: cpu offline causes backtrace from cmci_rediscover
> > User-Agent: Mutt/1.5.21 (2010-09-15)
> > 
> > offlining a CPU in 3.9-rc3 gets me this trace..
> > 
> > numa_remove_cpu cpu 1 node 0: mask now 0,2-3
> > smpboot: CPU 1 is now offline
> > BUG: using smp_processor_id() in preemptible [00000000] code: cpu-offline.sh/10591
> > caller is cmci_rediscover+0x6a/0xe0
> > Pid: 10591, comm: cpu-offline.sh Not tainted 3.9.0-rc3+ #2
> > Call Trace:
> >  [<ffffffff81333bbd>] debug_smp_processor_id+0xdd/0x100
> >  [<ffffffff8101edba>] cmci_rediscover+0x6a/0xe0
> >  [<ffffffff815f5b9f>] mce_cpu_callback+0x19d/0x1ae
> >  [<ffffffff8160ea66>] notifier_call_chain+0x66/0x150
> >  [<ffffffff8107ad7e>] __raw_notifier_call_chain+0xe/0x10
> >  [<ffffffff8104c2e3>] cpu_notify+0x23/0x50
> >  [<ffffffff8104c31e>] cpu_notify_nofail+0xe/0x20
> >  [<ffffffff815ef082>] _cpu_down+0x302/0x350
> >  [<ffffffff815ef106>] cpu_down+0x36/0x50
> >  [<ffffffff815f1c9d>] store_online+0x8d/0xd0
> >  [<ffffffff813edc48>] dev_attr_store+0x18/0x30
> >  [<ffffffff81226eeb>] sysfs_write_file+0xdb/0x150
> >  [<ffffffff811adfb2>] vfs_write+0xa2/0x170
> >  [<ffffffff811ae16c>] sys_write+0x4c/0xa0
> >  [<ffffffff81613019>] system_call_fastpath+0x16/0x1b
> > 
> Try this patch:
> 
> diff a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index 402c454..692c91e 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -311,10 +311,12 @@ void cmci_rediscover(int dying)
>                 if (cpu == dying)
>                         continue;
> 
> -               if (cpu == smp_processor_id()) {
> +               if (cpu == get_cpu()) {
> +                       put_cpu();
>                         cmci_rediscover_work_func(NULL);
>                         continue;
> -               }
> +               } else
> +                       put_cpu();
> 
>                 work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
>         }
> 

raw_smp_processor_id()?

-Mike

