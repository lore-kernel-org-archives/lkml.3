Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946925Ab3BHTS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:18:58 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54514 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946788Ab3BHTSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:18:55 -0500
MIME-Version: 1.0
In-Reply-To: <00780235-deac-4f80-b936-867834e05661@email.android.com>
References: <20130208191213.GA25081@www.outflux.net>
	<00780235-deac-4f80-b936-867834e05661@email.android.com>
Date: Fri, 8 Feb 2013 11:18:54 -0800
X-Google-Sender-Auth: VMs9rZDsczqyLPNxu9OCK3qR1kc
Message-ID: <CAGXu5jJnLY6Qp3J6HBpVg-AdUGdKYm-e4wErZO3=NuRo04ajvg@mail.gmail.com>
Subject: Re: [PATCH] x86: Lock down MSR writing in secure boot
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No. CAP_RAWIO is for reading. Writing needs a much stronger check.

-Kees

On Fri, Feb 8, 2013 at 11:17 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> We already have CAP_RAWIO for this in mainline; I am not sure if this should be harder than that...
>
> Kees Cook <keescook@chromium.org> wrote:
>
>>Writing to MSRs should not be allowed unless CAP_COMPROMISE_KERNEL is
>>set since it could lead to execution of arbitrary code in kernel mode.
>>
>>Signed-off-by: Kees Cook <keescook@chromium.org>
>>---
>>This would be used on top of Matthew Garrett's existing "Secure boot
>>policy support" patch series.
>>---
>> arch/x86/kernel/msr.c |    7 +++++++
>> 1 file changed, 7 insertions(+)
>>
>>diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
>>index 4929502..adaab3d 100644
>>--- a/arch/x86/kernel/msr.c
>>+++ b/arch/x86/kernel/msr.c
>>@@ -103,6 +103,9 @@ static ssize_t msr_write(struct file *file, const
>>char __user *buf,
>>       int err = 0;
>>       ssize_t bytes = 0;
>>
>>+      if (!capable(CAP_COMPROMISE_KERNEL))
>>+              return -EPERM;
>>+
>>       if (count % 8)
>>               return -EINVAL; /* Invalid chunk size */
>>
>>@@ -150,6 +153,10 @@ static long msr_ioctl(struct file *file, unsigned
>>int ioc, unsigned long arg)
>>                       err = -EBADF;
>>                       break;
>>               }
>>+              if (!capable(CAP_COMPROMISE_KERNEL)) {
>>+                      err = -EPERM;
>>+                      break;
>>+              }
>>               if (copy_from_user(&regs, uregs, sizeof regs)) {
>>                       err = -EFAULT;
>>                       break;
>
> --
> Sent from my mobile phone. Please excuse brevity and lack of formatting.



--
Kees Cook
Chrome OS Security
