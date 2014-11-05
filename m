Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaKEUI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:08:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56778 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaKEUIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:08:25 -0500
Subject: Re: [PATCH 4/5] of: Add old prop argument on OF_RECONFIG_UPDATE_PROPERTY
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20141105200129.B4438C41C40@trevor.secretlab.ca>
Date: Wed, 5 Nov 2014 22:08:18 +0200
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <E0B33C12-EBD6-465C-813C-7FD8553A3CB8@konsulko.com>
References: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com> <1414528433-9650-5-git-send-email-pantelis.antoniou@konsulko.com> <20141105200129.B4438C41C40@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

> On Nov 5, 2014, at 22:01 , Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> On Tue, 28 Oct 2014 22:33:52 +0200
> , Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> wrote:
>> The notifier now includes the old_prop argument when updating
>> properties, propagate this API to changeset internals while
>> also retaining the old behaviour of retrieving the old_property
>> when NULL is passed.
>> 
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> 
> I'm still fuzzy on the need for this patch. Is this just an optimization
> so that the property doesn't get looked up twice? Or is there a reason
> when the oldprop really needs to be passed in explicitly?
> 

In the case of overlay’s applying a property change the old property has
been already retrieved. Passing it as an argument saves us a traversal of the
property list.

On the original series were removal was supported, the old property was required
since you can’t find the old property anymore on the node (it was on another list). 

When we go back to revisit the removal case, that API is useful.

> g.
> 

Regards

— Pantelis

>> ---
>> drivers/of/dynamic.c  | 18 ++++++++++++++----
>> drivers/of/selftest.c |  2 +-
>> include/linux/of.h    | 20 +++++++++++++-------
>> 3 files changed, 28 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
>> index 8e8b614..9eb8528 100644
>> --- a/drivers/of/dynamic.c
>> +++ b/drivers/of/dynamic.c
>> @@ -627,6 +627,7 @@ int of_changeset_revert(struct of_changeset *ocs)
>>  * @action:	action to perform
>>  * @np:		Pointer to device node
>>  * @prop:	Pointer to property
>> + * @old_prop:	Pointer to old property (if updating)
>>  *
>>  * On action being one of:
>>  * + OF_RECONFIG_ATTACH_NODE
>> @@ -637,10 +638,21 @@ int of_changeset_revert(struct of_changeset *ocs)
>>  * Returns 0 on success, a negative error value in case of an error.
>>  */
>> int of_changeset_action(struct of_changeset *ocs, unsigned long action,
>> -		struct device_node *np, struct property *prop)
>> +		struct device_node *np, struct property *prop,
>> +		struct property *oldprop)
>> {
>> 	struct of_changeset_entry *ce;
>> 
>> +	/* in case someone passed NULL as old_prop, find it */
>> +	if (action == OF_RECONFIG_UPDATE_PROPERTY && prop && !oldprop) {
>> +		oldprop = of_find_property(np, prop->name, NULL);
>> +		if (!oldprop) {
>> +			pr_err("%s: Failed to find old_prop for \"%s/%s\"\n",
>> +					__func__, np->full_name, prop->name);
>> +			return -EINVAL;
>> +		}
>> +	}
>> +
>> 	ce = kzalloc(sizeof(*ce), GFP_KERNEL);
>> 	if (!ce) {
>> 		pr_err("%s: Failed to allocate\n", __func__);
>> @@ -650,9 +662,7 @@ int of_changeset_action(struct of_changeset *ocs, unsigned long action,
>> 	ce->action = action;
>> 	ce->np = of_node_get(np);
>> 	ce->prop = prop;
>> -
>> -	if (action == OF_RECONFIG_UPDATE_PROPERTY && prop)
>> -		ce->old_prop = of_find_property(np, prop->name, NULL);
>> +	ce->old_prop = oldprop;
>> 
>> 	/* add it to the list */
>> 	list_add_tail(&ce->node, &ocs->entries);
>> diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
>> index 7800127..16102fd 100644
>> --- a/drivers/of/selftest.c
>> +++ b/drivers/of/selftest.c
>> @@ -427,7 +427,7 @@ static void __init of_selftest_changeset(void)
>> 	selftest(!of_changeset_detach_node(&chgset, nremove), "fail remove node\n");
>> 	selftest(!of_changeset_attach_node(&chgset, n21), "fail attach n21\n");
>> 	selftest(!of_changeset_add_property(&chgset, parent, ppadd), "fail add prop\n");
>> -	selftest(!of_changeset_update_property(&chgset, parent, ppupdate), "fail update prop\n");
>> +	selftest(!of_changeset_update_property(&chgset, parent, ppupdate, NULL), "fail update prop\n");
>> 	selftest(!of_changeset_remove_property(&chgset, parent, ppremove), "fail remove prop\n");
>> 	mutex_lock(&of_mutex);
>> 	selftest(!of_changeset_apply(&chgset), "apply failed\n");
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index 6545e7a..71d25aa 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -830,36 +830,42 @@ extern int of_changeset_apply(struct of_changeset *ocs);
>> extern int of_changeset_revert(struct of_changeset *ocs);
>> extern int of_changeset_action(struct of_changeset *ocs,
>> 		unsigned long action, struct device_node *np,
>> -		struct property *prop);
>> +		struct property *prop, struct property *old_prop);
>> 
>> static inline int of_changeset_attach_node(struct of_changeset *ocs,
>> 		struct device_node *np)
>> {
>> -	return of_changeset_action(ocs, OF_RECONFIG_ATTACH_NODE, np, NULL);
>> +	return of_changeset_action(ocs, OF_RECONFIG_ATTACH_NODE, np, NULL,
>> +			NULL);
>> }
>> 
>> static inline int of_changeset_detach_node(struct of_changeset *ocs,
>> 		struct device_node *np)
>> {
>> -	return of_changeset_action(ocs, OF_RECONFIG_DETACH_NODE, np, NULL);
>> +	return of_changeset_action(ocs, OF_RECONFIG_DETACH_NODE, np, NULL,
>> +			NULL);
>> }
>> 
>> static inline int of_changeset_add_property(struct of_changeset *ocs,
>> 		struct device_node *np, struct property *prop)
>> {
>> -	return of_changeset_action(ocs, OF_RECONFIG_ADD_PROPERTY, np, prop);
>> +	return of_changeset_action(ocs, OF_RECONFIG_ADD_PROPERTY, np, prop,
>> +			NULL);
>> }
>> 
>> static inline int of_changeset_remove_property(struct of_changeset *ocs,
>> 		struct device_node *np, struct property *prop)
>> {
>> -	return of_changeset_action(ocs, OF_RECONFIG_REMOVE_PROPERTY, np, prop);
>> +	return of_changeset_action(ocs, OF_RECONFIG_REMOVE_PROPERTY, np, prop,
>> +			NULL);
>> }
>> 
>> static inline int of_changeset_update_property(struct of_changeset *ocs,
>> -		struct device_node *np, struct property *prop)
>> +		struct device_node *np, struct property *prop,
>> +		struct property *old_prop)
>> {
>> -	return of_changeset_action(ocs, OF_RECONFIG_UPDATE_PROPERTY, np, prop);
>> +	return of_changeset_action(ocs, OF_RECONFIG_UPDATE_PROPERTY, np, prop,
>> +			old_prop);
>> }
>> #endif
>> 
>> -- 
>> 1.7.12
>> 
> 

