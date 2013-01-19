Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab3ASCfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 21:35:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:61063 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab3ASCfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 21:35:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,496,1355126400"; 
   d="scan'208";a="274025969"
Message-ID: <50FA0661.2060400@linux.intel.com>
Date: Fri, 18 Jan 2013 18:35:13 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mitch Bradley <wmb@laptop.org>
CC: Andres Salomon <dilinger@queued.net>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@in.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, techteam@lists.laptop.org,
        Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Techteam] [RFC PATCH] x86-32: Start out eflags and cr4 clean
References: <87sjaaj3cx.fsf@xmission.com> <1348529239-17943-1-git-send-email-hpa@linux.intel.com> <20121010125927.0968dd8b@dev.queued.net> <20130118164043.29674d75@dev.queued.net> <50F9EBEA.9020805@linux.intel.com> <50F9F152.1000907@laptop.org>
In-Reply-To: <50F9F152.1000907@laptop.org>
Content-Type: multipart/mixed;
 boundary="------------070305040801030309040305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070305040801030309040305
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 01/18/2013 05:05 PM, Mitch Bradley wrote:
> 
> 
> On 1/18/2013 2:42 PM, H. Peter Anvin wrote:
>> On 01/18/2013 04:40 PM, Andres Salomon wrote:
>>> Bad news on this patch; I've been told that it breaks booting on an
>>> XO-1.5.  Does anyone from OLPC know why yet?
>>
>> What are the settings of CR0 and CR4 on kernel entry on XO-1.5?
> 
> 
> CR0 is 0x80000011
> CR4 is 0x10
> 

OK, that makes sense... the kernel doesn't enable the PSE bit yet and I
bet that's what you're using for the non-stolen page tables.

Can we simply disable paging before mucking with CR4?  The other option
that I can see is to always enable PSE and PGE, since they are simply
features opt-ins that don't do any harm if unused.  At the same time,
though, entering the kernel through the default_entry path with paging
enabled is definitely not anything the kernel expects.

Does this patch work for you?  Since we have ditched 386 support, we can
mimic x86-64 (yay, one more difference gone!) and just use a predefined
value for %cr0 (the FPU flags need to change if we are on an FPU-less
chip, but that happens during FPU probing.)

Does this patch work for you?

	-hpa




--------------070305040801030309040305
Content-Type: text/plain; charset=UTF-8;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8e7f655..2713ea1 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -300,6 +300,11 @@ ENTRY(startup_32_smp)
 	leal -__PAGE_OFFSET(%ecx),%esp
 
 default_entry:
+#define CR0_STATE	(X86_CR0_PE | X86_CR0_MP | X86_CR0_ET | \
+			 X86_CR0_NE | X86_CR0_WP | X86_CR0_AM | \
+			 X86_CR0_PG)
+	movl $(CR0_STATE & ~X86_CR0_PG),%eax
+	movl %eax,%cr0
 /*
  *	New page tables may be in 4Mbyte page mode and may
  *	be using the global pages. 
@@ -364,8 +369,7 @@ default_entry:
  */
 	movl $pa(initial_page_table), %eax
 	movl %eax,%cr3		/* set the page table pointer.. */
-	movl %cr0,%eax
-	orl  $X86_CR0_PG,%eax
+	movl $CR0_STATE,%eax
 	movl %eax,%cr0		/* ..and set paging (PG) bit */
 	ljmp $__BOOT_CS,$1f	/* Clear prefetch and normalize %eip */
 1:

--------------070305040801030309040305--
