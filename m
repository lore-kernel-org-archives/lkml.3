Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbaDDT3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 15:29:47 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:57634 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaDDT3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 15:29:43 -0400
Message-ID: <533F0847.6050909@linaro.org>
Date: Fri, 04 Apr 2014 14:30:15 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
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

You're right, that is one of several ways this could have
also been done.

Part of my thinking about this was affected by seeing how
arm_dt_init_cpu_maps() works.  (Well, at least how it's
structured.)  It looks for an enable method in each "cpu"
node, then falls back to looking for one in the "cpus" node
if none was seen.  It doesn't assume the extra properties
are in the "cpus" node (or a "cpu" node for that matter).
It directly supplies a node that's known to have a matching
"enable-method" property--at the time that match is found--to
make it possible to extract other relevant information from
that matching node.

(As an aside, the documentation doesn't mention that "cpus"
nodes will contain "enable-method" properties, even though
it seems that's more a function of "cpus" than each individual
"cpu".)

I think it offers useful flexibility to do it this way,
and I like that it is unambiguous which node should be
searched for the additional information.

					-Alex
