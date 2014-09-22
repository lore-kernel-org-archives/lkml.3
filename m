Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbaIVW6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:58:23 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:65327 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbaIVW6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:58:19 -0400
Date: Mon, 22 Sep 2014 15:58:16 -0700
From: David Matlack <dmatlack@google.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
Message-ID: <20140922225816.GD8347@google.com>
References: <1411167805-2458-1-git-send-email-dmatlack@google.com>
 <20140922200812.GA9217@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922200812.GA9217@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22, Marcelo Tosatti wrote:
> On Fri, Sep 19, 2014 at 04:03:25PM -0700, David Matlack wrote:
> > vcpu ioctls can hang the calling thread if issued while a vcpu is
> > running. 
> 
> There is a mutex per-vcpu, so thats expected, OK...
> 
> > If we know ioctl is going to be rejected as invalid anyway,
> > we can fail before trying to take the vcpu mutex.
> 
> Consider a valid ioctl that takes the vcpu mutex. If you need immediate
> access for that valid ioctl, it is necessary to interrupt thread
> which KVM_RUN ioctl executes. 
> 
> So knowledge of whether KVM_RUN is being executed is expected in
> userspace (either
> that or ask the KVM_RUN thread to run the ioctl for you, as qemu does).
> 
> Can't see why having different behaviour for valid/invalid ioctls
> is a good thing.
> 
> > This patch does not change functionality, it just makes invalid ioctls
> > fail faster.
> 
> Should not be executing vcpu ioctls without interrupt KVM_RUN in the
> first place.

This patch is trying to be nice to code that isn't aware it's
probing kvm file descriptors. We saw long hangs with some generic
process inspection code that was probing all open file descriptors.
There's no reason non-kvm ioctls should have to wait for the vcpu
mutex to become available just to fail.
