Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3KPRur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 12:50:47 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:53601 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267Ab3KPRul convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 12:50:41 -0500
Subject: Re: [PATCH v5 2/3] of/selftest: Add self tests for manipulation of properties
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1384537604-5032-3-git-send-email-grant.likely@linaro.org>
Date: Sat, 16 Nov 2013 19:50:37 +0200
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <902D15D9-439C-43BC-BD27-94785DA2F486@antoniou-consulting.com>
References: <1384537604-5032-1-git-send-email-grant.likely@linaro.org> <1384537604-5032-3-git-send-email-grant.likely@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 15, 2013, at 7:46 PM, Grant Likely wrote:

> Adds a few simple test cases to ensure that addition, update and removal
> of device tree node properties works correctly.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
> drivers/of/selftest.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
> 1 file changed, 62 insertions(+)
> 
> diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
> index e21012bde639..cb8d3e722f76 100644
> --- a/drivers/of/selftest.c
> +++ b/drivers/of/selftest.c
> @@ -30,6 +30,67 @@ static struct selftest_results {
> 	} \
> }
> 
> +static void __init of_selftest_dynamic(void)
> +{
> +	struct device_node *np;
> +	struct property *prop;
> +
> +	np = of_find_node_by_path("/testcase-data");
> +	if (!np) {
> +		pr_err("missing testcase data\n");
> +		return;
> +	}
> +
> +	/* Array of 4 properties for the purpose of testing */
> +	prop = kzalloc(sizeof(*prop) * 4, GFP_KERNEL);
> +	if (!prop) {
> +		selftest(0, "kzalloc() failed\n");
> +		return;
> +	}
> +
> +	/* Add a new property - should pass*/
> +	prop->name = "new-property";
> +	prop->value = "new-property-data";
> +	prop->length = strlen(prop->value);
> +	selftest(of_add_property(np, prop) == 0, "Adding a new property failed\n");
> +
> +	/* Try to add an existing property - should fail */
> +	prop++;
> +	prop->name = "new-property";
> +	prop->value = "new-property-data-should-fail";
> +	prop->length = strlen(prop->value);
> +	selftest(of_add_property(np, prop) != 0,
> +		 "Adding an existing property should have failed\n");
> +
> +	/* Try to modify an existing property - should pass */
> +	prop->value = "modify-property-data-should-pass";
> +	prop->length = strlen(prop->value);
> +	selftest(of_update_property(np, prop) == 0,
> +		 "Updating an existing property should have passed\n");
> +
> +	/* Try to modify non-existent property - should pass*/
> +	prop++;
> +	prop->name = "modify-property";
> +	prop->value = "modify-missing-property-data-should-pass";
> +	prop->length = strlen(prop->value);
> +	selftest(of_update_property(np, prop) == 0,
> +		 "Updating a missing property should have passed\n");
> +
> +	/* Remove property - should pass */
> +	selftest(of_remove_property(np, prop) == 0,
> +		 "Removing a property should have passed\n");
> +
> +	/* Adding very large property - should pass */
> +	prop++;
> +	prop->name = "large-property-PAGE_SIZEx8";
> +	prop->length = PAGE_SIZE * 8;
> +	prop->value = kzalloc(prop->length, GFP_KERNEL);
> +	selftest(prop->value != NULL, "Unable to allocate large buffer\n");
> +	if (prop->value)
> +		selftest(of_add_property(np, prop) == 0,
> +			 "Adding a large property should have passed\n");
> +}
> +
> static void __init of_selftest_parse_phandle_with_args(void)
> {
> 	struct device_node *np;
> @@ -312,6 +373,7 @@ static int __init of_selftest(void)
> 	of_node_put(np);
> 
> 	pr_info("start of selftest - you will see error messages\n");
> +	of_selftest_dynamic();
> 	of_selftest_parse_phandle_with_args();
> 	of_selftest_property_match_string();
> 	of_selftest_parse_interrupts();
> -- 
> 1.8.3.2
> 

I like this. I'll add my overlay test cases somewhere around here.

I might need to introduce some new helper functions in order to generate
the overlay completely programmatically.

Regards

-- Pantelis



