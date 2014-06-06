Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaFFPVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:21:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:58862 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752180AbaFFPVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:21:32 -0400
Date: Fri, 6 Jun 2014 11:21:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140606112127.37d2cf95@gandalf.local.home>
In-Reply-To: <20140606065141.GA10998@gchen.bj.intel.com>
References: <20140528163452.GF17196@pd.tnic>
	<20140528125625.6f6dcf7f@gandalf.local.home>
	<20140530092232.GA13495@gchen.bj.intel.com>
	<20140530100716.GE28131@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
	<20140530210759.267a854e@gandalf.local.home>
	<3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
	<20140602125748.7093ced8@gandalf.local.home>
	<20140603083606.GA15476@gchen.bj.intel.com>
	<20140603103544.207eaa6e@gandalf.local.home>
	<20140606065141.GA10998@gchen.bj.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014 02:51:41 -0400
"Chen, Gong" <gong.chen@linux.intel.com> wrote:


> +/*
> + * MCE Extended Error Log trace event
> + *
> + * These events are generated when hardware detects a corrected or
> + * uncorrected event.
> + */
> +
> +/* memory trace event */
> +
> +TRACE_EVENT(extlog_mem_event,
> +	TP_PROTO(struct cper_sec_mem_err *mem,
> +		 u32 err_seq,
> +		 const uuid_le *fru_id,
> +		 const char *fru_text,
> +		 u8 sev),
> +
> +	TP_ARGS(mem, err_seq, fru_id, fru_text, sev),
> +
> +	TP_STRUCT__entry(
> +		__field(u32, err_seq)
> +		__field(u8, etype)
> +		__field(u8, sev)
> +		__field(u64, pa)
> +		__field(u8, pa_mask_lsb)
> +		__dynamic_array(char, fru, 48)
> +		__dynamic_array(u8, data, sizeof(struct cper_mem_err_compact))

For constant size arrays, don't use __dynamic_array() just use
__array().

Although I'd get rid of the fru and replace that with:

		__field(unsigned long, fru_id)
		__string(fru_text, fru_text)


> +	),
> +
> +	TP_fast_assign(
> +		__entry->err_seq = err_seq;
> +		if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE)
> +			__entry->etype = mem->error_type;
> +		else
> +			__entry->etype = ~0;
> +		__entry->sev = sev;
> +		if (mem->validation_bits & CPER_MEM_VALID_PA)
> +			__entry->pa = mem->physical_addr;
> +		else
> +			__entry->pa = ~0ull;
> +
> +		if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
> +			__entry->pa_mask_lsb =
> +				(u8)__ffs64(mem->physical_addr_mask);
> +		else
> +			__entry->pa_mask_lsb = ~0;
> +		snprintf(__get_dynamic_array(fru), 47,
> +			 "FRU: %pUl %.20s", fru_id, fru_text);

Although, why not just save the id and text straight? Why format it
here?

	__entry->fru_id = fru_id;
	__assign_str(fru_text, fru_text);

> +		cper_mem_err_pack(mem, __get_dynamic_array(data));
> +	),
> +
> +	TP_printk("{%d} %s error: %s physical addr: %016llx (mask lsb: %x) %s%s",

	TP_printk("{%d} %s error: %s physical addr: %016llx (mask lsb: %x) %s FRU: %pUl %.20s",

> +		  __entry->err_seq,
> +		  cper_severity_str(__entry->sev),
> +		  cper_mem_err_type_str(__entry->etype),
> +		  __entry->pa,
> +		  __entry->pa_mask_lsb,
> +		  cper_mem_err_unpack(p, __get_dynamic_array(data)),
> +		  __get_str(fru))

		__entry->fru_id,
		__get_str(fru_text))

-- Steve

> +);
>  
>  /*
>   * Hardware Events Report

