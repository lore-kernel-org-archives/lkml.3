Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaFMPGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:06:49 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:47614 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaFMPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:06:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJ+f0CjwGnqTzXjMOAvbDOf0O3BZgcQwrzaWBy9Gwiw8A@mail.gmail.com>
References: <539A91E2.7000606@gmail.com> <CAL_JsqJ+f0CjwGnqTzXjMOAvbDOf0O3BZgcQwrzaWBy9Gwiw8A@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 13 Jun 2014 16:06:25 +0100
X-Google-Sender-Auth: v5O0MnFhZL2h0NAAdM50ZllkVAM
Message-ID: <CACxGe6sG+h7j9Npd-xR4-E13i=_p8OtbisgJv1PUzf981nGHUw@mail.gmail.com>
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

On Fri, Jun 13, 2014 at 2:52 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Jun 13, 2014 at 12:53 AM, Frank Rowand <frowand.list@gmail.com> wrote:
>> From: Frank Rowand <frank.rowand@sonymobile.com>
>>
>> Pantelis Antoniou reports that of_find_node_by_path() is borked because
>> of_allnodes is not guaranteed to contain the root of the tree after using
>> any of the dynamic update functions because some other nodes ends up as
>> of_allnodes.
>>
>> Fixes: c22e650e66b8 of: Make of_find_node_by_path() handle /aliases
>
> Is it not possible to do a fix in of_find_node_by_path instead? I just
> wonder if this could have any other unintended side-effects on
> of_attach_node's behavior.

Given that I'm going to replace the custom list with list_head which
makes this problem go away, I think this solution is fine.

Acked-by: Grant Likely <grant.likely@linaro.org>

g.

>
> Rob
>
>>
>> Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
>> ---
>>
>>
>> Pantelis,
>>
>> Can you test whether the problem you reported in irc?
>>
>> This patch has not been tested, not even compile tested.
>>
>>
>>  drivers/of/base.c |    8       6 +     2 -     0 !
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> Index: b/drivers/of/base.c
>> ===================================================================
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -1948,6 +1948,9 @@ int of_reconfig_notify(unsigned long act
>>
>>  /**
>>   * of_attach_node - Plug a device node into the tree and global list.
>> + *
>> + * Put the device node after of_allnodes in the global list so that
>> + * of_allnodes remains the root.
>>   */
>>  int of_attach_node(struct device_node *np)
>>  {
>> @@ -1958,11 +1961,12 @@ int of_attach_node(struct device_node *n
>>         if (rc)
>>                 return rc;
>>
>> +       BUG_ON(!of_allnodes);
>>         raw_spin_lock_irqsave(&devtree_lock, flags);
>>         np->sibling = np->parent->child;
>> -       np->allnext = of_allnodes;
>> +       np->allnext = of_allnodes->allnext;
>>         np->parent->child = np;
>> -       of_allnodes = np;
>> +       of_allnodes->allnext = np;
>>         of_node_clear_flag(np, OF_DETACHED);
>>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
>>
