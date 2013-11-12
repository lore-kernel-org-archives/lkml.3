Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3KLOag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:30:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60315 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3KLOac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:30:32 -0500
Date: Tue, 12 Nov 2013 15:30:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: paulus@samba.org, Ingo Molnar <mingo@redhat.com>, acme@ghostprotocols.net,
        kernel-br <kernel-br@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Coverity 1128445 - Reliance on integer endianness
Message-ID: <20131112143024.GR5056@laptop.programming.kicks-ass.net>
References: <CAGG-pUQrN6D_iSsWVptjQSA4B_oGn5NhbhBp+aLT0GJCFSmYRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG-pUQrN6D_iSsWVptjQSA4B_oGn5NhbhBp+aLT0GJCFSmYRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 12:19:13PM -0200, Geyslan Gregório Bem wrote:
> Hi,
> 
> Coverity detected in 'arch/x86/kernel/cpu/perf_event_intel_uncore.c' a
> possible reliance on integer endianness. Is that a positive one?
> 
> static u64 ivt_uncore_irp_read_counter(struct intel_uncore_box *box,
> struct perf_event *event)
> 1369{
> 1370        struct pci_dev *pdev = box->pci_dev;
> 1371        struct hw_perf_event *hwc = &event->hw;
> 1372        u64 count = 0;
> 1373
> 
> CID 1128445 (#1 of 1): Reliance on integer endianness
> (INCOMPATIBLE_CAST)incompatible_cast: Pointer "&count" points to an
> object whose effective type is "unsigned long long" (64 bits,
> unsigned) but is dereferenced as a narrower "unsigned int" (32 bits,
> unsigned). This may lead to unexpected results depending on machine
> endianness.[show details]
> 
> 1374        pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx],
> (u32 *)&count);
> 1375        pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx]
> + 4, (u32 *)&count + 1);
> 1376
> 1377        return count;
> 1378}

Right, its a bit ugly but since its all arch code (x86) we can indeed
assume endianness (little).

So yes Coverity is right but we can also ignore it since machine
endianness is fixed here.

The code loads the u64 in two pci dword reads and assumes the high dword
lives at the higher address, this is correct for little endian.
