Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab3KNJvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 04:51:40 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:52199 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752614Ab3KNJvP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 04:51:15 -0500
Subject: Re: [PATCH 5/5] OF: Introduce utility helper functions
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131114014420.E871CC4054D@trevor.secretlab.ca>
Date: Thu, 14 Nov 2013 10:51:05 +0100
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
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
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F61B515B-7024-4C4A-8E78-CEF8E032DF59@antoniou-consulting.com>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-6-git-send-email-panto@antoniou-consulting.com> <20131111163743.D136CC42330@trevor.secretlab.ca> <89491720-464B-47EC-A888-9CDE29B035F5@antoniou-consulting.com> <20131113013459.D3886C40F49@trevor.secretlab.ca> <F88335D9-6515-4E48-A21F-25039F16754A@antoniou-consulting.com> <20131114014420.E871CC4054D@trevor.secretlab.ca>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 14, 2013, at 2:44 AM, Grant Likely wrote:

> On Wed, 13 Nov 2013 10:03:37 +0100, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> On Nov 13, 2013, at 2:34 AM, Grant Likely wrote:
>>> On Tue, 12 Nov 2013 11:39:08 +0100, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>>>>> On Tue,  5 Nov 2013 19:50:16 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>>>>>> +	} else {
>>>>>> +		pr_warn("%s: node %p cannot be freed; memory is gone\n",
>>>>>> +				__func__, node);
>>>>>> +	}
>>>>>> +}
>>>>> 
>>>>> All of the above is potentially dangerous. There is no way to determine
>>>>> if anything still holds a reference to a node. The proper way to handle
>>>>> removal of properties is to have a release method when the last
>>>>> of_node_put is called.
>>>>> 
>>>> 
>>>> This is safe, and expected to be called only on a dynamically created tree,
>>>> that's what all the checks against OF_DYNAMIC guard against.
>>>> 
>>>> It is not ever meant to be called on an arbitrary tree, created by unflattening
>>>> a blob.
>>> 
>>> I am talking about when being used on a dynamic tree. The problem is
>>> when a driver or other code holds a reference to a dynamic nodes, but
>>> doesn't release it correctly. The memory must not be freed until all of
>>> the references are relased. OF_DYNAMIC doesn't actually help in that
>>> case, and it is the reason for of_node_get()/of_node_put()
>>> 
>> 
>> I know, but even that is not enough. of_node_get()/of_node_put() handles the
>> case of references to the nodes, but not what happens with references to
>> properties. deadprops is mitigating the problem somewhat, but if we're going
>> to go to all the trouble of kobjectification let's do the props as well.
>> 
>> of_get_property could be modified to return a devm_kmalloced copy of the real
>> property and that would deal with most of the callers. Of course for
>> the small sized scalar data we can avoid the copy.
>> 
>> By using the devm_* interface we also avoid having to mess too much with the callers.
>> 
>> I.e. what about something like devm_of_get_property()?
> 
> Reference counting is already a horrible pain to keep correct. I don't
> see a better way to handle it in the dynamic case, so we're stuck with
> it, but I don't want to make it any harder. Adding ref counting to
> properties will make it harder than it already is to get the code right.
> I'm absolutely fine with a little bit of wasted memory in the form of
> deadprops when the alternative is so horrible. References at the node
> level is enough granularity.
> 
> I don't think kduping the property is the solution either. I strongly
> suspect that will be far more expensive than the deadprop solution.
> 

As long as we can live with deadprops all is fine. Perhaps a devm_of_get_property()
makes sense for new drivers though? What do you think? Perhaps copying to a
user supplied buffer as well?

>>>>>> +{
>>>>>> +	struct device_node *node;
>>>>>> +
>>>>>> +	node = kzalloc(sizeof(*node), flags);
>>>>>> +	if (node == NULL)
>>>>>> +		return NULL;
>>>>>> +
>>>>>> +	node->name = kstrdup(name, flags);
>>>>>> +	if (node->name == NULL)
>>>>>> +		goto err_return;
>>>>>> +
>>>>>> +	node->type = kstrdup(type, flags);
>>>>>> +	if (node->type == NULL)
>>>>>> +		goto err_return;
>>>>>> +
>>>>>> +	node->full_name = kstrdup(full_name, flags);
>>>>>> +	if (node->type == NULL)
>>>>>> +		goto err_return;
>>>>> 
>>>>> Again, who do you expect the user of this function to be? If it is part
>>>>> of unflattening an overlay tree, is there a reason that the passed in
>>>>> names cannot be used directly instead of kmallocing them?
>>>>> 
>>>> 
>>>> I want to be able to get rid of the blob eventually; I don't need to keep
>>>> dragging it around.
>>> 
>>> Why? It really doesn't hurt and it means data does not need to be
>>> copied.
>> 
>> Copying data lead to less problems that having to drag that blob around. 
>> That's just preference, so not a big issue.
> 
> Can you elaborate? What problems do you foresee being created by keeping
> the blob?

It's a kind of drag. That means you get handed a device_node pointer you are not
able to free it without having the blob along with the container/accessor of it.
I.e. For the normal case where the blob comes from a request_firmware() call
You have to keep the firmware structure around.

Depending on what other method you're going to use tends to make the code a little
bit messier. 

> 
> g.

Regards

-- Pantelis

