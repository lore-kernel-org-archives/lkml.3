Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbaEEWCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:02:06 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:47336 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbaEEWCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:02:02 -0400
Message-ID: <53680A5B.4060208@linaro.org>
Date: Mon, 05 May 2014 17:02:03 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org, arnd@arndb.de
CC: bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ARM: add SMP support for Broadcom mobile SoCs
References: <1396577891-2713-1-git-send-email-elder@linaro.org> <1396577891-2713-3-git-send-email-elder@linaro.org> <533EF21C.6000909@codeaurora.org>
In-Reply-To: <533EF21C.6000909@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 12:55 PM, Stephen Boyd wrote:
> On 04/03/14 19:18, Alex Elder wrote:
>> +
>> +/*
>> + * Secondary startup method setup routine to extract the location of
>> + * the secondary boot register from a "cpu" or "cpus" device tree
>> + * node.  Only the first seen secondary boot register value is used;
>> + * any others are ignored.  The secondary boot register value must be
>> + * non-zero.
>> + *
>> + * Returns 0 if successful or an error code otherwise.
>> + */
>> +static int __init of_enable_method_setup(struct device_node *node)
>> +{
>> +	int ret;
>> +
>> +	/* Ignore all but the first one specified */
>> +	if (secondary_boot)
>> +		return 0;
>> +
>> +	ret = of_property_read_u32(node, OF_SECONDARY_BOOT, &secondary_boot);
>> +	if (ret)
>> +		pr_err("%s: missing/invalid " OF_SECONDARY_BOOT " property\n",
>> +			node->name);
>> +
>> +	return ret;
>> +}
> 
> I don't understand why we need this. Why can't we get the secondary boot
> address from the /cpus node in the smp_prepare_cpus op. It isn't that
> hard to get access to the cpus node there via of_find_node_by_path().
> Then we don't need patch 1 at all. If it turns out to be common stuff,
> we can always have the common function live in arm common code or maybe
> even be a devicetree API.

I already responded to this, but never got any response.  I
was preparing to re-send this series and wanted to try to
pull the added feature (patch 1) out and not be dependent on
it.  But I think it's a bit ugly so I'm hoping to get a
blessing to proceed with what I originally proposed.  For
reference, here's the thread:
    https://lkml.org/lkml/2014/4/3/421

What I'm trying to do is get the value of a "secondary-boot-reg"
property from a node known to have an "enable-method" property
that matches the method name supplied in CPU_METHOD_OF_DECLARE().

Using the callback function as I originally proposed, this is
very easy.  When arm_dt_init_cpu_maps() parses the "cpus" portion
of the device tree it calls set_smp_ops_by_method() for a
matching "cpu" or "cpus" node, and that function supplies
the node to the callback function. The callback can extract
additional property values if needed.

If I hold off until smp_prepare_cpus() is called, I have to
re-parse the device tree to find the "cpus" node (this is
in itself trivial).  I then need to re-parse that node to
verify the matching "enable-method" property is found before
looking for the parameter information I need for that enable
method.  I would really prefer not to re-do this parsing
step.  It's imprecise and a little inefficient, and it
duplicates (but not exactly) logic that's already performed
by arm_dt_init_cpu_maps().

One more point of clarification.  This "secondary-boot-reg"
value is *not* the secondary boot address--that is, it's
not the address secondary cores jump to when they are
activated.  Instead, this is the address of a register
that's used to request the ROM code release a core from
its ROM-implemented holding pen.  For this machine,
control jumps at that point to secondary_startup(),
defined in arch/arm/kernel/head.S.

So...

Stephen, I'd like to hear from you whether my explanation
is adequate, and whether you think my addition and use of
CPU_METHOD_OF_DECLARE_SETUP() is reasonable.  (If you have
a suggestion for a better name, I'm open.)

If you still don't like it, I'll follow up with a
new version of the patches, this time parsing the
device tree in the smp_prepare_cpus() method as
you suggested.  I don't want this to hold up getting
this SMP support into the kernel.

Thanks.

					-Alex

