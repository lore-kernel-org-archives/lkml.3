Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3CSXQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:16:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:33258 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3CSXQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:16:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
References: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
Date: Tue, 19 Mar 2013 16:16:25 -0700
In-Reply-To: <20130316040003.15064.62308.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Sat, 16 Mar 2013 13:00:47 +0900")
Message-ID: <87ip4nj7zq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19XxfLJmsyAhC5Bsxwz3J3VwwCG/9AviEE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 00/21] kdump, vmcore: support mmap() on /proc/vmcore
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> Currently, read to /proc/vmcore is done by read_oldmem() that uses
> ioremap/iounmap per a single page. For example, if memory is 1GB,
> ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
> times. This causes big performance degradation.
>
> In particular, the current main user of this mmap() is makedumpfile,
> which not only reads memory from /proc/vmcore but also does other
> processing like filtering, compression and IO work. Update of page
> table and the following TLB flush makes such processing much slow;
> though I have yet to make patch for makedumpfile and yet to confirm
> how it's improved.
>
> To address the issue, this patch implements mmap() on /proc/vmcore to
> improve read performance. My simple benchmark shows the improvement
> from 200 [MiB/sec] to over 50.0 [GiB/sec].

I am in favor of this direction and the performance and other gains look
good.

I am not in favor of the ABI changes nor of the nearly order of
magnitude memory usage increase for elf notes by rounding everything up
to a page size boundary.

As a general note it is possible to support mmaping any partial page
by just rounding inside of your mmap function so you should not need to
copy partial pages.

If you don't want the memory overhead of merging the ELF notes in memory
in the second kernel you can simply require that the ELF header, the ELF
program header, and the PT_NOTE section be read from /proc/vmcore
instead of mmaped.

I did the math and with your changes to note generation in the worst
case you are reserving 20MiB in the first kernel to replace a 1.6MiB
with a 240KiB allocation in the second kernel.  That is the wrong
tradeoff, especially when you require an ABI change at the same time,
and the 5120+ entries in vmcore_list will likely measurably slow down
setting up your mappings with mmap.

Eric
