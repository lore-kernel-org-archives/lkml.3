Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab3CUHHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 03:07:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36643 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3CUHHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 03:07:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <8738vp75cy.fsf@xmission.com>
	<20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
	<87ip4l1d1q.fsf@xmission.com>
	<20130321.154650.424925595.d.hatayama@jp.fujitsu.com>
Date: Thu, 21 Mar 2013 00:07:12 -0700
In-Reply-To: <20130321.154650.424925595.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Thu, 21 Mar 2013 15:46:50 +0900 (JST)")
Message-ID: <87a9pxz0wv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/2L42Msvupnc2cPfeHKx6y5XqCwt8h8ho=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
> Date: Wed, 20 Mar 2013 23:29:05 -0700
>
>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
>>>
>>> Do you mean for each range represented by each PT_LOAD entry, say:
>>>
>>>   [p_paddr, p_paddr + p_memsz]
>>>
>>> extend it as:
>>>
>>>   [rounddown(p_paddr, PAGE_SIZE), roundup(p_paddr + p_memsz, PAGE_SIZE)].
>>>
>>> not only objects in vmcore_list, but also updating p_paddr and p_memsz
>>> members themselves of each PT_LOAD entry? In other words, there's no
>>> new holes not referenced by any PT_LOAD entry since the regions
>>> referenced by some PT_LOAD entry, themselves are extended.
>> 
>> No.  p_paddr and p_memsz as exported should remain the same.
>> I am suggesting that we change p_offset.
>> 
>> I am suggesting to include the data in the file as if we had changed
>> p_paddr and p_memsz.
>> 
>>> Then, the vmcores seen from read and mmap methods are coincide in the
>>> direction of including both ranges
>>>
>>>   [rounddown(p_paddr, PAGE_SIZE), p_paddr]
>>>
>>> and
>>>
>>>   [p_paddr + p_memsz, roundup(p_paddr + p_memsz, PAGE_SIZE)]
>>>
>>> are included in both vmcores seen from read and mmap methods, although
>>> they are originally not dump target memory, which you are not
>>> problematic for ease of implementation.
>>>
>>> Is there difference here from you understanding?
>> 
>> Preserving the actual PT_LOAD segments p_paddr and p_memsz values is
>> important. p_offset we can change as much as we want.  Which means there
>> can be logical holes in the file between PT_LOAD segments, where we put
>> the extra data needed to keep everything page aligned.
>> 
>
> So, I have to make the same question again. Is it OK if two vmcores
> are different? How do you intend the ``extra data'' to be deal with? I
> mean mmap() has to export part of old memory as the ``extra data''.
>
> If you think OK, I'll fill the ``extra data'' with 0 in case of read
> method. If not OK, I'll fill with the corresponding part of old
> memory.

I think the two having different contents violates the principle of
least surprise.

I think exporting the old memory as the ``extra data'' is the least
surprising and the easiest way to go.

I don't mind filling the extra data with zero's but I don't see the
point.

Eric
