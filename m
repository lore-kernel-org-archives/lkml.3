Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3JNVvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:51:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37165 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175Ab3JNVu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:50:59 -0400
Date: Mon, 14 Oct 2013 23:50:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Lance Ortiz <lance.ortiz@hp.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output
 format
Message-ID: <20131014215047.GL4009@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
 <20131011160208.GL5925@pd.tnic>
 <20131014045500.GC12189@gchen.bj.intel.com>
 <20131014103616.GE4009@pd.tnic>
 <CA+8MBbJ9P1GVf3SCh7LMY_LH+pxQg3GWkxKMzni1b1Wyx1o8NQ@mail.gmail.com>
 <20131014184717.GK4009@pd.tnic>
 <CA+8MBbKDhFvRmJv1csMp5At8WfvHvSsDBbCKvOfQhVdgmnwBWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbKDhFvRmJv1csMp5At8WfvHvSsDBbCKvOfQhVdgmnwBWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 02:03:16PM -0700, Tony Luck wrote:
> Do you have a suggested mechanism for this disabling of dmesg?

Hmm, how about a 64-bit flag variable (we can use the remaining bits
for other stuff later) called x86_ras_flags which is private to
arch/x86/ras/core.c (a new file)...

 [ btw, I'm thinking of something similar to efi's x86_efi_facility which we
 nicely query with test_bit and set with set_bit and clear_bit, etc, etc ]

Also, look at arch/x86/platform/efi/efi.c::efi_enabled() how it hides
the actual variable and we can do something similar so that eMCA and
other users like cper.c can do

apei_estatus_print_section:

	if (!ras_tracepoint_enabled())
		cper_print_mem(...)

We set the bit in x86_ras_flags from, say, debugfs, i.e., a userspace
tool sets it and from that moment on all RAS output is rerouted to the
trace event. I.e., the output for which there is a trace event...

How does that look like?

Purely hypothetical, of course, I might me missing something but it
looks ok from here. As always, the devil is in the detail, of course.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
