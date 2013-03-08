Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364Ab3CHQNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:13:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57517 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933473Ab3CHQNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:13:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Ma\, Jingbai \(Kingboard\)" <kingboard.ma@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        "kumagai-atsushi\@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        "yinghai\@kernel.org" <yinghai@kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Mitchell\, Lisa \(MCLinux in Fort Collins\)" <lisa.mitchell@hp.com>
References: <CD6006EB.36EC%kingboard.ma@hp.com>
Date: Fri, 08 Mar 2013 08:13:31 -0800
In-Reply-To: <CD6006EB.36EC%kingboard.ma@hp.com> (Jingbai Ma's message of
	"Fri, 8 Mar 2013 13:31:51 +0000")
Message-ID: <87r4jpoono.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/D3Rz2J3SCztRJjeQKzQHVrO4j/fvuAbI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Ma\, Jingbai \(Kingboard\)" <kingboard.ma@hp.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel to speedup kernel dump process
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ma, Jingbai (Kingboard)" <kingboard.ma@hp.com> writes:

> On 3/8/13 6:33 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>
>>On 03/08/2013 02:06 AM, Jingbai Ma wrote:
>>> 
>>> Kernel do have some abilities that user space haven't. It's possible to
>>> map whole memory space of the first kernel into user space on the second
>>> kernel. But the user space code has to re-implement some parts of the
>>> kernel memory management system again. And worse, it's architecture
>>> dependent, more architectures supported, more codes have to be
>>> implemented. All implementation in user space must be sync to kernel
>>> implementation. It's may called "flexibility", but it's painful to
>>> maintain the codes.
>>> 
>>
>>What?  You are basically talking about /dev/mem... there is nothing
>>particularly magic about it at all.
>
> What we are talking about is filtering memory pages (AKA memory pages
> classification)
> The makedumpfile (or any other dumper in user space) has to know the
> exactly
> memory layout of the memory management data structures, it not only
> architecture dependent, but also may varies in different kernel release.
> At this point, /dev/mem doesn't give any help.
> So IMHO, I would like to do it in kernel, rather than So keep tracking
> changes in user space code.

But the fact is there is no requirment that the crash dump capture
kernel is the same version as the kernel that crashed.  In fact it has
been common at some points in time to use slightly different build
options, or slightly different kernels.  Say a 32bit PAE kernel to
capture a 64bit x86_64 kernel.

So in fact performing this work in the kernel and is actively harmful to
reliability and maintenance because it adds an incorrect assumption.

If you do want the benefit of shared maintenance with the kernel one
solution that has been suggested several times is to put code into
tools/makedumpfile (probably a library) that encapsulates the kernel
specific knowledge that can be loaded into the ramdisk when the
crahsdump kernel is being loaded.

That would allow shared maintenance along without breaking the
possibility of supporting kernel versions.

Eric
