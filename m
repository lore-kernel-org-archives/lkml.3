Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab3CSVWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:22:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44784 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab3CSVWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:22:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, vgoyal@redhat.com,
        cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	<20130316040228.15064.28019.stgit@localhost6.localdomain6>
	<20130319130229.fe83c985678146980ecc6102@linux-foundation.org>
Date: Tue, 19 Mar 2013 14:22:22 -0700
In-Reply-To: <20130319130229.fe83c985678146980ecc6102@linux-foundation.org>
	(Andrew Morton's message of "Tue, 19 Mar 2013 13:02:29 -0700")
Message-ID: <87fvzrozjl.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18VaNab0ZOIXr6d1BPl0hMvmJynKIznK2M=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Sat, 16 Mar 2013 13:02:29 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>
>> If there's some vmcore object that doesn't satisfy page-size boundary
>> requirement, remap_pfn_range() fails to remap it to user-space.
>> 
>> Objects that posisbly don't satisfy the requirement are ELF note
>> segments only. The memory chunks corresponding to PT_LOAD entries are
>> guaranteed to satisfy page-size boundary requirement by the copy from
>> old memory to buffer in 2nd kernel done in later patch.
>> 
>> This patch doesn't copy each note segment into the 2nd kernel since
>> they amount to so large in total if there are multiple CPUs. For
>> example, current maximum number of CPUs in x86_64 is 5120, where note
>> segments exceed 1MB with NT_PRSTATUS only.
>
> I don't really understand this.  Why does the number of or size of
> note segments affect their alignment?
>
>> --- a/fs/proc/vmcore.c
>> +++ b/fs/proc/vmcore.c
>> @@ -38,6 +38,8 @@ static u64 vmcore_size;
>>  
>>  static struct proc_dir_entry *proc_vmcore = NULL;
>>  
>> +static bool support_mmap_vmcore;
>
> This is quite regrettable.  It means that on some kernels/machines,
> mmap(vmcore) simply won't work.  This means that people might write
> code which works for them, but which will fail for others when deployed
> on a small number of machines.
>
> Can we avoid this?  Why can't we just copy the notes even if there are
> a large number of them?

Yes.  If it simplifies things I don't see a need to support mmapping
everything.  But even there I don't see much of an issue.

Today we allocate a buffer to hold the ELF header program headers and
the note segment, and we could easily allocate that buffer in such a way
to make it mmapable.

Eric
