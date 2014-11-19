Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaKSKaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:30:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54975 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbaKSK37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:29:59 -0500
Date: Wed, 19 Nov 2014 11:29:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: ruiv.wang@gmail.com
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com,
        gong.chen@linux.intel.com, rui.y.wang@intel.com
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Message-ID: <20141119102954.GA5617@pd.tnic>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:22:41PM +0800, ruiv.wang@gmail.com wrote:
> From: Rui Wang <rui.y.wang@intel.com>
> 
> There are cases when an machine check panics without giving any information
> about the error:
> 
> [  177.806166] Kernel panic - not syncing: Machine check from unknown source
> 
> No information besides that it is a machine check. This happens in two cases:
> 1) The CPU logs the error with the MCi_STATUS.EN bit set to zero, and Linux
>    ignores EN=0 entries (as it should).

Well, I guess we shouldn't anymore. Apparently hw forgets to set the
bit when raising an MCE so then we should ignore it too in mce-severity
and delete that piece or grade it as higher severity based on, I dunno,
b0rked hardware family/model/stepping or whatever bit we set...

        MCESEV(
                NO, "Not enabled",
                BITCLR(MCI_STATUS_EN)
                ),

> 2) In normal processing the MCE handler ignores banks that do not contain fatal
>    or unrecoverable errors (these would later be found and logged by the CMCI
>    handler). If we panic, these will never be logged, but could be important
>    to diagnose the problem.

Well, we do this:

                /*
                 * Non uncorrected or non signaled errors are handled by
                 * machine_check_poll. Leave them alone, unless this panics.
                 */
                if (!(m.status & (cfg->ser ? MCI_STATUS_S : MCI_STATUS_UC)) &&
                        !no_way_out)
                        continue;

so no_way_out gets indirectly controlled by mce-severity too. So I guess
mce-severity would need adjusting instead of adding more stuff to the #MC
handler.

Btw, the panic message comes from

        /*
         * No machine check event found. Must be some external
         * source or one CPU is hung. Panic.
         */
        if (global_worst <= MCE_KEEP_SEVERITY && mca_cfg.tolerant < 3)
                mce_panic("Machine check from unknown source", NULL, NULL);

so fixing mce_severity is what should happen here instead, IMO.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
