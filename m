Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3H2XiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:38:01 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:56233 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab3H2Xh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:37:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, vgoyal@redhat.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6>
	<521F5297.4070906@linux.intel.com>
Date: Thu, 29 Aug 2013 16:37:44 -0700
In-Reply-To: <521F5297.4070906@linux.intel.com> (H. Peter Anvin's message of
	"Thu, 29 Aug 2013 06:54:31 -0700")
Message-ID: <8738ps131z.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+jeY2lC0W8FP3MJoU89ZdO9A1kDfJbgkI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0134]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@linux.intel.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/2] x86, apic: Disable BSP if boot cpu is AP
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@linux.intel.com> writes:

> On 08/29/2013 02:27 AM, HATAYAMA Daisuke wrote:
>> This is the patch series to address the issue that kdump 2nd kernel
>> now fails to wake up multiple CPUs.
>
> Please explain the "now" in the above sentence.  Is this a regression?
> If so, what is its fimpact?

This is not a regression.

>  Is this something that needs to go into 3.11
> as a post-rc7 change, which means it better be hyper-critical?

No.  This is something that does not need to go into 3.11.

This situation is people who run machines of unreasonable size really
would like to use multiple cpus when generating crash dumps.  A
practical problem with that desire is that sending a (startup? init? I
forget which) IPI to a processor with the BSP flag sent triggers that
processor to load code from 0xfffffff0 instead of the vector specified
in the IPI.  At which point the processor which jumped to 0xfffffff0 and
is running BIOS code does not call into the kernel so never comes up
which is unfortunate, and worse almost always triggers a soft reset by
writing hardware registers.

Which means the practical way to avoid this sort of thing is not to send
init/startup IPIs to processors with the BSP bit set.  Which MPtables
and ACPI tables should denote as the boot processor.

In a previous attack on this problem we explored if it was possible to
clear the BSP bit and be able to use all processors but that does not
work.  I think it was actually your suggestion that we just skip the
BSP.

Anyway this long simmering issue has raised it's head again and we have
iron-clad evidence that the only thing people can do is avoid the
problem so this is a patchset to allow people who wind up in a
situtation where they are not booting on the bootstrap processor to to
avoid problems, and use as many of their other processors as possible.

Which should make people with boxes of unusual size happy.

Eric
