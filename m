Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965628Ab3FTOFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:05:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965398Ab3FTOFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:05:52 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4s8J-J0asxEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PLU82PbcHHgA:10 a=Enxo2lYeooLkX8JhCscA:9 a=QEXdDO2ut3YA:10 a=Ap5v-NcH9Ogw44nc:21 a=_ks93BZrIAGNgFaB:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371737149.18733.92.camel@gandalf.local.home>
Subject: Re: Oops in ring_buffer_alloc_read_page()
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 20 Jun 2013 10:05:49 -0400
In-Reply-To: <20130618120855.GA29700@localhost>
References: <20130618120855.GA29700@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-18 at 20:08 +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below oops in upstream. It's a hard to reproduce one and at
> least is as old as v3.0.
> 
> [   36.774933] IP: [<7916a472>] ring_buffer_alloc_read_page+0x66/0x82
> [   36.776024] *pde = 0e3e1067 *pte = 061e7260 
> [   36.776024] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> [   36.776024] CPU: 0 PID: 44 Comm: rb_consumer Not tainted 3.10.0-rc4-00292-gbed1059 #29
> [   36.776024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   36.776024] task: 7e3a5000 ti: 7e3a8000 task.ti: 7e3a8000
> [   36.776024] EIP: 0060:[<7916a472>] EFLAGS: 00010246 CPU: 0
> [   36.776024] EIP is at ring_buffer_alloc_read_page+0x66/0x82
> [   36.776024] EAX: 7e1e7000 EBX: 0000feaf ECX: 00000000 EDX: 00000000
> [   36.776024] ESI: 7e3a5000 EDI: 00000000 EBP: 7e3a9ed0 ESP: 7e3a9ecc
> [   36.776024]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   36.776024] CR0: 8005003b CR2: 7e1e7008 CR3: 05beb000 CR4: 00000690
> [   36.776024] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   36.776024] DR6: ffff0ff0 DR7: 00000400
> [   36.776024] Stack:
> [   36.776024]  00000000 7e3a9f00 7916abae 00000001 00000001 7e1e7000 ffffffff 00000ff0
> [   36.776024]  00000ff0 00000000 00000000 7e3a5000 00000000 7e3a9f30 7916b38c 00000000
> [   36.776024]  003a9f14 7e3a5000 00000000 00000000 0670d10e 00000004 00000000 7916b191
> [   36.776024] Call Trace:
> [   36.776024]  [<7916abae>] read_page+0x25/0x608
> [   36.776024]  [<7916b38c>] ring_buffer_consumer_thread+0x1fb/0x549
> 
> git bisect  bad c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1  # 12:28      0-  Linux 3.9
> git bisect  bad 19f949f52599ba7c3f67a5897ac6be14bfcb1200  # 12:28      0-  Linux 3.8
> git bisect  bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e  # 12:28      0-  Linux 3.7
> git bisect  bad a0d271cbfed1dd50278c6b06bead3d00ba0a88f9  # 12:29      0-  Linux 3.6
> git bisect  bad 28a33cbc24e4256c143dce96c7d93bf423229f92  # 12:31    179-  Linux 3.5
> git bisect  bad 76e10d158efb6d4516018846f60c2ab5501900bc  # 20:58   3174-  Linux 3.4
> git bisect  bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7  # 15:59  21714-  Linux 3.3
> git bisect  bad 805a6af8dba5dfdd35ec35dc52ec0122400b2610  # 16:20   2591-  Linux 3.2
> git bisect  bad c3b92c8787367a8bb53d57d9789b558f1295cc96  # 20:15   6321-  Linux 3.1
> git bisect  bad 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe  # 05:29  11960-  Linux 3.0
> git bisect  bad 8177a9d79c0e942dcac3312f15585d0344d505a5  # 06:23    493-  lseek(fd, n, SEEK_END) does *not* go to eof - n
> 

Looking at the dmesg you supplied:

[   36.745552] CPA self-test:
[   36.749335]  4k 65534 large 0 gb 0 x 65534[78000000-87ffd000] miss 0
[   36.773159] BUG: unable to handle kernel paging request at 7e1e7008
[   36.774933] IP: [<7916a472>] ring_buffer_alloc_read_page+0x66/0x82
[   36.776024] *pde = 0e3e1067 *pte = 061e7260 
[   36.776024] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC


The ring buffer stress test runs continuously when compiled into the
core kernel. It constantly consumes from a test buffer and replenishes
the pages with:

void *ring_buffer_alloc_read_page(struct ring_buffer *buffer, int cpu)
{
	struct buffer_data_page *bpage;
	struct page *page;

	page = alloc_pages_node(cpu_to_node(cpu),
				GFP_KERNEL | __GFP_NORETRY, 0);
	if (!page)
		return NULL;

	bpage = page_address(page);

	rb_init_page(bpage);

	return bpage;
}

Which looks to be where the crash occurred. What caught my eye was that
"CPA self-test" just before the crash. That comes from pageattr_test()
in arch/x86/mm/pageattr-test.c. The comment just above that code is:

/* Change the global bit on random pages in the direct mapping */

Could this test affect the alloc_pages_node() or the page_address() used
in ring_buffer_alloc_read_page()? If so, that may be the cause of this
bug.

-- Steve


