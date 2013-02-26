Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab3BZBwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 20:52:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32046 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758168Ab3BZBwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 20:52:20 -0500
X-IronPort-AV: E=Sophos;i="4.84,737,1355068800"; 
   d="scan'208";a="6767838"
Message-ID: <512C152E.1020201@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 09:51:42 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
In-Reply-To: <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 09:51:28,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 09:51:29,
	Serialize complete at 2013/02/26 09:51:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>
>>> [    0.170435] ------------[ cut here ]------------
>>> [    0.170450] WARNING: at arch/x86/kernel/smpboot.c:324
>>> topology_sane.isra.2+0x71/0x84()
>>> [    0.170452] Hardware name: S2600CP
>>> [    0.170454] sched: CPU #1's llc-sibling CPU #0 is not on the same
>>> node! [node: 1 != 0]. Ignoring dependency.
>>> [    0.156000] smpboot: Booting Node   1, Processors  #1
>>> [    0.170455] Modules linked in:
>>> [    0.170460] Pid: 0, comm: swapper/1 Not tainted 3.8.0+ #1
>>> [    0.170461] Call Trace:
>>> [    0.170466]  [<ffffffff810597bf>] warn_slowpath_common+0x7f/0xc0
>>> [    0.170473]  [<ffffffff810598b6>] warn_slowpath_fmt+0x46/0x50
>>> [    0.170477]  [<ffffffff816cc752>] topology_sane.isra.2+0x71/0x84
>>> [    0.170482]  [<ffffffff816cc9de>] set_cpu_sibling_map+0x23f/0x436
>>> [    0.170487]  [<ffffffff816ccd0c>] start_secondary+0x137/0x201
>>> [    0.170502] ---[ end trace 09222f596307ca1d ]---
>
> that commit is totally broken, and it should be reverted.
>
> 1. numa_init is called several times, NOT just for srat. so those
>     nodes_clear(numa_nodes_parsed)
>     memset(&numa_meminfo, 0, sizeof(numa_meminfo))
> can not be just removed.
> please consider sequence is: numaq, srat, amd, dummy.
> You need to make fall back path working!
>
> 2. simply split acpi_numa_init to early_parse_srat.
> a. that early_parse_srat is NOT called for ia64, so you break ia64.
> b.  for (i = 0; i<  MAX_LOCAL_APIC; i++)
>       set_apicid_to_node(i, NUMA_NO_NODE)
> still left in numa_init. So it will just clear result from early_parse_srat.
> it should be moved before that....
>
> 3. that patch TITLE is total misleading, there is NO x86 in the title,
> but it changes
> to x86 code.
>
> 4, it does not CC to TJ and other numa guys...

Hi Yinghai, Don,

OK, I see this. I'll fix it soon. :)

Thanks. :)
