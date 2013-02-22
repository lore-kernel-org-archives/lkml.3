Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3BVVzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:55:49 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6210 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab3BVVzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:55:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Fri, 22 Feb 2013 13:54:17 -0800
Message-ID: <5127E95E.4010500@nvidia.com>
Date: Fri, 22 Feb 2013 16:55:42 -0500
From: Rhyland Klein <rklein@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/3] power: power_supply: Add core support for supplied_nodes
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com> <1361488272-21010-3-git-send-email-rklein@nvidia.com> <5127CBD9.9050501@wwwdotorg.org>
In-Reply-To: <5127CBD9.9050501@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2013 2:49 PM, Stephen Warren wrote:
> On 02/21/2013 04:11 PM, Rhyland Klein wrote:
>> With the growing support for dt, it make sense to try to make use of
>> dt features to make the general code cleaner. This patch is an
>> attempt to commonize how chargers and their supplies are linked.
>>
>> Following common dt convention, the "supplied-to" char** list is
>> replaced with phandle lists defined in the supplies which contain
>> phandles of their suppliers.
>>
>> This has the effect however of introducing an inversion in the internal
>> mechanics of how this information is stored. In the case of non-dt,
>> the char** list of supplies is stored in the charger. In the dt case,
>> a device_node * list is stored in the supplies of their chargers,
>> however this seems to be the only way to support this.
> When parsing the DT, you can convert from phandle (or struct device_node
> *) to the name of the referenced supply by simple lookup. So, you could
> store supply names rather than device_node *. Can't you then also fill
> in the referenced supply's existing char** list of supplies?
>
> Of course, making this interact-with/use -EPROBE_DEFERRED might be
> challenging, since this would be operating in the inverse order to other
> producer/consumer relationships, which might cause loops.
The main problem I ran into when I was essentially trying to do this, 
was that the list of names that
are used to match the power_supplies are the strings set as "name" in 
the power_supply structs. This
doesn't get set automatically based on their nodes, and it is currently 
up to each driver to define their
own name.

For example, the sbs-battery driver uses the name "sbs-XXX" where XX is 
its dev_name. Other drivers
use "%s-$%d" as i2c_device_id->name, + instance number. Then the only 
solution I see is to require a new
property that defines the power-supply's name in the devicetree.

This solution with device_nodes, while not ideal, seems the be the best 
bet from what I see. Maybe
someone else has a better idea.

-rhyland

-- 
nvpublic

