Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3GXVFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:05:22 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:61591 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840Ab3GXVFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:05:15 -0400
Message-ID: <1374699912.29835.8.camel@x61.thuisdomein>
Subject: Re: compile x86_64 waring
From: Paul Bolle <pebolle@tiscali.nl>
To: Jianpeng Ma <majianpeng@gmail.com>, Tom Rini <trini@ti.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Jul 2013 23:05:12 +0200
In-Reply-To: <201307051956052638321@gmail.com>
References: <201307051956052638321@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2013 21:05:13.0404 (UTC) FILETIME=[7D5B2FC0:01CE88B1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Tom and Rusty because they might be able to say what's really
going on here.]

On Fri, 2013-07-05 at 19:56 +0800, majianpeng wrote:
> Compile x86_64 meet those messages:
> WARNING: arch/x86/mm/built-in.o(.text.unlikely+0xbf8): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
> The function __node_set.constprop.0() references
> the variable __initdata numa_nodes_parsed.
> This is often because __node_set.constprop.0 lacks a __initdata 
> annotation or the annotation of numa_nodes_parsed is wrong.
> 
> WARNING: arch/x86/built-in.o(.text.unlikely+0x171d): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
> The function __node_set.constprop.0() references
> the variable __initdata numa_nodes_parsed.
> This is often because __node_set.constprop.0 lacks a __initdata 
> annotation or the annotation of numa_nodes_parsed is wrong.

0) I noticed these too, on v3.11-rc1 and v3.12.-rc2. I assume Jianpeng
Ma reported these for a linux-next release that preceded v3.11-rc1.

1) The only hits for node_set and numa_nodes_parsed in arch/x86/mm are
in amdtopology.c, numa.c, and srat.c. If I peek at the object files
generated for these three files I notice that numa.o and srat.o have
node_set() in their .text.unlikely section. (amdtopology.o doesn't have
a .text.unlikely section.) 

2) I guess that since commit 06df44ee41442d83be061c5fd1b1de4f5fc6fbbf
("modpost.c: Add .text.unlikely to TEXT_SECTIONS"), which was included
in v3.11-rc1, code in .text.unlikely sections generates a mismatch
warning if it references __initdata code (and numa_nodes_parsed is
__initdata). But all calls of node_set() in these two files are from
within functions that are marked __init. And I think references from
__init code to __initdata code shouldn't lead to mismatch warnings,
should they?

3) So this looks like a false positive to me (but I'm not at all
familiar with, well, the section mismatch checks). Would there be a way
to silence this warning? Other than dropping __initdata from
numa_nodes_parsed, of course.


Paul Bolle

