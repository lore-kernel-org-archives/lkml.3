Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3KUXHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 18:07:16 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:33420 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3KUXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 18:07:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, hpa@zytor.com,
        mjg59@srcf.ucam.org, greg@kroah.com
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
Date: Thu, 21 Nov 2013 15:07:04 -0800
In-Reply-To: <1384969851-7251-1-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Wed, 20 Nov 2013 12:50:45 -0500")
Message-ID: <8761rl73s7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+SZEh702SNNnMH1H+xByySHZqEPV4uu/Y=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0391]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Current proposed secureboot implementation disables kexec/kdump because
> it can allow unsigned kernel to run on a secureboot platform. Intial
> idea was to sign /sbin/kexec binary and let that binary do the kernel
> signature verification. I had posted RFC patches for this apparoach
> here.
>
> https://lkml.org/lkml/2013/9/10/560
>
> Later we had discussion at Plumbers and most of the people thought
> that signing and trusting /sbin/kexec is becoming complex. So a 
> better idea might be let kernel do the signature verification of
> new kernel being loaded. This calls for implementing a new system call
> and moving lot of user space code in kernel.
>
> kexec_load() system call allows loading a kexec/kdump kernel and jump
> to that kernel at right time. Though a lot of processing is done in
> user space which prepares a list of segments/buffers to be loaded and
> kexec_load() works on that list of segments. It does not know what's
> contained in those segments.
>
> Now a new system call kexec_file_load() is implemented which takes
> kernel fd and initrd fd as parameters. Now kernel should be able
> to verify signature of newly loaded kernel. 
>
> This is an early RFC patchset. I have not done signature handling
> part yet. This is more of a minimal patch to show how new system
> call and functionality will look like. Right now it can only handle
> bzImage with 64bit entry point on x86_64. No EFI, no x86_32  or any
> other architecture. Rest of the things can be added slowly as need
> arises. In first iteration, I have tried to address most common use case
> for us.
>
> Any feedback is welcome.

Before you are done we need an ELF loader.  bzImage really is very
uninteresting.  To the point I am not at all convinced that an in kernel
loader should support it.

There is also a huge missing piece of this in that your purgatory is not
checking a hash of the loaded image before jumping too it.  Without that
this is a huge regression at least for the kexec on panic case.  We
absolutely need to check that the kernel sitting around in memory has
not been corrupted before we let it run very far.

Eric
