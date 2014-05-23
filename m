Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbaEWBOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 21:14:42 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43927 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaEWBOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 21:14:40 -0400
Message-ID: <537EA0FE.9000809@gmail.com>
Date: Thu, 22 May 2014 18:14:38 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH 2/3] of: Make of_find_node_by_path() handle /aliases
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org> <1399993115-21552-3-git-send-email-grant.likely@linaro.org> <53757D25.1060005@gmail.com> <20140516105444.C1DB7C42277@trevor.secretlab.ca> <20140518092730.109AAC40B8A@trevor.secretlab.ca> <537C1252.3090900@gmail.com> <20140522011600.C0014C40B13@trevor.secretlab.ca>
In-Reply-To: <20140522011600.C0014C40B13@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2014 6:16 PM, Grant Likely wrote:
> On Tue, 20 May 2014 19:41:22 -0700, Frank Rowand <frowand.list@gmail.com> wrote:
>> On 5/18/2014 2:27 AM, Grant Likely wrote:
>>> On Fri, 16 May 2014 11:54:44 +0100, Grant Likely <grant.likely@linaro.org> wrote:
>>>> On Thu, 15 May 2014 19:51:17 -0700, Frank Rowand <frowand.list@gmail.com> wrote:
>>>>> On 5/13/2014 7:58 AM, Grant Likely wrote:
>>>>>> Make of_find_node_by_path() handle aliases as prefixes. To make this
>>>>>> work the name search is refactored to search by path component instead
>>>>>> of by full string. This should be a more efficient search, and it makes
>>>>>> it possible to start a search at a subnode of a tree.
>>>>>>
>>>>>> Signed-off-by: David Daney <david.daney@cavium.com>
>>>>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>>>>> [grant.likely: Rework to not require allocating at runtime]
>>>>>> Acked-by: Rob Herring <robh@kernel.org>
>>>>>> Signed-off-by: Grant Likely <grant.likely@linaro.org>
>>>>>> ---
>>>>>>  drivers/of/base.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>>>>>>  1 file changed, 56 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>>>>>> index 6e240698353b..60089b9a3014 100644
>>>>>> --- a/drivers/of/base.c
>>>>>> +++ b/drivers/of/base.c
>>>>>> @@ -771,9 +771,38 @@ struct device_node *of_get_child_by_name(const struct device_node *node,
>>>>>>  }
>>>>>>  EXPORT_SYMBOL(of_get_child_by_name);
>>>>>>  
>>>>>> +static struct device_node *__of_find_node_by_path(struct device_node *parent,
>>>>>> +						const char *path)
>>>>>> +{
>>>>>> +	struct device_node *child;
>>>>>> +	int len = strchrnul(path, '/') - path;
>>>>>> +
>>>>>> +	if (!len)
>>>>>> +		return parent;
>>>>>
>>>>> (!len) is true if the the final character of the path passed into of_find_node_by_path()
>>>>> was "/".  Strictly speaking, ->full_name will never end with "/", so the return value
>>>>> should be NULL, indicating that the match fails.
>>>>
>>>> Ah, good catch. I should add a test case for that.
>>>
>>> In my testing this looks okay. The while loop that calls into
>>> __of_find_node_by_path() looks like this:
>>>
>>> 	while (np && *path == '/') {
>>> 		path++; /* Increment past '/' delimiter */
>>> 		np = __of_find_node_by_path(np, path);
>>> 		path = strchrnul(path, '/');
>>> 	}
>>>
>>> If the path ends with a '/', then the loop will go around one more time.
>>> The pointer will be incremented to point at the null character and len
>>> will be null because strchrnul() will point at the last item.
>>
>> Yes, that was my point.  The old version of of_find_node_by_path() would not
>> find a match if the path ended with a "/" (unless the full path was "/").
>> This patch series changes the behavior to be a match.
>>
>> I will reply to this email with an additional patch that restores the
>> original behavior.
>>
>> If you move the additional test cases you provide below and the test cases
>> in patch 3 to the beginning of the series, you can see the before and after
>> behavior of adding patch 1 and patch 2.
> 
> Ah, I see. That raises the question about what the behaviour /should/
> be. Off the top of my head, matching against a trailing '/' seems to be
> okay. Are there situations that you see or can think of where matching
> would be the wrong thing to do?

I have not thought of a case where matching against a trailing '/' would
hurt anything.  It just seemed better to be consistent in naming.

