Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaIVUIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbaIVUIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:08:35 -0400
Date: Mon, 22 Sep 2014 17:08:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: David Matlack <dmatlack@google.com>
Cc: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
Message-ID: <20140922200812.GA9217@amt.cnet>
References: <1411167805-2458-1-git-send-email-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411167805-2458-1-git-send-email-dmatlack@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 04:03:25PM -0700, David Matlack wrote:
> vcpu ioctls can hang the calling thread if issued while a vcpu is
> running. 

There is a mutex per-vcpu, so thats expected, OK...

> If we know ioctl is going to be rejected as invalid anyway,
> we can fail before trying to take the vcpu mutex.

Consider a valid ioctl that takes the vcpu mutex. If you need immediate
access for that valid ioctl, it is necessary to interrupt thread
which KVM_RUN ioctl executes. 

So knowledge of whether KVM_RUN is being executed is expected in
userspace (either
that or ask the KVM_RUN thread to run the ioctl for you, as qemu does).

Can't see why having different behaviour for valid/invalid ioctls
is a good thing.

> This patch does not change functionality, it just makes invalid ioctls
> fail faster.

Should not be executing vcpu ioctls without interrupt KVM_RUN in the
first place.


