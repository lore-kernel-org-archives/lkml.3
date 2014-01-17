Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaAQQmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:42:54 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:52296 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248AbaAQQmv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:42:51 -0500
Subject: Re: [PATCH] of: fix of_update_property()
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CAL_JsqJuAv8=pBuzYO5ZGzroD1kq6gjmNsTjoVyXR=vcu+-pTA@mail.gmail.com>
Date: Fri, 17 Jan 2014 18:42:47 +0200
Cc: Xiubo Li <Li.Xiubo@freescale.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <07586E1B-FDB0-4D91-8467-15E9435FD9CD@antoniou-consulting.com>
References: <1389933996-19306-1-git-send-email-Li.Xiubo@freescale.com> <CAL_JsqJuAv8=pBuzYO5ZGzroD1kq6gjmNsTjoVyXR=vcu+-pTA@mail.gmail.com>
To: Rob Herring <robherring2@gmail.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,


On Jan 17, 2014, at 4:49 PM, Rob Herring wrote:

> On Thu, Jan 16, 2014 at 10:46 PM, Xiubo Li <Li.Xiubo@freescale.com> wrote:
>> The of_update_property() is intent to update a property in a node
> 
[ snip ]

>>                return of_add_property(np, newprop);
> 
> Isn't there also a race that if you do 2 updates for a non-existent
> property and both threads try to add the property, the first one will
> succeed and the 2nd will fail. The 2nd one needs to retry as well.
> 
> Also, couldn't the node itself be removed while trying to do the update?
> 
> There seem to be multiple problems with this code, but doing multiple
> simultaneous, conflicting updates seems like an unlikely case.
> 

There are multiple problems with this function.

First of all, the firing of the notifier at the beginning with OF_RECONFIG_UPDATE_PROPERTY
even though we have no idea if the property is found.

The locking is no good; the lock should be taken before the search by switching to using
__of_find_property. Threading is just not handled well at all at the moment. 
Retrying is just bogus.

The biggest problem is the semantics; IMHO we should just remove the option to create
a property if it doesn't exist. I don't think there are many callers that use update property
expecting to be created if it doesn't exist.

> Rob
> 
>> @@ -1593,7 +1594,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
>>        raw_spin_unlock_irqrestore(&devtree_lock, flags);
>> 
>>        if (!found)
>> -               return -ENODEV;
>> +               goto retry;
>> 
>> #ifdef CONFIG_PROC_DEVICETREE
>>        /* try to add to proc as well if it was initialized */
>> --
>> 1.8.4
>> 
>> 

Regards

-- Pantelis