Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3EJKaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:30:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16994 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab3EJKaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:30:21 -0400
X-IronPort-AV: E=Sophos;i="4.87,648,1363104000"; 
   d="scan'208";a="7234628"
Message-ID: <518CCBB2.5010308@cn.fujitsu.com>
Date: Fri, 10 May 2013 18:28:02 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mm: Remove unnecessary assignment for max_pfn_mapped:q
References: <518CB758.4000101@cn.fujitsu.com> <CAE9FiQVpbDJT2Ma6MHkB5aF9PUuGCia_QaLc_LjYCLJb4nKebg@mail.gmail.com>
In-Reply-To: <CAE9FiQVpbDJT2Ma6MHkB5aF9PUuGCia_QaLc_LjYCLJb4nKebg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/10 18:29:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/10 18:29:16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月10日 17:27, Yinghai Lu 写道:
> On Fri, May 10, 2013 at 2:01 AM, Zhang Yanfei
> <zhangyanfei@cn.fujitsu.com> wrote:
>> init_memory_mapping will set max_pfn_mapped:
>> int_memory_mapping
>>   --> add_pfn_range_mapped
>>     --> max_pfn_mapped = max(max_pfn_mapped, end_pfn)
>>
>> In init_mem_mapping, before we set max_pfn_mapped to 0, we
>> have already called init_memory_mapping to setup pagetable
>> for [0, ISA_END_ADDRESS], and that sets max_pfn_mapped. So
>> the assignment to 0 is not necessary, remove it.
> 
> NAK.
> 
> for 32bit or Xen, max_pfn_mapped is set way before in head_32.S and
> xen-enlighen.

Hi Yinghai

I might be wrong, but just from the code in init_mem_mapping only:

 410         /* the ISA range is always mapped regardless of memory holes */
 411         init_memory_mapping(0, ISA_END_ADDRESS);
 412 
 413         /* xen has big range in reserved near end of ram, skip it at first.*/
 414         addr = memblock_find_in_range(ISA_END_ADDRESS, end, PMD_SIZE, PMD_SIZE);
 415         real_end = addr + PMD_SIZE;
 416 
 417         /* step_size need to be small so pgt_buf from BRK could cover it */
 418         step_size = PMD_SIZE;
 419         max_pfn_mapped = 0; /* will get exact value next */

Line 411 set max_pfn_mapped, and then line 419 set it to zero again, so
why keep the later assignment?

Thanks
Zhang
