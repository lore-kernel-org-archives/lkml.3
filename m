Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaKFMdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:33:39 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33948 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaKFMdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:33:37 -0500
Subject: Re: [PATCH 3/5] of: Only call notifiers when node is attached
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <20141105213925.3790BC41C40@trevor.secretlab.ca>
Date: Thu, 6 Nov 2014 14:33:29 +0200
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
Message-Id: <EE6F3801-A76A-4D95-B841-A7935FA7FCF9@konsulko.com>
References: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com> <1414528433-9650-4-git-send-email-pantelis.antoniou@konsulko.com> <20141105213925.3790BC41C40@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

> On Nov 5, 2014, at 23:39 , Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> On Tue, 28 Oct 2014 22:33:51 +0200
> , Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> wrote:
>> Make sure we call notifier only when the node is attached.
>> When a detatched tree is being constructed we do not want the
>> notifiers to fire at all.
> 
> The description does not match what the patch does. The patch moves the
> test into of_{add,remove,update}_property() and out of
> of_property_notify() itself. That leaves one other caller of
> of_property_notify(); __of_changeset_entry_notify(). The effect of this
> patch is that applying a changeset will cause notifiers to be fired for
> each property modified in a changeset. The comment says nothing about
> the change in behaviour and it sounds like it is a bug fix when it
> doesn't actually change the behaviour at all for the
> of_{add,remove,update}_property() paths.
> 
> This needs a better changelog. It needs to describe what the effects of
> the patch are and why the change is being made. When someone is
> bisecting a problem and they land on this change, the changelog needs to
> give them a good idea about what is going on and why.
> 

Valid points. In fact I performed some tests and with this reverted things
still work.

The rationale behind this is for when nodes/properties are removed in the overlay,
but since we don’t support this for now, we never hit the case where it was
needed.

Please remove from the patch series, I’ll revisit this when I add the removal
functionality.

> g.
> 

Regards

— Pantelis

>> 
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> ---
>> drivers/of/base.c    | 9 ++++++---
>> drivers/of/dynamic.c | 5 +----
>> 2 files changed, 7 insertions(+), 7 deletions(-)
>> 
>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index 2305dc0..a79d4ee 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -1695,7 +1695,8 @@ int of_add_property(struct device_node *np, struct property *prop)
>> 
>> 	mutex_unlock(&of_mutex);
>> 
>> -	if (!rc)
>> +	/* only call notifiers if the node is attached and no error occurred */
>> +	if (of_node_is_attached(np) && !rc)
>> 		of_property_notify(OF_RECONFIG_ADD_PROPERTY, np, prop, NULL);
>> 
>> 	return rc;
>> @@ -1754,7 +1755,8 @@ int of_remove_property(struct device_node *np, struct property *prop)
>> 
>> 	mutex_unlock(&of_mutex);
>> 
>> -	if (!rc)
>> +	/* only call notifiers if the node is attached and no error occurred */
>> +	if (of_node_is_attached(np) && !rc)
>> 		of_property_notify(OF_RECONFIG_REMOVE_PROPERTY, np, prop, NULL);
>> 
>> 	return rc;
>> @@ -1830,7 +1832,8 @@ int of_update_property(struct device_node *np, struct property *newprop)
>> 
>> 	mutex_unlock(&of_mutex);
>> 
>> -	if (!rc)
>> +	/* only call notifiers if the node is attached and no error occurred */
>> +	if (of_node_is_attached(np) && !rc)
>> 		of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop, oldprop);
>> 
>> 	return rc;
>> diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
>> index f297891..8e8b614 100644
>> --- a/drivers/of/dynamic.c
>> +++ b/drivers/of/dynamic.c
>> @@ -90,10 +90,6 @@ int of_property_notify(int action, struct device_node *np,
>> {
>> 	struct of_prop_reconfig pr;
>> 
>> -	/* only call notifiers if the node is attached */
>> -	if (!of_node_is_attached(np))
>> -		return 0;
>> -
>> 	pr.dn = np;
>> 	pr.prop = prop;
>> 	pr.old_prop = oldprop;
>> @@ -138,6 +134,7 @@ int of_attach_node(struct device_node *np)
>> 	__of_attach_node_sysfs(np);
>> 	mutex_unlock(&of_mutex);
>> 
>> +	/* node is guaranteed to be attached at this point */
>> 	of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, np);
>> 
>> 	return 0;
>> -- 
>> 1.7.12
>> 
> 

