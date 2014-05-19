Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaESNjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:39:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18323 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbaESNjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:39:05 -0400
X-IronPort-AV: E=Sophos;i="4.98,867,1392163200"; 
   d="scan'208";a="132390340"
Message-ID: <537A0974.40302@citrix.com>
Date: Mon, 19 May 2014 14:39:00 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <mjg59@srcf.ucam.org>, <jeremy@goop.org>, <matt.fleming@intel.com>,
        <ian.campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <mingo@redhat.com>, <david.vrabel@citrix.com>, <jbeulich@suse.com>,
        <hpa@zytor.com>, <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <eshelton@pobox.com>
Subject: Re: [Xen-devel] [PATCH v4 3/5] xen: Put EFI machinery in place
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com> <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.18]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/14 21:41, Daniel Kiper wrote:
> @@ -0,0 +1,374 @@
> +/*
> + * EFI support for Xen.
> + *
> + * Copyright (C) 1999 VA Linux Systems
> + * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
> + * Copyright (C) 1999-2002 Hewlett-Packard Co.
> + *	David Mosberger-Tang <davidm@hpl.hp.com>
> + *	Stephane Eranian <eranian@hpl.hp.com>
> + * Copyright (C) 2005-2008 Intel Co.
> + *	Fenghua Yu <fenghua.yu@intel.com>
> + *	Bibo Mao <bibo.mao@intel.com>
> + *	Chandramouli Narayanan <mouli@linux.intel.com>
> + *	Huang Ying <ying.huang@intel.com>
> + * Copyright (C) 2011 Novell Co.
> + *	Jan Beulich <JBeulich@suse.com>
> + * Copyright (C) 2011-2012 Oracle Co.
> + *	Liang Tang <liang.tang@oracle.com>
> + * Copyright (c) 2014 Daniel Kiper, Oracle Corporation
> + */
> +
> +#include <linux/bug.h>
> +#include <linux/efi.h>
> +#include <linux/init.h>
> +#include <linux/string.h>
> +
> +#include <xen/interface/xen.h>
> +#include <xen/interface/platform.h>
> +
> +#include <asm/xen/hypercall.h>
> +
> +#define call (op.u.efi_runtime_call)

I think not.

> +#define DECLARE_CALL(what) \
> +	struct xen_platform_op op; \
> +	op.cmd = XENPF_efi_runtime_call; \
> +	call.function = XEN_EFI_##what; \
> +	call.misc = 0

Macros like this which explicitly create local variable with implicit
names are evil when reading code.

If you want to do initialisation like this, then at least do something like:

#define INIT_EFI_CALL(what) \
{ .cmd = XENPF_efi_runtime_call, \
   .u.efi_runtime_call.function = XEN_EFI_##what, \
   .u.efi_runtime_call.misc = 0 }

And use it as:

struct xen_platform_op op = INIT_EFI_CALL(foo);

~Andrew
