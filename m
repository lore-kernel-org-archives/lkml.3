Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbaGDK7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:59:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48434 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaGDK7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:59:24 -0400
Date: Fri, 4 Jul 2014 12:59:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, huawei.libin@huawei.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH] x86,cpu-hotplug: clear llc_shared_mask at CPU hotplug
Message-ID: <20140704105913.GB9246@pd.tnic>
References: <53B3A991.2070502@jp.fujitsu.com>
 <20140702113253.GD1318@pd.tnic>
 <53B4E1A4.2050502@jp.fujitsu.com>
 <20140703095135.GA21776@pd.tnic>
 <53B5F201.5070804@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B5F201.5070804@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 09:14:57AM +0900, Yasuaki Ishimatsu wrote:
> If so, why following maps are cleared by CPU offline?
>   - cpu_sigling_map
>   - cpu_core_map

I'll let you figure that out on your own by doing some quality code
staring. Hint: search for usages outside of the CPU hotplug path.

In any case, let me try to explain it to you one more time: if the core
numbers are static and don't change across physical hotplug, the cores
which share last level cache also remain the same. This is a static
property which doesn't simply change.

For example, if cores 6-11 and 34-41 have been sharing the last level
cache, then if the node containing them gets unplugged and replugged
back again - then the same cores share that exact same cache and nothing
has changed.

Except the core numbers, as you've shown. Which would be not only a
problem for the llc_shared_mask but also a big annoyance for sysadmins
and users having to realize that the topology enumeration has changed
and trying to make sense of what node went where and why isn't it the
same as when the machine booted.

So what I'm trying to say is, we should keep the core numbering stable
across hotplug to avoid unnecessary confusion; the llc_shared_mask is
just a small issue which results from not doing that.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
