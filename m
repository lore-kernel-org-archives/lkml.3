Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3CALaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 06:30:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab3CALaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 06:30:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,761,1355068800"; 
   d="scan'208";a="6794578"
Message-ID: <513091C5.2010109@cn.fujitsu.com>
Date: Fri, 01 Mar 2013 19:32:21 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com> <512D7FAD.1040003@jp.fujitsu.com> <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com> <512D8EDA.3010602@jp.fujitsu.com> <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com> <512DBD24.7090302@cn.fujitsu.com> <20130227132612.14664a3a.akpm@linux-foundation.org> <CA+55aFz8Yx4=d=Lrmir0Vy0jhUBJMgfrJegDWsDByf28c0MuRQ@mail.gmail.com> <51302481.9070005@cn.fujitsu.com> <CA+55aFw_1wDHmu+wsfV5e0miHC20Guy=u_toG_VSnsqneryAHQ@mail.gmail.com> <513030AF.70208@zytor.com> <CAE9FiQXb7K=QTR4PgMdNSoPm2LgYkxAuXUUZ0BXtgicQOGOaUA@mail.gmail.com> <CAE9FiQXFVnO43TUFOt_zSL=QGDFmERQLfku3WJHgOPGTxf+XUA@mail.gmail.com>
In-Reply-To: <CAE9FiQXFVnO43TUFOt_zSL=QGDFmERQLfku3WJHgOPGTxf+XUA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 19:29:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 19:29:04,
	Serialize complete at 2013/03/01 19:29:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 03:43 PM, Yinghai Lu wrote:
> Please check attached patches.
>
> Plan A. revert all 8 patches:
>      revert_movablemem_map.patch
>
> Plan B. fix movablemem_map:
>      kill_max_low_pfn_mapped.patch and fix_movablemem_map.patch
>
> fix_movablemem_map.patch is too risky, and need more test.
>

Hi Yinghai,

In your Plan B, you allocated pgdat on local node, right ?

-    nd_pa = memblock_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
+    nd_pa = memblock_find_in_range_node(start, end, nd_size,
+                     SMP_CACHE_BYTES, nid);  ---------------- Here, 
right ?

Without movablemem_map, pgdat will be allocated successfully on local 
node, right ?

If so, this will prevent node hot-plug, because as mentioned by 
Kamezawa, there is
no way to ensure pgdat is not used by others on stack.

I do hope you can stop putting pgdat and zone on local node for now. And 
improve it
in the future.

And I also hope you can apply my revert SRAT patch first, and then do 
your work.
It will seem more clean to me.

Thanks. :)
