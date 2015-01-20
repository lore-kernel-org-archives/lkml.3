Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbbATKeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:34:50 -0500
Received: from mx5.zte.com.cn ([63.217.80.70]:43749 "EHLO mx5.zte.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbbATKeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:34:46 -0500
In-Reply-To: <54BD22CB.902@redhat.com>
References: <OF9FB4191F.311C876C-ON48257DCE.003C223F-48257DCE.0044DE9C@zte.com.cn> <54BD22CB.902@redhat.com>
Subject: Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject directly
 bug with guestos RFLAGS.IF=0
X-KeepSent: A79F49F0:447F9773-48257DD3:00086E68;
 type=4; name=$KeepSent
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFA79F49F0.447F9773-ON48257DD3.00086E68-48257DD3.0039B508@zte.com.cn>
From: "Li Kaihang" <li.kaihang@zte.com.cn>
Date: Tue, 20 Jan 2015 18:34:23 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP6|November 21, 2013) at
 2015-01-20 18:34:14
MIME-Version: 1.0
Content-type: text/plain; charset=GB2312
X-MAIL: mse01.zte.com.cn t0KAYT4H058447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0KAYuYc010663




From:	Paolo Bonzini <pbonzini@redhat.com>
To:	Li Kaihang <li.kaihang@zte.com.cn>, gleb@kernel.org,
Cc:	tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:	2015-01-19 ÏÂÎç 11:29
Subject:	Re: [PATCH 1/1] arch/x86/kvm/vmx.c: Fix external interrupts inject directly bug with guestos RFLAGS.IF=0





On 15/01/2015 13:36, Li Kaihang wrote:
> This patch fix a external interrupt injecting bug in linux 3.19-rc4.
>
> GuestOS is running and handling some interrupt with RFLAGS.IF = 0 while a external interrupt coming,
> then can lead to a vm exit,in this case,we must avoid inject this external interrupt or it will generate
> a processor hardware exception causing virtual machine crash.

I do not understand what is happening here.

Between the time the processor starts delivering an external interrupt
to the VM, and the time it decides to do a vm exit because of an
external interrupt in the host, IF becomes 0.

What is the cause of the external interrupt?  Why does IF become 0?


> Now, I show more details about this problem:
>
> A general external interrupt processing for a running virtual machine is shown in the following:
>
> Step 1:
>      a ext intr gen a vm_exit

How did the external interrupt cause the IDT-vectoring information field
to be set?  External interrupts for the host are not among the causes
listed in "27.2.3 Information for VM Exits During Event Delivery".

> --> vmx_complete_interrupts --> __vmx_complete_interrupts --> case INTR_TYPE_EXT_INR: kvm_queue_interrupt(vcpu, vector, type == INTR_TYPE_SOFT_INTR);
>
> Step 2:
>      kvm_x86_ops->handle_external_intr(vcpu);

Why is this relevant?  The external interrupt is a vectored event, so it
sets VM-exit interruption information (27.2.2 Information for VM Exits
Due to Vectored Events).  It doesn't set the IDT-vectoring information
field.

Li kaihang: I think I make a mistake here that IDT-vectoring information field is not written by vectored event but is done by Event Delivery.
            vm exit during Event Delivery is not triggered by external interrupt delivery, only vm exit due to vectored event is done so.
            Both are completely different, and you are right. I'm very sorry this patch is wrong.

Paolo

> Step 3:
>      get back to vcpu_enter_guest after a while cycle,then run inject_pending_event
>
> Step 4:
>      if (vcpu->arch.interrupt.pending) {
> 		 		 kvm_x86_ops->set_irq(vcpu);
> 		 		 return 0;
> 		 }
>
> Step 5:
>      kvm_x86_ops->run(vcpu) --> vm_entry inject vector to guestos IDT
>
> for the above steps, step 4 and 5 will be a processor hardware exception if step1 happen while guestos RFLAGS.IF = 0, that is to say, guestos interrupt is disabled.
> So we should add a logic to judge in step 1 whether a external interrupt need to be pended then inject directly, in the process, we don't need to worry about
> this external interrupt lost because the next Step 2 will handle and choose a best chance to inject it by virtual interrupt controller.
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
