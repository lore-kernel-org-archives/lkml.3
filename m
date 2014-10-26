Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaJZQqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:46:08 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54725 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaJZQqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:46:06 -0400
Message-ID: <1414341964.5609.3.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: vmalloced stacks on x86_64?
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 Oct 2014 09:46:04 -0700
In-Reply-To: <544B0D22.2070509@zytor.com>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
	 <544B0D22.2070509@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-24 at 19:38 -0700, H. Peter Anvin wrote:
> On 10/24/2014 05:22 PM, Andy Lutomirski wrote:
> > Is there any good reason not to use vmalloc for x86_64 stacks?
> 
> Additional TLB pressure if anything else.

It seems TLB pressure gets less and less interest these days...

Is it still worth trying to reduce it ?

I was wondering for example why 'hashdist' is not cleared if current
host runs a NUMA enabled kernel, but has a single node.

Something like following maybe ?

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7dbe5ec9d9cd08afac13797e2adac291fb703eec..0846ef054b0620a7be0c6f69b1a2f21c78d57d3b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1181,7 +1181,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	hashdist=	[KNL,NUMA] Large hashes allocated during boot
 			are distributed across NUMA nodes.  Defaults on
 			for 64-bit NUMA, off otherwise.
-			Format: 0 | 1 (for off | on)
+			Format: 0 | 1 | 2 (for off | on if NUMA host | on)
 
 	hcl=		[IA-64] SGI's Hardware Graph compatibility layer
 
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 1a883705a12a8a12410914be93b2ee65807cc423..8aded4c11c8c1cc5778e9ae2b9cd5146070b5b03 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -668,7 +668,8 @@ static int __init dummy_numa_init(void)
 
 	node_set(0, numa_nodes_parsed);
 	numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
-
+	if (hashdist == HASHDIST_DEFAULT)
+		hashdist = 0;
 	return 0;
 }
 


