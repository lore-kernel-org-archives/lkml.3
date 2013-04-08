Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936570Ab3DHKVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:21:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935508Ab3DHKV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:21:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,431,1363104000"; 
   d="scan'208";a="7015121"
Message-ID: <51629A94.5000200@cn.fujitsu.com>
Date: Mon, 08 Apr 2013 18:23:16 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, cl@linux.com
CC: Lin Feng <linfeng@cn.fujitsu.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, yinghai@kernel.org, catalin.marinas@arm.com,
        will.deacon@arm.com, arnd@arndb.de, tony@atomide.com,
        ben@decadent.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 1/2] mm: vmemmap: x86: add vmemmap_verify check for hot-add
 node case
References: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com> <1365415000-10389-2-git-send-email-linfeng@cn.fujitsu.com>
In-Reply-To: <1365415000-10389-2-git-send-email-linfeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/08 18:20:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/08 18:20:20,
	Serialize complete at 2013/04/08 18:20:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On 04/08/2013 05:56 PM, Lin Feng wrote:
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 474e28f..e2a7277 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1318,6 +1318,8 @@ vmemmap_populate(struct page *start_page, unsigned long size, int node)
>  			if (!p)
>  				return -ENOMEM;
>  
> +			vmemmap_verify((pte_t *)p, node, addr, addr + PAGE_SIZE);
> +
>  			addr_end = addr + PAGE_SIZE;
>  			p_end = p + PAGE_SIZE;
>  		} else {
IIUC it seems that the original 'p_end = p + PAGE_SIZE' assignment is buggy, because:

1309                 if (!cpu_has_pse) {
1310                         next = (addr + PAGE_SIZE) & PAGE_MASK;
1311                         pmd = vmemmap_pmd_populate(pud, addr, node);
1312 
1313                         if (!pmd)
1314                                 return -ENOMEM;
1315 
1316                         p = vmemmap_pte_populate(pmd, addr, node);
1317 
1318                         if (!p)
1319                                 return -ENOMEM;
1320 
1321                         addr_end = addr + PAGE_SIZE;
1322                         p_end = p + PAGE_SIZE;

The return value of vmemmap_pte_populate() is the virtual address of pte, not the allocated
virtual address, which is different from vmemmap_alloc_block_buf() in cpu_has_pse case, so
the addition PAGE_SIZE in !cpu_has_pse case is nonsense.

Or am I missing something?

thanks,
linfeng
