Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaEZFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:09:28 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33733 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaEZFJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:09:26 -0400
MIME-Version: 1.0
In-Reply-To: <CALeycy9ZW5cwByGfdnkrm6r30Zy18aAKt3-T6fMJUMUNuHd80g@mail.gmail.com>
References: <CALeycy9ZW5cwByGfdnkrm6r30Zy18aAKt3-T6fMJUMUNuHd80g@mail.gmail.com>
Date: Mon, 26 May 2014 00:09:25 -0500
Message-ID: <CALeycy_nTgbt4k8LF6=FDdpfh08izGxDRYchtd=OCG0Aw_=_qw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: use new CS.RPL as CPL during task switch
From: Wei Huang <huangwei.virt@gmail.com>
To: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        "J. Kiszka" <jan.kiszka@siemens.com>, gleb@kernel.org,
        Avi Kivity <avi.kivity@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> During task switch, all of CS.DPL, CS.RPL, SS.DPL must match (in addition
>> to all the other requirements) and will be the new CPL.  So far this
>> worked by carefully setting the CS selector and flag before doing the
>
> s/flag/EFLAGS/
>
>> task switch; however, this will not work once we get the CPL from SS.DPL:
>> setting SS itself would fail if the task switch changes the privilege
>> level.
>
> More precisely, before patch 4 in this series setting CS.selector would
> already change the CPL.  After it, you actually have to set the full
> segment descriptor cache to change the CPL, so we cannot use
> ctxt->ops->cpl(ctxt) to retrieve the CPL during a task switch.  The
> check that fails without this patch is that SS.DPL must be == CPL, and
> the failure happens because ctxt->ops->cpl(ctxt) is the *old* SS.DPL.

This is informative and answered some of my questions. Thanks. It would
be helpful to include such info in patch description.

>
> Paolo
>
>> Temporarily assume that the CPL comes from CS.RPL during task switch
>> to a protected-mode task.  This is the same approach used in QEMU's
>> emulation code, which (until version 2.0) manually tracks the CPL.
