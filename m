Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964851AbaCTOoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:44:46 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10546 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933849AbaCTOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:44:43 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-52-532afed91a29
Message-id: <532AFED3.5030103@samsung.com>
Date: Thu, 20 Mar 2014 15:44:35 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Josh Wu <josh.wu@atmel.com>
Cc: g.liakhovetski@gmx.de, m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] ov2640: add support for async device registration
References: <1394791952-12941-1-git-send-email-josh.wu@atmel.com>
 <532371F4.9050509@gmail.com> <53296094.3060209@atmel.com>
In-reply-to: <53296094.3060209@atmel.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/xa7o3/2kFG7Tv5LV4v3Eek8Wuxt+s
	Fpd3zWGz6NmwldXi4jp5B1aPBb+2snh8+Bjn0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBm7
	F1xlLJjJVbFk12XGBsZJHF2MnBwSAiYSm99sYoWwxSQu3FvP1sXIxSEksJRRYs7D74wQzidG
	iYfLn7OBVPEKaEns+HEVzGYRUJX4eHkHWDebgKFE79E+RhBbVCBCYu7EzVD1ghI/Jt9jAbFF
	BOQlZl84BWYzC+RIvG1rZAexhQX8JH7+uwhWLyRQK/F19l+wGk4BTYm9U5YwQdTrSOxvncYG
	YctLbF7zlnkCo8AsJCtmISmbhaRsASPzKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQIP6y
	g3HxMatDjAIcjEo8vCv2aAYLsSaWFVfmHmKU4GBWEuG1e64VLMSbklhZlVqUH19UmpNafIiR
	iYNTqoHRxPBBftIUzidz+KarWy3t2ldxmFPn0wPLDpvzPLI9vXsdS9ITe6Z6i7UtTFkZddxF
	YE7buc+M/sGfNJnX+hsVz8hLPKDOvo+tuGXHgw2hzOXf2/ytXdVmnbjQq+o9PTlTbEFPjrL/
	pQ8XGDsOXNY4avzy2NLz6k4VIUeE5PcWz1jz1lGwoEGJpTgj0VCLuag4EQC2ruvFQAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

On 19/03/14 10:17, Josh Wu wrote:
> On 3/15/2014 5:17 AM, Sylwester Nawrocki wrote:
>> > On 03/14/2014 11:12 AM, Josh Wu wrote:
>>> >> +    clk = v4l2_clk_get(&client->dev, "mclk");
>>> >> +    if (IS_ERR(clk))
>>> >> +        return -EPROBE_DEFER;
>> >
>> > You should instead make it:
>> >
>> >         return PTR_ERR(clk);
>> >
>> > But you will need this patch for that to work:
>> > http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/clk/clk.c?id=a34cd4666f3da84228a82f70c94b8d9b692034ea 
>> >
>> >
>> > With this patch there is no need to overwrite any returned error
>> > value with EPROBE_DEFER.
>
> Thanks for the information. I will use this in v2 version.

Oops, I missed somehow that it's v4l2_clk_get(), rather than
clk_get(). So it seems it will not work when you return PTR_ERR(clk),
since v4l2_clk_get() returns -ENODEV when clock is not found.
I think we should modify v4l2_clk_get() so it returns EPROBE_DEFER
rather than ENODEV on error. I anticipate v4l2_clk_get() might be
using clk_get() internally in future, and the v4l2 clk look up
will be used as a fallback only. So sensor drivers should just
do something like:

 clk = v4l2_clk_get(...);
 if (IS_ERR(clk))
	return PTR_ERR(clk);

--
Regards,
Sylwester
