Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3BOONu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 09:13:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45837 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3BOONs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 09:13:48 -0500
Date: Fri, 15 Feb 2013 15:13:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 07/13] edac: add support for raw error reports
Message-ID: <20130215141330.GF14387@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Linux Edac Mailing List <linux-edac@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <cover.1360931635.git.mchehab@redhat.com>
 <e08f797b129a50b4e1b39e8c31bff82904aea65d.1360931635.git.mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e08f797b129a50b4e1b39e8c31bff82904aea65d.1360931635.git.mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 10:44:55AM -0200, Mauro Carvalho Chehab wrote:
> That allows APEI GHES driver to report errors directly, using
> the EDAC error report API.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/edac/edac_core.h |  17 ++++++++
>  drivers/edac/edac_mc.c   | 109 ++++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 100 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> index 23bb99f..9c5da11 100644
> --- a/drivers/edac/edac_core.h
> +++ b/drivers/edac/edac_core.h
> @@ -453,6 +453,23 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
>  extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
>  extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
>  				      unsigned long page);
> +
> +void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
> +			  struct mem_ctl_info *mci,
> +			  long grain,
> +			  const u16 error_count,
> +			  const int top_layer,
> +			  const int mid_layer,
> +			  const int low_layer,
> +			  const unsigned long page_frame_number,
> +			  const unsigned long offset_in_page,
> +			  const unsigned long syndrome,
> +			  const char *msg,
> +			  const char *location,
> +			  const char *label,
> +			  const char *other_detail,
> +			  const bool enable_per_layer_report);

The argument count of this one looks like an overkill. Maybe it would be
nicer, cleaner to do this:

void __edac_handle_mc_error(const enum hw_event_mc_err_type type,
			    struct mem_ctl_info *mci,
			    struct error_desc *e);

and struct error_desc collects all the remaining arguments.

This way you can't get the arguments order wrong, forget one or
whatever; and it would be much less stack pressure on the function
calls.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
