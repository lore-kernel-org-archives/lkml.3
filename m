Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab3FYOuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:50:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39329 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab3FYOuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:50:12 -0400
Subject: Re: [PATCH RFC V9 0/19] Paravirtualized ticket spinlocks
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, hpa@zytor.com, pbonzini@redhat.com,
        linux-doc@vger.kernel.org, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
In-Reply-To: <20130601192125.5966.35563.sendpatchset@codeblue>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jun 2013 09:50:02 -0500
Message-ID: <1372171802.3804.30.camel@oc2024037011.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062514-5806-0000-0000-000021DE8DD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-06-02 at 00:51 +0530, Raghavendra K T wrote:
> This series replaces the existing paravirtualized spinlock mechanism
> with a paravirtualized ticketlock mechanism. The series provides
> implementation for both Xen and KVM.
> 
> Changes in V9:
> - Changed spin_threshold to 32k to avoid excess halt exits that are
>    causing undercommit degradation (after PLE handler improvement).
> - Added  kvm_irq_delivery_to_apic (suggested by Gleb)
> - Optimized halt exit path to use PLE handler
> 
> V8 of PVspinlock was posted last year. After Avi's suggestions to look
> at PLE handler's improvements, various optimizations in PLE handling
> have been tried.

Sorry for not posting this sooner.  I have tested the v9 pv-ticketlock
patches in 1x and 2x over-commit with 10-vcpu and 20-vcpu VMs.  I have
tested these patches with and without PLE, as PLE is still not scalable
with large VMs.

System: x3850X5, 40 cores, 80 threads


1x over-commit with 10-vCPU VMs (8 VMs) all running dbench:
----------------------------------------------------------
						Total
Configuration				Throughput(MB/s)	Notes

3.10-default-ple_on			22945			5% CPU in host kernel, 2% spin_lock in guests
3.10-default-ple_off			23184			5% CPU in host kernel, 2% spin_lock in guests
3.10-pvticket-ple_on			22895			5% CPU in host kernel, 2% spin_lock in guests
3.10-pvticket-ple_off			23051			5% CPU in host kernel, 2% spin_lock in guests
[all 1x results look good here]


2x over-commit with 10-vCPU VMs (16 VMs) all running dbench:
-----------------------------------------------------------
						Total
Configuration				Throughput		Notes

3.10-default-ple_on			 6287			55% CPU  host kernel, 17% spin_lock in guests
3.10-default-ple_off			 1849			2% CPU in host kernel, 95% spin_lock in guests
3.10-pvticket-ple_on			 6691			50% CPU in host kernel, 15% spin_lock in guests
3.10-pvticket-ple_off			16464			8% CPU in host kernel, 33% spin_lock in guests
[PLE hinders pv-ticket improvements, but even with PLE off,
 we still off from ideal throughput (somewhere >20000)]


1x over-commit with 20-vCPU VMs (4 VMs) all running dbench:
----------------------------------------------------------
						Total
Configuration				Throughput		Notes

3.10-default-ple_on			22736			6% CPU in host kernel, 3% spin_lock in guests
3.10-default-ple_off			23377			5% CPU in host kernel, 3% spin_lock in guests
3.10-pvticket-ple_on			22471			6% CPU in host kernel, 3% spin_lock in guests
3.10-pvticket-ple_off			23445			5% CPU in host kernel, 3% spin_lock in guests
[1x looking fine here]


2x over-commit with 20-vCPU VMs (8 VMs) all running dbench:
----------------------------------------------------------
						Total
Configuration				Throughput		Notes

3.10-default-ple_on			 1965			70% CPU in host kernel, 34% spin_lock in guests		
3.10-default-ple_off			  226			2% CPU in host kernel, 94% spin_lock in guests
3.10-pvticket-ple_on			 1942			70% CPU in host kernel, 35% spin_lock in guests
3.10-pvticket-ple_off			 8003			11% CPU in host kernel, 70% spin_lock in guests
[quite bad all around, but pv-tickets with PLE off the best so far.
 Still quite a bit off from ideal throughput]

In summary, I would state that the pv-ticket is an overall win, but the
current PLE handler tends to "get in the way" on these larger guests.

-Andrew

