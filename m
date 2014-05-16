Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaEPWT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:19:59 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60489 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbaEPWT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:19:57 -0400
Message-ID: <53768F08.1090008@redhat.com>
Date: Sat, 17 May 2014 00:19:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: Re: [PATCH v2 1/4] KVM: x86: use new CS.RPL as CPL during task switch
References: <1400172691-27030-1-git-send-email-pbonzini@redhat.com> <1400172691-27030-2-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1400172691-27030-2-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/05/2014 18:51, Paolo Bonzini ha scritto:
> During task switch, all of CS.DPL, CS.RPL, SS.DPL must match (in addition
> to all the other requirements) and will be the new CPL.  So far this
> worked by carefully setting the CS selector and flag before doing the

s/flag/EFLAGS/

> task switch; however, this will not work once we get the CPL from SS.DPL:
> setting SS itself would fail if the task switch changes the privilege
> level.

More precisely, before patch 4 in this series setting CS.selector would 
already change the CPL.  After it, you actually have to set the full 
segment descriptor cache to change the CPL, so we cannot use 
ctxt->ops->cpl(ctxt) to retrieve the CPL during a task switch.  The 
check that fails without this patch is that SS.DPL must be == CPL, and 
the failure happens because ctxt->ops->cpl(ctxt) is the *old* SS.DPL.

Paolo

> Temporarily assume that the CPL comes from CS.RPL during task switch
> to a protected-mode task.  This is the same approach used in QEMU's
> emulation code, which (until version 2.0) manually tracks the CPL.

