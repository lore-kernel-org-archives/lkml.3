Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaJKAdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 20:33:46 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38575 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaJKAdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 20:33:45 -0400
Message-ID: <1412987622.9362.20.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 4/4] x86: Use the page tables to look up kernel
 addresses in backtrace
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: peterz@infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Fri, 10 Oct 2014 17:33:42 -0700
In-Reply-To: <1412983517-12419-5-git-send-email-andi@firstfloor.org>
References: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
	 <1412983517-12419-5-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 16:25 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> On my workstation which has a lot of modules loaded:
> 
> $ lsmod | wc -l
> 80

> This patch uses the NX bits in the page tables to check for
> valid kernel addresses instead. This can be done in any context
> because kernel page tables are not removed (if they were it could
> be handled by RCU like the user page tables)
> 
> The lookup here is 2-4 memory accesses bounded.
> 
> Anything with no NX bit set and is in kernel space is a valid
> kernel executable. Unlike the previous scheme this will also
> handle cases like the profiler hitting BIOS code or similar
> (e.g. the PCI BIOS on 32bit)
> 
> On systems without NX we fall back to the previous scheme.

For such systems, we probably could reorder fields in struct module to
reduce at one cache line per module instead of three...

offsetof(struct module, module_core)=0x138
offsetof(struct module, module_init)=0x130
offsetof(struct module, core_size)=0x144
offsetof(struct module, init_size)=0x140
offsetof(struct module, list)=0x8



