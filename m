Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaBQQWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:22:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59375 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaBQQWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:22:14 -0500
Message-ID: <5302371B.4090403@zytor.com>
Date: Mon, 17 Feb 2014 08:21:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 1/3] x86: Add another set of MSR accessor functions
References: <1391953709-15400-1-git-send-email-bp@alien8.de> <1391953709-15400-2-git-send-email-bp@alien8.de>
In-Reply-To: <1391953709-15400-2-git-send-email-bp@alien8.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good patch series overall, but I do have some issues with this one:

On 02/09/2014 05:48 AM, Borislav Petkov wrote:
> + */
> +int msr_read(u32 msr, struct msr *m)
> +{
> +	int err;
> +	u64 val;
> +
> +	val = native_read_msr_safe(msr, &err);

I don't think we should use the native_ function here.

> +	if (err)
> +		pr_warn("%s: Error reading MSR 0x%08x\n", __func__, msr);
> +	else
> +		m->q = val;

I also don't think we should print a message if the MSR doesn't exist.
This will be a normal occurrence in a number of flows.

> +static int __flip_bit(u32 msr, u8 bit, bool set)
> +{
> +	struct msr m;
> +
> +	if (bit > 63)
> +		return -1;

Feels a bit excessive, but I'd suggest returning -EINVAL instead.

I would suggest explicitly making this an inline function.

> +	if (msr_read(msr, &m))
> +		return -1;

Return -EIO?

How about:

	m1 = m;
	if (set)
		m1.q |= BIT_64(bit);
	else
		m1.q &= ~BIT_64(bit);

	if (m1.q != m.q) {
		if (msr_write(...))
			...
	}

> +
> +/**
> + * Set @bit in a MSR @msr.
> + *
> + * Retval:
> + * < 0: An error was encountered.
> + * = 0: Bit was already set.
> + * > 0: Hardware accepted the MSR write.
> + */
> +int msr_set_bit(u32 msr, u8 bit)
> +{
> +	int err = __flip_bit(msr, bit, true);
> +	if (err < 0)
> +		pr_err("%s: Error setting bit %d in MSR 0x%08x.\n",
> +			__func__, bit, msr);
> +
> +	return err;
> +}

Again, I'm not sure if printing a message here makes sense.  In fact,
this is the second message you print for the same thing.

	-hpa

