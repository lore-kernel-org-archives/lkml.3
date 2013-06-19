Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3FSEc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 00:32:28 -0400
Received: from ozlabs.org ([203.10.76.45]:36530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab3FSEc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 00:32:27 -0400
From: Michael Neuling <michael.neuling@au1.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
cc: mingo@kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@ozlabs.org, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf: Add support for the mem_xlvl field.
In-reply-to: <20130607204043.GB3281@us.ibm.com>
References: <20130607204008.GA3281@us.ibm.com> <20130607204043.GB3281@us.ibm.com>
Comments: In-reply-to Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
   message dated "Fri, 07 Jun 2013 13:40:43 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 19 Jun 2013 14:32:24 +1000
Message-ID: <14038.1371616344@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> wrote:

> From 9f1a8a16e0ef36447e343d1cd4797c2b6a81225f Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Fri, 7 Jun 2013 13:26:31 -0700
> Subject: [PATCH 2/2] perf: Add support for the mem_xlvl field.
> 
> A follow-on patch to adding perf_mem_data_src support for Power7.
> At this point, this is only  touch-tested as am looking for feedback
> on the main kernel patch.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  tools/perf/util/sort.c |   31 ++++++++++++++++++++++++++++++-
>  1 files changed, 30 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
> index 5f52d49..24bbf4d 100644
> --- a/tools/perf/util/sort.c
> +++ b/tools/perf/util/sort.c
> @@ -631,9 +631,11 @@ static int hist_entry__tlb_snprintf(struct hist_entry *self, char *bf,
>  static int64_t
>  sort__lvl_cmp(struct hist_entry *left, struct hist_entry *right)
>  {
> +	int64_t rc;
>  	union perf_mem_data_src data_src_l;
>  	union perf_mem_data_src data_src_r;
>  
> +	data_src_l.val = data_src_r.val = (int64_t)0;
>  	if (left->mem_info)
>  		data_src_l = left->mem_info->data_src;
>  	else
> @@ -644,7 +646,11 @@ sort__lvl_cmp(struct hist_entry *left, struct hist_entry *right)
>  	else
>  		data_src_r.mem_lvl = PERF_MEM_LVL_NA;
>  
> -	return (int64_t)(data_src_r.mem_lvl - data_src_l.mem_lvl);
> +	rc = data_src_r.mem_lvl - data_src_l.mem_lvl;
> +	if (!rc)
> +		rc = data_src_r.mem_xlvl - data_src_l.mem_xlvl;
> +		

whitespace here

> +	return rc;
>  }
>  
>  static const char * const mem_lvl[] = {
> @@ -663,7 +669,14 @@ static const char * const mem_lvl[] = {
>  	"I/O",
>  	"Uncached",
>  };
> +
> +static const char * const mem_xlvl[] = {
> +	"Remote RAM (3 hops)",
> +	"Remote Cache (3 hops)",
> +};
> +
>  #define NUM_MEM_LVL (sizeof(mem_lvl)/sizeof(const char *))
> +#define NUM_MEM_XLVL (sizeof(mem_xlvl)/sizeof(const char *))
>  
>  static int hist_entry__lvl_snprintf(struct hist_entry *self, char *bf,
>  				    size_t size, unsigned int width)
> @@ -695,6 +708,22 @@ static int hist_entry__lvl_snprintf(struct hist_entry *self, char *bf,
>  		strncat(out, mem_lvl[i], sz - l);
>  		l += strlen(mem_lvl[i]);
>  	}
> +
> +	m = 0;
> +	if (self->mem_info)
> +		m = self->mem_info->data_src.mem_xlvl;
> +
> +	for (i = 0; m && i < NUM_MEM_XLVL; i++, m >>= 1) {
> +		if (!(m & 0x1))
> +			continue;
> +		if (l) {
> +			strcat(out, " or ");
> +			l += 4;
> +		}
> +		strncat(out, mem_xlvl[i], sz - l);
> +		l += strlen(mem_xlvl[i]);
> +	}
> +
>  	if (*out == '\0')
>  		strcpy(out, "N/A");
>  	if (hit)
> -- 
> 1.7.1
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 
