Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaENHsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:48:06 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41271 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaENHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:48:00 -0400
Message-ID: <53731FA7.3070800@redhat.com>
Date: Wed, 14 May 2014 09:47:51 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jan.kiszka@siemens.com, kvm@vger.kernel.org, gleb@kernel.org,
        avi.kivity@gmail.com
Subject: Re: [PATCH 0/5] KVM: x86: support setting the CPL independent of
 CS
References: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1399992941-11600-1-git-send-email-pbonzini@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/05/2014 16:55, Paolo Bonzini ha scritto:
> Until now, KVM used to assume that CS.RPL could always be used as the CPL
> value when KVM_SET_SREGS is called.  Unfortunately this is not the case.
> If userspace decides to call KVM_GET_SREGS/KVM_SET_SREGS exactly after
> CR0.PE has been set to 1, but before the long jump that reloads CS, the
> CPL will be reset to bits 0-1 of CS (aka CS.RPL).  This can work or not,
> depending on the placement of the code that transitions to protected
> mode.  If CS.RPL != 0 the emulator will see CS.RPL != CS.DPL (the DPL
> will always be zero) and fail to fetch the next instruction of the
> transition code.
>
> The same bug exists with SVM, where you don't have the emulator but the
> guest will triple fault.  Strangely, it doesn't occur with Intel's
> unrestricted guest mode.
>
> To trigger this using QEMU, it is enough to send "info cpus" continuously
> while running iPXE (which places its code for real->protected mode in
> the EBDA).  iPXE does a lot of transitions, and the guest will crash
> very quickly.
>
> Avi or Gleb, this is a bit tricky.  Can you review it please?

There's a simpler way to fix this, by using SS.DPL as the CPL.  Patch on 
its way...

Paolo

