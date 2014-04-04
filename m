Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaDDDxH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:53:07 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47070 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaDDDxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:53:03 -0400
Message-ID: <533E2D4A.3060203@oracle.com>
Date: Thu, 03 Apr 2014 23:55:54 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: srostedt@redhat.com
CC: xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen 32-bit PV regression
References: <533E259B.4030507@oracle.com>
In-Reply-To: <533E259B.4030507@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 11:23 PM, Boris Ostrovsky wrote:
> Steven,
>
> Looks like commit 198d208df (x86: Keep thread_info on thread stack in 
> x86_32) broke Xen's 32-bit PV guests.
>
> I poked a little at it and it seems that at least the ifdef in 
> xen_cpu_up() needs to be adjusted to set up kernel_stack --- that 
> allows CPUs to get going. This is not enough though (not particularly 
> surprisingly) and we die a little later with #GPF in xen_iret.


I should have probably included some output.


...
[    1.277533] Freeing unused kernel memory: 780K (c18fe000 - c19c1000)
[    1.280041] Write protecting the kernel text: 6120k
[    1.281477] Write protecting the kernel read-only data: 2472k
[    1.282177] NX-protecting the kernel data: 4120k
[    1.304957] general protection fault: 0000 [#1] SMP
[    1.305866] Modules linked in:
[    1.305866] CPU: 0 PID: 1 Comm: init Not tainted 3.14.0-32b #29
[    1.305866] task: eb880000 ti: eb84c000 task.ti: eb84c000
[    1.305866] EIP: e019:[<c100901f>] EFLAGS: 00010046 CPU: 0
[    1.305866] EIP is at xen_iret+0xb/0x29
[    1.305866] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
[    1.305866] ESI: 00000000 EDI: 00000000 EBP: 00000000 ESP: eb84dfe0
[    1.305866]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: e021
[    1.305866] CR0: 8005003b CR2: bf8e0fe0 CR3: 2ac52000 CR4: 00040660
[    1.305866] Stack:
[    1.305866]  00000000 b760d020 00000073 00000200 bf8e0fe0 0000007b 
c2c2c2c2 c2c2c2c2
[    1.305866] Call Trace:
[    1.305866] Code: a1 d8 9f 9b c1 2d ec 1f 00 00 36 8b 40 10 36 8b 04 
85 e0 74 8f c1 36 8b 80 c0 90 9b c1 eb 2a 90 f7 44 24 08 00 00 02 80 75 
3d 50 <64> a1 d8 9f 9b c1 2d ec 1f 00 00 36 8b 40 10 36 8b 04 85 e0 74
[    1.305866] EIP: [<c100901f>] xen_iret+0xb/0x29 SS:ESP e021:eb84dfe0
[    1.305866] ---[ end trace e4f42ac1798ac467 ]---
[    1.369739] Kernel panic - not syncing: Attempted to kill init! 
exitcode=0x0000000b


