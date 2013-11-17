Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3KQWOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 17:14:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58430 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3KQWOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 17:14:44 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 2/3] of/selftest: Add self tests for manipulation of properties
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>
In-Reply-To: <902D15D9-439C-43BC-BD27-94785DA2F486@antoniou-consulting.com>
References: <1384537604-5032-1-git-send-email-grant.likely@linaro.org> < 1384537604-5032-3-git-send-email-grant.likely@linaro.org> < 902D15D9-439C-43BC-BD27-94785DA2F486@antoniou-consulting.com>
Date: Sun, 17 Nov 2013 22:14:39 +0000
Message-Id: <20131117221439.D09A2C406A5@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Nov 2013 19:50:37 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
> Hi Grant,
> 
> On Nov 15, 2013, at 7:46 PM, Grant Likely wrote:
> 
> > Adds a few simple test cases to ensure that addition, update and removal
> > of device tree node properties works correctly.
> > 
> > Signed-off-by: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> > Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
> > ---
> > drivers/of/selftest.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 62 insertions(+)
> > 
> > diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
> > index e21012bde639..cb8d3e722f76 100644
> > --- a/drivers/of/selftest.c
> > +++ b/drivers/of/selftest.c
> > @@ -30,6 +30,67 @@ static struct selftest_results {
> > 	} \
> > }
> > 
> > +static void __init of_selftest_dynamic(void)
> > +{
> > +	struct device_node *np;
> > +	struct property *prop;
> > +
> > +	np = of_find_node_by_path("/testcase-data");
> > +	if (!np) {
> > +		pr_err("missing testcase data\n");
> > +		return;
> > +	}
> > +
> > +	/* Array of 4 properties for the purpose of testing */
> > +	prop = kzalloc(sizeof(*prop) * 4, GFP_KERNEL);
> > +	if (!prop) {
> > +		selftest(0, "kzalloc() failed\n");
> > +		return;
> > +	}
> > +
> > +	/* Add a new property - should pass*/
> > +	prop->name = "new-property";
> > +	prop->value = "new-property-data";
> > +	prop->length = strlen(prop->value);
> > +	selftest(of_add_property(np, prop) == 0, "Adding a new property failed\n");
> > +
> > +	/* Try to add an existing property - should fail */
> > +	prop++;
> > +	prop->name = "new-property";
> > +	prop->value = "new-property-data-should-fail";
> > +	prop->length = strlen(prop->value);
> > +	selftest(of_add_property(np, prop) != 0,
> > +		 "Adding an existing property should have failed\n");
> > +
> > +	/* Try to modify an existing property - should pass */
> > +	prop->value = "modify-property-data-should-pass";
> > +	prop->length = strlen(prop->value);
> > +	selftest(of_update_property(np, prop) == 0,
> > +		 "Updating an existing property should have passed\n");
> > +
> > +	/* Try to modify non-existent property - should pass*/
> > +	prop++;
> > +	prop->name = "modify-property";
> > +	prop->value = "modify-missing-property-data-should-pass";
> > +	prop->length = strlen(prop->value);
> > +	selftest(of_update_property(np, prop) == 0,
> > +		 "Updating a missing property should have passed\n");
> > +
> > +	/* Remove property - should pass */
> > +	selftest(of_remove_property(np, prop) == 0,
> > +		 "Removing a property should have passed\n");
> > +
> > +	/* Adding very large property - should pass */
> > +	prop++;
> > +	prop->name = "large-property-PAGE_SIZEx8";
> > +	prop->length = PAGE_SIZE * 8;
> > +	prop->value = kzalloc(prop->length, GFP_KERNEL);
> > +	selftest(prop->value != NULL, "Unable to allocate large buffer\n");
> > +	if (prop->value)
> > +		selftest(of_add_property(np, prop) == 0,
> > +			 "Adding a large property should have passed\n");
> > +}
> > +
> > static void __init of_selftest_parse_phandle_with_args(void)
> > {
> > 	struct device_node *np;
> > @@ -312,6 +373,7 @@ static int __init of_selftest(void)
> > 	of_node_put(np);
> > 
> > 	pr_info("start of selftest - you will see error messages\n");
> > +	of_selftest_dynamic();
> > 	of_selftest_parse_phandle_with_args();
> > 	of_selftest_property_match_string();
> > 	of_selftest_parse_interrupts();
> > -- 
> > 1.8.3.2
> > 
> 
> I like this. I'll add my overlay test cases somewhere around here.
> 
> I might need to introduce some new helper functions in order to generate
> the overlay completely programmatically.

That would be good. I also really want to get the overlay code working
so I can use it for loading the testcase data on any running system.
:-)

g.

