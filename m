Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab3J2T0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:26:36 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52396 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3J2T0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:26:32 -0400
Message-ID: <52700C24.9050001@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 00:57:32 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Tim Gardner <tim.gardner@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com> <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com>
In-Reply-To: <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102919-4790-0000-0000-00000B15325E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Greg/AI too since we touch debugfs code.
[...]
 >>
>> sudo modprobe kvm_amd
>> modprobe: ERROR: could not insert 'kvm_amd': Bad address
>
> "Bad address"? Christ people, are you guys making up error numbers
> with some kind of dice-roll? I can just see it now, somebody sitting
> there with a D20, playing some kind of kernel-specific D&D, and
> rolling a ten means that you get to slay the orc, and pick an error
> number of EFAULT for some random kernel function. Because quite
> frankly, "random dice roll" is the _only_ thing that explains "Bad
> address" sufficiently.
>
> Please, whoever wrote virt/kvm/kvm_main.c:: kvm_init_debug(), WTF?
> EFAULT means "user passed in an invalid virtual address pointer",
> which is why the error string is "Bad address". It makes absolutely NO
> SENSE here. Perhaps EEXIST or EBUSY.
>

Right. In current scenario it should have been EEXIST :(.

debugfs_create_dir() currently returns NULL dentry on both
EEXIST, ENOMEM ... cases.

Could one solution be cascading actual error
that is lost in fs/debugfs/inode.c:__create_file(), so that we could
take correct action in case of failure of debugfs_create_dir()?

(ugly side is we increase total number of params for __create_file to
6). or I hope there could be some better solution.

