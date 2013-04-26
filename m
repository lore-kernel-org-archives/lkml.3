Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3DZPLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:11:38 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:53922 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3DZPLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:11:37 -0400
Message-ID: <1366989094.8964.212.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support
 BPF_S_ANC_SECCOMP_LD_W instruction
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Apr 2013 08:11:34 -0700
In-Reply-To: <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
	 <1366962706-24204-3-git-send-email-xi.wang@gmail.com>
	 <1366985926.8964.190.camel@edumazet-glaptop>
	 <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 10:50 -0400, Xi Wang wrote:
> On Fri, Apr 26, 2013 at 10:18 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Fri, 2013-04-26 at 03:51 -0400, Xi Wang wrote:
> >
> >> +#ifdef CONFIG_SECCOMP_FILTER
> >> +                     case BPF_S_ANC_SECCOMP_LD_W:
> >> +                             if (K == offsetof(struct seccomp_data, arch)) {
> >> +                                     int arch = syscall_get_arch(current, NULL);
> >> +
> >> +                                     EMIT1_off32(0xb8, arch); /* mov arch,%eax */
> >> +                                     break;
> >> +                             }
> >> +                             func = (u8 *)seccomp_bpf_load;
> >> +                             t_offset = func - (image + addrs[i]);
> >> +                             EMIT1_off32(0xbf, K); /* mov imm32,%edi */
> >> +                             EMIT1_off32(0xe8, t_offset); /* call seccomp_bpf_load */
> >> +                             break;
> >> +#endif
> >
> > This seems seriously wrong to me.
> 
> Can you elaborate?
> 
> > This cannot have been tested at all.
> 
> Thanks to QEMU for hiding bugs then. :)



1) 'current' at the time the code is jitted (compiled) is not the
'current' at the time the filter will be evaluated.

On x86_64, if CONFIG_IA32_EMULATION=y, syscall_get_arch() evaluates to :

if (task_thread_info(task)->status & TS_COMPAT)
	return AUDIT_ARCH_I386;
return AUDIT_ARCH_X86_64;

So your code is completely wrong.

2) Calling a function potentially destroys some registers.
   %rdi,%r8,%r9 for instance, so we are going to crash very easily.

I dont know, I feel a bit uncomfortable having to explain this to
someone sending security related patches...




