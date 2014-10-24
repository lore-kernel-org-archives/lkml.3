Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbaJXVyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaJXVyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:54:51 -0400
Message-ID: <544ACAA3.7090203@redhat.com>
Date: Fri, 24 Oct 2014 23:54:43 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 08/14] kvm: x86: don't kill guest on unknown exit reason
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com> <1414163245-18555-9-git-send-email-pbonzini@redhat.com> <544A9320.6010102@amacapital.net>
In-Reply-To: <544A9320.6010102@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 07:57 PM, Andy Lutomirski wrote:
> > KVM_EXIT_UNKNOWN is a kvm bug, we don't really know whether it was
> > triggered by a priveledged application.  Let's not kill the guest: WARN
> > and inject #UD instead.
>
> This scares me a bit.  For guest CPL3, it's probably okay.  For guest
> CPL0, on the other hand, #UD might not use IST (or a task switch on
> 32-bit guests), resulting in possible corruption if unprivileged code
> controls SP.  Admittedly, there aren't that many contexts from which
> that should happen (on Linux, at least), but something like #DF (or even
> a triple fault) might be safer if the guest is at CPL0 when this happens.

This in practice will only happen for VMX instructions (INVVPID in this
patch set, INVEPT on some older kernels); all other intercepts can be
turned on or off at will.

For unknown exits we will not have exposed those instructions in the VMX
capabilities (or perhaps we will not have exposed VMX at all in CPUID on
the older kernels).  So #UD is the right thing to do.

Paolo
