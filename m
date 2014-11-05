Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaKEQlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:41:50 -0500
Received: from smtp.citrix.com ([66.165.176.89]:64010 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747AbaKEQls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:41:48 -0500
X-IronPort-AV: E=Sophos;i="5.07,320,1413244800"; 
   d="scan'208";a="188399416"
Date: Wed, 5 Nov 2014 16:41:41 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: <linux-kernel@vger.kernel.org>, <mgorman@suse.de>,
        <akpm@linux-foundation.org>, <hughd@google.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xen.org>,
        <david.vrabel@citrix.com>, <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Pte_special broken on Xen PV when NUMA balancing is enabled
Message-ID: <20141105164141.GA27834@zion.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I'm developing virtual NUMA support for Xen. One thing I notice is that when
NUMA balancing is enabled, kernel will crash with following backtrace.

[  404.281396] CPU: 0 PID: 1058 Comm: dd Tainted: G    B   W      3.18.0-rc3-bp+ #3
[  404.281403]  0000000000000000 00007fd62eca3000 ffffffff817b7cac ffff880172d298b8
[  404.281415]  ffffffff8110383f 0720072007300732 00000007fd62eca3 0720072007200720
[  404.281426]  ffff880172d298b8 ffff88017300bbb0 00007fd62eca3000 0000000000000000
[  404.281437] Call Trace:                                                      
[  404.281444]  [<ffffffff817b7cac>] ? dump_stack+0x41/0x51                     
[  404.281452]  [<ffffffff8110383f>] ? print_bad_pte+0x19f/0x1cb                
[  404.281460]  [<ffffffff81104479>] ? vm_normal_page+0x51/0x87                 
[  404.281469]  [<ffffffff8110c5ef>] ? change_protection+0x4fb/0x76a            
[  404.281477]  [<ffffffff81106435>] ? handle_mm_fault+0x9e0/0xa11              
[  404.281486]  [<ffffffff8111cc22>] ? change_prot_numa+0x13/0x24               
[  404.281495]  [<ffffffff8106abf0>] ? task_numa_work+0x20c/0x2ac               
[  404.281503]  [<ffffffff810615e7>] ? finish_task_switch+0x83/0xc5             
[  404.281512]  [<ffffffff8105af10>] ? task_work_run+0x7b/0x8f                  
[  404.281521]  [<ffffffff8100d732>] ? do_notify_resume+0x5a/0x6d               
[  404.281529]  [<ffffffff817bf49f>] ? retint_signal+0x48/0x89                  
[  404.281537]  [<ffffffff810012eb>] ? xen_hypercall_iret+0xb/0x20

Decoding page flags 0x366 we have _PAGE_SPECIAL(_PAGE_NUMA) and
_PAGE_GLOBAL(_PAGE_PROTNONE) set, _PAGE_PRESENT not set. It's handling
a NUMA hint page fault and crashes because the PTE in question is
considered a special PTE by pte_special.

In a Xen PV guest, _PAGE_GLOBAL is added by hypervisor to mark the page
a guest user space page. Xen PV kernel has already forbidden setting
that bit during initialisation. It's a bit unfortunate that there's
still clash with _PAGE_PROTNONE.

Wei.

P.S.  Interestingly, in b38af4721 ("x86,mm: fix pte_special versus
pte_numa"), the commit which changed pte_special, Hugh (the author)
wrote "It still appears that this patch may be incomplete: aren't there
other places which need to be handling PROTNONE along with PRESENT?"
Looks like now we have a case -- Xen PV -- that PROTNONE and PRESENT
co-exist.
