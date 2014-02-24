Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaBXQcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:32:32 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:42379 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaBXQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:32:30 -0500
Date: Mon, 24 Feb 2014 11:34:30 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
In-Reply-To: <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402211521040.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402211732290.11615@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402212342090.17416@vincent-weaver-1.um.maine.edu>
 <53084317.4090304@zytor.com> <alpine.DEB.2.10.1402230012260.18252@vincent-weaver-1.um.maine.edu> <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com> <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu> <530AD71E.50800@zytor.com> <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Vince Weaver wrote:

> Just touching the mmap page with a write of a single byte (it doesn't 
> matter where) is enough to trigger the bug.

OK, investigating this more.

     perf_fuzzer-2971  [000]   154.944114: page_fault_user:       address=0xf7729000 ip=0x41efab error_code=0x6
     perf_fuzzer-2971  [000]   154.944118: function:              ip=0xffffffff810d40e7 parent_ip=0xffffffff810d0840
     perf_fuzzer-2971  [000]   154.944119: function:              ip=0xffffffff812a91a5 parent_ip=0xffffffff81013ff5
     perf_fuzzer-2971  [000]   154.944120: function:              ip=0xffffffff8153837c parent_ip=0xffffffff81535432
     perf_fuzzer-2971  [000]   154.944121: page_fault_kernel:     address=0x22e0 ip=0xffffffff812a7d5c error_code=0x0

It looks like there are two page faults.  The first is caused by the user
code accessing the mmap'd page.  It looks sort of normal and what you'd
expect if the perf_event mmap ring buffer is being accessed for the first
time.

What follows is a kernel page fault, and this is the one where for 
whatever reason CR2 has obtained the value of the userspace RBP register.

Vince


