Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3CATQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:16:59 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64347 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3CATQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:16:57 -0500
Date: Fri, 1 Mar 2013 11:16:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [ 17/53] s390/kvm: Fix store status for ACRS/FPRS
Message-ID: <20130301191654.GA30321@kroah.com>
References: <20130226235619.844721947@linuxfoundation.org>
 <20130226235621.622037661@linuxfoundation.org>
 <512FD9B3.5000304@suse.cz>
 <51305DC5.7010201@de.ibm.com>
 <5130734F.6090208@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5130734F.6090208@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 10:22:23AM +0100, Jiri Slaby wrote:
> On 03/01/2013 08:50 AM, Christian Borntraeger wrote:
> > On 28/02/13 23:26, Jiri Slaby wrote:
> >> On 02/27/2013 12:57 AM, Greg Kroah-Hartman wrote:
> >>> 3.0-stable review patch.  If anyone has any objections, please let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Christian Borntraeger <borntraeger@de.ibm.com>
> >>>
> >>> commit 15bc8d8457875f495c59d933b05770ba88d1eacb upstream.
> >>>
> >>> On store status we need to copy the current state of registers
> >>> into a save area. Currently we might save stale versions:
> >>> The sie state descriptor doesnt have fields for guest ACRS,FPRS,
> >>> those registers are simply stored in the host registers. The host
> >>> program must copy these away if needed. We do that in vcpu_put/load.
> >>>
> >>> If we now do a store status in KVM code between vcpu_put/load, the
> >>> saved values are not up-to-date. Lets collect the ACRS/FPRS before
> >>> saving them.
> >>>
> >>> This also fixes some strange problems with hotplug and virtio-ccw,
> >>> since the low level machine check handler (on hotplug a machine check
> >>> will happen) will revalidate all registers with the content of the
> >>> save area.
> >>>
> >>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >>> Signed-off-by: Gleb Natapov <gleb@redhat.com>
> >>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>
> >>> ---
> >>>  arch/s390/kvm/kvm-s390.c |    8 ++++++++
> >>>  1 file changed, 8 insertions(+)
> >>>
> >>> --- a/arch/s390/kvm/kvm-s390.c
> >>> +++ b/arch/s390/kvm/kvm-s390.c
> >>> @@ -584,6 +584,14 @@ int kvm_s390_vcpu_store_status(struct kv
> >>>  	} else
> >>>  		prefix = 0;
> >>>  
> >>> +	/*
> >>> +	 * The guest FPRS and ACRS are in the host FPRS/ACRS due to the lazy
> >>> +	 * copying in vcpu load/put. Lets update our copies before we save
> >>> +	 * it into the save area
> >>> +	 */
> >>> +	save_fp_regs(&vcpu->arch.guest_fpregs);
> >>> +	save_access_regs(vcpu->run->s.regs.acrs);
> >>
> >> kvm_run structure does not have kvm_sync_regs in it in 3.0 yet. So this
> >> fails with:
> >> arch/s390/kvm/kvm-s390.c: In function 'kvm_s390_vcpu_store_status':
> >> arch/s390/kvm/kvm-s390.c:593: error: 'struct kvm_run' has no member
> >> named 's'
> >>
> >> I believe the fix is just to remove save_access_regs, right?
> > 
> > Before the sync reg changes, the ACRS were saved in the vcpu->arch.
> > So the fix would look like 
> > 
> > 	save_access_regs(vcpu->arch.guest_acrs);
> 
> Fix attached.

Thanks, now applied.

greg k-h
