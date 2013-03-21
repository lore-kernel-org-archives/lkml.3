Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3CUGfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:35:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38974 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3CUGfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:35:45 -0400
Date: Thu, 21 Mar 2013 15:35:37 +0900 (JST)
Message-Id: <20130321.153537.03532110.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com
Cc: akpm@linux-foundation.org, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <87d2ut2s7f.fsf@xmission.com>
References: <20130319123005.46e48e3f154acf594da5737c@linux-foundation.org>
	<20130321.125245.142520187.d.hatayama@jp.fujitsu.com>
	<87d2ut2s7f.fsf@xmission.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
Date: Wed, 20 Mar 2013 23:16:20 -0700

> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
>> From: Andrew Morton <akpm@linux-foundation.org>
>> Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
>> Date: Tue, 19 Mar 2013 12:30:05 -0700
>>
>>> On Sat, 16 Mar 2013 13:00:47 +0900 HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>>> 
>>>> Currently, read to /proc/vmcore is done by read_oldmem() that uses
>>>> ioremap/iounmap per a single page. For example, if memory is 1GB,
>>>> ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
>>>> times. This causes big performance degradation.
>>>> 
>>>> In particular, the current main user of this mmap() is makedumpfile,
>>>> which not only reads memory from /proc/vmcore but also does other
>>>> processing like filtering, compression and IO work. Update of page
>>>> table and the following TLB flush makes such processing much slow;
>>>> though I have yet to make patch for makedumpfile and yet to confirm
>>>> how it's improved.
>>>> 
>>>> To address the issue, this patch implements mmap() on /proc/vmcore to
>>>> improve read performance. My simple benchmark shows the improvement
>>>> from 200 [MiB/sec] to over 50.0 [GiB/sec].
>>> 
>>> There are quite a lot of userspace-visible vmcore changes here.  Is it
>>> all fully back-compatible?  Will all known userspace continue to work
>>> OK on newer kernels?
>>> 
>>
>> I designed it to keep backward-compatibility at least for gdb and
>> binutils but not less for makedumpfile since it should follow kernel
>> changes; old makedumpfile cannot use newer kernels, and this is within
>> the range of this review.
> 
> To the extent possible we should different versions of tools to be
> interchanged.  That helps with bug hunting and for people who are in
> resource constrained systems that build old versions of the tools that
> are tiny and fit.
> 
> Given that rounding the per cpu NOTES turns out to be a waste of memory
> I didn't see anything in the patchset that justfies any breakage.

The breakage was caused by the introduction of new NT_VMCORE_PAD to
"VMCOREINFO" name, except for which it worked fine. But it will be
dropped in the next version. It'll be no problem for some time.

The breakage was caused by makedumpfile itself due to the bug that it
had so far seen note type only, not note name. It was possible to
avoid the breakage by choosing another note name but I didn't do
it. This topic will probably arise when some kind of new note types
are needed.

Thanks.
HATAYAMA, Daisuke

