Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab3DBOjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:39:33 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:32551
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932161Ab3DBOjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:39:32 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z551bizbb2dI98dI9371I1432Id799h4015Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0MKMU1M-02-HJR-02
X-M-MSG: 
Message-ID: <515AED9E.80204@amd.com>
Date: Tue, 2 Apr 2013 09:39:26 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] iommu/amd: Add logic to decode AMD IOMMU event flag
References: <1364428283-2548-1-git-send-email-suravee.suthikulpanit@amd.com> <20130402143335.GB15687@8bytes.org>
In-Reply-To: <20130402143335.GB15687@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2013 9:33 AM, Joerg Roedel wrote:
> Hi Suravee,
>
> On Wed, Mar 27, 2013 at 06:51:23PM -0500, suravee.suthikulpanit@amd.com wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> Add logic to decode AMD IOMMU event flag based on information from AMD IOMMU specification.
>> This should simplify debugging IOMMU errors.  Also, dump DTE information in additional cases.
> The patch in general makes sense to have, but I have a couple of
> comments.
>
>> +static void dump_flags(int flags, int ev_type)
>> +{
>> +	struct _event_log_flags *p = (struct _event_log_flags *) &flags;
>> +	u32 err_type = p->type;
>> +
>> +	pr_err("AMD-Vi: Flags details:\n");
>> +	pr_err("AMD-Vi:    Guest / Nested  : %u\n", p->gn);
>> +	pr_err("AMD-Vi:    No Execute      : %u\n", p->nx);
>> +	pr_err("AMD-Vi:    User-Supervisor : %u\n", p->us);
>> +	pr_err("AMD-Vi:    Interrupt       : %u\n", p->i);
>> +	pr_err("AMD-Vi:    Present         : %u\n", p->pr);
>> +	pr_err("AMD-Vi:    Read / Write    : %u\n", p->rw);
>> +	pr_err("AMD-Vi:    Permission      : %u\n", p->pe);
>> +	pr_err("AMD-Vi:    Reserv bit not zero / Illegal level encoding : %u\n",
>> +		p->rz);
>> +	pr_err("AMD-Vi:    Translation / Transaction : %u\n",
>> +		p->tr);
>> +	pr_err("AMD-Vi:    Type of error   : (0x%x) ", err_type);
> Printing the flags multi-line is much too noisy for IOMMU events. Just
> print a char-shortcut for each flag set on the same line.
I will make the changes and send in for new patch for review.
>
>> +
>> +	if ((ev_type == EVENT_TYPE_DEV_TAB_ERR)  ||
>> +	    (ev_type == EVENT_TYPE_PAGE_TAB_ERR) ||
>> +	    (ev_type == EVENT_TYPE_CMD_HARD_ERR)) {
>> +		/* Only supports up to 2 bits */
>> +		err_type &= 0x3;
>> +		switch (err_type) {
>> +		case 0:
>> +			pr_err("Reserved\n");
>> +			break;
>> +		case 1:
>> +			pr_err("Master Abort\n");
>> +			break;
>> +		case 2:
>> +			pr_err("Target Abort\n");
>> +			break;
>> +		case 3:
>> +			pr_err("Data Error\n");
>> +			break;
>> +		}
> Why do you create string-arrays for other type-encodings but not for
> this one?
I can do the same way if that's preferred.

Thanks,

Suravee
>
>> +	} else if (ev_type == EVENT_TYPE_INV_DEV_REQ) {
>> +		if (p->tr == 0) {
>> +			if (err_type < ARRAY_SIZE(_invalid_translation_desc))
>> +				printk("%s\n",
>> +					_invalid_translation_desc[err_type]);
>> +		} else {
>> +			if (err_type < ARRAY_SIZE(_invalid_transaction_desc))
>> +				printk("%s\n",
>> +					_invalid_transaction_desc[err_type]);
> pr_cont instead of printk.
>
>
> 	Joerg
>
>
>


