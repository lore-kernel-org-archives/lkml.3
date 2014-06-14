Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaFNPA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:00:26 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43397 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbaFNPAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:00:22 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6sG+h7j9Npd-xR4-E13i=_p8OtbisgJv1PUzf981nGHUw@mail.gmail.com>
References: <539A91E2.7000606@gmail.com> <CAL_JsqJ+f0CjwGnqTzXjMOAvbDOf0O3BZgcQwrzaWBy9Gwiw8A@mail.gmail.com>
 <CACxGe6sG+h7j9Npd-xR4-E13i=_p8OtbisgJv1PUzf981nGHUw@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Sat, 14 Jun 2014 16:00:02 +0100
X-Google-Sender-Auth: RDDliUg6rxrKOJ9WRNdN4AhF6w0
Message-ID: <CACxGe6tv8H8yUYCs9N959T3KKDUDiDqJQ1LRfO5RJE3bxw5r5A@mail.gmail.com>
Subject: Re: [RFC PATCH] OF: fix of_find_node_by_path() assumption that
 of_allnodes is root
To: Rob Herring <robherring2@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 4:06 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Fri, Jun 13, 2014 at 2:52 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On Fri, Jun 13, 2014 at 12:53 AM, Frank Rowand <frowand.list@gmail.com> wrote:
>>> From: Frank Rowand <frank.rowand@sonymobile.com>
>>>
>>> Pantelis Antoniou reports that of_find_node_by_path() is borked because
>>> of_allnodes is not guaranteed to contain the root of the tree after using
>>> any of the dynamic update functions because some other nodes ends up as
>>> of_allnodes.
>>>
>>> Fixes: c22e650e66b8 of: Make of_find_node_by_path() handle /aliases
>>
>> Is it not possible to do a fix in of_find_node_by_path instead? I just
>> wonder if this could have any other unintended side-effects on
>> of_attach_node's behavior.
>
> Given that I'm going to replace the custom list with list_head which
> makes this problem go away, I think this solution is fine.
>
> Acked-by: Grant Likely <grant.likely@linaro.org>

That said, the following might be better because it would guarantee
that children always appear after parents...

>> Rob
>>
>>>
>>> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
>>> ---
>>>
>>>
>>> Pantelis,
>>>
>>> Can you test whether the problem you reported in irc?
>>>
>>> This patch has not been tested, not even compile tested.
>>>
>>>
>>>  drivers/of/base.c |    8       6 +     2 -     0 !
>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> Index: b/drivers/of/base.c
>>> ===================================================================
>>> --- a/drivers/of/base.c
>>> +++ b/drivers/of/base.c
>>> @@ -1948,6 +1948,9 @@ int of_reconfig_notify(unsigned long act
>>>
>>>  /**
>>>   * of_attach_node - Plug a device node into the tree and global list.
>>> + *
>>> + * Put the device node after of_allnodes in the global list so that
>>> + * of_allnodes remains the root.
>>>   */
>>>  int of_attach_node(struct device_node *np)
>>>  {
>>> @@ -1958,11 +1961,12 @@ int of_attach_node(struct device_node *n
>>>         if (rc)
>>>                 return rc;
>>>
>>> +       BUG_ON(!of_allnodes);
>>>         raw_spin_lock_irqsave(&devtree_lock, flags);
>>>         np->sibling = np->parent->child;
>>> -       np->allnext = of_allnodes;
>>> +       np->allnext = of_allnodes->allnext;

np->allnext = np->parent->allnext;
np->parent->allnext = np;

>>>         np->parent->child = np;
>>> -       of_allnodes = np;
>>> +       of_allnodes->allnext = np;
>>>         of_node_clear_flag(np, OF_DETACHED);
>>>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
>>>
