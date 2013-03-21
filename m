Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3CUGq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:46:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53532 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab3CUGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:46:54 -0400
Date: Thu, 21 Mar 2013 15:46:50 +0900 (JST)
Message-Id: <20130321.154650.424925595.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify
 mmap()'s page-size boundary requirement
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <87ip4l1d1q.fsf@xmission.com>
References: <8738vp75cy.fsf@xmission.com>
	<20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
	<87ip4l1d1q.fsf@xmission.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
Date: Wed, 20 Mar 2013 23:29:05 -0700

> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
>>
>> Do you mean for each range represented by each PT_LOAD entry, say:
>>
>>   [p_paddr, p_paddr + p_memsz]
>>
>> extend it as:
>>
>>   [rounddown(p_paddr, PAGE_SIZE), roundup(p_paddr + p_memsz, PAGE_SIZE)].
>>
>> not only objects in vmcore_list, but also updating p_paddr and p_memsz
>> members themselves of each PT_LOAD entry? In other words, there's no
>> new holes not referenced by any PT_LOAD entry since the regions
>> referenced by some PT_LOAD entry, themselves are extended.
> 
> No.  p_paddr and p_memsz as exported should remain the same.
> I am suggesting that we change p_offset.
> 
> I am suggesting to include the data in the file as if we had changed
> p_paddr and p_memsz.
> 
>> Then, the vmcores seen from read and mmap methods are coincide in the
>> direction of including both ranges
>>
>>   [rounddown(p_paddr, PAGE_SIZE), p_paddr]
>>
>> and
>>
>>   [p_paddr + p_memsz, roundup(p_paddr + p_memsz, PAGE_SIZE)]
>>
>> are included in both vmcores seen from read and mmap methods, although
>> they are originally not dump target memory, which you are not
>> problematic for ease of implementation.
>>
>> Is there difference here from you understanding?
> 
> Preserving the actual PT_LOAD segments p_paddr and p_memsz values is
> important. p_offset we can change as much as we want.  Which means there
> can be logical holes in the file between PT_LOAD segments, where we put
> the extra data needed to keep everything page aligned.
> 

So, I have to make the same question again. Is it OK if two vmcores
are different? How do you intend the ``extra data'' to be deal with? I
mean mmap() has to export part of old memory as the ``extra data''.

If you think OK, I'll fill the ``extra data'' with 0 in case of read
method. If not OK, I'll fill with the corresponding part of old
memory.

Thanks.
HATAYAMA, Daisuke

