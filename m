Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab3BVXBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:01:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47508 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757867Ab3BVXBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:01:15 -0500
Message-ID: <5127F8B5.10002@wwwdotorg.org>
Date: Fri, 22 Feb 2013 16:01:09 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/3] power: power_supply: Add core support for supplied_nodes
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com> <1361488272-21010-3-git-send-email-rklein@nvidia.com> <5127CBD9.9050501@wwwdotorg.org> <5127E95E.4010500@nvidia.com>
In-Reply-To: <5127E95E.4010500@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 02:55 PM, Rhyland Klein wrote:
> On 2/22/2013 2:49 PM, Stephen Warren wrote:
>> On 02/21/2013 04:11 PM, Rhyland Klein wrote:
>>> With the growing support for dt, it make sense to try to make use of
>>> dt features to make the general code cleaner. This patch is an
>>> attempt to commonize how chargers and their supplies are linked.
>>>
>>> Following common dt convention, the "supplied-to" char** list is
>>> replaced with phandle lists defined in the supplies which contain
>>> phandles of their suppliers.
>>>
>>> This has the effect however of introducing an inversion in the internal
>>> mechanics of how this information is stored. In the case of non-dt,
>>> the char** list of supplies is stored in the charger. In the dt case,
>>> a device_node * list is stored in the supplies of their chargers,
>>> however this seems to be the only way to support this.
>> When parsing the DT, you can convert from phandle (or struct device_node
>> *) to the name of the referenced supply by simple lookup. So, you could
>> store supply names rather than device_node *. Can't you then also fill
>> in the referenced supply's existing char** list of supplies?
>>
>> Of course, making this interact-with/use -EPROBE_DEFERRED might be
>> challenging, since this would be operating in the inverse order to other
>> producer/consumer relationships, which might cause loops.
> The main problem I ran into when I was essentially trying to do this,
> was that the list of names that
> are used to match the power_supplies are the strings set as "name" in
> the power_supply structs. This
> doesn't get set automatically based on their nodes, and it is currently
> up to each driver to define their
> own name.
> 
> For example, the sbs-battery driver uses the name "sbs-XXX" where XX is
> its dev_name. Other drivers
> use "%s-$%d" as i2c_device_id->name, + instance number. Then the only
> solution I see is to require a new
> property that defines the power-supply's name in the devicetree.
> 
> This solution with device_nodes, while not ideal, seems the be the best
> bet from what I see. Maybe
> someone else has a better idea.

For other resource types, this is handled by the (phandle -> whatever)
conversion process actually being a function call on the referenced
object, so that the driver code for it can look up the data in the
actual device/... object etc. See the various .of_xlate functions that
exist in the kernel.
