Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab3GXXWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:22:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39112 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab3GXXWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:22:51 -0400
Message-ID: <51F061CC.9080704@ti.com>
Date: Wed, 24 Jul 2013 19:22:52 -0400
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Jianpeng Ma <majianpeng@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
        <tglx@linutronix.de>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: compile x86_64 waring
References: <201307051956052638321@gmail.com> <1374699912.29835.8.camel@x61.thuisdomein>
In-Reply-To: <1374699912.29835.8.camel@x61.thuisdomein>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 05:05 PM, Paul Bolle wrote:
> [Added Tom and Rusty because they might be able to say what's really
> going on here.]
> 
> On Fri, 2013-07-05 at 19:56 +0800, majianpeng wrote:
>> Compile x86_64 meet those messages:
>> WARNING: arch/x86/mm/built-in.o(.text.unlikely+0xbf8): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
>> The function __node_set.constprop.0() references
>> the variable __initdata numa_nodes_parsed.
>> This is often because __node_set.constprop.0 lacks a __initdata 
>> annotation or the annotation of numa_nodes_parsed is wrong.
>>
>> WARNING: arch/x86/built-in.o(.text.unlikely+0x171d): Section mismatch in reference from the function __node_set.constprop.0() to the variable .init.data:numa_nodes_parsed
>> The function __node_set.constprop.0() references
>> the variable __initdata numa_nodes_parsed.
>> This is often because __node_set.constprop.0 lacks a __initdata 
>> annotation or the annotation of numa_nodes_parsed is wrong.
> 
> 0) I noticed these too, on v3.11-rc1 and v3.12.-rc2. I assume Jianpeng
> Ma reported these for a linux-next release that preceded v3.11-rc1.
> 
> 1) The only hits for node_set and numa_nodes_parsed in arch/x86/mm are
> in amdtopology.c, numa.c, and srat.c. If I peek at the object files
> generated for these three files I notice that numa.o and srat.o have
> node_set() in their .text.unlikely section. (amdtopology.o doesn't have
> a .text.unlikely section.) 
> 
> 2) I guess that since commit 06df44ee41442d83be061c5fd1b1de4f5fc6fbbf
> ("modpost.c: Add .text.unlikely to TEXT_SECTIONS"), which was included
> in v3.11-rc1, code in .text.unlikely sections generates a mismatch
> warning if it references __initdata code (and numa_nodes_parsed is
> __initdata). But all calls of node_set() in these two files are from
> within functions that are marked __init. And I think references from
> __init code to __initdata code shouldn't lead to mismatch warnings,
> should they?
> 
> 3) So this looks like a false positive to me (but I'm not at all
> familiar with, well, the section mismatch checks). Would there be a way
> to silence this warning? Other than dropping __initdata from
> numa_nodes_parsed, of course.

I suspect you have a real problem, in that either numa_nodes_parsed
needs to not be __initdata (as it's being called by both __init and
non-__init functions, and hence the problem), or the other caller(s) of
numa_nodes_parsed need to also be __init.  Is this seen in top-of-tree
Linus?  If so, I can take a peek took, if someone shoots me a config
file.  Thanks!

-- 
Tom
