Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaE0RoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:44:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaE0RoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:44:08 -0400
Message-ID: <5384CEE4.10300@redhat.com>
Date: Tue, 27 May 2014 18:44:04 +0100
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>, viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] elf, coredump: Extract only the active register set during
 core dump
References: <1400822213-18004-1-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1400822213-18004-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 06:16 AM, Anshuman Khandual wrote:
> Regset active hooks provide a way to query how many registers in the
> register set are active at any point of time. Currently this information
> is being ignored while creating core dump sections corresponding to any
> core note register set. This way the core dump will contain data which are
> not part of the active context of the process and may not be useful. This
> patch will make sure that only the active part of the register set are
> captured during the core dump process which will reduce the core dump
> size.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
> NOTE:
> Pedro Alves has mentioned that producing smaller note sections in the core
> dump may break some existing consumers. I request suggestions, reviews and
> test reports on different architectures to prove that this patch does not
> break any existing consumer. Thank you.

Yeah, FYI, I mentioned that after noticing that ia64 does:

mainline/linux-2.6/arch/ia64/kernel/ptrace.c:

 static int
 fpregs_active(struct task_struct *target, const struct user_regset *regset)
 {
         return (target->thread.flags & IA64_THREAD_FPH_VALID) ? 128 : 32;
 }

And it's likely that tools expect fpregset_t to have a fixed size.

include/uapi/linux/elfcore.h:

 22 typedef elf_fpregset_t fpregset_t;

arch/ia64/include/asm/elf.h:

 186 typedef struct ia64_fpreg elf_fpreg_t;
 187 typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];

arch/ia64/include/asm/elf.h:

 154 #define ELF_NGREG       128     /* we really need just 72 but let's leave some headroom... */
 155 #define ELF_NFPREG      128     /* f0 and f1 could be omitted, but so what... */


I haven't done an exhaustive look over ports.

-- 
Pedro Alves

