Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757Ab3DSIpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:45:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46249 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab3DSIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:45:44 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51710422.60704@jp.fujitsu.com>
Date: Fri, 19 Apr 2013 17:45:22 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, vgoyal@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH 0/2] kdump: Enter 2nd kernel with BSP for enabling multiple
 CPUs
References: <20120416021951.9303.58568.stgit@localhost6.localdomain6> <20130418134148.53704982@azariah.suse.cz>
In-Reply-To: <20130418134148.53704982@azariah.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/04/18 20:41), Petr Tesarik wrote:
> On Mon, 16 Apr 2012 11:21:28 +0900
> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:
>
>> Currently, booting up 2nd kernel with multiple CPUs fails in most
>> cases since it enters 2nd kernel with AP if the crash happens on the
>> AP. The problem is to signal startup IPI from AP to BSP. Typical
>> result of the operation I saw is the machine hanging during the 2nd
>> kernel boot.
>>
>> To solve this issue, always enter 2nd kernel with BSP. To do this, I
>> modify logic for shooting down CPUs. I use simple existing logic only
>> in this mechanism, not complicating crash path to machine_kexec().
>
> These patches looked pretty good. I seem to recall that Fenghua (from
> Intel) had an alternative solution for booting from AP. Unfortunately I
> can't find his mails in my kexec mailbox...
>
> Anyway, what's the latest upstream status?

It's still in experimental state.

The patch itself was nacked by Erick since switching the CPU that 
entered 2nd kenrel through NMI reduced reliability of kdump.

At the discussion of my 2nd patch set that tried to reset BSP flag at 
boot on the 2nd kernel, Erick suggested that BSP flag could be changed 
at runtime and then behaviour when INIT was received varied and first we 
should discuss how unsetting BSP flag affects system.

I'm now going in this direction and the patch I posted a month ago is:

[PATCH] x86, apic: Add unset_bsp parameter to unset BSP flag at boot time
https://lkml.org/lkml/2013/3/18/107

According to Fenghua, some kind of firmware assumes that BSP flag is 
being kept throughout system is running. I have yet to see difference of 
behaviour when unsetting BSP flag on top of the patch on my machine. I 
think this is system dependent and it might be better to assign each 
user to decide whether to unset BSP flag or not.

BTW, the work of software cpu hotplug for BSP by Fenghua is orthogonal 
to my case. His work is for system including firmware that is affected 
if BSP flag is unset and assumes healthy system that cpu#0 is always 
BSP. On the other hand, our case is for crash kernel and we can no 
longer assume cpu#0 is BSP and can no longer use NMI to wake up other 
CPUs since we cannot use logic that depends on the state of CPUs 
sleeping in the 1st kernel.

-- 
Thanks.
HATAYAMA, Daisuke

