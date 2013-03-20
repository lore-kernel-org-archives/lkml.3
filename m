Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3CTDFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:05:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42975 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3CTDFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:05:00 -0400
Message-ID: <514926C0.3020502@zytor.com>
Date: Tue, 19 Mar 2013 20:02:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tboot-devel@lists.sourceforge.net" 
	<tboot-devel@lists.sourceforge.net>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH v2] x86: add a new SMP bring up way for tboot case
References: <1349950267-28328-1-git-send-email-qiaowei.ren@intel.com> <9E0BE1322F2F2246BD820DA9FC397ADE4E0171@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE4E0171@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 07:14 PM, Ren, Qiaowei wrote:
> Any comments on this patch?
> 
> Thanks,
> Qiaowei

The biggest question is probably if we can use an existing hook of some
sort.

Overriding the apic method is probably not the right way to go, though.
 tglx, do you have any opinions here?

Furthermore, this really is not nice:

> +int tboot_wake_up(int apicid, unsigned long sipi_vec) {
> +	if (!tboot_enabled())
> +		return 0;
> +
> +	if ((tboot->version < 6) ||
> +	    !(tboot->flags & TB_FLAG_AP_WAKE_SUPPORT))
> +		return 0;
> +
> +	tboot->ap_wake_addr = sipi_vec;
> +	tboot->ap_wake_trigger = apicid;
> +
> +	return 1;
> +}

Not only don't you set boot_error for the code above it, but there is
absolutely no indication how that does its job (are those active
operations?  If so they should use writel()), nor does it include any
kind of synchronization.

	-hpa

