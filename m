Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaKLSA5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:00:57 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:50474 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaKLSAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:00:55 -0500
Date: Wed, 12 Nov 2014 10:00:50 -0800
From: David Matlack <dmatlack@google.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: add trace event for pvclock updates
Message-ID: <20141112180050.GA22530@google.com>
References: <1415216802-19201-1-git-send-email-dmatlack@google.com>
 <20141111011850.GA12749@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111011850.GA12749@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10 11:18 PM, Marcelo Tosatti wrote:
> On Wed, Nov 05, 2014 at 11:46:42AM -0800, David Matlack wrote:
> > The new trace event records:
> >   * the id of vcpu being updated
> >   * the pvclock_vcpu_time_info struct being written to guest memory
> > 
> > This is useful for debugging pvclock bugs, such as the bug fixed by
> > "[PATCH] kvm: x86: Fix kvm clock versioning.".
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> So you actually hit that bug in practice? Can you describe the
> scenario?

We noticed guests running stress workloads would occasionally get stuck 
on the far side of a save/restore. Inspecting the guest state revealed
arch/x86/kernel/pvclock.c:last_value was stuck at a value like
8020566108469899263, despite TSC and pvclock looking sane.

Since these guests ran without PVCLOCK_TSC_STABLE_BIT set in their
CPUID, they were stuck with this large time value until real time
caught up (in about 250 years :).

We've been unable to reproduce the bug with "kvm: x86: Fix kvm clock
versioning." so we didn't invest in catching the overflow in the act,
but a likely explanation is the guest gets save/restore-ed while
computing the pvclock delta:

        u64 delta = __native_read_tsc() - src->tsc_timestamp;

causing the subtraction to underflow and delta to be huge.

> 
> 
