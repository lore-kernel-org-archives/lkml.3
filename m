Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3AKU1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:27:09 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:36328 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3AKU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:27:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>,
        "xen-devel\@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "x86\@kernel.org" <x86@kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo\@redhat.com" <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>,
        "maxim.uvarov\@oracle.com" <maxim.uvarov@oracle.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>
References: <50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>
	<50E41973.9050705@citrix.com>
	<20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
	<50E6F81D02000078000B3245@nat28.tlf.novell.com>
	<20130104170751.GB3472@host-192-168-1-59.local.net-space.pl>
	<20130104191146.GC6721@phenom.dumpdata.com>
	<20130107123404.GA2927@host-192-168-1-59.local.net-space.pl>
	<20130107162018.GJ3219@phenom.dumpdata.com>
	<87ehhsqrpr.fsf@xmission.com>
	<20130111165506.GD25620@phenom.dumpdata.com>
Date: Fri, 11 Jan 2013 12:26:56 -0800
In-Reply-To: <20130111165506.GD25620@phenom.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Fri, 11 Jan 2013 11:55:06 -0500")
Message-ID: <87k3rjtqi7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+fJQ3iFBmT7F7Ao5iq/kAY+Zyb6KxzNy0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> On Thu, Jan 10, 2013 at 08:16:48PM -0800, Eric W. Biederman wrote:

>> The basic kexec interface is.
>> 
>> load ranges of virtual addresses physical addresses.
>> jump to the physical address  with identity mapped page tables.
>> 
>> There are a few flags to allow for different usage scenarios like
>> kexec on panic vs normal kexec.
>
> And there is nothing fancy to be done for EFI and SecureBoot?

There is a mess with EFI.  Reports are that EFI is a bug ridden pile,
and people keep advocating that we make more and more EFI calls in the
main kernel.  There is an argument over set_virtual_mapping, which is a
call that can be made only once which relocates the EFI code to a
different address, which makes life inconvient for kexec.  There is
another argument that EFI doesn't actually work if you don't make the
set_virtual_mapping call so we can't remove it and always use physical
addresses.

Frankly the only sane way to run a linux kernel under EFI is to scrape
up the information needed to talk to the hardware directly and ignore
EFI.  That is what we have historically done in the face of BIOS madness
and if anything the situation is worse with EFI, but it looks like we
are going to have to learn that the hard way.

Recently there is a desire to figure out how to /sbin/kexec support
signed kernel images.  What will probably happen is to have a specially
trusted userspace application perform the verification.  Sort of like
dom0 for the linux userspace.  A few other ideas have been batted around
but none that have stuck.

None of that is really about SecureBoot.  It is all trusting the kernel
binary but not trusting userspace.  With SecureBoot being an excuse for
coming up with a policy like that.

It looks like the answer to SecureBoot at this point may simply be just
reconfigure your BIOS or root Windows and EFI to get the hardware to do
what you want.

So the answer for looking forward for Xen dom0 is: A trusted /sbin/kexec
won't require changes.  The other suggest solution is a flag that says a
specific chunk of the loaded image is a signature that the magic trust
faires can verify.  As long as you have a flag bit free you should be
able to implement that policy if we ever implement it.

Eric
