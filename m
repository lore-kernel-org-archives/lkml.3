Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbaEGLQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 07:16:42 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:40873 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaEGLQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 07:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <5369F5B0.7050307@redhat.com>
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>
	<53636B1D.8030405@redhat.com>
	<CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>
	<5363BF42.9020505@redhat.com>
	<CAHqbYQvjBmeu2_WzrSesGA=PH+8-ZfYxdmKxvsPfHRYNEcObAg@mail.gmail.com>
	<jpgzjj0xbxl.fsf@nelium.bos.redhat.com>
	<CAHqbYQuaaUaGTahryghh0nX99msMgeNQr=yv34mbgDJbFeSCbw@mail.gmail.com>
	<CAESbUUzDm0REihDHinZ+fmQL8MWqn4kYCY8mQaVEnmVr4hh7NA@mail.gmail.com>
	<CAHqbYQuv73Wm_9p-_yhYn5C5K9Ag+8Az+sJ_-WEnk9u9Z586Ww@mail.gmail.com>
	<5369F5B0.7050307@redhat.com>
Date: Wed, 7 May 2014 14:16:39 +0300
Message-ID: <CAESbUUyQJ=BF1otV7XY2VpiM5TH6AxMMqGWCwO0+Mk_51sX_BA@mail.gmail.com>
Subject: Re: KVM Nested L2 guest startup problems
From: Abel Gordon <abel@stratoscale.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hu Yaohui <loki2441@gmail.com>, Bandan Das <bsd@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Muli Ben-Yehuda <muli@stratoscale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 11:58 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 04/05/2014 18:33, Hu Yaohui ha scritto:
>
>>> I experienced a similar problem that was related to nested code
>>> having some bugs related to apicv and other new vmx features.
>>>
>>> For example, the code enabled posted interrupts to run L2 even when the
>>> feature was not exposed to L1 and L1 didn't use it.
>>>
>>> Try changing prepare_vmcs02  to force disabling posted_interrupts,
>>> code should looks like:
>>>
>>> ....
>>> ....
>>> exec_control = vmcs12->pin_based_vm_exec_control;
>>> exec_control |= vmcs_config.pin_based_exec_ctrl;
>>> exec_control &= ~(PIN_BASED_VMX_PREEMPTION_TIMER|PIN_BASED_POSTED_INTR);
>>> vmcs_write32(PIN_BASED_VM_EXEC_CONTROL, exec_control);
>>> ....
>>> ...
>>>
>>> and also
>>>
>>> ...
>>> ...
>>> exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
>>>      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>>>      SECONDARY_EXEC_APIC_REGISTER_VIRT |
>>>      SECONDARY_EXEC_PAUSE_LOOP_EXITING);
>
>
> PLE should be left enabled, I think.

Well... the PLE settings L0 uses to run  L1 (vmcs01) may be different
than the PLE settings L1 configured to run  L2 (vmcs12).
For example, L0 can use a  ple_gap to run L1 that is bigger than the
ple_gap L1 configured to run L2. Or  L0 can use a ple_window to run L1
that is smaller than the ple_window L1 configured to run L2.

So seems PLE should never be exposed to L1 or an appropriate nested
handling needs to be implemented. Note the handling may become complex
because in some cases a PLE exit from L2 should be handled directly by
L0 and not passed to L1... remember nested preemption timer support :)
?


>
> Apart from that, I'll change the suggestion into a patch.

Great!

>
> Thanks!
>
> Paolo
>
