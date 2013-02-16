Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3BPALx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 19:11:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39090 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3BPALw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 19:11:52 -0500
Message-ID: <511ECE53.8040801@zytor.com>
Date: Fri, 15 Feb 2013 16:09:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: Steven Rostedt <rostedt@goodmis.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH v9 2/3] trace,x86: add x86 irq vector tracepoints
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A64C4B@USINDEM103.corp.hds.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 02:49 PM, Seiji Aguchi wrote:
> +
> +static void switch_to_trace_idt(void *arg)
> +{
> +	store_idt(this_cpu_ptr(&orig_idt_descr));
> +	load_idt(&trace_idt_descr);
> +
> +	return;
> +}
> +
> +static void restore_original_idt(void *arg)
> +{
> +	if (this_cpu_read(orig_idt_descr.address)) {
> +		load_idt(this_cpu_ptr(&orig_idt_descr));
> +		this_cpu_write(orig_idt_descr.address, 0);
> +	}
> +
> +	return;
> +}
> +

The base address of the IDT doesn't generally change... the one
exception is when we do the funny NMI workaround.

For that reason, I would be happier if we just restored the standard
value instead of saving/restoring stuff.

The above code is probably broken if either side is in the funny NMI
zone... unless you can guarantee it is *always* in the funny NMI zone
(in which case you can just load nmi_idt_descr instead.

Steve R., do you know what the constraints are with respect to that?

	-hpa


