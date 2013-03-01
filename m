Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3CAJWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:22:31 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57790 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3CAJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:22:28 -0500
Message-ID: <5130734F.6090208@suse.cz>
Date: Fri, 01 Mar 2013 10:22:23 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [ 17/53] s390/kvm: Fix store status for ACRS/FPRS
References: <20130226235619.844721947@linuxfoundation.org> <20130226235621.622037661@linuxfoundation.org> <512FD9B3.5000304@suse.cz> <51305DC5.7010201@de.ibm.com>
In-Reply-To: <51305DC5.7010201@de.ibm.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: multipart/mixed;
 boundary="------------060304080001020002080908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060304080001020002080908
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

On 03/01/2013 08:50 AM, Christian Borntraeger wrote:
> On 28/02/13 23:26, Jiri Slaby wrote:
>> On 02/27/2013 12:57 AM, Greg Kroah-Hartman wrote:
>>> 3.0-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Christian Borntraeger <borntraeger@de.ibm.com>
>>>
>>> commit 15bc8d8457875f495c59d933b05770ba88d1eacb upstream.
>>>
>>> On store status we need to copy the current state of registers
>>> into a save area. Currently we might save stale versions:
>>> The sie state descriptor doesnt have fields for guest ACRS,FPRS,
>>> those registers are simply stored in the host registers. The host
>>> program must copy these away if needed. We do that in vcpu_put/load.
>>>
>>> If we now do a store status in KVM code between vcpu_put/load, the
>>> saved values are not up-to-date. Lets collect the ACRS/FPRS before
>>> saving them.
>>>
>>> This also fixes some strange problems with hotplug and virtio-ccw,
>>> since the low level machine check handler (on hotplug a machine check
>>> will happen) will revalidate all registers with the content of the
>>> save area.
>>>
>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> Signed-off-by: Gleb Natapov <gleb@redhat.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> ---
>>>  arch/s390/kvm/kvm-s390.c |    8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -584,6 +584,14 @@ int kvm_s390_vcpu_store_status(struct kv
>>>  	} else
>>>  		prefix = 0;
>>>  
>>> +	/*
>>> +	 * The guest FPRS and ACRS are in the host FPRS/ACRS due to the lazy
>>> +	 * copying in vcpu load/put. Lets update our copies before we save
>>> +	 * it into the save area
>>> +	 */
>>> +	save_fp_regs(&vcpu->arch.guest_fpregs);
>>> +	save_access_regs(vcpu->run->s.regs.acrs);
>>
>> kvm_run structure does not have kvm_sync_regs in it in 3.0 yet. So this
>> fails with:
>> arch/s390/kvm/kvm-s390.c: In function 'kvm_s390_vcpu_store_status':
>> arch/s390/kvm/kvm-s390.c:593: error: 'struct kvm_run' has no member
>> named 's'
>>
>> I believe the fix is just to remove save_access_regs, right?
> 
> Before the sync reg changes, the ACRS were saved in the vcpu->arch.
> So the fix would look like 
> 
> 	save_access_regs(vcpu->arch.guest_acrs);

Fix attached.

thanks,
-- 
js
suse labs

--------------060304080001020002080908
Content-Type: text/x-patch;
 name="s390-kvm-Fix-store-status-for-ACRS-FPRS-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="s390-kvm-Fix-store-status-for-ACRS-FPRS-fix.patch"

From: Jiri Slaby <jslaby@suse.cz>
Subject: s390/kvm: Fix store status for ACRS/FPRS fix
Patch-mainline: no, submitted on 1st Mar 2013

In 3.0.67, commit 58c9ce6fad8e00d9726447f939fe7e78e2aec891 (s390/kvm:
Fix store status for ACRS/FPRS), upstream commit
15bc8d8457875f495c59d933b05770ba88d1eacb, added a call to
save_access_regs to save ACRS. But we do not have ARCS in kvm_run in
3.0 yet, so this results in:
arch/s390/kvm/kvm-s390.c: In function 'kvm_s390_vcpu_store_status':
arch/s390/kvm/kvm-s390.c:593: error: 'struct kvm_run' has no member named 's'

Fix it by saving guest_acrs which is where ARCS are in 3.0.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/s390/kvm/kvm-s390.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -590,7 +590,7 @@ int kvm_s390_vcpu_store_status(struct kv
 	 * it into the save area
 	 */
 	save_fp_regs(&vcpu->arch.guest_fpregs);
-	save_access_regs(vcpu->run->s.regs.acrs);
+	save_access_regs(vcpu->arch.guest_acrs);
 
 	if (__guestcopy(vcpu, addr + offsetof(struct save_area, fp_regs),
 			vcpu->arch.guest_fpregs.fprs, 128, prefix))

--------------060304080001020002080908--
