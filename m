Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636AbaIZV2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:28:47 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:33742 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755763AbaIZV2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:28:46 -0400
Message-ID: <5425DA8A.1030500@nexus-software.ie>
Date: Fri, 26 Sep 2014 22:28:42 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, davej@redhat.com,
        boon.leong.ong@intel.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Quark: Add if/else to setup_arch for Quark TLB
 bug
References: <1411754118-11665-1-git-send-email-pure.logic@nexus-software.ie> <20140926205955.GA22407@khazad-dum.debian.net>
In-Reply-To: <20140926205955.GA22407@khazad-dum.debian.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/14 21:59, Henrique de Moraes Holschuh wrote:

> I'm confused, now.
>
> Wasn't the other patch -- which just added a comment -- the one selected as
> a better fix, because there is absolutely no point in calling __flush_tlb()
> on Quark X1000 *right after* you just flushed the TLB [on these processors]
> by doing a load_cr3() ?
>
> Should this one ([PATCH v2] x86: Quark: Add if/else to setup_arch for Quark
> TLB bug) be ignored?  Or should the other one which just adds a comment be
> ignored?

Hi Henrique.

My view is that the CR3 load should have flushed the TLB in it's entirety.

Ong Boong Leong said that a discussion he had which included HPA 
concluded with a flush of the TLB being required after the CR3 reload.

The current code

a) Writes to CR3.
On Quark that will flush the entire TLB
Ref: Quark SoC X1000 Core Developer's Manual section 6.4.11

On other processors this won't invalidate the entire TLB under every 
scenario. For example a PTE with PGE on may not be flushed.

Ref: Intel 64 and IA32 Architectures .. vol (3a, 3b, 3c) 325384.pdf 
section 4.10.4.1

b) __flush_tlb_all
Depending on the value of cpu_has_pge() - which will be true for ~all 
x86 processors will call

native_write_cr4(cr4 & ~X86_CR4_PGE);

According to the same section "4.10.4.1" this will nuke the rest of the 
TLB entries even with PGE bits set in the PTEs

So the steps a & b are the appropriate sets to take to entirely flush 
the TLB for most processors i.e. one's that support PGE

The suggestion is that on Quark we should flush the TLB again.

The documentation doesn't really support that statement but, my view is 
OK if we are going to accommodate that position let's not force a third 
TLB flush on everybody who isn't running a Quark.

 From the technical/documentation standpoint I don't think Quark is 
forcing a step c - if we do decide to add a __flush_tlb() call for the 
sake of Quark anyway - then let's not foist the extra cycles on every 
other x86 processor out there.

My preference is

1. Just comment the code as is to explain why it works for Quark.

If that's not good enough for people then

2. if/else the flow so that Quark does __flush_tlb() and the rest of the 
world does a __flush_tlb_all()


--
BOD
