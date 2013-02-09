Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546Ab3BIUCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 15:02:47 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:41751 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932485Ab3BIUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 15:02:45 -0500
Message-ID: <1360440158.7515.321.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH v5 -next 1/2]efivars: Disable external interrupt while
 holding efivars->lock
From: Matt Fleming <matt@console-pimps.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Sat, 09 Feb 2013 20:02:38 +0000
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541B5@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541B5@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 00:41 +0000, Seiji Aguchi wrote:
> [Problem]
> There is a scenario which efi_pstore fails to log messages in a panic case.
> 
>  - CPUA holds an efi_var->lock in either efivarfs parts 
>    or efi_pstore with interrupt enabled.
>  - CPUB panics and sends IPI to CPUA in smp_send_stop().
>  - CPUA stops with holding the lock.
>  - CPUB kicks efi_pstore_write() via kmsg_dump(KSMG_DUMP_PANIC)
>    but it returns without logging messages.
> 
> [Patch Description]
> This patch disables an external interruption while holding efivars->lock 
> as follows.
> 
> In efi_pstore_write() and get_var_data(), spin_lock/spin_unlock is 
> replaced by spin_lock_irqsave/spin_unlock_irqrestore because they may 
> be called in an interrupt context.
> 
> In other functions, they are replaced by spin_lock_irq/spin_unlock_irq.
> because they are all called from a process context.
> 
> By applying this patch, we can avoid the problem above with 
> a following senario.
> 
>  - CPUA holds an efi_var->lock with interrupt disabled.
>  - CPUB panics and sends IPI to CPUA in smp_send_stop().
>  - CPUA receives the IPI after releasing the lock because it is
>    disabling interrupt while holding the lock.
>  - CPUB waits for one sec until CPUA releases the lock.
>  - CPUB kicks efi_pstore_write() via kmsg_dump(KSMG_DUMP_PANIC)
>    And it can hold the lock successfully.
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> Acked-by: Mike Waychison <mikew@google.com>
> ---
>  drivers/firmware/efivars.c |   86 ++++++++++++++++++++++---------------------
>  1 files changed, 44 insertions(+), 42 deletions(-)

Acked-by: Matt Fleming <matt.fleming@intel.com>

Tony, are you picking this up?

-- 
Matt Fleming, Intel Open Source Technology Center

