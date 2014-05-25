Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaEYW6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 18:58:43 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:48967 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaEYW6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 18:58:42 -0400
MIME-Version: 1.0
In-Reply-To: <CALeycy_8q9jcbwCGp6qpcN8TyH7Ve2WUxCbo+kcd_bHYzXDqOA@mail.gmail.com>
References: <CALeycy_8q9jcbwCGp6qpcN8TyH7Ve2WUxCbo+kcd_bHYzXDqOA@mail.gmail.com>
Date: Sun, 25 May 2014 17:58:40 -0500
Message-ID: <CALeycy-hH7=S5tLo1TWQTqGpwsjjx6_c3yaJZs0Vywyv-fZQaQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: get CPL from SS.DPL
From: Wei Huang <huangwei.virt@gmail.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        gleb@kernel.org, avi.kivity@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Another day, another CPL patch...
>
> It turns out that the simple approach of getting CPL from SS.DPL
> broke x86/taskswitch2.flat.  To fix that, already "imagine" that the
> CPL is CS.RPL, or 3 for VM86 tasks, while loading segment descriptors
> during task switches.  This removes the hack where task switches call
> kvm_set_rflags to override the VM flag (patch 2).

My understanding about this problem is that during task switch, the
CPL might be inconsistent with SS.DPL. This breaks the assumption
of previous patch (i.e. patch 4). To fix this problem, we have to rely
on CS.RPL to figure out CPL.

If so , my question: is there other special cases similar to task switch
which can break patch 4?

>
> While at it, add a new privilege test during task switches that is
> missing.
>
> Patch 4 is the same as before.
>
> Paolo Bonzini (4):
>   KVM: x86: use new CS.RPL as CPL during task switch
>   KVM: x86: drop set_rflags callback
>   KVM: x86: check CS.DPL against RPL during task switch
>   KVM: x86: get CPL from SS.DPL
>
>  arch/x86/include/asm/kvm_emulate.h |  1 -
>  arch/x86/include/asm/kvm_host.h    |  1 -
>  arch/x86/kvm/emulate.c             | 63 ++++++++++++++++++++++----------------
>  arch/x86/kvm/svm.c                 | 35 +++++++++------------
>  arch/x86/kvm/vmx.c                 | 24 +++------------
>  arch/x86/kvm/x86.c                 |  6 ----
>  6 files changed, 54 insertions(+), 76 deletions(-)
