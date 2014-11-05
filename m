Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbaKEQ66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:58:58 -0500
Received: from smtp.citrix.com ([66.165.176.89]:56266 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbaKEQ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:58:56 -0500
X-IronPort-AV: E=Sophos;i="5.07,320,1413244800"; 
   d="scan'208";a="188406067"
Message-ID: <545A5700.20902@citrix.com>
Date: Wed, 5 Nov 2014 16:57:36 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>, <linux-kernel@vger.kernel.org>,
        <mgorman@suse.de>, <akpm@linux-foundation.org>, <hughd@google.com>
CC: <xen-devel@lists.xen.org>, <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: Pte_special broken on Xen PV when NUMA balancing is enabled
References: <20141105164141.GA27834@zion.uk.xensource.com>
In-Reply-To: <20141105164141.GA27834@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/14 16:41, Wei Liu wrote:
> Hi all
> 
> I'm developing virtual NUMA support for Xen. One thing I notice is that when
> NUMA balancing is enabled, kernel will crash with following backtrace.
> 
> [  404.281396] CPU: 0 PID: 1058 Comm: dd Tainted: G    B   W      3.18.0-rc3-bp+ #3
> [  404.281403]  0000000000000000 00007fd62eca3000 ffffffff817b7cac ffff880172d298b8
> [  404.281415]  ffffffff8110383f 0720072007300732 00000007fd62eca3 0720072007200720
> [  404.281426]  ffff880172d298b8 ffff88017300bbb0 00007fd62eca3000 0000000000000000
> [  404.281437] Call Trace:                                                      
> [  404.281444]  [<ffffffff817b7cac>] ? dump_stack+0x41/0x51                     
> [  404.281452]  [<ffffffff8110383f>] ? print_bad_pte+0x19f/0x1cb                
> [  404.281460]  [<ffffffff81104479>] ? vm_normal_page+0x51/0x87                 
> [  404.281469]  [<ffffffff8110c5ef>] ? change_protection+0x4fb/0x76a            
> [  404.281477]  [<ffffffff81106435>] ? handle_mm_fault+0x9e0/0xa11              
> [  404.281486]  [<ffffffff8111cc22>] ? change_prot_numa+0x13/0x24               
> [  404.281495]  [<ffffffff8106abf0>] ? task_numa_work+0x20c/0x2ac               
> [  404.281503]  [<ffffffff810615e7>] ? finish_task_switch+0x83/0xc5             
> [  404.281512]  [<ffffffff8105af10>] ? task_work_run+0x7b/0x8f                  
> [  404.281521]  [<ffffffff8100d732>] ? do_notify_resume+0x5a/0x6d               
> [  404.281529]  [<ffffffff817bf49f>] ? retint_signal+0x48/0x89                  
> [  404.281537]  [<ffffffff810012eb>] ? xen_hypercall_iret+0xb/0x20
> 
> Decoding page flags 0x366 we have _PAGE_SPECIAL(_PAGE_NUMA) and
> _PAGE_GLOBAL(_PAGE_PROTNONE) set, _PAGE_PRESENT not set. It's handling
> a NUMA hint page fault and crashes because the PTE in question is
> considered a special PTE by pte_special.
> 
> In a Xen PV guest, _PAGE_GLOBAL is added by hypervisor to mark the page
> a guest user space page. Xen PV kernel has already forbidden setting
> that bit during initialisation. It's a bit unfortunate that there's
> still clash with _PAGE_PROTNONE.

_PAGE_IOMAP is no more (f955371 "x86: remove the Xen-specific
_PAGE_IOMAP PTE flag) so there's now a spare _PAGE_SOFTW2 that could be
used for NUMA hinting, instead of this confusing/complex aliasing.

David
