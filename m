Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbbAVSJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:09:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:25794 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbbAVSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:09:51 -0500
Message-ID: <54C13CCE.1040003@oracle.com>
Date: Thu, 22 Jan 2015 13:09:18 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, James Dingwall <james@dingwall.me.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.18.2 / xen 4.4.1 dom0 - microcode oops
References: <20150122055242.GA11089@dingwall.me.uk> <20150122082003.GA3441@pd.tnic> <54C10DB6.2050708@oracle.com> <54C10ED0.1010302@oracle.com> <20150122153002.GA3554@pd.tnic> <20150122174315.GA32051@dingwall.me.uk> <20150122175818.GB3554@pd.tnic>
In-Reply-To: <20150122175818.GB3554@pd.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 12:58 PM, Borislav Petkov wrote:
> On Thu, Jan 22, 2015 at 05:43:15PM +0000, James Dingwall wrote:
>> This patch solves it for me on my dom0 with 3.18.3, now there is
>> nothing printed at all from the microcode driver which doesn't seem
>> surprising given where the return is.
> Yap, xen does/will update microcode differently...
>
>> I'll check it on bare metal at the next opportunity but from my
>> understanding of what is happening there I don't see that it should
>> have any impact at all.
> Yeah, it shouldn't have any effect on baremetal in the sense that it
> should load properly there. And it is a fix for baremetal too, as Boris
> pointed out.
>
> I'm still curious as to why does it say this on your machine:
>
> [  176.855832] microcode: CPU0 sig=0x10676, pf=0x1, revision=0x60c
> [  176.855844] microcode: CPU0 update to revision 0x60f failed


If this was on dom0 (i.e  a Xen PV guest) then it's understandable since 
in that case MSR writes would have been  trapped by the hypervisor and 
not processed any further.

James can probably see in the hypervisor log ('xl dmesg') something like

(XEN) traps.c:2579:d0v0 Domain attempted WRMSR 0000000000000079 from 
0x0000000000000000 to 0x0000000000000001.

(MSR reads should proceed fine though).

-boris

>
> ?
>
> This basically says that we do try to update with the patch but the
> hardware doesn't accept it.
>
> Is this new? Did it ever update microcode properly?
>
> Where do you get the microcode for that machine?
>
> Can you run the scriptlet below as root and send me the results? You'd
> need the msr-tools package and the msr.ko kernel module loaded. Ask if
> you need help.
>
> Also, please send me a full dmesg with "ignore_loglevel log_buf_len=16M
> debug" on the kernel command line, privately is fine too.
>
> Thanks.
>
> --
> #!/bin/bash
>
> echo "/proc/cpuinfo: "
> cat /proc/cpuinfo
>
> echo; echo "dmesg: "
> dmesg | grep -i microcode
> modprobe msr 2>/dev/null
>
> echo ; echo "MSRs: (0x8b) "
> rdmsr --all 0x8b
> --
>

