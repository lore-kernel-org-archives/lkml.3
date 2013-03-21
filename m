Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab3CUG3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:29:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44491 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab3CUG3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:29:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <87txo5bxk4.fsf@xmission.com>
	<20130321.122501.82758179.d.hatayama@jp.fujitsu.com>
	<8738vp75cy.fsf@xmission.com>
	<20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
Date: Wed, 20 Mar 2013 23:29:05 -0700
In-Reply-To: <20130321.151428.393714972.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Thu, 21 Mar 2013 15:14:28 +0900 (JST)")
Message-ID: <87ip4l1d1q.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18522GwLrvrtUNgkVpHHs5MAQVvqBuVA2M=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
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
>
> Do you mean for each range represented by each PT_LOAD entry, say:
>
>   [p_paddr, p_paddr + p_memsz]
>
> extend it as:
>
>   [rounddown(p_paddr, PAGE_SIZE), roundup(p_paddr + p_memsz, PAGE_SIZE)].
>
> not only objects in vmcore_list, but also updating p_paddr and p_memsz
> members themselves of each PT_LOAD entry? In other words, there's no
> new holes not referenced by any PT_LOAD entry since the regions
> referenced by some PT_LOAD entry, themselves are extended.

No.  p_paddr and p_memsz as exported should remain the same.
I am suggesting that we change p_offset.

I am suggesting to include the data in the file as if we had changed
p_paddr and p_memsz.

> Then, the vmcores seen from read and mmap methods are coincide in the
> direction of including both ranges
>
>   [rounddown(p_paddr, PAGE_SIZE), p_paddr]
>
> and
>
>   [p_paddr + p_memsz, roundup(p_paddr + p_memsz, PAGE_SIZE)]
>
> are included in both vmcores seen from read and mmap methods, although
> they are originally not dump target memory, which you are not
> problematic for ease of implementation.
>
> Is there difference here from you understanding?

Preserving the actual PT_LOAD segments p_paddr and p_memsz values is
important. p_offset we can change as much as we want.  Which means there
can be logical holes in the file between PT_LOAD segments, where we put
the extra data needed to keep everything page aligned.

Eric
