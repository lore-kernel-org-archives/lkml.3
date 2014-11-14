Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934942AbaKNB2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:28:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48377 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754AbaKNB2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:28:50 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.2.3
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20140219-2
Date: Fri, 14 Nov 2014 10:31:33 +0900 (JST)
Message-Id: <20141114.103133.364422370204110382.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: ptesarik@suse.cz, kumagai-atsushi@mxc.nes.nec.co.jp, anderson@redhat.com,
        kexec@lists.infradead.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in
 VMCOREINFO
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20141113142548.GA1978@redhat.com>
References: <20141113090657.2578f087@hananiah.suse.cz>
	<54646C1D.1050102@jp.fujitsu.com>
	<20141113142548.GA1978@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
Date: Thu, 13 Nov 2014 09:25:48 -0500

> On Thu, Nov 13, 2014 at 05:30:21PM +0900, HATAYAMA, Daisuke wrote:
>> 
>> 
>> (2014/11/13 17:06), Petr Tesarik wrote:
>> >On Thu, 13 Nov 2014 09:17:09 +0900 (JST)
>> >HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>> >
>> >>From: Vivek Goyal <vgoyal@redhat.com>
>> >>Subject: Re: [PATCH] kdump, x86: report actual value of phys_base in VMCOREINFO
>> >>Date: Wed, 12 Nov 2014 17:12:05 -0500
>> >>
>> >>>On Wed, Nov 12, 2014 at 03:40:42PM +0900, HATAYAMA Daisuke wrote:
>> >>>>Currently, VMCOREINFO note information reports the virtual address of
>> >>>>phys_base that is assigned to symbol phys_base. But this doesn't make
>> >>>>sense because to refer to value of the phys_base, it's necessary to
>> >>>>get the value of phys_base itself we are now about to refer to.
>> >>>>
>> >>>
>> >>>Hi Hatayama,
>> >>>
>> >>>/proc/vmcore ELF headers have virtual address information and using
>> >>>that you should be able to read actual value of phys_base. gdb deals
>> >>>with virtual addresses all the time and can read value of any symbol
>> >>>using those headers.
>> >>>
>> >>>So I am not sure what's the need for exporting actual value of
>> >>>phys_base.
>> >>>
>> >>
>> >>Sorry, my logic in the patch description was wrong. For /proc/vmcore,
>> >>there's enough information for makedumpdile to get phys_base. It's
>> >>correct. The problem here is that other crash dump mechanisms that run
>> >>outside Linux kernel independently don't have information to get
>> >>phys_base.
>> >
>> >Yes, but these mechanisms won't be able to read VMCOREINFO either, will
>> >they?
>> >
>> 
>> I don't intend such sophisticated function only by VMCOREINFO.
>> Search vmcore for VMCOREINFO using strings + grep before opening it by crash.
>> I intend that only here.
> 
> I think this is very crude and not proper way to get to vmcoreinfo. Can

I agree it's crude, but it's useful enough for my usecase.

> you give more context. What are those mechanisms and what are you trying
> to do.
> 

I after all write the same thing in the patch description... I mean
qemu dump, xendump (and other hypervisor dumps), firmware dumps
implemented on each vendor system for the crash dump mechanism.

But there's no prepared information now. So, crash utility has made
effort to calculate phys_base from the existing information. One
example is to check if how far linux_banner string is apart from where
it actually is in vmcore, and another is to walk page tables via CR4
register if it is included in note information of the crash dump
mechanism's environment.

There's no gurantee that these always work well. For example, because
these crash dump mechanisms run independently of Linux kernel, it
could be when CPU moves to some firmware code. Then, CR4 could point
at differnet page table.

Looking at VMCOREINFO, there's already phys_base information but it's
symbol value only and it doesn't make sense. So it should be
corrected. I think this is natural.

Also, I think it important to keep externally running crash dump
mechansms as independent as possible. If they depend on linux kernel,
it could reduce robustoness of their functionality. In case of
phys_base, if we added a mechanism to get phys_base, it would mean
that the crash dump mechisms doesn't work well until they got
phys_base. For robustness, I think it best to make Linux kernel put
necessary information anywhere and to make users to use them
independently.

--
Thanks.
HATAYAMA, Daisuke

