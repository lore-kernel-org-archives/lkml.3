Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbaKEUHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:07:39 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:55519 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaKEUHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:07:36 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 5/5] of: of_reconfig_get_state_change() of notifier
 helper.
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
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
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <1414528433-9650-6-git-send-email-pantelis.antoniou@konsulko.com>
References: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
	<1414528433-9650-6-git-send-email-pantelis.antoniou@konsulko.com>
Date: Wed, 05 Nov 2014 20:07:31 +0000
Message-Id: <20141105200731.C44B4C41C40@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 22:33:53 +0200
, Pantelis Antoniou <pantelis.antoniou@konsulko.com>
 wrote:
> Introduce of_reconfig_get_state_change() which allows an of notifier
> to query about device state changes.
> 
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Applied, thanks.

g.

> ---
>  drivers/of/dynamic.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of.h   |  1 +
>  2 files changed, 97 insertions(+)
> 
> diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
> index 9eb8528..303a59b 100644
> --- a/drivers/of/dynamic.c
> +++ b/drivers/of/dynamic.c
> @@ -85,6 +85,102 @@ int of_reconfig_notify(unsigned long action, void *p)
>  	return notifier_to_errno(rc);
>  }
>  
> +/*
> + * of_reconfig_get_state_change()	- Returns new state of device
> + * @action	- action of the of notifier
> + * @arg		- argument of the of notifier
> + *
> + * Returns the new state of a device based on the notifier used.
> + * Returns 0 on device going from enabled to disabled, 1 on device
> + * going from disabled to enabled and -1 on no change.
> + */
> +int of_reconfig_get_state_change(unsigned long action, void *arg)
> +{
> +	struct device_node *dn;
> +	struct property *prop, *old_prop;
> +	struct of_prop_reconfig *pr;
> +	int is_status, status_state, old_status_state, prev_state, new_state;
> +
> +	/* figure out if a device should be created or destroyed */
> +	dn = NULL;
> +	prop = old_prop = NULL;
> +	switch (action) {
> +	case OF_RECONFIG_ATTACH_NODE:
> +	case OF_RECONFIG_DETACH_NODE:
> +		dn = arg;
> +		prop = of_find_property(dn, "status", NULL);
> +		break;
> +	case OF_RECONFIG_ADD_PROPERTY:
> +	case OF_RECONFIG_REMOVE_PROPERTY:
> +		pr = arg;
> +		dn = pr->dn;
> +		prop = pr->prop;
> +		break;
> +	case OF_RECONFIG_UPDATE_PROPERTY:
> +		pr = arg;
> +		dn = pr->dn;
> +		prop = pr->prop;
> +		old_prop = pr->old_prop;
> +		break;
> +	default:
> +		return -1;	/* don't care */
> +	}
> +
> +	is_status = 0;
> +	status_state = -1;
> +	old_status_state = -1;
> +	prev_state = -1;
> +	new_state = -1;
> +
> +	if (prop && !strcmp(prop->name, "status")) {
> +		is_status = 1;
> +		status_state = !strcmp(prop->value, "okay") ||
> +			       !strcmp(prop->value, "ok");
> +		if (old_prop)
> +			old_status_state = !strcmp(old_prop->value, "okay") ||
> +					   !strcmp(old_prop->value, "ok");
> +	}
> +
> +	switch (action) {
> +	case OF_RECONFIG_ATTACH_NODE:
> +		prev_state = 0;
> +		/* -1 & 0 status either missing or okay */
> +		new_state = status_state != 0;
> +		break;
> +	case OF_RECONFIG_DETACH_NODE:
> +		/* -1 & 0 status either missing or okay */
> +		prev_state = status_state != 0;
> +		new_state = 0;
> +		break;
> +	case OF_RECONFIG_ADD_PROPERTY:
> +		if (is_status) {
> +			/* no status property -> enabled (legacy) */
> +			prev_state = 1;
> +			new_state = status_state;
> +		}
> +		break;
> +	case OF_RECONFIG_REMOVE_PROPERTY:
> +		if (is_status) {
> +			prev_state = status_state;
> +			/* no status property -> enabled (legacy) */
> +			new_state = 1;
> +		}
> +		break;
> +	case OF_RECONFIG_UPDATE_PROPERTY:
> +		if (is_status) {
> +			prev_state = old_status_state != 0;
> +			new_state = status_state != 0;
> +		}
> +		break;
> +	}
> +
> +	if (prev_state == new_state)
> +		return -1;
> +
> +	return new_state;
> +}
> +EXPORT_SYMBOL_GPL(of_reconfig_get_state_change);
> +
>  int of_property_notify(int action, struct device_node *np,
>  		       struct property *prop, struct property *oldprop)
>  {
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 71d25aa..9ff1ec5 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -328,6 +328,7 @@ struct of_prop_reconfig {
>  extern int of_reconfig_notifier_register(struct notifier_block *);
>  extern int of_reconfig_notifier_unregister(struct notifier_block *);
>  extern int of_reconfig_notify(unsigned long, void *);
> +extern int of_reconfig_get_state_change(unsigned long action, void *arg);
>  
>  extern int of_attach_node(struct device_node *);
>  extern int of_detach_node(struct device_node *);
> -- 
> 1.7.12
> 

