Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab3DBOdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:33:42 -0400
Received: from 8bytes.org ([85.214.48.195]:53724 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761251Ab3DBOdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:33:41 -0400
Date: Tue, 2 Apr 2013 16:33:36 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130402143335.GB15687@8bytes.org>
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 16:33:38 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515aec4223672016918395
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

On Wed, Mar 27, 2013 at 06:51:23PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Add logic to decode AMD IOMMU event flag based on information from AMD IOMMU specification.
> This should simplify debugging IOMMU errors.  Also, dump DTE information in additional cases.

The patch in general makes sense to have, but I have a couple of
comments.

> +static void dump_flags(int flags, int ev_type)
> +{
> +	struct _event_log_flags *p = (struct _event_log_flags *) &flags;
> +	u32 err_type = p->type;
> +
> +	pr_err("AMD-Vi: Flags details:\n");
> +	pr_err("AMD-Vi:    Guest / Nested  : %u\n", p->gn);
> +	pr_err("AMD-Vi:    No Execute      : %u\n", p->nx);
> +	pr_err("AMD-Vi:    User-Supervisor : %u\n", p->us);
> +	pr_err("AMD-Vi:    Interrupt       : %u\n", p->i);
> +	pr_err("AMD-Vi:    Present         : %u\n", p->pr);
> +	pr_err("AMD-Vi:    Read / Write    : %u\n", p->rw);
> +	pr_err("AMD-Vi:    Permission      : %u\n", p->pe);
> +	pr_err("AMD-Vi:    Reserv bit not zero / Illegal level encoding : %u\n",
> +		p->rz);
> +	pr_err("AMD-Vi:    Translation / Transaction : %u\n",
> +		p->tr);
> +	pr_err("AMD-Vi:    Type of error   : (0x%x) ", err_type);

Printing the flags multi-line is much too noisy for IOMMU events. Just
print a char-shortcut for each flag set on the same line.

> +
> +	if ((ev_type == EVENT_TYPE_DEV_TAB_ERR)  ||
> +	    (ev_type == EVENT_TYPE_PAGE_TAB_ERR) ||
> +	    (ev_type == EVENT_TYPE_CMD_HARD_ERR)) {
> +		/* Only supports up to 2 bits */
> +		err_type &= 0x3;
> +		switch (err_type) {
> +		case 0:
> +			pr_err("Reserved\n");
> +			break;
> +		case 1:
> +			pr_err("Master Abort\n");
> +			break;
> +		case 2:
> +			pr_err("Target Abort\n");
> +			break;
> +		case 3:
> +			pr_err("Data Error\n");
> +			break;
> +		}

Why do you create string-arrays for other type-encodings but not for
this one?

> +	} else if (ev_type == EVENT_TYPE_INV_DEV_REQ) {
> +		if (p->tr == 0) {
> +			if (err_type < ARRAY_SIZE(_invalid_translation_desc))
> +				printk("%s\n",
> +					_invalid_translation_desc[err_type]);
> +		} else {
> +			if (err_type < ARRAY_SIZE(_invalid_transaction_desc))
> +				printk("%s\n",
> +					_invalid_transaction_desc[err_type]);

pr_cont instead of printk.


	Joerg


