Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaGBLdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:33:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42986 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaGBLdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:33:01 -0400
Date: Wed, 2 Jul 2014 13:32:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, huawei.libin@huawei.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH] x86,cpu-hotplug: clear llc_shared_mask at CPU hotplug
Message-ID: <20140702113253.GD1318@pd.tnic>
References: <53B3A991.2070502@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53B3A991.2070502@jp.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 03:41:21PM +0900, Yasuaki Ishimatsu wrote:
> llc_shared_mask is not cleared even if cpu is offline or hot removed.
> So when hot-plugging CPU, the mask has wrong value. The mask is used
> by CSF schduler. So it breaks CFS scheduler.
> 
> Here is a example on my system.
> My system has 4 sockets and each socket has 15 cores and HT is enabled.
> In this case, each core of sockes is numbered as follows:
> 
>          | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> Socket#2 | 30-44, 90-104
> Socket#3 | 45-59, 105-119
> 
> Then llc_shared_mask of CPU#30 has 0x3fff80000001fffc0000000.
> It means that cache of Socket#2 is shared with CPU#30-44 and 90-104.
> 
> When hot-removing socket#2 and #3, each core of sockets is numbered
> as follows:
> 
>          | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> 
> But llc_shared_mask is not cleared. So llc_shared_mask of CPU#30 remains
> having 0x3fff80000001fffc0000000.
> 
> After that, when hot-adding socket#2 and #3, each core of sockets is
> numbered as follows:
> 
>          | CPU#
> Socket#0 | 0-14 , 60-74
> Socket#1 | 15-29, 75-89
> Socket#2 | 30-59
> Socket#3 | 90-119

Ok, this doesn't make too much sense to me. Why would the readded cores
have new numbers?

Because if they kept their old numbers, you wouldn't have to correct the
LLC mask.

Shouldn't the hotplug code keep stable core ids based on APIC id and
node and whatever across physical hotplug operations?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
